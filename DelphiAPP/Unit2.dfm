object listUnit: TlistUnit
  Left = 569
  Top = 200
  Width = 453
  Height = 370
  Caption = 'listUnit'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 40
    Top = 0
    Width = 40
    Height = 13
    Caption = 'Contoh :'
  end
  object Label2: TLabel
    Left = 48
    Top = 24
    Width = 38
    Height = 13
    Caption = 'PC2000'
  end
  object Label3: TLabel
    Left = 184
    Top = 24
    Width = 72
    Height = 13
    Caption = 'J20059/EX286'
  end
  object saveBtn: TButton
    Left = 344
    Top = 296
    Width = 75
    Height = 25
    Caption = 'SAVE'
    TabOrder = 0
  end
  object inputModelUnit: TEdit
    Left = 40
    Top = 48
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'Model Unit'
  end
  object inputSerialUnit: TEdit
    Left = 184
    Top = 48
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'Serial/Kode Unit'
  end
  object tambahBtn: TButton
    Left = 336
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Tambah'
    TabOrder = 3
  end
  object typeUnitComBox: TComboBox
    Left = 40
    Top = 88
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 4
    Text = 'List Type Unit'
  end
  object ListBox1: TListBox
    Left = 40
    Top = 120
    Width = 377
    Height = 161
    ItemHeight = 13
    TabOrder = 5
  end
end
