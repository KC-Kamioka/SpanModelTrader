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
   if(SessionTrendTicket==NOPOSITION)
     {

      //トレンドチェック
      CheckTrend();

      //シグナルの状態表示
      SetObjSMTSignal(SessionSMBSSignal,SMTVPRICE1);
      SetObjSMTSignal(SessionSMCSSignal,SMTVPRICE2);
      SetObjSMTSignal(SessionSBMASignal,SMTVPRICE3);
      SetObjSMTSignal(SessionSBSLSignal,SMTVPRICE4);
      SetObjSMTSignal(SessionSBCSSignal,SMTVPRICE5);

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

      //基準線の値超えていなければクローズしない
      if(SessionSBSimpleMASigCnt>=LOWERKIJUNSEN-1)
        {
         //青色スパン＆終値チェック
         if(SessionIsClosedSMBlueSpan==false)
           {
            bool bRtn=CheckCloseSignal_SMBlueSpan(SessionOpenSignal);
            if(bRtn==true)
              {
               //ポジションクローズ
               PositionClose();
               SetSessionIsClosedSMBlueSpan(true);

              }
           }

         //遅行スパン逆転していない場合
         if(SessionIsClosedSMDelayedSpan==false)
           {
            bool bRtn=CheckCloseSignal_SMDelayedSpan(SessionOpenSignal);
            if(bRtn==true)
              {
               //ポジションクローズ
               PositionClose();
               SetSessionIsClosedSMDelayedSpan(true);
              }
           }

         //±2シグマラインを上回っている（下回っている）場合
         if(SessionIsClosedSB2SigmaLine==false)
           {
            bool bRtn=CheckCloseSignal_SB2SigmaLine(SessionOpenSignal);
            if(bRtn==true)
              {
               //ポジションクローズ
               PositionClose();
               SetSessionIsClosedSB2SigmaLine(true);
              }
           }
        }
      //SMAシグナルカウントアップ
      else if(TimeHour(Time[0])!=TimeHour(Time[1]))
        {
         SessionSBSimpleMASigCnt=SessionSBSimpleMASigCnt+1;
        }

      //±1シグマラインを上回っている（下回っている）場合
      if(SessionIsClosedSBSigmaLine==false)
        {

         //±1シグマラインチェック
         bool bRtn=CheckCloseSignal_SB1SigmaLine(SessionOpenSignal);
         if(bRtn==true)
           {
            //全ポジションクローズ
            PositionClose(true);
            SMTInitialize();
           }
        }

      //バンド幅縮小チェック
      bool bRtn=CheckCloseSignal_SB3SigmaLine();
      if(bRtn==true)
        {

         //全ポジションクローズ
         PositionClose(true);
         SMTInitialize();
        }

      //青色スパン赤色スパン逆転チェック
      CheckSMBlueSpan();
      if(SessionOpenSignal==SIGNALBUY&&
         SessionSMBSSignal==SIGNALSELL)
        {
         //全ポジションクローズ
         PositionClose(true);
         SMTInitialize();
        }
      else if(SessionOpenSignal==SIGNALSELL && 
         SessionSMBSSignal==SIGNALBUY)
           {
            //全ポジションクローズ
            PositionClose(true);
            SMTInitialize();
           }

         //週末チェック
         if(IsWeekend()==true)
           {
            //全ポジションクローズ
            PositionClose(true);
            SMTInitialize();
           }

      //ポジション保持グラフ設定
      if(SessionSBSimpleMASigCnt<LOWERKIJUNSEN-1)
        {
         SetObjSMTSignal(SessionOpenSignal,SMTVPRICE1);
        }
      if(SessionIsClosedSMBlueSpan==false)
        {
         SetObjSMTSignal(SessionOpenSignal,SMTVPRICE2);
        }
      if(SessionIsClosedSMDelayedSpan==false)
        {
         SetObjSMTSignal(SessionOpenSignal,SMTVPRICE3);
        }
      if(SessionIsClosedSBSigmaLine==false)
        {
         SetObjSMTSignal(SessionOpenSignal,SMTVPRICE4);
        }
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

      //シグナルの状態表示
      SetObjSMTSignal(SessionSMBSSignal,SMTVPRICE1,iBarNo);
      SetObjSMTSignal(SessionSMCSSignal,SMTVPRICE2,iBarNo);
      SetObjSMTSignal(SessionSBMASignal,SMTVPRICE3,iBarNo);
      SetObjSMTSignal(SessionSBSLSignal,SMTVPRICE4,iBarNo);
      SetObjSMTSignal(SessionSBCSSignal,SMTVPRICE5,iBarNo);

      //ダミーポジションオープン
      if(SessionOpenSignal==SIGNALBUY)
        {
         SetSessionTrendTicket(DUMMYPOSITION,iBarNo);
        }
      else if(SessionOpenSignal==SIGNALSELL)
        {
         SetSessionTrendTicket(DUMMYPOSITION,iBarNo);
        }
     }

