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
#define UPPERDELAYEDSPANBARNO 241

//+------------------------------------------------------------------+
//| 変数                                                             |
//+------------------------------------------------------------------+
static int Adjust_BarNo=12;  //一時間足バー補正
double dH1ClosePrice=0;
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
//+------------------------------------------------------------------+
//| スーパーボリンジャーの値をセット                                                             |
//+------------------------------------------------------------------+
void SetNewSBPrice(int iBarNo)
  {
//処理開始ログ出力
   string sProcessName="SetNewSBPrice";
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0033",iBarNo);
   string sRtnSignal=NOSIGNAL;
   int iPreUpperPeriodBarNo=Adjust_BarNo+iBarNo+1;

//終値
   dH1ClosePrice=GetH1ClosePrice(iBarNo+1);
   TrailLog("INFO",CLASSNAME3,sProcessName,"終値："+DoubleToString(dH1ClosePrice),iBarNo);

//１つ前の移動平均線の値
   dPreSimpleMA=iCustom(NULL,PERIOD_M5,
                        SB_INDICATORNAME,SB_SIMPLEMA,
                        iPreUpperPeriodBarNo);
   TrailLog("INFO",CLASSNAME3,sProcessName,"1つ前の移動平均線の値："+DoubleToString(dPreSimpleMA),iBarNo);

//移動平均線の値
   dSimpleMA=iCustom(NULL,PERIOD_M5,
                     SB_INDICATORNAME,SB_SIMPLEMA,
                     iBarNo+1);
   TrailLog("INFO",CLASSNAME3,sProcessName,"移動平均線の値："+DoubleToString(dSimpleMA),iBarNo);

//１つ前の+1シグマラインの値
   dPrePlus1Sigma=iCustom(NULL,PERIOD_M5,
                          SB_INDICATORNAME,SB_PLUS1SIGMA,
                          iPreUpperPeriodBarNo);
   TrailLog("INFO",CLASSNAME3,sProcessName,"１つ前の+1シグマラインの値："+DoubleToString(dPrePlus1Sigma),iBarNo);

//+1シグマラインの値
   dPlus1Sigma=iCustom(NULL,PERIOD_M5,
                       SB_INDICATORNAME,SB_PLUS1SIGMA,
                       iBarNo+1);
   TrailLog("INFO",CLASSNAME3,sProcessName,"+1シグマラインの値："+DoubleToString(dPlus1Sigma),iBarNo);

//１つ前の-1シグマラインの値
   dPreMnus1Sigma=iCustom(NULL,PERIOD_M5,
                          SB_INDICATORNAME,SB_MNUS1SIGMA,
                          iPreUpperPeriodBarNo);
   TrailLog("INFO",CLASSNAME3,sProcessName,"１つ前の-1シグマラインの値："+DoubleToString(dPreMnus1Sigma),iBarNo);

//-1シグマラインの値
   dMnus1Sigma=iCustom(NULL,PERIOD_M5,
                       SB_INDICATORNAME,SB_MNUS1SIGMA,
                       iBarNo+1);
   TrailLog("INFO",CLASSNAME3,sProcessName,"-1シグマラインの値："+DoubleToString(dMnus1Sigma),iBarNo);

//１つ前の+2シグマラインの値
   dPrePlus2Sigma=iCustom(NULL,PERIOD_M5,
                          SB_INDICATORNAME,SB_PLUS2SIGMA,
                          iPreUpperPeriodBarNo);
   TrailLog("INFO",CLASSNAME3,sProcessName,"１つ前の+2シグマラインの値："+DoubleToString(dPrePlus2Sigma),iBarNo);

//+2シグマラインの値
   dPlus2Sigma=iCustom(NULL,PERIOD_M5,
                       SB_INDICATORNAME,SB_PLUS2SIGMA,
                       iBarNo+1);
   TrailLog("INFO",CLASSNAME3,sProcessName,"-1シグマラインの値："+DoubleToString(dPlus2Sigma),iBarNo);

//１つ前の-2シグマラインの値
   dPreMnus2Sigma=iCustom(NULL,PERIOD_M5,
                          SB_INDICATORNAME,SB_MNUS2SIGMA,
                          iPreUpperPeriodBarNo);
   TrailLog("INFO",CLASSNAME3,sProcessName,"１つ前の-2シグマラインの値："+DoubleToString(dPreMnus2Sigma),iBarNo);

//-2シグマラインの値
   dMnus2Sigma=iCustom(NULL,PERIOD_M5,
                       SB_INDICATORNAME,SB_MNUS2SIGMA,
                       iBarNo+1);
   TrailLog("INFO",CLASSNAME3,sProcessName,"-2シグマラインの値："+DoubleToString(dMnus2Sigma),iBarNo);

//１つ前の+3シグマラインの値
   dPrePlus3Sigma=iCustom(NULL,PERIOD_M5,
                          SB_INDICATORNAME,SB_PLUS3SIGMA,
                          iPreUpperPeriodBarNo);
   TrailLog("INFO",CLASSNAME3,sProcessName,"１つ前の+3シグマラインの値："+DoubleToString(dPrePlus3Sigma),iBarNo);

//+3シグマラインの値
   dPlus3Sigma=iCustom(NULL,PERIOD_M5,
                       SB_INDICATORNAME,SB_PLUS3SIGMA,
                       iBarNo+1);
   TrailLog("INFO",CLASSNAME3,sProcessName,"+3シグマラインの値："+DoubleToString(dPlus3Sigma),iBarNo);

//１つ前の-3シグマラインの値
   dPreMnus3Sigma=iCustom(NULL,PERIOD_M5,
                          SB_INDICATORNAME,SB_MNUS3SIGMA,
                          iPreUpperPeriodBarNo);
   TrailLog("INFO",CLASSNAME3,sProcessName,"１つ前の-1シグマラインの値："+DoubleToString(dPreMnus3Sigma),iBarNo);

//-3シグマラインの値
   dMnus3Sigma=iCustom(NULL,PERIOD_M5,
                       SB_INDICATORNAME,SB_MNUS3SIGMA,
                       iBarNo+1);
   TrailLog("INFO",CLASSNAME3,sProcessName,"-3シグマラインの値："+DoubleToString(dMnus3Sigma),iBarNo);

//処理終了ログ出力
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0034",iBarNo);
   return;
  }
