object Form1: TForm1
  Left = 223
  Top = 126
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'DDTText Demo'
  ClientHeight = 522
  ClientWidth = 778
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 409
    Height = 177
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object ListBox1: TListBox
    Left = 424
    Top = 8
    Width = 345
    Height = 97
    ItemHeight = 16
    TabOrder = 3
  end
  object StringGrid1: TStringGrid
    Left = 424
    Top = 168
    Width = 345
    Height = 281
    ColCount = 3
    RowCount = 7
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
    TabOrder = 5
    OnSelectCell = StringGrid1SelectCell
    ColWidths = (
      64
      161
      83)
    RowHeights = (
      24
      24
      24
      24
      24
      24
      24)
  end
  object Button2: TButton
    Left = 20
    Top = 488
    Width = 749
    Height = 25
    Caption = 'Test button'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
  end
  object Panel1: TPanel
    Left = 424
    Top = 112
    Width = 345
    Height = 49
    Caption = 'Panel1'
    TabOrder = 9
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 192
    Width = 409
    Height = 289
    Caption = 'GroupBox1'
    TabOrder = 10
    object Label1: TLabel
      Left = 16
      Top = 20
      Width = 377
      Height = 109
      AutoSize = False
      Caption = 'Label1'
    end
  end
  object Button1: TButton
    Left = 24
    Top = 440
    Width = 377
    Height = 25
    Caption = #1055#1086#1083#1091#1095#1077#1085#1080#1077' '#1087#1086#1089#1083#1077#1076#1085#1077#1075#1086' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1072' '#1087#1077#1088#1077#1090#1072#1089#1082#1080#1074#1072#1085#1080#1103
    TabOrder = 6
    OnClick = Button1Click
  end
  object ComboBox1: TComboBox
    Left = 24
    Top = 404
    Width = 377
    Height = 24
    ItemHeight = 16
    TabOrder = 4
    Text = 'ComboBox1'
  end
  object LabeledEdit1: TLabeledEdit
    Left = 24
    Top = 364
    Width = 377
    Height = 24
    EditLabel.Width = 80
    EditLabel.Height = 16
    EditLabel.Caption = 'LabeledEdit1'
    TabOrder = 0
  end
  object Edit1: TEdit
    Left = 24
    Top = 325
    Width = 377
    Height = 24
    TabOrder = 2
    Text = 'Edit1'
  end
  object Button3: TButton
    Left = 424
    Top = 453
    Width = 345
    Height = 28
    Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1080#1089#1090#1086#1088#1080#1102
    TabOrder = 8
    OnClick = Button3Click
  end
end
