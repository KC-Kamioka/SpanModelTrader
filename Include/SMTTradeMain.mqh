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

   bool bRtn=false;
   
//処理開始ログ出力
   string sProcessName="SMTTrendFollow";
   TrailLog("INFO",sProcessName,iBarNo);

//+------------------------------------------------------------------+
//ポジションオープンシグナル消灯中
//+------------------------------------------------------------------+
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

//+------------------------------------------------------------------+
//ポジションオープンシグナル点灯中
//+------------------------------------------------------------------+
   else
     {

      //基準線の値超えていなければクローズしない
      if(SessionSBSimpleMASigCnt<LOWERKIJUNSEN-1)
        {
         //SMAシグナルカウントアップ
         if(TimeHour(Time[iBarNo])!=TimeHour(Time[iBarNo+1]))
           {
            SessionSBSimpleMASigCnt=SessionSBSimpleMASigCnt+1;
            TrailLog("INFO","MSG0027",iBarNo);
           }
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
         if(SessionIsAllClosed==false)
           {
            //青色スパン＆終値チェック
            if(SessionIsClosedSMBlueSpan==false)
              {
               SetObjSMTSignal(SessionOpenSignal,SMTVPRICE09,iBarNo);
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
               SetObjSMTSignal(SessionOpenSignal,SMTVPRICE10,iBarNo);
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
               SetSessionIsClosedSB2SigmaLine(true,iBarNo);
              }
           }
        }

      //+------------------------------------------------------------------+
      //全決済チェック
      //+------------------------------------------------------------------+
      if(SessionIsAllClosed==false)
        {
         SetObjSMTSignal(SessionOpenSignal,SMTVPRICE08,iBarNo);

         //バンド幅縮小チェック
         bRtn=false;
         bRtn=CheckCloseSignal_SB3SigmaLine(iBarNo);
         if(bRtn==true)
           {
            //全ポジションクローズ
            if(IsInit==false) PositionCloseAll();
            SetSessionIsClosedSB3SigmaLine(true,iBarNo);
           }

         //±1シグマラインチェック
         bRtn=false;
         bRtn=CheckCloseSignal_SB1SigmaLine(SessionOpenSignal,iBarNo);
         if(bRtn==true)
           {

            //全ポジションクローズ
            if(IsInit==false) PositionCloseAll();
            SetSessionIsClosedSB1SigmaLine(true,iBarNo);
           }

         //ポジション有無チェック
         if(IsInit==false && IsExistPosition()==false)
           {
            SetSessionTakeProfit(true,iBarNo);
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
               TrailLog("INFO","MSG0035",iBarNo);
              }

            //ポジションなし
            else
              {
               TrailLog("INFO","MSG0036",iBarNo);
              }
           }
        }

      //+------------------------------------------------------------------+
      //トレンド終了チェック
      //+------------------------------------------------------------------+
      SetObjSMTSignal(SessionOpenSignal,SMTVPRICE07,iBarNo);
      bRtn=false;
      bRtn=CheckCloseSignal_SBSimpleMA(SessionOpenSignal,iBarNo);
      if(bRtn==true)
        {
         //全ポジションクローズ
         if(IsInit==false) PositionCloseAll();
         SMTInitialize(iBarNo);
         
         //処理終了ログ出力
         TrailLog("INFO",sProcessName,iBarNo);
         return;
        }

      //+------------------------------------------------------------------+
      //週末チェック
      //+------------------------------------------------------------------+
      if(IsWeekend(iBarNo)==true)
        {
         //全ポジションクロー
         if(IsInit==false) PositionCloseAll();
         SMTInitialize(iBarNo);
         
         //処理終了ログ出力
         TrailLog("INFO",sProcessName,iBarNo);
         return;
        }
     }

//処理終了ログ出力
   TrailLog("INFO",sProcessName,iBarNo);
   return;
  }
//+------------------------------------------------------------------+
//| トレンドチェック                                                      |
//+------------------------------------------------------------------+
void CheckTrend(int iBarNo)
  {

//処理開始ログ出力
   string sProcessName="CheckTrend";
   TrailLog("INFO",sProcessName,iBarNo);

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
         TrailLog("INFO",sProcessName,iBarNo);
         return;
        }
     }

//+------------------------------------------------------------------+
//| スパンモデルチェック                                                |
//+------------------------------------------------------------------+
//青色スパンチェック                                            
   string sSMBSSignal=CheckSMBlueSpan(iBarNo);
   SetSessionSMBSSignal(sSMBSSignal,iBarNo);
   SetObjSMTSignal(SessionSMBSSignal,SMTVPRICE01,iBarNo);

