program Rogein;

uses
  Forms,
  UMainForm in 'UMainForm.pas' {FMain},
  UCommand in 'UCommand.pas',
  UAddSplit in 'UAddSplit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.Run;
end.
