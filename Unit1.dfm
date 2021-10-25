object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 307
  ClientWidth = 445
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 185
    Height = 65
    Caption = 'Simple'
    TabOrder = 0
    object Button2: TButton
      Left = 103
      Top = 24
      Width = 75
      Height = 25
      Caption = 'Print Image'
      TabOrder = 0
      OnClick = Button2Click
    end
    object Button1: TButton
      Left = 7
      Top = 24
      Width = 75
      Height = 25
      Caption = 'Print Font'
      TabOrder = 1
      OnClick = Button1Click
    end
  end
  object GroupBox2: TGroupBox
    Left = 216
    Top = 8
    Width = 185
    Height = 186
    Caption = 'Paramater Text'
    TabOrder = 1
    object Memo1: TMemo
      Left = 2
      Top = 15
      Width = 181
      Height = 144
      Align = alClient
      TabOrder = 0
    end
    object Button3: TButton
      Left = 2
      Top = 159
      Width = 181
      Height = 25
      Align = alBottom
      Caption = 'Print'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = Button3Click
    end
  end
end
