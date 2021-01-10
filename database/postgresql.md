# postgresql notes

[toc]

## table

get a table size

```
select pg_size_pretty(pg_relation_size('table_name'));
```

get 20 tables size

```
SELECT table_schema || '.' || table_name AS table_full_name, pg_size_pretty(pg_total_relation_size('"' || table_schema || '"."' || table_name || '"')) AS size
FROM information_schema.tables
ORDER BY pg_total_relation_size('"' || table_schema || '"."' || table_name || '"') DESC limit 20
```

get data size and index size of tables

```
SELECT
    table_name,
    pg_size_pretty(table_size) AS table_size,
    pg_size_pretty(indexes_size) AS indexes_size,
    pg_size_pretty(total_size) AS total_size
FROM (
    SELECT
        table_name,
        pg_table_size(table_name) AS table_size,
        pg_indexes_size(table_name) AS indexes_size,
        pg_total_relation_size(table_name) AS total_size
    FROM (
        SELECT ('"' || table_schema || '"."' || table_name || '"') AS table_name
        FROM information_schema.tables
    ) AS all_tables
    ORDER BY total_size DESC
) AS pretty_sizes
```



## login using psql

```bash
# if the user is the peer user(whose username both same in os or db) and username is # same with database name, the -d par can be omitted.
sudo -u pgadmin psql -d cassini

# login to database using user postgres 
sudo -u postgres psql -d cassini
```



## psql shell

### load psql shell non-interactively

```bash
[set|export] PGPASSWORD=${DBUSERPASSWORD} psql [-U${DBUSER}] [-d${DATABASE}]
# or
sudo -u postgres psql -d ${DATABASE}
```

### exec psql comm in bash shell

```bash
[set|export] PGPASSWORD=${DBUSERPASSWORD} psql [-U${DBUSER}] [-d${DATABASE}] -c "${sqlstmt}"

sudo -u postgres psql -d ${DATABASE} -c "${sqlstmt}"
```

### load into db

```bash
[set|export] PGPASSWORD=${DBUSERPASSWORD} psql -U${DBUSER} < ${DDL_TAB}

sudo -u postgres psql < ${DDL_TAB}
```



## database administration # admin priv required

### query location of configuration files

```sql
select name, setting from pg_settings where category = 'File Locations';
```

### postgresql.conf: current settings

```
select name, context, unit, setting, boot_val, reset_val
from pg_settings
where name in ('listen_addresses', 'max_connections', 'shared_buffers', 'effective_cache_size', 'work_mem', 'maintenance_work_mem')
order by context, name;

         name         |  context   | unit |    setting    | boot_val  |   reset_val   
----------------------+------------+------+---------------+-----------+---------------
 listen_addresses     | postmaster |      | 192.168.6.102 | localhost | 192.168.6.102
 max_connections      | postmaster |      | 100           | 100       | 100
 shared_buffers       | postmaster | 8kB  | 16384         | 1024      | 16384
 effective_cache_size | user       | 8kB  | 524288        | 524288    | 524288
 maintenance_work_mem | user       | kB   | 65536         | 65536     | 65536
 work_mem             | user       | kB   | 4096          | 4096      | 4096
(6 rows)

```

- If **context** is set to postmaster, it means changing this parameter requires a restart of the postgresql service. If context is set to user, changes require at least a reload. Furthermore, these settings can be overridden at the database, user, session, of function levels.
- **unit** tells you the unit of measurement that the settings is reported in. This is very important for memory settings since, as you can see, some are reported in 8 kB and some in KB. In postgresql.conf, usually you explicitly set these to a unit of measurement you want to record in, such as 128MB. You can also get a more human-readable display of a setting by running the statement: **SHOW effective_cache_size**; which give you 128MB, or **SHOW maintenance_work_mem**; which gives you 16MB for this particular case. If you want to see everything in friendly units, use **SHOW ALL**.
- **setting** is the currently running setting in effect ; **boot_val** is the default setting; **reset_val** is the new value if you were to restart or reload. You want to make sure that after any change you make to postgresql.conf the setting and **reset_val** are the same. If they are not, it means you still need to do a reload.

### postgresql.conf: File

