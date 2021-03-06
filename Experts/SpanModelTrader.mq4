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
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
//オブジェクト削除
   ObjectsDeleteAll();

//シグナル初期化
   sig.SpanModel_BlueSpan=NOSIGNAL;
   sig.SpanModel_DelayedSpan=NOSIGNAL;
   sig.SuperBolinger_DelayedSpan=NOSIGNAL;
//   sig.SuperBolinger_Expand3Sigma=NOSIGNAL;
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
      SpanModelRate pre_smr,smr;
      SuperBolingerRate pre_sbr,sbr;
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

      //スパンモデルシグナルセット
      SetSignalSpanModel(pre_smr,smr);

      //スーパーボリンジャーシグナルセット                                         |
      SetSignalSuperBolinger(pre_sbr,sbr,cdl);

      //---- ポジションオープン
      if(!IsExistPosition())
        {
         //買いシグナル点灯中
/*
         if(sig.SpanModel_BlueSpan==SIGNALBUY && 
            sig.SpanModel_DelayedSpan==SIGNALBUY && 
            sig.SuperBolinger_DelayedSpan==SIGNALBUY && 
            sig.SuperBolinger_Expand3Sigma==SIGNALBUY)
*/
         if(sig.SpanModel_BlueSpan==SIGNALBUY && 
            sig.SuperBolinger_DelayedSpan==SIGNALBUY && 
            sig.SpanModel_DelayedSpan==SIGNALBUY)
           {
            //終値がスーパーボリンジャ―のプラス１、２シグマラインの間に位置しているとき
            if(sbr.dPlus1Sigma<=Close[1] && sbr.dPlus2Sigma>=Close[1])
              {
               //終値がボリンジャーバンドプラス１シグマラインを下回った場合
               if(smr.dPlus1Sgma>=Close[0])
                 {
                  //買いポジションオープン
                  PositionOpenBuy(STOPLOSS);
                 }
              }
           }
         //売りシグナル点灯中
/*
         if(sig.SpanModel_BlueSpan==SIGNALSELL && 
            sig.SpanModel_DelayedSpan==SIGNALSELL && 
            sig.SuperBolinger_DelayedSpan==SIGNALSELL && 
            sig.SuperBolinger_Expand3Sigma==SIGNALSELL)
*/
         if(sig.SpanModel_BlueSpan==SIGNALSELL && 
            sig.SuperBolinger_DelayedSpan==SIGNALSELL && 
            sig.SpanModel_DelayedSpan==SIGNALSELL)
           {
            //終値がスーパーボリンジャ―のマイナス１、２シグマラインの間に位置しているとき
            if(sbr.dMnus1Sigma>=Close[1] && sbr.dMnus2Sigma<=Close[1])
              {
               //終値がボリンジャーバンドマイナス1シグマラインを上回ったとき
               if(smr.dMnus1Sgma<=Close[0])
                 {
                  //売りポジションオープン
                  PositionOpenSell(STOPLOSS);
                 }
              }
           }
        }
      //----

      //---- ポジションクローズ
      if(IsExistPosition())
        {
         if(sig.SpanModel_BlueSpan==NOSIGNAL && 
            sig.SpanModel_DelayedSpan==NOSIGNAL)
           {
            //全ポジションクローズ
            PositionCloseAll();
           }
        }
      //----
     }
//----
  }
