//+------------------------------------------------------------------+
//|                                            SMTLibDelayedSpan.mq4 |
//|                   Copyright 2005-2015, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "2005-2015, MetaQuotes Software Corp."
#property link      "http://www.mql4.com"
#property library

#include <SMTLib.mqh>
#include <SMTLog.mqh>

//+------------------------------------------------------------------+
//| 遅行スパンシグナル取得                                              |
//+------------------------------------------------------------------+
void GetSignalDelayedSpan(int &iSignal,
                          int &iDelayedSpanSigCnt,
                          double dPreClose,
                          double dPreChikoSpan,
                          double dClose,
                          double dChikoSpan,
                          double dHighest,
                          double dLowest,
                          string sTTypeCode,
                          string sINameCode){

    //シグナル点灯中の場合
    if(iDelayedSpanSigCnt > 0){
        
        //買いシグナルの場合
        if(dPreClose <= dPreChikoSpan && dClose < dChikoSpan){
            iSignal = SIGNAL_BUY;
            iDelayedSpanSigCnt = iDelayedSpanSigCnt + 1;
        }
        
        //売りシグナルの場合
        else if(dPreClose >= dPreChikoSpan && dClose > dChikoSpan){
            iSignal = SIGNAL_SELL;
            iDelayedSpanSigCnt = iDelayedSpanSigCnt + 1;
        }
                
        //上記以外
        else{
            TrailLog(INFO,sTTypeCode,sINameCode,CHIKOSPAN,iDelayedSpanSigCnt,MSG0004);
            iDelayedSpanSigCnt = 0;
        }
        
    }
    
    //シグナル点灯していない場合
    else{
    
        //買いシグナル点灯
        if(dHighest <= dChikoSpan){
            iSignal = SIGNAL_BUY;
            iDelayedSpanSigCnt = iDelayedSpanSigCnt + 1;
            TrailLog(INFO,sTTypeCode,sINameCode,CHIKOSPAN,
                       iDelayedSpanSigCnt,MSG0006);
        }
    
        //売りシグナル点灯
        else if(dLowest >= dChikoSpan){
            iSignal = SIGNAL_SELL;
            iDelayedSpanSigCnt = iDelayedSpanSigCnt + 1;
            TrailLog(INFO,sTTypeCode,sINameCode,CHIKOSPAN,
                       iDelayedSpanSigCnt,MSG0007);
        }
 
    }
    
    return;

}
//+------------------------------------------------------------------+