//+------------------------------------------------------------------+
//| 1時間足の終値取得                                                  |
//+------------------------------------------------------------------+
double GetH1ClosePrice(int iBarNo)
  {
//処理開始ログ出力
   string sProcessName="GetH1ClosePrice";
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0033",iBarNo);

   double dClose=0;
   for(int i=iBarNo; i<iBarNo+Adjust_BarNo; i++)
     {
      if(TimeHour(Time[i])!=TimeHour(Time[i+1]))
        {
         dClose=Close[i+1];
         break;
        }
     }

//処理終了ログ出力
   TrailLog("INFO",CLASSNAME3,sProcessName,"終値："+DoubleToString(dClose),iBarNo);
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0034",iBarNo);
   return dClose;
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
     }

//移動平均線が下降傾向で、終値が移動平均線より下
   else if(dPreSimpleMA>dSimpleMA && dSimpleMA>dH1ClosePrice)
     {
      sRtnSignal=SIGNALSELL;
     }

//シグナルなし
   else
     {
      sRtnSignal=NOSIGNAL;
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
      return sRtnSignal;
     }

//買いシグナルの場合
   if(dH1ClosePrice>dSimpleMA) sRtnSignal=SIGNALBUY;

//売りシグナルの場合
   else if(dH1ClosePrice<dSimpleMA) sRtnSignal=SIGNALSELL;

//上記以外
   else sRtnSignal=NOSIGNAL;

//処理終了ログ出力
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0034",iBarNo);

   return sRtnSignal;

  }