//ポジションあり
   else
     {

      //基準線の値超えていなければクローズしない
      if(SessionSBSimpleMASigCnt>=LOWERKIJUNSEN-1)
        {

         //青色スパン＆終値チェック
         if(SessionIsClosedSMBlueSpan==false)
           {
            bool bRtn=CheckCloseSignal_SMBlueSpan(SessionOpenSignal,iBarNo);
            if(bRtn==true)
              {
               SetSessionIsClosedSMBlueSpan(true,iBarNo);
              }
           }

         //遅行スパン逆転していない場合
         if(SessionIsClosedSMDelayedSpan==false)
           {

            //遅行スパン逆転シグナルチェック
            bool bRtn=CheckCloseSignal_SMDelayedSpan(SessionOpenSignal,iBarNo);
            if(bRtn==true)
              {
               SetSessionIsClosedSMDelayedSpan(true,iBarNo);
              }
           }

         //±2シグマラインを上回っている（下回っている）場合
         if(SessionIsClosedSB2SigmaLine==false)
           {
            bool bRtn=CheckCloseSignal_SB2SigmaLine(SessionOpenSignal,iBarNo);
            if(bRtn==true)
              {
               SetSessionIsClosedSB2SigmaLine(true,iBarNo);
              }
           }
        }

      //SMAシグナルカウントアップ
      else if(TimeHour(Time[iBarNo])!=TimeHour(Time[iBarNo+1]))
        {
         SessionSBSimpleMASigCnt=SessionSBSimpleMASigCnt+1;
        }

      //±1シグマラインを上回っている（下回っている）場合
      if(SessionIsClosedSBSigmaLine==false)
        {

         //±1シグマラインチェック
         bool bRtn=CheckCloseSignal_SB1SigmaLine(SessionOpenSignal,iBarNo);
         if(bRtn==true)
           {
            SMTInitialize();
           }
        }

      //バンド幅縮小チェック
      bool bRtn=CheckCloseSignal_SB3SigmaLine(iBarNo);
      if(bRtn==true)
        {
         SMTInitialize();
        }

      //青色スパン赤色スパン逆転チェック
      CheckSMBlueSpan(iBarNo);
      if(SessionOpenSignal==SIGNALBUY&&
         SessionSMBSSignal==SIGNALSELL)
        {
         SMTInitialize();
        }
      else if(SessionOpenSignal==SIGNALSELL && 
         SessionSMBSSignal==SIGNALBUY)
           {
            SMTInitialize();
           }

         //週末チェック
         if(IsWeekend(iBarNo)==true)
           {
            SMTInitialize();
           }

      //ポジション保持グラフ設定
      if(SessionSBSimpleMASigCnt<LOWERKIJUNSEN-1)
        {
         SetObjSMTSignal(SessionOpenSignal,SMTVPRICE1,iBarNo);
        }
      if(SessionIsClosedSMBlueSpan==false)
        {
         SetObjSMTSignal(SessionOpenSignal,SMTVPRICE2,iBarNo);
        }
      if(SessionIsClosedSMDelayedSpan==false)
        {
         SetObjSMTSignal(SessionOpenSignal,SMTVPRICE3,iBarNo);
        }
      if(SessionIsClosedSBSigmaLine==false)
        {
         SetObjSMTSignal(SessionOpenSignal,SMTVPRICE4,iBarNo);
        }
     }
  }
//+------------------------------------------------------------------+
//| トレンドチェック                                                    |
//+------------------------------------------------------------------+
void CheckTrend(int iBarNo=0)
  {

//バンド幅縮小チェック
   if(SessionOpenSignal==NOSIGNAL)
     {
      string sSignal=CheckSBBandShrink(iBarNo);
      if(sSignal==NOSIGNAL) return;
      SetSessionOpenSignal(sSignal,iBarNo);
      SetObjSMTSignal(sSignal,0,iBarNo);
     }

//スパンモデル青色スパンチェック                                            
   CheckSMBlueSpan(iBarNo);

//スパンモデル遅行スパンチェック                                            
   CheckSMDelayedSpan(iBarNo);

//スーパーボリンジャーSMAチェック                                            
   CheckSBSimpleMA(iBarNo);

//スーパーボリンジャーシグマラインチェック                                            
   CheckSBSigmaLine(iBarNo);

//スーパーボリンジャー遅行スパンチェック                                            
   CheckSBDelayedSpan(iBarNo);

//±1シグマラインチェック
   bool bRtn=CheckCloseSignal_SB1SigmaLine(SessionOpenSignal,iBarNo);
   if(bRtn==true) SMTInitialize();

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
   void PositionClose(bool bAllClose=false)
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
      double dLotCount=0;
      if(bAllClose)dLotCount=OrderLots();
      else dLotCount=CLOSELOT;
      bool Closed=OrderClose(OrderTicket(),dLotCount,OrderClosePrice(),10,Magenta);
      if(Closed==true)
        {
         SearchExistPosition();
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
         GetLastError()==ERR_NOT_ENOUGH_MONEY)
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
         GetLastError()==ERR_NOT_ENOUGH_MONEY)
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
//| 残ポジション検索&セッションにセット                                    |
//+------------------------------------------------------------------+
   void SearchExistPosition()
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

      //チケット番号を変数にセット
      if(IsExist) SetSessionTrendTicket(OrderTicket());
      else SetSessionTrendTicket(NOPOSITION);
     }
//+------------------------------------------------------------------+
