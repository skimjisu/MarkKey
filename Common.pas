unit Common;

interface

uses
  ShellAPI, ShlObj, Windows, ActiveX, System.SysUtils, System.IniFiles, System.IOUtils;
type
  TButtonItem = class(TObject)
  public
    Caption   : string;
    Hint      : string;
    Link      : string;
    Exe       : string;

    iType     : Integer;
    Loc       : Integer;
    Idx       : Integer;
  end;

const
  HINT_STR = '도움';
  TYPE_STR = '타입';
  LINK_STR = '링크';
  EXE_STR  = '경로';
  LOC_STR  = '위치';


  SETUP_SEC_STR = 'main';
  MAX_BTN_COUNT = 20;

 var
  Typename  : string;

  function GetSpecialFolderLocation(Handle: HWND; code: Integer): string;
  function BrowseCallbackProc(hwnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer; stdcall;
  function BrowseFolder(hwnd: HWND; Title: string; Folder: string): string;
(*
    procedure EncryptIniFile(const SourceFile, DestFile, Password: string);
    procedure DecryptIniFile(const SourceFile, DestFile, Password: string);
*)


implementation

function GetSpecialFolderLocation(Handle: HWND; code: Integer): string;
var
  Pidl         : PItemIDList;
  DisplayName  : array[0..MAX_PATH] of Char;
  stTemp       : string;
begin
  stTemp       := '';
  try
    if SHGetSpecialFolderLocation(Handle, code, Pidl) = S_OK then
    begin
      if SHGetPathFromIDList(Pidl, DisplayName) then
        stTemp := DisplayName;
    end;
  except
    stTemp     := '';
  end;
  Result       := stTemp;
end;

function BrowseCallbackProc(hwnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer; stdcall;
begin
  if uMsg = BFFM_INITIALIZED then
    if lstrlen(PChar(lpData)) > 0 then
      SendMessage(hwnd, BFFM_SETSELECTION, 1, lpData);
  Result := 0;
end;


function BrowseFolder(hwnd: HWND; Title: string; Folder: string): string;
var
  Info   : BROWSEINFO;
  IDList : PItemIDList;
  s      : array[0..255] of Char;
  ResultStr: array[0..1023] of Char;
begin
  ZeroMemory(@Info, SizeOf(Info));
  Info.hwndOwner        := hwnd;

  Info.pidlRoot         := nil;
  StrPCopy(s, Title);
  Info.lpszTitle        := s;
  Info.ulFlags          := BIF_RETURNONLYFSDIRS or BIF_USENEWUI or BIF_NEWDIALOGSTYLE;
  if Length(Folder) > 0 then StrPCopy(ResultStr, Folder);
  Info.lParam           := LPARAM(@ResultStr);
  Info.lpfn             := @BrowseCallbackProc;

  IDList                := SHBrowseForFolder(Info);

  if IDList <> nil then
  begin
    ZeroMemory(@ResultStr, SizeOf(ResultStr));
    SHGetPathFromIDList(IDList, ResultStr);
    CoTaskMemFree(IDList);
  end
  else StrPCopy(ResultStr, '');
  Result := string(ResultStr);
end;

(*  ini file 암호화 에정 코드
  procedure EncryptIniFile(const SourceFile, DestFile, Password: string);
  var
    Codec: TCodec;
    CryptographicLibrary: TCryptographicLibrary;
    IniFile: TIniFile;
    IniString, EncryptedString: string;
    StringStream, EncryptedStream: TStringStream;
  begin
    // Create a codec
    Codec := TCodec.Create(nil);
    CryptographicLibrary := TCryptographicLibrary.Create(nil);
    try
      // Set up the codec
      Codec.CryptoLibrary := CryptographicLibrary;
      Codec.StreamCipherId := BlockCipher_ProgId;
      Codec.BlockCipherId := Format(AES_ProgId, [256]);
      Codec.ChainModeId := CFB_ProgId;
      Codec.Password := Password;

      // Read the INI file
      IniFile := TIniFile.Create(SourceFile);
      try
        IniString := IniFile.ReadString('Section', 'Key', '');
      finally
        IniFile.Free;
      end;

      // Encrypt the INI string
      StringStream := TStringStream.Create(IniString, TEncoding.UTF8);
      EncryptedStream := TStringStream.Create('', TEncoding.UTF8);
      try
        Codec.EncryptStream(EncryptedStream, StringStream);
        EncryptedString := EncryptedStream.DataString;
        // Save the encrypted string to a file
        TFile.WriteAllText(DestFile, EncryptedString);
      finally
        StringStream.Free;
        EncryptedStream.Free;
      end;
    finally
      Codec.Free;
      CryptographicLibrary.Free;
    end;
  end;

  procedure DecryptIniFile(const SourceFile, DestFile, Password: string);  // ini file 복호화 에정 코드
  var
    Codec: TCodec;
    CryptographicLibrary: TCryptographicLibrary;
    EncryptedString, DecryptedString: string;
    StringStream, DecryptedStream: TStringStream;
  begin
    // Create a codec
    Codec := TCodec.Create(nil);
    CryptographicLibrary := TCryptographicLibrary.Create(nil);
    try
      // Set up the codec
      Codec.CryptoLibrary := CryptographicLibrary;
      Codec.StreamCipherId := BlockCipher_ProgId;
      Codec.BlockCipherId := Format(AES_ProgId, [256]);
      Codec.ChainModeId := CFB_ProgId;
      Codec.Password := Password;

      // Read the encrypted file
      EncryptedString := TFile.ReadAllText(SourceFile);

      // Decrypt the encrypted string
      StringStream := TStringStream.Create(EncryptedString, TEncoding.UTF8);
      DecryptedStream := TStringStream.Create('', TEncoding.UTF8);
      try
        Codec.DecryptStream(DecryptedStream, StringStream);
        DecryptedString := DecryptedStream.DataString;
        // Save the decrypted string to a file
        TFile.WriteAllText(DestFile, DecryptedString);
      finally
        StringStream.Free;
        DecryptedStream.Free;
      end;
    finally
      Codec.Free;
      CryptographicLibrary.Free;
    end;
  end;

*)
end.