//+------------------------------------------------------------------+
//| スーパーボリンジャー遅行スパンチェック                                 |
//+------------------------------------------------------------------+
string CheckSBDelayedSpan(int iBarNo)
  {
//処理開始ログ出力
   string sProcessName="CheckSBDelayedSpan";
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0033",iBarNo);

   string sRtnSignal=NOSIGNAL;

//遅行スパンの終値
   int iPreUpperPeriodBarNo=Adjust_BarNo+iBarNo+1;
   double dSBDelayedSpan=dH1ClosePrice;

//1時間足遅行スパン時の終値
   int iPreCloseCSpanUpperPeriodBarNo = UPPERDELAYEDSPANBARNO + iPreUpperPeriodBarNo;
   int iCloseCSpanUpperPeriodBarNo    = UPPERDELAYEDSPANBARNO + iBarNo+1;
   double dClose                      = GetH1ClosePrice(iCloseCSpanUpperPeriodBarNo);

//シグナル消灯
   if(SessionSBCSpanSigCnt>=UPPERSENKOSEN)
     {
      return sRtnSignal;
     }

//シグナル点灯中の場合
   if(SessionSBCSpanSigCnt>0)
     {

      //買いシグナルの場合
      if(SessionSBCSSignal==SIGNALBUY && dClose<=dSBDelayedSpan)
        {
         sRtnSignal=SIGNALBUY;
        }

      //売りシグナルの場合
      else if(SessionSBCSSignal==SIGNALSELL && dClose>=dSBDelayedSpan)
        {
         sRtnSignal=SIGNALSELL;
        }

      //上記以外
      else
        {
         sRtnSignal=NOSIGNAL;
        }

     }

//シグナル点灯していない場合
   else
     {

      //高値安値をセット
      double dCloseH1 = 0;
      double dHighest = GetH1ClosePrice(iPreUpperPeriodBarNo);
      double dLowest  = GetH1ClosePrice(iPreUpperPeriodBarNo);
      int i=iPreUpperPeriodBarNo;
      while(i<UPPERDELAYEDSPANBARNO)
        {

         //終値
         dCloseH1=GetH1ClosePrice(i);

         //高値
         if(dHighest<dCloseH1) dHighest=dCloseH1;

         //安値
         if(dLowest>dCloseH1) dLowest=dCloseH1;

         i=i+Adjust_BarNo;
        }

      //買いシグナル点灯
      if(dHighest<=dSBDelayedSpan) sRtnSignal=SIGNALBUY;

      //売りシグナル点灯
      else if(dLowest>=dSBDelayedSpan) sRtnSignal=SIGNALSELL;

      //上記以外
      else sRtnSignal=NOSIGNAL;

     }
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
      sRtnSignal=SHRINK;
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
   if(dPrePlus1Sigma-dPreMnus1Sigma<=dPlus1Sigma-dMnus1Sigma&&
      dPrePlus2Sigma-dPreMnus2Sigma<=dPlus2Sigma-dMnus2Sigma&&
      dPrePlus3Sigma-dPreMnus3Sigma<=dPlus3Sigma-dMnus3Sigma)
     {

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

//終値
   double dClose=GetH1ClosePrice(iBarNo+1);

//決済シグナル確認
   if(sSignal==SIGNALBUY && dSimpleMA>=dClose)
     {
      bClosed=true;
      TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0024",iBarNo);
     }
   else if(sSignal==SIGNALSELL && dSimpleMA<=dClose)
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
bool CheckCloseSignal_SB3SigmaLine(string sSignal,int iBarNo)
  {
//処理開始ログ出力
   string sProcessName="±3シグマライン決済シグナルチェック";
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
void TrendSignalCountUp(string sSignal,int iBarNo)
  {

//処理開始ログ出力
   string sProcessName="GetSBSLineSignalCount";
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0033",iBarNo);

   if(sSignal==SIGNALBUY)
     {
      int i=0;
      while(i<TRENDKEEP)
        {

         //終値
         double dCloseH1=GetH1ClosePrice(iBarNo+1);

         //スーパーボリンジャーの値
         double dTmpPlus1Sigma=iCustom(NULL,PERIOD_M5,
                                       SB_INDICATORNAME,SB_PLUS1SIGMA,
                                       iBarNo+1);

         //プラス1シグマラインを上回っている場合
         if(dTmpPlus1Sigma<dCloseH1) SessionTrendCount=SessionTrendCount+1;
         else SessionTrendCount=0;

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
         double dCloseH1=GetH1ClosePrice(iBarNo+1);

         //スーパーボリンジャーの値
         double dTmpMnus1Sigma=iCustom(NULL,PERIOD_M5,
                                       SB_INDICATORNAME,SB_MNUS1SIGMA,
                                       iBarNo+1);

         //マイナス1シグマラインを下回っている場合
         if(dTmpMnus1Sigma>dCloseH1) SessionTrendCount=SessionTrendCount+1;
         else SessionTrendCount=0;

         iBarNo=iBarNo+Adjust_BarNo;
         i=i+1;
        }
     }
   else
     {
      //シグナルカウント初期化
      SessionTrendCount=0;
     }
   TrailLog("INFO",CLASSNAME3,sProcessName,"トレンド継続数を更新しました。（"+IntegerToString(SessionTrendCount)+"）",iBarNo);

//処理終了ログ出力
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0034",iBarNo);
   return;
  }
//+------------------------------------------------------------------+
