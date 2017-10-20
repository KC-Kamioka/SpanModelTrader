//+------------------------------------------------------------------+
//|                                              SMTCommon.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
#include <stdlib.mqh>
#include <SMTConstants.mqh>
//+------------------------------------------------------------------+
//| コード変換                                                         |
//+------------------------------------------------------------------+
string GetCodeContent(string sCode)
  {

   if(INFO == sCode)  return "INFO";
   if(ERROR == sCode) return "ERROR";
   if(DEBUG == sCode) return "DEBUG";

   if(SPANMODEL == sCode)     return "SpanModel";
   if(BLUESPAN == sCode)      return "BlueSpan";
   if(DELAYEDSPAN == sCode)     return "DelayedSpan";
   if(SUPERBOLINGER == sCode) return "SuperBolinger";
   if(SIGMALINE == sCode)     return "SigmaLine";
   if(SIMPLEMA == sCode)     return "SimpleMA";

   if(POSITION == sCode)      return "Position";
   if(SIGNALBUY  == sCode)    return "Buy";
   if(SIGNALSELL == sCode)    return "Sell";
   if(NOSIGNAL == sCode)      return " ";
   if(SHRINK == sCode)        return "Shrink";

   if(MSG0001 == sCode) return "EAを起動しました。";
   if(MSG0002 == sCode) return "EAを終了しました。";
   if(MSG0003 == sCode) return "EAを初期化しました。";
   if(MSG0004 == sCode) return "シグナルが消灯しました。";
   if(MSG0005 == sCode) return "シグナル点灯中です。";
   if(MSG0006 == sCode) return "シグナルが点灯しました。";
   if(MSG0008 == sCode) return "ポジション保持期限を超過しました。";
   if(MSG0009 == sCode) return "遅行スパンが青色スパンを下回りました。";
   if(MSG0010 == sCode) return "遅行スパンが青色スパンを上回りました。";
   if(MSG0109 == sCode) return "終値が青色スパンを下回りました。";
   if(MSG0110 == sCode) return "終値が青色スパンを上回りました。";
   if(MSG0209 == sCode) return "青色スパンが赤色スパンを下回りました。";
   if(MSG0210 == sCode) return "青色スパンが赤色スパンを上回りました。";
   if(MSG0309 == sCode) return "プラス2シグマラインを上回りました。";
   if(MSG0310 == sCode) return "マイナス2シグマラインを下回りました。";
   if(MSG0011 == sCode) return "ポジションの選択に失敗しました。";
   if(MSG0012 == sCode) return "ポジションを取得しました。";
   if(MSG0013 == sCode) return "ポジションをすべて決済しました。";
   if(MSG0112 == sCode) return "ダミーポジションを取得しました。";
   if(MSG0113 == sCode) return "ダミーポジションを決済しました。";
   if(MSG0014 == sCode) return "損切りしました。";
   if(MSG0015 == sCode) return "ポジションオープンシグナルが点灯しました。";
   if(MSG0016 == sCode) return "トレード形態を変更しました。";
   if(MSG0017 == sCode) return "±3シグマラインが縮小しました。";
   if(MSG0018 == sCode) return "決済シグナルが取得できませんでした。";
   if(MSG0019 == sCode) return "エラーが発生したため、トレードを停止します。";
   if(MSG0020 == sCode) return "トレード終了時刻のため、ポジションを決済しました。";
   if(MSG0021 == sCode) return "バンド幅が拡大しました。";
   if(MSG0022 == sCode) return "ポジションを一部決済しました。";
   if(MSG0023 == sCode) return "下位時間軸で利益確定しました。";

   return sCode;

  }
//+------------------------------------------------------------------+
//| ログ出力
//+------------------------------------------------------------------+
void TrailLog(string sLogFileName,
              string sLogLevel,
              string sIndicatorName,
              string sSignalName,
              string sTradeKbn,
              int    iSignalCount,
              string sLog,
              int    iBarNo)
  {

//ログID
   string sLogId=GetSMTID()+StrPadding(IntegerToString(iBarNo),"0",4,true);

//デバッグファイル出力
   if(DEBUGFLG!=0)
     {

      //ファイルを開く
      int handle=FileOpen(sLogFileName,FILE_CSV|FILE_READ|FILE_WRITE,",");
      if(handle>0)
        {

         //ログ出力
         FileSeek(handle,0,SEEK_END);
         FileWrite(handle,
                   //                   sLogId,
                   TimeToString(Time[iBarNo]),
                   GetCodeContent(sLogLevel),
                   Symbol(),
                   GetCodeContent(sIndicatorName),
                   GetCodeContent(sSignalName),
                   GetCodeContent(sTradeKbn),
                   IntegerToString(iSignalCount),
                   GetCodeContent(sLog));

         //ファイルを閉じる
         FileClose(handle);
         handle=0;

        }
     }
  }
