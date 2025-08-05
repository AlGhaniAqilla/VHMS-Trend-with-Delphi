unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, TeeProcs, TeEngine, Chart,
  CheckLst, Series, DateUtils;

type
  TVHMStrend = class(TForm)
    modelUnit: TComboBox;
    serialUnit: TComboBox;
    generate: TButton;
    cekChart: TCheckListBox;
    Chart1: TChart;
    wktDari: TDateTimePicker;
    wktHingga: TDateTimePicker;
    editList: TButton;
    Label1: TLabel;
    Label2: TLabel;
    unCek: TButton;
    ListBox1: TListBox;
    Series1: TLineSeries;

    procedure editListClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure modelUnitChange(Sender: TObject);
    procedure generateClick(Sender: TObject);
    procedure cekChartClick(Sender: TObject);
    procedure unCekClick(Sender: TObject);
    procedure Chart1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Chart1ClickLegend(Sender: TCustomChart; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    procedure UpdateListUnit;
    procedure UpdateChart;
  public
  end;

type
  TTrendRow = record
    Calendar: TDateTime;
    Values: array of Double;
  end;

var
  VHMStrend: TVHMStrend;
  AxisItems: TStringList;
  HM: TStringList;
  TrendRows: array of TTrendRow;
  UnitList: array of record
    Model: string;
    Serial: string;
    Kode: string;
  end;

implementation

uses Unit2;

{$R *.dfm}

procedure TVHMStrend.editListClick(Sender: TObject);
begin
  listUnit.ShowModal
end;

procedure TVHMStrend.FormCreate(Sender: TObject);
var
  sl: TStringList;
  i: Integer;
  fields: TStringList;
  modelSet: TStringList;
  dataCount: Integer;
begin
  sl := TStringList.Create;
  fields := TStringList.Create;
  modelSet := TStringList.Create;
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
        if modelSet.IndexOf(fields[0]) = -1 then
          modelSet.Add(fields[0]);
      end;
    end;

    modelUnit.Items.Assign(modelSet);
    if modelUnit.Items.Count > 0 then
      modelUnit.ItemIndex := 0;
    UpdateListUnit;
  finally
    sl.Free;
    fields.Free;
    modelSet.Free;
  end;
end;

procedure TVHMStrend.UpdateListUnit;
var
  i: Integer;
  selectedModel: string;
begin
  serialUnit.Items.Clear;
  selectedModel := modelUnit.Text;
  for i := 0 to High(UnitList) do
    if UnitList[i].Model = selectedModel then
      serialUnit.Items.Add(UnitList[i].Serial + ' / ' + UnitList[i].Kode);
end;

procedure TVHMStrend.modelUnitChange(Sender: TObject);
begin
  serialUnit.Clear;
  UpdateListUnit;
end;

procedure TVHMStrend.generateClick(Sender: TObject);
var
  folderName, serialOnly, modelOnly: string;
  folderPath, subFolderPath, chkFolderPath, csvFilePath: string;
  sr: TSearchRec;
  maxFolder: string;
  found: Boolean;
  lines: TStringList;
  i, j, dataStart: Integer;
  axisLine, dataLine, s: string;
  fields: TStringList;
  epoch, offset: Int64;
  epochStr, offsetStr: string;
  p1, p2: Integer;
begin
  folderName := serialUnit.Text;
  modelOnly := modelUnit.Text;
  if (folderName = '') or (modelOnly = '') then
  begin
    ShowMessage('Pilih model dan unit terlebih dahulu!');
    Exit;
  end;

  serialOnly := Trim(Copy(folderName, 1, Pos(' / ', folderName) - 1));
  folderPath := 'data\' + modelOnly + '\' + serialOnly;

  if not DirectoryExists(folderPath) then
  begin
    ShowMessage('Folder tidak ada: ' + folderPath);
    Exit;
  end;

  maxFolder := '';
  found := False;
  if FindFirst(folderPath + '\*', faDirectory, sr) = 0 then
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
    ShowMessage('Tidak ada subfolder di: ' + folderPath);
    Exit;
  end;

  subFolderPath := folderPath + '\' + maxFolder;
  chkFolderPath := subFolderPath + '\CHK0001';
  csvFilePath := chkFolderPath + '\trend0.CSV';

  if not DirectoryExists(chkFolderPath) then
  begin
    ShowMessage('Folder CHK001 tidak ditemukan di: ' + subFolderPath);
    Exit;
  end;

  if not FileExists(csvFilePath) then
  begin
    ShowMessage('File tren0.CSV tidak ditemukan di: ' + chkFolderPath);
    Exit;
  end;

  // --- Parsing Axis Item untuk cekChart ---
  lines := TStringList.Create;
  lines.LoadFromFile(csvFilePath);

  AxisItems := TStringList.Create;
  try
    for i := 0 to lines.Count - 1 do
    begin
      if Pos('Axis Item', lines[i]) = 1 then
      begin
        axisLine := lines[i];
        axisLine := StringReplace(axisLine, ' ', '', [rfReplaceAll]);
        AxisItems.CommaText := Copy(axisLine, Pos(',', axisLine) + 1, MaxInt);
        Break;
      end;
    end;
    cekChart.Items.Clear;
    for i := 2 to AxisItems.Count - 1 do
      cekChart.Items.Add(AxisItems[i]);
    // Centang default SMR
    for i := 0 to cekChart.Items.Count - 1 do
       if cekChart.Items[i] = 'Eng.OilTmp.MAX' then cekChart.Checked[i] := true
      else if cekChart.Items[i] = 'CoolTemp.MAX' then cekChart.Checked[i] := true
      else if cekChart.Items[i] = 'HydOilTempMax' then cekChart.Checked[i] := true
      else if cekChart.Items[i] = 'HydOilTempAve' then cekChart.Checked[i] := true
      else if cekChart.Items[i] = 'PTOTempMax' then cekChart.Checked[i] := true;
  finally
    AxisItems.Free;
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
  fields := TStringList.Create;
  try
    for i := dataStart to lines.Count - 1 do
    begin
      dataLine := lines[i];
      fields.CommaText := dataLine;
      if fields.Count < 3 then Continue;

      //HM
      ListBox1.Items.Add(fields[1]);

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
          TrendRows[i - dataStart].Values[j] := StrToFloatDef(fields[j + 3], 0)
        else
          TrendRows[i - dataStart].Values[j] := 0;
      end;
    end;
  finally
    fields.Free;
    lines.Free;
  end;

  // ubah tanggal
  wktDari.Date := TrendRows[0].Calendar;
  wktHingga.Date := TrendRows[High(TrendRows)].Calendar;

  // Tampilkan chart awal
  UpdateChart;
  // Memo1.Clear;
  // Memo1.Lines.Add(DateTimeToStr(TrendRows[0].Calendar));
  //Memo1.Lines.Add(fields[0]);
end;

procedure TVHMStrend.cekChartClick(Sender: TObject);
begin
  UpdateChart;
end;

procedure TVHMStrend.UpdateChart;
var
  i, j: Integer;
  series: TLineSeries;
  dari, hingga: TDateTime;
begin
  Chart1.SeriesList.Clear;
  Chart1.BottomAxis.Title.Angle := 45;
  dari := wktDari.Date;
  hingga := wktHingga.Date;
  for i := 0 to cekChart.Items.Count - 1 do
    if cekChart.Checked[i] then
    begin
      series := TLineSeries.Create(Chart1);
      series.Title := cekChart.Items[i];
      Chart1.AddSeries(series);
          
      for j := 0 to High(TrendRows) do
        if (TrendRows[j].Calendar >= dari) and (TrendRows[j].Calendar <= hingga) then
          series.AddXY(j, TrendRows[j].Values[i], DateToStr(TrendRows[j].Calendar));
  end;

end;

procedure TVHMStrend.unCekClick(Sender: TObject);
var
  i: Integer;
  AllCek: Boolean;
begin
  AllCek := False;
  for i:= 0 to cekChart.Items.Count - 1 do
  begin
    if not cekChart.Checked[i] then
    begin
      AllCek := True;
      Break;
    end;
  end;

  if AllCek then
  begin
    for i:= 0 to cekChart.Items.Count - 1 do
    begin
      cekChart.Checked[i] := True;
    end;
    end
    else
    begin
      for i:= 0 to cekChart.Items.Count - 1 do
      begin
       cekChart.Checked[i] := False;
      end;
    end;
end;

procedure TVHMStrend.Chart1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
end;

procedure TVHMStrend.Chart1ClickLegend(Sender: TCustomChart;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ListBox1.Clear;
  ListBox1.Items.Add(IntToStr(X) + ', ' + IntToStr(Y));

end;

end.



