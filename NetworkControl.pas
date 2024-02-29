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
  �Լ���  : GetVarArrayFirstElement
  ���    : ù��° ���Ұ� �ִ��� Ȯ���ϰ� ��ȯ�ϴ� �Լ�
  �Ķ����: Variant Ÿ���� VarData
  ��¥    : 24.03.01
}
class function TNetworkControl.GetVarArrayFirstElement(VarData: Variant): string;
begin
  Result := '';
  if VarArrayDimCount(VarData) > 0 then Result := VarToStr(VarData[0]);
end;

{
  �Լ���  : GetDNSServers
  ���    : DNS ���� ����� ���ڿ��� ��ȯ�ϴ� �Լ�
  �Ķ����: Variant Ÿ���� DNSServerSearchOrder
  ��¥    : 24.03.01
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
  �Լ���  : AddNetworkAdapterInfo
  ���    : ��Ʈ��ũ ����� ������ ���ڿ��� ��ȯ�ϴ� �Լ�
  �Ķ����: OLEVariant Ÿ���� NetworkAdapter
  ��¥    : 24.03.01
}
class function TNetworkControl.AddNetworkAdapterInfo(NetworkAdapter: OLEVariant): string;
var
  InfoBuilder: TStringBuilder;
begin
  if VarIsNull(NetworkAdapter) then Exit('');

  InfoBuilder := TStringBuilder.Create;
  try
    InfoBuilder.AppendLine('NIC �̸�: ' + NetworkAdapter.Description);
    InfoBuilder.AppendLine('IP �ּ�: ' + GetVarArrayFirstElement(NetworkAdapter.IPAddress));
    InfoBuilder.AppendLine('����� ����ũ: ' + GetVarArrayFirstElement(NetworkAdapter.IPSubnet));
    InfoBuilder.AppendLine('DHCP Ȱ��ȭ: ' + BoolToStr(NetworkAdapter.DHCPEnabled, True));
    if NetworkAdapter.DHCPEnabled then InfoBuilder.AppendLine('DHCP ����: ' + NetworkAdapter.DHCPServer);
    InfoBuilder.AppendLine('DNS ����: ' + GetDNSServers(NetworkAdapter.DNSServerSearchOrder));
    InfoBuilder.AppendLine;
    Result := InfoBuilder.ToString;
  finally
    InfoBuilder.Free;
  end;
end;

{
  �Լ���  : GetNetworkAdapterInfo
  ���    : ��� ��Ʈ��ũ ����� ������ �������� �Լ�
  �Ķ����: ����
  ��¥    : 24.03.01
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

