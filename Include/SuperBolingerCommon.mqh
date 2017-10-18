//+------------------------------------------------------------------+
//|                                          SuperBolingerCommon.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

//+------------------------------------------------------------------+
//| ライブラリ                                                       |
//+------------------------------------------------------------------+
#include <SMTCommon.mqh>

//+------------------------------------------------------------------+
//| 定数                                                             |
//+------------------------------------------------------------------+
static int Adjust_BarNo=12;  //一時間足バー補正
//+------------------------------------------------------------------+
//| スーパーボリンジャーバンド幅縮小チェック                                    |
//+------------------------------------------------------------------+
void CheckSBSimpleMA(int iBarNo=0)
  {

   if(TimeHour(Time[iBarNo]) == TimeHour(Time[iBarNo + 1])) return;

//バーの位置
   int iPreUpperPeriodBarNo=Adjust_BarNo+iBarNo+1;
   int iUpperPeriodBarNo=iBarNo+1;

//スーパーボリンジャーの値
   double dPreSimpleMA=iCustom(NULL,PERIOD_CURRENT,
                               SUPERBOLINGER_MTF,SB_SIMPLEMA,
                               iPreUpperPeriodBarNo);
   double dSimpleMA=iCustom(NULL,PERIOD_CURRENT,
                            SUPERBOLINGER_MTF,SB_SIMPLEMA,
                            iUpperPeriodBarNo);
   double dPlus1Sigma=iCustom(NULL,PERIOD_CURRENT,
                              SUPERBOLINGER_MTF,SB_PLUS1SIGMA,
                              iUpperPeriodBarNo);
   double dMnus1Sigma=iCustom(NULL,PERIOD_CURRENT,
                              SUPERBOLINGER_MTF,SB_MNUS1SIGMA,
                              iUpperPeriodBarNo);
//終値
   double dClose=Close[iUpperPeriodBarNo];

//上昇の場合、プラス1を超えていれば買いシグナル
   if(dPreSimpleMA<dSimpleMA && 
      dPlus1Sigma<dClose)
     {
      SetSessionSBMASignal(SIGNALBUY,iBarNo);
     }

//下降の場合、マイナス1を下回っていれば売りシグナル
   else if(dPreSimpleMA>dSimpleMA && 
      dMnus1Sigma>dClose)
        {
         SetSessionSBMASignal(SIGNALSELL,iBarNo);
        }

      //シグナルなし
      else
        {
         SetSessionSBMASignal(NOSIGNAL,iBarNo);
        }
  }
//+------------------------------------------------------------------+
//| スーパーボリンジャーシグマラインチェック                         |
//+------------------------------------------------------------------+
void CheckSBSigmaLine(int iBarNo=0)
  {

   if(TimeHour(Time[iBarNo]) == TimeHour(Time[iBarNo + 1])) return;

//シグナル消灯
   if(SessionSBSLineSigCnt>UPPERSENKOSEN)
     {
      SetSessionSBSLSignal(NOSIGNAL,iBarNo);
      return;
     }

//1時間足の終値
   int iUpperPeriodBarNo=iBarNo+1;
   double dClose=Close[iUpperPeriodBarNo];

//スーパーボリンジャーの値
   double dPlus1Sigma=iCustom(NULL,PERIOD_CURRENT,
                              SUPERBOLINGER_MTF,SB_PLUS1SIGMA,
                              iUpperPeriodBarNo);
   double dMnus1Sigma=iCustom(NULL,PERIOD_CURRENT,
                              SUPERBOLINGER_MTF,SB_MNUS1SIGMA,
                              iUpperPeriodBarNo);
//バンド幅拡大チェック
   if(CheckSBBandExpand(iBarNo) == false) return;

//買いシグナルの場合
   if(dClose>dPlus1Sigma)
     {
      SetSessionSBSLSignal(SIGNALBUY,iBarNo);
     }

//売りシグナルの場合
   else if(dClose<dMnus1Sigma)
     {
      SetSessionSBSLSignal(SIGNALSELL,iBarNo);
     }

//上記以外
   else
     {
      SetSessionSBSLSignal(NOSIGNAL,iBarNo);
     }

   return;

  }
