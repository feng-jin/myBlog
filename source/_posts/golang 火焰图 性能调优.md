---
title: golang 火焰图 性能调优
date: 2020-01-08 20:38:38
category:
- golang
---

最近在做golang服务器调优，用了一下uber开源的工具，go-torch。下面记录一下运用过程

# 安装

```shell
# 安装go-torch
go get github.com/uber/go-torch

# 安装FlameGragh
cd $WORK_PATH && git clone https://github.com/brendangregg/FlameGraph.git
export PATH=$PATH:$WORK_PATH/FlameGraph

# 安装graghviz
yum install graphviz
```

# 代码修改
```go
//加入如下代码
package main

import (
    _ "net/http/pprof"
)

func main() {
    go func() {
		http.ListenAndServe("0.0.0.0:20020", nil)
	}()
}
```

# 查看结果
```shell
# 生成CPU火焰图
go-torch -u http://localhost:20020/debug/pprof -t 30

# 生成内存火焰图
go-torch -u http://localhost:20020/debug/pprof/heap -t 30
```

会生成一个svg文件，用文件用浏览器打开即可看到火焰图。