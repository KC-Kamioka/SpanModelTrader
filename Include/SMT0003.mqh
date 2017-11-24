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

//+------------------------------------------------------------------+
//| 定数                                                             |
//+------------------------------------------------------------------+
#define SB_INDICATORNAME "SuperBolingerMTF"
#define SB_DELAYEDSPAN  0
#define SB_PLUS1SIGMA 1
#define SB_MNUS1SIGMA 2
#define SB_SIMPLEMA   3
#define SB_PLUS2SIGMA 4
#define SB_MNUS2SIGMA 5
#define SB_PLUS3SIGMA 6
#define SB_MNUS3SIGMA 7

//上位時間遅行スパンのバーの位置
#define UPPERDELAYEDSPANBARNO 263

//+------------------------------------------------------------------+
//| 変数                                                             |
//+------------------------------------------------------------------+
static int Adjust_BarNo=12;  //一時間足バー補正
int iH1OpenBarNo=0;
int iPreH1OpenBarNo=0;
int iH1CloseBarNo=0;
int iPreH1CloseBarNo=0;
double dH1OpenPrice=0;
double dPreH1OpenPrice=0;
double dH1ClosePrice=0;
double dPreH1ClosePrice=0;
datetime dtH1OpenTime=0;
datetime dtPreH1OpenTime=0;
datetime dtH1CloseTime=0;
datetime dtPreH1CloseTime=0;
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

//+------------------------------------------------------------------+
//| 一時間足の終値                                                  |
//+------------------------------------------------------------------+
//バーの位置
   iH1CloseBarNo=iBarShift(NULL,PERIOD_H1,Time[Adjust_BarNo+iBarNo]);

//終値の時間
   dtH1CloseTime=iTime(NULL,PERIOD_H1,iH1CloseBarNo);

//終値
   dH1ClosePrice=iClose(NULL,PERIOD_H1,iH1CloseBarNo);

//1つ前のバーの位置
   iPreH1CloseBarNo=iBarShift(NULL,PERIOD_H1,Time[Adjust_BarNo+Adjust_BarNo+iBarNo]);

//1つ前の終値の時間
   dtPreH1CloseTime=iTime(NULL,PERIOD_H1,iPreH1CloseBarNo);

//1つ前の終値
   dPreH1ClosePrice=iClose(NULL,PERIOD_H1,iPreH1CloseBarNo);

//+------------------------------------------------------------------+
//| 遅行スパンの終値                                                  |
//+------------------------------------------------------------------+
//バーの位置
   int iH1CloseBarNo22=iBarShift(NULL,PERIOD_H1,Time[UPPERDELAYEDSPANBARNO+iBarNo+1]);

//1つ前のバーの位置
   int iPreH1CloseBarNo22=iBarShift(NULL,PERIOD_H1,Time[UPPERDELAYEDSPANBARNO+Adjust_BarNo+iBarNo+1]);

//22本前の終値
   dH1ClosePrice22=iClose(NULL,PERIOD_H1,iH1CloseBarNo22);

//１つ前の22本前の終値
   dPreH1ClosePrice22=iClose(NULL,PERIOD_H1,iPreH1CloseBarNo22);

//高値
   dH1Highest=iHighestMTF(iBarNo);

//安値
   dH1Lowest=iLowestMTF(iBarNo);

//１つ前の移動平均線の値
   dPreSimpleMA=iBandsMTF(SB_SIMPLEMA,iPreH1CloseBarNo);

//移動平均線の値
   dSimpleMA=iBandsMTF(SB_SIMPLEMA,iH1CloseBarNo);

//１つ前の+1シグマラインの値
   dPrePlus1Sigma=iBandsMTF(SB_PLUS1SIGMA,iPreH1CloseBarNo);

//+1シグマラインの値
   dPlus1Sigma=iBandsMTF(SB_PLUS1SIGMA,iH1CloseBarNo);

//１つ前の-1シグマラインの値
   dPreMnus1Sigma=iBandsMTF(SB_MNUS1SIGMA,iPreH1CloseBarNo);

//-1シグマラインの値
   dMnus1Sigma=iBandsMTF(SB_MNUS1SIGMA,iH1CloseBarNo);

//１つ前の+2シグマラインの値
   dPrePlus2Sigma=iBandsMTF(SB_PLUS2SIGMA,iPreH1CloseBarNo);

//+2シグマラインの値
   dPlus2Sigma=iBandsMTF(SB_PLUS2SIGMA,iH1CloseBarNo);

//１つ前の-2シグマラインの値
   dPreMnus2Sigma=iBandsMTF(SB_MNUS2SIGMA,iPreH1CloseBarNo);

//-2シグマラインの値
   dMnus2Sigma=iBandsMTF(SB_MNUS2SIGMA,iH1CloseBarNo);

