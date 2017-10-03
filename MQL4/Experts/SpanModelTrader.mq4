//+------------------------------------------------------------------+
//|                                              SpanModelTrader.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| ライブラリ                                                          |
//+------------------------------------------------------------------+
#include <SMTTradeMain.mqh>
#include <SMTSubFunction.mqh>

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---

    //既存のオブジェクトを削除
    ObjectsDeleteAll();   
    
    //EA初期化
    SMTInitialize();

    //ログファイル作成
    CreateLogFile(LOGFILENAME);
    
    for(int i=INITBARCOUNT; i>0; i--){
        SetSMTTrendFollowSignal(i);
/*
        if(SMTTrendFollow(true,i) == true){
          SMTInitialize(i);
        }
*/
    }
    
    //ソースバックアップ
    ExecuteCopyBatch(TerminalInfoString(TERMINAL_DATA_PATH) + "\\MQL4",
                    SOURCEBKPATH);

    //シグナル名表示
    DisplaySignalName();
    
    //シグナル表示
    Comment(GetDisplaySignal());

    return(INIT_SUCCEEDED);
//---
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
 
    //EA初期化
    SMTInitialize();
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){

    //始値でのみ処理開始
    static datetime dTmpTime = Time[0];
    if(Time[0] == dTmpTime) return;
    dTmpTime = Time[0];
    
    //トレード停止
    if(SessionIsTradeEnable == false){
        Comment(GetCodeContent(MSG0019));
        return;
    }
    
    //トレンドフォロー
    SMTTrendFollow();

    //シグナル名表示
    DisplaySignalName(); 

    //シグナル表示
    Comment(GetDisplaySignal());
}
//+------------------------------------------------------------------+