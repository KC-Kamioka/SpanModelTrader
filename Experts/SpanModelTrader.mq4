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
#include <SMT0001.mqh>
#include <SMT0002.mqh>
#include <SMT0003.mqh>
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

   return(INIT_SUCCEEDED);
//---
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {

//始値でのみ処理開始
   if(Volume[0]!=1)
     {

      //変数定義
      SpanModelRate preSmr;
      SpanModelRate smr;
      OpenSignal sig;

      //週末チェック
      if(IsWeekend(0)==true)
        {
         //全ポジションクローズ
         PositionCloseAll();
         return;
        }

      //スパンモデルの値をセット
      GetSpanModelRate(preSmr,2);
      GetSpanModelRate(smr,1);

      //---- スパンモデル売買シグナルセット
      //青色スパンが赤色スパンを上回る
      if(preSmr.dBlueSpan<=preSmr.dRedSpan && smr.dBlueSpan>smr.dRedSpan)
        {

         //遅行スパンが青色・赤色スパンを上回る
         if(smr.dDelayedBlueSpan<smr.dDelayedSpan && smr.dRedSpan<smr.dDelayedSpan)
           {
            //買いシグナル点灯
            sig.SpanModel_BlueSpan=SIGNALBUY;
           }
        }
      //青色スパンが赤色スパンを下回る
      else if(preSmr.dBlueSpan>=preSmr.dRedSpan && smr.dBlueSpan<smr.dRedSpan)
        {
         //遅行スパンが青色・赤色スパンを下回る
         if(smr.dDelayedBlueSpan>smr.dDelayedSpan && smr.dRedSpan>smr.dDelayedSpan)
           {
            //売りシグナル点灯
            sig.SpanModel_BlueSpan=SIGNALSELL;
           }
        }
      else sig.SpanModel_BlueSpan=NOSIGNAL;
      //---- 

      //---- ポジションオープン
      if(!IsExistPosition())
        {
         PositionOpen(sig);
        }
      //----

      //---- ポジションクローズ（遅行スパン）
      //買いシグナル点灯時
      if(sig.SpanModel_BlueSpan==SIGNALBUY)
        {
         //青色スパン＆遅行スパンクロス
         if(preSmr.dBlueSpan<=preSmr.dDelayedSpan && smr.dBlueSpan>smr.dDelayedSpan)
           {
            PositionClose(CLOSELOT);
           }
        }
      //売りシグナル点灯時
      else if(sig.SpanModel_BlueSpan==SIGNALSELL)
        {
         //青色スパン＆遅行スパンクロス
         if(preSmr.dBlueSpan>=preSmr.dDelayedSpan && smr.dBlueSpan<smr.dDelayedSpan)
           {
            PositionClose(CLOSELOT);
           }
        }
      else
        {
         //ブレイクイーブン
         BreakEven();
        }
      //----
     }
  }
//+------------------------------------------------------------------+
//| ポジションオープン                                                    |
//+------------------------------------------------------------------+
void PositionOpen(OpenSignal &sig)
  {

//買いシグナル
   if(sig.SpanModel_BlueSpan==SIGNALBUY)
     {
      //買いポジションオープン
      PositionOpenBuy(STOPLOSS);
     }
//売りシグナル
   else if(sig.SpanModel_BlueSpan==SIGNALSELL)
     {
      //売りポジションオープン
      PositionOpenSell(STOPLOSS);
     }
  }
//+------------------------------------------------------------------+
