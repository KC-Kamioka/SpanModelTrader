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
    if(SessionTrendTicket == NOPOSITION){
    
        //トレンドチェック
        CheckTrend();
        
        //ダミーポジションオープン
        if(SessionOpenSignal == SIGNALBUY ||
           SessionOpenSignal == SIGNALSELL){
            PositionOpenRegular();
        }
    }
    
    //ポジションオープンシグナル点灯中
    else{
    
        //オープンシグナルオブジェクト作成
        SetObjSMTSignal(SPANMODEL,BLUESPAN,NULL,80);
        SetObjSMTSignal(SPANMODEL,CHIKOSPAN,NULL,60);
        SetObjSMTSignal(SUPERBOLINGER,SIGMALINE,NULL,40);
        SetObjSMTSignal(SUPERBOLINGER,CHIKOSPAN,NULL,20);

       //ダミーポジションクローズ
        if(SessionTrendTicket == INITTICKETMGNO){
            bool bRtn = PositionCloseRegularDummy();
            if(bRtn == true){
                SMTInitialize();
            }
        }
        
        //ポジションクローズ
        else if(SessionTrendTicket != NOPOSITION){
            bool bRtn = PositionCloseRegular();
            if(bRtn == true){
                SMTInitialize();
            }
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
        bool bRtn = PositionCloseRegularDummy(iBarNo);
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
//| トレンドフォローポジションクローズ（ダミー）                                    |
//+------------------------------------------------------------------+
bool PositionCloseRegularDummy(int iBarNo = 0){

    //決済フラグ
    bool bCloseSignal = false;

    //決済シグナルチェック
    bCloseSignal = CheckSMCloseSignal(SessionOpenSignal,iBarNo);
    
    return bCloseSignal;
}
//+--------------------------------------------------------------+
//| ポジションオープン（ダミー）                                      |
//+--------------------------------------------------------------+
void PositionOpenRegularDummy(int iBarNo = 0){

    SetSessionTrendTicket(INITTICKETMGNO,iBarNo);

}
//+------------------------------------------------------------------+
//| トレンドフォローポジションクローズ                                    |
//+------------------------------------------------------------------+
bool PositionCloseRegular(){
    
    //決済フラグ
    bool bCloseSignal = false;

    //オーダー情報取得
    bool bSelected = OrderSelect(SessionTrendTicket,SELECT_BY_TICKET,MODE_TRADES);
    if(bSelected == false){
        int iLastError = GetLastError();
        TrailLog(LOGFILENAME,ERROR,TRENDFOLLOW,POSITION,NULL,NULL,NULL,
                 ErrorDescription(iLastError),0);
        SetSessionIsTradeEnable();
    }
    
    //ポジション決済済みチェック
    if(OrderCloseTime() != 0){
        TrailLog(LOGFILENAME,INFO,TRENDFOLLOW,POSITION,NULL,NULL,NULL,MSG0014,0);
        return true;
    }
    
    //決済シグナルチェック
    bCloseSignal = CheckSMCloseSignal(SessionOpenSignal);
    
    //週末ポジション持越しない
    if(DayOfWeek() == 5 && TimeHour(TimeCurrent()) > 22){
        bCloseSignal = true;
    }
    
    //ポジションクローズ
    if(bCloseSignal == true){
        bool Closed = OrderClose(SessionTrendTicket,OrderLots(),OrderClosePrice(),10,Magenta);
        if(Closed == true){
            TrailLog(LOGFILENAME,INFO,TRENDFOLLOW,POSITION,NULL,NULL,NULL,MSG0013,0);
        }else{
            int iLastError = GetLastError();
            TrailLog(LOGFILENAME,ERROR,TRENDFOLLOW,POSITION,NULL,NULL,NULL,
                     ErrorDescription(iLastError),0);
            SetSessionIsTradeEnable();
        }
    }
    
    return bCloseSignal;
}
//+--------------------------------------------------------------+
//| ポジションオープン                                               |
//+--------------------------------------------------------------+
void PositionOpenRegular(){

    //ポジション取得制限
    if(DayOfWeek() == 1 && TimeHour(TimeCurrent()) <  3) return;
    if(DayOfWeek() == 5 && TimeHour(TimeCurrent()) > 20) return;
    
    //チケット番号
    int iRtnTicketNo = 0;

    //買いポジションオープン
    if(SessionSMBSSignal == SIGNALBUY){
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
    
    //売りポジションオープン
    else if(SessionSMBSSignal == SIGNALSELL){
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
}
//+------------------------------------------------------------------+