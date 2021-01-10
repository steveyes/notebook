# elasticsearch6



warning: **only applicable for elasticsearhc 6.x**



## 倒排索引
Elasticsearch 使用一种称为 倒排索引 的结构，它适用于快速的全文搜索。一个倒排索引由文档中所有不重复词的列表构成，对于其中每个词，有一个包含它的文档列表。



## GET ALL

```
GET _search
{
  "query": {
    "match_all": {}
  }
}
```



## index (database) CRUD

### PUT (create for single node)

```
PUT /home

PUT /home
{
  "settings": {
    "index": {
      "number_of_shards": 3,
      "number_of_replicas": 0
    }
  }
}
```

PUT (create for 2 nodes, one for 3 shared, one for 3 replicas)

```
PUT /home
{
  "settings": {
    "index": {
      "number_of_shards": 3,
      "number_of_replicas": 1
    }
  }
}
```



### GET  (retrieve)

```
GET /_all/_settings

GET /lib/_settings
```

### DELETE

```
DELETE /home
```



## document (record) CRUD

### create

PUT 

````
PUT /home/user/1
{
  "first_name": "Jane",
  "last_name": "Smith",
  "age": 32,
  "about": "I like to collect rock albums",
  "interests": [
    "music"
  ]
}

PUT /home/user/2
{
  "first_name": "Amanda",
  "last_name": "Andersen",
  "age": 26,
  "about": "I like to go writing",
  "interests": [
    "music",
    "writing"
  ]
}

PUT /home/user/3
{
  "first_name": "Katarina",
  "last_name": "Proctor",
  "age": 36,
  "about": "I like to go football",
  "interests": [
    "music",
    "football"
  ]
}

PUT /home/user/4
{
  "first_name": "Jarvis",
  "last_name": "Armstrong",
  "age": 36,
  "about": "I like to study mathematics",
  "interests": [
    "music",
    "mathematics"
  ]
}
````

POST

```
POST /home/user/
{
  "first_name": "Douglas",
  "last_name": "Fir",
  "age": 23,
  "about": "I like to build cabinets",
  "interests": [
    "forestry"
  ]
}
```

### retrieve

```
GET /home/user/1
GET /home/user/cd6phHIBtlECQHWBHOs7?_source=age,interests
```

### update

put

```
PUT /home/user/1
{
  "first_name": "Jane",
  "last_name": "Smith",
  "age": 33,
  "about": "I don not like to collect rock albums",
  "interests": [
    "music", 
    "reading"
  ]
}
```

post

```
POST /home/user/1/_update
{
  "doc": {
    "age": 31
  }
}
```

### delete

```
DELETE /home/user/1
```



## document CRUD in bulk

### curl

```
curl 'http://192.168.1.202:9200/_mget' -d '{
"docs"：[
   {
    "_index": "home",
    "_type": "user",
    "_id": 1
   },
   {
     "_index": "home",
     "_type": "user",
     "_id": 2
   }
  ]
}'
```

Kibana.Dev Tools

```
GET /_mget
{
  "docs": [
    {
      "_index": "home",
      "_type": "user",
      "_id": 1
    },
    {
      "_index": "home",
      "_type": "user",
      "_id": 2
    },
    {
      "_index": "home",
      "_type": "user",
      "_id": 3
    }
  ]
}

# projection by using _source
GET /_mget
{
  "docs": [
    {
      "_index": "home",
      "_type": "user",
      "_id": 1,
      "_source": "interests"
    },
    {
      "_index": "home",
      "_type": "user",
      "_id": 2,
      "_source": [
        "age",
        "interests"
      ]
    }
  ]
}

# GET different type or documents with the same index
GET /home/user/_mget
{
  "docs": [
    {
      "_id": 1
    },
    {
      "_type": "user",
      "_id": 2
    }
  ]
}

# GET different documents with the same index
GET /home/user/_mget
{
  "ids": [
    "1",
    "2",
    "3"
  ]
}
```



## document CRUD in bulk using BULK API

### syntax

- {action:{path}}\n
- {requstbody}\n
- action: { action: { metadata } }
  - create: create document 
  - update: update document
  - index: create or update document
  - delete: delete document
- metadata：\_index, \_type, \_id

### POST (create)

