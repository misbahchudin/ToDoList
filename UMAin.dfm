object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Absensi Mahasiswa'
  ClientHeight = 456
  ClientWidth = 746
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 746
    Height = 456
    ActivePage = TabSheet1
    Align = alClient
    TabHeight = 25
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Main Source'
      PopupMenu = PM01
      object GroupBox1: TGroupBox
        Left = 0
        Top = 73
        Width = 145
        Height = 329
        Align = alLeft
        Caption = 'Options'
        TabOrder = 0
        object Button1: TButton
          Left = 2
          Top = 15
          Width = 141
          Height = 26
          Action = AcSimpan
          Align = alTop
          TabOrder = 0
        end
        object ListBox1: TListBox
          Left = 2
          Top = 87
          Width = 141
          Height = 240
          Align = alClient
          ItemHeight = 13
          TabOrder = 1
          OnDblClick = ListBox1DblClick
        end
        object Button2: TButton
          Left = 2
          Top = 41
          Width = 141
          Height = 25
          Action = ActHapusFile
          Align = alTop
          TabOrder = 2
        end
        object Edit1: TEdit
          Left = 2
          Top = 66
          Width = 141
          Height = 21
          Align = alTop
          TabOrder = 3
          TextHint = 'Cari Nama File'
          OnKeyPress = Edit1KeyPress
        end
      end
      object GroupBox2: TGroupBox
        Left = 0
        Top = 0
        Width = 738
        Height = 73
        Align = alTop
        Caption = 'Document Title'
        TabOrder = 1
        object Label1: TLabel
          Left = 16
          Top = 20
          Width = 29
          Height = 13
          Caption = 'Path :'
        end
        object LPath: TLabel
          Left = 51
          Top = 20
          Width = 59
          Height = 13
          Caption = 'Location File'
        end
        object FileName: TLabeledEdit
          Left = 64
          Top = 39
          Width = 661
          Height = 21
          EditLabel.Width = 46
          EditLabel.Height = 13
          EditLabel.BiDiMode = bdLeftToRight
          EditLabel.Caption = 'File Name'
          EditLabel.ParentBiDiMode = False
          LabelPosition = lpLeft
          TabOrder = 0
          Text = ''
        end
      end
      object ListView1: TListView
        Left = 145
        Top = 73
        Width = 593
        Height = 329
        Align = alClient
        Columns = <
          item
            Caption = 'No'
            Width = 25
          end
          item
            Caption = 'Nama'
            Width = 200
          end
          item
            Caption = 'Status'
            Width = 150
          end
          item
            Caption = 'Keterangan'
            Width = 200
          end>
        PopupMenu = PM01
        TabOrder = 2
        ViewStyle = vsReport
        OnColumnClick = ListView1ColumnClick
      end
      object StatusBar1: TStatusBar
        Left = 0
        Top = 402
        Width = 738
        Height = 19
        Panels = <
          item
            Text = 'Jumlah File :'
            Width = 70
          end
          item
            Width = 75
          end
          item
            Text = 'Jumlah Data :'
            Width = 80
          end
          item
            Width = 80
          end>
      end
    end
  end
  object AL01: TActionList
    Left = 540
    Top = 55
    object AcSimpan: TAction
      Caption = 'Simpan'
      ShortCut = 16467
      OnExecute = AcSimpanExecute
    end
    object ActHapus: TAction
      Caption = 'Hapus'
      ShortCut = 46
      OnExecute = ActHapusExecute
    end
    object ActTambah: TAction
      Caption = 'Tambah'
      ShortCut = 16457
      OnExecute = ActTambahExecute
    end
    object ActUbah: TAction
      Caption = 'Ubah'
      ShortCut = 113
      OnExecute = ActUbahExecute
    end
    object ActOpen: TAction
      Caption = 'Open'
      ShortCut = 16463
      OnExecute = ActOpenExecute
    end
    object ActListFile: TAction
      Caption = 'Daftar FIle'
      ShortCut = 16460
      OnExecute = ActListFileExecute
    end
    object ActHapusFile: TAction
      Caption = 'Hapus File'
      ShortCut = 16430
      OnExecute = ActHapusFileExecute
    end
    object ActUbahFile: TAction
      Caption = 'Ubah File'
      ShortCut = 16497
      OnExecute = ActUbahFileExecute
    end
  end
  object PM01: TPopupMenu
    Left = 540
    Top = 119
    object Open1: TMenuItem
      Action = ActOpen
    end
    object UbahFile1: TMenuItem
      Action = ActUbahFile
    end
    object HapusFile1: TMenuItem
      Action = ActHapusFile
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object AcSimpan1: TMenuItem
      Action = AcSimpan
    end
    object ActHapus1: TMenuItem
      Action = ActHapus
    end
    object ActTambah1: TMenuItem
      Action = ActTambah
    end
    object ActUbah1: TMenuItem
      Action = ActUbah
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 544
    Top = 192
  end
end
