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
void SetNewSBPrice(int iBarNo)
  {
//処理開始ログ出力
   string sProcessName="SetNewSBPrice";
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0033",iBarNo);
   string sRtnSignal=NOSIGNAL;
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
   dH1Highest=iHighestMTF(sSymbol,iPreH1CloseBarNo+iBarNo);

//安値
   dH1Lowest=iLowestMTF(sSymbol,iPreH1CloseBarNo+iBarNo);

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

//処理終了ログ出力
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0034",iBarNo);
   return;
  }
//+------------------------------------------------------------------+
//| 一時間足の時間取得                                                 |
//+------------------------------------------------------------------+
datetime iTimeMTF(string sSymbol,int iBarNo)
  {
   int iShiftBarNo=iBarShift(NULL,PERIOD_H1,Time[iBarNo]);
   datetime dtCloseTime=iTime(NULL,PERIOD_H1,iShiftBarNo);
   return dtCloseTime;
  }
//+------------------------------------------------------------------+
//| 一時間足の終値取得                                                 |
//+------------------------------------------------------------------+
double iOpenMTF(string sSymbol,int iBarNo)
  {
   int iShiftBarNo=iBarShift(sSymbol,PERIOD_H1,Time[iBarNo]);
   double dOpen=iOpen(sSymbol,PERIOD_H1,iShiftBarNo);
   return dOpen;
  }
//+------------------------------------------------------------------+
//| 一時間足の終値取得                                                 |
//+------------------------------------------------------------------+
double iCloseMTF(string sSymbol,int iBarNo)
  {
   int iShiftBarNo=iBarShift(sSymbol,PERIOD_H1,Time[iBarNo]);
   double dClose=iClose(sSymbol,PERIOD_H1,iShiftBarNo);
   return dClose;
  }
//+------------------------------------------------------------------+
//| 一時間足の高値取得                                                  |
//+------------------------------------------------------------------+
double iHighestMTF(string sSymbol,int iBarNo)
  {
   int i=0;
   int iShiftBarNo=iBarShift(sSymbol,PERIOD_H1,Time[iBarNo]);
   double dHighestClose=iClose(sSymbol,PERIOD_H1,iShiftBarNo);
   double dTmpClose=0;
   while(i<UPPERSENKOSEN)
     {
      iShiftBarNo=iBarShift(sSymbol,PERIOD_H1,Time[iBarNo]);
      dTmpClose=iClose(sSymbol,PERIOD_H1,iShiftBarNo);
      if(dHighestClose<dTmpClose) dHighestClose=dTmpClose;
      iBarNo=iBarNo+Adjust_BarNo;
      i=i+1;
     }
   return dHighestClose;
  }
//+------------------------------------------------------------------+
//| 一時間足の安値取得                                                  |
//+------------------------------------------------------------------+
double iLowestMTF(string sSymbol,int iBarNo)
  {
   int i=0;
   int iShiftBarNo=iBarShift(sSymbol,PERIOD_H1,Time[iBarNo]);
   double dLowestClose=iClose(sSymbol,PERIOD_H1,iShiftBarNo);
   double dTmpClose=0;
   while(i<UPPERSENKOSEN)
     {
      iShiftBarNo=iBarShift(sSymbol,PERIOD_H1,Time[iBarNo]);
      dTmpClose=iClose(sSymbol,PERIOD_H1,iShiftBarNo);
      if(dLowestClose>dTmpClose) dLowestClose=dTmpClose;
      iBarNo=iBarNo+Adjust_BarNo;
      i=i+1;
     }
   return dLowestClose;
  }
//+------------------------------------------------------------------+
//| スーパーボリンジャー遅行スパンクロスチェック                                    |
//+------------------------------------------------------------------+
string CheckSBDSpanCross(int iBarNo)
  {
//処理開始ログ出力
   string sProcessName="CheckSBDSpanCross";
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0033",iBarNo);

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

//処理終了ログ出力
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0034",iBarNo);
   return sRtnSignal;
  }
