unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, TeeProcs, TeEngine, Chart,
  CheckLst, Series, DateUtils;

type
  TVHMStrend = class(TForm)
    editList: TButton;    
    Chart1: TChart;
    Series1: TLineSeries;
    wktDari: TDateTimePicker;
    wktHingga: TDateTimePicker;
    unCek: TButton;
    
    EditModel: TEdit;
    BtnMinModel: TButton;
    BtnPlusModel: TButton;
    EditSerial: TEdit;
    BtnMinSerial: TButton;
    BtnPlusSerial: TButton;
    cekChart: TCheckListBox;
    Label1: TLabel;
    lastDate: TLabel;
    Memo1: TMemo;
    Label2: TLabel;
    Label3: TLabel;
    lastHM: TLabel;


    procedure editListClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnPlusModelClick(Sender: TObject);
    procedure BtnMinModelClick(Sender: TObject);
    procedure BtnPlusSerialClick(Sender: TObject);
    procedure BtnMinSerialClick(Sender: TObject);
    procedure refresChart(Sender: TObject);
    procedure unCekClick(Sender: TObject);
    procedure Chart1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    procedure cekFileDataCSV;
    procedure parsingData;
    procedure UpdateChart;
  public
    procedure loadListUnit;
    procedure UpdateListUnit;
  end;

type
  TTrendRow = record
    Calendar: TDateTime;
    HM: string;
    Values: array of Double;
  end;

var
  VHMStrend: TVHMStrend;

  SavedArea: TBitmap;

  minorVersi, varianKode: string;
  EngineModel: string;
  EGSerial: TStringList;
  lastTimeDL, lastHMDL: string;
  ModelList: TStringList;
  SerialList: TStringList;
  KodeList: TStringList;
  folderName: string;

  selectedModel, selectedSerial, selectedKode: string;

  ItemRateStr: TStringList;
  ItemDataList: TStringList;
  ScaleItemList: TStringList;
  selectedScale: TStringList;
  SelectedCalendar: TStringList;
  SelectedHM: TStringList;

  Xcount, Ycount: Integer;
  

  ModelCount, unitCount, IndexModel, IndexUnit: Integer;
  TrendRows: array of TTrendRow;
  UnitList: array of record
    Model: string;
    Serial: string;
    Kode: string;
  end;

implementation

uses Unit2, Unit3, Unit4;

{$R *.dfm}

//Awal open form
procedure TVHMStrend.FormCreate(Sender: TObject);
begin
  ItemRateStr := TStringList.Create;
  ScaleItemList := TStringList.Create;
  selectedScale := TStringList.Create;
  SelectedCalendar:= TStringList.Create;
  SelectedHM:= TStringList.Create;
  ModelList := TStringList.Create;
  KodeList := TStringList.Create;
  SerialList := TStringList.Create;
  loadListUnit;
end;

// untuk membuka form edit list unit
procedure TVHMStrend.editListClick(Sender: TObject);
begin
  listUnit.Show;
end;

// memperbarui list unit jika model unit di ubah
procedure TVHMStrend.UpdateListUnit;
var
  i: Integer;
begin
  KodeList.Clear;
  SerialList.Clear;
  selectedModel := EditModel.Text;
  for i := 0 to High(UnitList) do
    if UnitList[i].Model = selectedModel then
      begin
      KodeList.Add(UnitList[i].Kode);
      SerialList.Add(UnitList[i].Serial);
      end;

  unitCount := KodeList.Count;
  IndexUnit := 0;
  EditSerial.Text := KodeList[IndexUnit] + '/' + SerialList[IndexUnit];
  selectedSerial := SerialList[IndexUnit];
  selectedKode := KodeList[IndexUnit];
  cekFileDataCSV;
end;

// load list unit dari file listUnit.csv
procedure TVHMStrend.loadListUnit;
var
  sl: TStringList;
  i: Integer;
  fields: TStringList;
  dataCount: Integer;
