# Mathematica-TushareLink
Wolfram Mathematica连接[Tushare](https://github.com/waditu/Tushare)程序包，可以在Mathematica中获取A股数据



**版本要求：Mathematica版本 >= 11.3**



## 使用说明

导入包：

```mathematica
<< (NotebookDirectory[] <> "TushareLink.m")
(*注：括号里需改成TushareLink.m的绝对地址*)
```

输入Token，获取Python连接：

```mathematica
con = TushareConnect["<your token>"]
```

使用`CloseConnection[con]`可以关闭连接。

## 函数功能

### StockBasic：股票列表

```mathematica
StockBasic[conn, IsHS->"", ListStatus->"L", ExchangeID->"", Outputs->{"ts_code","symbol","name","area","industry","list_date"}]
```

此处格式与Tushare原来的包格式相近，可以参考[Tushare的文档](https://tushare.pro/document/2?doc_id=25)。

