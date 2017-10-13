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
//+------------------------------------------------------------------+
//| メイン処理                                                        |
//+------------------------------------------------------------------+
void SMTTrendFollow()
  {

//ポジションなし
   if(IsExistPosition()==false)
     {

      //トレンドチェック
      CheckTrend();

      //買いポジションオープン
      if(SessionOpenSignal==SIGNALBUY)
        {
         PositionOpenBuy();
        }

      //売りポジションオープン
      else if(SessionOpenSignal==SIGNALSELL)
        {
         PositionOpenSell();
        }
     }

//ポジションオープンシグナル点灯中
   else
     {

      //青色スパン＆終値チェック
      if(SessionIsClosedSMBlueSpan==false)
        {
         bool bRtn=CheckCloseSignal_SMBlueSpan(SessionOpenSignal);
         if(bRtn==false)
           {

            SetObjSMTSignal(SPANMODEL,BLUESPAN,NULL,80);

              }else{

            //ポジションクローズ
            PositionClose(CLOSELOT);
            SetSessionIsClosedSMBlueSpan(true);

           }
        }

      //遅行スパン逆転していない場合
      if(SessionIsClosedSMDelayedSpan==false)
        {
         bool bRtn=CheckCloseSignal_SMDelayedSpan(SessionOpenSignal);
         if(bRtn==false)
           {

            SetObjSMTSignal(SPANMODEL,DELAYEDSPAN,NULL,60);

              }else{
            //ポジションクローズ
            PositionClose(CLOSELOT);
            SetSessionIsClosedSMDelayedSpan(true);
           }
        }

      //±1シグマラインを上回っている（下回っている）場合
      if(SessionIsClosedSBSigmaLine==false)
        {

         //±1シグマラインチェック
         bool bRtn=CheckCloseSignal_SBSigmaLine(SessionOpenSignal);
         if(bRtn==false)
           {
            SetObjSMTSignal(SUPERBOLINGER,SIGMALINE,NULL,40);
              }else{

            //全ポジションクローズ
            PositionClose(0,true);
            SMTInitialize();
            //SetSessionIsClosedSBSigmaLine(true);
           }
        }

      //週末チェック
      if(IsWeekend()==true)
        {
         PositionClose(0,true);
         SMTInitialize();
        }
/*
      //ポジションがすべて決済された場合、オープンシグナルを初期化する。
      if(SessionIsClosedSMBlueSpan==true && 
         SessionIsClosedSMDelayedSpan==true && 
         SessionIsClosedSBSigmaLine==true)
        {
         PositionClose(0,true);
         SMTInitialize();
        }
        */
     }
  }
//+------------------------------------------------------------------+
//| 起動時トレンドフォローシグナル設定                                       |
//+------------------------------------------------------------------+
void SetSMTTrendFollowSignal(int iBarNo)
  {

//ポジションなし
   if(SessionTrendTicket==NOPOSITION)
     {

      //トレンドチェック
      CheckTrend(iBarNo);

      //ダミーポジションオープン
      if(SessionOpenSignal== SIGNALBUY ||
         SessionOpenSignal==SIGNALSELL)
        {
         SetSessionTrendTicket(DUMMYPOSITION,iBarNo);
        }
     }

//ポジションあり
   else
     {

      //青色スパン＆終値チェック
      if(SessionIsClosedSMBlueSpan==false)
        {
         bool bRtn=CheckCloseSignal_SMBlueSpan(SessionOpenSignal,iBarNo);
         if(bRtn==false)
           {
            SetObjSMTSignal(SPANMODEL,BLUESPAN,NULL,80,iBarNo);
              }else{
            SetSessionIsClosedSMBlueSpan(true,iBarNo);
           }
        }

      //遅行スパン逆転していない場合
      if(SessionIsClosedSMDelayedSpan==false)
        {

         //遅行スパン逆転シグナルチェック
         bool bRtn=CheckCloseSignal_SMDelayedSpan(SessionOpenSignal,iBarNo);
         if(bRtn==false)
           {
            SetObjSMTSignal(SPANMODEL,DELAYEDSPAN,NULL,60,iBarNo);
              }else{
            SetSessionIsClosedSMDelayedSpan(true,iBarNo);
           }
        }

      //±1シグマラインを上回っている（下回っている）場合
      if(SessionIsClosedSBSigmaLine==false)
        {

         //±1シグマラインチェック
         bool bRtn=CheckCloseSignal_SBSigmaLine(SessionOpenSignal,iBarNo);
         if(bRtn==false)
           {
            SetObjSMTSignal(SUPERBOLINGER,SIGMALINE,NULL,40,iBarNo);
              }else{

            SMTInitialize();
            //SetSessionIsClosedSBSigmaLine(true,iBarNo);
           }
        }

      //週末チェック
      if(IsWeekend(iBarNo)==true)
        {
         SMTInitialize();
        }
/*
      //ポジションがすべて決済された場合、取引情報初期化する。
      if(SessionIsClosedSMBlueSpan==true && 
         SessionIsClosedSMDelayedSpan==true && 
         SessionIsClosedSBSigmaLine==true)
        {
         
         SMTInitialize();
        }
        */
     }
  }
