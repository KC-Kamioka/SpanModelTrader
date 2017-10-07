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
void SMTTrendFollow(){  

    //ポジションなし
    if(IsExistPosition() == false){
    
        //トレンドチェック
        CheckTrend();
        
        //買いポジションオープン
        if(SessionOpenSignal == SIGNALBUY){
            PositionOpenBuy();
        }
        
        //売りポジションオープン
        else if(SessionOpenSignal == SIGNALSELL){
            PositionOpenSell();
        }
    }
    
    //ポジションオープンシグナル点灯中
    else{
    
        //オープンシグナルオブジェクト作成
        SetObjSMTSignal(SPANMODEL,BLUESPAN,NULL,80);
        SetObjSMTSignal(SPANMODEL,CHIKOSPAN,NULL,60);
        SetObjSMTSignal(SUPERBOLINGER,SIGMALINE,NULL,40);
        SetObjSMTSignal(SUPERBOLINGER,CHIKOSPAN,NULL,20);
        
        //決済シグナルチェック
        bool bCloseSignal = CheckSMCloseSignal(SessionOpenSignal);
    
        //ポジションクローズ
        if(bCloseSignal == true ||
           IsWeekend()  == true){
            PositionClose();
            SMTInitialize();
        }
        
    }
}
//+------------------------------------------------------------------+
//| 起動時トレンドフォローシグナル設定                                                    |
//+------------------------------------------------------------------+
void SetSMTTrendFollowSignal(int iBarNo){

    //ポジションなし
    if(SessionTrendTicket == NOPOSITION){
    
        //トレンドチェック
        CheckTrend(iBarNo);
        
        //ダミーポジションオープン
        if(SessionOpenSignal == SIGNALBUY ||
           SessionOpenSignal == SIGNALSELL){
            SetSessionTrendTicket(INITTICKETMGNO,iBarNo);
        }
    }
    
    //ポジションあり
    else{
    
        //オープンシグナルオブジェクト作成
        SetObjSMTSignal(SPANMODEL,BLUESPAN,NULL,80,iBarNo);
        SetObjSMTSignal(SPANMODEL,CHIKOSPAN,NULL,60,iBarNo);
        SetObjSMTSignal(SUPERBOLINGER,SIGMALINE,NULL,40,iBarNo);
        SetObjSMTSignal(SUPERBOLINGER,CHIKOSPAN,NULL,20,iBarNo);

        //クローズシグナルチェック
        bool bRtn = CheckSMCloseSignal(SessionOpenSignal,iBarNo);
        if(bRtn == true){
            SMTInitialize();
        }
   }
}
//+------------------------------------------------------------------+
//| トレンドチェック                                                    |
//+------------------------------------------------------------------+
void CheckTrend(int iBarNo = 0){
    
    //バンド幅縮小チェック
    if(SessionOpenSignal == NOSIGNAL){
        CheckSBBandShrink(iBarNo);
        SetObjSMTSignal(SUPERBOLINGER,SIGMALINE,SessionOpenSignal,0,iBarNo);
    }
    if(SessionOpenSignal != SHRINK) return;
             
    //スパンモデル青色スパンチェック                                            
    CheckSMBlueSpan(iBarNo);
    SetObjSMTSignal(SPANMODEL,BLUESPAN,SessionSMBSSignal,80,iBarNo);

    //スパンモデル遅行スパンチェック                                            
    CheckSMChikoSpan(iBarNo);
    SetObjSMTSignal(SPANMODEL,CHIKOSPAN,SessionSMCSSignal,60,iBarNo);

    //スーパーボリンジャーシグマラインチェック                                            
    CheckSBSigmaLine(iBarNo);
    SetObjSMTSignal(SUPERBOLINGER,SIGMALINE,SessionSBSLSignal,40,iBarNo);

    //スーパーボリンジャー遅行スパンチェック                                            
    CheckSBChikoSpan(iBarNo);
    SetObjSMTSignal(SUPERBOLINGER,CHIKOSPAN,SessionSBCSSignal,20,iBarNo);

    //シグナルチェック
    if(SessionSMBSSignal == SIGNALBUY &&
       SessionSMCSSignal == SIGNALBUY &&
       SessionSBSLSignal == SIGNALBUY &&
       SessionSBCSSignal == SIGNALBUY){
       
        SetSessionOpenSignal(SIGNALBUY,iBarNo);
    
    }
    else if(SessionSMBSSignal == SIGNALSELL &&
            SessionSMCSSignal == SIGNALSELL &&
            SessionSBSLSignal == SIGNALSELL &&
            SessionSBCSSignal == SIGNALSELL){
       
        SetSessionOpenSignal(SIGNALSELL,iBarNo);
    
    }

}
//+------------------------------------------------------------------+
//| ポジションクローズ                                    |
//+------------------------------------------------------------------+
void PositionClose(){
    
    //ダミーポジションクローズ
    if(SessionTrendTicket == INITTICKETMGNO) return;
    
    //オーダー情報取得
    bool bSelected = OrderSelect(SessionTrendTicket,SELECT_BY_TICKET);

    //ポジション決済済みチェック
    if(OrderCloseTime() != 0){
        TrailLog(LOGFILENAME,INFO,TRENDFOLLOW,POSITION,NULL,NULL,NULL,MSG0014,0);
        return;
    }
    
    //ポジションクローズ
    bool Closed = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),10,Magenta);
    if(Closed == true){
        TrailLog(LOGFILENAME,INFO,TRENDFOLLOW,POSITION,NULL,NULL,NULL,MSG0013,0);
    }else{
        int iLastError = GetLastError();
        TrailLog(LOGFILENAME,ERROR,TRENDFOLLOW,POSITION,NULL,NULL,NULL,
                     ErrorDescription(iLastError),0);
        SetSessionIsTradeEnable();
    }
        
}
//+--------------------------------------------------------------+
//| 買いポジションオープン                                               |
//+--------------------------------------------------------------+
void PositionOpenBuy(){

    //ポジション取得制限
    if(DayOfWeek() == 1 && TimeHour(TimeCurrent()) <  3) return;
    if(DayOfWeek() == 5 && TimeHour(TimeCurrent()) > 20) return;
    
    //証拠金チェック
    if(AccountFreeMarginCheck(Symbol(),OP_BUY,LOTCOUNT)<=0 ||
       GetLastError()==134){
       
         //ダミーポジションオープン
          SetSessionTrendTicket(INITTICKETMGNO);
       return;
    } 

    //チケット番号
    int iRtnTicketNo = 0;

    //買いポジションオープン
    iRtnTicketNo = OrderSend(NULL,OP_BUY,LOTCOUNT,Ask,NULL,
                             Ask-STOPLOSS*Point,NULL,NULL,NULL,NULL,clrAqua);
    if(iRtnTicketNo != -1){
        SetSessionTrendTicket(iRtnTicketNo);
    }else{
        int iLastError = GetLastError();
        TrailLog(LOGFILENAME,ERROR,TRENDFOLLOW,POSITION,NULL,SIGNALBUY,NULL,
                 ErrorDescription(iLastError),0);
        SetSessionIsTradeEnable();
    }
}