//+------------------------------------------------------------------+
//| スーパーボリンジャー遅行スパンチェック                                 |
//+------------------------------------------------------------------+
void CheckSBDELAYEDSPAN(int iBarNo=0)
  {

   if(TimeHour(Time[iBarNo]) == TimeHour(Time[iBarNo + 1])) return;

//1時間足の終値
   int iPreUpperPeriodBarNo = Adjust_BarNo + iBarNo + 1;
   int iUpperPeriodBarNo    = iBarNo + 1;
   double dDELAYEDSPAN=Close[iUpperPeriodBarNo];

//1時間足遅行スパン時の終値
   int iPreCloseCSpanUpperPeriodBarNo = UPPERDELAYEDSPANBARNO + iPreUpperPeriodBarNo;
   int iCloseCSpanUpperPeriodBarNo    = UPPERDELAYEDSPANBARNO + iUpperPeriodBarNo;
   double dClose                      = Close[iCloseCSpanUpperPeriodBarNo];

//シグナル消灯
   if(SessionSBCSpanSigCnt>=UPPERSENKOSEN)
     {
      SetSessionSBCSSignal(NOSIGNAL,iBarNo);
      return;
     }

//シグナル点灯中の場合
   if(SessionSBCSpanSigCnt>0)
     {

      //買いシグナルの場合
      if(SessionSBCSSignal==SIGNALBUY && 
         dClose<=dDELAYEDSPAN)
        {
         SetSessionSBCSSignal(SIGNALBUY,iBarNo);
        }

      //売りシグナルの場合
      else if(SessionSBCSSignal==SIGNALSELL && 
         dClose>=dDELAYEDSPAN)
           {
            SetSessionSBCSSignal(SIGNALSELL,iBarNo);
           }

         //上記以外
         else
           {
            SetSessionSBCSSignal(NOSIGNAL,iBarNo);
           }

     }

//シグナル点灯していない場合
   else
     {

      //高値安値をセット
      double dCloseH1 = 0;
      double dHighest = Close[iPreUpperPeriodBarNo];
      double dLowest  = Close[iPreUpperPeriodBarNo];
      int i=iPreUpperPeriodBarNo;
      while(i<UPPERDELAYEDSPANBARNO)
        {

         //終値
         dCloseH1=Close[i];

         //高値
         if(dHighest<dCloseH1) dHighest=dCloseH1;

         //安値
         if(dLowest>dCloseH1) dLowest=dCloseH1;

         i=i+Adjust_BarNo;
        }

      //買いシグナル点灯
      if(dHighest<=dDELAYEDSPAN)
        {
         SetSessionSBCSSignal(SIGNALBUY,iBarNo);
        }

      //売りシグナル点灯
      else if(dLowest>=dDELAYEDSPAN)
        {
         SetSessionSBCSSignal(SIGNALSELL,iBarNo);
        }

      //上記以外
      else
        {
         SetSessionSBCSSignal(NOSIGNAL,iBarNo);
        }

     }

   return;
  }
