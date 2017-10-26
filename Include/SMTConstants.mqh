//+------------------------------------------------------------------+
//|                                              SMTConstants.mqh |
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

#define INITBARCOUNT 1440        //初期化時確認バー数
#define SMTTEMPLATE    "SpanModelTrader"

#define DEBUGFLG 1

//+------------------------------------------------------------------+
//| ログコード
//+------------------------------------------------------------------+
//ログレベル
#define INFO             "1001"
#define ERROR            "1002"
#define DEBUG            "1003"

//シグナル
#define SPANMODEL        "3010"
#define BLUESPAN         "3011"
#define DELAYEDSPAN      "3012"
#define SUPERBOLINGER    "3020"
#define SIGMALINE        "3021"
#define SIMPLEMA         "3022"
#define SMTVPRICE1       120
#define SMTVPRICE2       100
#define SMTVPRICE3       80
#define SMTVPRICE4       60
#define SMTVPRICE5       40
#define SMTVPRICE6       20

//ポジション情報
#define POSITION         "5001"
#define SIGNALBUY        "6001"
#define SIGNALSELL       "6002"
#define NOSIGNAL         "6003"
#define SHRINK           "6004"
#define RANGE            "6005"
#define SIGNALBUY_STRONG "6006"
#define SIGNALBUY_WEAK   "6007"
#define SIGNALSELL_STRONG "6008"
#define SIGNALSELL_WEAK  "6009"

#define NOPOSITION       0
#define DUMMYPOSITION    999999999
#define TAKEPROFIT       500
#define STOPLOSS         1000                  //損切り設定
#define SLIPPAGE         100

//ログファイル名
static string LOGFILENAME="TrailLog_"+Symbol()+".csv";

static double LOTCOUNT=0.12;                 //オーダーロット数
static double CLOSELOT=0.03;                 //決済ロット

                                             //取引情報ファイル
#define TRADEINFOFILE  "TradeInfo_"+Symbol()+".csv"

//+------------------------------------------------------------------+
//| セッション                                                           |
//+------------------------------------------------------------------+
bool SessionIsExistPosition=false;     //チケットありフラグ
int SessionSMBSpanSigCnt = 0;     //スパンモデル青色スパンシグナルカウンター
int SessionSMCSpanSigCnt = 0;     //スパンモデル遅行スパンシグナルカウンター
int SessionSBSimpleMASigCnt=0;     //スーパーボリンジャー移動平均線シグナルカウンター
int SessionSBSLineSigCnt = 0;     //スーパーボリンジャーシグマラインシグナルカウンター
int SessionSBCSpanSigCnt = 0;     //スーパーボリンジャー遅行スパンシグナルカウンター
int SessionRangeCnt=0;
bool SessionIsClosedSMBlueSpan=false;
bool SessionIsClosedSMDelayedSpan=false;
bool SessionIsClosedSBSigmaLine=false;
bool SessionIsClosedSBDelayedSpan=false;
bool SessionIsAllClosed=false;
string SessionSMBSSignal = NOSIGNAL;
string SessionSMCSSignal = NOSIGNAL;
string SessionSBMASignal = NOSIGNAL;
string SessionSBEXSignal = NOSIGNAL;
string SessionSBSLSignal = NOSIGNAL;
string SessionSBCSSignal = NOSIGNAL;
string SessionOpenSignal = NOSIGNAL;

bool SessionIsTradeEnable=true;      //トレード可能フラグ
//+------------------------------------------------------------------+