//+------------------------------------------------------------------+
//| 文字埋め                                                          |
//+------------------------------------------------------------------+
string StrPadding(string sTarget,
                  string sStrPad,
                  int    iStrLength,
                  bool   IsLPad=false)
  {

   string sPads = NULL;
   string sRtn  = NULL;

//対象の文字列の長さ
   int iTargetLen=StringLen(sTarget);

//0の数
   int iZeroCnt=iStrLength-iTargetLen;

//返却文字列
   for(int i=0; i<iZeroCnt; i++)
     {
      sPads=sPads+sStrPad;
     }

   if(IsLPad==true) sRtn=sPads+sTarget;
   else               sRtn=sTarget+sPads;
   return sRtn;

  }
//+------------------------------------------------------------------+
//| ID作成                                                           |
//+------------------------------------------------------------------+
string GetSMTID(int iBarNo=0)
  {

   return IntegerToString(TimeYear(Time[iBarNo])) +
   StrPadding(IntegerToString(TimeMonth(Time[iBarNo])),"0",2)+
   StrPadding(IntegerToString(TimeDay(Time[iBarNo])),"0",2)+
   StrPadding(IntegerToString(TimeHour(Time[iBarNo])),"0",2)+
   StrPadding(IntegerToString(TimeMinute(Time[iBarNo])),"0",2)+
   StrPadding(IntegerToString(TimeSeconds(Time[iBarNo])),"0",2);

  }
//+------------------------------------------------------------------+
//| 初期化処理                                                        |
//+------------------------------------------------------------------+
void SMTInitialize(int iBarNo=0)
  {

   SetSessionTrendTicket(NOPOSITION);
   SetSessionSMBSSignal(NOSIGNAL);
   SetSessionSMCSSignal(NOSIGNAL);
   SetSessionSBMASignal(NOSIGNAL);
   SetSessionSBSLSignal(NOSIGNAL);
   SetSessionSBCSSignal(NOSIGNAL);
   SetSessionOpenSignal(NOSIGNAL);
   SetSessionIsClosedSMBlueSpan(false);
   SetSessionIsClosedSMDelayedSpan(false);
   SetSessionIsClosedSBSigmaLine(false);
   SetSessionIsClosedSB2SigmaLine(false);
   SessionIsTradeEnable=true;
   SessionRangeCnt=0;

//ログ出力
   TrailLog(LOGFILENAME,INFO,NULL,NULL,NULL,NULL,MSG0003,iBarNo);

  }
//+------------------------------------------------------------------+
//| サブウインドウにオープンシグナルを表示
//+------------------------------------------------------------------+
void SetObjSMTSignal(string sSignal,
                     int    SMBSPrice,
                     int    iBarNo=0)
  {

//シグナルなし
   if(sSignal == NOSIGNAL) return;

   bool bRtn=false;
   int iSubWIdx=1;

//オブジェクト名設定
   //string sObjName=sIndicatorName+sSignalName+sSignal+GetSMTID(iBarNo);
   string sObjName=GetSMTID(iBarNo)+IntegerToString(SMBSPrice);

   if(sSignal==SHRINK)
     {

      //オブジェクト作成
      bRtn = ObjectCreate(sObjName,OBJ_VLINE,iSubWIdx,Time[iBarNo],0);
      bRtn = ObjectSet(sObjName,OBJPROP_COLOR,LightGreen);

     }

   else
     {

      //オブジェクト作成
      bRtn = ObjectCreate(sObjName,OBJ_ARROW,iSubWIdx,Time[iBarNo],SMBSPrice);
      bRtn = ObjectSet(sObjName,OBJPROP_ARROWCODE,110);

      //オブジェクトの色設定
      if(SessionTrendTicket!=NOPOSITION) bRtn=ObjectSet(sObjName,OBJPROP_COLOR,Magenta);
      else if(sSignal == SIGNALBUY)  bRtn = ObjectSet(sObjName,OBJPROP_COLOR,Blue);
      else if(sSignal == SIGNALSELL) bRtn = ObjectSet(sObjName,OBJPROP_COLOR,Red);
     }

//エラーハンドラ
   if(bRtn==false)
     {
      int iLastError=GetLastError();
      TrailLog(LOGFILENAME,ERROR,NULL,
               NULL,NULL,NULL,ErrorDescription(iLastError),iBarNo);
     }
  }
