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

   bool bRtn=false;

//処理開始ログ出力
   string sProcessName="SMTTrendFollow";
   TrailLog("INFO",CLASSNAME4,sProcessName,"MSG0033",iBarNo);

//スパンモデルの値をセット
   SetNewSMPrice(iBarNo);

//スーパーボリンジャーの値をセット
   SetNewSBPrice(iBarNo);

//トレンドチェック
   CheckTrend(iBarNo);

//+------------------------------------------------------------------+
//ポジションオープンシグナル消灯中
//+------------------------------------------------------------------+
   if(SessionIsExistPosition==false)
     {

      //買いポジションオープン
      if(SessionOpenSignal==SIGNALBUY)
        {
         SetSessionIsExistPosition(true,iBarNo);
         if(IsInit==false) PositionOpenBuy();
        }

      //売りポジションオープン
      else if(SessionOpenSignal==SIGNALSELL)
        {
         SetSessionIsExistPosition(true,iBarNo);
         if(IsInit==false) PositionOpenSell();
        }
     }
//+------------------------------------------------------------------+
//ポジションオープンシグナル点灯中
//+------------------------------------------------------------------+
   else
     {
      if(SessionScalpingFlg==false)
        {

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
         //+------------------------------------------------------------------+
         //手仕舞い処理開始
         //+------------------------------------------------------------------+
         else
           {

            //+------------------------------------------------------------------+
            //部分決済チェック
            //+------------------------------------------------------------------+
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
                     SetSessionIsClosedSMBlueSpan(true,iBarNo);
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
                     SetSessionIsClosedSMDelayedSpan(true,iBarNo);
                    }
                 }

               //±2シグマラインを上回っている（下回っている）場合、利益確定
               bRtn=false;
               bRtn=CheckCloseSignal_SB2SigmaLine(SessionOpenSignal,iBarNo);
               if(bRtn==true)
                 {
                  //ポジションクローズ
                  if(IsInit==false) PositionCloseAll();
                  SetSessionScalpingFlg(true,iBarNo);
                 }
              }
           }

         //+------------------------------------------------------------------+
         //全決済チェック
         //+------------------------------------------------------------------+
         SetObjSMTSignal(SessionOpenSignal,SMTVPRICE07,iBarNo);

         //バンド幅縮小チェック
         bRtn=false;
         bRtn=CheckCloseSignal_SB3SLShrink(iBarNo);
         if(bRtn==true)
           {
            //全ポジションクローズ
            if(IsInit==false) PositionCloseAll();
            SetSessionScalpingFlg(true,iBarNo);
           }

         //±1シグマラインチェック
         bRtn=false;
         bRtn=CheckCloseSignal_SB1SigmaLine(SessionOpenSignal,iBarNo);
         if(bRtn==true)
           {

            //全ポジションクローズ
            if(IsInit==false) PositionCloseAll();
            SetSessionScalpingFlg(true,iBarNo);
           }

         //ポジション有無チェック
         if(IsInit==false && IsExistPosition()==false)
           {
            SetSessionScalpingFlg(true,iBarNo);
           }
        }

      //+------------------------------------------------------------------+
      //スキャルピング中
      //+------------------------------------------------------------------+
      else
        {
         if(IsInit==false)
           {
            //ポジションあり
            if(IsExistPosition()==true)
              {
               SetObjSMTSignal(SessionOpenSignal,SMTVPRICE11,iBarNo);
               TrailLog("INFO",CLASSNAME4,sProcessName,"MSG0035",iBarNo);
              }

            //ポジションなし
            else
              {
               TrailLog("INFO",CLASSNAME4,sProcessName,"MSG0036",iBarNo);
              }
           }
        }

      //トレンド継続マーク
      SetObjSMTSignal(SessionOpenSignal,SMTVPRICE07,iBarNo);