//+------------------------------------------------------------------+
//| スーパーボリンジャー移動平均線チェック                                    |
//+------------------------------------------------------------------+
string CheckSBSimpleMA(int iBarNo)
  {
//処理開始ログ出力
   string sProcessName="CheckSBSimpleMA";
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0033",iBarNo);
   string sRtnSignal=NOSIGNAL;

//移動平均線が上昇傾向で、終値が移動平均線より上
   if(dPreSimpleMA<dSimpleMA && dSimpleMA<dH1ClosePrice)
     {
      sRtnSignal=SIGNALBUY;
      TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0046",iBarNo);
     }

//移動平均線が下降傾向で、終値が移動平均線より下
   else if(dPreSimpleMA>dSimpleMA && dSimpleMA>dH1ClosePrice)
     {
      sRtnSignal=SIGNALSELL;
      TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0047",iBarNo);
     }

//シグナルなし
   else
     {
      sRtnSignal=NOSIGNAL;
      TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0045",iBarNo);
     }

//処理終了ログ出力
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0034",iBarNo);
   return sRtnSignal;
  }
//+------------------------------------------------------------------+
//| スーパーボリンジャーシグマラインチェック                         |
//+------------------------------------------------------------------+
string CheckSBSigmaLine(int iBarNo)
  {
//処理開始ログ出力
   string sProcessName="CheckSBSigmaLine";
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0033",iBarNo);
   string sRtnSignal=NOSIGNAL;

//±3シグマラインが縮小した場合、シグナル消灯
   if(CheckCloseSignal_SB3SLShrink(iBarNo)==true)
     {
      TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0045",iBarNo);

      //処理終了ログ出力
      TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0034",iBarNo);
      return sRtnSignal;
     }

//買いシグナルの場合
//   if(dH1ClosePrice>dSimpleMA)
   if(dH1ClosePrice>dPlus1Sigma)
     {
      sRtnSignal=SIGNALBUY;
      TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0046",iBarNo);
     }

//売りシグナルの場合
//   else if(dH1ClosePrice<dSimpleMA)
   else if(dH1ClosePrice<dMnus1Sigma)
     {
      sRtnSignal=SIGNALSELL;
      TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0047",iBarNo);
     }

//上記以外
   else
     {
      sRtnSignal=NOSIGNAL;
      TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0045",iBarNo);
     }

//処理終了ログ出力
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0034",iBarNo);

   return sRtnSignal;

  }
//+------------------------------------------------------------------+
//| スーパーボリンジャー遅行スパン&高値or安値チェック                         |
//+------------------------------------------------------------------+
string CheckSBDelayedSpan_HighAndLow(int iBarNo)
  {
//処理開始ログ出力
   string sProcessName="CheckSBDelayedSpan_HighAndLow";
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0033",iBarNo);

   string sRtnSignal=NOSIGNAL;

//買いシグナル点灯
   if(dH1Highest<dH1ClosePrice)
     {
      sRtnSignal=SIGNALBUY;
     }

//売りシグナル点灯
   else if(dH1Lowest>dH1ClosePrice)
     {
      sRtnSignal=SIGNALSELL;
     }

//上記以外
   else sRtnSignal=NOSIGNAL;

//処理終了ログ出力
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0034",iBarNo);

   return sRtnSignal;
  }
//+------------------------------------------------------------------+
//| スーパーボリンジャー遅行スパン&シグマラインチェック                         |
//+------------------------------------------------------------------+
string CheckSBDelayedSpan_SigmaLine(int iBarNo)
  {
//処理開始ログ出力
   string sProcessName="CheckSBDelayedSpan_SigmaLine";
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0033",iBarNo);

   string sRtnSignal=NOSIGNAL;

//買いシグナル点灯
   if(dH1ClosePrice>dPlusSigma22)
     {
      sRtnSignal=SIGNALBUY;
     }

//売りシグナル点灯
   else if(dH1ClosePrice<dMnusSigma22)
     {
      sRtnSignal=SIGNALSELL;
     }

//上記以外
   else sRtnSignal=NOSIGNAL;

//処理終了ログ出力
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0034",iBarNo);

   return sRtnSignal;
  }
