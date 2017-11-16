//+------------------------------------------------------------------+
//|                                                      SMT0004.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| ライブラリ                                                         |
//+------------------------------------------------------------------+
#include <SMT0002.mqh>
#include <SMT0003.mqh>
#include <SMT0005.mqh>
//+------------------------------------------------------------------+
//| メイン処理                                                        |
//+------------------------------------------------------------------+
void SMTTrendFollow(int iBarNo,bool IsInit=false)
  {

//処理開始ログ出力
   string sProcessName="SMTTrendFollow";
   TrailLog("INFO",CLASSNAME4,sProcessName,"MSG0033",iBarNo);

//スパンモデルの値をセット
   SetNewSMPrice(iBarNo);

//スーパーボリンジャーの値をセット
   SetNewSBPrice(iBarNo);

//トレンドチェック
   CheckTrend(iBarNo);

//レンジトレードフラグセット
   if(SessionOpenSignal!=SIGNALBUY &&
   SessionOpenSignal!=SIGNALSELL)
     {
      SessionRangeTradeFlg=true;
     }

//ポジションオープンシグナル消灯中
   if(SessionIsExistPosition==false)
     {
      //買いポジションオープン
      if(SessionOpenSignal==SIGNALBUY)
        {
         //全ポジションクローズ
         if(IsInit==false) PositionCloseAll();
         SessionIsExistPosition=true;
         SessionRangeTradeFlg=false;
         GetSBSLineSignalCount(SessionOpenSignal,iBarNo);
         if(SessionTrendCount<TRENDKEEP)
           {
            if(IsInit==false)
              {
               if(PositionOpenBuy(STOPLOSS)==false) SMTInitialize(iBarNo);
              }
           }
         else
           {
            SessionScalpingFlg=true;
           }
        }

      //売りポジションオープン
      else if(SessionOpenSignal==SIGNALSELL)
        {
         //全ポジションクローズ
         if(IsInit==false) PositionCloseAll();
         SessionIsExistPosition=true;
         SessionRangeTradeFlg=false;
         GetSBSLineSignalCount(SessionOpenSignal,iBarNo);
         if(SessionTrendCount<TRENDKEEP)
           {
            if(IsInit==false)
              {
               if(PositionOpenSell(STOPLOSS)==false) SMTInitialize(iBarNo);
              }
           }
         else
           {
            SessionScalpingFlg=true;
           }
        }
     }

//ポジションオープンシグナル点灯中
   else
     {
      if(SessionScalpingFlg==false)
        {
         //決済主処理
         PositionCloseMain(IsInit,iBarNo);
        }

      //売買終了チェック
      PositionCloseAllMain(IsInit,iBarNo);
     }

//処理終了ログ出力
   TrailLog("INFO",CLASSNAME4,sProcessName,"MSG0034",iBarNo);
   return;
  }
//+------------------------------------------------------------------+
//ポジション決済主処理
//+------------------------------------------------------------------+
void PositionCloseMain(bool IsInit,int iBarNo)
  {
   bool bRtn=false;

//トレンド継続数の値超えていなければクローズしない
   if(SessionTrendCount<TRENDKEEP)
     {
      //トレンド継続数取得
      GetSBSLineSignalCount(SessionOpenSignal,iBarNo);
      SetObjSMTSignal(SessionOpenSignal,SMTVPRICE07,iBarNo);
      SetObjSMTSignal(SessionOpenSignal,SMTVPRICE08,iBarNo);
      SetObjSMTSignal(SessionOpenSignal,SMTVPRICE09,iBarNo);
      SetObjSMTSignal(SessionOpenSignal,SMTVPRICE10,iBarNo);
     }

//手仕舞い処理開始
   else
     {

      //部分決済チェック
      if(SessionScalpingFlg==false)
        {

         //青色スパン＆終値チェック
         if(SessionIsClosedSMBlueSpan==false)
           {
            SetObjSMTSignal(SessionOpenSignal,SMTVPRICE08,iBarNo);
            bRtn=false;
            bRtn=CheckCloseSignal_SMBlueSpan(SessionOpenSignal,iBarNo);
            if(bRtn==true)
              {
               //ポジションクローズ
               if(IsInit==false)PositionClose();
               SessionIsClosedSMBlueSpan=true;
              }
           }

         //遅行スパン逆転していない場合
         if(SessionIsClosedSMDelayedSpan==false)
           {
            SetObjSMTSignal(SessionOpenSignal,SMTVPRICE09,iBarNo);
            bRtn=false;
            bRtn=CheckCloseSignal_SMDelayedSpan(SessionOpenSignal,iBarNo);
            if(bRtn==true)
              {
               //ポジションクローズ
               if(IsInit==false)PositionClose();
               SessionIsClosedSMDelayedSpan=true;
              }
           }

         //±2シグマラインを上回っている（下回っている）場合、利益確定
         if(SessionIsClosedSBSLTakeProfit==false)
           {
            SetObjSMTSignal(SessionOpenSignal,SMTVPRICE10,iBarNo); bRtn=CheckCloseSignal_SB2SigmaLine(SessionOpenSignal,iBarNo);
            if(bRtn==true)
              {
               //ポジションクローズ
               if(IsInit==false)PositionClose();
               SessionIsClosedSBSLTakeProfit=true;
              }
           }
        }
     }

//全決済チェック
   SetObjSMTSignal(SessionOpenSignal,SMTVPRICE07,iBarNo);

//バンド幅縮小チェック
   bRtn=false;
   bRtn=CheckCloseSignal_SB3SLShrink(iBarNo);
   if(bRtn==true)
     {
      //全ポジションクローズ
      if(IsInit==false) PositionCloseAll();
      SessionScalpingFlg=true;
     }

//±1シグマラインチェック
   bRtn=false;
   bRtn=CheckCloseSignal_SB1SigmaLine(SessionOpenSignal,iBarNo);
   if(bRtn==true)
     {

      //全ポジションクローズ
      if(IsInit==false) PositionCloseAll();
      SessionScalpingFlg=true;
     }

//ポジション有無チェック
   if(IsInit==false && IsExistPosition()==false)
     {
      SessionScalpingFlg=true;
     }
  }