//+------------------------------------------------------------------+
//| トレンドチェック                                                    |
//+------------------------------------------------------------------+
void CheckTrend(int iBarNo=0)
  {
   int iSignalHeight=90;
   int iDownPoint=10;

//バンド幅縮小チェック
   if(SessionOpenSignal==NOSIGNAL)
     {
      CheckSBBandShrink(iBarNo);
      SetObjSMTSignal(SUPERBOLINGER,SIGMALINE,SessionOpenSignal,0,iBarNo);
      if(SessionOpenSignal != SHRINK) return;
     }

//スパンモデル青色スパンチェック                                            
   CheckSMBlueSpan(iBarNo);
   iSignalHeight=iSignalHeight-iDownPoint; SetObjSMTSignal(SPANMODEL,BLUESPAN,SessionSMBSSignal,iSignalHeight,iBarNo);

//スパンモデル遅行スパンチェック                                            
   CheckSMDELAYEDSPAN(iBarNo);
   iSignalHeight=iSignalHeight-iDownPoint;
   SetObjSMTSignal(SPANMODEL,DELAYEDSPAN,SessionSMCSSignal,iSignalHeight,iBarNo);

//スーパーボリンジャーSMAチェック                                            
   CheckSBSimpleMA(iBarNo);
   iSignalHeight=iSignalHeight-iDownPoint;
   SetObjSMTSignal(SUPERBOLINGER,SIMPLEMA,SessionSBMASignal,iSignalHeight,iBarNo);

//スーパーボリンジャーシグマラインチェック                                            
   CheckSBSigmaLine(iBarNo);
   iSignalHeight=iSignalHeight-iDownPoint;
   SetObjSMTSignal(SUPERBOLINGER,SIGMALINE,SessionSBSLSignal,iSignalHeight,iBarNo);

//スーパーボリンジャー遅行スパンチェック                                            
   CheckSBDELAYEDSPAN(iBarNo);
   iSignalHeight=iSignalHeight-iDownPoint;
   SetObjSMTSignal(SUPERBOLINGER,DELAYEDSPAN,SessionSBCSSignal,iSignalHeight,iBarNo);

//シグナルチェック
   if(SessionSMBSSignal == SIGNALBUY &&
      SessionSMCSSignal == SIGNALBUY &&
      SessionSBMASignal == SIGNALBUY &&
      SessionSBSLSignal == SIGNALBUY &&
      SessionSBCSSignal==SIGNALBUY)
     {

      SetSessionOpenSignal(SIGNALBUY,iBarNo);

     }
   else if(SessionSMBSSignal==SIGNALSELL && 
      SessionSMCSSignal == SIGNALSELL &&
      SessionSBMASignal == SIGNALSELL &&
      SessionSBSLSignal == SIGNALSELL &&
      SessionSBCSSignal==SIGNALSELL)
        {

         SetSessionOpenSignal(SIGNALSELL,iBarNo);

        }

     }
