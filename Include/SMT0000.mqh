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
#define SMTVPRICE01       140
#define SMTVPRICE02       120
#define SMTVPRICE03       240
#define SMTVPRICE04       220
#define SMTVPRICE05       200
#define SMTVPRICE06       180
#define SMTVPRICE07       160
#define SMTVPRICE08       100
#define SMTVPRICE09       80
#define SMTVPRICE10       60
#define SMTVPRICE11       40
#define SMTVPRICE12       20

//ポジション情報
#define POSITION         "5001"
#define SIGNALBUY        "6001"
#define SIGNALSELL       "6002"
#define NOSIGNAL         "6003"
#define CHKSTART         "6004"
#define UPPERTREND       "6005"
#define DOWNERTREND      "6006"
#define SHRINK           "6007"

#define NOPOSITION       0
#define DUMMYPOSITION    999999999
#define TAKEPROFIT       300
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

static double LOTCOUNT=0.20;                 //オーダーロット数
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
//| セッション                                                           |
//+------------------------------------------------------------------+
bool SessionIsExistPosition=false;     //チケットありフラグ
int SessionSMBSpanSigCnt = 0;     //スパンモデル青色スパンシグナルカウンター
int SessionSMCSpanSigCnt = 0;     //スパンモデル遅行スパンシグナルカウンター
int SessionSBSLineSigCnt = 0;     //スーパーボリンジャーシグマラインシグナルカウンター
int SessionSBCSpanSigCnt = 0;     //スーパーボリンジャー遅行スパンシグナルカウンター
bool SessionIsClosedSMBlueSpan=false;
bool SessionIsClosedSMDelayedSpan=false;
bool SessionIsClosedSBDelayedSpan=false;
bool SessionIsClosedSB1SigmaLine=false;
bool SessionIsClosedSB3SLAgainst=false;
bool SessionIsClosedSBSLTakeProfit=false;
bool SessionScalpingFlg=false;
bool SessionIsExistScalpPos=false;
bool SessionRangeTradeFlg=false;
bool SessionTrendKeep=false;
string SessionSMBSSignal = NOSIGNAL;
string SessionSMCSSignal = NOSIGNAL;
string SessionSBMASignal = NOSIGNAL;
string SessionSBSRSignal = NOSIGNAL;
string SessionSBEXSignal = NOSIGNAL;
string SessionSBSLSignal = NOSIGNAL;
string SessionSBCHLSignal = NOSIGNAL;
string SessionSBCSLSignal = NOSIGNAL;
string SessionOpenSignal = NOSIGNAL;
string SessionScalpingSignal = NOSIGNAL;
bool SessionSentFlg = false;
//+------------------------------------------------------------------+
//| 構造体                                                             |
//+------------------------------------------------------------------+
struct SpanModelPrice 
  {

   //青色スパン
   double            dPreBlueSpan;
   double            dBlueSpan;

   //赤色スパン
   double            dPreRedSpan;
   double            dRedSpan;

   //遅行スパン
   double            dPreSMDelayedSpan;
   double            dSMDelayedSpan;

   //終値
   double            dClose27;

   //高値
   double            dHighest;

   //安値
   double            dLowest;

   //スパンモデル遅行スパン時のスーパーボリンジャーの値
   double            dSMPlusSigma27;
   double            dSMMnusSigma27;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct SuperBolingerPrice
  {
   double            dH1OpenPrice;
   double            dPreH1OpenPrice;
   double            dH1ClosePrice;
   double            dPreH1ClosePrice;
   double            dH1ClosePrice22;
   double            dPreH1ClosePrice22;
   double            dH1Highest;
   double            dH1Lowest;
   double            dPreSimpleMA;
   double            dSimpleMA;
   double            dPrePlus1Sigma;
   double            dPlus1Sigma;
   double            dPreMnus1Sigma;
   double            dMnus1Sigma;
   double            dPrePlus2Sigma;
   double            dPlus2Sigma;
   double            dPreMnus2Sigma;
   double            dMnus2Sigma;
   double            dPrePlus3Sigma;
   double            dPlus3Sigma;
   double            dPreMnus3Sigma;
   double            dMnus3Sigma;
   double            dPlusSigma22;
   double            dMnusSigma22;
   double            dHighestPlusSigma22;
   double            dLowestMnusSigma22;
  };
//+------------------------------------------------------------------+