//+------------------------------------------------------------------+
//| スーパーボリンジャーバンド幅縮小チェック                                    |
//+------------------------------------------------------------------+
void CheckSBBandShrink(int iBarNo=0)
  {

   if(TimeHour(Time[iBarNo]) == TimeHour(Time[iBarNo + 1])) return;

//バーの位置
   int iPreUpperPeriodBarNo=Adjust_BarNo+iBarNo+1;
   int iUpperPeriodBarNo=iBarNo+1;

//スーパーボリンジャーの値
   double dPrePlus1Sigma=iCustom(NULL,PERIOD_CURRENT,
                                 SUPERBOLINGER_MTF,SB_PLUS1SIGMA,
                                 iPreUpperPeriodBarNo);
   double dPlus1Sigma=iCustom(NULL,PERIOD_CURRENT,
                              SUPERBOLINGER_MTF,SB_PLUS1SIGMA,
                              iUpperPeriodBarNo);
   double dPreMnus1Sigma=iCustom(NULL,PERIOD_CURRENT,
                                 SUPERBOLINGER_MTF,SB_MNUS1SIGMA,
                                 iPreUpperPeriodBarNo);
   double dMnus1Sigma=iCustom(NULL,PERIOD_CURRENT,
                              SUPERBOLINGER_MTF,SB_MNUS1SIGMA,
                              iUpperPeriodBarNo);
   double dPrePlus2Sigma=iCustom(NULL,PERIOD_CURRENT,
                                 SUPERBOLINGER_MTF,SB_PLUS2SIGMA,
                                 iPreUpperPeriodBarNo);
   double dPlus2Sigma=iCustom(NULL,PERIOD_CURRENT,
                              SUPERBOLINGER_MTF,SB_PLUS2SIGMA,
                              iUpperPeriodBarNo);
   double dPreMnus2Sigma=iCustom(NULL,PERIOD_CURRENT,
                                 SUPERBOLINGER_MTF,SB_MNUS2SIGMA,
                                 iPreUpperPeriodBarNo);
   double dMnus2Sigma=iCustom(NULL,PERIOD_CURRENT,
                              SUPERBOLINGER_MTF,SB_MNUS2SIGMA,
                              iUpperPeriodBarNo);
   double dPrePlus3Sigma=iCustom(NULL,PERIOD_CURRENT,
                                 SUPERBOLINGER_MTF,SB_PLUS3SIGMA,
                                 iPreUpperPeriodBarNo);
   double dPlus3Sigma=iCustom(NULL,PERIOD_CURRENT,
                              SUPERBOLINGER_MTF,SB_PLUS3SIGMA,
                              iUpperPeriodBarNo);
   double dPreMnus3Sigma=iCustom(NULL,PERIOD_CURRENT,
                                 SUPERBOLINGER_MTF,SB_MNUS3SIGMA,
                                 iPreUpperPeriodBarNo);
   double dMnus3Sigma=iCustom(NULL,PERIOD_CURRENT,
                              SUPERBOLINGER_MTF,SB_MNUS3SIGMA,
                              iUpperPeriodBarNo);

//バンド幅縮小チェック
   if(dPrePlus1Sigma >= dPlus1Sigma &&
      dPrePlus2Sigma >= dPlus2Sigma &&
      dPrePlus3Sigma >= dPlus3Sigma &&
      dPreMnus1Sigma <= dMnus1Sigma &&
      dPreMnus2Sigma <= dMnus2Sigma &&
      dPreMnus3Sigma<=dMnus3Sigma)
     {

      SetSessionOpenSignal(SHRINK,iBarNo);

     }
  }
