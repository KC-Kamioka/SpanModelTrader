//+------------------------------------------------------------------+
//|                                                      SMT0001.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
#include <stdlib.mqh>
#include <SMT0000.mqh>
//+------------------------------------------------------------------+
//| コード変換                                                         |
//+------------------------------------------------------------------+
string GetCodeContent(string sCode)
  {

//クラス名
   if(sCode == "SMT0000")     return "SMTConstants";
   if(sCode == "SMT0001")     return "SMTCommon";
   if(sCode == "SMT0002")     return "SpanModelCommon";
   if(sCode == "SMT0003")     return "SuperBolingerCommon";
   if(sCode == "SMT0004")     return "SMTTradeMain";

   if(sCode == SPANMODEL)     return "SpanModel";
   if(sCode == BLUESPAN)      return "BlueSpan";
   if(sCode == DELAYEDSPAN)     return "DelayedSpan";
   if(sCode == SUPERBOLINGER) return "SuperBolinger";
   if(sCode == SIGMALINE)     return "SigmaLine";
   if(sCode == SIMPLEMA)     return "SimpleMA";

   if(sCode == POSITION)      return "Position";
   if(sCode == SIGNALBUY)     return "Buy";
   if(sCode == SIGNALSELL)    return "Sell";
   if(sCode == NOSIGNAL)      return " ";
   if(sCode == SHRINK)        return "Shrink";

   if(sCode == IntegerToString(SMTVPRICE01))   return "SpanModelBlueSpan";
   if(sCode == IntegerToString(SMTVPRICE02))   return "SpanModelDelayedSpan";
   if(sCode == IntegerToString(SMTVPRICE03))   return "SuperBolingerSimpleMA";
   if(sCode == IntegerToString(SMTVPRICE04))   return "SuperBolingerBandExpand";
   if(sCode == IntegerToString(SMTVPRICE05))   return "SuperBolingerSigmaLine";
   if(sCode == IntegerToString(SMTVPRICE06))   return "SuperBolingerDelayedSpan";
   if(sCode == IntegerToString(SMTVPRICE07))   return "PositionOpen";
   if(sCode == IntegerToString(SMTVPRICE08))   return "OpenBlueSpan";
   if(sCode == IntegerToString(SMTVPRICE09))   return "OpenDelayedSpan";
   if(sCode == IntegerToString(SMTVPRICE10))   return "OpenSigmaLine";
   if(sCode == IntegerToString(SMTVPRICE11))   return "Scalping";

   if(sCode == "MSG0001") return "EAを起動しました。";
   if(sCode == "MSG0002") return "EAを終了しました。";
   if(sCode == "MSG0003") return "SpanModelTraderを初期化しました。";
   if(sCode == "MSG0004") return "シグナルが消灯しました。";
   if(sCode == "MSG0005") return "シグナル点灯中です。";
   if(sCode == "MSG0006") return "シグナルが点灯しました。";
   if(sCode == "MSG0008") return "ポジション保持期限を超過しました。";
   if(sCode == "MSG0009") return "遅行スパンが青色スパンを下回りました。";
   if(sCode == "MSG0010") return "遅行スパンが青色スパンを上回りました。";
   if(sCode == "MSG0109") return "終値が青色スパンを下回りました。";
   if(sCode == "MSG0110") return "終値が青色スパンを上回りました。";
   if(sCode == "MSG0209") return "青色スパンが赤色スパンを下回りました。";
   if(sCode == "MSG0210") return "青色スパンが赤色スパンを上回りました。";
   if(sCode == "MSG0309") return "プラス2シグマラインを上回りました。";
   if(sCode == "MSG0310") return "マイナス2シグマラインを下回りました。";
   if(sCode == "MSG0409") return "プラス3シグマラインを上回りました。";
   if(sCode == "MSG0410") return "マイナス3シグマラインを下回りました。";
   if(sCode == "MSG0011") return "ポジションの選択に失敗しました。";
   if(sCode == "MSG0012") return "ポジションを取得しました。";
   if(sCode == "MSG0013") return "ポジションをすべて決済しました。";
   if(sCode == "MSG0112") return "ダミーポジションを取得しました。";
   if(sCode == "MSG0113") return "ダミーポジションを決済しました。";
   if(sCode == "MSG0014") return "損切りしました。";
   if(sCode == "MSG0015") return "ポジションオープンシグナルが点灯しました。";
   if(sCode == "MSG0115") return "ポジションオープンシグナルが消灯しました。";
   if(sCode == "MSG0016") return "トレード形態を変更しました。";
   if(sCode == "MSG0017") return "±3シグマラインが縮小しました。";
   if(sCode == "MSG0018") return "決済シグナルが取得できませんでした。";
   if(sCode == "MSG0019") return "エラーが発生したため、トレードを停止します。";
   if(sCode == "MSG0020") return "トレード終了時刻のため、ポジションを決済しました。";
   if(sCode == "MSG0021") return "バンド幅が拡大しました。";
   if(sCode == "MSG0022") return "ポジションを一部決済しました。";
   if(sCode == "MSG0023") return "下位時間軸で利益確定しました。";
   if(sCode == "MSG0024") return "移動平均線を下回りました。";
   if(sCode == "MSG0025") return "移動平均線を上回りました。";
   if(sCode == "MSG0026") return "シグナル待機中";
   if(sCode == "MSG0027") return "ポジション保持期間中";
   if(sCode == "MSG0028") return "青色スパン確認中";
   if(sCode == "MSG0029") return "遅行スパン確認中";
   if(sCode == "MSG0030") return "±2シグマライン確認中";
   if(sCode == "MSG0031") return "ポジションオープン待機中";
   if(sCode == "MSG0032") return "ポジションクローズ待機中";
   if(sCode == "MSG0033") return "処理開始";
   if(sCode == "MSG0034") return "処理終了";
   if(sCode == "MSG0035") return "スキャルピングポジション保持中です。";
   if(sCode == "MSG0036") return "スキャルピングポジション待機中です。";
   if(sCode == "MSG0037") return "取引開始";
   if(sCode == "MSG0038") return "取引終了";
   if(sCode == "MSG0039") return "プラス3シグマラインは上回っていません。";
   if(sCode == "MSG0040") return "マイナス3シグマラインは下回っていません。";
   if(sCode == "MSG0041") return "±3シグマラインを超えています。";
   if(sCode == "MSG0042") return "スキャルピングフラグをセットしました。";

   return sCode;

  }
