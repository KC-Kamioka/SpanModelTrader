//+------------------------------------------------------------------+
//|                                                      SMT0003.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property library
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

//+------------------------------------------------------------------+
//| ライブラリ                                                       |
//+------------------------------------------------------------------+
#include <SMT0001.mqh>
//+------------------------------------------------------------------+
//| 一時間足の時間取得                                                 |
//+------------------------------------------------------------------+
datetime iTimeMTF(string sSymbol,int iBarNo) export
  {
   int iShiftBarNo=iBarShift(sSymbol,PERIOD_H1,Time[iBarNo]);
   datetime dtCloseTime=iTime(sSymbol,PERIOD_H1,iShiftBarNo);
   return dtCloseTime;
  }
//+------------------------------------------------------------------+
//| 一時間足の終値取得                                                 |
//+------------------------------------------------------------------+
double iOpenMTF(string sSymbol,int iBarNo) export
  {
   int iShiftBarNo=iBarShift(sSymbol,PERIOD_H1,Time[iBarNo]);
   double dOpen=iOpen(sSymbol,PERIOD_H1,iShiftBarNo);
   return dOpen;
  }
//+------------------------------------------------------------------+
//| 一時間足の終値取得                                                 |
//+------------------------------------------------------------------+
double iCloseMTF(string sSymbol,int iBarNo) export
  {
   int iShiftBarNo=iBarShift(sSymbol,PERIOD_H1,Time[iBarNo]);
   double dClose=iClose(sSymbol,PERIOD_H1,iShiftBarNo);
   return dClose;
  }
//+------------------------------------------------------------------+
//| 一時間足の高値のバーの位置                                                  |
//+------------------------------------------------------------------+
int iHighestMTF(string sSymbol,int iBarNo) export
  {
   int i=0;
   int iShiftBarNo=iBarShift(sSymbol,PERIOD_H1,Time[iBarNo]);
   int iRtnBarNo=iShiftBarNo;
   double dHighestClose=iClose(sSymbol,PERIOD_H1,iShiftBarNo);
   double dTmpClose=0;
   while(i<UPPERSENKOSEN)
     {
      iShiftBarNo=iBarShift(sSymbol,PERIOD_H1,Time[iBarNo]);
      dTmpClose=iClose(sSymbol,PERIOD_H1,iShiftBarNo);
      if(dHighestClose<dTmpClose) iRtnBarNo=iShiftBarNo;
      iBarNo=iBarNo+Adjust_BarNo;
      i=i+1;
     }
   return iRtnBarNo;
  }
//+------------------------------------------------------------------+
//| 一時間足の安値取得                                                  |
//+------------------------------------------------------------------+
int iLowestMTF(string sSymbol,int iBarNo) export
  {
   int i=0;
   int iShiftBarNo=iBarShift(sSymbol,PERIOD_H1,Time[iBarNo]);
   int iRtnBarNo=iShiftBarNo;
   double dLowestClose=iClose(sSymbol,PERIOD_H1,iShiftBarNo);
   double dTmpClose=0;
   while(i<UPPERSENKOSEN)
     {
      iShiftBarNo=iBarShift(sSymbol,PERIOD_H1,Time[iBarNo]);
      dTmpClose=iClose(sSymbol,PERIOD_H1,iShiftBarNo);
      if(dLowestClose>dTmpClose) iRtnBarNo=iShiftBarNo;
      iBarNo=iBarNo+Adjust_BarNo;
      i=i+1;
     }
   return iRtnBarNo;
  }
//+------------------------------------------------------------------+
//| 一時間足の高値のバーの位置                                                  |
//+------------------------------------------------------------------+
double iHighestPlusSigma22MTF(string sSymbol,int iBarNo) export
  {
   int i=0;
   int iShiftBarNo=iBarShift(sSymbol,PERIOD_H1,Time[iBarNo]);
   int iRtnBarNo=iShiftBarNo;
   double dHighestClose=iBands(sSymbol,PERIOD_H1,21,3,0,PRICE_CLOSE,1,iShiftBarNo);
   double dTmpClose=0;
   while(i<UPPERSENKOSEN)
     {
      iShiftBarNo=iBarShift(sSymbol,PERIOD_H1,Time[iBarNo]);
      dTmpClose=iBands(sSymbol,PERIOD_H1,21,3,0,PRICE_CLOSE,1,iShiftBarNo);
      if(dHighestClose<dTmpClose) dHighestClose=dTmpClose;
      iBarNo=iBarNo+Adjust_BarNo;
      i=i+1;
     }
   return dHighestClose;
  }
