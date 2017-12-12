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
#include <SMT0004.mqh>
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
   price1=dPreSMDelayedSpan;
   price2=dSMDelayedSpan;
   ObjectCreate(0,sLineID4,OBJ_TRIANGLE,0,datetime1,price1,datetime2,price2,datetime2,price2);
   ObjectSetInteger(0,sLineID4,OBJPROP_COLOR,clrMagenta);
   ObjectSetInteger(0,sLineID4,OBJPROP_WIDTH,2);
   ObjectSetInteger(0,sLineID4,OBJPROP_BACK,false);

//買いシグナル点灯中
   if(dBlueSpan>dRedSpan)
     {
      //上部設定
      lColor=clrBlue;
      price1=dPreBlueSpan;
      price2=dBlueSpan;
      datetime1=dPreStTime;
      datetime2=dStTime;
      if(dPreBlueSpan>dBlueSpan)
        {
         price3=dBlueSpan;
         datetime3=dPreStTime;
        }
      else
        {
         price3=dPreBlueSpan;
         datetime3=dStTime;
        }
      ObjectCreate(0,sLineID1,OBJ_TRIANGLE,0,datetime1,price1,datetime2,price2,datetime3,price3);

      //中部設定
      datetime1=dPreStTime;
      datetime2=dStTime;
      if(dPreBlueSpan>dBlueSpan)
        {
         price1=dBlueSpan;
        }
      else
        {
         price1=dPreBlueSpan;
        }
      if(dPreRedSpan>dRedSpan)
        {
         price2=dPreRedSpan;
        }
      else
        {
         price2=dRedSpan;
        }
      ObjectCreate(0,sLineID2,OBJ_RECTANGLE,0,datetime1,price1,datetime2,price2);

      //下部設定
      price1=dPreRedSpan;
      price2=dRedSpan;
      datetime1=dPreStTime;
      datetime2=dStTime;
      if(dPreRedSpan>dRedSpan)
        {
         price3=dPreRedSpan;
         datetime3=dStTime;
        }
      else
        {
         price3=dRedSpan;
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
      price1=dPreRedSpan;
      price2=dRedSpan;
      datetime1=dPreStTime;
      datetime2=dStTime;
      if(dPreRedSpan>dRedSpan)
        {
         price3=dRedSpan;
         datetime3=dPreStTime;
        }
      else
        {
         price3=dPreRedSpan;
         datetime3=dStTime;
        }
      ObjectCreate(0,sLineID1,OBJ_TRIANGLE,0,datetime1,price1,datetime2,price2,datetime3,price3);

      //中部設定
      datetime1=dPreStTime;
      datetime2=dStTime;
      if(dPreBlueSpan>dBlueSpan)
        {
         price1=dPreBlueSpan;
        }
      else
        {
         price1=dBlueSpan;
        }
      if(dPreRedSpan>dRedSpan)
        {
         price2=dRedSpan;
        }
      else
        {
         price2=dPreRedSpan;
        }
      ObjectCreate(0,sLineID2,OBJ_RECTANGLE,0,datetime1,price1,datetime2,price2);

      //下部設定
      price1=dPreBlueSpan;
      price2=dBlueSpan;
      datetime1=dPreStTime;
      datetime2=dStTime;
      if(dPreBlueSpan>dBlueSpan)
        {
         price3=dPreBlueSpan;
         datetime3=dStTime;
        }
      else
        {
         price3=dBlueSpan;
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
             dH1OpenPrice,
             dH1ClosePrice);

//遅行スパン作成
   SuperBolingerMTF(GetSMTID(iBarNo),SB_DELAYEDSPAN,dtStartTime,dH1ClosePrice,dPreH1ClosePrice);

//移動平均線作成
   SuperBolingerMTF(GetSMTID(iBarNo),SB_SIMPLEMA,dtStartTime,dSimpleMA,dPreSimpleMA);

//+1シグマライン作成
   SuperBolingerMTF(GetSMTID(iBarNo),SB_PLUS1SIGMA,dtStartTime,dPlus1Sigma,dPrePlus1Sigma);

//-1シグマライン作成
   SuperBolingerMTF(GetSMTID(iBarNo),SB_MNUS1SIGMA,dtStartTime,dMnus1Sigma,dPreMnus1Sigma);

//+2シグマライン作成
   SuperBolingerMTF(GetSMTID(iBarNo),SB_PLUS2SIGMA,dtStartTime,dPlus2Sigma,dPrePlus2Sigma);

//-2シグマライン作成
   SuperBolingerMTF(GetSMTID(iBarNo),SB_MNUS2SIGMA,dtStartTime,dMnus2Sigma,dPreMnus2Sigma);

//+3シグマライン作成
   SuperBolingerMTF(GetSMTID(iBarNo),SB_PLUS3SIGMA,dtStartTime,dPlus3Sigma,dPrePlus3Sigma);

//-3シグマライン作成
   SuperBolingerMTF(GetSMTID(iBarNo),SB_MNUS3SIGMA,dtStartTime,dMnus3Sigma,dPreMnus3Sigma);

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
