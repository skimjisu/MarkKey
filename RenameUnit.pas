unit RenameUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, Vcl.ExtCtrls, Common;

type
  TRenameForm = class(TForm)
    Panel1: TPanel;
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RenameForm: TRenameForm;

implementation

{$R *.dfm}

procedure TRenameForm.FormShow(Sender: TObject);
begin
  Edit1.Text := Typename;
end;

procedure TRenameForm.SpeedButton1Click(Sender: TObject);
begin
  //
end;

procedure TRenameForm.SpeedButton2Click(Sender: TObject);
begin
  close;
end;

end.