```
POST /lib/books/_bulk
{"index":{"_id":1}}
{"title":"Java","price":55}
{"index":{"_id":2}}
{"title":"js","price":45}
{"index":{"_id":3}}
{"title":"C++","price":65}
{"index":{"_id":4}}
{"title":"Python","price":50}
```

### GET (retrieve)

```
GET /lib/books/_mget
{"ids": ["1","2","3","4"]}
```

### POST (update)

```
POST /lib/books/_bulk
{"update": {"_index":"lib","_type":"books","_id":3}}
{"doc":{"price":70}}
```

### POST (multiple actions)

```
POST /lib/books/_bulk
{"create":{"_index":"tt","_type":"ttt","_id":"100"}}
{"name":"lisi"}
{"index":{"_index":"tt","_type":"ttt"}}
{"name":"wangwu"}
{"update":{"_index":"lib","_type":"books","_id":"4"}}
{"doc":{"price":58}}
{"delete":{"_index":"lib","_type":"books","_id":1}}
```



## version control

### scope

[1, 2^63 - 1]

### _version=1

> after running this, the _version will be 1

```
PUT /home/user/4
{
  "first_name":"Jane",
  "last_name":"Lucy",
  "age": 20,
  "about": "I like to collect rock albums",
  "interests": ["music"]
}
```

### _version++

> after running this, the _version will be 2

```
PUT /home/user/4
{
  "first_name":"Jane",
  "last_name":"Lucy",
  "age": 21,
  "about": "I like to collect rock albums",
  "interests": ["music"]
}
```

### conflict

> version: 3 not equal to _version 2, will raise version_conflict_engine_exception

```
PUT /home/user/4?version=3
{
  "first_name":"Jane",
  "last_name":"Lucy",
  "age": 22,
  "about": "I like to collect rock albums",
  "interests": ["music"]
}
```

### consistent

> after running this, the _version will be 3

```
PUT /home/user/4?version=2
{
  "first_name":"Jane",
  "last_name":"Lucy",
  "age": 23,
  "about": "I like to collect rock albums",
  "interests": ["music"]
}
```

### extern version

> version type is extern version(here is 3), must be greater then _version(here is 3), otherwise this will failed
>
> change 3 to 5, after running this, the _version will be 5

```
PUT /home/user/4?version=5&version_type=external
{
  "first_name":"Jane",
  "last_name":"Lucy",
  "age": 24,
  "about": "I like to collect rock albums",
  "interests": ["music"]
}
```



## data types

ref to this https://www.elastic.co/guide/en/elasticsearch/reference/current/sql-data-types.html



## mapping

create type mapping automatically

```
PUT /forum/article/1 
{ 
  "post_date": "2018-05-10", 
  "title": "Java", 
  "content": "java is the best language", 
  "author_id": 119
}

PUT /forum/article/2
{ 
  "post_date": "2018-05-12", 
  "title": "html", 
  "content": "I like html", 
  "author_id": 120
}

PUT /forum/article/3
{ 
  "post_date": "2018-05-16", 
  "title": "es", 
  "content": "Es is distributed document store", 
  "author_id": 110
}
```

search

```
GET /forum/article/_search?q=2018-05
GET /forum/article/_search?q=post_date:2018-05

GET /forum/article/_search?q=2018-05-10
GET /forum/article/_search?q=post_date:2018-05-10

GET /forum/article/_search?q=html
GET /forum/article/_search?q=content:html

GET /forum/article/_search?q=java
GET /forum/article/_search?q=content:java
```

get the mapping information

```
GET /forum/article/_mapping
```





## English query

create test index

```
PUT /lib3
{
    "settings":{
    "number_of_shards" : 3,
    "number_of_replicas" : 0
    },
     "mappings":{
      "user":{
        "properties":{
            "name": {"type":"text"},
            "address": {"type":"text"},
            "age": {"type":"integer"},
            "interests": {"type":"text"},
            "birthday": {"type":"date"}
        }
      }
     }
}
```

create test documents