//+------------------------------------------------------------------+
//| スパンモデルシグナルセット                                             |
//+------------------------------------------------------------------+
void SetSignalSpanModel(SpanModelRate &pre_smr,SpanModelRate &smr)
  {
//---- 青色スパン売買シグナルセット
//シグナル消灯中の場合
   if(sig.SpanModel_BlueSpan==NOSIGNAL)
     {
      //青色スパンが赤色スパンを上回る
      if(smr.dBlueSpan>smr.dRedSpan)
        {
         //買いシグナル点灯
         sig.SpanModel_BlueSpan=SIGNALBUY;
         Print(TimeToString(Time[0])+" 【スパンモデル：青色スパン】買いシグナル点灯");
        }
      //青色スパンが赤色スパンを下回る
      if(smr.dBlueSpan<smr.dRedSpan)
        {
         //売りシグナル点灯
         sig.SpanModel_BlueSpan=SIGNALSELL;
         Print(TimeToString(Time[0])+" 【スパンモデル：青色スパン】売りシグナル点灯");
        }
     }
//---- 

//---- スパンモデル遅行スパン売買シグナルセット
//シグナル消灯中の場合
   if(sig.SpanModel_DelayedSpan==NOSIGNAL)
     {
      //遅行スパンが高値を上回っている
      if(smr.dDelayedSpan>smr.dHighest)
        {
         //買いシグナル点灯
         sig.SpanModel_DelayedSpan=SIGNALBUY;
         Print(TimeToString(Time[0])+" 【スパンモデル：遅行スパン】買いシグナル点灯");
        }
      //遅行スパンが安値を下回っている
      if(smr.dDelayedSpan<smr.dLowest)
        {
         //売りシグナル点灯
         sig.SpanModel_DelayedSpan=SIGNALSELL;
         Print(TimeToString(Time[0])+" 【スパンモデル：遅行スパン】売りシグナル点灯");
        }
     }
//---- 

//---- スパンモデルシグナル消灯セット
//買いシグナル点灯中
   if(sig.SpanModel_BlueSpan==SIGNALBUY && 
      sig.SpanModel_DelayedSpan==SIGNALBUY)
     {
      //遅行スパンが青色スパンを下回った場合
      if(pre_smr.dDelayedSpan>pre_smr.dDelayedBlueSpan && smr.dDelayedSpan<=smr.dDelayedBlueSpan)
        {
         sig.SpanModel_BlueSpan=NOSIGNAL;
         sig.SpanModel_DelayedSpan=NOSIGNAL;
         Print(TimeToString(Time[0])+" 【スパンモデル】買いシグナル消灯");
        }
     }
//売りシグナル点灯中
   if(sig.SpanModel_BlueSpan==SIGNALSELL && 
      sig.SpanModel_DelayedSpan==SIGNALSELL)
     {
      //遅行スパンが青色スパンを上回った場合
      if(pre_smr.dDelayedSpan<pre_smr.dDelayedBlueSpan && smr.dDelayedSpan>=smr.dDelayedBlueSpan)
        {
         sig.SpanModel_BlueSpan=NOSIGNAL;
         sig.SpanModel_DelayedSpan=NOSIGNAL;
         Print(TimeToString(Time[0])+" 【スパンモデル】売りシグナル消灯");
        }
     }
//シグナル逆行
   if(sig.SpanModel_BlueSpan==SIGNALBUY && 
      sig.SpanModel_DelayedSpan==SIGNALSELL)
     {
      sig.SpanModel_BlueSpan=NOSIGNAL;
      sig.SpanModel_DelayedSpan=NOSIGNAL;
      Print(TimeToString(Time[0])+" 【スパンモデル】シグナル逆行のため消灯");
     }
   if(sig.SpanModel_BlueSpan==SIGNALSELL && 
      sig.SpanModel_DelayedSpan==SIGNALBUY)
     {
      sig.SpanModel_BlueSpan=NOSIGNAL;
      sig.SpanModel_DelayedSpan=NOSIGNAL;
      Print(TimeToString(Time[0])+" 【スパンモデル】シグナル逆行のため消灯");
     }
//---- 
  }
