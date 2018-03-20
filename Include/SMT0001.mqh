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
#import "SMT0001.ex4"
bool PositionOpenBuy(int iStopLoss,int iBarNo=0);
bool PositionOpenSell(int iStopLoss,int iBarNo=0);
void PositionClose(double CloseLot);
void BreakEven();
bool IsExistPosition(int iBarNo=0);
#import
//+------------------------------------------------------------------+
//| 定数                                                             |
//+------------------------------------------------------------------+
#define SB_INDICATORNAME "SuperBolingerMTF"
#define SB_DELAYEDSPAN  0
#define SB_PLUS1SIGMA 1
#define SB_MNUS1SIGMA 2
#define SB_SIMPLEMA   3
#define SB_PLUS2SIGMA 4
#define SB_MNUS2SIGMA 5
#define SB_PLUS3SIGMA 6
#define SB_MNUS3SIGMA 7
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
   if(sCode == CHKSTART)        return "DelayedSpanCross";

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
   if(sCode == "MSG0043") return "+3シグマラインが逆行しました。";
   if(sCode == "MSG0044") return "-3シグマラインが逆行しました。";
   if(sCode == "MSG0045") return "シグナルは消灯しています。";
   if(sCode == "MSG0046") return "買いシグナルが点灯中です。";
   if(sCode == "MSG0047") return "売りシグナルが点灯中です。";

   return sCode;

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
   SessionIsExistPosition=false;
   SessionSMBSSignal=NOSIGNAL;
   SessionSMCSSignal=NOSIGNAL;
   SessionSMSLSignal=NOSIGNAL;
   SessionSBMASignal=NOSIGNAL;
   SessionSBEXSignal=NOSIGNAL;
   SessionSBSLSignal=NOSIGNAL;
   SessionSBCHLSignal=NOSIGNAL;
   SessionSBCSLSignal=NOSIGNAL;
   SessionOpenSignal=NOSIGNAL;
   SessionIsClosedSMBlueSpan=false;
   SessionIsClosedSMDelayedSpan=false;
   SessionIsClosedSBSLTakeProfit=false;
   SessionIsClosedSB1SigmaLine=false;
   SessionIsClosedSB3SLAgainst=false;
   SessionScalpingFlg=false;
   SessionIsExistScalpPos=false;
   SessionRangeTradeFlg=false;
   SessionTrendSignal=NOSIGNAL;
   SessionTrendKeep=false;

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

   if(sSignal==CHKSTART)
     {
      //オブジェクト作成
      bRtn = ObjectCreate(sObjName,OBJ_VLINE,iSubWIdx,Time[iBarNo],0);
      bRtn = ObjectSet(sObjName,OBJPROP_COLOR,LightGreen);
     }
   else
     {
      long lColor=0;

      //オブジェクト作成
      ObjectCreate(0,sObjName,OBJ_RECTANGLE,iSubWIdx,Time[iBarNo],iSMTPrice,Time[iBarNo+1],iSMTPrice);
      ObjectSetInteger(0,sObjName,OBJPROP_WIDTH,4);
      ObjectSetInteger(0,sObjName,OBJPROP_BACK,false);

      //オブジェクトの色設定
      if(iSMTPrice<100)
        {
         if(sSignal==SIGNALBUY) lColor=clrAqua;
         if(sSignal==SIGNALSELL) lColor=clrMagenta;
        }
      else
        {
         if(sSignal==SIGNALBUY) lColor=clrBlue;
         if(sSignal==SIGNALSELL) lColor=clrRed;
        }
      bRtn=ObjectSet(sObjName,OBJPROP_COLOR,lColor);
     }
//エラーハンドラ
   if(bRtn==false)
     {
      int iLastError=GetLastError();
      string sProcessName="SMTInitialize";
     }
  }
//+------------------------------------------------------------------+
//| スパンモデル青色スパン                                               |
//+------------------------------------------------------------------+
void SetSessionSMBSSignal(string sSignal,int iBarNo)
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

     }

//シグナル消灯
   else
     {
      if(SessionSMBSpanSigCnt>0)
        {
         SessionSMBSSignal=sSignal;
         SessionSMBSpanSigCnt=SessionSMBSpanSigCnt+1;
         SessionSMBSpanSigCnt=0;
        }
     }
  }
//+------------------------------------------------------------------+
//| スパンモデル遅行スパン                                               |
//+------------------------------------------------------------------+
void SetSessionSMCSSignal(string sSignal,int iBarNo)
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

     }
   else if(SessionSMCSpanSigCnt>0)
     {
      SessionSMCSSignal=sSignal;
      SessionSMCSpanSigCnt=SessionSMCSpanSigCnt+1;
      SessionSMCSpanSigCnt=0;
     }
  }
//+------------------------------------------------------------------+
//| スーパーボリンジャーシグマライン                                      |
//+------------------------------------------------------------------+
void SetSessionSBSLSignal(string sSignal,int iBarNo)
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

     }
   else if(SessionSBSLineSigCnt>0)
     {
      SessionSBSLSignal=sSignal;
      SessionSBSLineSigCnt=SessionSBSLineSigCnt+1;
      SessionSBSLineSigCnt=0;
     }
  }
//+------------------------------------------------------------------+
//| オープンシグナル                                           |
//+------------------------------------------------------------------+
void SetSessionOpenSignal(string sSignal,int iBarNo)
  {

//シグナルセット
   SessionOpenSignal=sSignal;
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
//| 全ポジションクローズ                                                    |
//+------------------------------------------------------------------+
void PositionCloseAll()
  {

//オーダー情報取得
   for(int i=0; i<OrdersTotal(); i++)
     {
      bool bSelected=OrderSelect(i,SELECT_BY_POS);
      if(OrderSymbol()==Symbol())
        {
         //ポジションクローズ
         bool Closed=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),SLIPPAGE,Magenta);
         if(Closed==true)
           {
              }else{
            int iLastError=GetLastError();
            string sErrMessage=ErrorDescription(iLastError);
            SendNotification(Symbol()+" "+sErrMessage);
           }
        }
     }
   return;
  }
//+------------------------------------------------------------------+