```
PUT /lib3/user/1
{
    "name": "zhaoliu",
    "address": "hei long jiang sheng tie ling shi",
    "age" : 50,
    "birthday": "1970-12-12",
    "interests": "xin huan hejiu, duanlian, lvyou"
}

PUT /lib3/user/2
{
    "name": "zhaoming",
    "address": "bei jing hai dian qu qing he zhen",
    "age" : 20,
    "birthday": "1998-10-12",
    "interests": "xi huan hejiu, duanlian, changge"
}

PUT /lib3/user/3
{
    "name": "lisi",
    "address": "bei jing hai dian qu qing he zhen",
    "age" : 23,
    "birthday": "1998-10-12",
    "interests": "xi huan hejiu, duanlian, changge"
}

PUT /lib3/user/5
{
    "name": "zhangsan",
    "address": "bei jing chao yang qu",
    "age" : 29,
    "birthday": "1988-10-12",
    "interests": "xihuan tingyinyue, changge, tiaowu"
}

PUT /lib3/user/6
{
    "name": "lvyou",
    "address": "bei jing chao yang qu",
    "age" : 29,
    "birthday": "1988-10-12",
    "interests": "xihuan tingyinyue, changge, tiaowu"
}
```

### simple query 

```
GET /lib3/user/_search?q=name:lisi
GET /lib3/user/_search?q=interests:changge&sort=age:desc
```

### term and terms

```
GET /lib3/user/_search 
{
    "query": {
        "term": {"name": "zhaoliu"}
    }
}

GET /lib3/user/_search 
{
    "query": {
        "terms": {
            "interests": ["hejiu", "changge"]
        }
    }
}

```

### from and size 

- from : similar to `offset ` in postgresql
- size :  similar to `limit` in postgresql

```
GET /lib3/user/_search 
{
    "from": 0,
    "size": 2,
    "query": {
        "terms": {
            "interests": ["hejiu", "changge"]
        }
    }
}
```

### return contains `version`

```
GET /lib3/user/_search 
{
    "version": true,
    "from": 0,
    "size": 2,
    "query": {
        "terms": {
            "interests": ["hejiu", "changge"]
        }
    }
}
```

### match

`match` is conscious of Lexical analysis (or Tokenize) and leverage it, yet term[s] is not 

```
GET /lib3/user/_search
{
    "query":{
        "match":{
            "name": "zhaoliu zhaoming"
        }
    }
}

GET /lib3/user/_search
{
    "query":{
        "match":{
            "interests": "duanlian, changge"
        }
    }
}
```

### match_all

```
GET /lib3/user/_search
{
  "query": {
    "match_all": {}
  }
}
```

### multi_match

```
GET /lib3/user/_search
{
    "query":{
        "multi_match": {
            "query": "lvyou",
            "fields": ["interests","name"]
         }
    }
}
```

### match_phrase

the order of these words must be same

```
GET lib3/user/_search
{
  "query":{  
      "match_phrase":{  
         "interests": "duanlian changge"
      }
   }
}

# order mismatch will return none
GET lib3/user/_search
{
  "query":{  
      "match_phrase":{  
         "interests": "changge duanlian"
      }
   }
}
```

### projection using `_source`

```
GET /lib3/user/_search
{
    "query": {
        "match_all": {}
    },
    "_source": ["name","addr*"]
}

GET /lib3/user/_search
{
    "query": {
        "match_all": {}
    },
    "_source": {
          "includes": ["name","addr*"],
          "excludes": ["age","birthday"]
    }
}
```

### sort

```
GET /lib3/user/_search
{
    "query": {
        "match_all": {}
    },
    "sort": [
        {
           "age": {
               "order":"asc"
           }
        }
    ]        
}
```

### match_phrase_prefix

```
GET /lib3/user/_search
{
  "query": {
    "match_phrase_prefix": {
        "name": {
            "query": "zhao"
        }
    }
  }
}
```

### range

```
GET /lib3/user/_search
{
    "query": {
        "range": {
            "birthday": {
                "from": "1990-10-10",
                "to": "2018-05-01"
            }
        }
    }
}
```

```
GET /lib3/user/_search
{
    "query": {
        "range": {
            "age": {
                "from": 20,
                "to": 25,
                "include_lower": true,
                "include_upper": false
            }
        }
    }
}
```

### wildcard

```
GET /lib3/user/_search
{
    "query": {
        "wildcard": {
             "name": "zhao*"
        }
    }
}
```