//+------------------------------------------------------------------+
//| スーパーボリンジャーバンド幅拡大チェック                                    |
//+------------------------------------------------------------------+
bool CheckSBBandExpand(int iBarNo=0)
  {

   if(TimeHour(Time[iBarNo]) == TimeHour(Time[iBarNo + 1])) return false;

   bool bRtn=false;

//バーの位置
   int iPreUpperPeriodBarNo=Adjust_BarNo+iBarNo+1;
   int iUpperPeriodBarNo=iBarNo+1;

//スーパーボリンジャーの値
   double dPrePlus1Sigma=iCustom(NULL,PERIOD_CURRENT,
                                 SUPERBOLINGER_MTF,SB_PLUS1SIGMA,
                                 iPreUpperPeriodBarNo);
   double dPlus1Sigma=iCustom(NULL,PERIOD_CURRENT,
                              SUPERBOLINGER_MTF,SB_PLUS1SIGMA,
                              iUpperPeriodBarNo);
   double dPreMnus1Sigma=iCustom(NULL,PERIOD_CURRENT,
                                 SUPERBOLINGER_MTF,SB_MNUS1SIGMA,
                                 iPreUpperPeriodBarNo);
   double dMnus1Sigma=iCustom(NULL,PERIOD_CURRENT,
                              SUPERBOLINGER_MTF,SB_MNUS1SIGMA,
                              iUpperPeriodBarNo);
   double dPrePlus2Sigma=iCustom(NULL,PERIOD_CURRENT,
                                 SUPERBOLINGER_MTF,SB_PLUS2SIGMA,
                                 iPreUpperPeriodBarNo);
   double dPlus2Sigma=iCustom(NULL,PERIOD_CURRENT,
                              SUPERBOLINGER_MTF,SB_PLUS2SIGMA,
                              iUpperPeriodBarNo);
   double dPreMnus2Sigma=iCustom(NULL,PERIOD_CURRENT,
                                 SUPERBOLINGER_MTF,SB_MNUS2SIGMA,
                                 iPreUpperPeriodBarNo);
   double dMnus2Sigma=iCustom(NULL,PERIOD_CURRENT,
                              SUPERBOLINGER_MTF,SB_MNUS2SIGMA,
                              iUpperPeriodBarNo);
   double dPrePlus3Sigma=iCustom(NULL,PERIOD_CURRENT,
                                 SUPERBOLINGER_MTF,SB_PLUS3SIGMA,
                                 iPreUpperPeriodBarNo);
   double dPlus3Sigma=iCustom(NULL,PERIOD_CURRENT,
                              SUPERBOLINGER_MTF,SB_PLUS3SIGMA,
                              iUpperPeriodBarNo);
   double dPreMnus3Sigma=iCustom(NULL,PERIOD_CURRENT,
                                 SUPERBOLINGER_MTF,SB_MNUS3SIGMA,
                                 iPreUpperPeriodBarNo);
   double dMnus3Sigma=iCustom(NULL,PERIOD_CURRENT,
                              SUPERBOLINGER_MTF,SB_MNUS3SIGMA,
                              iUpperPeriodBarNo);

//バンド幅拡大チェック
/*
   if(dPrePlus1Sigma <= dPlus1Sigma &&
      dPrePlus2Sigma <= dPlus2Sigma &&
      dPrePlus3Sigma <= dPlus3Sigma &&
      dPreMnus1Sigma >= dMnus1Sigma &&
      dPreMnus2Sigma >= dMnus2Sigma &&
      dPreMnus3Sigma>=dMnus3Sigma)
     {
*/
   if(dPrePlus1Sigma-dPreMnus1Sigma<=dPlus1Sigma-dMnus1Sigma&&
      dPrePlus2Sigma-dPreMnus2Sigma<=dPlus2Sigma-dMnus2Sigma&&
      dPrePlus3Sigma-dPreMnus3Sigma<=dPlus3Sigma-dMnus3Sigma)
     {
      //ログ出力
      TrailLog(LOGFILENAME,INFO,SUPERBOLINGER,SIGMALINE,
               NULL,NULL,MSG0021,iBarNo);
      bRtn=true;

     }
   return bRtn;
  }
//+------------------------------------------------------------------+
//| 1シグマライン決済シグナルチェック                                          |
//+------------------------------------------------------------------+
bool CheckCloseSignal_SB1SigmaLine(string sSignal,int iBarNo=0)
  {

   bool bClosed=false;
   if(TimeHour(Time[iBarNo]) == TimeHour(Time[iBarNo + 1])) return bClosed;


//バーの位置
   int iPreUpperPeriodBarNo=Adjust_BarNo+iBarNo+1;
   int iUpperPeriodBarNo=iBarNo+1;

//終値
   double dClose=Close[iUpperPeriodBarNo];

//スーパーボリンジャーの値
   double dPlus1Sigma=iCustom(NULL,PERIOD_CURRENT,
                              SUPERBOLINGER_MTF,SB_PLUS1SIGMA,
                              iUpperPeriodBarNo);
   double dMnus1Sigma=iCustom(NULL,PERIOD_CURRENT,
                              SUPERBOLINGER_MTF,SB_MNUS1SIGMA,
                              iUpperPeriodBarNo);

//決済シグナル確認
   if(sSignal==SIGNALBUY && dPlus1Sigma>=dClose)
     {
      bClosed=true;
      TrailLog(LOGFILENAME,INFO,SUPERBOLINGER,SIGMALINE,
               SIGNALBUY,SessionSBSLineSigCnt,MSG0009,iBarNo);
     }
   else if(sSignal==SIGNALSELL && dMnus1Sigma<=dClose)
     {
      bClosed=true;
      TrailLog(LOGFILENAME,INFO,SUPERBOLINGER,SIGMALINE,
               SIGNALSELL,SessionSBSLineSigCnt,MSG0010,iBarNo);
     }

   return bClosed;

  }
