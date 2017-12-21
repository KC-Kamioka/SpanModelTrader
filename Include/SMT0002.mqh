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
SpanModelPrice SetNewSMPrice(int iBarNo);
string CheckSMDelayedSpan(int iBarNo);
string CheckSMBlueSpan(int iBarNo);
bool CheckCloseSignal_SMBlueSpan(string sSignal,int iBarNo);
bool CheckCloseSignal_SMDelayedSpan(string sSignal,int iBarNo);   
#import
//+------------------------------------------------------------------+
