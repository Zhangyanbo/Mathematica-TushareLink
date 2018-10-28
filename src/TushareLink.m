(* ::Package:: *)

BeginPackage["TushareLink`"]


TushareConnect::usage = "\:6253\:5f00Tushare Link\:ff0c\:5e76\:8fd4\:56de\:4e00\:4e2a\:8fde\:63a5"

CloseConnection::usage = "\:5173\:95ed\:8fde\:63a5"

DayliData::usage = "DayliData[\:8fde\:63a5\:ff0c\:80a1\:7968\:4ee3\:7801.SZ or .SI\:ff0c\:5f00\:59cb\:65e5\:671f\:ff0c\:7ed3\:675f\:65e5\:671f]\:ff0c\:83b7\:53d6\:5206\:65e5\:6570\:636e"

DayliDatas::usage = "DayliDatas[\:8fde\:63a5\:ff0c\:80a1\:7968\:4ee3\:7801.SZ or .SI\:ff0c\:5f00\:59cb\:65e5\:671f\:ff0c\:7ed3\:675f\:65e5\:671f]\:ff0c\:83b7\:53d6\:591a\:53ea\:80a1\:7968\:7684\:5206\:65e5\:6570\:636e"

TushareCandlestickChart::usage = "TushareCandlestickChart[\:6570\:636e], \:7ed8\:5236\:8721\:70db\:56fe"


Begin["`Private`"]


openLinkCode[api_]:=StringTemplate["
import tushare as ts
api = ts.pro_api('``')
"][api]

TushareConnect[api_]:=Module[{con},
con=StartExternalSession["Python"];
ExternalEvaluate[con,openLinkCode[api]];
con
]

CloseConnection[conn_]:=DeleteObject[conn]

MMAListToPythonList[list_]:=StringReplace[ToString[list,InputForm],{"\""->"'","{"->"[","}"->"]"}]

DateObjectToStr[date_]:=StringDelete[DateString[date,"ISODate"],"-"]

DayliData[conn_,code_,stdate_,eddate_]:=ExternalEvaluate[conn,
StringTemplate["
t_data=api.daily(ts_code= '``', start_date = '``', end_date = '``')
dict(t_data)
"][code,DateObjectToStr[stdate],DateObjectToStr[eddate]]
]

DayliDatas[conn_,codes_,stdate_,eddate_]:=ExternalEvaluate[conn,
StringTemplate["
codes=``
[dict(api.daily(ts_code=code, start_date = '``', end_date = '``')) for code in codes]
"][MMAListToPythonList[codes],DateObjectToStr[stdate],DateObjectToStr[eddate]]
]

TushareCandlestickChart[data_]:=CandlestickChart[{#1,{#2,#3,#4,#5}}&@@@({data["trade_date"],data["open"],data["high"],data["low"],data["close"]}\[Transpose]),ScalingFunctions->"Log"]


End[]


EndPackage[]
