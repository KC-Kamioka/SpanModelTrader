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
#include <SMT0004.mqh>
//+------------------------------------------------------------------+
//| 構造体                                                           |
//+------------------------------------------------------------------+
OpenSignal sig;
OpenSignal init_sig;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   ObjectsDeleteAll();
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

//---- 始値でのみ処理開始
   if(Volume[0]!=1)
     {

      //変数定義
      SpanModelRate pre_smr;
      SpanModelRate smr;
      SuperBolingerRate pre_sbr;
      SuperBolingerRate sbr;
      Candle cdl;

      //週末チェック
      if(IsWeekend(0)==true)
        {
         //全ポジションクローズ
         PositionCloseAll();
         return;
        }

      //スパンモデルの値をセット
      GetSpanModelRate(pre_smr,2);
      GetSpanModelRate(smr,1);

      //スーパーボリンジャーの値セット
      GetSuperBolingerRate(pre_sbr,Adjust_BarNo+1);
      GetSuperBolingerRate(sbr,1);

      //1時間足ローソク情報セット
      GetUpperPeriodCandleInfo(cdl,1);

      //---- 青色スパン売買シグナルセット
      //青色スパンが赤色スパンを上回っている
      if(smr.dBlueSpan>smr.dRedSpan)
        {
         //買いシグナル点灯
         sig.SpanModel_BlueSpan=SIGNALBUY;
        }
      //青色スパンが赤色スパンを下回っている
      else if(smr.dBlueSpan<smr.dRedSpan)
        {
         //売りシグナル点灯
         sig.SpanModel_BlueSpan=SIGNALSELL;
        }
      else sig.SpanModel_BlueSpan=NOSIGNAL;
      //---- 

      //---- スパンモデル遅行スパン売買シグナルセット
      //遅行スパンが青色・赤色スパンを上回っている
      if(smr.dDelayedBlueSpan<smr.dDelayedSpan && smr.dRedSpan<smr.dDelayedSpan)
        {
         //買いシグナル点灯
         sig.SpanModel_DelayedSpan=SIGNALBUY;
        }
      //遅行スパンが青色・赤色スパンを下回っている
      else if(smr.dDelayedBlueSpan>smr.dDelayedSpan && smr.dRedSpan>smr.dDelayedSpan)
        {
         //売りシグナル点灯
         sig.SpanModel_DelayedSpan=SIGNALSELL;
        }
      else sig.SpanModel_DelayedSpan=NOSIGNAL;
      //---- 

      //---- スーパーボリンジャー遅行スパン売買シグナルセット
      //遅行スパン上抜け
      if(cdl.dHighRate<cdl.dCloseRate)
        {
         //買いシグナル点灯
         sig.SuperBolinger_DelayedSpan=SIGNALBUY;
        }
      //遅行スパン下抜け
      else if(cdl.dLowRate>cdl.dCloseRate)
        {
         //売りシグナル点灯
         sig.SuperBolinger_DelayedSpan=SIGNALSELL;
        }
      else sig.SuperBolinger_DelayedSpan=NOSIGNAL;
      //---- 

      //---- スーパーボリンジャー±３シグマライン拡大シグナルセット
      //プラス３シグマライン拡大
      if(pre_sbr.dPlus3Sigma<sbr.dPlus3Sigma)
        {
         //買いシグナル点灯
         sig.SuperBolinger_Expand3Sigma=SIGNALBUY;
        }
      //マイナス３シグマライン拡大
      else if(pre_sbr.dMnus3Sigma>sbr.dMnus3Sigma)
        {
         //売りシグナル点灯
         sig.SuperBolinger_Expand3Sigma=SIGNALSELL;
        }
      else sig.SuperBolinger_Expand3Sigma=NOSIGNAL;
      //---- 

      //---- ポジションオープン
      if(!IsExistPosition())
        {
         //買いシグナル点灯中
         if(sig.SpanModel_BlueSpan==SIGNALBUY && 
            sig.SpanModel_DelayedSpan==SIGNALBUY && 
            sig.SuperBolinger_DelayedSpan==SIGNALBUY && 
            sig.SuperBolinger_Expand3Sigma==SIGNALBUY)
           {
            //終値がスーパーボリンジャ―のプラス１、２シグマラインの間に位置しているとき
            if(sbr.dPlus1Sigma<=Close[1] && sbr.dPlus2Sigma>=Close[1])
              {
               //終値がボリンジャーバンドプラス１シグマラインを下回った場合
               if(pre_smr.dPlus1Sgma<Close[2] && smr.dPlus1Sgma>=Close[1])
                 {
                  //買いポジションオープン
                  PositionOpenBuy(STOPLOSS);
                 }
              }
           }
         //売りシグナル点灯中
         if(sig.SpanModel_BlueSpan==SIGNALSELL && 
            sig.SpanModel_DelayedSpan==SIGNALSELL && 
            sig.SuperBolinger_DelayedSpan==SIGNALSELL && 
            sig.SuperBolinger_Expand3Sigma==SIGNALSELL)
           {
            //終値がスーパーボリンジャ―のマイナス１、２シグマラインの間に位置しているとき
            if(sbr.dMnus1Sigma>=Close[1] && sbr.dMnus2Sigma<=Close[1])
              {
               //終値がボリンジャーバンドマイナス1シグマラインを上回ったとき
               if(pre_smr.dMnus1Sgma>Close[2] && smr.dMnus1Sgma<=Close[1])
                 {
                  //売りポジションオープン
                  PositionOpenSell(STOPLOSS);
                 }
              }
           }
        }
      //----

      //---- ポジションクローズ（遅行スパン）
      if(IsExistPosition())
        {
         //買いシグナル点灯時
         if(sig.SpanModel_BlueSpan==SIGNALBUY)
           {
            //青色スパン＆遅行スパンクロス
            if(pre_smr.dDelayedBlueSpan<=pre_smr.dDelayedSpan && smr.dDelayedBlueSpan>smr.dDelayedSpan)
              {
               //Print("smr.dDelayedBlueSpan " + DoubleToString(smr.dDelayedBlueSpan));
               //Print("smr.dDelayedSpan " + DoubleToString(smr.dDelayedSpan));
               //全ポジションクローズ
               PositionCloseAll();

               //シグナル構造体初期化
               sig=init_sig;
              }
           }
         //売りシグナル点灯時
         if(sig.SpanModel_BlueSpan==SIGNALSELL)
           {
            //青色スパン＆遅行スパンクロス
            if(pre_smr.dDelayedBlueSpan>=pre_smr.dDelayedSpan && smr.dDelayedBlueSpan<smr.dDelayedSpan)
              {
               //全ポジションクローズ
               PositionCloseAll();
               Print(TimeToString(Time[0])+" smr.dDelayedBlueSpan "+DoubleToString(smr.dDelayedBlueSpan));
               Print(TimeToString(Time[0])+" smr.dDelayedSpan "+DoubleToString(smr.dDelayedSpan));

               //シグナル構造体初期化
               sig=init_sig;
               Print(TimeToString(Time[0])+" sig.SpanModel_BlueSpan "+IntegerToString(sig.SpanModel_BlueSpan));
              }
           }
         //ブレイクイーブン
         //BreakEven();
        }
      //----
     }
//----
  }
//+------------------------------------------------------------------+