begin
  sl := TStringList.Create;
  fields := TStringList.Create;
  try
    if FileExists('List\listUnit.csv') then
      sl.LoadFromFile('List\listUnit.csv');
    dataCount := sl.Count - 1;
    if dataCount > 0 then
      SetLength(UnitList, dataCount)
    else
      SetLength(UnitList, 0);

    for i := 1 to sl.Count - 1 do
    begin
      fields.CommaText := sl[i];
      if fields.Count >= 3 then
      begin
        UnitList[i-1].Model := fields[0];
        UnitList[i-1].Kode := fields[1];
        UnitList[i-1].Serial := fields[2];
        if ModelList.IndexOf(fields[0]) = -1 then
          ModelList.Add(fields[0]);
      end;
    end;

    IndexModel := 0;
    ModelCount := ModelList.Count;
    EditModel.Text := UnitList[IndexModel].Model;
    UpdateListUnit;
    selectedModel := UnitList[IndexModel].Model;
    selectedSerial := UnitList[IndexUnit].Serial;
    selectedKode := KodeList[IndexUnit];


  finally
    FreeAndNil(sl);
    FreeAndNil(fields);
  end;
  cekFileDataCSV;
end;

// (tmbl Model next) model di ganti update list unit
procedure TVHMStrend.BtnPlusModelClick(Sender: TObject);
begin
  IndexModel := IndexModel + 1;
  if IndexModel = ModelCount then
    IndexModel := 0;
  EditModel.Text := ModelList[IndexModel];
  IndexUnit := 0;
  UpdateListUnit;
  // cekFileDataCSV;
end;

// (tmbl Model prev) model di ganti update list unit
procedure TVHMStrend.BtnMinModelClick(Sender: TObject);
begin
  IndexModel := IndexModel - 1;
  if IndexModel < 0 then
    IndexModel := ModelCount - 1;
  EditModel.Text := ModelList[IndexModel];
  IndexUnit := 0;
  UpdateListUnit;
  // cekFileDataCSV;
end;

// (tmbl Model next) unit di ganti update list unit
procedure TVHMStrend.BtnPlusSerialClick(Sender: TObject);
begin
  IndexUnit := IndexUnit + 1;
  if IndexUnit = unitCount then
    IndexUnit := 0;
  EditSerial.Text := KodeList[IndexUnit] + '/' + SerialList[IndexUnit];
  selectedSerial := SerialList[IndexUnit];
  selectedKode := KodeList[IndexUnit];
  cekFileDataCSV;
end;

// (tmbl serial prev) unit di ganti update list unit
procedure TVHMStrend.BtnMinSerialClick(Sender: TObject);
begin
  IndexUnit := IndexUnit - 1;
  if IndexUnit < 0 then
    IndexUnit := unitCount - 1;
  EditSerial.Text := KodeList[IndexUnit] + '/' + SerialList[IndexUnit];
  selectedSerial := SerialList[IndexUnit];
  selectedKode := KodeList[IndexUnit];
  cekFileDataCSV;
end;

procedure TVHMStrend.unCekClick(Sender: TObject);
var
  i: Integer;
begin
  for i:= 0 to cekChart.Items.Count - 1 do
  begin
    cekChart.Checked[i] := False;
    end;
  UpdateChart;
end;

procedure TVHMStrend.refresChart(Sender: TObject);
begin
  UpdateChart
end;

// cek folder dan file berdasarkan Model dan Serial Unit
procedure TVHMStrend.cekFileDataCSV;
var
  maxFolder: string;
  sr: TSearchRec;
  found: Boolean;

