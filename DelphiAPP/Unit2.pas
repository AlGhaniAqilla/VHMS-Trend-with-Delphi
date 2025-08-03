unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, StrUtils, ComCtrls;

type
  TUnitRecord = record
    Model: string;
    Serial: string;
    Kode: string;
  end;

  TlistUnit = class(TForm)
    inputModel: TEdit;
    inputSerial: TEdit;
    inputKode: TEdit;
    tambahBtn: TButton;
    delBtn: TButton;
    modelUnit: TComboBox;
    ListBox1: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure modelUnitChange(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure delBtnClick(Sender: TObject);
    procedure tambahBtnClick(Sender: TObject);
  private
    procedure UpdateListBox;
    procedure SortUnitList;
    procedure SortStringListByKode(sl: TStringList);
  public
  end;

var
  listUnit: TlistUnit;
  UnitList: array of TUnitRecord;

implementation

{$R *.dfm}

procedure TlistUnit.SortUnitList;
var
  i, j: Integer;
  temp: TUnitRecord;
begin
  for i := Low(UnitList) to High(UnitList) - 1 do
    for j := i + 1 to High(UnitList) do
      if UnitList[i].Kode > UnitList[j].Kode then
      begin
        temp := UnitList[i];
        UnitList[i] := UnitList[j];
        UnitList[j] := temp;
      end;
end;

procedure TlistUnit.SortStringListByKode(sl: TStringList);
var
  i, j: Integer;
  temp: string;
  kodeI, kodeJ: string;
begin
  // Mulai dari 1 agar header tetap di atas
  for i := 1 to sl.Count - 2 do
    for j := i + 1 to sl.Count - 1 do
    begin
      kodeI := '';
      kodeJ := '';
      if Pos(',', sl[i]) > 0 then
        kodeI := Trim(Copy(sl[i], LastDelimiter(',', sl[i]) + 1, MaxInt));
      if Pos(',', sl[j]) > 0 then
        kodeJ := Trim(Copy(sl[j], LastDelimiter(',', sl[j]) + 1, MaxInt));
      if kodeI > kodeJ then
      begin
        temp := sl[i];
        sl[i] := sl[j];
        sl[j] := temp;
      end;
    end;
end;

procedure TlistUnit.FormCreate(Sender: TObject);
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
    // Lewati header, mulai dari indeks 1
    dataCount :=  sl.Count - 1;
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
    UpdateListBox;
  finally
    sl.Free;
    fields.Free;
    modelSet.Free;
  end;
end;

procedure TlistUnit.modelUnitChange(Sender: TObject);
begin
  UpdateListBox;
end;

procedure TlistUnit.UpdateListBox;
var
  i, no: Integer;
  selectedModel: string;
begin
  ListBox1.Items.Clear;
  selectedModel := modelUnit.Text;
  no := 1;
  for i := 0 to High(UnitList) do
    if UnitList[i].Model = selectedModel then
    begin
      ListBox1.Items.Add(IntToStr(no) + '. ' + UnitList[i].Kode + ' / ' + UnitList[i].Serial);
      Inc(no);
    end;
end;

procedure TlistUnit.ListBox1DblClick(Sender: TObject);
var
  idx, i: Integer;
  selectedModel: string;
  count: Integer;
begin
  idx := ListBox1.ItemIndex;
  if idx = -1 then Exit;

  selectedModel := modelUnit.Text;
  count := -1;
  for i := 0 to High(UnitList) do
    if UnitList[i].Model = selectedModel then
    begin
      Inc(count);
      if count = idx then
      begin
        inputModel.Text := UnitList[i].Model;
        inputKode.Text := UnitList[i].Kode;
        inputSerial.Text := UnitList[i].Serial;
        Break;
      end;
    end;
end;

procedure TlistUnit.delBtnClick(Sender: TObject);
var
  sl: TStringList;
  i: Integer;
  foundIdx: Integer;
  fields: TStringList;
  prevIndex: Integer;
begin
  prevIndex := modelUnit.ItemIndex; // simpan posisi sebelumnya
  foundIdx := -1;
  sl := TStringList.Create;
  fields := TStringList.Create;
  try
    if FileExists('List\listUnit.csv') then
      sl.LoadFromFile('List\listUnit.csv');
    for i := 1 to sl.Count - 1 do
    begin
      fields.CommaText := sl[i];
      if (fields.Count >= 3) and
         (fields[0] = inputModel.Text) and
         (fields[1] = inputKode.Text) and
         (fields[2] = inputSerial.Text) then
      begin
        foundIdx := i;
        Break;
      end;
    end;
    if foundIdx <> -1 then
    begin
      sl.Delete(foundIdx);
      SortStringListByKode(sl);
      sl.SaveToFile('List\listUnit.csv');
      FormCreate(nil);
      // kembalikan posisi ComboBox
      if (prevIndex >= 0) and (prevIndex < modelUnit.Items.Count) then
        modelUnit.ItemIndex := prevIndex;
      UpdateListBox;
    end
    else
      ShowMessage('Data tidak ada!');
  finally
    sl.Free;
    fields.Free;
  end;
end;

procedure TlistUnit.tambahBtnClick(Sender: TObject);
var
  sl: TStringList;
  newLine: string;
  i: Integer;
  fields: TStringList;
  exists, kodeDuplikat: Boolean;
  prevIndex: Integer;
begin
  prevIndex := modelUnit.ItemIndex; // simpan posisi sebelumnya
  sl := TStringList.Create;
  fields := TStringList.Create;
  exists := False;
  kodeDuplikat := False;
  try
    if FileExists('List\listUnit.csv') then
      sl.LoadFromFile('List\listUnit.csv');
    for i := 1 to sl.Count - 1 do
    begin
      fields.CommaText := sl[i];
      if (fields.Count >= 3) then
      begin
        if (fields[0] = inputModel.Text) and
           (fields[1] = inputKode.Text) and
           (fields[2] = inputSerial.Text) then
        begin
          exists := True;
          Break;
        end;
        if (fields[1] = inputKode.Text) and
           ((fields[0] <> inputModel.Text) or (fields[2] <> inputSerial.Text)) then
        begin
          kodeDuplikat := True;
        end;
      end;
    end;
    if exists then
      ShowMessage('Data sudah ada!')
    else if kodeDuplikat then
      ShowMessage('Kode UNIT sudah ada dengan data berbeda!')
    else
    begin
      newLine := inputModel.Text + ',' + inputKode.Text + ',' + inputSerial.Text;
      sl.Add(newLine);
      SortStringListByKode(sl);
      sl.SaveToFile('List\listUnit.csv');
      FormCreate(nil);
      // kembalikan posisi ComboBox
      if (prevIndex >= 0) and (prevIndex < modelUnit.Items.Count) then
        modelUnit.ItemIndex := prevIndex;
      UpdateListBox;
    end;
  finally
    sl.Free;
    fields.Free;
  end;
end;

end.
