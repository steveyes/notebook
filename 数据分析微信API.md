# 数据分析微信 API

[TOC]

# request



## URL 全局常量

| 字段       | 值                    |
| ---------- | --------------------- |
| **scheme** | https                 |
| **host**   | philips.wenyugame.com |
| **port**   | 80                    |
| **path**   | 由以下各API提供       |



## URL 全局变量

| 字段          | 解释   |
| ------------- | ------ |
| **page**      | 页号   |
| **page_size** | 页大小 |



## URL 拼接规则

`schema://host[:port#]/path/.../[?query-string]`



## URL 拼接 examples

> 请更换以下命令中 sessionid 和 csrftoken 再运行测试命令

### example 1

例如要这样的数据

- **method:** get
- **数据源:** stats_aedapppagehistory 应用页面历史数据表
- **页号:** 1 
- **页大小:**  100
- **开始日期:**  2021年2月14日
- **结束日期:** 2021年2月14日
- **page_url:** page_2021

用 curl 命令可以这样写

```
curl --request GET \
  --url 'https://philips.wenyugame.com/stats_aed/apppagehistory?page=1&page_size=100&day_gte=2021-02-14&day_lte=2021-02-14&page_url=page_10' \
  --header 'Cookie: sessionid=5tqkmc8aqszwtq2w1wuzlnwchy2ie20h' \
  --cookie 'sessionid=zxhznfn7v0vg8t6ajf72y1q0sel1gyk2; csrftoken=l0cojuLs9bRUuOzOS8EGfNKE1n70X35T'
```



## method CRUD 对应关系

| action         | 请求方式    | 详细                            |
| -------------- | ----------- | ------------------------------- |
| create         | post        | 创建一条数据                    |
| list           | get         | 获取多条数据                    |
| retrieve       | get /pk/    | 获取单条数据 需带上pk           |
| update         | put /pk/    | 修改单条数据的全部字段 需带上pk |
| partial_update | patch /pk/  | 修改单条数据的某个字段 需带上pk |
| destroy        | delete /pk/ | 删除单条数据 需带上pk           |



## request body 全局常量

```
USER_TYPE = (
    # 用户类型
    (1, 'anonymous'),  # 匿名用户
    (2, 'activation'),  # 验证码用户
    (3, 'individual'),  # 个人用户
    (4, 'hospital'),  # 医院用户
)

USER_FRESHNESS = (
    (1, 'new'),  # 新用户
    (2, 'old'),  # 老用户
)

PAGE_TYPE = (
    (1, 'admin'),
    (2, 'sfy'),
    (3, 'ssd'),
    (4, 'aed'),
)

PRODUCT_TYPE = PAGE_TYPE
```



## 类型推荐写法

| type     | example               |
| -------- | --------------------- |
| int      | 10                    |
| str      | "10.1.1.1"            |
| datetime | "2021-02-13T20:17:39" |



# API 



## visit

> 用户访问信息

action:

| method | path                |
| ------ | ------------------- |
| POST   | stats/wx/visit      |
| PUT    | stats/wx/visit/{pk} |

body:

| key            | type     | required | comment      |
| -------------- | -------- | -------- | ------------ |
| user_id        | int      | true     | 用户id       |
| user_ip        | str      | false    | IP地址       |
| user_type      | str      | false    | 用户类型     |
| user_freshness | str      | false    | 新老用户     |
| url_origin     | str      | false    | 入口页面URL  |
| url_current    | str      | false    | 当前页面URL  |
| page_type      | str      | false    | 页面类型     |
| product_id     | int      | false    | 产品id       |
| start_at       | datetime | false    | 页面访问时间 |
| end_at         | datetime | false    | 页面离开时间 |
| opened_at      | datetime | false    | 会话发起时间 |
| closed_at      | datetime | false    | 会话断开时间 |

POST single example

```

```

POST many example

```

```

PUT example

```

```





## cart

> 购物车信息

action:

| method | path                |
| ------ | ------------------- |
| POST   | stats_aed/cart      |
| PUT    | stats_aed/cart/{pk} |
| DELETE | stats_aed/cart/{pk} |

body:

| key        | type     | required | comment      |
| ---------- | -------- | -------- | ------------ |
| product_id | int      | true     | 产品id       |
| amount     | int      | true     | 产品数量     |
| user_id    | int      | true     | 用户id       |
| carted_at  | datetime | true     | 加购物车时间 |

GET example

```

```

POST example

```

```

PUT example

```

```




