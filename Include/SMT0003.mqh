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

#import "SMT0003.ex4"
datetime iTimeMTF(string sSymbol,int iBarNo);
double iOpenMTF(string sSymbol,int iBarNo);
double iCloseMTF(string sSymbol,int iBarNo);
int iHighestMTF(string sSymbol,int iBarNo);
int iLowestMTF(string sSymbol,int iBarNo);
double iHighestPlusSigma22MTF(string sSymbol,int iBarNo);
double iLowestMnusSigma22MTF(string sSymbol,int iBarNo);
double iBandsMTF(string sSymbol,int iLineNo,int iBarNo);
int GetSBSLineSignalCount(string sSignal,int iBarNo);
#import

SuperBolingerPrice sbp;

//+------------------------------------------------------------------+
//| スーパーボリンジャーの値をセット                                 |
//+------------------------------------------------------------------+
void SetNewSBPrice(int iBarNo) export
  {

   string sSymbol=Symbol();

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
   sbp.dPlusSigma22=iBandsMTF(sSymbol,SB_PLUS3SIGMA,iH1CloseBarNo22+iBarNo);

//22本前のシグマラインの値
   sbp.dMnusSigma22=iBandsMTF(sSymbol,SB_MNUS3SIGMA,iH1CloseBarNo22+iBarNo);

//22本前のシグマラインの値
   sbp.dHighestPlusSigma22=iHighestPlusSigma22MTF(sSymbol,iPreH1CloseBarNo+iBarNo);

//22本前のシグマラインの値
   sbp.dLowestMnusSigma22=iLowestMnusSigma22MTF(sSymbol,iPreH1CloseBarNo+iBarNo);

   return;
  }
//+------------------------------------------------------------------+
//| スーパーボリンジャー遅行スパンクロスチェック                                    |
//+------------------------------------------------------------------+
string CheckSBDSpanCross(int iBarNo) export
  {

   string sRtnSignal=NOSIGNAL;

///シグナル確認
   if(sbp.dPreH1ClosePrice22>=sbp.dPreH1ClosePrice && sbp.dH1ClosePrice22<sbp.dH1ClosePrice)
     {
      sRtnSignal=CHKSTART;
     }
   else if(sbp.dPreH1ClosePrice22<=sbp.dPreH1ClosePrice && sbp.dH1ClosePrice22>sbp.dH1ClosePrice)
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
   if(sbp.dPreSimpleMA<sbp.dSimpleMA) sRtnSignal=SIGNALBUY;

//移動平均線が下降傾向で、終値が移動平均線より下
   else if(sbp.dPreSimpleMA>sbp.dSimpleMA) sRtnSignal=SIGNALSELL;

   return sRtnSignal;
  }
//+------------------------------------------------------------------+
//| スーパーボリンジャーシグマラインチェック                         |
//+------------------------------------------------------------------+
string CheckSBSigmaLine(int iBarNo) export
  {
   string sRtnSignal=NOSIGNAL;

//買いシグナルの場合
   if(sbp.dH1ClosePrice>sbp.dPlus1Sigma) sRtnSignal=SIGNALBUY;

//売りシグナルの場合
   else if(sbp.dH1ClosePrice<sbp.dMnus1Sigma) sRtnSignal=SIGNALSELL;

   return sRtnSignal;

  }
//+------------------------------------------------------------------+
//| スーパーボリンジャー遅行スパン&高値or安値チェック                         |
//+------------------------------------------------------------------+
string CheckSBDelayedSpan_HighAndLow(int iBarNo) export
  {

   string sRtnSignal=NOSIGNAL;

//買いシグナル点灯
   if(sbp.dH1Highest<sbp.dH1ClosePrice) sRtnSignal=SIGNALBUY;

//売りシグナル点灯
   else if(sbp.dH1Lowest>sbp.dH1ClosePrice) sRtnSignal=SIGNALSELL;

   return sRtnSignal;
  }
//+------------------------------------------------------------------+
//| スーパーボリンジャー遅行スパン&シグマラインチェック                         |
//+------------------------------------------------------------------+
string CheckSBDelayedSpan_SigmaLine(int iBarNo) export
  {

   string sRtnSignal=NOSIGNAL;

//買いシグナル点灯
   if(sbp.dH1ClosePrice>sbp.dHighestPlusSigma22) sRtnSignal=SIGNALBUY;

//売りシグナル点灯
   else if(sbp.dH1ClosePrice<sbp.dLowestMnusSigma22) sRtnSignal=SIGNALSELL;

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
      sbp.dPrePlus2Sigma>sbp.dPlus2Sigma &&
      sbp.dPrePlus3Sigma>sbp.dPlus3Sigma &&
      //dPreMnus1Sigma<=dMnus1Sigma &&
      sbp.dPreMnus2Sigma<sbp.dMnus2Sigma &&
      sbp.dPreMnus3Sigma<sbp.dMnus3Sigma)
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
   if(sbp.dPrePlus3Sigma<sbp.dPlus3Sigma &&
      sbp.dPrePlus2Sigma<sbp.dPlus2Sigma &&
      sbp.dPrePlus1Sigma<=sbp.dPlus1Sigma && 
      sbp.dPreMnus3Sigma>sbp.dMnus3Sigma &&
      sbp.dPreMnus2Sigma>sbp.dMnus2Sigma &&
      sbp.dPreMnus1Sigma>=sbp.dMnus1Sigma)
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
   if(sSignal==SIGNALBUY && sbp.dPreSimpleMA>=sbp.dSimpleMA)
     {
      bClosed=true;
     }
   else if(sSignal==SIGNALSELL && sbp.dPreSimpleMA<=sbp.dSimpleMA)
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
   if(sSignal==SIGNALBUY && sbp.dPrePlus3Sigma>=sbp.dPlus3Sigma)
     {
      bClosed=true;
     }
   if(sSignal==SIGNALSELL && sbp.dPreMnus3Sigma<=sbp.dMnus3Sigma)
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
   if(sSignal==SIGNALBUY && sbp.dPlus1Sigma>=sbp.dH1ClosePrice)
     {
      bClosed=true;
     }
   else if(sSignal==SIGNALSELL && sbp.dMnus1Sigma<=sbp.dH1ClosePrice)
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
   if(sSignal==SIGNALBUY && sbp.dPlus2Sigma<=sbp.dH1ClosePrice)
     {
      bClosed=true;
     }
   else if(sSignal==SIGNALSELL && sbp.dMnus2Sigma>=sbp.dH1ClosePrice)
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
      if(sbp.dPlus3Sigma<sbp.dH1ClosePrice)
        {
         bClosed=true;
        }
     }
   else if(sSignal==SIGNALSELL)
     {
      if(sbp.dMnus3Sigma>sbp.dH1ClosePrice)
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
   if(sbp.dPrePlus3Sigma>=sbp.dPlus3Sigma && sbp.dPreMnus3Sigma<=sbp.dMnus3Sigma)
     {
      bClosed=true;
     }
   return bClosed;
  }
//+------------------------------------------------------------------+
