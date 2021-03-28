# plpgsql

[TOC]





## useful variables

```
select now(), current_timestamp, current_timestamp(0), current_timestamp(0)::TIMESTAMP(0);
select current_date;
select current_time;
```



## timestamp

```
select timestamp 'epoch';
select timestamp 'infinity';
select timestamp '-infinity';
select timestamp 'now';
select timestamp 'today';
select timestamp 'tomorrow';
select timestamp 'yesterday';
```



## to_timestamp()

```
select to_timestamp('21 Dec 2012', 'DD Mon YYYY');
select to_timestamp(1356048000);
```



## date

```
select date(now());
select date 'epoch';
select date 'infinity';
select date '-infinity';
select date 'now';
select date 'today';
select date 'tomorrow';
select date 'yesterday';
```



## to_date()

```
select to_date('21 Dec 2012', 'DD Mon YYYY');
```



## time

```
select time 'now';
select time 'allballs';
```



## interval

```
select timestamp 'epoch' + interval '1 seconds';
select timestamp 'now' + interval '-10 minutes';
select timestamp 'yesterday' + interval '24 hours';
select date 'epoch' + interval '1 days';
select date 'now' + interval '1 weeks';
select date 'today' + interval '1 months';
select date 'tomorrow' + interval '1 years';
```



## age(timestamp, timestamp)

```
select age(now(), now() - (1 || 'years')::interval);
```



## date_trunc()

```
select date_trunc('hour', now());
```



## date_part()

```
select date_part('hour', now());
```



## extract(filed from source)

```
select extract(year from now());
select extract(month from now());
select extract(day from now());
select extract(doy from now());
select extract(hour from now());
select extract(minute from now());
select extract(second from now());
select extract(second from now())::int;
select extract(epoch from now());
select extract(epoch from now())::int;
```



## how to convert epoch to timestamp

```
select
timestamp with time zone 'epoch',
extract(epoch from timestamp '2012-12-21 00:00:00')::int,
extract(epoch from timestamp '2012-12-21 00:00:00')::int * interval '1 second',
timestamp with time zone 'epoch' + 1356048000::int * interval '1 second';
```



## to_char()

```
select to_char(now(), 'YYYY-MM-DD HH:MI:SS');
```



## how to remove all functions whose owner is cassini

```
peer_user=cassini

sql="select 'drop function if exists ' || ns.nspname || '.' || proname || '(' || oidvectortypes(proargtypes) || ');'
from pg_proc
         inner join pg_namespace ns on pg_proc.pronamespace = ns.OID
where ns.nspname = 'public';"

sudo su - $peer_user -c "psql -f <(psql -c \"$sql\" | grep 'drop function')"
```