//１つ前の+3シグマラインの値
   dPrePlus3Sigma=iBandsMTF(SB_PLUS3SIGMA,iPreH1CloseBarNo);

//+3シグマラインの値
   dPlus3Sigma=iBandsMTF(SB_PLUS3SIGMA,iH1CloseBarNo);

//１つ前の-3シグマラインの値
   dPreMnus3Sigma=iBandsMTF(SB_MNUS3SIGMA,iPreH1CloseBarNo);

//-3シグマラインの値
   dMnus3Sigma=iBandsMTF(SB_MNUS3SIGMA,iH1CloseBarNo);

//22本前のシグマラインの値
   dPlusSigma22=iBandsMTF(SB_PLUS3SIGMA,iH1CloseBarNo22);

//22本前のシグマラインの値
   dMnusSigma22=iBandsMTF(SB_MNUS3SIGMA,iH1CloseBarNo22);

   TrailLog("INFO",CLASSNAME3,sProcessName,"一時間足の終時間："+TimeToString(dtH1CloseTime),iBarNo);
   TrailLog("INFO",CLASSNAME3,sProcessName,"1つ前の一時間足の終時間："+TimeToString(dtPreH1CloseTime),iBarNo);
   TrailLog("INFO",CLASSNAME3,sProcessName,"最新の遅行スパンの時間："+TimeToString(iTime(NULL,PERIOD_H1,iH1CloseBarNo22)),iBarNo);
   TrailLog("INFO",CLASSNAME3,sProcessName,"１つ前の遅行スパンの時間："+TimeToString(iTime(NULL,PERIOD_H1,iPreH1CloseBarNo22)),iBarNo);
   TrailLog("INFO",CLASSNAME3,sProcessName,"終値："+DoubleToString(dH1ClosePrice),iBarNo);
   TrailLog("INFO",CLASSNAME3,sProcessName,"1つ前の終値："+DoubleToString(dPreH1ClosePrice),iBarNo);
   TrailLog("INFO",CLASSNAME3,sProcessName,"22本前の終値："+DoubleToString(dH1ClosePrice22),iBarNo);
   TrailLog("INFO",CLASSNAME3,sProcessName,"１つ前の22本前の終値："+DoubleToString(dPreH1ClosePrice22),iBarNo);
   TrailLog("INFO",CLASSNAME3,sProcessName,"高値："+DoubleToString(dH1Highest),iBarNo);
   TrailLog("INFO",CLASSNAME3,sProcessName,"安値："+DoubleToString(dH1Lowest),iBarNo);
   TrailLog("INFO",CLASSNAME3,sProcessName,"１つ前の+3シグマラインの値："+DoubleToString(dPrePlus3Sigma),iBarNo);
   TrailLog("INFO",CLASSNAME3,sProcessName,"１つ前の+2シグマラインの値："+DoubleToString(dPrePlus2Sigma),iBarNo);
   TrailLog("INFO",CLASSNAME3,sProcessName,"１つ前の+1シグマラインの値："+DoubleToString(dPrePlus1Sigma),iBarNo);
   TrailLog("INFO",CLASSNAME3,sProcessName,"1つ前の移動平均線の値："+DoubleToString(dPreSimpleMA),iBarNo);
   TrailLog("INFO",CLASSNAME3,sProcessName,"１つ前の-1シグマラインの値："+DoubleToString(dPreMnus1Sigma),iBarNo);
   TrailLog("INFO",CLASSNAME3,sProcessName,"１つ前の-2シグマラインの値："+DoubleToString(dPreMnus2Sigma),iBarNo);
   TrailLog("INFO",CLASSNAME3,sProcessName,"１つ前の-3シグマラインの値："+DoubleToString(dPreMnus3Sigma),iBarNo);
   TrailLog("INFO",CLASSNAME3,sProcessName,"+3シグマラインの値："+DoubleToString(dPlus3Sigma),iBarNo);
   TrailLog("INFO",CLASSNAME3,sProcessName,"+2シグマラインの値："+DoubleToString(dPlus2Sigma),iBarNo);
   TrailLog("INFO",CLASSNAME3,sProcessName,"+1シグマラインの値："+DoubleToString(dPlus1Sigma),iBarNo);
   TrailLog("INFO",CLASSNAME3,sProcessName,"移動平均線の値："+DoubleToString(dSimpleMA),iBarNo);
   TrailLog("INFO",CLASSNAME3,sProcessName,"-1シグマラインの値："+DoubleToString(dMnus1Sigma),iBarNo);
   TrailLog("INFO",CLASSNAME3,sProcessName,"-2シグマラインの値："+DoubleToString(dMnus2Sigma),iBarNo);
   TrailLog("INFO",CLASSNAME3,sProcessName,"-3シグマラインの値："+DoubleToString(dMnus3Sigma),iBarNo);
   TrailLog("INFO",CLASSNAME3,sProcessName,"22本前の+1シグマラインの値："+DoubleToString(dPlusSigma22),iBarNo);
   TrailLog("INFO",CLASSNAME3,sProcessName,"22本前の-1シグマラインの値："+DoubleToString(dMnusSigma22),iBarNo);

