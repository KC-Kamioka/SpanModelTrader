//+------------------------------------------------------------------+
//|                                              SMTSubFunction.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
#include <SMTCommon.mqh>

//コピーバッチ
#define MQLCOPYBATCH    "CopyMQL.bat"

//取引情報ファイル
#define TRADEINFOFILE  "TradeInfo.csv"

//+------------------------------------------------------------------+
//| 外部関数                                                             |
//+------------------------------------------------------------------+
#import "shell32.dll"
int ShellExecuteW(int hWnd,int lpVerb,string lpFile,string lpParameters,int lpDirectory,int nCmdShow);
#import
//+------------------------------------------------------------------+
//| ソースバックアップ                                                        |
//+------------------------------------------------------------------+
void ExecuteCopyBatch(string sFrom,string sTo)
  {

   ShellExecuteW(0,0,TerminalInfoString(TERMINAL_DATA_PATH)+"\\MQL4\\bat\\"+MQLCOPYBATCH,
                 sFrom+" "+sTo,NULL,5);

  }
//+------------------------------------------------------------------+
//| 取引情報ファイル作成                                                        |
//+------------------------------------------------------------------+
void WriteTradeInfoFile(int iBarNo=0)
  {

//ファイルを開く
   int handle=FileOpen(TRADEINFOFILE,FILE_CSV|FILE_READ|FILE_WRITE,",");
   if(handle>0)
     {

      //スパンモデルの値
      double dBlueSpan=iCustom(NULL,LOWERPERIOD,"SpanModel",5,iBarNo+1);
      double dRedSpan=iCustom(NULL,LOWERPERIOD,"SpanModel",6,iBarNo+1);

      //スーパーボリンジャーの値
      double dPlus1Sigma=iCustom(NULL,PERIOD_CURRENT,
                                 SUPERBOLINGER_MTF,SB_PLUS1SIGMA,
                                 iBarNo+1);
      double dPlus2Sigma=iCustom(NULL,PERIOD_CURRENT,
                                 SUPERBOLINGER_MTF,SB_PLUS2SIGMA,
                                 iBarNo+1);
      double dPlus3Sigma=iCustom(NULL,PERIOD_CURRENT,
                                 SUPERBOLINGER_MTF,SB_PLUS3SIGMA,
                                 iBarNo+1);
      double dMnus1Sigma=iCustom(NULL,PERIOD_CURRENT,
                                 SUPERBOLINGER_MTF,SB_MNUS1SIGMA,
                                 iBarNo+1);
      double dMnus2Sigma=iCustom(NULL,PERIOD_CURRENT,
                                 SUPERBOLINGER_MTF,SB_MNUS2SIGMA,
                                 iBarNo+1);
      double dMnus3Sigma=iCustom(NULL,PERIOD_CURRENT,
                                 SUPERBOLINGER_MTF,SB_MNUS3SIGMA,
                                 iBarNo+1);
      double dSBCSpan=iCustom(NULL,PERIOD_CURRENT,
                              SUPERBOLINGER_MTF,SB_DELAYEDSPAN,
                              iBarNo+1);

      //ログ出力
      FileSeek(handle,0,SEEK_END);
      FileWrite(handle,
                TimeToString(Time[iBarNo+1]),//日時
                Symbol(),//取引通貨
                DoubleToString(Open[iBarNo+1]),   //始値
                DoubleToString(Close[iBarNo+1]),  //終値
                DoubleToString(High[iBarNo+1]),   //高値
                DoubleToString(Low[iBarNo+1]),    //安値
                DoubleToString(dBlueSpan),        //スパンモデル青色スパン
                DoubleToString(dRedSpan),         //スパンモデル赤色スパン
                DoubleToString(Close[iBarNo+1]),  //スパンモデル遅行スパン
                DoubleToString(dPlus1Sigma),      //スーパーボリンジャー+1
                DoubleToString(dPlus2Sigma),      //スーパーボリンジャー+2
                DoubleToString(dPlus3Sigma),      //スーパーボリンジャー+3
                DoubleToString(dMnus1Sigma),      //スーパーボリンジャー-1
                DoubleToString(dMnus2Sigma),      //スーパーボリンジャー-2
                DoubleToString(dMnus3Sigma),      //スーパーボリンジャー-3
                DoubleToString(dSBCSpan));        //スーパーボリンジャー遅行スパン


      //ファイルを閉じる
      FileClose(handle);
      handle=0;

     }
  }

//+---------------------------------------------------------------------+