```
GET /lib3/user/_search
{
    "query": {
        "wildcard": {
             "name": "li?i"
        }
    }
}
```

### fuzzy

```
GET /lib3/user/_search
{
    "query": {
        "fuzzy": {
             "name": "zhouliu"
        }
    }
}
```

```
GET /lib3/user/_search
{
    "query": {
        "fuzzy": {
             "interests": {
                 "value": "chagge"
             }
        }
    }
}
```

### highlight

```
GET /lib3/user/_search
{
    "query":{
        "match":{
            "interests": "changge"
        }
    },
    "highlight": {
        "fields": {
             "interests": {}
        }
    }
}
```



## 中文查询

create test index

```
PUT /lib4 
{
  "settings": {
    "number_of_shards": 3,
    "number_of_replicas": 0
  },
  "mappings": {
    "user": {
      "properties": {
        "name": {
          "type": "text",
          "analyzer": "ik_max_word"
        },
        "address": {
          "type": "text",
          "analyzer": "ik_max_word"
        },
        "age": {
          "type": "integer"
        },
        "interests": {
          "type": "text",
          "analyzer": "ik_max_word"
        },
        "birthday": {
          "type": "date"
        }
      }
    }
  }
}
```

create test documents

```
PUT /lib4/user/1
{
  "name": "赵六",
  "address": "黑龙江省铁岭",
  "age": 50,
  "birthday": "1970-12-12",
  "interests": "喜欢喝酒，锻炼，说相声"
}

PUT /lib4/user/2
{
  "name": "赵明",
  "address": "北京海淀区青河",
  "age": 20,
  "birthday": "1998-12-12",
  "interests": "喜欢喝酒，锻炼，唱歌"
}

PUT /lib4/user/3
{
  "name": "lisi",
  "address": "北京海淀区青河",
  "age": 23,
  "birthday": "1998-12-12",
  "interests": "喜欢喝酒，锻炼，唱歌"
}

PUT /lib4/user/4
{
  "name": "王五",
  "address": "北京海淀区青河",
  "age": 26,
  "birthday": "1995-10-12",
  "interests": "喜欢编程，听音乐，旅游"
}

PUT /lib4/user/5
{
  "name": "张三",
  "address": "北京海淀区青河",
  "age": 29,
  "birthday": "1988-10-12",
  "interests": "喜欢摄影，听音乐，跳舞"
}
```

### query

```
GET /lib4/user/_search?q=name:lisi
```

### term and terms

```
GET /lib4/user/_search/
{
  "query": {
    "term": { "name" : "赵" }
  }
}

GET /lib4/user/_search/
{
  "from": 0,
  "size": 2,
  "version": true,
  "query": {
    "terms": { 
      "interests" : ["喝酒", "唱歌"]
    }
  }
}
```

### match

`match` is conscious of Lexical analysis (or Tokenize) and leverage it, yet term[s] is not 

```
GET /lib4/user/_search/
{
  "query": {
    "match": { "name" : "赵六" }
  }
}

GET /lib4/user/_search/
{
  "query": {
    "match": { "age" : 20 }
  }
}
```

### match_all

```
GET /lib4/user/_search/
{
  "query": {
    "match_all": { }
  }
}
```

### multi_match

```
GET /lib4/user/_search/
{
  "query": {
    "multi_match": {
      "query": "唱歌",
      "fields": ["interests", "name"]
    }
  }
}
```

match_phrase

```
GET /lib4/user/_search/
{
  "query": {
    "match_phrase": {
      "interests": "锻炼 说相声"
    }
  }
}

# order mismatch will return none
GET /lib4/user/_search/
{
  "query": {
    "match_phrase": {
      "interests": "说相声 锻炼"
    }
  }
}
```

### projection using `_source`

```
GET /lib4/user/_search/
{
  "_source": ["address", "name"],
  "query": {
    "match": {
      "interests": "唱歌"
    }
  }
}

GET /lib4/user/_search/
{
  "_source": {
    "includes": ["address", "name", "age"],
    "excludes": ["birthday"]
  },  
  "query": {
    "match": {
      "interests": "唱歌"
    }
  }
}
```

### sort

```
GET /lib4/user/_search/
{
  "query": {
    "match_all": { }
  },
  "sort": [
    {
      "age": {
        "order": "asc"
      }
    }
  ]
}
```

