//+------------------------------------------------------------------+
//|                                          SuperBolingerCommon.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

//+------------------------------------------------------------------+
//| ライブラリ                                                       |
//+------------------------------------------------------------------+
#include <SMTCommon.mqh>

//+------------------------------------------------------------------+
//| 定数                                                             |
//+------------------------------------------------------------------+
static int Adjust_BarNo = 12;  //一時間足バー補正

//+------------------------------------------------------------------+
//| スーパーボリンジャーシグマラインチェック                         |
//+------------------------------------------------------------------+
void CheckSBSigmaLine(int iBarNo = 0){
        
    if(TimeHour(Time[iBarNo]) == TimeHour(Time[iBarNo + 1])) return;

    //シグナル消灯
    if(SessionSBSLineSigCnt > UPPERSENKOSEN){
        SetSessionSBSLSignal(NOSIGNAL,iBarNo);
        return;
    }
    
    //1時間足の終値
    int iUpperPeriodBarNo = iBarNo + 1;
    double dClose = Close[iUpperPeriodBarNo];
    
    //スーパーボリンジャーの値
    double dPlus1Sigma    = iCustom(NULL,PERIOD_CURRENT,
                                    SUPERBOLINGER_MTF,SB_PLUS1SIGMA,
                                    iUpperPeriodBarNo);
    double dMnus1Sigma    = iCustom(NULL,PERIOD_CURRENT,
                                    SUPERBOLINGER_MTF,SB_MNUS1SIGMA,
                                    iUpperPeriodBarNo);
    
    //買いシグナルの場合
    if(CheckSBBandExpand(iBarNo) && dClose > dPlus1Sigma){
        SetSessionSBSLSignal(SIGNALBUY,iBarNo);
    }
    
    //売りシグナルの場合
    else if(CheckSBBandExpand(iBarNo) && dClose < dMnus1Sigma){
        SetSessionSBSLSignal(SIGNALSELL,iBarNo);
    }
    
    //上記以外
    else{
        SetSessionSBSLSignal(NOSIGNAL,iBarNo);
    }

    return;
    
}

