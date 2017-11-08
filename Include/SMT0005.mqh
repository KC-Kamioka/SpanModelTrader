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
#include <SMT0002.mqh>

//+------------------------------------------------------------------+
//| スキャルピング                                                                 |
//+------------------------------------------------------------------+
void Scalping(string sSignal,int iBarNo,bool IsInit=false)
  {

//処理開始ログ出力
   string sProcessName="Scalping";
   TrailLog("INFO",CLASSNAME5,sProcessName,"MSG0033",iBarNo);

      //スパンモデルの値
      
      
      //スーパーボリンジャーの値
      double dLowPlus2Sigma=iBands(NULL,PERIOD_M5,21,2,0,PRICE_CLOSE,1,iBarNo);
      double dLowMnus2Sigma=iBands(NULL,PERIOD_M5,21,2,0,PRICE_CLOSE,2,iBarNo);
      double dLowPrePlus2Sigma=iBands(NULL,PERIOD_M5,21,2,0,PRICE_CLOSE,1,iBarNo+1);
      double dLowPreMnus2Sigma=iBands(NULL,PERIOD_M5,21,2,0,PRICE_CLOSE,2,iBarNo+1);
      
      //高値、安値、終値
      double dHigh=High[iBarNo+1];
      double dLow=Low[iBarNo+1];
      double dClose=Close[iBarNo];

//トレード中の場合
   if(IsInit==false)
     {      
      //新規ポジション取得
      if(IsExistPosition()==false)
        {

         //買いポジション取得
         if(sSignal==SIGNALBUY && 
         CheckSMBlueSpan(iBarNo)==SIGNALSELL &&
         dLowMnus2Sigma>dClose)
           {
            PositionOpenBuy(STOPLOSS_SCL);
           }

         //売りポジション取得
         else if(sSignal==SIGNALSELL && 
         CheckSMBlueSpan(iBarNo)==SIGNALBUY &&
          dLowPlus2Sigma<dClose)
           {
            PositionOpenSell(STOPLOSS_SCL);
           }
        }

      //手仕舞い
      else
        {
         if(sSignal==SIGNALBUY && dLowPlus2Sigma<dClose)
           {
            //買いポジションクローズ
            PositionCloseAll();
           }
         else if(sSignal==SIGNALSELL && dLowMnus2Sigma>dClose)
           {
            //売りポジションクローズ
            PositionCloseAll();
           }
        }
     }

//初期化処理の場合
   else
     {
      //新規ポジション取得
      if(SessionIsExistScalpPos==false)
        {

         //買いポジション取得
         if(sSignal==SIGNALBUY && 
         CheckSMBlueSpan(iBarNo)==SIGNALSELL &&
          dLowPreMnus2Sigma>dLow)
           {
            SessionIsExistScalpPos=true;
           }

         //売りポジション取得
         else if(sSignal==SIGNALSELL && 
         CheckSMBlueSpan(iBarNo)==SIGNALBUY &&
          dLowPrePlus2Sigma<dHigh)
           {
            SessionIsExistScalpPos=true;
           }

         TrailLog("INFO",CLASSNAME5,sProcessName,"MSG0035",iBarNo);
        }

      //手仕舞い
      else
        {
         SetObjSMTSignal(SessionOpenSignal,SMTVPRICE11,iBarNo+1);
         if(sSignal==SIGNALBUY && dLowPrePlus2Sigma<dHigh)
           {
            //買いポジションクローズ
            SessionIsExistScalpPos=false;
           }
         else if(sSignal==SIGNALSELL && dLowPreMnus2Sigma>dLow)
           {
            //売りポジションクローズ
            SessionIsExistScalpPos=false;
           }

         TrailLog("INFO",CLASSNAME5,sProcessName,"MSG0036",iBarNo);
        }
     }
//処理終了ログ出力
   TrailLog("INFO",CLASSNAME5,sProcessName,"MSG0034",iBarNo);
   return;
  }

//+------------------------------------------------------------------+