//+------------------------------------------------------------------+
//| サブウインドウにシグナル名表示                                        |
//+------------------------------------------------------------------+
void DisplaySignalName()
  {

   bool bRtn=false;
   int iSubWIdx=1;

//オブジェクト名作成
   string sSMBSpan = GetCodeContent(SPANMODEL) + "_" + GetCodeContent(BLUESPAN);
   string sSMCSpan = GetCodeContent(SPANMODEL) + "_" + GetCodeContent(DELAYEDSPAN);
   string sSBSMA=GetCodeContent(SUPERBOLINGER)+"_"+GetCodeContent(SIMPLEMA);
   string sSBSLine = GetCodeContent(SUPERBOLINGER) + "_" + GetCodeContent(SIGMALINE);
   string sSBCSpan = GetCodeContent(SUPERBOLINGER) + "_" + GetCodeContent(DELAYEDSPAN);

//オブジェクト削除
   ObjectDelete(sSMBSpan);
   ObjectDelete(sSMCSpan);
   ObjectDelete(sSBSMA);
   ObjectDelete(sSBSLine);
   ObjectDelete(sSBCSpan);

//オブジェクト作成
   int iTimeShift=0;
   bRtn = ObjectCreate(0,sSMBSpan,OBJ_TEXT,iSubWIdx,Time[iTimeShift],SMTVPRICE1);
   bRtn = ObjectCreate(0,sSMCSpan,OBJ_TEXT,iSubWIdx,Time[iTimeShift],SMTVPRICE2);
   bRtn = ObjectCreate(0,sSBSMA,OBJ_TEXT,iSubWIdx,Time[iTimeShift],SMTVPRICE3);
   bRtn = ObjectCreate(0,sSBSLine,OBJ_TEXT,iSubWIdx,Time[iTimeShift],SMTVPRICE4);
   bRtn = ObjectCreate(0,sSBCSpan,OBJ_TEXT,iSubWIdx,Time[iTimeShift],SMTVPRICE5);

//表示テキスト
   int iLength = 28;
   int iFSize  = 8;
   ObjectSetText(sSMBSpan,StrPadding("SM_BSpan"," ",iLength,true),iFSize);
   ObjectSetText(sSMCSpan,StrPadding("SM_DSpan"," ",iLength,true),iFSize);
   ObjectSetText(sSBSMA,StrPadding("SB_SMA"," ",iLength,true),iFSize);
   ObjectSetText(sSBSLine,StrPadding("SB_SLine"," ",iLength,true),iFSize);
   ObjectSetText(sSBCSpan,StrPadding("SB_DSpan"," ",iLength,true),iFSize);

//エラーハンドラ
   if(bRtn==false)
     {
      int iLastError=GetLastError();
      TrailLog(LOGFILENAME,ERROR,SPANMODEL,
               NULL,NULL,NULL,ErrorDescription(iLastError),0);
     }
  }
//+------------------------------------------------------------------+
//| チケット番号セット                                                    |
//+------------------------------------------------------------------+
void SetSessionTrendTicket(int iTicketNo,int iBarNo=0)
  {

//ダミーポジション決済
   if(SessionTrendTicket==DUMMYPOSITION)
     {
      SessionTrendTicket=NOPOSITION;
      TrailLog(LOGFILENAME,INFO,POSITION,
               NULL,NULL,NULL,MSG0113,iBarNo);
      return;
     }

   SessionTrendTicket=iTicketNo;

//ダミーポジション取得
   if(iTicketNo==DUMMYPOSITION)
     {
      TrailLog(LOGFILENAME,INFO,POSITION,
               NULL,NULL,NULL,MSG0112,iBarNo);
     }

//ポジション決済
   else if(iTicketNo!=NOPOSITION)
     {
      TrailLog(LOGFILENAME,INFO,POSITION,
               NULL,NULL,NULL,MSG0012,iBarNo);
     }

//ポジション取得
   else
     {
      TrailLog(LOGFILENAME,INFO,POSITION,
               NULL,NULL,NULL,MSG0013,iBarNo);
     }

   return;

  }
