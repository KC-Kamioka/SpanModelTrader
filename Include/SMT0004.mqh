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

//ポジションオープンシグナル点灯中
   if(SessionIsExistPosition==true)
     {
      //ブレイクイーブン
      BreakEven();

      //売買終了チェック
      PositionCloseMain(IsInit,iBarNo);

      //全て決済済みの場合
      if(SessionIsClosedSMBlueSpan==true && 
         SessionIsClosedSMDelayedSpan==true && 
         SessionIsClosedSB3SLAgainst==true &&
         SessionIsClosedSB1SigmaLine==true &&
         SessionIsClosedSBSLTakeProfit==true)
        {
         if(SessionOpenSignal==SIGNALBUY) SessionOpenSignal=UPPERTREND;
         if(SessionOpenSignal==SIGNALSELL) SessionOpenSignal=DOWNERTREND;
         SessionSMBSSignal=NOSIGNAL;
         SessionIsClosedSMBlueSpan=false;
         SessionIsClosedSMDelayedSpan=false;
         SessionIsClosedSB3SLAgainst=false;
         SessionIsClosedSB1SigmaLine=false;
         SessionIsClosedSBSLTakeProfit=false;
         SessionTrendKeep=true;
         SessionIsExistPosition=false;
        }
     }

//トレンドチェック
   CheckTrend(iBarNo);

//シグナル消灯中
   if(SessionOpenSignal==NOSIGNAL)
     {
      return;
     }

//トレンド終了チェック
   if(SessionOpenSignal==UPPERTREND ||
      SessionOpenSignal==DOWNERTREND)
      {
      if(SessionSBSRSignal==SHRINK)
        {
         //シグナル初期化
         SMTInitialize(iBarNo);
         return;
        }
      }
   if(SessionOpenSignal==SIGNALBUY ||
      SessionOpenSignal==UPPERTREND)
     {
      if(SessionSBMASignal==SIGNALSELL)
        {
         //シグナル初期化
         SMTInitialize(iBarNo);
         return;
        }
      if(SessionSBSLSignal==SIGNALSELL)
        {
         //シグナル初期化
         SMTInitialize(iBarNo);
         return;
        }
     }
   else if(SessionOpenSignal==SIGNALSELL || 
      SessionOpenSignal==DOWNERTREND)
        {
         if(SessionSBMASignal==SIGNALBUY)
           {
            //シグナル初期化
            SMTInitialize(iBarNo);
            return;
           }
         if(SessionSBSLSignal==SIGNALBUY)
           {
            //シグナル初期化
            SMTInitialize(iBarNo);
            return;
           }
        }

      // if(SessionOpenSignal==NOSIGNAL) return;

      //ポジション取得制限
      if(TimeDayOfWeek(Time[iBarNo])==1) return;
   if(TimeDayOfWeek(Time[iBarNo])==5) return;

//ポジションオープンシグナルセット
   SetOpenSignal(iBarNo);

