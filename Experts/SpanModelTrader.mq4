//+------------------------------------------------------------------+
//|                                              SpanModelTrader.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| ライブラリ                                                          |
//+------------------------------------------------------------------+
#include <SMT0004.mqh>
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

//コメント初期化
   Comment("");

//既存のオブジェクトを削除
   ObjectsDeleteAll();

//ログファイル名取得
string sLogFileName=GetLogFileName();

//ファイル削除
   FileDelete(sLogFileName);

//ファイルを開く
   int handle=FileOpen(sLogFileName,FILE_CSV|FILE_READ|FILE_WRITE,SMTLOGSEP);

//シグナルセット
   for(int i=INITBARCOUNT; i>0; i--)
     {
      SessionLogContents=NULL;
      SessionLogContents=SessionLogContents+StrPadding(NULL,"-",140)+SMTRTNCODE;
      SMTTrendFollow(i,true);
      if(SessionIsAllClosed==true) Scalping(SessionOpenSignal,i,true);
      SessionLogContents=SessionLogContents+StrPadding(NULL,"-",140)+SMTRTNCODE;
      
      //ログ出力
      if(handle>0)
        {
         FileSeek(handle,0,SEEK_END);
         FileWrite(handle,SessionLogContents);
        }
     }

//ポジションクローズ
   for(int i=0; i<OrdersTotal(); i++)
     {
      bool bSelected=OrderSelect(i,SELECT_BY_POS);
      if(OrderSymbol()==Symbol())
        {
         bool Closed=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),10,Magenta);
        }
     }

//ポジション保持中の場合は初期化する
   if(SessionIsExistPosition==true) SMTInitialize(0);

//ファイルを閉じる
   if(handle>0)
     {
      FileClose(handle);
      handle=0;
     }

//コメント表示
   SessionLogContents=SessionLogContents+StrPadding(NULL,"-",140)+SMTRTNCODE;
   TrailLog("INFO",NULL,NULL,"MSG0037",0);
   SessionLogContents=SessionLogContents+StrPadding(NULL,"-",140);
//   Comment(SessionLogContents);
   OutputLogFile(SessionLogContents);
   SessionLogContents=NULL;
   return(INIT_SUCCEEDED);
//---
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

//EA初期化
   SMTInitialize(0);
   
//ログ出力
   SessionLogContents=SessionLogContents+StrPadding(NULL,"-",140)+SMTRTNCODE;
   TrailLog("INFO",NULL,NULL,"MSG0038",0);
   SessionLogContents=SessionLogContents+StrPadding(NULL,"-",140);
   //Comment(SessionLogContents);
   OutputLogFile(SessionLogContents);
   SessionLogContents=NULL;

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {

//スキャルピング
   if(SessionIsAllClosed==true) Scalping(SessionOpenSignal,0);

//始値でのみ処理開始
   static datetime dTmpTime=Time[0];
   if(Time[0] == dTmpTime) return;
   dTmpTime=Time[0];

//トレンドフォロー
   SessionLogContents=SessionLogContents+StrPadding(NULL,"-",140)+SMTRTNCODE;
   SMTTrendFollow(0);
   SessionLogContents=SessionLogContents+StrPadding(NULL,"-",140)+SMTRTNCODE;;

//ログ出力
   Comment(SessionLogContents);
   OutputLogFile(SessionLogContents);
   SessionLogContents=NULL;

  }
//+------------------------------------------------------------------+