begin
  // cek folder sesuai model unit
  folderName := 'C:\VHMS_DATA\' + selectedModel;
  if not DirectoryExists(folderName) then
  begin
    ShowMessage('Folder Model: ' + selectedModel + ' Tidak Ada');
    Exit;
  end;

  // cek folder sesuai serial unit
  folderName := folderName + '\' + selectedSerial;
  if not DirectoryExists(folderName) then
  begin
    ShowMessage('Folder ' + selectedModel + ' Serial: ' + selectedSerial + ' Tidak Ada');
    Exit;
  end;

  // cek apakah sudah ada data vhms by folder tanggal
  maxFolder := '';
  found := False;
  if FindFirst(folderName + '\*', faDirectory, sr) = 0 then
  begin
    repeat
      if (sr.Attr and faDirectory = faDirectory) and
         (sr.Name <> '.') and (sr.Name <> '..') then
      begin
        if (maxFolder = '') or (sr.Name > maxFolder) then
        begin
          maxFolder := sr.Name;
          found := True;
        end;
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;

  if not found then
  begin
    ShowMessage('Tidak ada subfolder di: ' + folderName);
    Exit;
  end;

  // jika folder tgl ada tp folder CHK0001 tidak ada
  folderName := folderName + '\' + maxFolder + '\CHK0001';
  if not DirectoryExists(folderName) then
  begin
    ShowMessage('Folder CHK001 tidak ditemukan di: ' + maxFolder);
    Exit;
  end;

  // cek apakah ada file trend0.CSV
  folderName := folderName + '\trend0.CSV';
  if not FileExists(folderName) then
  begin
    ShowMessage('File trend0.CSV tidak ditemukan di: ' + selectedModel +
    ' ' + selectedSerial + ' ' + maxFolder);
    Exit;
  end;
  parsingData;
end;

//mengolah data trend0.CSV
procedure TVHMStrend.parsingData;
var
  lines: TStringList;
  i, j, dataStart: Integer;
  axisLine, dataLine, s: string;
  fields: TStringList;
  epoch, offset: Int64;
  epochStr, offsetStr: string;
  p1, p2: Integer;
  hmStr: string;
  hmFloat: single;
  
