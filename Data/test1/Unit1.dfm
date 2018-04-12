object Form1: TForm1
  Left = 181
  Top = 116
  Width = 870
  Height = 500
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ComboBox1: TComboBox
    Left = 648
    Top = 96
    Width = 145
    Height = 19
    Style = csOwnerDrawFixed
    ItemHeight = 13
    TabOrder = 0
    OnDrawItem = ComboBox1DrawItem
  end
  object CheckListBox1: TCheckListBox
    Left = 480
    Top = 88
    Width = 121
    Height = 33
    OnClickCheck = CheckListBox1ClickCheck
    ItemHeight = 13
    Items.Strings = (
      'fdgg'
      '43535345345'
      '34253425235'
      '345345345'
      '345345345'
      '345345345')
    TabOrder = 1
  end
  object Memo1: TMemo
    Left = 528
    Top = 248
    Width = 289
    Height = 169
    Lines.Strings = (
      'Memo1')
    TabOrder = 2
  end
  object ComboBox2: TComboBox
    Left = 216
    Top = 112
    Width = 145
    Height = 19
    Style = csOwnerDrawFixed
    ItemHeight = 13
    TabOrder = 3
    OnDrawItem = ComboBox2DrawItem
    Items.Strings = (
      '111'
      '222'
      '333'
      '444'
      '555'
      '666'
      '777'
      '888'
      '999')
  end
  object CheckBox1: TCheckBox
    Left = 240
    Top = 208
    Width = 97
    Height = 17
    Caption = 'CheckBox1'
    TabOrder = 4
  end
  object ComboBox3: TComboBox
    Left = 216
    Top = 304
    Width = 145
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    TabOrder = 5
    Items.Strings = (
      '232'
      '23'
      '423'
      '4'
      '234'
      '23'
      '4'
      '234'
      ''
      '34')
  end
end
