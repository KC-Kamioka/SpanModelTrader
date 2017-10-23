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
#define SMTVPRICE1       100
#define SMTVPRICE2       80
#define SMTVPRICE3       60
#define SMTVPRICE4       40
#define SMTVPRICE5       20

//ポジション情報
#define POSITION         "5001"
#define SIGNALBUY        "6001"
#define SIGNALSELL       "6002"
#define NOSIGNAL         "6003"
#define SHRINK           "6004"
#define RANGE            "6005"

#define NOPOSITION       0
#define DUMMYPOSITION    999999999
#define STOPLOSS         1000                  //損切り設定
#define SLIPPAGE         100

//メッセージ
#define MSG0001          "7001"
#define MSG0002          "7002"
#define MSG0003          "7003"
#define MSG0004          "7004"
#define MSG0005          "7005"
#define MSG0006          "7006"
#define MSG0008          "7008"
#define MSG0009          "7009"
#define MSG0010          "7010"
#define MSG0109          "7109"
#define MSG0110          "7110"
#define MSG0309          "7309"
#define MSG0310          "7310"
#define MSG0209          "7209"
#define MSG0210          "7210"
#define MSG0011          "7011"
#define MSG0012          "7012"
#define MSG0013          "7013"
#define MSG0112          "7112"
#define MSG0113          "7113"
#define MSG0014          "7014"
#define MSG0015          "7015"
#define MSG0016          "7016"
#define MSG0017          "7017"
#define MSG0018          "7018"
#define MSG0019          "7019"
#define MSG0020          "7020"
#define MSG0021          "7021"
#define MSG0022          "7022"
#define MSG0023          "7023"

//ログファイル名
static string LOGFILENAME="TrailLog_"+Symbol()+".csv";

static double LOTCOUNT=0.12;                 //オーダーロット数
static double CLOSELOT=0.03;                 //決済ロット

                                             //取引情報ファイル
#define TRADEINFOFILE  "TradeInfo_"+Symbol()+".csv"

//+------------------------------------------------------------------+
//| セッション                                                           |
//+------------------------------------------------------------------+
//int SessionTrendTicket   = 0;     //トレンドトレードチケット番号
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
bool SessionIsClosedSB2SigmaLine=false;
string SessionSMBSSignal = NOSIGNAL;
string SessionSMCSSignal = NOSIGNAL;
string SessionSBMASignal = NOSIGNAL;
string SessionSBSLSignal = NOSIGNAL;
string SessionSBCSSignal = NOSIGNAL;
string SessionOpenSignal = NOSIGNAL;

bool SessionIsTradeEnable=true;      //トレード可能フラグ
//+------------------------------------------------------------------+
