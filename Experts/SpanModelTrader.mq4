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
#include <SMT0002.mqh>
#include <SMT0003.mqh>

SpanModelPrice smp;
SuperBolingerPrice sbp;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

//コメント初期化
   Comment("");

//既存のオブジェクトを削除
   ObjectsDeleteAll();

//シグナルセット
//  for(int i=30; i>0; i--)
   for(int i=INITBARCOUNT; i>0; i--)
     {
      //スパンモデルの値をセット
      smp=SetNewSMPrice(i);

      //スーパーボリンジャーの値をセット
      sbp=SetNewSBPrice(i);

      //スーパーボリンジャー描画
      CeateSuperBolinger(i);

      //大局観把握
      SessionPerspective=GetPerspective(i);

      //トレンドフォロー
      SMTTrendFollow(i,true);
     }

   return(INIT_SUCCEEDED);
//---
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

//EA初期化
   SMTInitialize(0);

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {

//始値でのみ処理開始
   if(Volume[0]!=1)
     {
      //スパンモデルの値をセット
      smp=SetNewSMPrice(0);

      //スーパーボリンジャーの値をセット
      sbp=SetNewSBPrice(0);

      //スーパーボリンジャー描画
      CeateSuperBolinger(0);

      //週末チェック
      if(IsWeekend(0)==true)
        {
         //全ポジションクローズ
         PositionCloseAll();
         return;
        }

      //トレンドフォロー
      SMTTrendFollow(0);
     }
  }
//+------------------------------------------------------------------+
//|大局観把握                                        |
//+------------------------------------------------------------------+
string GetPerspective(int iBarNo)
  {
   SuperBolingerPrice wksbp;
   for(int i=0; i<6; i++)
     {
      int iRangeCount=0;
      iBarNo=iBarNo+Adjust_BarNo;
      wksbp=SetNewSBPrice(iBarNo);
      if(wksbp.dH1ClosePrice<wksbp.dPlus1Sigma &&
         wksbp.dH1ClosePrice>wksbp.dMnus1Sigma)
        {
         iRangeCount=iRangeCount+1;
        }
     }
   return NOSIGNAL;
  }
//+------------------------------------------------------------------+
//| スーパーボリンジャー作成主処理                                                      |
//+------------------------------------------------------------------+
void CeateSuperBolinger(int iBarNo)
  {
   if(TimeHour(Time[iBarNo])==TimeHour(Time[iBarNo+1])) return;

//始値の時間
   datetime dtStartTime=iTimeMTF(Symbol(),iH1OpenBarNo+iBarNo);

//遅行スパン作成
   SuperBolingerMTF(GetSMTID(iBarNo),SB_DELAYEDSPAN,dtStartTime,sbp.dH1ClosePrice,sbp.dPreH1ClosePrice);

//移動平均線作成
   SuperBolingerMTF(GetSMTID(iBarNo),SB_SIMPLEMA,dtStartTime,sbp.dSimpleMA,sbp.dPreSimpleMA);

//+1シグマライン作成
   SuperBolingerMTF(GetSMTID(iBarNo),SB_PLUS1SIGMA,dtStartTime,sbp.dPlus1Sigma,sbp.dPrePlus1Sigma);

//-1シグマライン作成
   SuperBolingerMTF(GetSMTID(iBarNo),SB_MNUS1SIGMA,dtStartTime,sbp.dMnus1Sigma,sbp.dPreMnus1Sigma);

//+2シグマライン作成
   SuperBolingerMTF(GetSMTID(iBarNo),SB_PLUS2SIGMA,dtStartTime,sbp.dPlus2Sigma,sbp.dPrePlus2Sigma);

//-2シグマライン作成
   SuperBolingerMTF(GetSMTID(iBarNo),SB_MNUS2SIGMA,dtStartTime,sbp.dMnus2Sigma,sbp.dPreMnus2Sigma);

//+3シグマライン作成
   SuperBolingerMTF(GetSMTID(iBarNo),SB_PLUS3SIGMA,dtStartTime,sbp.dPlus3Sigma,sbp.dPrePlus3Sigma);

//-3シグマライン作成
   SuperBolingerMTF(GetSMTID(iBarNo),SB_MNUS3SIGMA,dtStartTime,sbp.dMnus3Sigma,sbp.dPreMnus3Sigma);

  }