/*
      //+------------------------------------------------------------------+
      //3シグマライン決済チェック
      //+------------------------------------------------------------------+
      bRtn=false;
      bRtn=CheckCloseSignal_OverSB3SigmaLine(SessionOpenSignal,iBarNo);
      if(bRtn==true)
        {
         //全ポジションクローズ
         if(IsInit==false) PositionCloseAll();

         //処理終了ログ出力
         TrailLog("INFO",CLASSNAME4,sProcessName,"MSG0034",iBarNo);
         return;
        }
*/
      //+------------------------------------------------------------------+
      //トレンド終了チェック
      //+------------------------------------------------------------------+
      bRtn=false;
      bRtn=CheckCloseSignal_SBSimpleMA(SessionOpenSignal,iBarNo);
      if(bRtn==true)
        {
         //全ポジションクローズ
         if(IsInit==false) PositionCloseAll();
         SMTInitialize(iBarNo);

         //処理終了ログ出力
         TrailLog("INFO",CLASSNAME4,sProcessName,"MSG0034",iBarNo);
         return;
        }
      //+------------------------------------------------------------------+
      //±3シグマラインチェック
      //+------------------------------------------------------------------+
      bRtn=false;
      bRtn=CheckCloseSignal_SB3SLAgainst(SessionOpenSignal,iBarNo);
      if(bRtn==true)
        {
         //全ポジションクローズ
         if(IsInit==false) PositionCloseAll();
         //SMTInitialize(iBarNo);
         SetSessionScalpingFlg(true,iBarNo);

         //処理終了ログ出力
         TrailLog("INFO",CLASSNAME4,sProcessName,"MSG0034",iBarNo);
         return;
        }

      //+------------------------------------------------------------------+
      //週末チェック
      //+------------------------------------------------------------------+
      if(IsWeekend(iBarNo)==true)
        {
         //全ポジションクロー
         if(IsInit==false) PositionCloseAll();
         TrailLog("INFO",CLASSNAME1,sProcessName,"MSG0020",iBarNo);
         SMTInitialize(iBarNo);

         //処理終了ログ出力
         TrailLog("INFO",CLASSNAME4,sProcessName,"MSG0034",iBarNo);
         return;
        }
     }

//処理終了ログ出力
   TrailLog("INFO",CLASSNAME4,sProcessName,"MSG0034",iBarNo);
   return;
  }
//+------------------------------------------------------------------+
//| トレンドチェック                                                      |
//+------------------------------------------------------------------+
void CheckTrend(int iBarNo)
  {

//処理開始ログ出力
   string sProcessName="CheckTrend";
   TrailLog("INFO",CLASSNAME4,sProcessName,"MSG0033",iBarNo);

//オープンシグナル消灯中のとき
   if(SessionOpenSignal==NOSIGNAL)
     {

      if(TimeHour(Time[iBarNo])!=TimeHour(Time[iBarNo+1]))
        {
         //バンド幅縮小チェック
         string sSignal=CheckSBBandShrink(iBarNo);

         //オープンシグナルセット
         SetSessionOpenSignal(sSignal,iBarNo);

         //バンド幅縮小オブジェクトセット
         SetObjSMTSignal(sSignal,0,iBarNo);

        }
      if(SessionOpenSignal==NOSIGNAL)
        {
         //処理終了ログ出力
         TrailLog("INFO",CLASSNAME4,sProcessName,"MSG0034",iBarNo);
         return;
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

//スーパーボリンジャーチェック                                          |
   if(TimeHour(Time[iBarNo])!=TimeHour(Time[iBarNo+1]))
     {

      //SMAチェック
      string sSBMASingal=CheckSBSimpleMA(iBarNo);
      SetSessionSBMASignal(sSBMASingal,iBarNo);

      //バンド幅拡大チェック
      string sSBEXSignal=CheckSBBandExpand(iBarNo);
      SetSessionSBEXSignal(sSBEXSignal,iBarNo);

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
//| ポジションクローズ                                                    |
//+------------------------------------------------------------------+
void PositionClose()
  {
//処理開始ログ出力
   string sProcessName="PositionClose";
   TrailLog("INFO",CLASSNAME4,sProcessName,"MSG0033",0);

//オーダー情報取得
   for(int i=0; i<OrdersTotal(); i++)
     {
      bool bSelected=OrderSelect(i,SELECT_BY_POS);
      if(OrderSymbol()==Symbol())
        {

         //ポジションクローズ
         bool Closed=OrderClose(OrderTicket(),CLOSELOT,OrderClosePrice(),SLIPPAGE,Magenta);
         if(Closed==true)
           {
            TrailLog("INFO",CLASSNAME4,sProcessName,"MSG0013",0);
              }else{
            int iLastError=GetLastError();
            string sErrMessage=ErrorDescription(iLastError);
            TrailLog("ERROR",CLASSNAME3,sProcessName,sErrMessage,0);
            SendNotification(Symbol()+" "+sErrMessage);
           }
         break;
        }
     }

//処理終了ログ出力
   TrailLog("INFO",CLASSNAME4,sProcessName,"MSG0034",0);
   return;
  }
//+------------------------------------------------------------------+
