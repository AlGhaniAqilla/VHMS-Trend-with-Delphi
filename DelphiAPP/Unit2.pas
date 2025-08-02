unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TlistUnit = class(TForm)
    saveBtn: TButton;
    inputModelUnit: TEdit;
    inputSerialUnit: TEdit;
    tambahBtn: TButton;
    typeUnitComBox: TComboBox;
    ListBox1: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  listUnit: TlistUnit;

implementation

{$R *.dfm}

end.