//+------------------------------------------------------------------+
//| スーパーボリンジャー遅行スパンチェック                                 |
//+------------------------------------------------------------------+
void CheckSBChikoSpan(int iBarNo = 0){
    
    if(TimeHour(Time[iBarNo]) == TimeHour(Time[iBarNo + 1])) return;
   
    //1時間足の終値
    int iPreUpperPeriodBarNo = Adjust_BarNo + iBarNo + 1;
    int iUpperPeriodBarNo    = iBarNo + 1;
    double dChikoSpan        = Close[iUpperPeriodBarNo];
    
    //1時間足遅行スパン時の終値
    int iPreCloseCSpanUpperPeriodBarNo = UPPERCHIKOSPANBARNO + iPreUpperPeriodBarNo;
    int iCloseCSpanUpperPeriodBarNo    = UPPERCHIKOSPANBARNO + iUpperPeriodBarNo;
    double dClose                      = Close[iCloseCSpanUpperPeriodBarNo];
     
    //シグナル消灯
    if(SessionSBCSpanSigCnt >= UPPERSENKOSEN){
        SetSessionSBCSSignal(NOSIGNAL,iBarNo);
        return;
    }
    
    //シグナル点灯中の場合
    if(SessionSBCSpanSigCnt > 0){
        
        //買いシグナルの場合
        if(SessionSBCSSignal == SIGNALBUY &&
           dClose <= dChikoSpan){
            SetSessionSBCSSignal(SIGNALBUY,iBarNo);
        }
        
        //売りシグナルの場合
        else if(SessionSBCSSignal == SIGNALSELL &&
                dClose >= dChikoSpan){
            SetSessionSBCSSignal(SIGNALSELL,iBarNo);
        }
                
        //上記以外
        else{
            SetSessionSBCSSignal(NOSIGNAL,iBarNo);
        }
        
    }
    
    //シグナル点灯していない場合
    else{
    
        //高値安値をセット
        double dCloseH1 = 0;
        double dHighest = Close[iPreUpperPeriodBarNo];
        double dLowest  = Close[iPreUpperPeriodBarNo];
        int i = iPreUpperPeriodBarNo;
        while(i < UPPERCHIKOSPANBARNO){  
            
            //終値
            dCloseH1 = Close[i];
            
            //高値
            if(dHighest < dCloseH1) dHighest = dCloseH1;
            
            //安値
            if(dLowest  > dCloseH1) dLowest  = dCloseH1;
            
            i = i + Adjust_BarNo;
        }
        
        //買いシグナル点灯
        if(dHighest <= dChikoSpan){
            SetSessionSBCSSignal(SIGNALBUY,iBarNo);
        }
    
        //売りシグナル点灯
        else if(dLowest >= dChikoSpan){
            SetSessionSBCSSignal(SIGNALSELL,iBarNo);
        }
        
        //上記以外
        else{
            SetSessionSBCSSignal(NOSIGNAL,iBarNo);
        }
        
    }

    return;
}
//+------------------------------------------------------------------+
//| スーパーボリンジャーバンド幅縮小チェック                                    |
//+------------------------------------------------------------------+
void CheckSBBandShrink(int iBarNo = 0){
        
    if(TimeHour(Time[iBarNo]) == TimeHour(Time[iBarNo + 1])) return;
    
    //バーの位置
    int iPreUpperPeriodBarNo = Adjust_BarNo + iBarNo + 1;
    int iUpperPeriodBarNo = iBarNo + 1;
    
    //スーパーボリンジャーの値
    double dPrePlus3Sigma = iCustom(NULL,PERIOD_CURRENT,
                                    SUPERBOLINGER_MTF,SB_PLUS3SIGMA,
                                    iPreUpperPeriodBarNo);
    double dPlus3Sigma    = iCustom(NULL,PERIOD_CURRENT,
                                    SUPERBOLINGER_MTF,SB_PLUS3SIGMA,
                                    iUpperPeriodBarNo);
    double dPreMnus3Sigma = iCustom(NULL,PERIOD_CURRENT,
                                    SUPERBOLINGER_MTF,SB_MNUS3SIGMA,
                                    iPreUpperPeriodBarNo);
    double dMnus3Sigma    = iCustom(NULL,PERIOD_CURRENT,
                                    SUPERBOLINGER_MTF,SB_MNUS3SIGMA,
                                    iUpperPeriodBarNo);
                                                              
    //バンド幅縮小チェック
    if(dPrePlus3Sigma >= dPlus3Sigma &&
       dPreMnus3Sigma <= dMnus3Sigma){
       
       SetSessionOpenSignal(SHRINK,iBarNo);
       
    }
}
//+------------------------------------------------------------------+
//| スーパーボリンジャーバンド幅拡大チェック                                    |
//+------------------------------------------------------------------+
bool CheckSBBandExpand(int iBarNo = 0){
    
    bool bRtn = false;
    
    //バーの位置
    int iPreUpperPeriodBarNo = Adjust_BarNo + iBarNo + 1;
    int iUpperPeriodBarNo = iBarNo + 1;
    
    //スーパーボリンジャーの値
    double dPrePlus1Sigma = iCustom(NULL,PERIOD_CURRENT,
                                    SUPERBOLINGER_MTF,SB_PLUS1SIGMA,
                                    iPreUpperPeriodBarNo);
    double dPlus1Sigma    = iCustom(NULL,PERIOD_CURRENT,
                                    SUPERBOLINGER_MTF,SB_PLUS1SIGMA,
                                    iUpperPeriodBarNo);
    double dPreMnus1Sigma = iCustom(NULL,PERIOD_CURRENT,
                                    SUPERBOLINGER_MTF,SB_MNUS1SIGMA,
                                    iPreUpperPeriodBarNo);
    double dMnus1Sigma    = iCustom(NULL,PERIOD_CURRENT,
                                    SUPERBOLINGER_MTF,SB_MNUS1SIGMA,
                                    iUpperPeriodBarNo);
    double dPrePlus2Sigma = iCustom(NULL,PERIOD_CURRENT,
                                    SUPERBOLINGER_MTF,SB_PLUS2SIGMA,
                                    iPreUpperPeriodBarNo);
    double dPlus2Sigma    = iCustom(NULL,PERIOD_CURRENT,
                                    SUPERBOLINGER_MTF,SB_PLUS2SIGMA,
                                    iUpperPeriodBarNo);
    double dPreMnus2Sigma = iCustom(NULL,PERIOD_CURRENT,
                                    SUPERBOLINGER_MTF,SB_MNUS2SIGMA,
                                    iPreUpperPeriodBarNo);
    double dMnus2Sigma    = iCustom(NULL,PERIOD_CURRENT,
                                    SUPERBOLINGER_MTF,SB_MNUS2SIGMA,
                                    iUpperPeriodBarNo);
    double dPrePlus3Sigma = iCustom(NULL,PERIOD_CURRENT,
                                    SUPERBOLINGER_MTF,SB_PLUS3SIGMA,
                                    iPreUpperPeriodBarNo);
    double dPlus3Sigma    = iCustom(NULL,PERIOD_CURRENT,
                                    SUPERBOLINGER_MTF,SB_PLUS3SIGMA,
                                    iUpperPeriodBarNo);
    double dPreMnus3Sigma = iCustom(NULL,PERIOD_CURRENT,
                                    SUPERBOLINGER_MTF,SB_MNUS3SIGMA,
                                    iPreUpperPeriodBarNo);
    double dMnus3Sigma    = iCustom(NULL,PERIOD_CURRENT,
                                    SUPERBOLINGER_MTF,SB_MNUS3SIGMA,
                                    iUpperPeriodBarNo);
                                    
    //バンド幅縮小チェック
    if(dPrePlus1Sigma <= dPlus1Sigma &&
       dPrePlus2Sigma <= dPlus2Sigma &&
       dPrePlus3Sigma <= dPlus3Sigma &&
       dPreMnus1Sigma >= dMnus1Sigma &&
       dPreMnus2Sigma >= dMnus2Sigma &&
       dPreMnus3Sigma >= dMnus3Sigma){
       
        //ログ出力
        TrailLog(LOGFILENAME,INFO,SUPERBOLINGER,SIGMALINE,
                 NULL,NULL,MSG0021,iBarNo);
        bRtn = true;
       
    }
    return bRtn;
}
//+------------------------------------------------------------------+