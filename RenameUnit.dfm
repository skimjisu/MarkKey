object RenameForm: TRenameForm
  Left = 0
  Top = 0
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsToolWindow
  Caption = 'RenameForm'
  ClientHeight = 73
  ClientWidth = 211
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  OnShow = FormShow
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 211
    Height = 73
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object SpeedButton1: TSpeedButton
      Left = 121
      Top = 30
      Width = 39
      Height = 33
      Caption = 'O'
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 166
      Top = 30
      Width = 39
      Height = 33
      Caption = 'X'
      OnClick = SpeedButton2Click
    end
    object Edit1: TEdit
      Left = 0
      Top = 0
      Width = 211
      Height = 23
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      Text = 'Edit1'
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 203
    end
  end
end
