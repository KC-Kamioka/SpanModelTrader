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

string sOpenRangeSignal=NOSIGNAL;
//+------------------------------------------------------------------+
//| スキャルピング                                                                 |
//+------------------------------------------------------------------+
void Scalping(string sSignal,bool IsInit,int iBarNo)
  {

//処理開始ログ出力
   string sProcessName="Scalping";
   TrailLog("INFO",CLASSNAME5,sProcessName,"MSG0033",iBarNo);

//高値、安値、終値
   double dHigh=High[iBarNo+1];
   double dLow=Low[iBarNo+1];
   double dClose=Close[iBarNo+1];

//現在値
   double dBuy=0;
   double dSell=0;
   if(IsInit)
     {
      dBuy=High[iBarNo];
      dSell=Low[iBarNo];
     }
   else 
     {
      dBuy=Ask;
      dSell=Bid;
     }

//新規ポジション取得
   if(SessionIsExistScalpPos==false)
     {
      //買いシグナル点灯中
      if(sSignal==SIGNALBUY)
        {
         if(dSimpleMA>dBuy)
           {
            if(IsInit==false)PositionOpenBuy(STOPLOSS_SCL);
            SessionIsExistScalpPos=true;
           }
        }

      //売りポジション取得
      else if(sSignal==SIGNALSELL)
        {
         if(dSimpleMA<dSell)
           {
            if(IsInit==false)PositionOpenSell(STOPLOSS_SCL);
            SessionIsExistScalpPos=true;
           }
        }
     }
//手仕舞い
   else
     {
      SetObjSMTSignal(SessionOpenSignal,SMTVPRICE11,iBarNo);
      if(sSignal==SIGNALBUY && dPlus1Sigma<dSell)
        {
         //買いポジションクローズ
         if(IsInit==false)PositionCloseAll();
         SessionIsExistScalpPos=false;
        }
      else if(sSignal==SIGNALSELL && dMnus1Sigma>dBuy)
        {
         //売りポジションクローズ
         if(IsInit==false)PositionCloseAll();
         SessionIsExistScalpPos=false;
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

//現在値
   double dBuy=0;
   double dSell=0;
   if(IsInit)
     {
      dBuy=High[iBarNo];
      dSell=Low[iBarNo];
     }
   else 
     {
      dBuy=Ask;
      dSell=Bid;
     }

//新規ポジション取得
   if(sOpenRangeSignal==NOSIGNAL)
     {
      if(dMnus2Sigma>dBuy)
        {
         if(IsInit==false)PositionOpenBuy(STOPLOSS_SCL);
         sOpenRangeSignal=SIGNALBUY;
        
        }

      if(dPlus2Sigma<dSell)
        {
         if(IsInit==false)PositionOpenSell(STOPLOSS_SCL);
         sOpenRangeSignal=SIGNALSELL;
   
        }
     }

//手仕舞い
   else
     {
      SetObjSMTSignal(sOpenRangeSignal,SMTVPRICE11,iBarNo);
      if(sOpenRangeSignal==SIGNALBUY && dMnus1Sigma<dSell)
        {
         //買いポジションクローズ
         if(IsInit==false)PositionCloseAll();
         sOpenRangeSignal=NOSIGNAL;
        }
      else if(sOpenRangeSignal==SIGNALSELL && dPlus1Sigma>dBuy)
        {
         //売りポジションクローズ
         if(IsInit==false)PositionCloseAll();
         sOpenRangeSignal=NOSIGNAL;
        }
     }

//処理終了ログ出力
   TrailLog("INFO",CLASSNAME5,sProcessName,"MSG0034",iBarNo);
   return;
  }
//+------------------------------------------------------------------+