//+------------------------------------------------------------------+
//全ポジション決済主処理
//+------------------------------------------------------------------+
bool PositionCloseAllMain(bool IsInit,int iBarNo)
  {
   bool bRtn=false;

//トレンド継続マーク
   SetObjSMTSignal(SessionOpenSignal,SMTVPRICE07,iBarNo);

//トレンド終了チェック
   bRtn=CheckCloseSignal_SBSimpleMA(SessionOpenSignal,iBarNo);
   if(bRtn==true)
     {
      //全ポジションクローズ
      if(IsInit==false) PositionCloseAll();
      return bRtn;
     }

//週末チェック
   if(IsWeekend(iBarNo)==true)
     {
      //全ポジションクローズ
      if(IsInit==false) PositionCloseAll();
      return bRtn;
     }

//トレンド継続数の値超えていなければクローズしない
   if(SessionTrendCount<TRENDKEEP)
     {
      //±3シグマラインチェック
      bRtn=CheckCloseSignal_SB3SLAgainst(SessionOpenSignal,iBarNo);
      if(bRtn==true)
        {
         //全ポジションクローズ
         if(IsInit==false) PositionCloseAll();
         return bRtn;
        }
     }
   return bRtn;
  }
//+------------------------------------------------------------------+
//| トレンドチェック                                                      |
//+------------------------------------------------------------------+
void CheckTrend(int iBarNo)
  {

//処理開始ログ出力
   string sProcessName="CheckTrend";
   TrailLog("INFO",CLASSNAME4,sProcessName,"MSG0033",iBarNo);

   if(TimeHour(Time[iBarNo])!=TimeHour(Time[iBarNo+1]))
     {
      //遅行スパンクロスチェック
      string sSignal=CheckSBDSpanCross(iBarNo);
      if(sSignal!=NOSIGNAL)
        {
         //シグナル初期化
         SMTInitialize(iBarNo);

         //オープンシグナルセット
         SetSessionOpenSignal(sSignal,iBarNo);

         //バンド幅縮小オブジェクトセット
         SetObjSMTSignal(sSignal,0,iBarNo);
        }
     }

//青色スパンチェック                                            
   string sSMBSSignal=CheckSMBlueSpan(iBarNo);
   SetSessionSMBSSignal(sSMBSSignal,iBarNo);
   SetObjSMTSignal(SessionSMBSSignal,SMTVPRICE01,iBarNo);

//遅行スパンチェック                                            
   string sSMDSSingal=CheckSMDelayedSpan(iBarNo);
   SetSessionSMCSSignal(sSMDSSingal,iBarNo);
   SetObjSMTSignal(SessionSMCSSignal,SMTVPRICE02,iBarNo);

//スーパーボリンジャーチェック
   if(TimeHour(Time[iBarNo])!=TimeHour(Time[iBarNo+1]))
     {

      //SMAチェック
      string sSBMASingal=CheckSBSimpleMA(iBarNo);
      SessionSBMASignal=sSBMASingal;

      //バンド幅拡大チェック
      string sSBEXSignal=CheckSBBandExpand(iBarNo);
      SessionSBEXSignal=sSBEXSignal;

      //シグマラインチェック                                            
      string sSBSLSignal=CheckSBSigmaLine(iBarNo);
      SetSessionSBSLSignal(sSBSLSignal,iBarNo);

      //遅行スパンチェック
      string sSBCSSignal=CheckSBDelayedSpan(iBarNo);
      SetSessionSBCSSignal(sSBCSSignal,iBarNo);
     }

   SetObjSMTSignal(SessionSBMASignal,SMTVPRICE03,iBarNo);
   SetObjSMTSignal(SessionSBEXSignal,SMTVPRICE04,iBarNo);
   SetObjSMTSignal(SessionSBSLSignal,SMTVPRICE05,iBarNo);
   SetObjSMTSignal(SessionSBCSSignal,SMTVPRICE06,iBarNo);

//上昇トレンド発生
   if(SessionSMBSSignal==SIGNALBUY && 
      SessionSMCSSignal == SIGNALBUY &&
      SessionSBMASignal == SIGNALBUY &&
      SessionSBEXSignal == SIGNALBUY &&
      SessionSBSLSignal == SIGNALBUY &&
      SessionSBCSSignal==SIGNALBUY)
     {
      SetSessionOpenSignal(SIGNALBUY,iBarNo);
     }

//下降トレンド発生
   else if(SessionSMBSSignal==SIGNALSELL && 
      SessionSMCSSignal == SIGNALSELL &&
      SessionSBMASignal == SIGNALSELL &&
      SessionSBEXSignal == SIGNALSELL &&
      SessionSBSLSignal == SIGNALSELL &&
      SessionSBCSSignal==SIGNALSELL)
        {
         SetSessionOpenSignal(SIGNALSELL,iBarNo);
        }

      //処理終了ログ出力
      TrailLog("INFO",CLASSNAME4,sProcessName,"MSG0034",iBarNo);
   return;
  }
//+------------------------------------------------------------------+