//+------------------------------------------------------------------+
//| ポジションクローズ                                    |
//+------------------------------------------------------------------+
   void PositionClose(double dLotCount,bool bAllClose=false)
     {

      //オーダー情報取得
      bool bSelected=OrderSelect(SessionTrendTicket,SELECT_BY_TICKET);

      //ポジション決済済みチェック
      if(OrderCloseTime()!=0)
        {
         TrailLog(LOGFILENAME,INFO,POSITION,NULL,NULL,NULL,MSG0014,0);
         return;
        }

      //ポジションクローズ
      if(bAllClose)dLotCount=OrderLots();
      bool Closed=OrderClose(OrderTicket(),dLotCount,OrderClosePrice(),10,Magenta);
      if(Closed==true)
        {
         TrailLog(LOGFILENAME,INFO,POSITION,NULL,NULL,NULL,MSG0013,0);
           }else{
         int iLastError=GetLastError();
         string sErrMessage=ErrorDescription(iLastError);
         TrailLog(LOGFILENAME,ERROR,POSITION,NULL,NULL,NULL,
                  sErrMessage,0);
         SendNotification(Symbol()+sErrMessage);
         SetSessionIsTradeEnable();
        }

     }
//+--------------------------------------------------------------+
//| 買いポジションオープン                                               |
//+--------------------------------------------------------------+
   void PositionOpenBuy()
     {

      //ポジション取得制限
      if(DayOfWeek() == 1 && TimeHour(TimeCurrent()) <  3) return;
      if(DayOfWeek() == 5 && TimeHour(TimeCurrent()) > 20) return;

      //証拠金チェック
      if(AccountFreeMarginCheck(Symbol(),OP_BUY,LOTCOUNT)<=0 || 
         GetLastError()==134)
        {

         //シグナル初期化
         SMTInitialize();
         return;
        }

      //チケット番号
      int iRtnTicketNo=0;

      //買いポジションオープン
      iRtnTicketNo=OrderSend(NULL,OP_BUY,LOTCOUNT,Ask,SLIPPAGE,
                             Ask-STOPLOSS*Point,NULL,NULL,NULL,NULL,clrAqua);
      if(iRtnTicketNo!=-1)
        {
         SetSessionTrendTicket(iRtnTicketNo);
           }else{
         int iLastError=GetLastError();
         string sErrMessage=ErrorDescription(iLastError);
         TrailLog(LOGFILENAME,ERROR,POSITION,NULL,NULL,NULL,
                  sErrMessage,0);
         SendNotification(Symbol()+" "+sErrMessage);
         SetSessionIsTradeEnable();
        }
     }
//+--------------------------------------------------------------+
//| 売りポジションオープン                                               |
//+--------------------------------------------------------------+
   void PositionOpenSell()
     {

      //ポジション取得制限
      if(DayOfWeek() == 1 && TimeHour(TimeCurrent()) <  3) return;
      if(DayOfWeek() == 5 && TimeHour(TimeCurrent()) > 20) return;

      //証拠金チェック
      if(AccountFreeMarginCheck(Symbol(),OP_SELL,LOTCOUNT)<=0 || 
         GetLastError()==134)
        {

         //シグナル初期化
         SMTInitialize();
         return;
        }
      //チケット番号
      int iRtnTicketNo=0;

      //売りポジションオープン
      iRtnTicketNo=OrderSend(NULL,OP_SELL,LOTCOUNT,Bid,SLIPPAGE,
                             Bid+STOPLOSS*Point,NULL,NULL,NULL,NULL,clrDarkRed);
      if(iRtnTicketNo!=-1)
        {
         SetSessionTrendTicket(iRtnTicketNo);
           }else{
         int iLastError=GetLastError();
         string sErrMessage=ErrorDescription(iLastError);
         TrailLog(LOGFILENAME,ERROR,POSITION,NULL,NULL,NULL,
                  sErrMessage,0);
         SendNotification(Symbol()+" "+sErrMessage);
         SetSessionIsTradeEnable();
        }
     }
//+------------------------------------------------------------------+
//| ポジションチェック                                    |
//+------------------------------------------------------------------+
   bool IsExistPosition()
     {

      //オーダー情報取得
      for(int i=0; i<OrdersTotal(); i++)
        {
         bool bSelected=OrderSelect(i,SELECT_BY_POS);
         if(OrderSymbol()==Symbol())
           {
            SetSessionTrendTicket(OrderTicket());
            return true;
           }
        }

      return false;
     }
//+------------------------------------------------------------------+
