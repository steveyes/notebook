# 数据分析前端 API

[TOC]





# API参考



URL全局常量、URL全局变量、URL拼接规则、URL 拼接 examples等请参考

https://www.teambition.com/project/600157953020806848d4f811/app/5eba5fba6a92214d420a3219/workspaces/6001615c411fae004660db07/docs/6031d1914cc583000117b46f





# 应用分析指标说明



| 指标名称 | 英文名称            | 中文名              | 计算方式                                  |
| -------- | ------------------- | ------------------- | ----------------------------------------- |
| pv       | Page View           | 访问次数            | 每个页面被打开1次记为1个pv                |
| uv       | Unique Visitor      | 访问人数            | 当天同一访客访问N次只计1个uv              |
| vv       | Visit View          | 打开次数            | 每次浏览完并关闭所有页面记1个vv           |
| uip      | Unique IP           | 独立IP数            | 当天同一IP访问N次只计1个uip               |
| aot      | Average Online Time | 平均在线时长,单位秒 | 按天为维度，所有页面人均访问时长和/页面数 |



**VV与UV的区别**：VV是指所有访客一天内在整个网站的流量次数，UV是指多少个访客（电脑）访问过你的网站。



| 指标                       | VV       | UV   |
| -------------------------- | -------- | ---- |
| 针对主体                   | 浏览行为 | 用户 |
| 同一用户的多次浏览是否去重 | 否       | 是   |





# 应用分析



## **realtime 实时数据**



> 实时数据
>
> 统计今日0点至当前的数据

action:

| method | path               |
| ------ | ------------------ |
| GET    | stats/app/realtime |

body:

| key       | type | required | comment        |
| --------- | ---- | -------- | -------------- |
| page_type | str  |          | 页面类型       |
| pv        | int  |          | 日访问次数     |
| uv        | int  |          | 日访问人数     |
| vv        | int  |          | 日打开次数     |
| uip       | int  |          | 日独立IP数     |
| aot       | int  |          | 日平均在线时长 |



## **hourly 时段数据**



> 今日数据
>
> 按小时时段统计
>
> ihour: 0-23, 0为0:00-0:59, 23为23:00-23:59



action:

| method | path             |
| ------ | ---------------- |
| GET    | stats/app/hourly |

body:

| key       | type | required | comment          |
| --------- | ---- | -------- | ---------------- |
| page_type | str  |          | 页面类型         |
| ihour     | time |          | 时间             |
| hpv       | int  |          | 小时访问次数     |
| huv       | int  |          | 小时访问人数     |
| hvv       | int  |          | 小时打开次数     |
| huip      | int  |          | 小时独立IP数     |
| haot      | int  |          | 小时平均在线时长 |



## **history 历史数据**



> 当天的实时数据
>
> 非当天的静态数据

action:

| method | path              |
| ------ | ----------------- |
| GET    | stats/app/history |

query-string

| key      | coment       |
| -------- | ------------ |
| day__gte | 日期大于等于 |
| day__lte | 日期小于等于 |

body:

| key       | type      | required | comment      |
| --------- | --------- | -------- | ------------ |
| page_type | str       |          | 页面类型     |
| day       | timestamp |          | 日期         |
| pv        | int       |          | 访问次数     |
| uv        | int       |          | 访问人数     |
| vv        | int       |          | 打开次数     |
| uip       | int       |          | 独立IP数     |
| aot       | int       |          | 平均在线时长 |



## **page 页面分析**

> 当天的实时数据
>
> 非当天的静态数据

action:

| method | path           |
| ------ | -------------- |
| GET    | stats/app/page |

query-string

| key      | coment       |
| -------- | ------------ |
| day__gte | 日期大于等于 |
| day__lte | 日期小于等于 |
| page_url |              |

body:

| key       | type      | required | comment      |
| --------- | --------- | -------- | ------------ |
| day       | timestamp |          | 日期         |
| page_url  | text      |          | 页面url      |
| page_type | str       |          | 页面类型     |
| pv        | int       |          | 访问次数     |
| uv        | int       |          | 访问人数     |
| vv        | int       |          | 打开次数     |
| uip       | int       |          | 独立IP数     |
| aot       | int       |          | 平均在线时长 |