//+------------------------------------------------------------------+
//| スーパーボリンジャー作成                                                      |
//+------------------------------------------------------------------+
void SuperBolingerMTF(string sObjID,
                      int iSBLineNo,
                      datetime dStTime,
                      double dSBRate,
                      double dPreSBRate)
  {
   string sLineName=NULL;
   int iOpenBarNo=0;
   datetime dPreStTime=NULL;
   long lColor=0;
   int iLineWidth=1;

//遅行スパン作成
   if(iSBLineNo==SB_DELAYEDSPAN)
     {
      sLineName="SBDelayedSpan_";
      iOpenBarNo=iBarShift(NULL,PERIOD_M5,dStTime)+UPPERDELAYEDSPANBARNO;
      dStTime=Time[iOpenBarNo];
      lColor=clrMagenta;
      iLineWidth=4;
     }
   else
     {
      //移動平均線作成
      if(iSBLineNo==SB_SIMPLEMA)
        {
         sLineName="SBSimpleMA_";
         lColor=clrAquamarine;
        }
      //+1シグマライン作成
      else if(iSBLineNo==SB_PLUS1SIGMA)
        {
         sLineName="SBPlus1Sigma_";
         lColor=clrOrange;
        }
      //-1シグマライン作成
      else if(iSBLineNo==SB_MNUS1SIGMA)
        {
         sLineName="SBMnus1Sigma_";
         lColor=clrOrange;
        }
      //+2シグマライン作成
      else if(iSBLineNo==SB_PLUS2SIGMA)
        {
         sLineName="SBPlus2Sigma_";
         lColor=clrBlueViolet;
        }
      //-1シグマライン作成
      else if(iSBLineNo==SB_MNUS2SIGMA)
        {
         sLineName="SBMnus2Sigma_";
         lColor=clrBlueViolet;
        }
      //+1シグマライン作成
      else if(iSBLineNo==SB_PLUS3SIGMA)
        {
         sLineName="SBPlus3Sigma_";
         lColor=clrYellow;
        }
      //-1シグマライン作成
      else if(iSBLineNo==SB_MNUS3SIGMA)
        {
         sLineName="SBMnus3Sigma_";
         lColor=clrYellow;
        }
      iOpenBarNo=iBarShift(NULL,PERIOD_M5,dStTime);
     }
//         Print(IntegerToString(iOpenBarNo));

   dPreStTime=Time[iOpenBarNo+1];

   string sLineID1=sLineName+sObjID+"1";
   string sLineID2=sLineName+sObjID+"2";

//終値のバーの位置
   int iCloseBarNo=iOpenBarNo-Adjust_BarNo+1;
   datetime dEdTime=Time[iCloseBarNo];

//オブジェクト削除
   ObjectDelete(sLineID1);
   ObjectDelete(sLineID2);

//ライン作成
   ObjectCreate(0,sLineID1,OBJ_RECTANGLE,0,dStTime,dSBRate,dEdTime,dSBRate);
   ObjectCreate(0,sLineID2,OBJ_TRIANGLE,0,dStTime,dSBRate,dPreStTime,dPreSBRate,dPreStTime,dPreSBRate);

//プロパティの設定
   ObjectSetInteger(0,sLineID1,OBJPROP_COLOR,lColor);
   ObjectSetInteger(0,sLineID1,OBJPROP_WIDTH,iLineWidth);
   ObjectSetInteger(0,sLineID1,OBJPROP_BACK,false);
   ObjectSetInteger(0,sLineID2,OBJPROP_COLOR,lColor);
   ObjectSetInteger(0,sLineID2,OBJPROP_WIDTH,iLineWidth);
   ObjectSetInteger(0,sLineID2,OBJPROP_BACK,false);

  }
