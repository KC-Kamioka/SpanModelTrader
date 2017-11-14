//+------------------------------------------------------------------+
//|                                                      SMT0005.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
//+------------------------------------------------------------------+
//| ライブラリ                                                       |
//+------------------------------------------------------------------+
#include <SMT0001.mqh>
//+------------------------------------------------------------------+
//| スキャルピング                                                                 |
//+------------------------------------------------------------------+
void Scalping(string sSignal,bool IsInit,int iBarNo)
  {

//処理開始ログ出力
   string sProcessName="Scalping";
   TrailLog("INFO",CLASSNAME5,sProcessName,"MSG0033",iBarNo);

//スーパーボリンジャーの値
   double dLowPlus1Sigma=iBands(NULL,PERIOD_M5,21,1,0,PRICE_CLOSE,1,iBarNo+1);
   double dLowMnus1Sigma=iBands(NULL,PERIOD_M5,21,1,0,PRICE_CLOSE,2,iBarNo+1);
   double dLowPlus2Sigma=iBands(NULL,PERIOD_M5,21,2,0,PRICE_CLOSE,1,iBarNo);
   double dLowMnus2Sigma=iBands(NULL,PERIOD_M5,21,2,0,PRICE_CLOSE,2,iBarNo);
   double dLowPrePlus2Sigma=iBands(NULL,PERIOD_M5,21,2,0,PRICE_CLOSE,1,iBarNo+3);
   double dLowPreMnus2Sigma=iBands(NULL,PERIOD_M5,21,2,0,PRICE_CLOSE,2,iBarNo+3);

//2つ前の高値、安値
   double dHigh=High[iBarNo+3];
   double dLow=Low[iBarNo+3];
   double dPreClose=Close[iBarNo+1];
   double dClose=Close[iBarNo];

//トレード中の場合
//新規ポジション取得
   if(SessionIsExistScalpPos==false)
      //if(IsExistPosition()==false)
     {
      //買いシグナル点灯中
      if(sSignal==SIGNALBUY)
        {
        if(dLowMnus2Sigma>Low[iBarNo])
              {
               if(IsInit==false)PositionOpenBuy(STOPLOSS_SCL);
               SessionIsExistScalpPos=true;
              }
        /*
         //3つ前の安値が-2シグマを下回る
         if(dLowPreMnus2Sigma>dLow)
           {
            //1つ前の終値が3つ前の安値を超えていない
            if(dLow<dPreClose)
              {
               if(IsInit==false)PositionOpenBuy(STOPLOSS_SCL);
               SessionIsExistScalpPos=true;
              }
           }
           */
        }

      //売りポジション取得
      else if(sSignal==SIGNALSELL)
        {
        if(dLowPlus2Sigma<High[iBarNo])
              {
               if(IsInit==false)PositionOpenSell(STOPLOSS_SCL);
               SessionIsExistScalpPos=true;
              }
        /*
         //3つ前の高値が+2シグマを上回る
         if(dLowPrePlus2Sigma<dHigh)
           {
            //1つ前の終値が3つ前の高値を超えていない
            if(dHigh>dPreClose)
              {
               if(IsInit==false)PositionOpenSell(STOPLOSS_SCL);
               SessionIsExistScalpPos=true;
              }
           }
           */
        }
     }
//手仕舞い
   else
     {
      if(sSignal==SIGNALBUY && dLowPlus2Sigma<High[iBarNo])
        {
         //買いポジションクローズ
         if(IsInit==false)PositionCloseAll();
         SessionIsExistScalpPos=false;
        }
      else if(sSignal==SIGNALSELL && dLowMnus2Sigma>Low[iBarNo])
        {
         //売りポジションクローズ
         if(IsInit==false)PositionCloseAll();
         SessionIsExistScalpPos=false;
        }
      else
        {
         SetObjSMTSignal(SessionOpenSignal,SMTVPRICE11,iBarNo);
        }
     }

//処理終了ログ出力
   TrailLog("INFO",CLASSNAME5,sProcessName,"MSG0034",iBarNo);
   return;
  }
//+------------------------------------------------------------------+
