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
         if(IsInit=false) PositionOpenBuy();
        }

      //売りポジションオープン
      else if(SessionOpenSignal==SIGNALSELL)
        {
         SetSessionIsExistPosition(true,iBarNo);
         if(IsInit=false) PositionOpenSell();
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
            bool bRtn=CheckCloseSignal_SMBlueSpan(SessionOpenSignal,iBarNo);
            if(bRtn==true)
              {
               //ポジションクローズ
               if(IsInit=false)PositionClose();
               SetSessionIsClosedSMBlueSpan(true,iBarNo);

              }
           }

         //遅行スパン逆転していない場合
         if(SessionIsClosedSMDelayedSpan==false)
           {
            bool bRtn=CheckCloseSignal_SMDelayedSpan(SessionOpenSignal,iBarNo);
            if(bRtn==true)
              {
               //ポジションクローズ
               if(IsInit=false)PositionClose();
               SetSessionIsClosedSMDelayedSpan(true,iBarNo);
              }
           }

         //±2シグマラインを上回っている（下回っている）場合
         if(SessionIsClosedSB2SigmaLine==false)
           {
            bool bRtn=CheckCloseSignal_SB2SigmaLine(SessionOpenSignal,iBarNo);
            if(bRtn==true)
              {
               //ポジションクローズ
               if(IsInit=false) PositionClose();
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
            //全ポジションクローズ
            if(IsInit=false) PositionCloseAll();
            SMTInitialize(iBarNo);
           }
        }

      //バンド幅縮小チェック
      bool bRtn=CheckCloseSignal_SB3SigmaLine(iBarNo);
      if(bRtn==true)
        {

         //全ポジションクローズ
         if(IsInit=false) PositionCloseAll();
         SMTInitialize(iBarNo);
        }

      //青色スパン赤色スパン逆転チェック
      CheckSMBlueSpan(iBarNo);
      if(SessionOpenSignal==SIGNALBUY&&
         SessionSMBSSignal==SIGNALSELL)
        {
         //全ポジションクローズ
         if(IsInit=false) PositionCloseAll();
         SMTInitialize(iBarNo);
        }
      else if(SessionOpenSignal==SIGNALSELL && 
         SessionSMBSSignal==SIGNALBUY)
           {
            //全ポジションクローズ
            if(IsInit=false) PositionCloseAll();
            SMTInitialize(iBarNo);
           }

         //週末チェック
         if(IsWeekend(iBarNo)==true)
           {
            //全ポジションクローズ
            if(IsInit=false) PositionCloseAll();
            SMTInitialize(iBarNo);
           }
     }
  }
//+------------------------------------------------------------------+
//| サブウインドウにシグナル表示                                            |
//+------------------------------------------------------------------+
void SMTDisplaySignal(int iBarNo)
  {
   if(SessionIsExistPosition==false)
     {
      //シグナルの状態表示
      SetObjSMTSignal(SessionSMBSSignal,SMTVPRICE1,iBarNo);
      SetObjSMTSignal(SessionSMCSSignal,SMTVPRICE2,iBarNo);
      SetObjSMTSignal(SessionSBMASignal,SMTVPRICE3,iBarNo);
      SetObjSMTSignal(SessionSBEXSignal,SMTVPRICE4,iBarNo);
      SetObjSMTSignal(SessionSBSLSignal,SMTVPRICE5,iBarNo);
      SetObjSMTSignal(SessionSBCSSignal,SMTVPRICE6,iBarNo);
     }

   else
     {
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
//   Print(TimeToString(Time[iBarNo])+" "+IntegerToString(SessionIsExistPosition));

        }

      //縮小中であれば処理しない
      if(SessionOpenSignal!=RANGE) return;
     }

//スパンモデル青色スパンチェック                                            
   string sSMBSSignal=CheckSMBlueSpan(iBarNo);
   SetSessionSMBSSignal(sSMBSSignal,iBarNo);

//スパンモデル遅行スパンチェック                                            
   string sSMDSSingal=CheckSMDelayedSpan(iBarNo);
   SetSessionSMCSSignal(sSMDSSingal,iBarNo);

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

//シグナルチェック
   if(SessionSMBSSignal==SIGNALBUY && 
      SessionSMCSSignal == SIGNALBUY &&
      SessionSBMASignal == SIGNALBUY &&
      SessionSBEXSignal == SIGNALBUY &&
      SessionSBSLSignal == SIGNALBUY &&
      SessionSBCSSignal==SIGNALBUY)
     {
      SetSessionOpenSignal(SIGNALBUY,iBarNo);
     }
   else if(SessionSMBSSignal==SIGNALSELL && 
      SessionSMCSSignal == SIGNALSELL &&
      SessionSBMASignal == SIGNALSELL &&
      SessionSBEXSignal == SIGNALSELL &&
      SessionSBSLSignal == SIGNALSELL &&
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
               TrailLog(LOGFILENAME,INFO,POSITION,NULL,NULL,NULL,MSG0013,0);
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
