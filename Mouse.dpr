program Mouse;

uses
  Vcl.Forms,
  MouseUnit in 'MouseUnit.pas' {MouseForm},
  TThreadA in 'TThreadA.pas',
  TThreadB in 'TThreadB.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMouseForm, MouseForm);
  Application.Run;
end.