//+------------------------------------------------------------------+
//| スパンモデル青色スパン                                               |
//+------------------------------------------------------------------+
void SetSessionSMBSSignal(string sSignal,int iBarNo=0)
  {

//シグナル点灯
   if(sSignal!=NOSIGNAL)
     {

      //シグナルカウントアップ
      SessionSMBSpanSigCnt=SessionSMBSpanSigCnt+1;

      //シグナル転換
      if(SessionSMBSSignal!=sSignal) SessionSMBSpanSigCnt=1;

      //シグナルセット
      SessionSMBSSignal=sSignal;

      //ログ出力
      if(SessionSMBSpanSigCnt<2)
        {
         TrailLog(LOGFILENAME,INFO,SPANMODEL,BLUESPAN,
                  sSignal,SessionSMBSpanSigCnt,MSG0006,iBarNo);
        }

        }else if(SessionSMBSpanSigCnt>0){
      SessionSMBSSignal=sSignal;
      SessionSMBSpanSigCnt=SessionSMBSpanSigCnt+1;
      TrailLog(LOGFILENAME,INFO,SPANMODEL,BLUESPAN,
               sSignal,SessionSMBSpanSigCnt,MSG0004,iBarNo);
      SessionSMBSpanSigCnt=0;
     }
  }
//+------------------------------------------------------------------+
//| スパンモデル遅行スパン                                               |
//+------------------------------------------------------------------+
void SetSessionSMCSSignal(string sSignal,int iBarNo=0)
  {

//シグナル点灯
   if(sSignal!=NOSIGNAL)
     {

      //シグナルカウントアップ
      SessionSMCSpanSigCnt=SessionSMCSpanSigCnt+1;

      //シグナル転換
      if(SessionSMCSSignal!=sSignal) SessionSMCSpanSigCnt=1;

      //シグナルセット
      SessionSMCSSignal=sSignal;

      //ログ出力
      if(SessionSMCSpanSigCnt<2)
        {
         TrailLog(LOGFILENAME,INFO,SPANMODEL,DELAYEDSPAN,
                  sSignal,SessionSMCSpanSigCnt,MSG0006,iBarNo);
        }

        }else if(SessionSMCSpanSigCnt>0){
      SessionSMCSSignal=sSignal;
      SessionSMCSpanSigCnt=SessionSMCSpanSigCnt+1;
      TrailLog(LOGFILENAME,INFO,SPANMODEL,DELAYEDSPAN,
               sSignal,SessionSMCSpanSigCnt,MSG0004,iBarNo);
      SessionSMCSpanSigCnt=0;
     }

  }
//+------------------------------------------------------------------+
//| スーパーボリンジャー移動平均線                                      |
//+------------------------------------------------------------------+
void SetSessionSBMASignal(string sSignal,int iBarNo=0)
  {

//シグナルセット
   SessionSBMASignal=sSignal;

   if(sSignal==NOSIGNAL)
     {
      //シグナル初期化
      SessionSBSimpleMASigCnt=0;
     }
   else
     {
      //シグナルカウントアップ
      SessionSBSimpleMASigCnt=SessionSBSimpleMASigCnt+1;
     }
  }
//+------------------------------------------------------------------+
//| スーパーボリンジャーシグマライン                                      |
//+------------------------------------------------------------------+
void SetSessionSBSLSignal(string sSignal,int iBarNo=0)
  {

//シグナル点灯
   if(sSignal!=NOSIGNAL)
     {

      //シグナルカウントアップ
      SessionSBSLineSigCnt=SessionSBSLineSigCnt+1;

      //シグナル転換
      if(SessionSBSLSignal!=sSignal) SessionSBSLineSigCnt=1;

      //シグナルセット
      SessionSBSLSignal=sSignal;

      //ログ出力
      if(SessionSBSLineSigCnt<2)
        {
         TrailLog(LOGFILENAME,INFO,SUPERBOLINGER,SIGMALINE,
                  sSignal,SessionSBSLineSigCnt,MSG0006,iBarNo);
        }

        }else if(SessionSBSLineSigCnt>0){
      SessionSBSLSignal=sSignal;
      SessionSBSLineSigCnt=SessionSBSLineSigCnt+1;
      TrailLog(LOGFILENAME,INFO,SUPERBOLINGER,SIGMALINE,
               sSignal,SessionSBSLineSigCnt,MSG0004,iBarNo);
      SessionSBSLineSigCnt=0;
     }
  }
