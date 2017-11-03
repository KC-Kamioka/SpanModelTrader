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

//バーの位置
   int iPreUpperPeriodBarNo=Adjust_BarNo+iBarNo+1;
   
//1時間足の終値
   double dClose=GetH1ClosePrice(iBarNo+1);
  
//スーパーボリンジャーの値
   double dPreSimpleMA=iCustom(NULL,PERIOD_M5,
                               SB_INDICATORNAME,SB_SIMPLEMA,
                               iPreUpperPeriodBarNo);
   double dSimpleMA=iCustom(NULL,PERIOD_M5,
                            SB_INDICATORNAME,SB_SIMPLEMA,
                            iBarNo+1);

//移動平均線が上昇傾向で、終値が移動平均線より上
   if(dPreSimpleMA<dSimpleMA && dSimpleMA<dClose)
     {
      sRtnSignal=SIGNALBUY;
     }

//移動平均線が下降傾向で、終値が移動平均線より下
   else if(dPreSimpleMA>dSimpleMA && dSimpleMA>dClose)
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
   if(CheckCloseSignal_SB3SigmaLine(iBarNo)==true)
     {
      return sRtnSignal;
     }

//1時間足の終値
   double dClose=GetH1ClosePrice(iBarNo+1);

//スーパーボリンジャーの値
   double dSimpleMA=iCustom(NULL,PERIOD_M5,
                            SB_INDICATORNAME,SB_SIMPLEMA,
                            iBarNo+1);

   double dPlus1Sigma=iCustom(NULL,PERIOD_M5,
                              SB_INDICATORNAME,SB_PLUS1SIGMA,
                              iBarNo+1);
   double dMnus1Sigma=iCustom(NULL,PERIOD_M5,
                              SB_INDICATORNAME,SB_MNUS1SIGMA,
                              iBarNo+1);

//買いシグナルの場合
   if(dClose>dSimpleMA) sRtnSignal=SIGNALBUY;

//売りシグナルの場合
   else if(dClose<dSimpleMA) sRtnSignal=SIGNALSELL;

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
   int iPreUpperPeriodBarNo = Adjust_BarNo + iBarNo + 1;
   double dDelayedSpan=GetH1ClosePrice(iBarNo+1);

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
      if(SessionSBCSSignal==SIGNALBUY && dClose<=dDelayedSpan)
        {
         sRtnSignal=SIGNALBUY;
        }

      //売りシグナルの場合
      else if(SessionSBCSSignal==SIGNALSELL && dClose>=dDelayedSpan)
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
      if(dHighest<=dDelayedSpan) sRtnSignal=SIGNALBUY;

      //売りシグナル点灯
      else if(dLowest>=dDelayedSpan) sRtnSignal=SIGNALSELL;

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
   
//スーパーボリンジャーの値
   double dPrePlus1Sigma=iCustom(NULL,PERIOD_M5,
                                 SB_INDICATORNAME,SB_PLUS1SIGMA,
                                 iPreUpperPeriodBarNo);
   double dPlus1Sigma=iCustom(NULL,PERIOD_M5,
                              SB_INDICATORNAME,SB_PLUS1SIGMA,
                              iBarNo+1);
   double dPreMnus1Sigma=iCustom(NULL,PERIOD_M5,
                                 SB_INDICATORNAME,SB_MNUS1SIGMA,
                                 iPreUpperPeriodBarNo);
   double dMnus1Sigma=iCustom(NULL,PERIOD_M5,
                              SB_INDICATORNAME,SB_MNUS1SIGMA,
                              iBarNo+1);
   double dPrePlus2Sigma=iCustom(NULL,PERIOD_M5,
                                 SB_INDICATORNAME,SB_PLUS2SIGMA,
                                 iPreUpperPeriodBarNo);
   double dPlus2Sigma=iCustom(NULL,PERIOD_M5,
                              SB_INDICATORNAME,SB_PLUS2SIGMA,
                              iBarNo+1);
   double dPreMnus2Sigma=iCustom(NULL,PERIOD_M5,
                                 SB_INDICATORNAME,SB_MNUS2SIGMA,
                                 iPreUpperPeriodBarNo);
   double dMnus2Sigma=iCustom(NULL,PERIOD_M5,
                              SB_INDICATORNAME,SB_MNUS2SIGMA,
                              iBarNo+1);
   double dPrePlus3Sigma=iCustom(NULL,PERIOD_M5,
                                 SB_INDICATORNAME,SB_PLUS3SIGMA,
                                 iPreUpperPeriodBarNo);
   double dPlus3Sigma=iCustom(NULL,PERIOD_M5,
                              SB_INDICATORNAME,SB_PLUS3SIGMA,
                              iBarNo+1);
   double dPreMnus3Sigma=iCustom(NULL,PERIOD_M5,
                                 SB_INDICATORNAME,SB_MNUS3SIGMA,
                                 iPreUpperPeriodBarNo);
   double dMnus3Sigma=iCustom(NULL,PERIOD_M5,
                              SB_INDICATORNAME,SB_MNUS3SIGMA,
                              iBarNo+1);