//+------------------------------------------------------------------+
//| ファイル出力
//+------------------------------------------------------------------+
void OutputLogFile(string sLog)
  {
//ファイルを開く
   int handle=FileOpen(GetLogFileName(),FILE_CSV|FILE_READ|FILE_WRITE,SMTLOGSEP);
   if(handle>0)
     {
      //ログ出力
      FileSeek(handle,0,SEEK_END);
      FileWrite(handle,sLog);

      //ファイルを閉じる
      FileClose(handle);
      handle=0;
     }
  }
//+------------------------------------------------------------------+
//| ログファイル名取得                                                  |
//+------------------------------------------------------------------+
string GetLogFileName(int iBarNo=0)
  {

//日付をセット
   string sDate=IntegerToString(TimeYear(Time[iBarNo]))+
                StrPadding(IntegerToString(TimeMonth(Time[iBarNo])),"0",2,true)+
                StrPadding(IntegerToString(TimeDay(Time[iBarNo])),"0",2,true);

//ログファイル名をセット
   string sLogFileName="TrailLog_"+Symbol()+"_"+sDate+".csv";

   return sLogFileName;
  }
//+------------------------------------------------------------------+
//| ログ出力
//+------------------------------------------------------------------+
void TrailLog(string sLogLevel,
              string sClassName,
              string sProcessId,
              string sLog1,
              int    iBarNo,
              string sLog2=NULL,)
  {

//ログ内容作成
   string sLogContent=TimeToString(Time[iBarNo])+SMTLOGSEP+
                      sLogLevel+SMTLOGSEP+
                      sClassName+SMTLOGSEP+
                      GetCodeContent(sProcessId)+SMTLOGSEP+
                      GetCodeContent(sLog1)+SMTLOGSEP+
                      sLog2;

   SessionLogContents=SessionLogContents+sLogContent+SMTRTNCODE;
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
//| ID取得                                                           |
//+------------------------------------------------------------------+
string GetSMTID(int iBarNo=0)
  {

   return IntegerToString(TimeYear(Time[iBarNo])) +
   StrPadding(IntegerToString(TimeMonth(Time[iBarNo])),"0",2,true)+
   StrPadding(IntegerToString(TimeDay(Time[iBarNo])),"0",2,true)+
   StrPadding(IntegerToString(TimeHour(Time[iBarNo])),"0",2,true)+
   StrPadding(IntegerToString(TimeMinute(Time[iBarNo])),"0",2,true)+
   StrPadding(IntegerToString(TimeSeconds(Time[iBarNo])),"0",2,true);

  }
//+------------------------------------------------------------------+
//| 初期化処理                                                        |
//+------------------------------------------------------------------+
void SMTInitialize(int iBarNo)
  {

//処理開始ログ出力
   string sProcessName="SMTInitialize";
   TrailLog("INFO",CLASSNAME1,sProcessName,"MSG0033",iBarNo);

   SessionIsExistPosition=false;
   SessionSMBSSignal=NOSIGNAL;
   SessionSMCSSignal=NOSIGNAL;
   SessionSBMASignal=NOSIGNAL;
   SessionSBEXSignal=NOSIGNAL;
   SessionSBSLSignal=NOSIGNAL;
   SessionSBCSSignal=NOSIGNAL;
   SessionOpenSignal=NOSIGNAL;
   SessionIsClosedSMBlueSpan=false;
   SessionIsClosedSMDelayedSpan=false;
   SessionScalpingFlg=false;
   SessionTrendCount=0;

//処理終了ログ出力
   TrailLog("INFO",CLASSNAME1,sProcessName,"MSG0003",iBarNo);
   TrailLog("INFO",CLASSNAME1,sProcessName,"MSG0034",iBarNo);
  }
//+------------------------------------------------------------------+
//| サブウインドウにオープンシグナルを表示
//+------------------------------------------------------------------+
void SetObjSMTSignal(string sSignal,
                     int    iSMTPrice,
                     int    iBarNo)
  {

//シグナルなし
   if(sSignal == NOSIGNAL) return;

   bool bRtn=false;
   int iSubWIdx=1;

//オブジェクト名設定
   string sObjName=GetCodeContent(IntegerToString(iSMTPrice))+"_"+GetSMTID(iBarNo);

   if(sSignal==SHRINK)
     {
      //オブジェクト作成
      bRtn = ObjectCreate(sObjName,OBJ_VLINE,iSubWIdx,Time[iBarNo],0);
      bRtn = ObjectSet(sObjName,OBJPROP_COLOR,LightGreen);
     }
   else
     {
      //オブジェクト作成
      bRtn = ObjectCreate(sObjName,OBJ_ARROW,iSubWIdx,Time[iBarNo],iSMTPrice);
      bRtn = ObjectSet(sObjName,OBJPROP_ARROWCODE,110);

      //オブジェクトの色設定
      if(iSMTPrice<SMTVPRICE06)
        {
         bRtn=ObjectSet(sObjName,OBJPROP_COLOR,Magenta);
        }
      else
        {
         if(sSignal==SIGNALBUY) bRtn=ObjectSet(sObjName,OBJPROP_COLOR,Blue);
         else if(sSignal==SIGNALSELL) bRtn=ObjectSet(sObjName,OBJPROP_COLOR,Red);
        }
     }
//エラーハンドラ
   if(bRtn==false)
     {
      int iLastError=GetLastError();
      string sProcessName="SMTInitialize";
      TrailLog("ERROR",CLASSNAME1,sProcessName,ErrorDescription(iLastError),iBarNo);
     }
  }
//+------------------------------------------------------------------+
//| サブウインドウにシグナル名表示                                        |
//+------------------------------------------------------------------+
void DisplaySignalName(int iBarNo=0)
  {

//処理開始ログ出力
   string sProcessName="DisplaySignalName";
   TrailLog("INFO",CLASSNAME1,sProcessName,"MSG0033",iBarNo);

   bool bRtn=false;
   int iSubWIdx=1;

//オブジェクト名作成
   string sSignal07=IntegerToString(SMTVPRICE07);
/*
   string sSMBSpan = GetCodeContent(SPANMODEL) + "_" + GetCodeContent(BLUESPAN);
   string sSMCSpan = GetCodeContent(SPANMODEL) + "_" + GetCodeContent(DELAYEDSPAN);
   string sSBSMA=GetCodeContent(SUPERBOLINGER)+"_"+GetCodeContent(SIMPLEMA);
   string sSBSLine = GetCodeContent(SUPERBOLINGER) + "_" + GetCodeContent(SIGMALINE);
   string sSBCSpan = GetCodeContent(SUPERBOLINGER) + "_" + GetCodeContent(DELAYEDSPAN);
*/
//オブジェクト削除
   ObjectDelete(sSignal07);
/*
   ObjectDelete(sSMBSpan);
   ObjectDelete(sSMCSpan);
   ObjectDelete(sSBSMA);
   ObjectDelete(sSBSLine);
   ObjectDelete(sSBCSpan);
*/
//オブジェクト作成
   int iTimeShift=0;
   bRtn=ObjectCreate(0,sSignal07,OBJ_TEXT,iSubWIdx,Time[iTimeShift],SMTVPRICE07);
/*
   bRtn = ObjectCreate(0,sSMBSpan,OBJ_TEXT,iSubWIdx,Time[iTimeShift],SMTVPRICE01);
   bRtn = ObjectCreate(0,sSMCSpan,OBJ_TEXT,iSubWIdx,Time[iTimeShift],SMTVPRICE02);
   bRtn = ObjectCreate(0,sSBSMA,OBJ_TEXT,iSubWIdx,Time[iTimeShift],SMTVPRICE03);
   bRtn = ObjectCreate(0,sSBSLine,OBJ_TEXT,iSubWIdx,Time[iTimeShift],SMTVPRICE04);
   bRtn = ObjectCreate(0,sSBCSpan,OBJ_TEXT,iSubWIdx,Time[iTimeShift],SMTVPRICE05);
*/
//表示テキスト
   int iLength = 28;
   int iFSize  = 8;
   ObjectSetText(sSignal07,StrPadding(GetCodeContent("MSG0027")," ",iLength,true),iFSize);
/*
   ObjectSetText(sSMBSpan,StrPadding("SM_BSpan"," ",iLength,true),iFSize);
   ObjectSetText(sSMCSpan,StrPadding("SM_DSpan"," ",iLength,true),iFSize);
   ObjectSetText(sSBSMA,StrPadding("SB_SMA"," ",iLength,true),iFSize);
   ObjectSetText(sSBSLine,StrPadding("SB_SLine"," ",iLength,true),iFSize);
   ObjectSetText(sSBCSpan,StrPadding("SB_DSpan"," ",iLength,true),iFSize);
   */
//エラーハンドラ
   if(bRtn==false)
     {
      int iLastError=GetLastError();
      TrailLog("ERROR",CLASSNAME1,sProcessName,ErrorDescription(iLastError),0);
     }

//処理終了ログ出力
   TrailLog("INFO",CLASSNAME1,sProcessName,"MSG0034",iBarNo);
  }
//+------------------------------------------------------------------+
//| チケットありフラグセット                                                    |
//+------------------------------------------------------------------+
void SetSessionIsExistPosition(bool IsExistPosition,int iBarNo)
  {
   SessionIsExistPosition=IsExistPosition;
  }
//+------------------------------------------------------------------+
//| スパンモデル青色スパン                                               |
//+------------------------------------------------------------------+
void SetSessionSMBSSignal(string sSignal,int iBarNo)
  {

//処理開始ログ出力
   string sProcessName="SetSessionSMBSSignal";
   TrailLog("INFO",CLASSNAME1,sProcessName,"MSG0033",iBarNo);

//シグナル点灯
   if(sSignal!=NOSIGNAL)
     {
      //シグナルカウントアップ
      SessionSMBSpanSigCnt=SessionSMBSpanSigCnt+1;

      //シグナル転換
      if(SessionSMBSSignal!=sSignal) SessionSMBSpanSigCnt=1;

      //シグナルセット
      SessionSMBSSignal=sSignal;

      //シグナルが点灯したとき
      if(SessionSMBSpanSigCnt<2) TrailLog("INFO",CLASSNAME1,sProcessName,"MSG0006",iBarNo);

     }

//シグナル消灯
   else
     {
      if(SessionSMBSpanSigCnt>0)
        {
         SessionSMBSSignal=sSignal;
         SessionSMBSpanSigCnt=SessionSMBSpanSigCnt+1;
         TrailLog("INFO",CLASSNAME1,sProcessName,"MSG0004",iBarNo);
         SessionSMBSpanSigCnt=0;
        }
     }

//処理終了ログ出力
   TrailLog("INFO",CLASSNAME1,sProcessName,"MSG0034",iBarNo);
  }
//+------------------------------------------------------------------+
//| スパンモデル遅行スパン                                               |
//+------------------------------------------------------------------+
void SetSessionSMCSSignal(string sSignal,int iBarNo)
  {

//処理開始ログ出力
   string sProcessName="SetSessionSMCSSignal";
   TrailLog("INFO",CLASSNAME1,sProcessName,"MSG0033",iBarNo);

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
         TrailLog("INFO",CLASSNAME1,sProcessName,"MSG0006",iBarNo);
        }
     }
   else if(SessionSMCSpanSigCnt>0)
     {
      SessionSMCSSignal=sSignal;
      SessionSMCSpanSigCnt=SessionSMCSpanSigCnt+1;
      TrailLog("INFO",CLASSNAME1,sProcessName,"MSG0004",iBarNo);
      SessionSMCSpanSigCnt=0;
     }

