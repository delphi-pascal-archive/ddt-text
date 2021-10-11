{ *****************************************************************************
  ->> DDTText - реализация технологии Drag & Drop для визуальных
      компонентов, работающих с текстом

  ->> Описание: 
      Модуль содержит в себе классы для удобной работы с технологией Drag & Drop
      
      * Позволяет перетягивать мышью текстовую информацию из таких приложений,
        как MSWorld (и др.) в компоненты типа TLabel, TEdit, TMemo, в поле
        TCaption формы, TStringGrid и др. Полный список см. в процедуре
        TObjects.SetText.

  
  unit ver 1.0

  Author: Kordal, kordal@kornet.ru, icq 8281400
  Copyright © 2008 by LS Software

****************************************************************************** }
unit DDTText;

interface

uses
  Windows, Forms, Classes, StdCtrls, ExtCtrls, Grids,
  ComObj, ActiveX;


type
  TDDTarget = class
  public
    constructor Create (Wnd: hWnd);
    destructor  Destroy; override;
    
    procedure SetControlObject(AObj: TComponent; Focused: Boolean=False;
              Multiline: Boolean=False; Limit: Integer=5);
    procedure SetCells(Col, Row: Integer);
    function  Result: String;
    function  Count: Integer;

    procedure SetHistory;
    function  HCount: Integer;
    function  HRange(FRange: Integer): Integer;
    function  HRow(Index: Integer): String;
    function  HStrings: String;
    procedure HSort;
    procedure HistoryClear;
    procedure HistoryFree;
  end;


implementation


type
  TObjects = object
    AObj:      TComponent;
    Focused:   Boolean;
    Multiline: Boolean;
    Limit:     Integer;
    function   IsFocused: Boolean;
    procedure  SetText;
    procedure  AddText(Lim: Integer);
  end;


type
  TDropTarget = class(TInterfacedObject, IDropTarget)
  protected
    function DragEnter(const dataObj: IDataObject; grfKeyState: Longint;
      pt: TPoint; var dwEffect: Longint): HResult; stdcall;
    function DragOver(grfKeyState: Longint; pt: TPoint;
      var dwEffect: Longint): HResult; stdcall;
    function DragLeave: HResult; stdcall;
    function Drop(const dataObj: IDataObject; grfKeyState: Longint; pt: TPoint;
      var dwEffect: Longint): HResult; stdcall;
  end;


var
  IDT: IDropTarget;
  hWindow: hWnd;
  RText: String;
  Obj: Array [1..100] of TObjects;
  ObjCount: Byte;
  ACol, ARow: Integer;

  THistory: TStringList; // история
  TCount:  Integer; // количество операций Drag&Drop


function Trim(const S: String): String;
begin
  Result := S;
  while (Length(Result) > 0) and (Result[1] <= ' ') do
    Delete(Result, 1, 1); // Пробелы слева
  while (Length(Result) > 0) and (Result[Length(Result)] <= ' ') do
    Delete(Result, Length(Result), 1); // Пробелы справа
end;


function TObjects.IsFocused: Boolean;
begin
  Result := false;
  try
    if (AObj is TEdit)        and (AObj as TEdit).Focused        then Result := true;
    if (AObj is TMemo)        and (AObj as TMemo).Focused        then Result := true;
    if (AObj is TListBox)     and (AObj as TListBox).Focused     then Result := true;
    if (AObj is TComboBox)    and (AObj as TComboBox).Focused    then Result := true;
    if (AObj is TLabeledEdit) and (AObj as TLabeledEdit).Focused then Result := true;
    if (AObj is TButton)      and (AObj as TButton).Focused      then Result := true;
    if (AObj is TStringGrid)  and (AObj as TStringGrid).Focused  then Result := true;
    if (AObj is TPanel)       and (AOBJ as TPanel).Focused       then Result := true;
  except
  end;
end;


procedure TObjects.SetText;
begin
  try
    if (AObj is TForm)        then (AObj as TForm).Caption := RText;
    if (AObj is TLabel)       then (AObj as TLabel).Caption := RText;
    if (AObj is TEdit)        then (AObj as TEdit).Text := RText;
    if (AObj is TMemo)        then (AObj as TMemo).Text := RText;
    if (AObj is TListBox)     then begin
                                   (AObj as TListBox).Clear;
                                   (AObj as TListBox).Items.Add(RText);
    end;
    if (AObj is TComboBox)    then (AObj as TComboBox).Text := RText;
    if (AObj is TLabeledEdit) then (AObj as TLabeledEdit).Text := RText;
    if (AObj is TButton)      then (AObj as TButton).Caption := RText;
    if (AObj is TGroupBox)    then (AObj as TGroupBox).Caption := RText;
    if (AObj is TStringGrid)  then (AObj as TStringGrid).Cells[ACol, ARow] := RText;
    if (AObj is TPanel)       then (AObj as Tpanel).Caption := RText;
  except
  end;
end;


procedure TObjects.AddText(Lim: Integer);
  procedure SetMultiline(hWindow: hWnd);
  var
    i: Integer;
  begin
    i := GetWindowLong(hWindow, GWL_STYLE);
    SetWindowLong(hWindow, GWL_STYLE, i or BS_MULTILINE);
  end;

