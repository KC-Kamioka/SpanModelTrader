//+------------------------------------------------------------------+
//|                                                      SMT0000.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
#include <stdlib.mqh>

//+------------------------------------------------------------------+
//| 定数                                                             |
//+------------------------------------------------------------------+
#define LOWERKIJUNSEN  9                     //基準線
#define LOWERSENKOSEN  26                    //下位時間基準線
#define LOWERSIGNALLM  52                    //下位シグナル継続制限
#define UPPERSENKOSEN  21                    //上位時間基準線

#define TRENDKEEP     6                     //トレンド継続数
#define CHKTRENDKEEP     9                     //トレンド継続数

#define INITBARCOUNT   1560                    //初期化時確認バー数
#define SMTTEMPLATE    "SpanModelTrader"
#define SMTLOGSEP " "
#define SMTRTNCODE "\n"
#define DEBUGFLG 0

//+------------------------------------------------------------------+
//| ログコード
//+------------------------------------------------------------------+

//シグナル
#define SPANMODEL        "3010"
#define BLUESPAN         "3011"
#define DELAYEDSPAN      "3012"
#define SUPERBOLINGER    "3020"
#define SIGMALINE        "3021"
#define SIMPLEMA         "3022"

//ポジション情報
#define POSITION         "5001"
#define SIGNALBUY        1
#define SIGNALSELL       2
#define NOSIGNAL         0
#define CHKSTART         "6004"
#define UPPERTREND       "6005"
#define DOWNERTREND      "6006"
#define SHRINK           "6007"

#define NOPOSITION       0
#define DUMMYPOSITION    999999999
#define TAKEPROFIT       3000
#define STOPLOSS         1000
#define SLIPPAGE         100

#define CLASSNAME0 "SMTConstants"
#define CLASSNAME1 "SMTCommon"
#define CLASSNAME2 "SpanModelCommon"
#define CLASSNAME3 "SuperBolingerCommon"
#define CLASSNAME4 "SMTTradeMain"
#define CLASSNAME5 "SMTScalping"

//ログ内容
string SessionLogContents=NULL;

static double LOTCOUNT=0.10;                 //オーダーロット数
static double CLOSELOT=0.05;                 //決済ロット

                                             //上位時間遅行スパンのバーの位置
#define UPPERDELAYEDSPANBARNO 263

//+------------------------------------------------------------------+
//| 変数                                                             |
//+------------------------------------------------------------------+
static int Adjust_BarNo=12;  //一時間足バー補正
int iH1OpenBarNo=Adjust_BarNo;
int iH1CloseBarNo=Adjust_BarNo;
int iPreH1CloseBarNo=Adjust_BarNo*2;
int iH1CloseBarNo22=UPPERDELAYEDSPANBARNO+iH1CloseBarNo;
int iPreH1CloseBarNo22=UPPERDELAYEDSPANBARNO+iPreH1CloseBarNo;

string OpenSymbol[10]=
  {
   "USDJPY",
   "GBPJPY",
   "GBPUSD",
   "EURJPY",
   "EURUSD",
   "AUDJPY",
   "AUDUSD",
   "EURGBP",
   "EURAUD",
   "GBPAUD"
  };
//+------------------------------------------------------------------+
//| 構造体                                                             |
//+------------------------------------------------------------------+
//---- ローソク足
struct Candle
  {
   datetime          dOpenTime;
   datetime          dCloseTime;
   double            dOpenRate;
   double            dCloseRate;
   double            dHighRate;
   double            dLowRate;
  };
//----

//---- スパンモデル
struct SpanModelRate
  {
   double            dBlueSpan;
   double            dDelayedBlueSpan;
   double            dRedSpan;
   double            dDelayedRedSpan;
   double            dHighest;
   double            dLowest;
   double            dDelayedSpan;
   double            dPlus1Sgma;
   double            dMnus1Sgma;
   double            dPlus2Sgma;
   double            dMnus2Sgma;
   double            dPlus3Sgma;
   double            dMnus3Sgma;
  };
//----

//---- スーパーボリンジャー
struct SuperBolingerRate
  {
   double            dSimpleMA;
   double            dPlus1Sigma;
   double            dMnus1Sigma;
   double            dPlus2Sigma;
   double            dMnus2Sigma;
   double            dPlus3Sigma;
   double            dMnus3Sigma;
   double            dDelayedSpan;
  };
//----

//---- オープンシグナル
struct OpenSignal
  {
   int               SpanModel_BlueSpan;
   int               SpanModel_DelayedSpan;
   int               SuperBolinger_DelayedSpan;
   //int               SuperBolinger_Expand3Sigma;
  };
//----
//+------------------------------------------------------------------+
