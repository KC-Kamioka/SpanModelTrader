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
//| スーパーボリンジャーの値をセット                                 |
//+------------------------------------------------------------------+
SuperBolingerPrice SetNewSBPrice(int iBarNo) export
  {

   string sSymbol=Symbol();

   SuperBolingerPrice sbp;

//始値
   sbp.dH1OpenPrice=iOpenMTF(sSymbol,iH1OpenBarNo+iBarNo);

//終値
   sbp.dH1ClosePrice=iCloseMTF(sSymbol,iH1CloseBarNo+iBarNo);

//1つ前の終値
   sbp.dPreH1ClosePrice=iCloseMTF(sSymbol,iPreH1CloseBarNo+iBarNo);

//22本前の終値
   sbp.dH1ClosePrice22=iCloseMTF(sSymbol,iH1CloseBarNo22+iBarNo);

//１つ前の22本前の終値
   sbp.dPreH1ClosePrice22=iCloseMTF(sSymbol,iPreH1CloseBarNo22+iBarNo);

//高値
   sbp.dH1Highest=iClose(sSymbol,PERIOD_H1,iHighestMTF(sSymbol,iPreH1CloseBarNo+iBarNo));

//安値
   sbp.dH1Lowest=iClose(sSymbol,PERIOD_H1,iLowestMTF(sSymbol,iPreH1CloseBarNo+iBarNo));

//１つ前の移動平均線の値
   sbp.dPreSimpleMA=iBandsMTF(sSymbol,SB_SIMPLEMA,iPreH1CloseBarNo+iBarNo);

//移動平均線の値
   sbp.dSimpleMA=iBandsMTF(sSymbol,SB_SIMPLEMA,iH1CloseBarNo+iBarNo);

//１つ前の+1シグマラインの値
   sbp.dPrePlus1Sigma=iBandsMTF(sSymbol,SB_PLUS1SIGMA,iPreH1CloseBarNo+iBarNo);

//+1シグマラインの値
   sbp.dPlus1Sigma=iBandsMTF(sSymbol,SB_PLUS1SIGMA,iH1CloseBarNo+iBarNo);

//１つ前の-1シグマラインの値
   sbp.dPreMnus1Sigma=iBandsMTF(sSymbol,SB_MNUS1SIGMA,iPreH1CloseBarNo+iBarNo);

//-1シグマラインの値
   sbp.dMnus1Sigma=iBandsMTF(sSymbol,SB_MNUS1SIGMA,iH1CloseBarNo+iBarNo);

//１つ前の+2シグマラインの値
   sbp.dPrePlus2Sigma=iBandsMTF(sSymbol,SB_PLUS2SIGMA,iPreH1CloseBarNo+iBarNo);

//+2シグマラインの値
   sbp.dPlus2Sigma=iBandsMTF(sSymbol,SB_PLUS2SIGMA,iH1CloseBarNo+iBarNo);

//１つ前の-2シグマラインの値
   sbp.dPreMnus2Sigma=iBandsMTF(sSymbol,SB_MNUS2SIGMA,iPreH1CloseBarNo+iBarNo);

//-2シグマラインの値
   sbp.dMnus2Sigma=iBandsMTF(sSymbol,SB_MNUS2SIGMA,iH1CloseBarNo+iBarNo);

//１つ前の+3シグマラインの値
   sbp.dPrePlus3Sigma=iBandsMTF(sSymbol,SB_PLUS3SIGMA,iPreH1CloseBarNo+iBarNo);

//+3シグマラインの値
   sbp.dPlus3Sigma=iBandsMTF(sSymbol,SB_PLUS3SIGMA,iH1CloseBarNo+iBarNo);

//１つ前の-3シグマラインの値
   sbp.dPreMnus3Sigma=iBandsMTF(sSymbol,SB_MNUS3SIGMA,iPreH1CloseBarNo+iBarNo);

//-3シグマラインの値
   sbp.dMnus3Sigma=iBandsMTF(sSymbol,SB_MNUS3SIGMA,iH1CloseBarNo+iBarNo);

//22本前のシグマラインの値
   sbp.dPlusSigma22=iBandsMTF(sSymbol,SB_PLUS2SIGMA,iH1CloseBarNo22+iBarNo);

//22本前のシグマラインの値
   sbp.dMnusSigma22=iBandsMTF(sSymbol,SB_MNUS2SIGMA,iH1CloseBarNo22+iBarNo);

//22本前のシグマラインの値
   sbp.dHighestPlusSigma22=iHighestPlusSigma22MTF(sSymbol,iPreH1CloseBarNo+iBarNo);

//22本前のシグマラインの値
   sbp.dLowestMnusSigma22=iLowestMnusSigma22MTF(sSymbol,iPreH1CloseBarNo+iBarNo);

   return sbp;
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
