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
      //スパンモデル描画
      CeateSpanModel(i);

      //スーパーボリンジャー描画
      CeateSuperBolinger(i);

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
      //スパンモデル描画
      CeateSpanModel(0);

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
//| スパンモデル作成主処理                                                      |
//+------------------------------------------------------------------+
void CeateSpanModel(int iBarNo) export
  {
   string sObjID=GetSMTID(iBarNo);
   string sLineName1="BlueSpan_";
   string sLineName2="SpanBody_";
   string sLineName3="RedSpan_";
   string sLineName4="DelayedSpan_";

   string sLineID1=sLineName1+sObjID;
   string sLineID2=sLineName2+sObjID;
   string sLineID3=sLineName3+sObjID;
   string sLineID4=sLineName4+sObjID;

   datetime dPreStTime=Time[iBarNo+2];

//プロパティの設定
   datetime dStTime=Time[iBarNo+1];

//オブジェクト削除
   ObjectDelete(sLineID1);
   ObjectDelete(sLineID2);
   ObjectDelete(sLineID3);
   ObjectDelete(sLineID4);

//ライン作成
   long lColor=0;
   double price1=0;
   double price2=0;
   double price3=0;
   datetime datetime1=NULL;
   datetime datetime2=NULL;
   datetime datetime3=NULL;

//遅行スパン作成
   datetime1=Time[LOWERSENKOSEN+iBarNo+2];
   datetime2=Time[LOWERSENKOSEN+iBarNo+1];
   price1=smp.dPreSMDelayedSpan;
   price2=smp.dSMDelayedSpan;
   ObjectCreate(0,sLineID4,OBJ_TRIANGLE,0,datetime1,price1,datetime2,price2,datetime2,price2);
   ObjectSetInteger(0,sLineID4,OBJPROP_COLOR,clrMagenta);
   ObjectSetInteger(0,sLineID4,OBJPROP_WIDTH,2);
   ObjectSetInteger(0,sLineID4,OBJPROP_BACK,false);

//買いシグナル点灯中
   if(smp.dBlueSpan>smp.dRedSpan)
     {
      //上部設定
      lColor=clrBlue;
      price1=smp.dPreBlueSpan;
      price2=smp.dBlueSpan;
      datetime1=dPreStTime;
      datetime2=dStTime;
      if(smp.dPreBlueSpan>smp.dBlueSpan)
        {
         price3=smp.dBlueSpan;
         datetime3=dPreStTime;
        }
      else
        {
         price3=smp.dPreBlueSpan;
         datetime3=dStTime;
        }
      ObjectCreate(0,sLineID1,OBJ_TRIANGLE,0,datetime1,price1,datetime2,price2,datetime3,price3);

      //中部設定
      datetime1=dPreStTime;
      datetime2=dStTime;
      if(smp.dPreBlueSpan>smp.dBlueSpan)
        {
         price1=smp.dBlueSpan;
        }
      else
        {
         price1=smp.dPreBlueSpan;
        }
      if(smp.dPreRedSpan>smp.dRedSpan)
        {
         price2=smp.dPreRedSpan;
        }
      else
        {
         price2=smp.dRedSpan;
        }
      ObjectCreate(0,sLineID2,OBJ_RECTANGLE,0,datetime1,price1,datetime2,price2);

      //下部設定
      price1=smp.dPreRedSpan;
      price2=smp.dRedSpan;
      datetime1=dPreStTime;
      datetime2=dStTime;
      if(smp.dPreRedSpan>smp.dRedSpan)
        {
         price3=smp.dPreRedSpan;
         datetime3=dStTime;
        }
      else
        {
         price3=smp.dRedSpan;
         datetime3=dPreStTime;
        }
      ObjectCreate(0,sLineID3,OBJ_TRIANGLE,0,datetime1,price1,datetime2,price2,datetime3,price3);
      ObjectSetInteger(0,sLineID1,OBJPROP_COLOR,lColor);
      ObjectSetInteger(0,sLineID2,OBJPROP_COLOR,lColor);
      ObjectSetInteger(0,sLineID3,OBJPROP_COLOR,lColor);
     }

//売りシグナル点灯中
   else
     {
      //上部設定
      lColor=clrRed;
      price1=smp.dPreRedSpan;
      price2=smp.dRedSpan;
      datetime1=dPreStTime;
      datetime2=dStTime;
      if(smp.dPreRedSpan>smp.dRedSpan)
        {
         price3=smp.dRedSpan;
         datetime3=dPreStTime;
        }
      else
        {
         price3=smp.dPreRedSpan;
         datetime3=dStTime;
        }
      ObjectCreate(0,sLineID1,OBJ_TRIANGLE,0,datetime1,price1,datetime2,price2,datetime3,price3);

      //中部設定
      datetime1=dPreStTime;
      datetime2=dStTime;
      if(smp.dPreBlueSpan>smp.dBlueSpan)
        {
         price1=smp.dPreBlueSpan;
        }
      else
        {
         price1=smp.dBlueSpan;
        }
      if(smp.dPreRedSpan>smp.dRedSpan)
        {
         price2=smp.dRedSpan;
        }
      else
        {
         price2=smp.dPreRedSpan;
        }
      ObjectCreate(0,sLineID2,OBJ_RECTANGLE,0,datetime1,price1,datetime2,price2);

      //下部設定
      price1=smp.dPreBlueSpan;
      price2=smp.dBlueSpan;
      datetime1=dPreStTime;
      datetime2=dStTime;
      if(smp.dPreBlueSpan>smp.dBlueSpan)
        {
         price3=smp.dPreBlueSpan;
         datetime3=dStTime;
        }
      else
        {
         price3=smp.dBlueSpan;
         datetime3=dPreStTime;
        }
      ObjectCreate(0,sLineID3,OBJ_TRIANGLE,0,datetime1,price1,datetime2,price2,datetime3,price3);
      ObjectSetInteger(0,sLineID1,OBJPROP_COLOR,lColor);
      ObjectSetInteger(0,sLineID2,OBJPROP_COLOR,lColor);
      ObjectSetInteger(0,sLineID3,OBJPROP_COLOR,lColor);
     }
  }