# 用户分析

## **track 实时用户轨迹**



> 实时刷新间隔 1分钟

action:

| method | path             |
| ------ | ---------------- |
| GET    | stats/user/track |

query-string

| key           | coment           |
| ------------- | ---------------- |
| url_origin    | 入口页面url      |
| duration__gte | 访问时长大于等于 |
| duration__lte | 访问时长小于等于 |

body:

| key            | type     | required | comment      |
| -------------- | -------- | -------- | ------------ |
| page_type      | str      |          | 页面类型     |
| user_id        | int2     |          | 用户id       |
| user_type      | int2     |          | 用户类型     |
| user_freshness | str      |          | 新老用户     |
| opened_at      | datetime |          | 会话发起时间 |
| url_origin     | text     |          | 入口页面URL  |
| duration       | int      |          | 访问时长     |
| n_pages        | int      |          | 访问页数     |



## **freshness 新老用户表**

> 按天统计

action:

| method | path                 |
| ------ | -------------------- |
| GET    | stats/user/freshness |

query-string

| key      | coment       |
| -------- | ------------ |
| day__gte | 日期大于等于 |
| day__lte | 日期小于等于 |

body:

| key       | type  | required | comment    |
| --------- | ----- | -------- | ---------- |
| day       | date  |          | 日期       |
| old_users | int   |          | 新老用户   |
| new_users | int   |          | 新用户数   |
| rate_old  | float |          | 老用户占比 |
| rate_new  | float |          | 新用户占比 |





## **retention 用户留存率表**

> 按天统计

action:

| method | path                 |
| ------ | -------------------- |
| GET    | stats/user/retention |

query-string

| key      | coment       |
| -------- | ------------ |
| day__gte | 日期大于等于 |
| day__lte | 日期小于等于 |

body:

| key          | type  | required | comment     |
| ------------ | ----- | -------- | ----------- |
| day          | date  |          | 日期        |
| new_users    | int   |          | 新增用户数  |
| retention_1  | float |          | 次日留存率  |
| retention_7  | float |          | 7日后留存率 |
| retention_14 | float |          | 14日后留存  |
| retention_30 | float |          | 30日后留存  |



## **activity 用户活跃度表**

> 按天统计

action:

| method | path                |
| ------ | ------------------- |
| GET    | stats/user/activity |

query-string

| key  | coment |
| ---- | ------ |
|      |        |
|      |        |

body:

| key            | type | required | comment      |
| -------------- | ---- | -------- | ------------ |
| day            | date |          | 日期         |
| daily_active   | int  |          | 日活跃用户数 |
| weekly_active  | int  |          | 周活跃用户数 |
| monthly_active | int  |          | 月活跃用户数 |





# 订单分析表



## **entire 整体分析**

> 按天统计

| key           | type  | required | comment    |
| ------------- | ----- | -------- | ---------- |
| day           | date  |          | 下单时间   |
| product_type  | str   |          | 产品类型   |
| n_user        | int   |          | 下单用户数 |
| n_order       | int   |          | 订单量     |
| avg_price     | float |          | 客单价     |
| n_canceled    | int   |          | 取消订单量 |
| rate_canceled | float |          | 订单取消率 |
| n_rejected    | int   |          | 订单退货量 |
| rate_rejected | float |          | 订单退货率 |



## **sell 产品销售分析表**

> 按天统计

| key          | type  | required | comment  |
| ------------ | ----- | -------- | -------- |
| day          | date  |          | 日期     |
| product_type | str   |          | 产评类型 |
| product_name | text  |          | 产品名称 |
| n_users      | int   |          | 购买人数 |
| n_times      | int   |          | 购买次数 |
| n_amount     | float |          | 购买金额 |



## **transform 购买转化漏斗表** 

> 按天统计

| key          | type | required | comment      |
| ------------ | ---- | -------- | ------------ |
| day          | date |          | 日期         |
| product_type | str  |          | 产评类型     |
| product_name | text |          | 商品名称     |
| n_products   | int  |          | 浏览商品页面 |
| n_carted     | int  |          | 加购物车量   |
| n_ordered    | int  |          | 提交订单量   |
| n_paid       | int  |          | 支付订单量   |