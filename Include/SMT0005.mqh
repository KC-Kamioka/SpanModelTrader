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
#include <SMT0003.mqh>

bool IsExistRangePos=false;
//+------------------------------------------------------------------+
//| スキャルピング                                                                 |
//+------------------------------------------------------------------+
void Scalping(string sSignal,bool IsInit,int iBarNo)
  {

//処理開始ログ出力
   string sProcessName="Scalping";
   TrailLog("INFO",CLASSNAME5,sProcessName,"MSG0033",iBarNo);

//ボリンジャーバンドの値
   double dLowPlus2Sigma=iBands(NULL,PERIOD_M5,21,2,0,PRICE_CLOSE,1,iBarNo);
   double dLowMnus2Sigma=iBands(NULL,PERIOD_M5,21,2,0,PRICE_CLOSE,2,iBarNo);

//新規ポジション取得
   if(SessionIsExistScalpPos==false)
     {
      //買いシグナル点灯中
      if(sSignal==SIGNALBUY)
        {
         if(dLowMnus2Sigma>Low[iBarNo])
           {
            if(IsInit==false)PositionOpenBuy(STOPLOSS_SCL);
            SessionIsExistScalpPos=true;
           }
        }

      //売りポジション取得
      else if(sSignal==SIGNALSELL)
        {
         if(dLowPlus2Sigma<High[iBarNo])
           {
            if(IsInit==false)PositionOpenSell(STOPLOSS_SCL);
            SessionIsExistScalpPos=true;
           }
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
//| レンジトレード                                                     |
//+------------------------------------------------------------------+
void RangeTrade(bool IsInit,int iBarNo)
  {

//処理開始ログ出力
   string sProcessName="RangeTrade";
   TrailLog("INFO",CLASSNAME5,sProcessName,"MSG0033",iBarNo);
/*
//デバッグ
if(IsExistRangePos==false && SessionOpenRangeSignal!=NOSIGNAL)
{
Print("ポジションありフラグ不一致");
}
if(IsExistRangePos==true && SessionOpenRangeSignal==NOSIGNAL)
{
Print("ポジションありフラグ不一致");
}
*/
//新規ポジション取得
   if(IsExistRangePos==false)
     {
      if(dMnus2Sigma>Low[iBarNo])
        {
         if(IsInit==false)PositionOpenBuy(STOPLOSS_SCL);
         SessionOpenRangeSignal=SIGNALBUY;
         IsExistRangePos=true;
        }

      if(dPlus2Sigma<High[iBarNo])
        {
         if(IsInit==false)PositionOpenSell(STOPLOSS_SCL);
         SessionOpenRangeSignal=SIGNALSELL;
         IsExistRangePos=true;
        }
     }
     
//手仕舞い
   else
     {
      if(SessionOpenRangeSignal==SIGNALBUY && dMnus1Sigma<High[iBarNo])
        {
         //買いポジションクローズ
         if(IsInit==false)PositionCloseAll();
         SessionOpenRangeSignal=NOSIGNAL;
         IsExistRangePos=false;
        }
      else if(SessionOpenRangeSignal==SIGNALSELL && dPlus1Sigma>Low[iBarNo])
        {
         //売りポジションクローズ
         if(IsInit==false)PositionCloseAll();
         SessionOpenRangeSignal=NOSIGNAL;
         IsExistRangePos=false;
        }
      else
        {
         SetObjSMTSignal(SessionOpenRangeSignal,SMTVPRICE11,iBarNo);
        }
     }

//処理終了ログ出力
   TrailLog("INFO",CLASSNAME5,sProcessName,"MSG0034",iBarNo);
   return;
  }
//+------------------------------------------------------------------+