### match_phrase_prefix

```
GET /lib4/user/_search/
{
  "query": {
    "match_phrase_prefix": {
      "name": {
        "query": "赵"
      }
    }
  }
}
```

### range

```
GET /lib4/user/_search/
{
  "query": {
    "range": {
      "birthday": {
        "from": "1990-10-10",
        "to": "2018-05-01"
      }
    }
  }
}

GET /lib4/user/_search/
{
  "query": {
    "range": {
      "age": {
        "from": 20,
        "to": 25,
        "include_lower": true,
        "include_upper": false
      }
    }
  }
}
```

### wildcard

```
GET /lib4/user/_search/
{
  "query": {
    "wildcard": {
      "name": "赵*"
    }
  }
}

GET /lib4/user/_search/
{
  "query": {
    "wildcard": {
      "name": "li?i"
    }
  }
}
```

### fuzzy

```
GET /lib4/user/_search/
{
  "query": {
    "fuzzy": {
      "name": "赵"
    }
  }
}

GET /lib4/user/_search/
{
  "query": {
    "fuzzy": {
      "interests": "喝酒"
    }
  }
}
```



## filter

### create test index and documents

````
POST /lib5/items/_bulk
{"index":{"_id":1}}
{"price":40,"itemID":"ID100123"}
{"index":{"_id":2}}
{"price":50,"itemID":"ID100124"}
{"index":{"_id":3}}
{"price":25,"itemID":"ID100124"}
{"index":{"_id":4}}
{"price":30,"itemID":"ID100125"}
{"index":{"_id":5}}
{"price":null,"itemID":"ID100127"}
````

### filter

```
GET /lib5/items/_search
{
  "query": {
    "bool": {
      "filter": [{
        "term": {
          "price": 40
        }
      }]
    }
  }
}


GET /lib5/items/_search
{
  "post_filter": {
    "term": {"price": 40 }
  }
}
```

### terms

```
GET /lib5/items/_search
{
  "query": {
    "bool": {
      "filter": [{
        "terms": { "price": [25,40] }
      }]
    }
  }
}

GET /lib4/items/_search
{
  "post_filter": {
    "terms": {
      "price": [25,40]
    }
  }
}
```

### auto mapping

```
GET /lib5/items/_search
{
  "post_filter": {
    "term": {
      "itemID": "ID100123"
    }
  }
}
```

this query will return nothing because of auto mapping (create a index without setting mapping manually), to get the `type` of `itemID` by running this

```
GET /lib5/_mapping
```

and the `type` is `text`,  `text` will Lexical analysis (or Tokenize) the content and make it case-lower.

how to address this issue, 

> using match instead which will leverage Lexical analysis (or Tokenize)

```
GET /lib5/items/_search
{
  "post_filter": {
    "match": {
      "itemID": "id100123"
    }
  }
}
```

### bool

```
GET /lib5/items/_search
{
  "post_filter": {
    "bool": {
      "should": [
        {
          "term": {
            "price": 25
          }
        },
        {
          "match": {
            "itemID": "ID100123"
          }
        }
      ],
      "must_not": {
        "term": {
          "price": 30
        }
      }
    }
  }
}
```

```
GET /lib5/items/_search
{
  "post_filter": {
    "bool": {
      "should": [
        {
          "match": {
            "itemID": "ID100124"
          }
        },
        {
          "bool": {
            "must": [
              {
                "match": {
                  "itemID": "ID100123"
                }
              },
              {
                "term": {
                  "price": 40
                }
              }
            ]
          }
        }
      ]
    }
  }
}
```

Comparison operation

```
GET /lib5/items/_search
{
  "post_filter": {
    "range": {
      "price": {
        "gt": 25,
        "lte": 50
      }
    }
  }
}
```

exclude NULL

```
GET /lib5/items/_search
{
  "query": {
    "bool": {
      "filter": {
        "exists": {
          "field": "price"
        }
      }
    }
  }
}

GET /lib5/items/_search
{
  "query": {
    "constant_score": {
      "filter": {
        "exists": {
          "field": "price"
        }
      }
    }
  }
}
```



## aggregation

### sum

