//+------------------------------------------------------------------+
//|                                                SMTTradeMain.mqh |
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
#include <SpanModelCommon.mqh>
#include <SuperBolingerCommon.mqh>

bool bHasPosition=false;
//+------------------------------------------------------------------+
//| メイン処理                                                        |
//+------------------------------------------------------------------+
void SMTTrendFollow(int iBarNo,bool IsInit=false)
  {

//ポジションオープンシグナル消灯中
   if(SessionIsExistPosition==false)
     {

      //トレンドチェック
      CheckTrend(iBarNo);

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

//ポジションオープンシグナル点灯中
   else
     {

      //基準線の値超えていなければクローズしない
      if(SessionSBSimpleMASigCnt<LOWERKIJUNSEN-1)
        {
         //SMAシグナルカウントアップ
         if(TimeHour(Time[iBarNo])!=TimeHour(Time[iBarNo+1]))
           {
            SessionSBSimpleMASigCnt=SessionSBSimpleMASigCnt+1;
           }
         SetObjSMTSignal(SessionOpenSignal,SMTVPRICE1,iBarNo);
         SetObjSMTSignal(SessionOpenSignal,SMTVPRICE2,iBarNo);
         SetObjSMTSignal(SessionOpenSignal,SMTVPRICE3,iBarNo);
         SetObjSMTSignal(SessionOpenSignal,SMTVPRICE4,iBarNo);

        }

      //手仕舞い処理開始
      else
        {

         //青色スパン＆終値チェック
         if(SessionIsClosedSMBlueSpan==false)
           {
            SetObjSMTSignal(SessionOpenSignal,SMTVPRICE2,iBarNo);
            bool bRtn=CheckCloseSignal_SMBlueSpan(SessionOpenSignal,iBarNo);
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
            SetObjSMTSignal(SessionOpenSignal,SMTVPRICE3,iBarNo);
            bool bRtn=CheckCloseSignal_SMDelayedSpan(SessionOpenSignal,iBarNo);
            if(bRtn==true)
              {
               //ポジションクローズ
               if(IsInit==false)PositionClose();
               SetSessionIsClosedSMDelayedSpan(true,iBarNo);
              }
           }

         //±2シグマラインを上回っている（下回っている）場合、利益確定
         if(SessionIsAllClosed==false)
           {
            bool bRtn=CheckCloseSignal_SB2SigmaLine(SessionOpenSignal,iBarNo);
            if(bRtn==true)
              {
               //ポジションクローズ
               if(IsInit==false) PositionCloseAll();
               SetSessionIsClosedSB2SigmaLine(true,iBarNo);
              }
           }
        }

      //バンド幅縮小チェック
      if(SessionIsAllClosed==false)
        {
         SetObjSMTSignal(SessionOpenSignal,SMTVPRICE4,iBarNo);
         bool bRtn=CheckCloseSignal_SB3SigmaLine(iBarNo);
         if(bRtn==true)
           {

            //全ポジションクローズ
            if(IsInit==false) PositionCloseAll();
            SetSessionIsClosedSB3SigmaLine(true,iBarNo);
           }
        }

      //トレンド終了チェック
      SetObjSMTSignal(SessionOpenSignal,SMTVPRICE5,iBarNo);
      bool bRtn=CheckCloseSignal_SBSimpleMA(SessionOpenSignal,iBarNo);
      if(bRtn==true)
        {

         //全ポジションクローズ
         if(IsInit==false) PositionCloseAll();
         SMTInitialize(iBarNo);
         return;
        }

      //スキャルピング
      if(SessionIsAllClosed==true)
        {
         double dPlus2Sigma=iBands(NULL,PERIOD_M5,21,2,0,PRICE_CLOSE,1,iBarNo);
         double dMnus2Sigma=iBands(NULL,PERIOD_M5,21,2,0,PRICE_CLOSE,2,iBarNo);
         double dClose=Close[iBarNo];

         //新規ポジション取得
//         if(IsExistPosition(iBarNo)==false)
           if(bHasPosition==false)
           {
            //買いポジション取得
            if(SessionOpenSignal==SIGNALBUY && dMnus2Sigma>dClose)
              {
               if(IsInit==false) PositionOpenBuy(iBarNo);
               bHasPosition=true;
              }

            //売りポジション取得
            else if(SessionOpenSignal==SIGNALBUY && dPlus2Sigma<dClose)
              {
               if(IsInit==false) PositionOpenSell(iBarNo);
               bHasPosition=true;
              }
           }

         //手仕舞い
         else
           {
            if(SessionOpenSignal==SIGNALBUY && dPlus2Sigma<dClose)
              {
               //全ポジションクローズ
               if(IsInit==false) PositionCloseAll();
               bHasPosition=false;
              }
            else if(SessionOpenSignal==SIGNALSELL && dMnus2Sigma>dClose)
              {
               //全ポジションクローズ
               if(IsInit==false) PositionCloseAll();
               bHasPosition=false;
              }

           }
            if(bHasPosition=true)
              {
               SetObjSMTSignal(SessionOpenSignal,SMTVPRICE6,iBarNo);
              }
        }

      //週末チェック
      if(IsWeekend(iBarNo)==true)
        {
         //全ポジションクロー
         if(IsInit==false) PositionCloseAll();
         SMTInitialize(iBarNo);
         return;
        }
     }
  }
//+------------------------------------------------------------------+
//| トレンドチェック                                                      |
//+------------------------------------------------------------------+
void CheckTrend(int iBarNo)
  {

//オープンシグナル消灯中、またはバンド幅縮小中のとき
   if(SessionOpenSignal==NOSIGNAL || SessionOpenSignal==SHRINK)
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

      //縮小中であれば処理しない
      if(SessionOpenSignal!=RANGE) return;
     }

//スパンモデル青色スパンチェック                                            
   string sSMBSSignal=CheckSMBlueSpan(iBarNo);
   SetSessionSMBSSignal(sSMBSSignal,iBarNo);
   SetObjSMTSignal(SessionSMBSSignal,SMTVPRICE1,iBarNo);

//スパンモデル遅行スパンチェック                                            
   string sSMDSSingal=CheckSMDelayedSpan(iBarNo);
   SetSessionSMCSSignal(sSMDSSingal,iBarNo);
   SetObjSMTSignal(SessionSMCSSignal,SMTVPRICE2,iBarNo);
   if(TimeHour(Time[iBarNo])!=TimeHour(Time[iBarNo+1]))
     {

      //スーパーボリンジャーSMAチェック
      string sSBMASingal=CheckSBSimpleMA(iBarNo);
      SetSessionSBMASignal(sSBMASingal,iBarNo);

      //バンド幅拡大チェック
      string sSBEXSignal=CheckSBBandExpand(iBarNo);
      SetSessionSBEXSignal(sSBEXSignal,iBarNo);

      //スーパーボリンジャーシグマラインチェック                                            
      string sSBSLSignal=CheckSBSigmaLine(iBarNo);
      SetSessionSBSLSignal(sSBSLSignal,iBarNo);

      //スーパーボリンジャー遅行スパンチェック
      string sSBCSSignal=CheckSBDelayedSpan(iBarNo);
      SetSessionSBCSSignal(sSBCSSignal,iBarNo);
     }
   SetObjSMTSignal(SessionSBMASignal,SMTVPRICE3,iBarNo);
   SetObjSMTSignal(SessionSBEXSignal,SMTVPRICE4,iBarNo);
   SetObjSMTSignal(SessionSBSLSignal,SMTVPRICE5,iBarNo);
   SetObjSMTSignal(SessionSBCSSignal,SMTVPRICE6,iBarNo);
//強トレンド発生
   if(SessionSMBSSignal==SIGNALBUY && 
      SessionSMCSSignal == SIGNALBUY &&
      SessionSBMASignal == SIGNALBUY &&
      SessionSBEXSignal == SIGNALBUY &&
      SessionSBSLSignal == SIGNALBUY_STRONG &&
      SessionSBCSSignal==SIGNALBUY)
     {
      SetSessionOpenSignal(SIGNALBUY,iBarNo);
     }
   else if(SessionSMBSSignal==SIGNALSELL && 
      SessionSMCSSignal == SIGNALSELL &&
      SessionSBMASignal == SIGNALSELL &&
      SessionSBEXSignal == SIGNALSELL &&
      SessionSBSLSignal == SIGNALSELL_STRONG &&
      SessionSBCSSignal==SIGNALSELL)
        {
         SetSessionOpenSignal(SIGNALSELL,iBarNo);
        }

      //弱トレンド発生
      else if(SessionSMBSSignal==SIGNALBUY && 
         SessionSMCSSignal == SIGNALBUY &&
         SessionSBMASignal == SIGNALBUY &&
         SessionSBEXSignal == SIGNALBUY &&
         SessionSBSLSignal == SIGNALBUY_WEAK &&
         SessionSBCSSignal==SIGNALBUY)
           {
            SetSessionOpenSignal(SIGNALBUY,iBarNo);
           }
         //+------------------------------------------------------------------+
         //|                                                                  |
         //+------------------------------------------------------------------+
         //+------------------------------------------------------------------+
         //|                                                                  |
         //+------------------------------------------------------------------+
         else if(SessionSMBSSignal==SIGNALSELL && 
            SessionSMCSSignal == SIGNALSELL &&
            SessionSBMASignal == SIGNALSELL &&
            SessionSBEXSignal == SIGNALSELL &&
            SessionSBSLSignal == SIGNALSELL_WEAK &&
            SessionSBCSSignal==SIGNALSELL)
              {
               SetSessionOpenSignal(SIGNALSELL,iBarNo);
              }
           }
