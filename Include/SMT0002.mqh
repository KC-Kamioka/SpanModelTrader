//+------------------------------------------------------------------+
//|                                                      SMT0002.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

#include <SMT0001.mqh>
#import "SMT0002.ex4"
bool GetSpanModelRate(SpanModelRate &smp,int iBarNo);
string CheckSMBlueSpan(double dBlueSpan,double dRedSpan,int iBarNo);
string CheckSMDelayedSpan(double dSMDelayedSpan,double dHighest,double dLowest,int iBarNo);
string CheckSigmaLine(double dPlusSigma,double dMnusSigma,double dClose,int iBarNo);
bool CheckCloseSignal_SMBlueSpan(string sSignal,double dBlueSpan,double dRedSpan,int iBarNo);
bool CheckCloseSignal_SMDelayedSpan(string sSignal,double dSMDelayedSpan,double dClose27,int iBarNo);
#import
//+------------------------------------------------------------------+
