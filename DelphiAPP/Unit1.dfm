object VHMStrend: TVHMStrend
  Left = 269
  Top = 118
  Width = 950
  Height = 520
  Caption = 'VHMStrend'
  Color = clBtnFace
  Constraints.MinHeight = 520
  Constraints.MinWidth = 950
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    934
    481)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 360
    Top = 0
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
    Left = 440
    Top = 416
    Width = 32
    Height = 13
    Caption = 'Label2'
  end
  object modelUnit: TComboBox
    Left = 0
    Top = 0
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 0
    Text = 'Model Unit'
    OnChange = modelUnitChange
  end
  object generate: TButton
    Left = 24
    Top = 152
    Width = 75
    Height = 25
    Caption = 'Generate'
    TabOrder = 2
    OnClick = generateClick
  end
  object cekChart: TCheckListBox
    Left = 0
    Top = 184
    Width = 198
    Height = 247
    OnClickCheck = cekChartClick
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 3
  end
  object Chart1: TChart
    Left = 152
    Top = 48
    Width = 611
    Height = 428
    AnimatedZoomSteps = 3
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    MarginBottom = 0
    MarginLeft = 0
    MarginRight = 5
    MarginTop = 0
    Title.Text.Strings = (
      'TChart')
    OnClickLegend = Chart1ClickLegend
    BottomAxis.DateTimeFormat = 'dd/MM/yyyy'
    BottomAxis.LabelsAngle = 45
    BottomAxis.LabelsMultiLine = True
    BottomAxis.LabelsOnAxis = False
    BottomAxis.LabelsSize = 20
    BottomAxis.MinorTickLength = 4
    BottomAxis.TickLength = 12
    LeftAxis.LabelsMultiLine = True
    Legend.Alignment = laBottom
    View3D = False
    ParentColor = True
    TabOrder = 4
    Anchors = [akLeft, akTop, akRight, akBottom]
    Constraints.MaxHeight = 700
    Constraints.MaxWidth = 1100
    Constraints.MinHeight = 100
    Constraints.MinWidth = 600
    OnMouseMove = Chart1MouseMove
    object Series1: TLineSeries
      Marks.ArrowLength = 8
      Marks.Style = smsValue
      Marks.Visible = False
      SeriesColor = clRed
      Pointer.InflateMargins = False
      Pointer.Style = psDiamond
      Pointer.Visible = True
      XValues.DateTime = True
      XValues.Name = 'X'
      XValues.Multiplier = 1.000000000000000000
      XValues.Order = loAscending
      YValues.DateTime = False
      YValues.Name = 'Y'
      YValues.Multiplier = 1.000000000000000000
      YValues.Order = loNone
    end
  end
  object wktDari: TDateTimePicker
    Left = 0
    Top = 72
    Width = 145
    Height = 21
    Date = 45862.771494131940000000
    Time = 45862.771494131940000000
    TabOrder = 5
    OnChange = cekChartClick
  end
  object wktHingga: TDateTimePicker
    Left = 0
    Top = 112
    Width = 145
    Height = 21
    Date = 45862.771650833330000000
    Time = 45862.771650833330000000
    TabOrder = 6
    OnChange = cekChartClick
  end
  object editList: TButton
    Left = 849
    Top = 8
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Edit List'
    TabOrder = 7
    OnClick = editListClick
  end
  object serialUnit: TComboBox
    Left = 0
    Top = 40
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 1
    Text = 'Serial Number Unit'
  end
  object unCek: TButton
    Left = 4
    Top = 440
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = 'UN/Cek ALL'
    TabOrder = 8
    OnClick = unCekClick
  end
  object ListBox1: TListBox
    Left = 770
    Top = 56
    Width = 152
    Height = 409
    Anchors = [akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 9
  end
  object ListBox2: TListBox
    Left = 776
    Top = 376
    Width = 121
    Height = 97
    ItemHeight = 13
    TabOrder = 10
    Visible = False
  end
end