//処理終了ログ出力
   TrailLog("INFO",CLASSNAME1,sProcessName,"MSG0034",iBarNo);
  }
//+------------------------------------------------------------------+
//| スーパーボリンジャー移動平均線                                      |
//+------------------------------------------------------------------+
void SetSessionSBMASignal(string sSignal,int iBarNo)
  {

//処理開始ログ出力
   string sProcessName="SetSessionSBMASignal";
   TrailLog("INFO",CLASSNAME1,sProcessName,"MSG0033",iBarNo);

//シグナルセット
   SessionSBMASignal=sSignal;

//処理終了ログ出力
   TrailLog("INFO",CLASSNAME1,sProcessName,"MSG0034",iBarNo);
  }
//+------------------------------------------------------------------+
//| スーパーボリンジャーシグマライン                                      |
//+------------------------------------------------------------------+
void SetSessionSBSLSignal(string sSignal,int iBarNo)
  {

//処理開始ログ出力
   string sProcessName="SetSessionSBSLSignal";
   TrailLog("INFO",CLASSNAME1,sProcessName,"MSG0033",iBarNo);

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
         TrailLog("INFO",CLASSNAME1,sProcessName,"MSG0006",iBarNo);
        }

        }else if(SessionSBSLineSigCnt>0){
      SessionSBSLSignal=sSignal;
      SessionSBSLineSigCnt=SessionSBSLineSigCnt+1;
      TrailLog("INFO",CLASSNAME1,sProcessName,"MSG0004",iBarNo);
      SessionSBSLineSigCnt=0;
     }