//+------------------------------------------------------------------+
//| スーパーボリンジャーバンド幅縮小チェック                                    |
//+------------------------------------------------------------------+
string CheckSBBandShrink(int iBarNo)
  {
//処理開始ログ出力
   string sProcessName="CheckSBBandShrink";
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0033",iBarNo);

   string sRtnSignal=NOSIGNAL;

//バーの位置
   int iPreUpperPeriodBarNo=Adjust_BarNo+iBarNo+1;

//バンド幅縮小チェック
   if(dPrePlus1Sigma-dPreMnus1Sigma>=dPlus1Sigma-dMnus1Sigma&&
      dPrePlus2Sigma-dPreMnus2Sigma>=dPlus2Sigma-dMnus2Sigma&&
      dPrePlus3Sigma-dPreMnus3Sigma>=dPlus3Sigma-dMnus3Sigma)
     {
      sRtnSignal=CHKSTART;
      TrailLog("INFO",CLASSNAME3,sProcessName,"バンド幅縮小確認",iBarNo);
     }
//処理終了ログ出力
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0034",iBarNo);

   return sRtnSignal;
  }
//+------------------------------------------------------------------+
//| スーパーボリンジャーバンド幅拡大チェック                                    |
//+------------------------------------------------------------------+
string CheckSBBandExpand(int iBarNo)
  {
//処理開始ログ出力
   string sProcessName="CheckSBBandExpand";
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0033",iBarNo);
   string sRtnSignal=NOSIGNAL;

//バンド幅拡大チェック
/*
   if(dPrePlus1Sigma-dPreMnus1Sigma<dPlus1Sigma-dMnus1Sigma && 
      dPrePlus2Sigma-dPreMnus2Sigma<dPlus2Sigma-dMnus2Sigma && 
      dPrePlus3Sigma<dPlus3Sigma && dPreMnus3Sigma>dMnus3Sigma)
     {
*/
   if(dPrePlus1Sigma-dPreMnus1Sigma<dPlus1Sigma-dMnus1Sigma && 
      dPrePlus2Sigma-dPreMnus2Sigma<dPlus2Sigma-dMnus2Sigma && 
      dPrePlus3Sigma-dPreMnus3Sigma<dPlus3Sigma-dMnus3Sigma)
     {
/*
   if(dPrePlus3Sigma<dPlus3Sigma && 
      dPrePlus2Sigma<dPlus2Sigma && 
      dPrePlus1Sigma<dPlus1Sigma && 
      dPreMnus3Sigma>dMnus3Sigma && 
      dPreMnus2Sigma>dMnus2Sigma && 
      dPreMnus1Sigma>dMnus1Sigma)
     {
*/
      //移動平均線が上昇の場合は買いシグナル
      if(SessionSBMASignal==SIGNALBUY) sRtnSignal=SIGNALBUY;

      //移動平均線が下降の場合は売りシグナル
      if(SessionSBMASignal==SIGNALSELL) sRtnSignal=SIGNALSELL;

     }
//処理終了ログ出力
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0034",iBarNo);
   return sRtnSignal;
  }