//+------------------------------------------------------------------+
//| 一時間足の安値取得                                                  |
//+------------------------------------------------------------------+
double iLowestMnusSigma22MTF(string sSymbol,int iBarNo) export
  {
   int i=0;
   int iShiftBarNo=iBarShift(sSymbol,PERIOD_H1,Time[iBarNo]);
   double dLowestClose=iBands(sSymbol,PERIOD_H1,21,3,0,PRICE_CLOSE,2,iShiftBarNo);
   double dTmpClose=0;
   while(i<UPPERSENKOSEN)
     {
      iShiftBarNo=iBarShift(sSymbol,PERIOD_H1,Time[iBarNo]);
      dTmpClose=iBands(sSymbol,PERIOD_H1,21,3,0,PRICE_CLOSE,2,iShiftBarNo);
      if(dLowestClose>dTmpClose) dLowestClose=dTmpClose;
      iBarNo=iBarNo+Adjust_BarNo;
      i=i+1;
     }
   return dLowestClose;
  }
//+------------------------------------------------------------------+
//| 一時間足のスーパーボリンジャーバンドの値取得                               |
//+------------------------------------------------------------------+
double iBandsMTF(string sSymbol,int iLineNo,int iBarNo) export
  {
//
   int iShiftBarNo=iBarShift(sSymbol,PERIOD_H1,Time[iBarNo]);

//移動平均線
   if(iLineNo==SB_SIMPLEMA)
     {
      return iBands(sSymbol,PERIOD_H1,21,0,0,PRICE_CLOSE,0,iShiftBarNo);
     }

//+1シグマライン
   if(iLineNo==SB_PLUS1SIGMA)
     {
      return iBands(sSymbol,PERIOD_H1,21,1,0,PRICE_CLOSE,1,iShiftBarNo);
     }

//-1シグマライン
   if(iLineNo==SB_MNUS1SIGMA)
     {
      return iBands(sSymbol,PERIOD_H1,21,1,0,PRICE_CLOSE,2,iShiftBarNo);
     }

//+2シグマライン
   if(iLineNo==SB_PLUS2SIGMA)
     {
      return iBands(sSymbol,PERIOD_H1,21,2,0,PRICE_CLOSE,1,iShiftBarNo);
     }

//-2シグマライン
   if(iLineNo==SB_MNUS2SIGMA)
     {
      return iBands(sSymbol,PERIOD_H1,21,2,0,PRICE_CLOSE,2,iShiftBarNo);
     }

//+3シグマライン
   if(iLineNo==SB_PLUS3SIGMA)
     {
      return iBands(sSymbol,PERIOD_H1,21,3,0,PRICE_CLOSE,1,iShiftBarNo);
     }

//-3シグマライン
   if(iLineNo==SB_MNUS3SIGMA)
     {
      return iBands(sSymbol,PERIOD_H1,21,3,0,PRICE_CLOSE,2,iShiftBarNo);
     }
   return 0;
  }
//+------------------------------------------------------------------+
//| シグナル継続カウント取得                                      |
//+------------------------------------------------------------------+
int GetSBSLineSignalCount(string sSignal,int iBarNo) export
  {

   int iTrendCount=0;
   if(sSignal==SIGNALBUY)
     {
      int i=0;
      while(i<CHKTRENDKEEP)
        {
         //始値
         double dOpenH1=iOpenMTF(Symbol(),iBarNo);

         //終値
         double dCloseH1=iCloseMTF(Symbol(),iBarNo);

         if(dOpenH1<dCloseH1) iTrendCount=iTrendCount+1;

         iBarNo=iBarNo+Adjust_BarNo;
         i=i+1;
        }
     }
   else if(sSignal==SIGNALSELL)
     {
      int i=0;
      while(i<CHKTRENDKEEP)
        {

         //始値
         double dOpenH1=iOpenMTF(Symbol(),iBarNo);

         //終値
         double dCloseH1=iCloseMTF(Symbol(),iBarNo);

         if(dOpenH1>dCloseH1) iTrendCount=iTrendCount+1;

         iBarNo=iBarNo+Adjust_BarNo;
         i=i+1;
        }
     }
   return iTrendCount;
  }
//+------------------------------------------------------------------+
