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
//| 1シグマライン決済シグナルチェック                                          |
//+------------------------------------------------------------------+
bool CheckCloseSignal_SB1SigmaLine(string sSignal,
                                   double dPlus1Sigma,
                                   double dMnus1Sigma,
                                   double dH1ClosePrice,
                                   int iBarNo) export
  {
   bool bClosed=false;

//決済シグナル確認
   if(sSignal==SIGNALBUY && dPlus1Sigma>=dH1ClosePrice)
     {
      bClosed=true;
     }
   else if(sSignal==SIGNALSELL && dMnus1Sigma<=dH1ClosePrice)
     {
      bClosed=true;
     }
   return bClosed;

  }
//+------------------------------------------------------------------+
//| スーパーボリンジャー±3シグマ逆行チェック                                    |
//+------------------------------------------------------------------+
bool CheckCloseSignal_SB3SLAgainst(string sSignal,
                                   double dPrePlus3Sigma,
                                   double dPlus3Sigma,
                                   double dPreMnus3Sigma,
                                   double dMnus3Sigma,
                                   int iBarNo) export
  {

   bool bClosed=false;

///決済シグナル確認
   if(sSignal==SIGNALBUY && dPrePlus3Sigma>=dPlus3Sigma)
     {
      bClosed=true;
     }
   if(sSignal==SIGNALSELL && dPreMnus3Sigma<=dMnus3Sigma)
     {
      bClosed=true;
     }
   return bClosed;
  }
//+------------------------------------------------------------------+
//| 移動平均線決済シグナルチェック                                          |
//+------------------------------------------------------------------+
bool CheckCloseSignal_SBSimpleMA(string sSignal,
                                 double dClose,
                                 double dSimpleMA,
                                 int iBarNo) export
  {

   bool bClosed=false;
//決済シグナル確認
   if((sSignal==SIGNALBUY || sSignal==UPPERTREND) && 
      dSimpleMA>=dClose)
     {
      bClosed=true;
     }
   if((sSignal==SIGNALSELL || sSignal==DOWNERTREND) && 
      dSimpleMA<=dClose)
     {
      bClosed=true;
     }
   return bClosed;

  }
//+------------------------------------------------------------------+
//| スーパーボリンジャー移動平均線チェック                                    |
//+------------------------------------------------------------------+
string CheckSBSimpleMA(double dPreSimpleMA,
                       double dSimpleMA,
                       int iBarNo) export
  {

   string sRtnSignal=NOSIGNAL;

//移動平均線が上昇傾向で、終値が移動平均線より上
   if(dPreSimpleMA<dSimpleMA) sRtnSignal=SIGNALBUY;

//移動平均線が下降傾向で、終値が移動平均線より下
   else if(dPreSimpleMA>dSimpleMA) sRtnSignal=SIGNALSELL;

   return sRtnSignal;
  }
//+------------------------------------------------------------------+
//| スーパーボリンジャーシグマラインチェック                         |
//+------------------------------------------------------------------+
string CheckSBSigmaLine(double dH1ClosePrice,
                        double dPlus1Sigma,
                        double dMnus1Sigma,
                        int iBarNo) export
  {
   string sRtnSignal=NOSIGNAL;

//買いシグナルの場合
   if(dH1ClosePrice>dPlus1Sigma) sRtnSignal=SIGNALBUY;

//売りシグナルの場合
   else if(dH1ClosePrice<dMnus1Sigma) sRtnSignal=SIGNALSELL;

   return sRtnSignal;

  }
//+------------------------------------------------------------------+
//| スーパーボリンジャー遅行スパン&高値or安値チェック                         |
//+------------------------------------------------------------------+
string CheckSBDelayedSpan_HighAndLow(double dH1Highest,
                                     double dH1Lowest,
                                     double dH1ClosePrice,
                                     int iBarNo) export
  {

   string sRtnSignal=NOSIGNAL;

//買いシグナル点灯
   if(dH1Highest<dH1ClosePrice) sRtnSignal=SIGNALBUY;

//売りシグナル点灯
   else if(dH1Lowest>dH1ClosePrice) sRtnSignal=SIGNALSELL;

   return sRtnSignal;
  }
//+------------------------------------------------------------------+
//| スーパーボリンジャー遅行スパン&シグマラインチェック                         |
//+------------------------------------------------------------------+
string CheckSBDelayedSpan_SigmaLine(double dH1ClosePrice,
                                    double dHighestPlusSigma22,
                                    double dLowestMnusSigma22,
                                    int iBarNo) export
  {

   string sRtnSignal=NOSIGNAL;

//買いシグナル点灯
   if(dH1ClosePrice>dHighestPlusSigma22) sRtnSignal=SIGNALBUY;

//売りシグナル点灯
   else if(dH1ClosePrice<dLowestMnusSigma22) sRtnSignal=SIGNALSELL;

   return sRtnSignal;
  }