//処理終了ログ出力
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0034",iBarNo);
   return;
  }
//+------------------------------------------------------------------+
//| 一時間足の高値取得                                                  |
//+------------------------------------------------------------------+
double iHighestMTF(int iBarNo)
  {
   int i=0;
   int iM5BarNo=Adjust_BarNo+Adjust_BarNo+iBarNo;
   int iH1BarNo=iBarShift(NULL,PERIOD_H1,Time[iM5BarNo]);
   double dHighestClose=iClose(NULL,PERIOD_H1,iH1BarNo);
   double dTmpClose=0;
   while(i<UPPERSENKOSEN)
     {
      iH1BarNo=iBarShift(NULL,PERIOD_H1,Time[iM5BarNo]);
      dTmpClose=iClose(NULL,PERIOD_H1,iH1BarNo);
      if(dHighestClose<dTmpClose) dHighestClose=dTmpClose;
      iM5BarNo=iM5BarNo+Adjust_BarNo;
      i=i+1;
     }
   return dHighestClose;
  }
//+------------------------------------------------------------------+
//| 一時間足の安値取得                                                  |
//+------------------------------------------------------------------+
double iLowestMTF(int iBarNo)
  {
   int i=0;
   int iM5BarNo=Adjust_BarNo+Adjust_BarNo+iBarNo;
   int iH1BarNo=iBarShift(NULL,PERIOD_H1,Time[iM5BarNo]);
   double dLowestClose=iClose(NULL,PERIOD_H1,iH1BarNo);
   double dTmpClose=0;
   while(i<UPPERSENKOSEN)
     {
      iH1BarNo=iBarShift(NULL,PERIOD_H1,Time[iM5BarNo]);
      dTmpClose=iClose(NULL,PERIOD_H1,iH1BarNo);
      if(dLowestClose>dTmpClose) dLowestClose=dTmpClose;
      iM5BarNo=iM5BarNo+Adjust_BarNo;
      i=i+1;
     }
   return dLowestClose;
  }
//+------------------------------------------------------------------+
//| 一時間足のスーパーボリンジャーバンドの値取得                                                  |
//+------------------------------------------------------------------+
double iBandsMTF(int iLineNo,int iBarNo)
  {
//移動平均線
   if(iLineNo==SB_SIMPLEMA)
     {
      return iBands(NULL,PERIOD_H1,21,0,0,PRICE_CLOSE,0,iBarNo);
     }

//+1シグマライン
   if(iLineNo==SB_PLUS1SIGMA)
     {
      return iBands(NULL,PERIOD_H1,21,1,0,PRICE_CLOSE,1,iBarNo);
     }

//-1シグマライン
   if(iLineNo==SB_MNUS1SIGMA)
     {
      return iBands(NULL,PERIOD_H1,21,1,0,PRICE_CLOSE,2,iBarNo);
     }

//+2シグマライン
   if(iLineNo==SB_PLUS2SIGMA)
     {
      return iBands(NULL,PERIOD_H1,21,2,0,PRICE_CLOSE,1,iBarNo);
     }

//-2シグマライン
   if(iLineNo==SB_MNUS2SIGMA)
     {
      return iBands(NULL,PERIOD_H1,21,2,0,PRICE_CLOSE,2,iBarNo);
     }

//+3シグマライン
   if(iLineNo==SB_PLUS3SIGMA)
     {
      return iBands(NULL,PERIOD_H1,21,3,0,PRICE_CLOSE,1,iBarNo);
     }

//-3シグマライン
   if(iLineNo==SB_MNUS3SIGMA)
     {
      return iBands(NULL,PERIOD_H1,21,3,0,PRICE_CLOSE,2,iBarNo);
     }
   return 0;
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
         int iH1BarNo=iBarShift(NULL,PERIOD_H1,Time[Adjust_BarNo+iBarNo]);
         double dCloseH1=iClose(NULL,PERIOD_H1,iH1BarNo);

         //スーパーボリンジャーの値
         double dTmpPlus1Sigma=iBandsMTF(SB_PLUS1SIGMA,iH1BarNo);

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
         int iH1BarNo=iBarShift(NULL,PERIOD_H1,Time[Adjust_BarNo+iBarNo]);
         double dCloseH1=iClose(NULL,PERIOD_H1,iH1BarNo);

         //スーパーボリンジャーの値
         double dTmpMnus1Sigma=iBandsMTF(SB_MNUS1SIGMA,iH1BarNo);

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