//+------------------------------------------------------------------+
//| スーパーボリンジャー作成主処理                                                      |
//+------------------------------------------------------------------+
void CeateSuperBolinger(int iBarNo) export
  {
   if(TimeHour(Time[iBarNo])==TimeHour(Time[iBarNo+1])) return;

//始値の時間
   datetime dtStartTime=iTimeMTF(Symbol(),iH1OpenBarNo+iBarNo);

//ローソク足作成
   RosokuMTF(GetSMTID(iBarNo),
             dtStartTime,
             sbp.dH1OpenPrice,
             sbp.dH1ClosePrice);

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
                      double dPreSBRate) export
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
//| ローソク足作成                                                      |
//+------------------------------------------------------------------+
void RosokuMTF(string sObjID,
               datetime dStTime,
               double dStRate,
               double dEdRate) export
  {

   string sRosoku="Rosoku_Body"+sObjID;

//終値の時間
   int iShiftBarNo=iBarShift(NULL,PERIOD_M5,dStTime)-Adjust_BarNo+1;
   datetime dEdTime=iTime(NULL,PERIOD_M5,iShiftBarNo);

//オブジェクト削除
   ObjectDelete(sRosoku);

//ローソク足のボディを設定
   ObjectCreate(0,sRosoku,OBJ_RECTANGLE,0,dStTime,dStRate,dEdTime,dEdRate);

//プロパティの設定
   ObjectSetInteger(0,sRosoku,OBJPROP_COLOR,clrBeige);
   ObjectSetInteger(0,sRosoku,OBJPROP_WIDTH,2);

//背景の設定
   bool IsEnableBKColor=true;
   if(dStRate<=dEdRate) IsEnableBKColor=false;
   ObjectSetInteger(0,sRosoku,OBJPROP_BACK,IsEnableBKColor);

  }
//+------------------------------------------------------------------+
//| メイン処理                                                        |
//+------------------------------------------------------------------+
void SMTTrendFollow(int iBarNo,bool IsInit=false)
  {

//スパンモデルの値をセット
   smp=SetNewSMPrice(iBarNo);

//スーパーボリンジャーの値をセット
   SetNewSBPrice(iBarNo);

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

//トレンドチェック
   CheckTrend(iBarNo);

//シグナル消灯中
   if(SessionOpenSignal==NOSIGNAL)
     {
      return;
     }

//トレンド終了チェック
   if(SessionOpenSignal==SIGNALBUY ||
      SessionOpenSignal==UPPERTREND)
     {
      if(SessionSBMASignal==SIGNALSELL)
        {
         //シグナル初期化
         SMTInitialize(iBarNo);
         return;
        }
      if(SessionSBSLSignal==SIGNALSELL)
        {
         //シグナル初期化
         SMTInitialize(iBarNo);
         return;
        }
      if(SessionSBSRSignal==SHRINK)
        {
         //シグナル初期化
         SMTInitialize(iBarNo);
         return;
        }

     }
   else if(SessionOpenSignal==SIGNALSELL || 
      SessionOpenSignal==DOWNERTREND)
        {
         if(SessionSBMASignal==SIGNALBUY)
           {
            //シグナル初期化
            SMTInitialize(iBarNo);
            return;
           }
         if(SessionSBSLSignal==SIGNALBUY)
           {
            //シグナル初期化
            SMTInitialize(iBarNo);
            return;
           }
         if(SessionSBSRSignal==SHRINK)
           {
            //シグナル初期化
            SMTInitialize(iBarNo);
            return;
           }
        }

      //ポジション取得制限
      if(TimeDayOfWeek(Time[iBarNo])==1) return;
   if(TimeDayOfWeek(Time[iBarNo])==5) return;

//ポジションオープンシグナルセット
   SetOpenSignal(iBarNo);

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
      bRtn=CheckCloseSignal_SMBlueSpan(SessionOpenSignal,iBarNo);
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
      bRtn=CheckCloseSignal_SMDelayedSpan(SessionOpenSignal,iBarNo);
      if(bRtn==true)
        {
         //ポジションクローズ
         if(IsInit==false)PositionClose();
         SessionIsClosedSMDelayedSpan=true;
        }
     }

