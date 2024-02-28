program MarkDelphi;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  Common in 'Common.pas',
  SetupUnit in 'SetupUnit.pas' {SetupForm},
  AddUnit in 'AddUnit.pas' {AddForm},
  Vcl.Themes,
  Vcl.Styles,
  Unit1 in 'Unit1.pas' {Form1},
  RenameUnit in 'RenameUnit.pas' {RenameForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Sienna Green Light LB');
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TSetupForm, SetupForm);
  Application.CreateForm(TAddForm, AddForm);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TRenameForm, RenameForm);
  Application.Run;
end.