begin
  // --- Parsing Axis Item untuk cekChart ---
  lines := TStringList.Create;
  lines.LoadFromFile(folderName);

  ItemRateStr.Clear;
  ScaleItemList.Clear;

  ItemDataList := TStringList.Create;
  fields := TStringList.Create;
  EGSerial := TStringList.Create;
  try
    // mengambil Minor dan varian kode unit
    for i := 0 to lines.Count - 1 do
    begin
      if Pos('Machine Type & Minor Variation Code', lines[i]) = 1 then
      begin
        s := lines[i];
        fields.CommaText := Copy(s, Pos(',', s) + 1, MaxInt);
      end;
    end;
    minorVersi := fields[0];
    varianKode := fields[1];
    
    // mengambil HM terakhir download
    for i := 0 to lines.Count - 1 do
    begin
      if Pos('Engine Model & Serial No.1 2 3', lines[i]) = 1 then
      begin
        s := lines[i];
        EGSerial.CommaText := Copy(s, Pos(',', s) + 1, MaxInt);
      end;
    end;
    EngineModel := EGSerial[0];
    
    // mengambil Waktu terakhir download
    for i := 0 to lines.Count - 1 do
    begin
      if Pos('Time Stamp', lines[i]) = 1 then
      begin
        s := lines[i];
        fields.CommaText := Copy(s, Pos(',', s) + 1, MaxInt);
      end;
    end;
    lastTimeDL := fields[0] + ' ' + fields[1];
    lastDate.Caption := lastTimeDL;
    
    // mengambil HM terakhir download
    for i := 0 to lines.Count - 1 do
    begin
      if Pos('SMR,', lines[i]) = 1 then
      begin
        s := lines[i];
        fields.CommaText := Copy(s, Pos(',', s) + 1, MaxInt);
      end;
    end;
    lastHMDL := fields[0];
    lastHM.Caption := lastHMDL;
    
    // mengambil Rate pembagi value
    // Parsing Item
    // Axis Rate,10,1,1,1,100,1,1,1,1,1,100,100,100,1,1,1,10,1,1,1,0.1,10,10,
               //10,10,10,10,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,10,1,1,1,1,1,1,1,1,1,1

    for i := 0 to lines.Count - 1 do
    begin
      if Pos('Axis Rate', lines[i]) = 1 then
      begin
        axisLine := lines[i];
        ItemRateStr.CommaText := Copy(axisLine, Pos(',', axisLine) + 1, MaxInt);
        Break;
      end;
    end;
    
    // mengambil Judul Series dari Axis Item Contoh (Eng.TempOilMax)
    // Parsing Item
    // Axis Item,SMR,Calendar,Eng.Speed(Max),Eng.Speed(Ave),Blowby Press Max,LF Exh.Temp Max,LR Exh.Temp Max,RF Exh.Temp Max,
               //RR Exh.Temp Max,Boost Press Max,E.Oil P.Max,E.Oil P.Lo_Min,E.Oil P.Hi_Min,Eng.Oil Tmp.Max,Fuel Rate,Cool Temp.Max,
               //Cool Temp.Min,TM Oil Temp.Max,Ambient TempMax,Ambient TempAve,Ambient TempMin,Atomos. Pres.Ave,F Brake P.Max,
               //R Brake P.Max,TravelSpeed Max,ECO ON
    for i := 0 to lines.Count - 1 do
    begin
      if Pos('Axis Item', lines[i]) = 1 then
      begin
        axisLine := lines[i];
        axisLine := StringReplace(axisLine, ' ', '', [rfReplaceAll]);
        ItemDataList.CommaText := Copy(axisLine, Pos(',', axisLine) + 1, MaxInt);
        Break;
      end;
    end;

    //mengambil Satuan scala data COntoh(degC)
    // Parsing Scala
    // Axis Scale,h,,rpm,rpm,kPa,degC,degC,degC,degC,kPa,MPa,MPa,MPa,degC,Liter/h,degC,degC,degC,degC,degC,degC,hPa,MPa,MPa,km/h,sec
    for i := 0 to lines.Count - 1 do
    begin
      if Pos('Axis Scale,h,,', lines[i]) = 1 then
      begin
        axisLine := lines[i];
        ScaleItemList.CommaText := Copy(axisLine, Pos(',', axisLine) + 1, MaxInt);
        Break;
      end;
    end;


    cekChart.Items.Clear;
    for i := 2 to ItemDataList.Count - 1 do
      begin
        cekChart.Items.Add(ItemDataList[i]);
      end;
    // Centang default pada cekBox
    
    for i := 0 to cekChart.Items.Count - 1 do
    begin
      if cekChart.Items[i] = 'Eng.OilTmp.MAX' then cekChart.Checked[i] := true;
      if cekChart.Items[i] = 'CoolTemp.MAX' then cekChart.Checked[i] := true;
      if cekChart.Items[i] = 'HydOilTempMax' then cekChart.Checked[i] := true;
      if cekChart.Items[i] = 'TMOilTempMax' then cekChart.Checked[i] := true;
      if cekChart.Items[i] = 'HydOilTempAve' then cekChart.Checked[i] := true;
      if cekChart.Items[i] = 'T/COilTempMax' then cekChart.Checked[i] := true;
      if cekChart.Items[i] = 'PTOTempMax' then cekChart.Checked[i] := true;
      if cekChart.Items[i] = 'TMOilTemp.Max' then cekChart.Checked[i] := true;
    end;
  finally
    ItemDataList.Free;
  end;

  // --- Parsing Data ---
  dataStart := -1;
  for i := 0 to lines.Count - 1 do
    if lines[i] = '[Data]' then
    begin
      dataStart := i + 1;
      Break;
    end;
  if dataStart = -1 then
  begin
    lines.Free;
    Exit;
  end;

  SetLength(TrendRows, lines.Count - dataStart);
  // fields := TStringList.Create;
  try
    for i := dataStart to lines.Count - 1 do
    begin
      dataLine := lines[i];
      fields.CommaText := dataLine;
      if fields.Count < 3 then Continue;

      //HM
      s := fields[1];
      hmStr := Copy(s, 1, Length(s));
      hmFloat := StrToFloat(hmStr);
      hmStr := FloatToStr(hmFloat / 10);
      TrendRows[i - dataStart].HM := hmStr; 

      // Calendar
      s := fields[2];
      p1 := Pos('|', s);
      if p1 > 0 then
      begin
        epochStr := Copy(s, 1, p1 - 1);
        p2 := Pos('|', Copy(s, p1 + 1, Length(s)));
        if p2 > 0 then
          offsetStr := Copy(s, p1 + 1, p2 - 1)
        else
          offsetStr := '0';
        epoch := StrToInt64Def(epochStr, 0);
        offset := StrToInt64Def(offsetStr, 0);
        TrendRows[i - dataStart].Calendar := UnixToDateTime(epoch + offset); 
      end
      else
        TrendRows[i - dataStart].Calendar := 0;

      // Data lain
      SetLength(TrendRows[i - dataStart].Values, cekChart.Items.Count);
      for j := 0 to cekChart.Items.Count - 1 do
      begin
        if (j + 1) < fields.Count then
        begin
          TrendRows[i - dataStart].Values[j] := StrToFloatDef(fields[j + 3], 0);
        end
        else
          TrendRows[i - dataStart].Values[j] := 0;
      end;
    end;
  finally
    fields.Free;
    lines.Free;
  end;

  // ubah tanggal
  wktDari.Date := TrendRows[0].Calendar - 1;
  wktHingga.Date := TrendRows[High(TrendRows)].Calendar;

  // Tampilkan chart awal
  UpdateChart;
