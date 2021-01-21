object FMain: TFMain
  Left = 136
  Top = 118
  Width = 1044
  Height = 621
  Caption = #1056#1054#1043#1045#1049#1053' '#1058#1050' '#1052#1040#1048
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 1028
    Height = 57
    Align = alTop
    TabOrder = 0
    object Label3: TLabel
      Left = 232
      Top = 36
      Width = 22
      Height = 13
      Caption = #1084#1080#1085'.'
    end
    object Label4: TLabel
      Left = 288
      Top = 16
      Width = 100
      Height = 13
      Caption = #1050#1086#1085#1090#1088#1086#1083#1100#1085#1086#1077' '#1074#1088#1077#1084#1103
    end
    object Label5: TLabel
      Left = 323
      Top = 35
      Width = 22
      Height = 13
      Caption = #1084#1080#1085'.'
    end
    object BtLoadsplit: TButton
      Left = 8
      Top = 8
      Width = 89
      Height = 33
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072
      TabOrder = 0
      OnClick = BtLoadsplitClick
    end
    object BtGoPoint: TButton
      Left = 144
      Top = 8
      Width = 129
      Height = 25
      Caption = #1055#1086#1076#1089#1095#1080#1090#1072#1090#1100' '#1086#1095#1082#1080
      TabOrder = 1
      OnClick = BtGoPointClick
    end
    object BtSaveProt: TButton
      Left = 392
      Top = 8
      Width = 129
      Height = 33
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1087#1088#1086#1090#1086#1082#1086#1083
      TabOrder = 2
      OnClick = BtSaveProtClick
    end
    object BtSaveProtokolPlayer: TButton
      Left = 528
      Top = 8
      Width = 161
      Height = 33
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1083#1080#1095#1085#1099#1081' '#1087#1088#1086#1090#1086#1082#1086#1083
      TabOrder = 3
      OnClick = BtSaveProtokolPlayerClick
    end
    object BtSaveSplit: TButton
      Left = 696
      Top = 8
      Width = 105
      Height = 33
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1089#1087#1083#1080#1090#1099
      TabOrder = 4
      OnClick = BtSaveSplitClick
    end
    object EdKolStr: TEdit
      Left = 808
      Top = 8
      Width = 105
      Height = 21
      TabOrder = 5
      Text = '1'
    end
    object BtSaveObSplit: TButton
      Left = 920
      Top = 8
      Width = 75
      Height = 25
      Caption = 'BtSaveObSplit'
      TabOrder = 6
      OnClick = BtSaveObSplitClick
    end
    object CbHalfHour: TCheckBox
      Left = 144
      Top = 32
      Width = 49
      Height = 17
      Caption = #1050#1042' + '
      Checked = True
      State = cbChecked
      TabOrder = 7
    end
    object EdMin: TEdit
      Left = 192
      Top = 32
      Width = 41
      Height = 21
      TabOrder = 8
      Text = '0'
    end
    object EdDiscvalTimeMin: TEdit
      Left = 288
      Top = 32
      Width = 33
      Height = 21
      TabOrder = 9
      Text = '30'
    end
  end
  object pnl2: TPanel
    Left = 0
    Top = 57
    Width = 545
    Height = 526
    Align = alLeft
    Caption = 'pnl2'
    TabOrder = 1
    object pnl3: TPanel
      Left = 1
      Top = 1
      Width = 543
      Height = 40
      Align = alTop
      TabOrder = 0
      object Label1: TLabel
        Left = 248
        Top = 0
        Width = 75
        Height = 13
        Caption = #1048#1084#1103' '#1091#1095#1072#1089#1090#1085#1080#1082#1072
      end
      object CbGroup: TComboBox
        Left = 8
        Top = 8
        Width = 145
        Height = 21
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 0
        Text = #1042#1089#1077
        OnClick = CbGroupClick
        Items.Strings = (
          #1042#1089#1077)
      end
      object BtSort: TButton
        Left = 160
        Top = 8
        Width = 81
        Height = 25
        Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072
        TabOrder = 1
        OnClick = BtSortClick
      end
      object EdNomCommand: TEdit
        Left = 248
        Top = 16
        Width = 121
        Height = 21
        TabOrder = 2
        OnChange = EdNomCommandChange
      end
      object BtSearchNomCommand: TButton
        Left = 376
        Top = 8
        Width = 89
        Height = 25
        Caption = #1055#1086#1080#1089#1082
        TabOrder = 3
        OnClick = BtSearchNomCommandClick
      end
    end
    object SgCommand: TStringGrid
      Left = 1
      Top = 41
      Width = 543
      Height = 484
      Align = alClient
      ColCount = 6
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSizing, goColSizing, goEditing, goRowSelect]
      TabOrder = 1
      OnSelectCell = SgCommandSelectCell
      ColWidths = (
        64
        64
        64
        168
        64
        64)
    end
  end
  object pnl4: TPanel
    Left = 545
    Top = 57
    Width = 483
    Height = 526
    Align = alClient
    Caption = 'pnl4'
    TabOrder = 2
    object pnl5: TPanel
      Left = 1
      Top = 1
      Width = 481
      Height = 41
      Align = alTop
      TabOrder = 0
      object CbGoAddFunction: TCheckBox
        Left = 8
        Top = 16
        Width = 233
        Height = 17
        Caption = #1042#1082#1083#1102#1095#1080#1090#1100' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1077' '#1074#1086#1079#1084#1086#1078#1085#1086#1089#1090#1080
        TabOrder = 0
      end
      object BtSaveDop: TButton
        Left = 248
        Top = 11
        Width = 75
        Height = 25
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
        TabOrder = 1
        OnClick = BtSaveDopClick
      end
    end
    object pnl6: TPanel
      Left = 1
      Top = 42
      Width = 481
      Height = 483
      Align = alClient
      Caption = 'pnl6'
      TabOrder = 1
      object SgSplit: TStringGrid
        Left = 1
        Top = 1
        Width = 479
        Height = 177
        Align = alClient
        ColCount = 7
        FixedCols = 0
        RowCount = 8
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSizing, goColSizing, goEditing, goRowSelect]
        TabOrder = 0
        OnDrawCell = SgSplitDrawCell
      end
      object pnl7: TPanel
        Left = 1
        Top = 178
        Width = 479
        Height = 304
        Align = alBottom
        Caption = 'pnl7'
        TabOrder = 1
        object Panel1: TPanel
          Left = 1
          Top = 1
          Width = 477
          Height = 48
          Align = alTop
          TabOrder = 0
          object Label2: TLabel
            Left = 8
            Top = 8
            Width = 48
            Height = 13
            Caption = #1053#1086#1084#1077#1088' '#1050#1055
          end
          object BtAddKP: TButton
            Left = 136
            Top = 8
            Width = 129
            Height = 33
            Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1050#1055
            TabOrder = 0
            OnClick = BtAddKPClick
          end
          object EdKPFail: TEdit
            Left = 8
            Top = 24
            Width = 121
            Height = 21
            TabOrder = 1
            Text = '105'
          end
          object BtAddKPFailPlayer: TButton
            Left = 272
            Top = 8
            Width = 153
            Height = 33
            Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1050#1055' '#1048#1075#1088#1086#1082#1091
            TabOrder = 2
            OnClick = BtAddKPFailPlayerClick
          end
        end
        object pnl8: TPanel
          Left = 1
          Top = 49
          Width = 72
          Height = 254
          Align = alLeft
          Caption = 'pnl8'
          TabOrder = 1
          object SgKPFail: TStringGrid
            Left = 1
            Top = 1
            Width = 70
            Height = 252
            Align = alClient
            ColCount = 1
            FixedCols = 0
            RowCount = 1
            FixedRows = 0
            TabOrder = 0
            OnSelectCell = SgKPFailSelectCell
          end
        end
        object MeKPPlayer: TMemo
          Left = 73
          Top = 49
          Width = 405
          Height = 254
          Align = alClient
          TabOrder = 2
        end
      end
    end
  end
  object OdLoad: TOpenDialog
    Left = 96
    Top = 8
  end
end
