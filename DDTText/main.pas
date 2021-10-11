unit main;

interface

uses
  Windows, Messages, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, DDTText;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    LabeledEdit1: TLabeledEdit;
    Edit1: TEdit;
    ListBox1: TListBox;
    ComboBox1: TComboBox;
    StringGrid1: TStringGrid;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    DDTT: TDDTarget;
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation


{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin

  DDTT := TDDTarget.Create(handle);

  DDTT.SetControlObject(Memo1);
  DDTT.SetControlObject(Form1);
  DDTT.SetControlObject(Label1, false, true, 6);
  DDTT.SetControlObject(Edit1, true);
  DDTT.SetControlObject(ListBox1);
  DDTT.SetControlObject(ComboBox1, false, true);
  DDTT.SetControlObject(LabeledEdit1, true);
  DDTT.SetControlObject(StringGrid1, true);
  DDTT.SetControlObject(Button2, false, true);
  DDTT.SetControlObject(GroupBox1);
  DDTT.SetControlObject(Panel1);
  DDTT.SetHistory;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DDTT.Free;
end;

procedure TForm1.StringGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  DDTT.SetCells(ACol, ARow);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Button1.Caption := DDTT.Result;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
 i: byte;
 mes: String;
begin
  if DDTT.HCount = 0 then exit; // ничего нет

  for i := DDTT.HRange(5) to DDTT.HCount-1 do
    mes:= mes + DDTT.HRow(i)+#10#13;
  ShowMessage(mes);
end;

end.
