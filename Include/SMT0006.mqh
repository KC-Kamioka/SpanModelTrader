//+------------------------------------------------------------------+
//|                                                      SMT0006.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

//+------------------------------------------------------------------+
//| ライブラリ                                                         |
//+------------------------------------------------------------------+
#include <SMT0003.mqh>
//+------------------------------------------------------------------+
//| メイン処理                                                      |
//+------------------------------------------------------------------+
void CeateSuperBolinger(int iBarNo)
  {
   if(TimeHour(Time[iBarNo])==TimeHour(Time[iBarNo+1])) return;

//ローソク足作成
   RosokuMTF(GetSMTID(iBarNo),dtH1CloseTime,dH1ClosePrice);

//遅行スパン作成
   SuperBolingerMTF(GetSMTID(iBarNo),SB_DELAYEDSPAN,dtH1CloseTime,dH1ClosePrice);

  }
//+------------------------------------------------------------------+
//| スーパーボリンジャー作成                                                      |
//+------------------------------------------------------------------+
void SuperBolingerMTF(string sObjID,
                      int iSBLineNo,
                      datetime dStTime,
                      double dSBRate)
  {
   string sLineName=NULL;
   if(iSBLineNo==SB_DELAYEDSPAN)
     {
      sLineName="SBDelayedSpan_";
     }
   string sLineID=sLineName+sObjID;

//始値のバーの位置
   int iOpenBarNo=iBarShift(NULL,PERIOD_M5,dStTime)+UPPERDELAYEDSPANBARNO;
   dStTime=Time[iOpenBarNo];
//   Print(IntegerToString(iOpenBarNo));

//終値のバーの位置
   int iCloseBarNo=iOpenBarNo-Adjust_BarNo+1;
   datetime dEdTime=Time[iCloseBarNo];

//オブジェクト削除
   ObjectDelete(sLineID);

//ライン作成
   ObjectCreate(0,sLineID,OBJ_RECTANGLE,0,dStTime,dSBRate,dEdTime,dSBRate);

//プロパティの設定
   ObjectSetInteger(0,sLineID,OBJPROP_COLOR,clrMagenta);
   ObjectSetInteger(0,sLineID,OBJPROP_WIDTH,2);
   ObjectSetInteger(0,sLineID,OBJPROP_BACK,false);

  }
//+------------------------------------------------------------------+
//| ローソク足作成                                                      |
//+------------------------------------------------------------------+
void RosokuMTF(string sObjID,
               datetime dStTime,
               double dEdRate)
  {

   string sRosoku="Rosoku_Body"+sObjID;

//始値のバーの位置
   int iOpenBarNo=iBarShift(NULL,PERIOD_M5,dStTime);

//始値
   double dStRate=Open[iOpenBarNo];

//終値のバーの位置
   int iCloseBarNo=iOpenBarNo-Adjust_BarNo+1;
   datetime dEdTime=Time[iCloseBarNo];

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