//±3シグマライン逆行チェック
   if(SessionIsClosedSB3SLAgainst==false)
     {
      SetObjSMTSignal(SessionOpenSignal,SMTVPRICE10,iBarNo);
      bRtn=false;
      bRtn=CheckCloseSignal_SB3SLAgainst(SessionOpenSignal,iBarNo);
      if(bRtn==true)
        {
         //ポジションクローズ
         if(IsInit==false)PositionClose();
         SessionIsClosedSB3SLAgainst=true;
        }
     }

//±1シグマラインチェック
   if(SessionIsClosedSB1SigmaLine==false)
     {
      SetObjSMTSignal(SessionOpenSignal,SMTVPRICE11,iBarNo);
      bRtn=false; bRtn=CheckCloseSignal_SB1SigmaLine(SessionOpenSignal,iBarNo);
      if(bRtn==true)
        {
         //ポジションクローズ
         if(IsInit==false)PositionClose();
         SessionIsClosedSB1SigmaLine=true;
        }
     }
/*
//±2シグマラインを上回っている（下回っている）場合、利益確定
   if(SessionIsClosedSBSLTakeProfit==false)
     {
      SetObjSMTSignal(SessionOpenSignal,SMTVPRICE12,iBarNo);
      if(TimeHour(Time[iBarNo])!=TimeHour(Time[iBarNo+1]))
        {
         //トレンド継続数の値超えていなければクローズしない
         if(GetSBSLineSignalCount(SessionOpenSignal,iBarNo)<TRENDKEEP)
           {
            bRtn=CheckCloseSignal_SB2SigmaLine(SessionOpenSignal,iBarNo);
            if(bRtn==true)
              {
               //ポジションクローズ
               if(IsInit==false)PositionClose();
               SessionIsClosedSBSLTakeProfit=true;
              }
           }
        }
     }
*/

//トレンド終了チェック
   bRtn=CheckCloseSignal_SBSimpleMA(SessionOpenSignal,iBarNo);
   if(bRtn==true || SessionSBSRSignal==SHRINK)
     {
      //全て決済済み
      SessionIsClosedSMBlueSpan=true;
      SessionIsClosedSMDelayedSpan=true;
      SessionIsClosedSB3SLAgainst=true;
      SessionIsClosedSB1SigmaLine=true;
      SessionIsClosedSBSLTakeProfit=true;

      //全ポジションクローズ
      if(IsInit==false) PositionCloseAll();
      return;
     }
  }
//+------------------------------------------------------------------+
//全ポジション決済主処理
//+------------------------------------------------------------------+
bool PositionCloseAllMain(bool IsInit,int iBarNo)
  {
   bool bRtn=false;

//トレンド継続マーク
   SetObjSMTSignal(SessionOpenSignal,SMTVPRICE07,iBarNo);

//トレンド終了チェック
   bRtn=CheckCloseSignal_SBSimpleMA(SessionOpenSignal,iBarNo);
   if(bRtn==true)
     {
      //全ポジションクローズ
      if(IsInit==false) PositionCloseAll();
      return bRtn;
     }
//週末チェック
   if(IsWeekend(iBarNo)==true)
     {
      //全ポジションクローズ
      if(IsInit==false) PositionCloseAll();
      return bRtn;
     }
//トレンド継続数の値超えていなければクローズしない
   if(GetSBSLineSignalCount(SessionOpenSignal,iBarNo)<TRENDKEEP)
     {
      //±3シグマラインチェック
      bRtn=CheckCloseSignal_SB3SLAgainst(SessionOpenSignal,iBarNo);
      if(bRtn==true)
        {
         //全ポジションクローズ
         if(IsInit==false) PositionCloseAll();
         return bRtn;
        }
     }
   return bRtn;
  }
