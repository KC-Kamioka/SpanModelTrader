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
   Print(TimeToString(dtH1CloseTime));
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
   double dStRate=Open[iOpenBarNo];
   
//終値のバーの位置
   int iCloseBarNo=iOpenBarNo-Adjust_BarNo+1;
   datetime dEdTime=Time[iCloseBarNo];

// Print(TimeToString(dStTime));
//オブジェクト削除
   ObjectDelete(sRosoku);

//ローソク足のボディを設定
   ObjectCreate(0,sRosoku,OBJ_RECTANGLE,0,dStTime,dStRate,dEdTime,dEdRate);

//プロパティの設定
   ObjectSetInteger(0,sRosoku,OBJPROP_COLOR,clrBeige);
   ObjectSetInteger(0,sRosoku,OBJPROP_WIDTH,2);

//背景の設定
   bool IsEnableBKColor=true;
   if(dStRate<dEdRate) IsEnableBKColor=false;
   ObjectSetInteger(0,sRosoku,OBJPROP_BACK,IsEnableBKColor);

  }
//+------------------------------------------------------------------+