//+--------------------------------------------------------------+
//| 売りポジションオープン                                               |
//+--------------------------------------------------------------+
void PositionOpenSell(){

    //ポジション取得制限
    if(DayOfWeek() == 1 && TimeHour(TimeCurrent()) <  3) return;
    if(DayOfWeek() == 5 && TimeHour(TimeCurrent()) > 20) return;
    
    //証拠金チェック
    if(AccountFreeMarginCheck(Symbol(),OP_SELL,LOTCOUNT)<=0 ||
       GetLastError()==134){
       
         //ダミーポジションオープン
          SetSessionTrendTicket(INITTICKETMGNO);
       return;
    } 
    //チケット番号
    int iRtnTicketNo = 0;

    //売りポジションオープン
    iRtnTicketNo = OrderSend(NULL,OP_SELL,LOTCOUNT,Bid,NULL,
                             Bid+STOPLOSS*Point,NULL,NULL,NULL,NULL,clrDarkRed);
    if(iRtnTicketNo != -1){
        SetSessionTrendTicket(iRtnTicketNo);
    }else{
        int iLastError = GetLastError();
        TrailLog(LOGFILENAME,ERROR,TRENDFOLLOW,POSITION,NULL,SIGNALSELL,NULL,
                 ErrorDescription(iLastError),0);
        SetSessionIsTradeEnable();
    }
}
//+------------------------------------------------------------------+
//| ポジションチェック                                    |
//+------------------------------------------------------------------+
bool IsExistPosition(){
    
    //チケット番号設定チェック
    if(SessionTrendTicket != NOPOSITION) return true;
    
    //オーダー情報取得
    for(int i = 0; i < OrdersTotal(); i++){
        bool bSelected = OrderSelect(i,SELECT_BY_POS);
        if(OrderSymbol() == Symbol()){
            SetSessionTrendTicket(OrderTicket());
            return true;
        }
    }
    
    return false;
}
//+------------------------------------------------------------------+