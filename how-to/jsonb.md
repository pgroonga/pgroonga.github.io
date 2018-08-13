---
title: How to use on JSONB type column
---

# How to do full-text-seach on JSONB type column

JSONB type comes from Postgresql 9.4, this document will help you to try use `Pgronga` on JSONB type.

## Create table schema and index

Here is the sample to create a table with JSONB type:

```sql
CREATE TABLE "public"."jsonb_table" (
   "id" serial2,
   "data" jsonb,
  PRIMARY KEY ("id")
);
```

Then create index on JSONB:

**Notes**
> `pgroonga_jsonb_ops_v2` only support less than **4kiB** data in a JSONB column;
  if not certain about the length of JSONB data `pgroonga_jsonb_full_text_search_ops_v2` should be used as index method.

```sql
create INDEX pgidx_jsonb_table_data on test using pgroonga("data" pgroonga_jsonb_full_text_search_ops_v2);
```

Let us add some data for test:
```sql
INSERT INTO jsonb_table ( data )VALUES('{"addata":null,"category":"新闻","channel":null,"digest":"新华社北京7月31日电中共中央政治局7月31日召开会议，分析","docid":"DO2JBFH50001899O","imgsrc3gtype":1,"imgsrcFrom":null,"link":"https://3g.163.com/all/article/DO2JBFH50001899O.html","liveInfo":null,"picInfo":[{"height":null,"ref":null,"url":"http://cms-bucket.nosdn.127.net/2018/07/31/337d4e18a4ce420889ef6f0be621656b.png","width":null}],"ptime":"2018-07-31 18:43:30","source":"新华社","tag":"","tcount":0,"title":"中央政治局召开会议:做好去杠杆工作 遏制房价上涨","type":"doc","typeid":"","unlikeReason":null,"videoInfo":null}');
INSERT INTO jsonb_table ( data )VALUES('{"addata":null,"category":"新闻","channel":null,"digest":"环球网综合报道2018年7月31日外交部发言人耿爽主持例行记","docid":"DO2CA44F0001875O","imgsrc3gtype":1,"imgsrcFrom":null,"link":"https://3g.163.com/all/article/DO2CA44F0001875O.html","liveInfo":null,"picInfo":[{"height":null,"ref":null,"url":"http://cms-bucket.nosdn.127.net/2018/07/31/7f6ff38153bb466d87e6aff42bacf5f4.png","width":null}],"ptime":"2018-07-31 16:40:26","source":"环球时报-环球网","tag":"","tcount":0,"title":"老挝溃坝致数百人失踪 外交部：暂无中国公民伤亡","type":"doc","typeid":"","unlikeReason":null,"videoInfo":null}');
INSERT INTO jsonb_table ( data )VALUES('{"addata":null,"category":"新闻","channel":null,"digest":"财税〔2018〕74号各省、自治区、直辖市、计划单列市财政厅","docid":"DO2BMNQB0001899O","imgsrc3gtype":1,"imgsrcFrom":null,"link":"https://3g.163.com/all/article/DO2BMNQB0001899O.html","liveInfo":null,"picInfo":[{"height":null,"ref":null,"url":"http://cms-bucket.nosdn.127.net/2018/07/31/600cfadcb8344952ac84bb9d5b2aaf4b.png","width":null}],"ptime":"2018-07-31 16:29:51","source":"财政部网站","tag":"","tcount":4528,"title":"财政部：1.6L排量以下乘用车享受车船税减半优惠","type":"doc","typeid":"","unlikeReason":null,"videoInfo":null}');
INSERT INTO jsonb_table ( data )VALUES('{"addata":null,"category":"新闻","channel":null,"digest":"国务院办公厅关于印发《为烈属、军属和退役军人等家庭悬挂光荣牌","docid":"DO2APOHN0001899O","imgsrc3gtype":1,"imgsrcFrom":null,"link":"https://3g.163.com/all/article/DO2APOHN0001899O.html","liveInfo":null,"picInfo":[{"height":null,"ref":null,"url":"http://cms-bucket.nosdn.127.net/2018/07/31/ec0d455edcba4429a9b3a7d0844a06f1.png","width":null}],"ptime":"2018-07-31 16:14:01","source":"中国政府网","tag":"","tcount":1367,"title":"国办印发：为退役军人等家庭悬挂光荣牌实施办法","type":"doc","typeid":"","unlikeReason":null,"videoInfo":null}');
```
Now you can use full `Pgronga` seach on `data` column like below:
```sql
SELECT id FROM jsonb_table WHERE data->>'title' &@'国' LIMIT 5;
```
result should be like belows :
```
 id
----
  2
  4
(2 rows)
```

## Score function on JSONB column

With `pgroonga_score(tableoid,ctid)` can get score of full JSONB column

```sql
 SELECT id,pgroonga_score(tableoid, ctid) AS score FROM jsonb_table WHERE data &@'国' LIMIT 5;
```
```
 id | score
----+-------
  2 |     1
  4 |     3
(2 rows)
```

If you want to score on specified json field , you must create index on that field:

```sql
CREATE INDEX idx_jsonb_title ON jsonb_table USING pgroonga ((data->>'title'));
```
**Notes**
> `jsonb`->>'field' is text type
  `jsonb`->'field' is jsonb type

With this INDEX, now can get score on jsonb field:

```sql
 SELECT id,pgroonga_score(tableoid, ctid) AS score FROM jsonb_table WHERE data->>'title' &@'国' LIMIT 5;

  id | score
 ----+-------
   2 |     1
   4 |     1
 (2 rows)
```