end;

// update chart
procedure TVHMStrend.UpdateChart;
var
  i, j: Integer;
  checkedIndex: Integer;
  dari, hingga: TDateTime;
  ValueData, Rate: double;
  RateStr: string;
  UrgentSeries, CautionSeries: TLineSeries;
  maxVal, currentVal, threshold: double;
  message: string;
  maxValDate, firstDateAboveThreshold, lastDateAboveThreshold: TDateTime;
begin
  // JUDUL CHAR
  Chart1.Title.Text.Clear;
  Chart1.Title.Text.Add('VHMS TREND');
  Chart1.Title.Text.Add(selectedKode + ' Model: ' + selectedModel + minorVersi + ' Serial Unit: ' + selectedSerial);

  Chart1.SeriesList.Clear;
  selectedScale.Clear;
  Ycount := 0;
  Chart1.BottomAxis.Title.Angle := 45;
  dari := wktDari.Date;
  hingga := wktHingga.Date;
  for i := 0 to cekChart.Items.Count - 1 do
    if cekChart.Checked[i] then
    begin
      Series1 := TLineSeries.Create(Chart1);
      Series1.Title := cekChart.Items[i];
      Series1.LinePen.Width := 3;
      Chart1.AddSeries(Series1);
      selectedScale.Add(ScaleItemList[i + 2]);
      Ycount := Ycount + 1;

      selectedCalendar.Clear;
      SelectedHM.Clear;
      for j := 0 to High(TrendRows) do
        if (TrendRows[j].Calendar >= dari) and (TrendRows[j].Calendar <= hingga) then
          begin
            ValueData := TrendRows[j].Values[i];
            RateStr := ItemRateStr[i + 2];
            RateStr := StringReplace(RateStr, '.', ',', [rfReplaceAll]);
            Rate := StrToFloat(RateStr);
            if ValueData = 0 then
              Series1.AddXY(j, TrendRows[j].Values[i], DateToStr(TrendRows[j].Calendar))
              else
                Series1.AddXY(j, ValueData / Rate, DateToStr(TrendRows[j].Calendar));
            selectedCalendar.Add(DateToStr(TrendRows[j].Calendar));
            SelectedHM.Add(TrendRows[j].HM);
            Xcount := j + 1;
          end;
  end;

  Memo1.Clear;
  if Ycount = 1 then
  begin
    Chart1.Series[0].SeriesColor := clGreen;

    UrgentSeries := TLineSeries.Create(Chart1);
    UrgentSeries.Title := 'Urgent';
    UrgentSeries.SeriesColor := clRed;
    UrgentSeries.LinePen.Width := 2;
    Chart1.AddSeries(UrgentSeries);

    CautionSeries := TLineSeries.Create(Chart1);
    CautionSeries.Title := 'Caution';
    CautionSeries.SeriesColor := clYellow;
    CautionSeries.LinePen.Width := 2;
    Chart1.AddSeries(CautionSeries);

    for j := 0 to High(TrendRows) do
      if (TrendRows[j].Calendar >= dari) and (TrendRows[j].Calendar <= hingga) then
      begin
        UrgentSeries.AddXY(j, 115, '');
        CautionSeries.AddXY(j, 95, '');
      end;

    Chart1.LeftAxis.Title.Caption := selectedScale[0];
     // --- Analysis for high values ---
    checkedIndex := -1;
    for i := 0 to cekChart.Items.Count - 1 do
      if cekChart.Checked[i] then
      begin
        checkedIndex := i;
        break;
      end;

    if checkedIndex <> -1 then
    begin
      maxVal := 0;
      maxValDate := 0;

      // First pass: Find max value
      for j := 0 to High(TrendRows) do
      begin
        if (TrendRows[j].Calendar >= dari) and (TrendRows[j].Calendar <= hingga) then
        begin
          ValueData := TrendRows[j].Values[checkedIndex];
          if ValueData = 0 then
            currentVal := 0
          else
          begin
            RateStr := ItemRateStr[checkedIndex + 2];
            RateStr := StringReplace(RateStr, '.', ',', [rfReplaceAll]);
            Rate := StrToFloat(RateStr);
            if Rate > 0 then
              currentVal := ValueData / Rate
            else
              currentVal := 0;
          end;

          if currentVal > maxVal then
          begin
            maxVal := currentVal;
            maxValDate := TrendRows[j].Calendar;
          end;
        end;
      end;

      // Determine threshold and status
      message := '';
      threshold := 0;
      if maxVal > 115 then
      begin
        Memo1.Visible := True;
        threshold := 115;
        message := 'DANGER';
      end
      else if maxVal > 95 then
      begin
        Memo1.Visible := True;
        threshold := 95;
        message := 'PERINGATAN';
      end;

      // Second pass: If threshold is passed, find date range and build message
      if threshold > 0 then
      begin
        firstDateAboveThreshold := 0;
        lastDateAboveThreshold := 0;
        for j := 0 to High(TrendRows) do
        begin
          if (TrendRows[j].Calendar >= dari) and (TrendRows[j].Calendar <= hingga) then
          begin
            ValueData := TrendRows[j].Values[checkedIndex];
            if ValueData = 0 then
              currentVal := 0
            else
            begin
              RateStr := ItemRateStr[checkedIndex + 2];
              RateStr := StringReplace(RateStr, '.', ',', [rfReplaceAll]);
              Rate := StrToFloat(RateStr);
              if Rate > 0 then
                currentVal := ValueData / Rate
              else
                currentVal := 0;
            end;

            if currentVal > threshold then
            begin
              if firstDateAboveThreshold = 0 then
                firstDateAboveThreshold := TrendRows[j].Calendar;
              lastDateAboveThreshold := TrendRows[j].Calendar;
            end;
          end;
        end;

        message := message + ': Nilai tertinggi ' + FormatFloat('0.##', maxVal) + ' pada tanggal ' + DateToStr(maxValDate) + '.';
        Memo1.Lines.Add(message);
        if firstDateAboveThreshold <> 0 then
        begin
          message := 'Terjadi dari tanggal ' + DateToStr(firstDateAboveThreshold) + ' sampai ' + DateToStr(lastDateAboveThreshold) + '.';
          Memo1.Lines.Add(message);
        end;
      end;
    end;
  end
  else
  begin
      Chart1.LeftAxis.Title.Caption := '';
      Memo1.Visible := False;
  end;