//+------------------------------------------------------------------+
//| スーパーボリンジャーシグナルセット                                         |
//+------------------------------------------------------------------+
void SetSignalSuperBolinger(SuperBolingerRate &pre_sbr,SuperBolingerRate &sbr,Candle &cdl)
  {
//---- スーパーボリンジャー遅行スパン売買シグナルセット
//シグナル消灯中の場合
   if(sig.SuperBolinger_DelayedSpan==NOSIGNAL)
     {
      //遅行スパン上抜け
      if(cdl.dHighRate<cdl.dCloseRate)
        {
         //買いシグナル点灯
         sig.SuperBolinger_DelayedSpan=SIGNALBUY;
         Print(TimeToString(Time[0])+" 【スーパーボリンジャー：遅行スパン】買いシグナル点灯");
        }
      //遅行スパン下抜け
      if(cdl.dLowRate>cdl.dCloseRate)
        {
         //売りシグナル点灯
         sig.SuperBolinger_DelayedSpan=SIGNALSELL;
         Print(TimeToString(Time[0])+" 【スーパーボリンジャー：遅行スパン】売りシグナル点灯");
        }
     }
//---- 
/*
//---- スーパーボリンジャー±３シグマライン拡大シグナルセット
//シグナル消灯中の場合
   if(sig.SuperBolinger_Expand3Sigma==NOSIGNAL)
     {
      //プラス３シグマライン拡大
      if(pre_sbr.dPlus3Sigma<sbr.dPlus3Sigma)
        {
         //買いシグナル点灯
         sig.SuperBolinger_Expand3Sigma=SIGNALBUY;
         Print(TimeToString(Time[0])+" 【スーパーボリンジャー：シグマライン】買いシグナル点灯");
        }
      //マイナス３シグマライン拡大
      if(pre_sbr.dMnus3Sigma>sbr.dMnus3Sigma)
        {
         //売りシグナル点灯
         sig.SuperBolinger_Expand3Sigma=SIGNALSELL;
         Print(TimeToString(Time[0])+" 【スーパーボリンジャー：シグマライン】売りシグナル点灯");
        }
     }
//---- 
*/
/*
//---- スーパーボリンジャーシグナル消灯セット
   if(sig.SuperBolinger_Expand3Sigma!=NOSIGNAL)
     {
      //買いシグナル点灯中、プラス３シグマラインの拡大が止まった場合
      if(pre_sbr.dPlus3Sigma>=sbr.dPlus3Sigma)
        {
         sig.SuperBolinger_DelayedSpan=NOSIGNAL;
         sig.SuperBolinger_Expand3Sigma=NOSIGNAL;
         Print(TimeToString(Time[0])+" 【スーパーボリンジャー】買いシグナル消灯");
        }
     }
   if(sig.SuperBolinger_DelayedSpan==SIGNALSELL && 
      sig.SuperBolinger_Expand3Sigma==SIGNALSELL)
     {
      //売りシグナル点灯中、マイナス３シグマラインの拡大が止まった場合
      if(pre_sbr.dMnus3Sigma<=sbr.dMnus3Sigma)
        {
         sig.SuperBolinger_DelayedSpan=NOSIGNAL;
         sig.SuperBolinger_Expand3Sigma=NOSIGNAL;
         Print(TimeToString(Time[0])+" 【スーパーボリンジャー】売りシグナル消灯");
        }
     }
//---- 
*/
//---- スーパーボリンジャーシグナル消灯セット
   if(sig.SuperBolinger_DelayedSpan==SIGNALBUY)
     {
      //買いシグナル点灯中、終値が移動平均線を下回った場合
      if(cdl.dCloseRate<sbr.dSimpleMA)
        {
         sig.SuperBolinger_DelayedSpan=NOSIGNAL;
         Print(TimeToString(Time[0])+" 【スーパーボリンジャー】買いシグナル消灯");
        }
     }
   if(sig.SuperBolinger_DelayedSpan==SIGNALSELL)
     {
      //売りシグナル点灯中、終値が移動平均線を上回った場合
      if(cdl.dCloseRate>sbr.dSimpleMA)
        {
         sig.SuperBolinger_DelayedSpan=NOSIGNAL;
         Print(TimeToString(Time[0])+" 【スーパーボリンジャー】売りシグナル消灯");
        }
     }
//---- 

  }
//+------------------------------------------------------------------+