//+------------------------------------------------------------------+
//| スーパーボリンジャーバンド幅縮小チェック                                    |
//+------------------------------------------------------------------+
string CheckSBBandShrink(double dPrePlus2Sigma,
                         double dPrePlus3Sigma,
                         double dPlus2Sigma,
                         double dPlus3Sigma,
                         double dPreMnus2Sigma,
                         double dPreMnus3Sigma,
                         double dMnus2Sigma,
                         double dMnus3Sigma,
                         int iBarNo) export
  {

   string sRtnSignal=NOSIGNAL;

//バーの位置
   int iPreUpperPeriodBarNo=Adjust_BarNo+iBarNo+1;

//バンド幅縮小チェック
   if(//dPrePlus1Sigma>=dPlus1Sigma &&
      dPrePlus2Sigma>dPlus2Sigma && 
      dPrePlus3Sigma>dPlus3Sigma && 
      //dPreMnus1Sigma<=dMnus1Sigma &&
      dPreMnus2Sigma<dMnus2Sigma && 
      dPreMnus3Sigma<dMnus3Sigma)
     {
      sRtnSignal=SHRINK;
     }

   return sRtnSignal;
  }
//+------------------------------------------------------------------+
//| スーパーボリンジャーバンド幅拡大チェック                                    |
//+------------------------------------------------------------------+
string CheckSBBandExpand(string sSBMASignal,
                         double dPrePlus3Sigma,
                         double dPrePlus2Sigma,
                         double dPrePlus1Sigma,
                         double dPlus3Sigma,
                         double dPlus2Sigma,
                         double dPlus1Sigma,
                         double dPreMnus3Sigma,
                         double dPreMnus2Sigma,
                         double dPreMnus1Sigma,
                         double dMnus3Sigma,
                         double dMnus2Sigma,
                         double dMnus1Sigma,
                         int iBarNo) export
  {

   string sRtnSignal=NOSIGNAL;

//バンド幅拡大チェック
/*
   if(dPrePlus3Sigma<dPlus3Sigma && 
      dPrePlus2Sigma<dPlus2Sigma && 
      dPrePlus1Sigma<=dPlus1Sigma && 
      dPreMnus3Sigma>dMnus3Sigma && 
      dPreMnus2Sigma>dMnus2Sigma && 
      dPreMnus1Sigma>=dMnus1Sigma)
*/
   if(dPrePlus3Sigma<dPlus3Sigma && 
      dPreMnus3Sigma>dMnus3Sigma)
     {
      //移動平均線が上昇の場合は買いシグナル
      if(sSBMASignal==SIGNALBUY) sRtnSignal=SIGNALBUY;

      //移動平均線が下降の場合は売りシグナル
      if(sSBMASignal==SIGNALSELL) sRtnSignal=SIGNALSELL;

     }
   return sRtnSignal;
  }
//+------------------------------------------------------------------+
//| スーパーボリンジャーの値を取得                                 |
//+------------------------------------------------------------------+
bool GetSuperBolingerRate(SuperBolingerRate &sbr,int iBarNo) export
  {
   int i=iBarNo;
   datetime dDateTime = 0;
   
   //1時間足の変更時間検索
   while(i<iBarNo+Adjust_BarNo)
   {
    dDateTime = Time[i];
    if(TimeHour(dDateTime) != TimeHour(Time[i+1])) break;
    i++;
   }

   int iShiftBarNo=iBarShift(NULL,PERIOD_H1,dDateTime,false);

//移動平均線の値
   sbr.dSimpleMA=iBands(NULL,PERIOD_H1,21,0,0,PRICE_CLOSE,0,iShiftBarNo);

//+1シグマラインの値
   sbr.dPlus1Sigma=iBands(NULL,PERIOD_H1,21,1,0,PRICE_CLOSE,1,iShiftBarNo);

//-1シグマラインの値
   sbr.dMnus1Sigma=iBands(NULL,PERIOD_H1,21,1,0,PRICE_CLOSE,2,iShiftBarNo);

//+2シグマラインの値
   sbr.dPlus2Sigma=iBands(NULL,PERIOD_H1,21,2,0,PRICE_CLOSE,1,iShiftBarNo);

//-2シグマラインの値
   sbr.dMnus2Sigma=iBands(NULL,PERIOD_H1,21,2,0,PRICE_CLOSE,2,iShiftBarNo);

//+3シグマラインの値
   sbr.dPlus3Sigma=iBands(NULL,PERIOD_H1,21,3,0,PRICE_CLOSE,1,iShiftBarNo);

//-3シグマラインの値
   sbr.dMnus3Sigma=iBands(NULL,PERIOD_H1,21,3,0,PRICE_CLOSE,2,iShiftBarNo);

//遅行スパンの値
  sbr.dDelayedSpan=iClose(NULL,PERIOD_H1,iShiftBarNo);
   return true;
  }
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