//遅行スパンチェック                                            
   string sSMDSSingal=CheckSMDelayedSpan(iBarNo);
   SetSessionSMCSSignal(sSMDSSingal,iBarNo);
   SetObjSMTSignal(SessionSMCSSignal,SMTVPRICE02,iBarNo);
//+------------------------------------------------------------------+
//| スーパーボリンジャーチェック                                          |
//+------------------------------------------------------------------+
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
   TrailLog("INFO",sProcessName,iBarNo);
   return;
  }
//+------------------------------------------------------------------+
//| ポジションクローズ                                                    |
//+------------------------------------------------------------------+
void PositionClose()
  {
//処理開始ログ出力
   string sProcessName="PositionClose";
   TrailLog("INFO",sProcessName,0);

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
            TrailLog("INFO","MSG0013",0);
              }else{
            int iLastError=GetLastError();
            string sErrMessage=ErrorDescription(iLastError);
            TrailLog("ERROR",sErrMessage,0);
            SendNotification(Symbol()+" "+sErrMessage);
           }
         break;
        }
     }
     
  //処理終了ログ出力
   TrailLog("INFO",sProcessName,0);
   return;
  }
//+------------------------------------------------------------------+
//| 全ポジションクローズ                                                    |
//+------------------------------------------------------------------+
void PositionCloseAll()
  {

//処理開始ログ出力
   string sProcessName="PositionCloseAll";
   TrailLog("INFO",sProcessName,0);

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
            TrailLog("INFO","MSG0013",0);
              }else{
            int iLastError=GetLastError();
            string sErrMessage=ErrorDescription(iLastError);
            TrailLog("ERROR",sErrMessage,0);
            SendNotification(Symbol()+" "+sErrMessage);
           }
        }
     }
  //処理終了ログ出力
   TrailLog("INFO",sProcessName,0);
   return;
  }
//+--------------------------------------------------------------+
//| 買いポジションオープン                                             |
//+--------------------------------------------------------------+
void PositionOpenBuy(int iBarNo=0)
  {

//処理開始ログ出力
   string sProcessName="PositionOpenBuy";
   TrailLog("INFO",sProcessName,iBarNo);

//ポジション取得制限
   if(DayOfWeek() == 1 && TimeHour(TimeCurrent()) <  3) return;
   if(DayOfWeek() == 5 && TimeHour(TimeCurrent()) > 20) return;

//証拠金チェック
   if(AccountFreeMarginCheck(Symbol(),OP_BUY,LOTCOUNT)<=0 || 
      GetLastError()==ERR_NOT_ENOUGH_MONEY)
     {
      
      //ログ出力
      string sErrMessage=ErrorDescription(ERR_NOT_ENOUGH_MONEY);
      TrailLog("WARN",sErrMessage,0);
      SendNotification(Symbol()+" "+sErrMessage);
               
      //シグナル初期化
      SMTInitialize(iBarNo);
      return;
     }

//買いポジションオープン
   int iRtnTicketNo=OrderSend(NULL,OP_BUY,LOTCOUNT,Ask,SLIPPAGE,
                              Ask-STOPLOSS*Point,Ask+TAKEPROFIT*Point,NULL,NULL,NULL,clrAqua);
   if(iRtnTicketNo==-1)
     {
      int iLastError=GetLastError();
      string sErrMessage=ErrorDescription(iLastError);
      TrailLog("ERROR",sErrMessage,0);
      SendNotification(Symbol()+" "+sErrMessage);
     }
  //処理終了ログ出力
   TrailLog("INFO",sProcessName,iBarNo);
   return;
  }
//+--------------------------------------------------------------+
//| 売りポジションオープン                                             |
//+--------------------------------------------------------------+
void PositionOpenSell(int iBarNo=0)
  {

//処理開始ログ出力
   string sProcessName="PositionOpenSell";
   TrailLog("INFO",sProcessName,iBarNo);

//ポジション取得制限
   if(DayOfWeek() == 1 && TimeHour(TimeCurrent()) <  3) return;
   if(DayOfWeek() == 5 && TimeHour(TimeCurrent()) > 20) return;

//証拠金チェック
   if(AccountFreeMarginCheck(Symbol(),OP_SELL,LOTCOUNT)<=0 || 
      GetLastError()==ERR_NOT_ENOUGH_MONEY)
     {
      //ログ出力
      string sErrMessage=ErrorDescription(ERR_NOT_ENOUGH_MONEY);
      TrailLog("WARN",sErrMessage,0);
      SendNotification(Symbol()+" "+sErrMessage);

      //シグナル初期化
      SMTInitialize(iBarNo);
      return;
     }

//売りポジションオープン
   int iRtnTicketNo=OrderSend(NULL,OP_SELL,LOTCOUNT,Bid,SLIPPAGE,
                              Bid+STOPLOSS*Point,Bid-TAKEPROFIT*Point,NULL,NULL,NULL,clrDarkRed);
   if(iRtnTicketNo==-1)
     {
      int iLastError=GetLastError();
      string sErrMessage=ErrorDescription(iLastError);
      TrailLog("ERROR",sErrMessage,0);
      SendNotification(Symbol()+" "+sErrMessage);
     }
       //処理終了ログ出力
   TrailLog("INFO",sProcessName,iBarNo);
   return;
  }
