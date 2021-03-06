//+------------------------------------------------------------------+
//|                                                      SMT0001.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
#include <stdlib.mqh>
#include <SMT0000.mqh>
#import "SMT0001.ex4"
bool PositionOpenBuy(int iStopLoss,int iBarNo=0);
bool PositionOpenSell(int iStopLoss,int iBarNo=0);
void PositionClose(double CloseLot);
void BreakEven();
bool IsExistPosition(int iBarNo=0);
bool IsWeekend(int iBarNo);
void PositionCloseAll();
#import
//+------------------------------------------------------------------+
//| 定数                                                             |
//+------------------------------------------------------------------+
#define SB_INDICATORNAME "SuperBolingerMTF"
#define SB_DELAYEDSPAN  0
#define SB_PLUS1SIGMA 1
#define SB_MNUS1SIGMA 2
#define SB_SIMPLEMA   3
#define SB_PLUS2SIGMA 4
#define SB_MNUS2SIGMA 5
#define SB_PLUS3SIGMA 6
#define SB_MNUS3SIGMA 7
//+------------------------------------------------------------------+
//| 文字埋め                                                          |
//+------------------------------------------------------------------+
string StrPadding(string sTarget,
                  string sStrPad,
                  int    iStrLength,
                  bool   IsLPad=false)
  {

   string sPads = NULL;
   string sRtn  = NULL;

//対象の文字列の長さ
   int iTargetLen=StringLen(sTarget);

//0の数
   int iZeroCnt=iStrLength-iTargetLen;

//返却文字列
   for(int i=0; i<iZeroCnt; i++)
     {
      sPads=sPads+sStrPad;
     }

   if(IsLPad==true) sRtn=sPads+sTarget;
   else               sRtn=sTarget+sPads;
   return sRtn;

  }
//+------------------------------------------------------------------+
//| ID取得                                                           |
//+------------------------------------------------------------------+
string GetSMTID(int iBarNo=0)
  {

   return IntegerToString(TimeYear(Time[iBarNo])) +
   StrPadding(IntegerToString(TimeMonth(Time[iBarNo])),"0",2,true)+
   StrPadding(IntegerToString(TimeDay(Time[iBarNo])),"0",2,true)+
   StrPadding(IntegerToString(TimeHour(Time[iBarNo])),"0",2,true)+
   StrPadding(IntegerToString(TimeMinute(Time[iBarNo])),"0",2,true)+
   StrPadding(IntegerToString(TimeSeconds(Time[iBarNo])),"0",2,true);

  }
//+------------------------------------------------------------------+
