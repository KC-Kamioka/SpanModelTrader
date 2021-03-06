//+------------------------------------------------------------------+
//|                                                      SMT0003.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

//+------------------------------------------------------------------+
//| ライブラリ                                                       |
//+------------------------------------------------------------------+
#include <SMT0001.mqh>

#import "SMT0003.ex4"
datetime iTimeMTF(string sSymbol,int iBarNo);
double iOpenMTF(string sSymbol,int iBarNo);
double iCloseMTF(string sSymbol,int iBarNo);
int iHighestMTF(string sSymbol,int iBarNo);
int iLowestMTF(string sSymbol,int iBarNo);
double iHighestPlusSigma22MTF(string sSymbol,int iBarNo);
double iLowestMnusSigma22MTF(string sSymbol,int iBarNo);
double iBandsMTF(string sSymbol,int iLineNo,int iBarNo);
int GetSBSLineSignalCount(string sSignal,int iBarNo);
bool CheckCloseSignal_SB1SigmaLine(string sSignal,
                                   double dPlus1Sigma,
                                   double dMnus1Sigma,
                                   double dH1ClosePrice,
                                   int iBarNo);
bool CheckCloseSignal_SB3SLAgainst(string sSignal,
                                   double dPrePlus3Sigma,
                                   double dPlus3Sigma,
                                   double dPreMnus3Sigma,
                                   double dMnus3Sigma,
                                   int iBarNo);
bool CheckCloseSignal_SBSimpleMA(string sSignal,
                                 double dClose,
                                 double dSimpleMA,
                                 int iBarNo);
string CheckSBSimpleMA(double dPreSimpleMA,
                       double dSimpleMA,
                       int iBarNo);
string CheckSBSigmaLine(double dH1ClosePrice,
                        double dPlus1Sigma,
                        double dMnus1Sigma,
                        int iBarNo);
string CheckSBDelayedSpan_HighAndLow(double dH1Highest,
                                     double dH1Lowest,
                                     double dH1ClosePrice,
                                     int iBarNo);
string CheckSBDelayedSpan_SigmaLine(double dH1ClosePrice,
                                    double dHighestPlusSigma22,
                                    double dLowestMnusSigma22,
                                    int iBarNo);
string CheckSBBandShrink(double dPrePlus2Sigma,
                         double dPrePlus3Sigma,
                         double dPlus2Sigma,
                         double dPlus3Sigma,
                         double dPreMnus2Sigma,
                         double dPreMnus3Sigma,
                         double dMnus2Sigma,
                         double dMnus3Sigma,
                         int iBarNo);
string CheckSBBandExpand(string sSBMASignal,
                         double dPrePlus3Sigma,
                         double dPrePlus2Sigma,
                         double dPrePlus1Sigma,
                         double dPlus3Sigma,
                         double dPlus2Sigma,
                         double dPlus1Sigma,
                         double dPreMnus3Sigma,
                         double dPreMnus2Sigma,
                         double dPreMnus1Sigma,
                         double dMnus3Sigma,
                         double dMnus2Sigma,
                         double dMnus1Sigma,
                         int iBarNo);
bool GetSuperBolingerRate(SuperBolingerRate &sbr,int iBarNo);                         
#import


//+------------------------------------------------------------------+