//バンド幅縮小チェック
   if(dPrePlus1Sigma-dPreMnus1Sigma>=dPlus1Sigma-dMnus1Sigma&&
      dPrePlus2Sigma-dPreMnus2Sigma>=dPlus2Sigma-dMnus2Sigma&&
      dPrePlus3Sigma-dPreMnus3Sigma>=dPlus3Sigma-dMnus3Sigma)
     {
      sRtnSignal=SHRINK;
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

//バーの位置
   int iPreUpperPeriodBarNo=Adjust_BarNo+iBarNo+1;

//スーパーボリンジャーの値
   double dPrePlus1Sigma=iCustom(NULL,PERIOD_M5,
                                 SB_INDICATORNAME,SB_PLUS1SIGMA,
                                 iPreUpperPeriodBarNo);
   double dPlus1Sigma=iCustom(NULL,PERIOD_M5,
                              SB_INDICATORNAME,SB_PLUS1SIGMA,
                              iBarNo+1);
   double dPreMnus1Sigma=iCustom(NULL,PERIOD_M5,
                                 SB_INDICATORNAME,SB_MNUS1SIGMA,
                                 iPreUpperPeriodBarNo);
   double dMnus1Sigma=iCustom(NULL,PERIOD_M5,
                              SB_INDICATORNAME,SB_MNUS1SIGMA,
                              iBarNo+1);
   double dPrePlus2Sigma=iCustom(NULL,PERIOD_M5,
                                 SB_INDICATORNAME,SB_PLUS2SIGMA,
                                 iPreUpperPeriodBarNo);
   double dPlus2Sigma=iCustom(NULL,PERIOD_M5,
                              SB_INDICATORNAME,SB_PLUS2SIGMA,
                              iBarNo+1);
   double dPreMnus2Sigma=iCustom(NULL,PERIOD_M5,
                                 SB_INDICATORNAME,SB_MNUS2SIGMA,
                                 iPreUpperPeriodBarNo);
   double dMnus2Sigma=iCustom(NULL,PERIOD_M5,
                              SB_INDICATORNAME,SB_MNUS2SIGMA,
                              iBarNo+1);
   double dPrePlus3Sigma=iCustom(NULL,PERIOD_M5,
                                 SB_INDICATORNAME,SB_PLUS3SIGMA,
                                 iPreUpperPeriodBarNo);
   double dPlus3Sigma=iCustom(NULL,PERIOD_M5,
                              SB_INDICATORNAME,SB_PLUS3SIGMA,
                              iBarNo+1);
   double dPreMnus3Sigma=iCustom(NULL,PERIOD_M5,
                                 SB_INDICATORNAME,SB_MNUS3SIGMA,
                                 iPreUpperPeriodBarNo);
   double dMnus3Sigma=iCustom(NULL,PERIOD_M5,
                              SB_INDICATORNAME,SB_MNUS3SIGMA,
                              iBarNo+1);

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

//スーパーボリンジャーの値
   double dSimpleMA=iCustom(NULL,PERIOD_M5,
                            SB_INDICATORNAME,SB_SIMPLEMA,
                            iBarNo+1);

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
//| 1シグマライン決済シグナルチェック                                          |
//+------------------------------------------------------------------+
bool CheckCloseSignal_SB1SigmaLine(string sSignal,int iBarNo)
  {
//処理開始ログ出力
   string sProcessName="CheckCloseSignal_SB1SigmaLine";
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0033",iBarNo);

   bool bClosed=false;

//バーの位置
   int iPreUpperPeriodBarNo=Adjust_BarNo+iBarNo+1;

//終値
   double dClose=GetH1ClosePrice(iBarNo+1);

//スーパーボリンジャーの値
   double dPlus1Sigma=iCustom(NULL,PERIOD_M5,
                              SB_INDICATORNAME,SB_PLUS1SIGMA,
                              iBarNo+1);
   double dMnus1Sigma=iCustom(NULL,PERIOD_M5,
                              SB_INDICATORNAME,SB_MNUS1SIGMA,
                              iBarNo+1);

//決済シグナル確認
   if(sSignal==SIGNALBUY && dPlus1Sigma>=dClose)
     {
      bClosed=true;
      TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0009",iBarNo);
     }
   else if(sSignal==SIGNALSELL && dMnus1Sigma<=dClose)
     {
      bClosed=true;
      TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0010",iBarNo);
     }
//処理終了ログ出力
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0034",iBarNo);
   return bClosed;

  }
//+------------------------------------------------------------------+
//| 2シグマライン決済シグナルチェック                                          |
//+------------------------------------------------------------------+
bool CheckCloseSignal_SB2SigmaLine(string sSignal,int iBarNo)
  {
//処理開始ログ出力
   string sProcessName="CheckCloseSignal_SB2SigmaLine";
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0033",iBarNo);

   bool bClosed=false;

//終値
   double dClose=GetH1ClosePrice(iBarNo+1);

//スーパーボリンジャーの値
   double dPlus2Sigma=iCustom(NULL,PERIOD_M5,
                              SB_INDICATORNAME,SB_PLUS2SIGMA,
                              iBarNo+1);
   double dMnus2Sigma=iCustom(NULL,PERIOD_M5,
                              SB_INDICATORNAME,SB_MNUS2SIGMA,
                              iBarNo+1);

//決済シグナル確認
   if(sSignal==SIGNALBUY && dPlus2Sigma<=dClose)
     {
      bClosed=true;
      TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0309",iBarNo);
     }
   else if(sSignal==SIGNALSELL && dMnus2Sigma>=dClose)
     {
      bClosed=true;
      TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0310",iBarNo);
     }
//処理終了ログ出力
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0034",iBarNo);
   return bClosed;

  }
//+------------------------------------------------------------------+
//| スーパーボリンジャーバンド幅縮小チェック                                    |
//+------------------------------------------------------------------+
bool CheckCloseSignal_SB3SigmaLine(int iBarNo)
  {
//処理開始ログ出力
   string sProcessName="CheckCloseSignal_SB3SigmaLine";
   TrailLog("INFO",CLASSNAME3,sProcessName,"MSG0033",iBarNo);

   bool bClosed=false;

//バーの位置
   int iPreUpperPeriodBarNo=Adjust_BarNo+iBarNo+1;

//スーパーボリンジャーの値
   double dPrePlus3Sigma=iCustom(NULL,PERIOD_M5,
                                 SB_INDICATORNAME,SB_PLUS3SIGMA,
                                 iPreUpperPeriodBarNo);
   double dPlus3Sigma=iCustom(NULL,PERIOD_M5,
                              SB_INDICATORNAME,SB_PLUS3SIGMA,
                              iBarNo+1);
   double dPreMnus3Sigma=iCustom(NULL,PERIOD_M5,
                                 SB_INDICATORNAME,SB_MNUS3SIGMA,
                                 iPreUpperPeriodBarNo);
   double dMnus3Sigma=iCustom(NULL,PERIOD_M5,
                              SB_INDICATORNAME,SB_MNUS3SIGMA,
                              iBarNo+1);

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