//処理終了ログ出力
   TrailLog("INFO",CLASSNAME1,sProcessName,"MSG0034",iBarNo);
  }
//+------------------------------------------------------------------+
//| スーパーボリンジャー遅行スパン                                        |
//+------------------------------------------------------------------+
void SetSessionSBCSSignal(string sSignal,int iBarNo)
  {

//処理開始ログ出力
   string sProcessName="SetSessionSBCSSignal";
   TrailLog("INFO",CLASSNAME1,sProcessName,"MSG0033",iBarNo);

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
         TrailLog("INFO",CLASSNAME1,sProcessName,"MSG0006",iBarNo);
        }

        }else if(SessionSBCSpanSigCnt>0){
      SessionSBCSSignal=sSignal;
      SessionSBCSpanSigCnt=SessionSBCSpanSigCnt+1;
      TrailLog("INFO",CLASSNAME1,sProcessName,"MSG0004",iBarNo);
      SessionSBCSpanSigCnt=0;
     }

//処理終了ログ出力
   TrailLog("INFO",CLASSNAME1,sProcessName,"MSG0034",iBarNo);
  }
//+------------------------------------------------------------------+
//| オープンシグナル                                           |
//+------------------------------------------------------------------+
void SetSessionOpenSignal(string sSignal,int iBarNo)
  {

//処理開始ログ出力
   string sProcessName="SetSessionOpenSignal";
   TrailLog("INFO",CLASSNAME1,sProcessName,"MSG0033",iBarNo);

//シグナルセット
   SessionOpenSignal=sSignal;

//シグナル点灯の場合
   if(sSignal!=NOSIGNAL)
     {

      //ログ出力
      TrailLog("INFO",CLASSNAME1,sProcessName,"MSG0015",iBarNo);
     }

//バンド幅縮小シグナル点灯の場合
   else if(sSignal==SHRINK)
     {

      //ログ出力
      TrailLog("INFO",CLASSNAME1,sProcessName,"MSG0017",iBarNo);
     }
//シグナル消灯の場合
   else
     {

      //ログ出力
      TrailLog("INFO",CLASSNAME1,sProcessName,"MSG0115",iBarNo);
     }

//処理終了ログ出力
   TrailLog("INFO",CLASSNAME1,sProcessName,"MSG0034",iBarNo);
  }
