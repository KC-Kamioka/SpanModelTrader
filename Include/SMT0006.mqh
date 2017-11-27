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
//| ローソク足作成                                                      |
//+------------------------------------------------------------------+
void RosokuMTF(string sObjID,
               datetime dStTime,
               double dStRate,
               double dEdRate)
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