//+------------------------------------------------------------------+
//| スキャルピングシグナルチェック                                        |
//+------------------------------------------------------------------+
string CheckSBScalpingSignal(int iBarNo)
  {
//処理開始ログ出力
   string sProcessName="CheckSBScalpingSignal";
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0033",iBarNo);

   string sRtnSignal=NOSIGNAL;

//プラス2シグマラインを上回った場合、売りシグナル点灯
   if(dPrePlus2Sigma>=dPreH1ClosePrice && 
      dPlus2Sigma<dH1ClosePrice)
     {
      sRtnSignal=SIGNALBUY;
     }

//移動平均線を下回った場合、売りシグナル消灯
   else if(dPreSimpleMA<=dPreH1ClosePrice && 
      dSimpleMA>dH1ClosePrice)
        {
         sRtnSignal=NOSIGNAL;
        }

      //マイナス2シグマラインを下回った場合、買いシグナル点灯
      if(dPreMnus2Sigma<=dPreH1ClosePrice && 
         dMnus2Sigma>dH1ClosePrice)
        {
         sRtnSignal=SIGNALBUY;
        }

//移動平均線を上回った場合、買いシグナル消灯
   else if(dPreSimpleMA>=dPreH1ClosePrice && 
      dSimpleMA<dH1ClosePrice)
        {
         sRtnSignal=NOSIGNAL;
        }

      //処理終了ログ出力
      TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0034",iBarNo);

   return sRtnSignal;
  }
//+------------------------------------------------------------------+
//| 移動平均線決済シグナルチェック                                          |
//+------------------------------------------------------------------+
bool CheckCloseSignal_SBSimpleMA(string sSignal,int iBarNo)
  {
//処理開始ログ出力
   string sProcessName="CheckCloseSignal_SBSimpleMA";
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0033",iBarNo);
   bool bClosed=false;

//バーの位置
   int iPreUpperPeriodBarNo=Adjust_BarNo+iBarNo+1;

//決済シグナル確認
   if(sSignal==SIGNALBUY && dSimpleMA>=dH1ClosePrice && 
      dPrePlus3Sigma>=dPlus3Sigma)
     {
      bClosed=true;
      TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0024",iBarNo);
     }
   else if(sSignal==SIGNALSELL && dSimpleMA<=dH1ClosePrice && dPreMnus3Sigma<=dMnus3Sigma)
     {
      bClosed=true;
      TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0025",iBarNo);
     }
//処理終了ログ出力
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0034",iBarNo);
   return bClosed;

  }
//+------------------------------------------------------------------+
//| スーパーボリンジャー±3シグマ逆行チェック                                    |
//+------------------------------------------------------------------+
bool CheckCloseSignal_SB3SLAgainst(string sSignal,int iBarNo)
  {
//処理開始ログ出力
   string sProcessName="CheckCloseSignal_SB3SLAgainst";
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0033",iBarNo);

   bool bClosed=false;

///決済シグナル確認
   if(sSignal==SIGNALBUY && dPrePlus3Sigma>=dPlus3Sigma)
     {
      bClosed=true;
      TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0043",iBarNo);
     }
   if(sSignal==SIGNALSELL && dPreMnus3Sigma<=dMnus3Sigma)
     {
      bClosed=true;
      TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0044",iBarNo);
     }

//処理終了ログ出力
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0034",iBarNo);
   return bClosed;
  }
//+------------------------------------------------------------------+
//| 1シグマライン決済シグナルチェック                                          |
//+------------------------------------------------------------------+
bool CheckCloseSignal_SB1SigmaLine(string sSignal,int iBarNo)
  {
//処理開始ログ出力
   string sProcessName="CheckCloseSignal_SB1SigmaLine";
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0033",iBarNo);

   bool bClosed=false;

//決済シグナル確認
   if(sSignal==SIGNALBUY && dPlus1Sigma>=dH1ClosePrice)
     {
      bClosed=true;
      TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0009",iBarNo);
     }
   else if(sSignal==SIGNALSELL && dMnus1Sigma<=dH1ClosePrice)
     {
      bClosed=true;
      TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0010",iBarNo);
     }
//処理終了ログ出力
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0034",iBarNo);
   return bClosed;

  }
