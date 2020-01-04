---
title: Spark处理损坏json文件
date: 2020-01-04 12:28:08
category:
- spark
tags:
---

通常用spark读取json文件的时候，用的是
```scala
spark.read.json(path)
```
这种方式进行读取，但是，当json文件某一行有损坏的情况下，则会出现解析失败，导致schema解析错误的情况，可能会遇到这种错误
```scala
Found duplicate column(s) in the data schema
```
百度和google了很多，有人说加入
```scala
spark.read.option("mode","DROPMALFORMED")
```
但是在我的数据下并没有用。

然后我想出2个解决方案。
第一个是用fastjson，来逐行解析，丢掉解析失败的行。
第二个是用spark中指定schema的方式来解析。
最终我采取了第二种方式。

具体如下，我只将代码重要部分提取，其他业务部分省略：

```scala
import org.apache.spark.sql.types._

	val schema_1 = StructType(
		List(
			StructField("field_a", LongType),
			StructField("field_b", LongType),
			StructField("field_c", LongType),
            StructField("field_d", ArrayType(StringType))
		)
	)

    val schema_2 = StructType(
		List(
			StructField("field_e", LongType),
			StructField("field_f", LongType),
			StructField("field_g", LongType),
            StructField("field_h", ArrayType(StringType))
		)
	)
    
    val schema = StructType(
		List(
			StructField("schema_1", schema_1),
			StructField("schema_2", schema_2)
		)
	)

    val df = spark.read.schema(schema).json(path)
```

这种方式有优点，也有缺点：

优点是，若不加schema，则spark.read.json方式则需要扫2遍所有json文件，第一遍扫schema，第二遍解析。加入schema，则只需要扫一遍，第一遍扫schema跳过。

缺点是，增加了维护成本，若加入了一些字段，则这里则需要同步修改。

如有遇到同样问题的朋友们，有新的解决方案，欢迎交流。