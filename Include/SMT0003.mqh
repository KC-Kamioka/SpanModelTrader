//+------------------------------------------------------------------+
//|                                                      SMT0003.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

//+------------------------------------------------------------------+
//| ライブラリ                                                       |
//+------------------------------------------------------------------+
#include <SMT0001.mqh>

//上位時間遅行スパンのバーの位置
#define UPPERDELAYEDSPANBARNO 263

//+------------------------------------------------------------------+
//| 変数                                                             |
//+------------------------------------------------------------------+
static int Adjust_BarNo=12;  //一時間足バー補正
int iH1OpenBarNo=Adjust_BarNo;
int iH1CloseBarNo=Adjust_BarNo;
int iPreH1CloseBarNo=Adjust_BarNo*2;
int iH1CloseBarNo22=UPPERDELAYEDSPANBARNO+iH1CloseBarNo;
int iPreH1CloseBarNo22=UPPERDELAYEDSPANBARNO+iPreH1CloseBarNo;
double dH1OpenPrice=0;
double dPreH1OpenPrice=0;
double dH1ClosePrice=0;
double dPreH1ClosePrice=0;
double dH1ClosePrice22=0;
double dPreH1ClosePrice22=0;
double dH1Highest=0;
double dH1Lowest=0;
double dPreSimpleMA=0;
double dSimpleMA=0;
double dPrePlus1Sigma=0;
double dPlus1Sigma=0;
double dPreMnus1Sigma=0;
double dMnus1Sigma=0;
double dPrePlus2Sigma=0;
double dPlus2Sigma=0;
double dPreMnus2Sigma=0;
double dMnus2Sigma=0;
double dPrePlus3Sigma=0;
double dPlus3Sigma=0;
double dPreMnus3Sigma=0;
double dMnus3Sigma=0;
double dPlusSigma22=0;
double dMnusSigma22=0;
//+------------------------------------------------------------------+
//| スーパーボリンジャーの値をセット                                                             |
//+------------------------------------------------------------------+
void SetNewSBPrice(int iBarNo) export
  {

   string sSymbol=Symbol();

//始値
   dH1OpenPrice=iOpenMTF(sSymbol,iH1OpenBarNo+iBarNo);

//終値
   dH1ClosePrice=iCloseMTF(sSymbol,iH1CloseBarNo+iBarNo);

//1つ前の終値
   dPreH1ClosePrice=iCloseMTF(sSymbol,iPreH1CloseBarNo+iBarNo);

//22本前の終値
   dH1ClosePrice22=iCloseMTF(sSymbol,iH1CloseBarNo22+iBarNo);

//１つ前の22本前の終値
   dPreH1ClosePrice22=iCloseMTF(sSymbol,iPreH1CloseBarNo22+iBarNo);

//高値
   dH1Highest=iClose(sSymbol,PERIOD_H1,iHighestMTF(sSymbol,iPreH1CloseBarNo+iBarNo));

//安値
   dH1Lowest=iClose(sSymbol,PERIOD_H1,iLowestMTF(sSymbol,iPreH1CloseBarNo+iBarNo));

//１つ前の移動平均線の値
   dPreSimpleMA=iBandsMTF(sSymbol,SB_SIMPLEMA,iPreH1CloseBarNo+iBarNo);

//移動平均線の値
   dSimpleMA=iBandsMTF(sSymbol,SB_SIMPLEMA,iH1CloseBarNo+iBarNo);

//１つ前の+1シグマラインの値
   dPrePlus1Sigma=iBandsMTF(sSymbol,SB_PLUS1SIGMA,iPreH1CloseBarNo+iBarNo);

//+1シグマラインの値
   dPlus1Sigma=iBandsMTF(sSymbol,SB_PLUS1SIGMA,iH1CloseBarNo+iBarNo);

//１つ前の-1シグマラインの値
   dPreMnus1Sigma=iBandsMTF(sSymbol,SB_MNUS1SIGMA,iPreH1CloseBarNo+iBarNo);

//-1シグマラインの値
   dMnus1Sigma=iBandsMTF(sSymbol,SB_MNUS1SIGMA,iH1CloseBarNo+iBarNo);

//１つ前の+2シグマラインの値
   dPrePlus2Sigma=iBandsMTF(sSymbol,SB_PLUS2SIGMA,iPreH1CloseBarNo+iBarNo);

//+2シグマラインの値
   dPlus2Sigma=iBandsMTF(sSymbol,SB_PLUS2SIGMA,iH1CloseBarNo+iBarNo);

//１つ前の-2シグマラインの値
   dPreMnus2Sigma=iBandsMTF(sSymbol,SB_MNUS2SIGMA,iPreH1CloseBarNo+iBarNo);

//-2シグマラインの値
   dMnus2Sigma=iBandsMTF(sSymbol,SB_MNUS2SIGMA,iH1CloseBarNo+iBarNo);

//１つ前の+3シグマラインの値
   dPrePlus3Sigma=iBandsMTF(sSymbol,SB_PLUS3SIGMA,iPreH1CloseBarNo+iBarNo);

//+3シグマラインの値
   dPlus3Sigma=iBandsMTF(sSymbol,SB_PLUS3SIGMA,iH1CloseBarNo+iBarNo);

//１つ前の-3シグマラインの値
   dPreMnus3Sigma=iBandsMTF(sSymbol,SB_MNUS3SIGMA,iPreH1CloseBarNo+iBarNo);

//-3シグマラインの値
   dMnus3Sigma=iBandsMTF(sSymbol,SB_MNUS3SIGMA,iH1CloseBarNo+iBarNo);

//22本前のシグマラインの値
   dPlusSigma22=iBandsMTF(sSymbol,SB_PLUS1SIGMA,iH1CloseBarNo22+iBarNo);

//22本前のシグマラインの値
   dMnusSigma22=iBandsMTF(sSymbol,SB_MNUS1SIGMA,iH1CloseBarNo22+iBarNo);

   return;
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
//| 一時間足のスーパーボリンジャーバンドの値取得                                                  |
//+------------------------------------------------------------------+
double iBandsMTF(string sSymbol,int iLineNo,int iBarNo)
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
//| スーパーボリンジャー遅行スパンクロスチェック                                    |
//+------------------------------------------------------------------+
string CheckSBDSpanCross(int iBarNo) export
  {

   string sRtnSignal=NOSIGNAL;

///シグナル確認
   if(dPreH1ClosePrice22>=dPreH1ClosePrice && dH1ClosePrice22<dH1ClosePrice)
     {
      sRtnSignal=CHKSTART;
     }
   else if(dPreH1ClosePrice22<=dPreH1ClosePrice && dH1ClosePrice22>dH1ClosePrice)
     {
      sRtnSignal=CHKSTART;
     }

   return sRtnSignal;
  }
//+------------------------------------------------------------------+
//| スーパーボリンジャー移動平均線チェック                                    |
//+------------------------------------------------------------------+
string CheckSBSimpleMA(int iBarNo) export
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
string CheckSBSigmaLine(int iBarNo) export
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
string CheckSBDelayedSpan_HighAndLow(int iBarNo) export
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
string CheckSBDelayedSpan_SigmaLine(int iBarNo) export
  {

   string sRtnSignal=NOSIGNAL;

//買いシグナル点灯
   if(dH1ClosePrice>dPlusSigma22) sRtnSignal=SIGNALBUY;

//売りシグナル点灯
   else if(dH1ClosePrice<dMnusSigma22) sRtnSignal=SIGNALSELL;

   return sRtnSignal;
  }
//+------------------------------------------------------------------+
//| スーパーボリンジャーバンド幅縮小チェック                                    |
//+------------------------------------------------------------------+
string CheckSBBandShrink(int iBarNo) export
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
string CheckSBBandExpand(int iBarNo) export
  {

   string sRtnSignal=NOSIGNAL;

//バンド幅拡大チェック
   if(dPrePlus3Sigma<dPlus3Sigma && 
      dPrePlus2Sigma<dPlus2Sigma && 
      dPrePlus1Sigma<=dPlus1Sigma && 
      dPreMnus3Sigma>dMnus3Sigma && 
      dPreMnus2Sigma>dMnus2Sigma && 
      dPreMnus1Sigma>=dMnus1Sigma)
     {
      //移動平均線が上昇の場合は買いシグナル
      if(SessionSBMASignal==SIGNALBUY) sRtnSignal=SIGNALBUY;

      //移動平均線が下降の場合は売りシグナル
      if(SessionSBMASignal==SIGNALSELL) sRtnSignal=SIGNALSELL;

     }
   return sRtnSignal;
  }


//+------------------------------------------------------------------+
//| 移動平均線決済シグナルチェック                                          |
//+------------------------------------------------------------------+
bool CheckCloseSignal_SBSimpleMA(string sSignal,int iBarNo) export
  {

   bool bClosed=false;

//決済シグナル確認
   if(sSignal==SIGNALBUY && dPreSimpleMA>=dSimpleMA)
     {
      bClosed=true;
     }
   else if(sSignal==SIGNALSELL && dPreSimpleMA<=dSimpleMA)
     {
      bClosed=true;
     }
   return bClosed;

  }
//+------------------------------------------------------------------+
//| スーパーボリンジャー±3シグマ逆行チェック                                    |
//+------------------------------------------------------------------+
bool CheckCloseSignal_SB3SLAgainst(string sSignal,int iBarNo) export
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
//| 1シグマライン決済シグナルチェック                                          |
//+------------------------------------------------------------------+
bool CheckCloseSignal_SB1SigmaLine(string sSignal,int iBarNo) export
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
//| ±2シグマライン決済シグナルチェック                                          |
//+------------------------------------------------------------------+
bool CheckCloseSignal_SB2SigmaLine(string sSignal,int iBarNo) export
  {

   bool bClosed=false;

//決済シグナル確認
   if(sSignal==SIGNALBUY && dPlus2Sigma<=dH1ClosePrice)
     {
      bClosed=true;
     }
   else if(sSignal==SIGNALSELL && dMnus2Sigma>=dH1ClosePrice)
     {
      bClosed=true;
     }
   return bClosed;
  }
//+------------------------------------------------------------------+
//| ±3シグマライン決済シグナルチェック                                        |
//+------------------------------------------------------------------+
bool CheckCloseSignal_OverSB3SigmaLine(string sSignal,int iBarNo) export
  {

   bool bClosed=false;

///決済シグナル確認
   if(sSignal==SIGNALBUY)
     {
      if(dPlus3Sigma<dH1ClosePrice)
        {
         bClosed=true;
        }
     }
   else if(sSignal==SIGNALSELL)
     {
      if(dMnus3Sigma>dH1ClosePrice)
        {
         bClosed=true;
        }
     }
   return bClosed;
  }
//+------------------------------------------------------------------+
//| スーパーボリンジャーバンド幅縮小チェック                                    |
//+------------------------------------------------------------------+
bool CheckCloseSignal_SB3SLShrink(int iBarNo) export
  {
   bool bClosed=false;

///決済シグナル確認
   if(dPrePlus3Sigma>=dPlus3Sigma && dPreMnus3Sigma<=dMnus3Sigma)
     {
      bClosed=true;
     }
   return bClosed;
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