//+------------------------------------------------------------------+
//| 2シグマライン決済シグナルチェック                                          |
//+------------------------------------------------------------------+
bool CheckCloseSignal_SB2SigmaLine(string sSignal,int iBarNo=0)
  {

   bool bClosed=false;

//バーの位置
   int iUpperPeriodBarNo=iBarNo+1;

//終値
   double dClose=Close[iUpperPeriodBarNo];

//スーパーボリンジャーの値
   double dPlus2Sigma=iCustom(NULL,PERIOD_CURRENT,
                              SUPERBOLINGER_MTF,SB_PLUS2SIGMA,
                              iUpperPeriodBarNo);
   double dMnus2Sigma=iCustom(NULL,PERIOD_CURRENT,
                              SUPERBOLINGER_MTF,SB_MNUS2SIGMA,
                              iUpperPeriodBarNo);

//決済シグナル確認
   if(sSignal==SIGNALBUY && dPlus2Sigma<=dClose)
     {
      bClosed=true;
      TrailLog(LOGFILENAME,INFO,SUPERBOLINGER,SIGMALINE,
               SIGNALBUY,SessionSBSLineSigCnt,MSG0309,iBarNo);
     }
   else if(sSignal==SIGNALSELL && dMnus2Sigma>=dClose)
     {
      bClosed=true;
      TrailLog(LOGFILENAME,INFO,SUPERBOLINGER,SIGMALINE,
               SIGNALSELL,SessionSBSLineSigCnt,MSG0310,iBarNo);
     }

   return bClosed;

  }
//+------------------------------------------------------------------+
//| スーパーボリンジャーバンド幅縮小チェック                                    |
//+------------------------------------------------------------------+
bool CheckCloseSignal_SB3SigmaLine(int iBarNo=0)
  {
   bool bClosed=false;
   if(TimeHour(Time[iBarNo]) == TimeHour(Time[iBarNo + 1])) return bClosed;;

//バーの位置
   int iPreUpperPeriodBarNo=Adjust_BarNo+iBarNo+1;
   int iUpperPeriodBarNo=iBarNo+1;

//スーパーボリンジャーの値
   double dPrePlus3Sigma=iCustom(NULL,PERIOD_CURRENT,
                                 SUPERBOLINGER_MTF,SB_PLUS3SIGMA,
                                 iPreUpperPeriodBarNo);
   double dPlus3Sigma=iCustom(NULL,PERIOD_CURRENT,
                              SUPERBOLINGER_MTF,SB_PLUS3SIGMA,
                              iUpperPeriodBarNo);
   double dPreMnus3Sigma=iCustom(NULL,PERIOD_CURRENT,
                                 SUPERBOLINGER_MTF,SB_MNUS3SIGMA,
                                 iPreUpperPeriodBarNo);
   double dMnus3Sigma=iCustom(NULL,PERIOD_CURRENT,
                              SUPERBOLINGER_MTF,SB_MNUS3SIGMA,
                              iUpperPeriodBarNo);


///決済シグナル確認
   if(dPrePlus3Sigma>=dPlus3Sigma && dPreMnus3Sigma<=dMnus3Sigma)
     {
      bClosed=true;
      TrailLog(LOGFILENAME,INFO,SUPERBOLINGER,SIGMALINE,
               SIGNALBUY,SessionSBSLineSigCnt,MSG0309,iBarNo);
     }

   return bClosed;
  }
//+------------------------------------------------------------------+
