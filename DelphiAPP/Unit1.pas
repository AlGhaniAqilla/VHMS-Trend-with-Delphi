unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, TeeProcs, TeEngine, Chart,
  CheckLst;

type
  TVHMStrend = class(TForm)
    modelUnit: TComboBox;
    Label1: TLabel;
    generate: TButton;
    cekChart: TCheckListBox;
    Chart1: TChart;
    wktDari: TDateTimePicker;
    wktHingga: TDateTimePicker;
    editList: TButton;
    Label2: TLabel;
    Memo1: TMemo;
    serialUnit: TComboBox;
    procedure editListClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  VHMStrend: TVHMStrend;

implementation

uses Unit2;

{$R *.dfm}

procedure TVHMStrend.editListClick(Sender: TObject);
begin
  listUnit.ShowModal
end;

end.