//+------------------------------------------------------------------+
//| ±2シグマライン決済シグナルチェック                                          |
//+------------------------------------------------------------------+
bool CheckCloseSignal_SB2SigmaLine(string sSignal,int iBarNo)
  {
   string sProcessName="±2シグマライン決済シグナルチェック";

   bool bClosed=false;

//決済シグナル確認
   if(sSignal==SIGNALBUY && dPlus2Sigma<=dH1ClosePrice)
     {
      bClosed=true;
      TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0309",iBarNo);
     }
   else if(sSignal==SIGNALSELL && dMnus2Sigma>=dH1ClosePrice)
     {
      bClosed=true;
      TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0310",iBarNo);
     }
   return bClosed;
  }
//+------------------------------------------------------------------+
//| ±3シグマライン決済シグナルチェック                                        |
//+------------------------------------------------------------------+
bool CheckCloseSignal_OverSB3SigmaLine(string sSignal,int iBarNo)
  {
//処理開始ログ出力
   string sProcessName="CheckCloseSignal_OverSB3SigmaLine";
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0033",iBarNo);

   bool bClosed=false;

///決済シグナル確認
   if(sSignal==SIGNALBUY)
     {
      if(dPlus3Sigma<dH1ClosePrice)
        {
         bClosed=true;
         TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0409",iBarNo);
        }
      else
        {
         TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0039",iBarNo);
        }
     }
   else if(sSignal==SIGNALSELL)
     {
      if(dMnus3Sigma>dH1ClosePrice)
        {
         bClosed=true;
         TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0410",iBarNo);
        }
      else
        {
         TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0040",iBarNo);
        }
     }

//処理終了ログ出力
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0034",iBarNo);
   return bClosed;
  }
//+------------------------------------------------------------------+
//| スーパーボリンジャーバンド幅縮小チェック                                    |
//+------------------------------------------------------------------+
bool CheckCloseSignal_SB3SLShrink(int iBarNo)
  {
//処理開始ログ出力
   string sProcessName="CheckCloseSignal_SB3SLShrink";
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0033",iBarNo);

   bool bClosed=false;

///決済シグナル確認
   if(dPrePlus3Sigma>=dPlus3Sigma && dPreMnus3Sigma<=dMnus3Sigma)
     {
      bClosed=true;
      TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0309",iBarNo);
     }

//処理終了ログ出力
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0034",iBarNo);
   return bClosed;
  }
//+------------------------------------------------------------------+
//| シグナル継続カウント取得                                      |
//+------------------------------------------------------------------+
int GetSBSLineSignalCount(string sSignal,int iBarNo)
  {

//処理開始ログ出力
   string sProcessName="GetSBSLineSignalCount";
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0033",iBarNo);

   int iTrendCount=0;
   if(sSignal==SIGNALBUY)
     {
      int i=0;
      while(i<TRENDKEEP)
        {

         //終値
         double dCloseH1=iCloseMTF(Symbol(),iBarNo);

         //スーパーボリンジャーの値
         double dTmpPlus1Sigma=iBandsMTF(Symbol(),SB_PLUS1SIGMA,iBarNo);

         //プラス1シグマラインを上回っている場合
         if(dTmpPlus1Sigma<dCloseH1) iTrendCount=iTrendCount+1;

         iBarNo=iBarNo+Adjust_BarNo;
         i=i+1;
        }
     }
   else if(sSignal==SIGNALSELL)
     {
      int i=0;
      while(i<TRENDKEEP)
        {
         //終値
         double dCloseH1=iCloseMTF(Symbol(),iBarNo);

         //スーパーボリンジャーの値
         double dTmpMnus1Sigma=iBandsMTF(Symbol(),SB_MNUS1SIGMA,iBarNo);

         //マイナス1シグマラインを下回っている場合
         if(dTmpMnus1Sigma>dCloseH1) iTrendCount=iTrendCount+1;

         iBarNo=iBarNo+Adjust_BarNo;
         i=i+1;
        }
     }

//処理終了ログ出力
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0034",iBarNo);
   return iTrendCount;
  }
//+------------------------------------------------------------------+