//+------------------------------------------------------------------+
//| メイン処理                                                        |
//+------------------------------------------------------------------+
void SMTTrendFollow(int iBarNo,bool IsInit=false)
  {

//ポジションオープンシグナル点灯中
   if(SessionIsExistPosition==true)
     {
      //ブレイクイーブン
      BreakEven();

      //売買終了チェック
      PositionCloseMain(IsInit,iBarNo);
     }

//ポジションオープンシグナル消灯中
   else
     {
      //全ポジションクローズ
      if(IsInit==false) PositionCloseAll();
     }

//全ポジションクローズの場合、再度ポジションオープンチェック
   if(SessionIsClosedSMBlueSpan==true && 
      SessionIsClosedSMDelayedSpan==true)
     {
      SessionIsExistPosition=false;
      SessionIsClosedSMBlueSpan=false;
      SessionIsClosedSMDelayedSpan=false;
      SessionOpenSignal=NOSIGNAL;
     }

//トレンドチェック
   CheckTrend(iBarNo);

//シグナル消灯中
   if(SessionTrendSignal==NOSIGNAL) return;

//トレンド終了チェック
   if(IsTrendEnd(iBarNo))
     {
      //シグナル初期化
      SMTInitialize(iBarNo);
      return;
     }

//ポジション取得制限
/*
   if(TimeDayOfWeek(Time[iBarNo])==1) return;
   if(TimeDayOfWeek(Time[iBarNo])==5) return;
   int iNowTimeHour=TimeHour(Time[iBarNo]);
   if(iNowTimeHour<9 || iNowTimeHour>18) return;
*/
//ポジションオープンシグナルセット
   //SetOpenSignal(iBarNo);
//青色スパンチェック                                            
   string sSMBSSignal=CheckSMBlueSpan(smp.dPreBlueSpan,
                                      smp.dPreRedSpan,
                                      iBarNo);
   SessionSMBSSignal=sSMBSSignal;
   SetObjSMTSignal(SessionSMBSSignal,SMTVPRICE07,iBarNo);

//遅行スパンチェック                                            
   string sSMDSSingal=CheckSMDelayedSpan(smp.dSMDelayedSpan,
                                         smp.dHighest,
                                         smp.dLowest,
                                         iBarNo);
   SessionSMCSSignal=sSMDSSingal;
   SetObjSMTSignal(SessionSMCSSignal,SMTVPRICE01,iBarNo);

//シグマラインチェック
   string sSMSLSingal=CheckSigmaLine(smp.dPlusSigma,
                                     smp.dMnusSigma,
                                     smp.dSMDelayedSpan,
                                     iBarNo);
   SessionSMSLSignal=sSMSLSingal;
   SetObjSMTSignal(SessionSMSLSignal,SMTVPRICE02,iBarNo);

//ポジション保持中はセットしない
   if(SessionIsExistPosition==true) return;

//買いシグナルセット
   if(SessionTrendSignal==UPPERTREND)
     {
      if(SessionSMBSSignal==SIGNALBUY &&
         SessionSMCSSignal==SIGNALBUY &&
         SessionSMSLSignal==SIGNALBUY &&
         SessionSBMASignal==SIGNALBUY)
        {
         SessionOpenSignal=SIGNALBUY;
         return;
        }
     }
//売りシグナルセット
   if(SessionTrendSignal==DOWNERTREND)
     {
      if(SessionSMBSSignal==SIGNALSELL &&
         SessionSMCSSignal==SIGNALSELL &&
         SessionSMSLSignal==SIGNALSELL &&
         SessionSBMASignal==SIGNALSELL)
        {
         SessionOpenSignal=SIGNALSELL;
         return;
        }
     }

//ポジションオープンシグナル消灯中
   if(SessionIsExistPosition==false)
     {
      //買いポジションオープン
      if(SessionOpenSignal==SIGNALBUY)
        {
         SessionIsExistPosition=true;
         if(IsInit==false)
           {
            if(PositionOpenBuy(STOPLOSS)==false) SMTInitialize(iBarNo);
           }
        }

      //売りポジションオープン
      else if(SessionOpenSignal==SIGNALSELL)
        {
         SessionIsExistPosition=true;
         if(IsInit==false)
           {
            if(PositionOpenSell(STOPLOSS)==false) SMTInitialize(iBarNo);
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//ポジション決済主処理
//+------------------------------------------------------------------+
void PositionCloseMain(bool IsInit,int iBarNo)
  {
   bool bRtn=false;

//青色スパン＆終値チェック
   if(SessionIsClosedSMBlueSpan==false)
     {
      SetObjSMTSignal(SessionOpenSignal,SMTVPRICE08,iBarNo);
      bRtn=false;
      bRtn=CheckCloseSignal_SMBlueSpan(SessionOpenSignal,
                                       smp.dBlueSpan,
                                       smp.dRedSpan,
                                       iBarNo);
      if(bRtn==true)
        {
         //ポジションクローズ
         if(IsInit==false)PositionClose();
         SessionIsClosedSMBlueSpan=true;
        }
     }

//遅行スパン逆転していない場合
   if(SessionIsClosedSMDelayedSpan==false)
     {
      SetObjSMTSignal(SessionOpenSignal,SMTVPRICE09,iBarNo);
      bRtn=false;
      bRtn=CheckCloseSignal_SMDelayedSpan(SessionOpenSignal,
                                          smp.dSMDelayedSpan,
                                          smp.dBlueSpan27,
                                          iBarNo);
      if(bRtn==true)
        {
         //ポジションクローズ
         if(IsInit==false)PositionClose();
         SessionIsClosedSMDelayedSpan=true;
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| トレンドチェック                                                      |
//+------------------------------------------------------------------+
void CheckTrend(int iBarNo)
  {

   if(TimeHour(Time[iBarNo])!=TimeHour(Time[iBarNo+1]))
     {

      //SMAチェック
      SessionSBMASignal=CheckSBSimpleMA(sbp.dPreSimpleMA,
                                        sbp.dSimpleMA,
                                        iBarNo);

      //バンド幅拡大チェック
      SessionSBEXSignal=CheckSBBandExpand(SessionSBMASignal,
                                          sbp.dPrePlus3Sigma,
                                          sbp.dPrePlus2Sigma,
                                          sbp.dPrePlus1Sigma,
                                          sbp.dPlus3Sigma,
                                          sbp.dPlus2Sigma,
                                          sbp.dPlus1Sigma,
                                          sbp.dPreMnus3Sigma,
                                          sbp.dPreMnus2Sigma,
                                          sbp.dPreMnus1Sigma,
                                          sbp.dMnus3Sigma,
                                          sbp.dMnus2Sigma,
                                          sbp.dMnus1Sigma,iBarNo);

/*
      //バンド縮小チェック
      SessionSBSRSignal=CheckSBBandShrink(sbp.dPrePlus2Sigma,
                                          sbp.dPrePlus3Sigma,
                                          sbp.dPlus2Sigma,
                                          sbp.dPlus3Sigma,
                                          sbp.dPreMnus2Sigma,
                                          sbp.dPreMnus3Sigma,
                                          sbp.dMnus2Sigma,
                                          sbp.dMnus3Sigma,
                                          iBarNo);
*/
      //シグマラインチェック                                            
      SessionSBSLSignal=CheckSBSigmaLine(sbp.dH1ClosePrice,
                                         sbp.dPlus1Sigma,
                                         sbp.dMnus1Sigma,
                                         iBarNo);

      //遅行スパン&高値or安値チェック
      SessionSBCHLSignal=CheckSBDelayedSpan_HighAndLow(sbp.dH1Highest,
                                                       sbp.dH1Lowest,
                                                       sbp.dH1ClosePrice,
                                                       iBarNo);
/*
      //遅行スパン&シグマライン
      SessionSBCSLSignal=CheckSBDelayedSpan_SigmaLine(sbp.dH1ClosePrice,
                                                      sbp.dHighestPlusSigma22,
                                                      sbp.dLowestMnusSigma22,
                                                      iBarNo);
*/
     }
/*
   if(SessionOpenSignal!=NOSIGNAL)
     {
*/
   SetObjSMTSignal(SessionSBMASignal,SMTVPRICE03,iBarNo);
   SetObjSMTSignal(SessionSBEXSignal,SMTVPRICE04,iBarNo);
   SetObjSMTSignal(SessionSBSLSignal,SMTVPRICE05,iBarNo);
   SetObjSMTSignal(SessionSBCHLSignal,SMTVPRICE06,iBarNo);
//   SetObjSMTSignal(SessionSBCSLSignal,SMTVPRICE07,iBarNo);
//     }

   if(SessionOpenSignal==SIGNALBUY ||
      SessionOpenSignal==SIGNALSELL)
     {
      return;
     }

//上昇トレンド発生
   if(SessionSBMASignal==SIGNALBUY &&
      SessionSBEXSignal==SIGNALBUY &&
      SessionSBSLSignal==SIGNALBUY &&
      /*
      SessionSBCHLSignal==SIGNALBUY &&
      SessionSBCSLSignal==SIGNALBUY)
*/
      SessionSBCHLSignal==SIGNALBUY)
     {
      SessionTrendSignal=UPPERTREND;
     }
//下降トレンド発生
   else if(SessionSBMASignal==SIGNALSELL && 
      SessionSBEXSignal==SIGNALSELL &&
      SessionSBSLSignal==SIGNALSELL &&
/*
      SessionSBCHLSignal==SIGNALSELL &&
      SessionSBCSLSignal==SIGNALSELL)
*/
      SessionSBCHLSignal==SIGNALSELL)
        {
         SessionTrendSignal=DOWNERTREND;
        }
      else
        {
         return;
        }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| トレンド終了チェック                                                      |
//+------------------------------------------------------------------+
bool IsTrendEnd(int iBarNo)
  {
//単純移動平均線が逆行した場合
   bool bRtn=CheckCloseSignal_SBSimpleMA(SessionOpenSignal,
                                         sbp.dH1ClosePrice,
                                         sbp.dSimpleMA,
                                         iBarNo);
   if(bRtn==true) return true;
   else return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| ポジションオープンシグナルセット                                          |
//+------------------------------------------------------------------+
void SetOpenSignal(int iBarNo)
  {

//青色スパンチェック                                            
   string sSMBSSignal=CheckSMBlueSpan(smp.dBlueSpan,smp.dRedSpan,iBarNo);
   SessionSMBSSignal=sSMBSSignal;
   SetObjSMTSignal(SessionSMBSSignal,SMTVPRICE07,iBarNo);

//遅行スパンチェック                                            
   string sSMDSSingal=CheckSMDelayedSpan(smp.dSMDelayedSpan,smp.dHighest,smp.dLowest,iBarNo);
   SessionSMCSSignal=sSMDSSingal;
   SetObjSMTSignal(SessionSMCSSignal,SMTVPRICE01,iBarNo);

//シグマラインチェック
   string sSMSLSingal=CheckSigmaLine(smp.dPlusSigma,smp.dMnusSigma,smp.dSMDelayedSpan,iBarNo);
   SessionSMSLSignal=sSMSLSingal;
   SetObjSMTSignal(SessionSMSLSignal,SMTVPRICE02,iBarNo);

  }
//+------------------------------------------------------------------+