//ポジションオープンシグナル消灯中
   if(SessionIsExistPosition==false)
     {
      //買いポジションオープン
      if(SessionOpenSignal==SIGNALBUY)
        {
         SessionIsExistPosition=true;
         if(IsInit==false)
           {
            if(PositionOpenBuy(STOPLOSS)==false) SMTInitialize(iBarNo);
           }
        }

      //売りポジションオープン
      else if(SessionOpenSignal==SIGNALSELL)
        {
         SessionIsExistPosition=true;
         if(IsInit==false)
           {
            if(PositionOpenSell(STOPLOSS)==false) SMTInitialize(iBarNo);
           }
        }
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

   if(SessionTrendKeep==false)
     {
      //トレンド継続数の値超えていなければクローズしない
      if(GetSBSLineSignalCount(SessionOpenSignal,iBarNo)<TRENDKEEP)
        {
         //トレンド継続数取得
         SetObjSMTSignal(SessionOpenSignal,SMTVPRICE08,iBarNo);
         SetObjSMTSignal(SessionOpenSignal,SMTVPRICE09,iBarNo);
         SetObjSMTSignal(SessionOpenSignal,SMTVPRICE10,iBarNo);
         SetObjSMTSignal(SessionOpenSignal,SMTVPRICE11,iBarNo);
         SetObjSMTSignal(SessionOpenSignal,SMTVPRICE12,iBarNo);
        }
      else
        {
         SessionTrendKeep=true;
        }

      //青色スパンが逆行した場合、クローズチェックを開始する
      string sSignal=CheckSMBlueSpan(iBarNo);
      if((SessionOpenSignal==SIGNALBUY && sSignal==SIGNALSELL) ||
         (SessionOpenSignal==SIGNALSELL && sSignal==SIGNALBUY))
        {
         SessionTrendKeep=true;
        }
     }
//手仕舞い処理開始
   else
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

      //±3シグマライン逆行チェック
      if(SessionIsClosedSB3SLAgainst==false)
        {
         SetObjSMTSignal(SessionOpenSignal,SMTVPRICE10,iBarNo);
         bRtn=false;
         bRtn=CheckCloseSignal_SB3SLAgainst(SessionOpenSignal,iBarNo);
         if(bRtn==true)
           {
            //ポジションクローズ
            if(IsInit==false)PositionClose();
            SessionIsClosedSB3SLAgainst=true;
           }
        }

      //±1シグマラインチェック
      if(SessionIsClosedSB1SigmaLine==false)
        {
         SetObjSMTSignal(SessionOpenSignal,SMTVPRICE11,iBarNo);
         bRtn=false; bRtn=CheckCloseSignal_SB1SigmaLine(SessionOpenSignal,iBarNo);
         if(bRtn==true)
           {
            //ポジションクローズ
            if(IsInit==false)PositionClose();
            SessionIsClosedSB1SigmaLine=true;
           }
        }

      //±2シグマラインを上回っている（下回っている）場合、利益確定
      if(SessionIsClosedSBSLTakeProfit==false)
        {
         SetObjSMTSignal(SessionOpenSignal,SMTVPRICE12,iBarNo);
         if(TimeHour(Time[iBarNo])!=TimeHour(Time[iBarNo+1]))
           {
            bRtn=CheckCloseSignal_SB2SigmaLine(SessionOpenSignal,iBarNo);
            if(bRtn==true)
              {
               //ポジションクローズ
               if(IsInit==false)PositionClose();
               SessionIsClosedSBSLTakeProfit=true;
              }
           }
        }
     }

//トレンド終了チェック
   bRtn=CheckCloseSignal_SBSimpleMA(SessionOpenSignal,iBarNo);
   if(bRtn==true)
     {
      //全て決済済み
      SessionIsClosedSMBlueSpan=true;
      SessionIsClosedSMDelayedSpan=true;
      SessionIsClosedSB3SLAgainst=true;
      SessionIsClosedSB1SigmaLine=true;
      SessionIsClosedSBSLTakeProfit=true;

      //全ポジションクローズ
      if(IsInit==false) PositionCloseAll();
      return;
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
   if(GetSBSLineSignalCount(SessionOpenSignal,iBarNo)<TRENDKEEP)
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
      //SMAチェック
      SessionSBMASignal=CheckSBSimpleMA(iBarNo);

      //バンド幅拡大チェック
      SessionSBEXSignal=CheckSBBandExpand(iBarNo);

      //バンド縮小チェック
      SessionSBSRSignal=CheckSBBandShrink(iBarNo);

      //シグマラインチェック                                            
      SessionSBSLSignal=CheckSBSigmaLine(iBarNo);

      //遅行スパン&高値or安値チェック
      SessionSBCHLSignal=CheckSBDelayedSpan_HighAndLow(iBarNo);

      //遅行スパン&シグマライン
      SessionSBCSLSignal=CheckSBDelayedSpan_SigmaLine(iBarNo);

     }
   if(SessionOpenSignal!=NOSIGNAL)
     {

      SetObjSMTSignal(SessionSBMASignal,SMTVPRICE03,iBarNo);
      SetObjSMTSignal(SessionSBEXSignal,SMTVPRICE04,iBarNo);
      SetObjSMTSignal(SessionSBSLSignal,SMTVPRICE05,iBarNo);
      SetObjSMTSignal(SessionSBCHLSignal,SMTVPRICE06,iBarNo);
      SetObjSMTSignal(SessionSBCSLSignal,SMTVPRICE07,iBarNo);
     }
   if(SessionOpenSignal==SIGNALBUY ||
      SessionOpenSignal==SIGNALSELL)
     {
      return;
     }
