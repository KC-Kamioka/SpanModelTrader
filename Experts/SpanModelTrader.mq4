//+------------------------------------------------------------------+
//|                                              SpanModelTrader.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| ライブラリ                                                          |
//+------------------------------------------------------------------+
#include <SMTTradeMain.mqh>
#include <SMTSubFunction.mqh>
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

//既存のオブジェクトを削除
   ObjectsDeleteAll();

//チャートの期間変更
//    ChartSetSymbolPeriod(0,NULL,PERIOD_M5);

//テンプレート適用
//    ChartApplyTemplate(0,SMTTEMPLATE);

//EA初期化
   SMTInitialize();

//ログファイル作成
//    CreateLogFile(LOGFILENAME);

//ログファイル削除
   FileDelete(LOGFILENAME);

//シグナルセット
   for(int i=INITBARCOUNT; i>0; i--)
     {
      SetSMTTrendFollowSignal(i);
     }

//シグナル名表示
   DisplaySignalName();

//ポジションクローズ
   for(int i=0; i<OrdersTotal(); i++)
     {
      bool bSelected=OrderSelect(i,SELECT_BY_POS);
      if(OrderSymbol()==Symbol())
        {

         bool Closed=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),10,Magenta);
        }
     }

//取引情報初期化
   SetSessionOpenSignal(NOSIGNAL);
   SetSessionTrendTicket(NOPOSITION);
   SetSessionIsClosedSMBlueSpan(false);
   SetSessionIsClosedSMDelayedSpan(false);
   SetSessionIsClosedSBSigmaLine(false);

   return(INIT_SUCCEEDED);
//---
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

//EA初期化
   SMTInitialize();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {

//始値でのみ処理開始
   static datetime dTmpTime=Time[0];
   if(Time[0] == dTmpTime) return;
   dTmpTime=Time[0];

//トレード停止
   if(SessionIsTradeEnable==false)
     {
      Comment(GetCodeContent(MSG0019));
      return;
     }

//トレンドフォロー
   SMTTrendFollow();

//シグナル名表示
   DisplaySignalName();

//チケット番号表示
   Comment(SessionTrendTicket);
  }
//+------------------------------------------------------------------+
