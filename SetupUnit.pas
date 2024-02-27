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

    procedure ChangeLabelOnMouseEnter(Sender: TObject);
    procedure ChangeLabelOnMouseLeave(Sender: TObject);
    procedure FormCreate(Sender: TObject);

    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Btn_InsertClick(Sender: TObject);
    procedure Btn_DelClick(Sender: TObject);
    procedure LB_BtnListClick(Sender: TObject);
    procedure RB_TypeClick(Sender: TObject);


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
    procedure AssignItemToForm(Item: TButtonItem);
    procedure CheckRadioButton(ItemType: Integer);
    procedure ClearAllEditText;
  end;

var
  SetupForm: TSetupForm;

implementation

{$R *.dfm}


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
  // 설정을 읽어와 체크박스 상태를 설정
  RegStart.Checked        := ini.ReadBool(SETUP_SEC_STR, 'WriteReg', False);
  HotKey.Checked          := ini.ReadBool(SETUP_SEC_STR, 'WriteHotKey', False);

  // TStringList 인스턴스 생성
  List                    := TStringList.Create;
  try
    // .ini 파일의 섹션 이름을 모두 읽어서 List에 저장
    ini.ReadSections(List);

    // 버튼 리스트를 초기화하고 업데이트를 시작
    LB_BtnList.Items.Clear;
    LB_BtnList.Items.BeginUpdate;

    // 각 섹션에 대해 처리
    for i := 0 to List.Count - 1 do
    begin
      secname             := List.Strings[i]; // 섹션 이름

      // SETUP_SEC_STR은 처리하지 않음
      if secname = SETUP_SEC_STR then Continue;

      // 각 키의 값을 읽음
      hint                := ini.ReadString(secname, HINT_STR, '');
      lnk                 := ini.ReadString(secname, LINK_STR, '');
      exe                 := ini.ReadString(secname, EXE_STR, '');
      itype               := ini.ReadInteger(secname, TYPE_STR, -1);
      loc                 := ini.ReadInteger(secname, LOC_STR, -1);

      // 키의 값이 모두 빈 문자열이거나 -1인 경우는 무시
      if (hint = '') and (lnk = '') and (exe = '') and (itype = -1) and (loc = -1) then Continue;

      // 새로운 TButtonItem 인스턴스를 생성하고 설정한 값을 할당
      Item                := TButtonItem.Create;
      Item.Caption        := secname;
      Item.Hint           := hint;
      Item.Link           := lnk;
      Item.Exe            := exe;
      Item.iType          := itype;
      Item.Loc            := loc;
      Item.Idx            := i;

      // 생성된 아이템을 버튼 리스트에 추가
      LB_BtnList.Items.AddObject(Item.Caption, Item);
    end;

    // 버튼 리스트의 업데이트를 종료
    LB_BtnList.Items.EndUpdate;

    // IS_OK 플래그를 false로 설정
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

procedure TSetupForm.LB_BtnListClick(Sender: TObject);
var
  Item : TButtonItem;
begin
  if LB_BtnList.ItemIndex = -1 then Exit;

  Item := TButtonItem(LB_BtnList.Items.Objects[LB_BtnList.ItemIndex]);
  AssignItemToForm(Item);
end;

procedure TSetupForm.RB_TypeClick(Sender: TObject);
begin
  Btn_ChoiceFile.Visible := not SameText((Sender as TRadioButton).Name, 'RB_Type1');
 // ExeGroup.Visible := SameText((Sender as TRadioButton).Name, 'RB_Type3');
end;

procedure TSetupForm.AssignItemToForm(Item: TButtonItem);
begin
  ED_Name.Text          := Item.Caption;
  ED_Hint.Text          := Item.Hint;
  ED_LinkName.Text      := Item.Link;
  ED_ExeName.Text       := Item.Exe;
  LB_LocList.ItemIndex  := Item.Loc;
  CheckRadioButton(Item.iType);
end;

procedure TSetupForm.CheckRadioButton(ItemType: Integer);
begin
  case ItemType of
    0: RB_Type0.Checked   := True;
    1: RB_Type1.Checked   := True;
    2: RB_Type2.Checked   := True;
    3: RB_Type3.Checked   := True;
    else RB_Type0.Checked := True;
  end;
end;

procedure TSetupForm.Btn_DelClick(Sender: TObject);
var
  Item: TButtonItem;
begin
  if LB_BtnList.ItemIndex = -1 then Exit;

  Item := TButtonItem(LB_BtnList.Items.Objects[LB_BtnList.ItemIndex]);
  ini.EraseSection(Item.Caption);
  LB_BtnList.Items.Delete(LB_BtnList.ItemIndex);
end;

procedure TSetupForm.Btn_CloseClick(Sender: TObject);
var
  Item : TButtonItem;
  idx  : Integer;
begin
  ini.WriteBool(SETUP_SEC_STR, 'WriteReg', RegStart.Checked);
  ini.WriteBool(SETUP_SEC_STR, 'WriteHotKey', HotKey.Checked);

  // If there is a selected item in the list box, delete it
{
    idx := LB_BtnList.ItemIndex;
    if idx <> -1 then
    begin
      Item := TButtonItem(LB_BtnList.Items.Objects[idx]);
      ini.EraseSection(Item.Caption);
      LB_BtnList.Items.Delete(idx);
      LB_BtnList.ItemIndex := -1;
    end;
}
  ClearAllEditText;
  Close;
end;

procedure TSetupForm.ClearAllEditText;
var
  Edits : array[1..4] of TLabeledEdit;
  I     : Integer;
begin
  Edits[1] := ED_LinkName;
  Edits[2] := ED_Hint;
  Edits[3] := ED_Name;
  Edits[4] := ED_ExeName;

  for I := 1 to 4 do Edits[I].Clear;
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


end.
