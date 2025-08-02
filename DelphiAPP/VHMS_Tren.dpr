program VHMS_Tren;

uses
  Forms,
  Unit1 in 'Unit1.pas' {VHMStrend},
  Unit2 in 'Unit2.pas' {listUnit};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TVHMStrend, VHMStrend);
  Application.CreateForm(TlistUnit, listUnit);
  Application.Run;
end.
