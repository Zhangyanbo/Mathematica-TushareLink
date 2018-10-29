(* ::Package:: *)

BeginPackage["TushareLink`"]


TushareConnect::usage = "\:6253\:5f00Tushare Link\:ff0c\:5e76\:8fd4\:56de\:4e00\:4e2a\:8fde\:63a5"

CloseConnection::usage = "\:5173\:95ed\:8fde\:63a5"

DayliData::usage = "DayliData[\:8fde\:63a5\:ff0c\:80a1\:7968\:4ee3\:7801.SZ or .SI\:ff0c\:5f00\:59cb\:65e5\:671f\:ff0c\:7ed3\:675f\:65e5\:671f]\:ff0c\:83b7\:53d6\:5206\:65e5\:6570\:636e"

DayliDatas::usage = "DayliDatas[\:8fde\:63a5\:ff0c\:80a1\:7968\:4ee3\:7801.SZ or .SI\:ff0c\:5f00\:59cb\:65e5\:671f\:ff0c\:7ed3\:675f\:65e5\:671f]\:ff0c\:83b7\:53d6\:591a\:53ea\:80a1\:7968\:7684\:5206\:65e5\:6570\:636e"

TushareCandlestickChart::usage = "TushareCandlestickChart[\:6570\:636e], \:7ed8\:5236\:8721\:70db\:56fe"

StockBasic::usage = "StockBasic[\:8fde\:63a5\:ff0c\:9009\:9879]\:ff0c\:83b7\:53d6\:5e02\:573a\:4e0a\:7684\:80a1\:7968\:57fa\:672c\:4fe1\:606f\:3002
\:9009\:9879\:ff1a
IsHS\[Rule]\:662f\:5426\:6caa\:6df1\:6e2f\:901a\:6807\:7684\:ff0cN\:5426 H\:6caa\:80a1\:901a S\:6df1\:80a1\:901a
ListStatus\[Rule]\:4e0a\:5e02\:72b6\:6001\:ff1aL\:4e0a\:5e02 D\:9000\:5e02 P\:6682\:505c\:4e0a\:5e02
ExchangeID\[Rule]\:4ea4\:6613\:6240\:ff1aSSE\:4e0a\:4ea4\:6240 SZSE\:6df1\:4ea4\:6240 HKEX\:6e2f\:4ea4\:6240
Outputs\[Rule]\:8f93\:51fa\:53c2\:6570
\:66f4\:591a\:4fe1\:606f\:53c2\:89c1\:ff1ahttps://tushare.pro/document/2?doc_id=25"


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


(* ::Subsection:: *)
(*StockBasic: \:80a1\:7968\:5217\:8868*)


Options[StockBasic]={IsHS->"",ListStatus->"L",ExchangeID->"",
Outputs->{"ts_code","symbol","name","area","industry","list_date"}}

StockBasic[conn_,OptionsPattern[]]:=Module[{fields=StringReplace[ToString[OptionValue[Outputs]],{"{"->"'","}"->"'"," "->""}]},
ExternalEvaluate[conn,StringTemplate["
tdata = api.stock_basic(is_hs = '``', exchange_id='``', list_status='``', fields=``)
dict(tdata)
"][OptionValue[IsHS],OptionValue[ExchangeID],OptionValue[ListStatus],fields]]
]


(* ::Subsection:: *)
(*End*)


End[]


EndPackage[]