//+------------------------------------------------------------------+
//| 残ポジション検索                                                    |
//+------------------------------------------------------------------+
bool IsExistPosition(int iBarNo=0)
  {
  
//処理開始ログ出力
   string sProcessName="IsExistPosition";
   TrailLog("INFO",sProcessName,iBarNo);

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
       //処理終了ログ出力
   TrailLog("INFO",sProcessName,iBarNo);
   return IsExist;
  }
//+------------------------------------------------------------------+
//| スキャルピング                                                                 |
//+------------------------------------------------------------------+
void Scalping(string sSignal,int iBarNo,bool IsInit=false)
  {

//処理開始ログ出力
   string sProcessName="Scalping";
   TrailLog("INFO",sProcessName,iBarNo);

//トレード中の場合
   if(IsInit==false)
     {
      double dPlus2Sigma=iBands(NULL,PERIOD_M5,21,2,0,PRICE_CLOSE,1,iBarNo);
      double dMnus2Sigma=iBands(NULL,PERIOD_M5,21,2,0,PRICE_CLOSE,2,iBarNo);
      double dClose=Close[iBarNo];
      //+------------------------------------------------------------------+
      //| 新規ポジション取得                                                  |
      //+------------------------------------------------------------------+
      if(IsExistPosition()==false)
        {

         //買いポジション取得
         if(sSignal==SIGNALBUY && dMnus2Sigma>dClose)
           {
            PositionOpenBuy();
           }

         //売りポジション取得
         else if(sSignal==SIGNALSELL && dPlus2Sigma<dClose)
           {
            PositionOpenSell();
           }
        }
      //+------------------------------------------------------------------+
      //| 手仕舞い                                                          |
      //+------------------------------------------------------------------+
      else
        {
         if(sSignal==SIGNALBUY && dPlus2Sigma<dClose)
           {
            //買いポジションクローズ
            PositionCloseAll();
           }
         else if(sSignal==SIGNALSELL && dMnus2Sigma>dClose)
           {
            //売りポジションクローズ
            PositionCloseAll();
           }
        }
     }

//初期化処理の場合
   else
     {

      double dPrePlus2Sigma=iBands(NULL,PERIOD_M5,21,2,0,PRICE_CLOSE,1,iBarNo+1);
      double dPreMnus2Sigma=iBands(NULL,PERIOD_M5,21,2,0,PRICE_CLOSE,2,iBarNo+1);
      double dHigh=High[iBarNo+1];
      double dLow=Low[iBarNo+1];
      //+------------------------------------------------------------------+
      //| 新規ポジション取得                                                  |
      //+------------------------------------------------------------------+
      if(SessionIsExistScalpPos==false)
        {

         //買いポジション取得
         if(sSignal==SIGNALBUY && dPreMnus2Sigma>dLow)
           {
            SessionIsExistScalpPos=true;

           }

         //売りポジション取得
         else if(sSignal==SIGNALSELL && dPrePlus2Sigma<dHigh)
           {
            SessionIsExistScalpPos=true;
           }

         TrailLog("INFO","MSG0035",iBarNo);
        }
      //+------------------------------------------------------------------+
      //| 手仕舞い                                                          |
      //+------------------------------------------------------------------+
      else
        {
         SetObjSMTSignal(SessionOpenSignal,SMTVPRICE11,iBarNo+1);
         if(sSignal==SIGNALBUY && dPrePlus2Sigma<dHigh)
           {
            //買いポジションクローズ
            SessionIsExistScalpPos=false;
           }
         else if(sSignal==SIGNALSELL && dPreMnus2Sigma>dLow)
           {
            //売りポジションクローズ
            SessionIsExistScalpPos=false;
           }

         TrailLog("INFO","MSG0036",iBarNo);

        }

     }
       //処理終了ログ出力
   TrailLog("INFO",sProcessName,iBarNo);
   return;
  }
//+------------------------------------------------------------------+