//+------------------------------------------------------------------+
//| ポジションクローズ                                                    |
//+------------------------------------------------------------------+
   void PositionClose()
     {

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
               TrailLog(LOGFILENAME,INFO,POSITION,NULL,NULL,NULL,"MSG0013",0);
                 }else{
               int iLastError=GetLastError();
               string sErrMessage=ErrorDescription(iLastError);
               TrailLog(LOGFILENAME,ERROR,POSITION,NULL,NULL,NULL,
                        sErrMessage,0);
               SendNotification(Symbol()+sErrMessage);
               SetSessionIsTradeEnable();
              }
            break;
           }
        }
     }
//+------------------------------------------------------------------+
//| 全ポジションクローズ                                                    |
//+------------------------------------------------------------------+
   void PositionCloseAll()
     {

      //オーダー情報取得
      for(int i=0; i<OrdersTotal(); i++)
        {
         bool bSelected=OrderSelect(i,SELECT_BY_POS);
         if(OrderSymbol()==Symbol())
           {

            //ポジションクローズ
            bool Closed=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),SLIPPAGE,Magenta);
            if(Closed==true)
              {
               TrailLog(LOGFILENAME,INFO,POSITION,NULL,NULL,NULL,"MSG0013",0);
                 }else{
               int iLastError=GetLastError();
               string sErrMessage=ErrorDescription(iLastError);
               TrailLog(LOGFILENAME,ERROR,POSITION,NULL,NULL,NULL,
                        sErrMessage,0);
               SendNotification(Symbol()+sErrMessage);
               SetSessionIsTradeEnable();
              }
           }
        }
     }
