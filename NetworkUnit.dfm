object NetworkForm: TNetworkForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'NetworkForm'
  ClientHeight = 416
  ClientWidth = 539
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 539
    Height = 385
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 630
    object Memo1: TMemo
      Left = 0
      Top = 0
      Width = 539
      Height = 385
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 176
      ExplicitTop = 152
      ExplicitWidth = 185
      ExplicitHeight = 89
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 385
    Width = 539
    Height = 31
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitHeight = 198
    object Button1: TButton
      Left = 0
      Top = 0
      Width = 539
      Height = 31
      Align = alClient
      Caption = #51312#54924
      TabOrder = 0
      OnClick = Button1Click
      ExplicitLeft = 232
      ExplicitTop = -8
      ExplicitWidth = 75
      ExplicitHeight = 25
    end
  end
end