- **listen_addresses** tells PostgreSQL which IPs to listen on. This usually defaults to localhost, but many people change it to *, meaning all available IPs.
- **port** defaults to 5432. Again, this is often set in a different file in some distributions, which overrides this settings. For instance, if you are on a Red Hat or CentOS, you can override the setting by settting a **PGPORT** value in /etc/sysconfig/pgsql/your_service_name_here.
- **max_connections** is the maximum number of concurrent connnections allowed.
- **shared_buffers** defines the amount of memory you have shared across all connections to store recently accessed pages. This settings has the most effect on query performance. You want this to be fairly high, probably at least 25% of your onboard memory.
- **effective_cache_size** is an estimate of how much memory you expect to be available in the OS and PostgreSQL buffer caches. It has no affect on an actual allocation, but it used only by the PostgreSQL query planner to figure out whether plans under consideration would fit in RAM or not. If it's set to low, indexes may be underutilized. If you have a dedicated PostgreSQL server, then setting this to half or more of your on-board memory would be a good start.
- **work_mem** controls the maximum amount of memory allocated for each operations such as sorting, hash join, and others. The optimal setting really depends on the kind of work you do, how much memory you have, and if your server is a dedicated server. If you have many users connecting, but fairly simple queries, you want this relatively low. If you do lots of intensive processing, like building a data warehouse, but few users, you want this to be high. How high you set this also depends on how much motherboard memory you have. A good article to read on the pros and cons of setting work_mem is *Understanding postgresq.conf work_mem*.
- **maintenance_work_mem** is the total memory allocated for housekeeping activities like vacuuming(getting rid of dead records). This shouldn't be set higher than about 1GB.

### pg_hba.conf: File

```
# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     peer
# IPv4 local connections:
host    all             all             127.0.0.1/32            md5
# IPv6 local connections:
host    all             all             ::1/128                 md5
# Allow replication connections from localhost, by a user with the
# replication privilege.
#local   replication     postgres                                peer
#host    replication     postgres        127.0.0.1/32            md5
#host    replication     postgres        ::1/128                 md5
host	cassini		pgadmin		192.168.6.0/24		md5
```

- Authentication method. ident, trust, md, password are the most common and always available. Others such as gss, radius, ldap, and pam, may not always be in stalled.
- IPv4 syntax for defining network range. The first part in this case 192.168.6.0 is the network address. The /24 is the bit mask. In this example, we are allowing anyone in our subnet of 192.168.6.0 to connect as long as they provide a valid md5 encrypted password.
- Ipv6 syntax for defining localhost. This only applies to servers with IPv6 support and may cause the configuration file to not load if you have it and don't hava IPv6.
- Users must connect throught SSL. In out example, we allow anyone to connect to our server as long as the connect using SSL and have a valid md5-encrypted password.
- Defines a range of IPs allowed to replicate with this server. This is new in PostgreSQL 9.0+. In this example, we have the line remarked out.

### Reload the Configuration Files

```
sudo systemctl reload postgresql;
sudo -u postgres psql -c 'select pg_reload_conf();'
```

### creating user account

```
# User with login rights that can create database object
create role leo login password 'lion!king' createdb valid until 'infinity';

# Superuser
create role regina login password 'queen!penultimate' superuser valid until '2222-02-02';
```

### creating group roles

```
create role jungle inherit;
grant jungle to leo;
```

### create database

```
create database mydb;
```

### create a database using a template

```
create database mydb template template0;
```

### make a database a template

```
update pg_database set datistemplate=true where datname='mydb';
```

### Organizing Your Database Using Schemas

Schemas are a logical way of partitioning your database into mini-containers. You can divide schemas by functionality, by users, or by any other attribute you like. Aside from logical partitioning, the provide an easy way for doing out rights. One common practice is to install all contribs and extensions, covered in "Extensions and Contribs" on page 18 into a separate schema and give rights to use for users of a database.

To create a schema called contrib in a database, we connect to the database and run this SQL:

```
\c mydb;
create schema contrib;
```

The default **search_path** defined in postgresql.conf is **"$user"**, **public**. This means that if there is a schema with the same name as the logged in user, then all non-schema qualified objects will first check the schema with the same name as user and then the public schema. You can override this behavior at the user level or the database level. For example, if we wanted all objects in contrib to be accessible without schema qualification, wo would change our database as follows:

```
alter database mydb set search_path="$user", public, contrib;
```

### Permissions

all users of our database to have **EXECUTE** and **SELECT** access to any tables and functions 

we will create in the contrib schema.

