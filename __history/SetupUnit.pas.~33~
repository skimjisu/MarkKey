unit SetupUnit;

interface

uses
  Common, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Buttons ,System.IniFiles,
  Vcl.Mask, Vcl.Imaging.pngimage, AddUnit, Registry, Vcl.Themes, RenameUnit, Vcl.Menus;

type
  THotKey = record
    ID: Integer;
    Key: Char;
  end;

type
  TRegistryUpdateType = (rutAdd, rutRemove);

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
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    PopupMenu2: TPopupMenu;
    N4: TMenuItem;
    N5: TMenuItem;

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
    procedure Btn_ChoiceFileClick(Sender: TObject);
    procedure Btn_ChangeClick(Sender: TObject);
    procedure RegStartClick(Sender: TObject);
    procedure RegisterADD(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure Exe_ChoiceFileClick(Sender: TObject);
    procedure StyleListClick(Sender: TObject);
    procedure ChangeSkin(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure LB_LocListClick(Sender: TObject);
    procedure LB_LocListDblClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    GB_CapList  : TStringList;
    ini         : TIniFile;
    IS_OK       : Boolean;
    Reg         : Boolean;
	  Key         : Boolean;

  public
    procedure ChangeLabel;
    function CreateButtonItem: TButtonItem;
    function GetType(SetupAddForm: TAddForm): Integer;
    procedure WriteToIni(Item: TButtonItem);
    procedure AssignItemToForm(Item: TButtonItem);
    procedure CheckRadioButton(ItemType: Integer);
    procedure ClearAllEditText;
    function GetSelectedButton: TButtonItem;
    procedure UpdateButtonDetails(Button: TButtonItem);
    procedure UpdateButtonType(Button: TButtonItem);
    procedure UpdateButtonLocIndex(Button: TButtonItem);
    procedure UpdateButtonList(Button: TButtonItem);
    procedure UpdateIniWithButtonDetails(Button: TButtonItem);
    procedure UpdateRegistry(const ValueName: string; const ValueData: string = ''; UpdateType: TRegistryUpdateType = rutAdd);
    procedure UpdateHotKeys(Register: Boolean);

  end;

  const
    DEF_CTRL_Q = $1234;
    DEF_CTRL_W = $1235;
    DEF_CTRL_E = $1236;


var
  SetupForm: TSetupForm;

var
  HotKeys: array of THotKey;

implementation

{$R *.dfm}



{
  모듈명: ChangeLabelOnMouseEnter
  기능: Label 스타일 변경
  작성일: 24.02.28
  파라미터:
    - Sender: 이벤트 발생 레이블 객체
}
procedure TSetupForm.ChangeLabelOnMouseEnter(Sender: TObject);
begin
  TLabel(Sender).Font.Color := $000080FF;
  TLabel(Sender).Font.Style := [fsBold];
end;

{
  모듈명: ChangeLabelOnMouseLeave
  기능: 마우스가 Label을 벗어날 때 스타일 복귀
  작성일: 24.02.28
  파라미터:
    - Sender: 이벤트 발생 레이블 객체
}
procedure TSetupForm.ChangeLabelOnMouseLeave(Sender: TObject);
begin
  TLabel(Sender).Font.Color := clWhite;
  TLabel(Sender).Font.Style := [];
end;


procedure TSetupForm.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  ChangeLabel;

  // 핫키 설정
  SetLength(HotKeys, 3);
  HotKeys[0].ID := DEF_CTRL_Q; HotKeys[0].Key := 'Q';
  HotKeys[1].ID := DEF_CTRL_W; HotKeys[1].Key := 'W';
  HotKeys[2].ID := DEF_CTRL_E; HotKeys[2].Key := 'E';

  Reg := False;
  Key := False;

  // 스타일 목록 추가
  for i := 0 to High(TStyleManager.StyleNames) do StyleList.Items.Add(TStyleManager.StyleNames[i]);
(*  페이지 컨트롤 변경 처리
    for c := 0 to PageControl1.PageCount - 1 do
    begin
      self.PageControl1.Pages[c].TabVisible := False;
    end;
    self.PageControl1.ActivePageIndex := 0;
*)
end;

{
  모듈명: UpdateHotKeys
  기능: 핫키 등록 or 해제
  작성일: 24.02.28
  파라미터:
    - Register: 핫키를 등록할지 또는 해제할지를 결정
}
procedure TSetupForm.UpdateHotKeys(Register: Boolean);
var
  HotKey: THotKey;
begin
  for HotKey in HotKeys do
  begin
    if Register then RegisterHotKey(Handle, HotKey.ID, MOD_CONTROL, Ord(HotKey.Key))
    else UnregisterHotKey(Handle, HotKey.ID);
  end;
end;

procedure TSetupForm.RegisterADD(Sender: TObject);
begin
  if HotKey.Checked then
  begin
    UpdateHotKeys(True);
  end
  else
  begin
    UpdateHotKeys(False);
    ShowMessage('윈도우 실행시 자동실행이 해제되었습니다.');
  end;
end;

procedure TSetupForm.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const
  sc_DragMove = $F012;
begin
  ReleaseCapture;
  Perform(wm_SysCommand, sc_DragMove, 0);
end;

{
  모듈명: ChangeLabel
  기능: 특정 Labeldp 마우스 진입 및 벗어남 이벤트
  작성일: 24.02.28
}
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

procedure TSetupForm.LB_LocListClick(Sender: TObject);
begin
///
end;

procedure TSetupForm.LB_LocListDblClick(Sender: TObject);
var
  i             : Integer;
  SelectedItem  : string;
begin
  if LB_LocList.ItemIndex <> -1 then // 리스트박스에서 아이템이 선택되었는지 확인
  begin
    SelectedItem := LB_LocList.Items[LB_LocList.ItemIndex];
    Typename := SelectedItem;
    RenameForm.ShowModal;
    //ShowMessage(SelectedItem);
  end
  else
    ShowMessage('아이템이 선택되지 않았습니다.'); // 아이템이 선택되지 않았을 경우의 메시지
end;

procedure TSetupForm.N2Click(Sender: TObject);
begin
  LB_LocListDblClick(nil);
end;

procedure TSetupForm.N4Click(Sender: TObject);
begin
  Btn_InsertClick(nil);
end;

procedure TSetupForm.N5Click(Sender: TObject);
begin
  Btn_DelClick(nil);
end;

procedure TSetupForm.RB_TypeClick(Sender: TObject);
begin
  Btn_ChoiceFile.Visible := not SameText((Sender as TRadioButton).Name, 'RB_Type1');
 // ExeGroup.Visible := SameText((Sender as TRadioButton).Name, 'RB_Type3');
end;

procedure TSetupForm.RegStartClick(Sender: TObject);
var
  p  : TCheckBox;
  reg: TRegistry;
begin
  p   := Sender as TCheckBox;
  reg := TRegistry.Create(KEY_WRITE);
  try
    reg.RootKey := HKEY_LOCAL_MACHINE;
    if reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', False) then
    begin
      if p.Checked then reg.WriteString('MarkDelphi', Application.ExeName)
      else
      begin reg.DeleteValue('MarkDelphi');
        ShowMessage('윈도우 실행시 자동실행이 해제되었습니다.');
      end;
    end;
  finally
    reg.CloseKey;
    reg.Free;
  end;
end;

procedure TSetupForm.SpeedButton1Click(Sender: TObject);
begin
//
end;

procedure TSetupForm.StyleListClick(Sender: TObject);
begin
  //
end;

procedure TSetupForm.TrackBar1Change(Sender: TObject);
begin
  self.AlphaBlendValue := TrackBar1.Position;
end;

{
  모듈명   : AssignItemToForm
  기능     : TButtonItem 객체의 정보를 폼에 할당
  작성일   : 24.02.28
  파라미터 : Item / 정보를 할당할 TButtonItem 객체
}
procedure TSetupForm.AssignItemToForm(Item: TButtonItem);
begin
  ED_Name.Text          := Item.Caption;
  ED_Hint.Text          := Item.Hint;
  ED_LinkName.Text      := Item.Link;
  ED_ExeName.Text       := Item.Exe;
  LB_LocList.ItemIndex  := Item.Loc;
  CheckRadioButton(Item.iType);
end;

{
    모듈명: CheckRadioButton
      기능: 주어진 ItemType에 해당하는 라디오 버튼을 선택합니다.
    작성일: 24.02.28
  파라미터: ItemType / 선택할 라디오 버튼의 타입을 나타내는 정수입니다.
}
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

{
  모듈명   : ChangeSkin
  기능     : 사용자의 선택에 따라 애플리케이션의 스킨 변경
  작성일   : 24.02.28
  파라미터 : 스킨 변경 요청 이벤트를 발생시킨 객체
}
procedure TSetupForm.ChangeSkin(Sender: TObject);
var
  ini: TIniFile;
  Res: Integer;
begin
  Res := MessageDlg('스킨을 바꾸시겠습니까?' + #13#10 + '스킨을 적용합니다.', mtConfirmation, [mbYes, mbNo], 0);
  if Res = mrYes then
  begin
    if StyleList.ItemIndex = -1 then
      Exit;
    ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
    try
      TStyleManager.SetStyle(TStyleManager.StyleNames[StyleList.ItemIndex]);
      ini.WriteString('main', 'StyleNames', TStyleManager.StyleNames[StyleList.ItemIndex]);
    finally
      ini.Free;
    end;
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
//var
  //Item : TButtonItem;
  //idx  : Integer;
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
  Edits    : array[1..4] of TLabeledEdit;
  I        : Integer;
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

procedure TSetupForm.Exe_ChoiceFileClick(Sender: TObject);
begin
  if not OpenDialog2.Execute then Exit;
  ED_ExeName.Text := OpenDialog2.FileName;
end;

function TSetupForm.GetType(SetupAddForm: TAddForm): Integer;
begin
  if AddForm.RB_Type0.Checked then Result := 0
  else if SetupAddForm.RB_Type1.Checked then Result := 1
  else if SetupAddForm.RB_Type2.Checked then Result := 2
  else if SetupAddForm.RB_Type3.Checked then Result := 3
  else Result := -1;
end;

procedure TSetupForm.Btn_ChoiceFileClick(Sender: TObject);
var
  Dir: string;
begin
  if RB_Type2.Checked and not RB_Type0.Checked then
  begin
    Dir := BrowseFolder(Application.Handle, '폴더를 선택하세요.', '');
    if not DirectoryExists(Dir) or (Dir = '') then Exit;
    if Length(Dir) = 3 then SetLength(Dir, 2);
    ED_LinkName.Text := Dir;
  end
  else if OpenDialog1.Execute then ED_LinkName.Text := OpenDialog1.FileName;
end;

procedure TSetupForm.WriteToIni(Item: TButtonItem);
var
  Caption : string;
begin
  Caption := Item.Caption;
  ini.WriteString(Caption, HINT_STR, Item.Hint);
  ini.WriteString(Caption, LINK_STR, Item.Link);
  ini.WriteString(Caption, EXE_STR, Item.Exe);
  ini.WriteInteger(Caption, TYPE_STR, Item.iType);
  ini.WriteInteger(Caption, LOC_STR, Item.Loc);
end;

procedure TSetupForm.Btn_ChangeClick(Sender: TObject);
var
  Item: TButtonItem;
begin
  Item := GetSelectedButton;
  if SetupForm.IS_OK then Item := TButtonItem.Create;

  UpdateButtonDetails(Item);
  UpdateButtonType(Item);
  UpdateButtonLocIndex(Item);

  UpdateButtonList(Item);
  UpdateIniWithButtonDetails(Item);

  IS_OK := True;
end;

function TSetupForm.GetSelectedButton: TButtonItem;
begin
  Result                            := TButtonItem(LB_BtnList.Items.Objects[LB_BtnList.ItemIndex]);
  ini.EraseSection(Result.Caption);
  AddForm.LB_LocList.Items.Text     := GB_CapList.Text;
end;

procedure TSetupForm.UpdateButtonDetails(Button: TButtonItem);
begin
  with Button do
  begin
    Caption := SetupForm.ED_Name.Text;
    Hint    := SetupForm.ED_Hint.Text;
    Link    := SetupForm.ED_LinkName.Text;
    Exe     := SetupForm.ED_ExeName.Text;
  end;
end;

//
procedure TSetupForm.UpdateButtonType(Button: TButtonItem);
begin
  if SetupForm.RB_Type0.Checked then Button.iType := 0;
  if SetupForm.RB_Type1.Checked then Button.iType := 1;
  if SetupForm.RB_Type2.Checked then Button.iType := 2;
  if SetupForm.RB_Type3.Checked then Button.iType := 3;
end;

procedure TSetupForm.UpdateButtonLocIndex(Button: TButtonItem);
begin
  Button.Loc := SetupForm.LB_LocList.ItemIndex;
  Button.Idx := 0;
end;

procedure TSetupForm.UpdateButtonList(Button: TButtonItem);
begin
  LB_BtnList.Items.Delete(LB_BtnList.ItemIndex);
  LB_BtnList.Items.AddObject(Button.Caption, Button);
end;

procedure TSetupForm.UpdateIniWithButtonDetails(Button: TButtonItem);
begin
  with Button do
  begin
    ini.WriteString(Caption, HINT_STR, Hint);
    ini.WriteString(Caption, LINK_STR, Link);
    ini.WriteString(Caption, EXE_STR, Exe);
    ini.WriteInteger(Caption, TYPE_STR, iType);
    ini.WriteInteger(Caption, LOC_STR, Loc);
  end;
end;

procedure TSetupForm.UpdateRegistry(const ValueName: string; const ValueData: string = ''; UpdateType: TRegistryUpdateType = rutAdd);
var
  reg : TRegistry;
begin
  reg := TRegistry.Create(KEY_WRITE);
  try
    reg.RootKey := HKEY_LOCAL_MACHINE;
    if reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', False) then
    begin
      case UpdateType of
        rutAdd: reg.WriteString(ValueName, ValueData);
        rutRemove: reg.DeleteValue(ValueName);
      end;
    end;
  finally
    reg.CloseKey;
    reg.Free;
  end;
end;

end.
