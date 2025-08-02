object VHMStrend: TVHMStrend
  Left = 188
  Top = 117
  Width = 922
  Height = 480
  Caption = 'VHMStrend'
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
    Left = 384
    Top = 8
    Width = 247
    Height = 39
    Caption = 'VHMS TREND'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'News701 BT'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 392
    Top = 408
    Width = 189
    Height = 24
    Caption = 'Created by ToNaY'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Magneto'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object modelUnit: TComboBox
    Left = 24
    Top = 8
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 0
    Text = 'Model Unit'
  end
  object generate: TButton
    Left = 64
    Top = 168
    Width = 75
    Height = 25
    Caption = 'Generate'
    TabOrder = 1
  end
  object cekChart: TCheckListBox
    Left = 24
    Top = 208
    Width = 153
    Height = 113
    ItemHeight = 13
    TabOrder = 2
  end
  object Chart1: TChart
    Left = 200
    Top = 64
    Width = 689
    Height = 345
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Title.Text.Strings = (
      'TChart')
    TabOrder = 3
    object Memo1: TMemo
      Left = 0
      Top = 0
      Width = 105
      Height = 113
      Lines.Strings = (
        'Memo1')
      TabOrder = 0
    end
  end
  object wktDari: TDateTimePicker
    Left = 24
    Top = 80
    Width = 145
    Height = 21
    Date = 45862.771494131940000000
    Time = 45862.771494131940000000
    TabOrder = 4
  end
  object wktHingga: TDateTimePicker
    Left = 24
    Top = 120
    Width = 145
    Height = 21
    Date = 45862.771650833330000000
    Time = 45862.771650833330000000
    TabOrder = 5
  end
  object editList: TButton
    Left = 808
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Edit List'
    TabOrder = 6
    OnClick = editListClick
  end
  object serialUnit: TComboBox
    Left = 24
    Top = 48
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 7
    Text = 'Serial Number Unit'
  end
end
