unit NetworkControl;

interface

uses
  ComObj, ActiveX, System.Variants, System.SysUtils, System.Classes;

type
  TNetworkControl = class
  private
    class function GetVarArrayFirstElement(VarData: Variant): string;
    class function GetDNSServers(DNSServerSearchOrder: Variant): string;
    class function AddNetworkAdapterInfo(NetworkAdapter: OLEVariant): string;
  public
    class function GetNetworkAdapterInfo: TStringList;
  end;

implementation

{
  함수명  : GetVarArrayFirstElement
  기능    : 첫번째 원소가 있는지 확인하고 반환하는 함수
  파라메터: Variant 타입의 VarData
  날짜    : 24.03.01
}
class function TNetworkControl.GetVarArrayFirstElement(VarData: Variant): string;
begin
  Result := '';
  if VarArrayDimCount(VarData) > 0 then Result := VarToStr(VarData[0]);
end;

{
  함수명  : GetDNSServers
  기능    : DNS 서버 목록을 문자열로 반환하는 함수
  파라메터: Variant 타입의 DNSServerSearchOrder
  날짜    : 24.03.01
}
class function TNetworkControl.GetDNSServers(DNSServerSearchOrder: Variant): string;
var
  DNSIndex: Integer;
begin
  Result := '';
  if VarArrayDimCount(DNSServerSearchOrder) > 0 then
  begin
    for DNSIndex := VarArrayLowBound(DNSServerSearchOrder, 1) to VarArrayHighBound(DNSServerSearchOrder, 1) do
      Result := Result + VarToStr(DNSServerSearchOrder[DNSIndex]) + ', ';
    Result := Result.TrimRight([',', ' ']);
  end;
end;

{
  함수명  : AddNetworkAdapterInfo
  기능    : 네트워크 어댑터 정보를 문자열로 반환하는 함수
  파라메터: OLEVariant 타입의 NetworkAdapter
  날짜    : 24.03.01
}
class function TNetworkControl.AddNetworkAdapterInfo(NetworkAdapter: OLEVariant): string;
var
  InfoBuilder: TStringBuilder;
begin
  if VarIsNull(NetworkAdapter) then Exit('');

  InfoBuilder := TStringBuilder.Create;
  try
    InfoBuilder.AppendLine('NIC 이름: ' + NetworkAdapter.Description);
    InfoBuilder.AppendLine('IP 주소: ' + GetVarArrayFirstElement(NetworkAdapter.IPAddress));
    InfoBuilder.AppendLine('서브넷 마스크: ' + GetVarArrayFirstElement(NetworkAdapter.IPSubnet));
    InfoBuilder.AppendLine('DHCP 활성화: ' + BoolToStr(NetworkAdapter.DHCPEnabled, True));
    if NetworkAdapter.DHCPEnabled then InfoBuilder.AppendLine('DHCP 서버: ' + NetworkAdapter.DHCPServer);
    InfoBuilder.AppendLine('DNS 서버: ' + GetDNSServers(NetworkAdapter.DNSServerSearchOrder));
    InfoBuilder.AppendLine;
    Result := InfoBuilder.ToString;
  finally
    InfoBuilder.Free;
  end;
end;

{
  함수명  : GetNetworkAdapterInfo
  기능    : 모든 네트워크 어댑터 정보를 가져오는 함수
  파라메터: 없음
  날짜    : 24.03.01
}
class function TNetworkControl.GetNetworkAdapterInfo: TStringList;
var
  WMIConnector   : OLEVariant;
  WMIObject      : OLEVariant;
  QueryResult    : OLEVariant;
  i              : Integer;
  InfoList       : TStringList;
begin
  InfoList       := TStringList.Create;
  try
    WMIConnector := CreateOleObject('WbemScripting.SWbemLocator');
    WMIObject    := WMIConnector.ConnectServer('localhost', 'root\CIMV2', '', '');
    QueryResult  := WMIObject.ExecQuery('SELECT * FROM Win32_NetworkAdapterConfiguration WHERE IPEnabled = True');

    for i := 0 to QueryResult.Count - 1 do InfoList.Add(AddNetworkAdapterInfo(QueryResult.ItemIndex(i)));
    Result := InfoList;

  except
    InfoList.Free;
    raise;
  end;
end;

end.

