//+------------------------------------------------------------------+
//|                                                      SMT0006.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

#import "SMT0006.ex4"
void CeateSpanModel(int iBarNo);
void CeateSuperBolinger(int iBarNo);
void SuperBolingerMTF(string sObjID,
                      int iSBLineNo,
                      datetime dStTime,
                      double dSBRate,
                      double dPreSBRate);
void RosokuMTF(string sObjID,
               datetime dStTime,
               double dStRate,
               double dEdRate);
#import
//----------------------------------------------------+
