//+------------------------------------------------------------------+
//|                                              SMTSubFunction.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

//+------------------------------------------------------------------+
//| ライブラリ                                                             |
//+------------------------------------------------------------------+
#include <SMTCommon.mqh>

//MQL4コピーバッチ
#define MQLCOPYBATCH    "CopyMQL.bat"

//ソースバックアップパス
#define SOURCEBKPATH    "C:\\Users\\KC\\Dropbox\\Development\\MQL4_DEV\\MQL4"

//ログ出力設定ファイル
#define SETTINGINI      "Setting.ini"

//ログテーブル作成バッチ
#define CREATELOGBATCH  "CreateLogTable.bat"

//ログリスト出力先
#define LOGOUTPUTPATH   "E:\\Dropbox\\Development\\MQL4_DEV\\TrailLog"

//+------------------------------------------------------------------+
//| 外部関数                                                             |
//+------------------------------------------------------------------+
#import "shell32.dll"
int ShellExecuteW(int hWnd,int lpVerb,string lpFile,string lpParameters,int lpDirectory,int nCmdShow);
#import

//+------------------------------------------------------------------+
//| ソースバックアップ                                                        |
//+------------------------------------------------------------------+
void ExecuteCopyBatch(string sFrom,string sTo){

    ShellExecuteW(0,0,TerminalInfoString(TERMINAL_DATA_PATH) + "\\MQL4\\bat\\" + MQLCOPYBATCH,
                  sFrom + " " + sTo,NULL,5);
   
}
//+---------------------------------------------------------------------+