end;

// Mengelola info
procedure TVHMStrend.Chart1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  pitchX: Double;
  lebarXchart: Integer;
  Xpos: Integer;
  i: Integer;
  R: TRect;
  xScreen, Yscreen: Integer;
  Xmin, Xmax, Ymin, Ymax: Integer;
  XminLast, YminLast, XmaxLast, YmaxLast: Integer;

begin
  if Chart1.SeriesCount = 0 then exit; // agar tidak eror saat tidak ada item yg dipilih

  R := Chart1.ChartRect;
  if PtInRect(R, Point(X, Y)) then // agar eksekusi hanya jika mouse berada di dalam area chart
  begin
    DataUnit.Show;
    DataUnit.Memo1.Clear;
    lebarXchart := Chart1.BottomAxis.IEndPos - Chart1.BottomAxis.IStartPos;

    pitchX := lebarXchart / Xcount;

    Xpos := Round((X - Chart1.BottomAxis.IStartPos) / pitchX);

    if Xpos = 1 then
      Xpos := Xpos - 1;
    if Xpos >= 1 then
        Xpos := Xpos - 1;

    DataUnit.Memo1.Lines.Add(selectedKode + ' Model: ' + selectedModel);
    DataUnit.Memo1.Lines.Add('SN UNIT: ' + selectedSerial);
    DataUnit.Memo1.Lines.Add('Engine SN 1, 2, 3: ' + EGSerial[1] + ', ' + EGSerial[2] + ', ' + EGSerial[3]);
    DataUnit.Memo1.Lines.Add('HM: ' + SelectedHM[Xpos]);
    DataUnit.Memo1.Lines.Add('Tanggal: ' + selectedCalendar[Xpos]);
    DataUnit.Memo1.Lines.Add('');

    if Chart1.SeriesCount = 0 then exit;
    if Ycount = 1 then
      DataUnit.Memo1.Lines.Add(Chart1.Series[0].Title + ': ' + FloatToStr(Chart1.Series[0].YValue[Xpos]) + ' ' + selectedScale[0])
      else
        for i:= 0 to Chart1.SeriesCount - 1 do
          DataUnit.Memo1.Lines.Add(Chart1.Series[i].Title + ': ' + FloatToStr(Chart1.Series[i].YValue[Xpos]) + ' ' + selectedScale[i]);

    // DataUnit.Memo1.lines.Add('Xmouse ' + IntToStr(X));
    // DataUnit.Memo1.lines.Add('Pitch ' + FloatToStr(pitchX));
    // DataUnit.Memo1.lines.Add('X - star ' + IntToStr(X - Chart1.BottomAxis.IStartPos));
    // DataUnit.Memo1.lines.Add('Xpos ' + IntToStr(Xpos));

    // DataUnit.Memo1.lines.Add('Ymouse ' + IntToStr(Y));
    // DataUnit.Memo1.lines.Add('Y - star ' + IntToStr(Y - Chart1.LeftAxis.IStartPos));

    // DataUnit.Memo1.lines.Add('Scoun' + FloatToStr(Chart1.SeriesCount));

    // Ytitik := Series1.YValue[0];
    // DataUnit.Memo1.lines.Add('Ytitik' + FloatToStr(Ytitik));

    // for i := 0 to Chart1.SeriesCount - 1 do
    // begin
    //   for Ypos := Chart1.LeftAxis.IStartPos to Chart1.LeftAxis.IEndPos do
    //   begin
    //     ValueIndex := Chart1.Series[i].Clicked(Xpos, Ypos);
    //     if ValueIndex = -1 then
    //       DataUnit.Memo1.lines.Add('Ypos ' + IntToStr(Ypos));
    //   end;
    // end;

    xScreen := Series1.CalcXPos(Xpos);
    Yscreen := Series1.CalcYPos(Xpos);

    Xmin := xScreen - 5;
    Xmax := Xmin + 10;
    Ymin := Chart1.LeftAxis.IStartPos;
    Ymax := Chart1.LeftAxis.IEndPos;

    SavedArea := TBitmap.Create;

    // menempelkan
    SavedArea.Canvas.CopyRect(Rect(Xmin, Ymin, Xmax, Ymax), SavedArea.Canvas, Point(0, 0));
    SavedArea.Free;

    //menyalin
    SavedArea.Canvas.CopyRect(React(0, 0, 10, Chart1.LeftAxis.IEndPos - Chart1.LeftAxis.IStartPos), Chart1.Canvas, Point(Xmin, Ymin));
    XminLast := Xmin;
    YminLast := Ymin;
    XmaxLast := Xmax;
    YmaxLast := Ymax;

    

    //Chart1.Canvas.ClipRectangle();

    Chart1.Canvas.Brush.Color := clBlue;
    Chart1.Canvas.Rectangle(Xmin, Ymin, Xmax, Ymax);



    Chart1.Canvas.Brush.Color := clGreen;
    Chart1.Canvas.Ellipse(Xscreen - 4, Yscreen - 4, Xscreen + 4, Yscreen + 4);
  end;
end;

end.