```

grant usage on schema contrib to public;
alter default privileges in schema contrib grant select, references, trigger on tables to public;
alter default privileges in schema contrib grant select, update on sequences to public;
alter default privileges in schema contrib grant execute on functions to public;
alter defualt privileges in schema contrib grant usage on types to public;
```

If you already have your schema set with all the tables and functions, you can retroactively set permissions on each object separately or do this for all existing tables, functions, and sequences with a **GRANT .. ALL .. IN SCHEM**.

```
grant usage on schema contrib to public;
grant select, references, trigger on all tables in schema contrib to public;
grant select, update on all sequences in schema contrib to public;
grant execute on all functions in schema contrib to public;
```

### Extensions and Contribs

To see which extensions you have already installed

```
select *
from pg_available_extensions
where comment like '%string%' or installed_version is not null
order by name;
```

To get details about a particular installed extension

```
\dx+ plpgsql
```

Or run this query

```
select pg_catalog.pg_describe_object(d.classid, d.objid, 0) as description
from pg_catalog.pg_depend as D
	inner join pg_extension as E on D.refobjid = E.oid
where D.refclassid = 'pg_catalog.pg_extension'::pg_catalog.regclass
	and deptype = 'e' and E.extname = 'plpgsql';
```

install a new extension

```
psql -d mydb
create extension fuzzystrmatch;
```

install new extension in a schema called contrib

```
psql -d mydb
drop extension fuzzystrmatch;
create extension fuzzystrmatch schema contrib;
```

### backup using pg_dump

```
# creates a compressed, single database backup:
pg_dump -h localhost -p 5432 -U <user> -F c -b -v -f mydb.backup mydb

# creates a plain-text single database backup, including Creates database
pg_dump -h localhost -p 5432 -U <user> -C -F p -b -v -f mydb.backup mydb

# creates a compressed backup of tables with a name that starts with payments in any schema
pg_dump -h localhost -p 5432 -U <user> -F c -b -v -t *.payments* -f payment_tables.backup mydb

# creates a compressed backup of all objects in hr and payroll schemas
pg_dump -h localhost -p 5432 -U <user> -F c -b -v -n hr -n payrool -f hr_payroll_schemas.backup mydb

# creates a compressed backup of all objects in all schemas, excluding public schemas
pg_dump -h localhost -p 5432 -U <user> -F c -b -v -N public -f all_schema_except_public.backup mydb

# craete a plain-text SQL backup of select tables, useful for porting to lower versions of PostgreSQL or other database system
pg_dump -h localhost -p 5432 -U <user> -F p --column-inserts -f select_tables.backup mydb

# separate gzipped file for each table and a file that has all the structures listed
pg_dump -h localhost -p 5432 -U <user> -F d -f /somepath/a_directory mydb
```

### backup using pg_dumpall

```
# to backup roles and tablespaces
pg_dumpall -h localhost -U <user> --port=5432 -f myglobals.sql --globals-only

# back up roles and not tables spaces
pg_dumpall -h localhost -U <user> --port=5432 -f myglobals.sql --roles-only
```

### backup using psql

```
# restores a full backup and ignore errors
psql -U <user> -f myglobals.sql

# restores and stops on first error
psql -U <user> --set ON_ERROR_STOP=on -f myglobals.sql

# restore a partial backup to a specific database
psql -U <user> -d mydb -f select_objects.sql

```

### backup using pg_restore

```
create database mydb;
pg_restore --dbname=mydb --jobs=4 --verbose mydb.backup

# if the database is the same as the one you backed up, you can create the database in ones steop with the following
pg_restore --dbname=postgres --create --jobs=4 --verbose mydb.backup

# restore just table structure without the actual data using --section
pg_restore --dbname=mydb2 --section=pre-data --job=4 mydb.backup
```

### terminate connections

```
# list currently active connections and the process id
select * from pg_stat_activity;

# cancel all active queries on a connection, bu doesn't terminate the connection
select pg_cancel_backend(pid);

# kill user Regina's all connections
select pg_terminate(backend(pid) from pg_stat_activity where usename = 'regina'
```

### create tablespace

```
create tablespace secondary location '/usr/data/pgdata91_secondary'
```

### moving objects between tablespaces

```
# moving all objects in the database to our secondary tablespace
alter database mydb set tablespace secondary;

# move just a table 
alter table mytable set tablespace secondary;
```