```
GET /lib5/items/_search
{
  "size": 0,
  "aggs": {
    "price_of_sum": {
      "sum": {
        "field": "price"
      }
    }
  }
}
```

### min

```
GET /lib5/items/_search
{
  "size": 0,
  "aggs": {
    "price_of_min": {
      "min": {
        "field": "price"
      }
    }
  }
}
```

### max

```
GET /lib5/items/_search
{
  "size": 0,
  "aggs": {
    "price_of_max": {
      "max": {
        "field": "price"
      }
    }
  }
}
```

### avg

```
GET /lib5/items/_search
{
  "size": 0,
  "aggs": {
    "price_of_avg": {
      "avg": {
        "field": "price"
      }
    }
  }
}
```

### cardinality

```
GET /lib4/items/_search
{
  "size":0,
  "aggs": {
     "price_of_cardi": {
         "cardinality": {
           "field": "price"
         }
     }
  }
}
```

### terms (group by)

```
GET /lib5/items/_search
{
  "size":0,
  "aggs": {
     "price_group_by": {
         "terms": {
           "field": "price"
         }
     }
  }
}

GET /lib3/user/_search
{
  "query": {
    "match": {
      "interests": "changge"
    }
  },
  "size": 0,
  "aggs": {
    "age_group_by": {
      "terms": {
        "field": "age",
        "order": {
          "avg_of_age": "desc"
        }
      },
      "aggs": {
        "avg_of_age": {
          "avg": {
            "field": "age"
          }
        }
      }
    }
  }
}
```



## compound query

### bool

### constant_score



## partial update using post using groovy

test data

```
PUT /home/user/3
{
  "first_name":"Alice",
  "last_name":"Lucy",
  "age": 29,
  "about": "I like to collect rock albums",
  "interests": ["music"]
}

PUT /home/user/4
{
  "first_name":"Jane",
  "last_name":"Lucy",
  "age": 20,
  "about": "I like to collect rock albums",
  "interests": ["music"]
}
```

### update age

```
POST /home/user/4/_update
{
  "script": "ctx._source.age+=1"
}
```

### update name

```
POST /home/user/4/_update
{
  "script": "ctx._source.last_name+='hehe'"
}
```

### append interests

```
POST /home/user/4/_update
{
  "script": {
    "source": "ctx._source.interests.add(params.tag)",
    "params": {
      "tag": "picture"
    }
  }
}
```

### remove interest

```
POST /home/user/4/_update
{
  "script": {
    "source": "ctx._source.interests.remove(ctx._source.interests.indexOf(params.tag))",
    "params": {
      "tag": "picture"
    }
  }
}
```

### remove document

```
POST /home/user/3/_update
{
  "script": {
    "source": "ctx.op=ctx._source.age==params.count?'delete':'nono'",
    "params": {
      "count": 29
    }
  }
}
```

### upsert

```
POST home/user/4/_update 
{
  "script": "ctx._source.age += 1",
  "upsert": {
    "first_name": "Jane",
    "last_name": "Lucy",
    "age": 20,
    "about": "I like to collect rock albums",
    "interests": ["music"]
  }
}
```



## multilple index, multiple type

```
GET _search

GET /home/_search

GET /lib,lib3/_search

GET /*3,*4/_search

GET /home/user/_search

GET /lib,lib4/user,items/_search

GET /_all/_search

GET /_all/user,items/_search
```



## copy to





## text and keyword

`"type": "text"` is for Tokenize, and `"type": "keyword"`, `"fielddata": true` is for sort

```
PUT /home
{
  "settings": {
    "number_of_shards": 3,
    "number_of_replicas": 0
  },
  "mappings": {
    "user": {
      "properties": {
        "name": {
          "type": "text"
        },
        "address": {
          "type": "text"
        },
        "age": {
          "type": "integer"
        },
        "birthday": {
          "type": "date"
        },
        "interests": {
          "type": "text",
          "fields": {
            "raw": {
              "type": "keyword"
            }
          },
          "fielddata": true
        }
      }
    }
  }
}
```

```
GET /lib3/user/_search
{
  "query": {
    "match_all": {}
  },
  "sort": [
    {
      "interests.raw": {
        "order": "asc"
      }
    }
  ]
}
```












## ref

https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html



