unit AddUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, Common, ShellAPI;

type
  TAddForm = class(TForm)
    AddPanel: TPanel;
    Btn_AddOK: TSpeedButton;
    Btn_Cancel: TSpeedButton;
    Label1: TLabel;
    Label3: TLabel;
    LocList_Box: TGroupBox;
    LB_LocList: TListBox;
    Drag_Box: TGroupBox;
    Img_Icon: TImage;
    File_Type: TLabel;
    File_Notice: TLabel;
    Drag_LinkName: TEdit;
    ED_Hint: TEdit;
    ED_Name: TEdit;
    ExeGroup: TGroupBox;
    Label4: TLabel;
    Exe_ChoiceFile: TSpeedButton;
    ED_ExeName: TEdit;
    DefaultGroup: TGroupBox;
    Label2: TLabel;
    Btn_ChoiceFile: TSpeedButton;
    ED_LinkName: TEdit;
    OpenDialog1: TOpenDialog;
    OpenDialog2: TOpenDialog;
    Type_Box: TGroupBox;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    RB_Type0: TRadioButton;
    RB_Type1: TRadioButton;
    RB_Type2: TRadioButton;
    RB_Type3: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure Btn_CancelClick(Sender: TObject);
    procedure RB_TypeClick(Sender: TObject);
    procedure Btn_ChoiceFileClick(Sender: TObject);
    procedure Btn_AddOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure Exe_ChoiceFileClick(Sender: TObject);
  private
    { Private declarations }
    procedure WMDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;
  public
    { Public declarations }


    IS_OK: Boolean;

  public
    procedure CheckInput(Ed: TEdit; Msg: string);
    procedure ClearFields;
  end;
var
  AddForm: TAddForm;

  procedure GetFileSysInfo(FileName: string; var FileInfo: TSHFileInfo);
  procedure GetExtNameFromSystemIcon(Ext: string; icon: TIcon);


implementation

{$R *.dfm}

procedure TAddForm.ClearFields;
begin
  ED_LinkName.Clear;
  ED_Hint.Clear;
  ED_Name.Clear;
  ED_ExeName.Clear;
end;

procedure TAddForm.CheckInput(Ed: TEdit; Msg: string);
begin
  if Trim(Ed.Text) = '' then raise Exception.Create(Msg);
end;

procedure TAddForm.Btn_AddOKClick(Sender: TObject);
begin
  try
    CheckInput(ED_Name, '이름을 입력하세요.');
    CheckInput(ED_LinkName, '경로를 지정하세요.');
    CheckInput(ED_Hint, '도움말을 입력하세요.');

    if LB_LocList.ItemIndex = -1 then raise Exception.Create('위치를 선택 하세요');

    IS_OK := True;
  except
    on E:Exception do
    begin
      ShowMessage(E.Message);
      Exit;
    end;
  end;

  Close;
end;

procedure TAddForm.Btn_CancelClick(Sender: TObject);
begin
  IS_OK := False;
  ClearFields;
  Close;
end;

procedure TAddForm.RB_TypeClick(Sender: TObject);
var
  p                       : TRadioButton;
begin
  p                       := Sender as TRadioButton;
  Btn_ChoiceFile.Visible  := True;
  ExeGroup.Visible        := False;
  if p.Name               = 'RB_Type3' then ExeGroup.Visible := True
  else if p.Name          = 'RB_Type1' then Btn_ChoiceFile.Visible := False;
end;

procedure TAddForm.Btn_ChoiceFileClick(Sender: TObject);
var
  Dir : string;
begin
  if RB_Type2.Checked and not RB_Type0.Checked then
  begin
    Dir              := BrowseFolder(Handle, '폴더를 선택하세요.', '');
    if not DirectoryExists(Dir) or (Dir = '') then Exit;
    if Length(Dir) = 3 then SetLength(Dir, 2);
    ED_LinkName.Text := Dir;
  end
  else if OpenDialog1.Execute then
    ED_LinkName.Text := OpenDialog1.FileName;
end;

procedure TAddForm.FormCreate(Sender: TObject);
const
  disigne_width  = 1900; // 개발당시 해상도
  disigne_height = 1200;
begin
  if Screen.Width <= 1280 then // 특정 해상도 이하이면.
  begin
    Scaled := True;
    Height := Height * Screen.Height div disigne_height;
    Width  := Width * Screen.Width div disigne_width;
    ScaleBy(Screen.Width, disigne_width);
  end;
end;

procedure TAddForm.FormShow(Sender: TObject);
begin
  IS_OK := False;
end;

procedure TAddForm.WMDropFiles(var msg: TWMDropFiles);
var
  filename    : array[0..MAX_PATH] of Char;
  fileCount   : UINT;
  icon        : TIcon;
  FileInfo    : TSHFileInfo;
  i: UINT;
begin
  fileCount                 := DragQueryFile(msg.Drop, $FFFFFFFF, nil, 0);

  for i := 0 to fileCount - 1 do
  begin
    DragQueryFile(msg.Drop, i, filename, MAX_PATH);
    Drag_LinkName.Visible   := True;
    File_Type.Visible       := True;
    Drag_LinkName.Text      := filename;
    ED_LinkName.Text        := filename;
    File_Notice.Visible     := False;

    icon := TIcon.Create;
    try
      GetExtNameFromSystemIcon(ExtractFileExt(filename), icon);
      Img_Icon.Picture.Icon := icon;
      GetFileSysInfo(Drag_LinkName.Text, FileInfo);
      Drag_LinkName.Text    := FileInfo.szTypeName;
    finally
      icon.Free;
    end;
  end;
  DragFinish(msg.Drop);
end;

procedure GetFileSysInfo(FileName: string; var FileInfo: TSHFileInfo);
begin
  SHGetFileInfo(PChar(FileName), 0, FileInfo, SizeOf(FileInfo), SHGFI_USEFILEATTRIBUTES or SHGFI_TYPENAME);
end;

procedure GetExtNameFromSystemIcon(Ext: string; icon: TIcon);
var
  IconInfo: TSHFileInfo;
begin
  SHGetFileInfo(PChar(Ext), 0, IconInfo, SizeOf(IconInfo), SHGFI_USEFILEATTRIBUTES or SHGFI_ICON);
  icon.Handle := IconInfo.hIcon;
end;

procedure TAddForm.Exe_ChoiceFileClick(Sender: TObject);
begin
  if not OpenDialog2.Execute then Exit;
  ED_ExeName.Text := OpenDialog2.FileName;
end;

end.
