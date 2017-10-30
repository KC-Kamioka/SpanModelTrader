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
#include <SMTTradeMain.mqh>
#include <SMTSubFunction.mqh>
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

//既存のオブジェクトを削除
   ObjectsDeleteAll();

//EA初期化
   SMTInitialize(0);

//ファイル削除
   FileDelete(LOGFILENAME);
   //FileDelete(TRADEINFOFILE);
  
//ファイルを開く
   int handle=FileOpen(LOGFILENAME,FILE_CSV|FILE_READ|FILE_WRITE,SMTLOGSEP);
      
//シグナルセット
   for(int i=INITBARCOUNT; i>0; i--)
     {
      SMTTrendFollow(i,true);
      if(SessionIsAllClosed==true) Scalping(SessionOpenSignal,i,true);

      //ログ出力
      if(handle>0)
        {
         FileSeek(handle,0,SEEK_END);
         FileWrite(handle,SessionLogContents);
        }
      if(i==1)Comment(SessionLogContents);
      SessionLogContents=NULL;
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
   if(SessionIsExistPosition==true)
     {
      SMTInitialize(0);
     }
     
     //ファイルを閉じる
      if(handle>0)
        {
         FileClose(handle);
         handle=0;
        }
        
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
   SMTTrendFollow(0);

//ログ出力
   Comment(SessionLogContents);
   OutputLogFile(SessionLogContents);
   SessionLogContents=NULL;

  }
//+------------------------------------------------------------------+