//+------------------------------------------------------------------+
//| スーパーボリンジャー遅行スパン                                        |
//+------------------------------------------------------------------+
void SetSessionSBCSSignal(string sSignal,int iBarNo=0)
  {

//シグナル点灯
   if(sSignal!=NOSIGNAL)
     {

      //シグナルカウントアップ
      SessionSBCSpanSigCnt=SessionSBCSpanSigCnt+1;

      //シグナル転換
      if(SessionSBCSSignal!=sSignal) SessionSBCSpanSigCnt=1;

      //シグナルセット
      SessionSBCSSignal=sSignal;

      //ログ出力
      if(SessionSBCSpanSigCnt<2)
        {
         TrailLog(LOGFILENAME,INFO,SUPERBOLINGER,DELAYEDSPAN,
                  sSignal,SessionSBCSpanSigCnt,MSG0006,iBarNo);
        }

        }else if(SessionSBCSpanSigCnt>0){
      SessionSBCSSignal=sSignal;
      SessionSBCSpanSigCnt=SessionSBCSpanSigCnt+1;
      TrailLog(LOGFILENAME,INFO,SUPERBOLINGER,DELAYEDSPAN,
               sSignal,SessionSBCSpanSigCnt,MSG0004,iBarNo);
      SessionSBCSpanSigCnt=0;
     }

  }
//+------------------------------------------------------------------+
//| オープンシグナル                                           |
//+------------------------------------------------------------------+
void SetSessionOpenSignal(string sSignal,int iBarNo=0)
  {

//シグナルセット
   SessionOpenSignal=sSignal;

//シグナル点灯の場合
   if(sSignal!=NOSIGNAL)
     {

      //ログ出力
      TrailLog(LOGFILENAME,INFO,POSITION,NULL,
               SessionOpenSignal,NULL,MSG0006,iBarNo);

      //バンド幅縮小シグナル点灯の場合
        }else if(sSignal==SHRINK){

      //ログ出力
      TrailLog(LOGFILENAME,INFO,POSITION,NULL,
               SessionOpenSignal,NULL,MSG0017,iBarNo);

      //シグナル消灯の場合
        }else{

      //ログ出力
      TrailLog(LOGFILENAME,INFO,POSITION,NULL,
               SessionOpenSignal,NULL,MSG0004,iBarNo);
     }

  }
//+------------------------------------------------------------------+
//| トレード停止                                                       |
//+------------------------------------------------------------------+
void SetSessionIsTradeEnable()
  {

//停止フラグセット
   SessionIsTradeEnable=false;

  }
//+------------------------------------------------------------------+
//| 週末ポジションチェック                                                       |
//+------------------------------------------------------------------+
bool IsWeekend(int iBarNo=0)
  {

//週末ポジション持越しない
   bool bRtn=false;
   if(TimeDayOfWeek(Time[iBarNo])==5 && TimeHour(Time[iBarNo])>22)
     {
      TrailLog(LOGFILENAME,INFO,POSITION,NULL,NULL,NULL,MSG0020,0);
      bRtn=true;
     }
   return bRtn;
  }
//+------------------------------------------------------------------+
//| 青色スパン決済フラグ                                                 |
//+------------------------------------------------------------------+
void SetSessionIsClosedSMBlueSpan(bool bClosed,int iBarNo=0)
  {
   SessionIsClosedSMBlueSpan=bClosed;
  }
//+------------------------------------------------------------------+
//| 遅行スパン決済フラグ                                                 |
//+------------------------------------------------------------------+
void SetSessionIsClosedSMDelayedSpan(bool bClosed,int iBarNo=0)
  {
   SessionIsClosedSMDelayedSpan=bClosed;
  }
//+------------------------------------------------------------------+
//| 青色スパン決済フラグ                                                 |
//+------------------------------------------------------------------+
void SetSessionIsClosedSBSigmaLine(bool bClosed,int iBarNo=0)
  {
   SessionIsClosedSBSigmaLine=bClosed;
  }
//+------------------------------------------------------------------+
//| 青色スパン決済フラグ                                                 |
//+------------------------------------------------------------------+
void SetSessionIsClosedSB2SigmaLine(bool bClosed,int iBarNo=0)
  {
   SessionIsClosedSB2SigmaLine=bClosed;
  }
//+------------------------------------------------------------------+
//| レンジカウントアップ                                                 |
//+------------------------------------------------------------------+
void SetSessionRangeCnt(int iBarNo=0)
  {
   SessionRangeCnt=SessionRangeCnt+1;
  }
//+------------------------------------------------------------------+