//+------------------------------------------------------------------+
//| 週末ポジションチェック                                                       |
//+------------------------------------------------------------------+
bool IsWeekend(int iBarNo)
  {

//週末ポジション持越しない
   bool bRtn=false;
   if(TimeDayOfWeek(Time[iBarNo])==5 && TimeHour(Time[iBarNo])>22)
     {
      bRtn=true;
     }
   return bRtn;
  }
//+------------------------------------------------------------------+
//| 青色スパン決済フラグ                                                 |
//+------------------------------------------------------------------+
void SetSessionIsClosedSMBlueSpan(bool bClosed,int iBarNo=0)
  {

//処理開始ログ出力
   string sProcessName="SetSessionIsClosedSMBlueSpan";
   TrailLog("INFO",CLASSNAME1,sProcessName,"MSG0033",iBarNo);

   SessionIsClosedSMBlueSpan=bClosed;

   if(SessionOpenSignal==SIGNALBUY)
     {
      TrailLog("INFO",CLASSNAME1,sProcessName,"MSG0109",iBarNo);
     }
   else if(SessionOpenSignal==SIGNALSELL)
     {
      TrailLog("INFO",CLASSNAME1,sProcessName,"MSG0110",iBarNo);
     }

//処理終了ログ出力
   TrailLog("INFO",CLASSNAME1,sProcessName,"MSG0034",iBarNo);
  }