begin
  try
    if (AObj is TMemo)        then (AObj as TMemo).Lines.Add(RText);
    if (AObj is TListBox)     then (AObj as TListBox).Items.Add(RText);
    if (AObj is TComboBox)    then (AObj as TComboBox).Items.Add(RText);
    if (AObj is TGroupBox)    then (AObj as TGroupBox).Caption := RText;
    if (AObj is TLabel)       then
    begin
      if Lim < 0 then Exit; // лимит исчерпан
      if TCount = 1 then (AObj as TLabel).Caption := '';
      (AObj as TLabel).WordWrap := true;
      (AObj as TLabel).AutoSize := false;
      (AObj as TLabel).Height := (AObj as TLabel).Height + 10;
      (AObj as TLabel).Caption := (AObj as TLabel).Caption +#10#13+ TRim(RText);
      (AObj as TLabel).Caption := Trim((AObj as TLabel).Caption);
    end;
    if (AObj is TButton)      then
    begin
      if Lim < 0 then Exit; // лимит исчерпан
      if TCount = 1 then (AObj as TButton).Caption := '';
      SetMultiline((AObj as TButton).Handle);
      (AObj as TButton).Caption := (AObj as TButton).Caption +#10#13+ RText;
      (AObj as TButton).Height := (AObj as TButton).Height + 10;
      (AObj as TButton).Caption := Trim((AObj as TButton).Caption);
    end;
    //if (AObj is TPanel)      then
  except
  end;
end;


{ TDropTarget }
function TDropTarget.DragEnter(const dataObj: IDataObject;
  grfKeyState: Integer; pt: TPoint; var dwEffect: Integer): HResult;
begin
  Result := S_OK;
end;


function TDropTarget.DragLeave: HResult;
begin
  Result := S_OK;
end;


function TDropTarget.DragOver(grfKeyState: Integer; pt: TPoint;
  var dwEffect: Integer): HResult;
begin
  Result := S_OK;
end;


function TDropTarget.Drop(const dataObj: IDataObject;
  grfKeyState: Integer; pt: TPoint; var dwEffect: Integer): HResult;
var
  FMT:    FORMATETC;
  MED:    STGMEDIUM;
  Size:   DWORD;
  Buffer: PChar;
  i:      Byte;

begin
  Result := S_OK;
  FMT.cfFormat := CF_TEXT; //Мы принимаем только обычный текст
  FMT.ptd := nil;
  FMT.dwAspect := DVASPECT_CONTENT; //Само содержимое
  FMT.lindex := -1;                 //Получаем все что есть
  FMT.tymed := TYMED_HGLOBAL;       //В виде глобального буфера
  try
    OLECheck(dataObj.GetData(FMT, MED)); //Пробуем получить данные
    Size := GlobalSize(MED.hGlobal);
    Buffer := GlobalLock(MED.hGlobal);
    SetString(RText, Buffer, Size);
    RText := Trim(RText);
    GlobalUnlock(MED.hGlobal);
    ReleaseStgMedium(MED);

    Inc(TCount);
    try
      THistory.Add(RText);
    except
    end;

    for i:=1 to ObjCount do
    begin
      Dec(Obj[i].Limit); // осталось
      
      if (Obj[i].Focused) and (Obj[i].IsFocused) then
        if not (Obj[i].Multiline) then
          Obj[i].SetText // вставить
        else
          Obj[i].AddText(Obj[i].Limit); // добавить

      if not (Obj[i].Focused) then
        if not (Obj[i].Multiline) then
          Obj[i].SetText // вставить
        else
          Obj[i].AddText(Obj[i].Limit); // добавить
    end;
          
  except //Источник не поддерживает нужный формат
    Result := E_UNEXPECTED;
  end;
end;


{ TDDTarget }
constructor TDDTarget.Create(Wnd: hWnd);
begin
  inherited Create;
  //
  hWindow := Wnd;
  TCount := 0;
  ObjCount := 0;
  OleInitialize(nil);
  IDT := TDropTarget.Create;
  OLECheck(CoLockObjectExternal(IDT, true, false));
  OLECheck(RegisterDragDrop(hWindow, IDT));
end;


destructor TDDTarget.Destroy;
begin
  inherited Destroy;
  //
  try
    OLECheck(RevokeDragDrop(hWindow));
    THistory.Free;
  except
    Application.HandleException(Self);
  end;
  OleUninitialize;
end;


procedure TDDTarget.SetControlObject(AObj: TComponent; Focused: Boolean=False;
          Multiline: Boolean=False; Limit: Integer=5);
begin
  Inc(ObjCount);
  Obj[ObjCount].AObj := AObj;
  Obj[ObjCount].Focused := Focused;
  Obj[ObjCount].Multiline := Multiline;
  Obj[ObjCount].Limit := Limit;
end;


procedure TDDTarget.SetCells(Col, Row: Integer);
begin
  ACol := Col;
  ARow := Row;
end;


function TDDTarget.Result: String;
begin
  Result := RText;
end;


function TDDTarget.Count;
begin
  Result := TCount;
end;


procedure TDDTarget.SetHistory;
begin
  THistory := TStringList.Create;
  THistory.Clear;
end;


function TDDTarget.HCount: Integer;
begin
  try
    Result :=  THistory.Count;
  except
    Result := -1;
  end;
end;


function TDDTarget.HRange(FRange: Integer): Integer;
begin
  if THistory.Count <= FRange then
    Result := 0
  else
    Result := THistory.Count - FRange;
end;


function TDDTarget.HRow(Index: Integer): String;
begin
  try
    Result := THistory.Strings[Index];
  except
    Result := 'No History!';
  end;
end;


function TDDTarget.HStrings: String;
begin
  try
    Result := THistory.Text;
  except
    Result := 'No History!';
  end;
end;


procedure TDDTarget.HSort;
begin
  try
    THistory.Sort;
  except
  end;
end;


procedure TDDTarget.HistoryClear;
begin
  try
    THistory.Clear;
  except
  end;
end;


procedure TDDTarget.HistoryFree;
begin
  try
    THistory.Free;
  except
  end;
end;



end.