//+--------------------------------------------------------------+
//| 買いポジションオープン                                             |
//+--------------------------------------------------------------+
   void PositionOpenBuy(int iBarNo=0)
     {

      //ポジション取得制限
      if(DayOfWeek() == 1 && TimeHour(TimeCurrent()) <  3) return;
      if(DayOfWeek() == 5 && TimeHour(TimeCurrent()) > 20) return;

      //証拠金チェック
      if(AccountFreeMarginCheck(Symbol(),OP_BUY,LOTCOUNT)<=0 || 
         GetLastError()==ERR_NOT_ENOUGH_MONEY)
        {

         //シグナル初期化
         SMTInitialize(iBarNo);
         return;
        }

      //買いポジションオープン
      int iRtnTicketNo=OrderSend(NULL,OP_BUY,LOTCOUNT,Ask,SLIPPAGE,
                                 Ask-STOPLOSS*Point,NULL,NULL,NULL,NULL,clrAqua);
      if(iRtnTicketNo==-1)
        {
         int iLastError=GetLastError();
         string sErrMessage=ErrorDescription(iLastError);
         TrailLog(LOGFILENAME,ERROR,POSITION,NULL,NULL,NULL,
                  sErrMessage,0);
         SendNotification(Symbol()+" "+sErrMessage);
         SetSessionIsTradeEnable();
        }
     }
//+--------------------------------------------------------------+
//| 売りポジションオープン                                             |
//+--------------------------------------------------------------+
   void PositionOpenSell(int iBarNo=0)
     {

      //ポジション取得制限
      if(DayOfWeek() == 1 && TimeHour(TimeCurrent()) <  3) return;
      if(DayOfWeek() == 5 && TimeHour(TimeCurrent()) > 20) return;

      //証拠金チェック
      if(AccountFreeMarginCheck(Symbol(),OP_SELL,LOTCOUNT)<=0 || 
         GetLastError()==ERR_NOT_ENOUGH_MONEY)
        {

         //シグナル初期化
         SMTInitialize(iBarNo);
         return;
        }

      //売りポジションオープン
      int iRtnTicketNo=OrderSend(NULL,OP_SELL,LOTCOUNT,Bid,SLIPPAGE,
                                 Bid+STOPLOSS*Point,NULL,NULL,NULL,NULL,clrDarkRed);
      if(iRtnTicketNo==-1)
        {
         int iLastError=GetLastError();
         string sErrMessage=ErrorDescription(iLastError);
         TrailLog(LOGFILENAME,ERROR,POSITION,NULL,NULL,NULL,
                  sErrMessage,0);
         SendNotification(Symbol()+" "+sErrMessage);
         SetSessionIsTradeEnable();
        }
     }
//+------------------------------------------------------------------+
//| 残ポジション検索                                                    |
//+------------------------------------------------------------------+
   bool IsExistPosition(int iBarNo=0)
     {
      bool IsExist=false;
      //オーダー情報取得
      for(int i=0; i<OrdersTotal(); i++)
        {
         bool bSelected=OrderSelect(i,SELECT_BY_POS);
         if(OrderSymbol()==Symbol())
           {
            IsExist=true;
            break;
           }
        }
      return IsExist;
     }
//+------------------------------------------------------------------+