//+------------------------------------------------------------------+
//| 遅行スパン決済フラグ                                                 |
//+------------------------------------------------------------------+
void SetSessionIsClosedSMDelayedSpan(bool bClosed,int iBarNo)
  {

//処理開始ログ出力
   string sProcessName="SetSessionIsClosedSMDelayedSpan";
   TrailLog("INFO",CLASSNAME1,sProcessName,"MSG0033",iBarNo);

   SessionIsClosedSMDelayedSpan=bClosed;

//処理終了ログ出力
   TrailLog("INFO",CLASSNAME1,sProcessName,"MSG0034",iBarNo);
  }
//+------------------------------------------------------------------+
//| スキャルピングフラグ                                                   |
//+------------------------------------------------------------------+
void SetSessionScalpingFlg(bool bClosed,int iBarNo)
  {
   string sProcessName="SetSessionScalpingFlg";
   SessionScalpingFlg=bClosed;
   TrailLog("INFO",CLASSNAME4,sProcessName,"MSG0042",iBarNo,
            "（"+IntegerToString(bClosed)+"）");
  }
//+------------------------------------------------------------------+
//|                                 sProcessName                                 |
//+------------------------------------------------------------------+
/*
//+------------------------------------------------------------------+
//| レンジカウントアップ                                                 |
//+------------------------------------------------------------------+
void SetSessionRangeCnt(int iBarNo)
  {

//処理開始ログ出力
   string sProcessName="SetSessionRangeCnt";
   TrailLog("INFO",CLASSNAME1,sProcessName,"MSG0033",iBarNo);

   SessionRangeCnt=SessionRangeCnt+1;

//処理終了ログ出力
   TrailLog("INFO",CLASSNAME1,sProcessName,"MSG0034",iBarNo);
  }
*/
//+------------------------------------------------------------------+
//| バンド幅拡大シグナル                                                 |
//+------------------------------------------------------------------+
void SetSessionSBEXSignal(string sSignal,int iBarNo)
  {
   string sProcessName="SetSessionSBEXSignal";
   SessionSBEXSignal=sSignal;
   TrailLog("INFO",CLASSNAME1,sProcessName,"MSG0021",iBarNo);
  }
//+------------------------------------------------------------------+
