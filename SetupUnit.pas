unit SetupUnit;

interface

uses
  Common, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Buttons ,System.IniFiles, Vcl.Mask, Vcl.Imaging.pngimage, AddUnit;

type
  TSetupForm = class(TForm)
    OpenDialog1: TOpenDialog;
    OpenDialog2: TOpenDialog;
    Btn_Save: TSpeedButton;
    Btn_Insert: TSpeedButton;
    Btn_Del: TSpeedButton;
    LB_BtnList: TListBox;
    Btn_Change: TSpeedButton;
    Ltn_List_Change: TSpeedButton;
    LB_LocList: TListBox;
    GroupBox5: TGroupBox;
    TrackBar1: TTrackBar;
    Btn_ChoiceFile: TSpeedButton;
    Exe_ChoiceFile: TSpeedButton;
    Type_Box: TGroupBox;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    RB_Type0: TRadioButton;
    RB_Type1: TRadioButton;
    RB_Type2: TRadioButton;
    RB_Type3: TRadioButton;
    StyleList: TListBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    RegStart: TCheckBox;
    HotKey: TCheckBox;
    Panel4: TPanel;
    Panel8: TPanel;
    Label5: TLabel;
    Panel9: TPanel;
    ED_Hint: TLabeledEdit;
    ED_Name: TLabeledEdit;
    ED_LinkName: TLabeledEdit;
    ED_ExeName: TLabeledEdit;
    Label1: TLabel;
    Panel10: TPanel;
    Label2: TLabel;
    Menu_pn: TPanel;
    Image6: TImage;
    Label4: TLabel;
    Label6: TLabel;
    Image8: TImage;
    Label8: TLabel;
    Image9: TImage;
    Label9: TLabel;
    Image10: TImage;
    Label10: TLabel;
    procedure FormShow(Sender: TObject);
    procedure Btn_CloseClick(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure ChangeLabelOnMouseEnter(Sender: TObject);
    procedure ChangeLabelOnMouseLeave(Sender: TObject);
    procedure FormCreate(Sender: TObject);

    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Btn_InsertClick(Sender: TObject);


  private
    { Private declarations }
  public
    { Public declarations }
    GB_CapList  : TStringList;
    ini         : TIniFile;
    IS_OK       : Boolean;

  public
    procedure ChangeLabel;
    function CreateButtonItem: TButtonItem;
    function GetType(SetupAddForm: TAddForm): Integer;
    procedure WriteToIni(Item: TButtonItem);

  end;

var
  SetupForm: TSetupForm;

implementation

{$R *.dfm}

procedure TSetupForm.Btn_CloseClick(Sender: TObject);
begin
  close;
end;

procedure TSetupForm.ChangeLabelOnMouseEnter(Sender: TObject);
begin
  TLabel(Sender).Font.Color := $000080FF;
  TLabel(Sender).Font.Style := [fsBold];
end;

procedure TSetupForm.ChangeLabelOnMouseLeave(Sender: TObject);
begin
  TLabel(Sender).Font.Color := clWhite;
  TLabel(Sender).Font.Style := [];
end;


procedure TSetupForm.FormCreate(Sender: TObject);
var
  c: Integer;
begin
  ChangeLabel;
(*
    for c := 0 to PageControl1.PageCount - 1 do
    begin
      self.PageControl1.Pages[c].TabVisible := False;
    end;
    self.PageControl1.ActivePageIndex := 0;
*)
end;

procedure TSetupForm.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const
  sc_DragMove = $F012;
begin
  ReleaseCapture;
  Perform(wm_SysCommand, sc_DragMove, 0);
end;

procedure TSetupForm.ChangeLabel;
var
  i: Integer;
  labelName: String;
begin
  for i := 0 to ComponentCount - 1 do
  begin
    if Components[i] is TLabel then
    begin
      labelName := TLabel(Components[i]).Name;
      if (labelName = 'Label4') or (labelName = 'Label6') or
         (labelName = 'Label8') or (labelName = 'Label9') or
         (labelName = 'Label6') or (labelName = 'Label10') then
      begin
        TLabel(Components[i]).OnMouseEnter := ChangeLabelOnMouseEnter;
        TLabel(Components[i]).OnMouseLeave := ChangeLabelOnMouseLeave;
      end;
    end;
  end;
end;

procedure TSetupForm.FormShow(Sender: TObject);
var
  i                       : Integer;
  secname, hint, lnk, exe : string;
  itype, loc           : Integer;
  List                    : TStringList;
  Item                    : TButtonItem;
begin
  // ������ �о�� üũ�ڽ� ���¸� ����
  RegStart.Checked        := ini.ReadBool(SETUP_SEC_STR, 'WriteReg', False);
  HotKey.Checked          := ini.ReadBool(SETUP_SEC_STR, 'WriteHotKey', False);

  // TStringList �ν��Ͻ� ����
  List                    := TStringList.Create;
  try
    // .ini ������ ���� �̸��� ��� �о List�� ����
    ini.ReadSections(List);

    // ��ư ����Ʈ�� �ʱ�ȭ�ϰ� ������Ʈ�� ����
    LB_BtnList.Items.Clear;
    LB_BtnList.Items.BeginUpdate;

    // �� ���ǿ� ���� ó��
    for i := 0 to List.Count - 1 do
    begin
      secname             := List.Strings[i]; // ���� �̸�

      // SETUP_SEC_STR�� ó������ ����
      if secname = SETUP_SEC_STR then Continue;

      // �� Ű�� ���� ����
      hint                := ini.ReadString(secname, HINT_STR, '');
      lnk                 := ini.ReadString(secname, LINK_STR, '');
      exe                 := ini.ReadString(secname, EXE_STR, '');
      itype               := ini.ReadInteger(secname, TYPE_STR, -1);
      loc                 := ini.ReadInteger(secname, LOC_STR, -1);

      // Ű�� ���� ��� �� ���ڿ��̰ų� -1�� ���� ����
      if (hint = '') and (lnk = '') and (exe = '') and (itype = -1) and (loc = -1) then Continue;

      // ���ο� TButtonItem �ν��Ͻ��� �����ϰ� ������ ���� �Ҵ�
      Item                := TButtonItem.Create;
      Item.Caption        := secname;
      Item.Hint           := hint;
      Item.Link           := lnk;
      Item.Exe            := exe;
      Item.iType          := itype;
      Item.Loc            := loc;
      Item.Idx            := i;

      // ������ �������� ��ư ����Ʈ�� �߰�
      LB_BtnList.Items.AddObject(Item.Caption, Item);
    end;

    // ��ư ����Ʈ�� ������Ʈ�� ����
    LB_BtnList.Items.EndUpdate;

    // IS_OK �÷��׸� false�� ����
    IS_OK := False;
  finally
    List.Free;
  end;
end;

procedure TSetupForm.Btn_InsertClick(Sender: TObject);
var
  Item : TButtonItem;
  i    : Integer;
begin
  AddForm.LB_LocList.Items.Text := GB_CapList.Text;
  if AddForm.ShowModal = mrOK then
  begin
    Item := CreateButtonItem;
    LB_BtnList.Items.AddObject(Item.Caption, Item);
  end;

  for i := 0 to LB_BtnList.Items.Count - 1 do
  begin
    Item := TButtonItem(LB_BtnList.Items.Objects[i]);
    WriteToIni(Item);
  end;
end;

function TSetupForm.CreateButtonItem: TButtonItem;
begin
  Result            := TButtonItem.Create;
  try
    Result.Caption  := AddForm.ED_Name.Text;
    Result.Hint     := AddForm.ED_Hint.Text;
    Result.Link     := AddForm.ED_LinkName.Text;
    Result.Exe      := AddForm.ED_ExeName.Text;
    Result.iType    := GetType(AddForm);
    Result.Loc      := AddForm.LB_LocList.ItemIndex;
    Result.Idx      := 0;
  except
    Result.Free;
    raise;
  end;
end;

function TSetupForm.GetType(SetupAddForm: TAddForm): Integer;
begin
  if AddForm.RB_Type0.Checked then Result := 0
  else if SetupAddForm.RB_Type1.Checked then Result := 1
  else if SetupAddForm.RB_Type2.Checked then Result := 2
  else if SetupAddForm.RB_Type3.Checked then Result := 3
  else Result := -1;
end;


procedure TSetupForm.WriteToIni(Item: TButtonItem);
begin
  ini.WriteString(Item.Caption, HINT_STR, Item.Hint);
  ini.WriteString(Item.Caption, LINK_STR, Item.Link);
  ini.WriteString(Item.Caption, EXE_STR, Item.Exe);
  ini.WriteInteger(Item.Caption, TYPE_STR, Item.iType);
  ini.WriteInteger(Item.Caption, LOC_STR, Item.Loc);
end;



procedure TSetupForm.SpeedButton3Click(Sender: TObject);
begin
close;
end;

end.
