unit NetworkUnit;



interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TNetworkForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Memo1: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }

  public
//
  end;

var
  NetworkForm: TNetworkForm;


implementation

uses
  NetworkControl,
  ComObj, // COM ��ü�� ����ϱ� ���� ����
  ActiveX; // ActiveX ��Ʈ���� ����ϱ� ���� ����


{$R *.dfm}

procedure TNetworkForm.Button1Click(Sender: TObject);
var
  InfoList : TStringList;
begin
  InfoList := TNetworkControl.GetNetworkAdapterInfo;
  try
    Memo1.Lines.Assign(InfoList);
  finally
    InfoList.Free;
  end;
end;



end.