//上昇トレンド発生
   if(SessionSBMASignal==SIGNALBUY &&
      SessionSBEXSignal==SIGNALBUY &&
      SessionSBSLSignal==SIGNALBUY &&
      SessionSBCHLSignal==SIGNALBUY &&
      SessionSBCSLSignal==SIGNALBUY)
     {
      SessionOpenSignal=UPPERTREND;
     }
//下降トレンド発生
   else if(SessionSBMASignal==SIGNALSELL && 
      SessionSBEXSignal==SIGNALSELL &&
      SessionSBSLSignal==SIGNALSELL &&
      SessionSBCHLSignal==SIGNALSELL &&
      SessionSBCSLSignal==SIGNALSELL)
        {
         SessionOpenSignal=DOWNERTREND;
        }

      //処理終了ログ出力
      TrailLog("INFO",CLASSNAME4,sProcessName,"MSG0034",iBarNo);
   return;
  }
//+------------------------------------------------------------------+
//| ポジションオープンシグナルセット                                                      |
//+------------------------------------------------------------------+
void SetOpenSignal(int iBarNo)
  {

//処理開始ログ出力
   string sProcessName="CheckTrend";
   TrailLog("INFO",CLASSNAME4,sProcessName,"MSG0033",iBarNo);

//青色スパンチェック                                            
   string sSMBSSignal=CheckSMBlueSpan(iBarNo);
   SetSessionSMBSSignal(sSMBSSignal,iBarNo);
   SetObjSMTSignal(SessionSMBSSignal,SMTVPRICE01,iBarNo);

//遅行スパンチェック                                            
   string sSMDSSingal=CheckSMDelayedSpan(iBarNo);
   SetSessionSMCSSignal(sSMDSSingal,iBarNo);
   SetObjSMTSignal(SessionSMCSSignal,SMTVPRICE02,iBarNo);
//買いシグナルセット
   if(SessionOpenSignal==UPPERTREND &&
      SessionSMBSSignal==SIGNALBUY &&
      SessionSMCSSignal==SIGNALBUY &&
      SessionSBMASignal!=SIGNALSELL &&
      SessionSBEXSignal!=SIGNALSELL &&
      SessionSBSLSignal!=SIGNALSELL &&
      SessionSBCHLSignal!=SIGNALSELL &&
      SessionSBCSLSignal!=SIGNALSELL)
     {
      SessionOpenSignal=SIGNALBUY;
      return;
     }
//売りシグナルセット
   if(SessionOpenSignal==DOWNERTREND &&
      SessionSMBSSignal==SIGNALSELL &&
      SessionSMCSSignal==SIGNALSELL &&
      SessionSBMASignal!=SIGNALBUY &&
      SessionSBEXSignal!=SIGNALBUY &&
      SessionSBSLSignal!=SIGNALBUY &&
      SessionSBCHLSignal!=SIGNALBUY &&
      SessionSBCSLSignal!=SIGNALBUY)
     {
      SessionOpenSignal=SIGNALSELL;
      return;
     }

//処理終了ログ出力
   TrailLog("INFO",CLASSNAME4,sProcessName,"MSG0034",iBarNo);
   return;
  }
//+------------------------------------------------------------------+