//+------------------------------------------------------------------+
//| トレンドチェック                                                      |
//+------------------------------------------------------------------+
void CheckTrend(int iBarNo)
  {

   if(TimeHour(Time[iBarNo])!=TimeHour(Time[iBarNo+1]))
     {

      //遅行スパンクロスチェック
      //SMAチェック
      SessionSBMASignal=CheckSBSimpleMA(iBarNo);

      //バンド幅拡大チェック
      SessionSBEXSignal=CheckSBBandExpand(iBarNo);

      //バンド縮小チェック
      SessionSBSRSignal=CheckSBBandShrink(iBarNo);

      //シグマラインチェック                                            
      SessionSBSLSignal=CheckSBSigmaLine(iBarNo);

      //遅行スパン&高値or安値チェック
      SessionSBCHLSignal=CheckSBDelayedSpan_HighAndLow(iBarNo);

      //遅行スパン&シグマライン
      SessionSBCSLSignal=CheckSBDelayedSpan_SigmaLine(iBarNo);

     }
   if(SessionOpenSignal!=NOSIGNAL)
     {

      SetObjSMTSignal(SessionSBMASignal,SMTVPRICE03,iBarNo);
      SetObjSMTSignal(SessionSBEXSignal,SMTVPRICE04,iBarNo);
      SetObjSMTSignal(SessionSBSLSignal,SMTVPRICE05,iBarNo);
      SetObjSMTSignal(SessionSBCHLSignal,SMTVPRICE06,iBarNo);
      SetObjSMTSignal(SessionSBCSLSignal,SMTVPRICE07,iBarNo);
     }
   if(SessionOpenSignal==SIGNALBUY ||
      SessionOpenSignal==SIGNALSELL)
     {
      return;
     }
//上昇トレンド発生
   if(SessionSBMASignal==SIGNALBUY &&
      SessionSBEXSignal==SIGNALBUY &&
      SessionSBSLSignal==SIGNALBUY &&
      SessionSBCHLSignal==SIGNALBUY &&
      SessionSBCSLSignal==SIGNALBUY)
     {
      SessionOpenSignal=UPPERTREND;
     }
//下降トレンド発生
   else if(SessionSBMASignal==SIGNALSELL && 
      SessionSBEXSignal==SIGNALSELL &&
      SessionSBSLSignal==SIGNALSELL &&
      SessionSBCHLSignal==SIGNALSELL &&
      SessionSBCSLSignal==SIGNALSELL)
        {
         SessionOpenSignal=DOWNERTREND;
        }
  }
//+------------------------------------------------------------------+
//| ポジションオープンシグナルセット                                                      |
//+------------------------------------------------------------------+
void SetOpenSignal(int iBarNo)
  {

//青色スパンチェック                                            
   string sSMBSSignal=CheckSMBlueSpan(iBarNo);
   SetSessionSMBSSignal(sSMBSSignal,iBarNo);
   SetObjSMTSignal(SessionSMBSSignal,SMTVPRICE01,iBarNo);

//遅行スパンチェック                                            
   string sSMDSSingal=CheckSMDelayedSpan(iBarNo);
   SetSessionSMCSSignal(sSMDSSingal,iBarNo);
   SetObjSMTSignal(SessionSMCSSignal,SMTVPRICE02,iBarNo);
//買いシグナルセット
   if(SessionOpenSignal==UPPERTREND &&
      SessionSMBSSignal==SIGNALBUY &&
      SessionSMCSSignal==SIGNALBUY &&
      SessionSBMASignal==SIGNALBUY &&
      SessionSBEXSignal==SIGNALBUY &&
      SessionSBSLSignal==SIGNALBUY &&
      SessionSBCHLSignal==SIGNALBUY &&
      SessionSBCSLSignal==SIGNALBUY)
     {
      SessionOpenSignal=SIGNALBUY;
      return;
     }
//売りシグナルセット
   if(SessionOpenSignal==DOWNERTREND &&
      SessionSMBSSignal==SIGNALSELL &&
      SessionSMCSSignal==SIGNALSELL &&
      SessionSBMASignal==SIGNALSELL &&
      SessionSBEXSignal==SIGNALSELL &&
      SessionSBSLSignal==SIGNALSELL &&
      SessionSBCHLSignal==SIGNALSELL &&
      SessionSBCSLSignal==SIGNALSELL)
     {
      SessionOpenSignal=SIGNALSELL;
      return;
     }
  }
//+------------------------------------------------------------------+
