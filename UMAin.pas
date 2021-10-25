unit UMAin;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.StrUtils,
  System.Variants,
  System.Classes,
  System.Inifiles,
  System.Masks,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.Menus,
  System.Actions,
  Vcl.ActnList,
  Vcl.ComCtrls, Vcl.Mask;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    AL01: TActionList;
    AcSimpan: TAction;
    ActHapus: TAction;
    PM01: TPopupMenu;
    AcSimpan1: TMenuItem;
    ActHapus1: TMenuItem;
    GroupBox1: TGroupBox;
    Button1: TButton;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    LPath: TLabel;
    FileName: TLabeledEdit;
    ListBox1: TListBox;
    Button2: TButton;
    ListView1: TListView;
    ActTambah: TAction;
    ActTambah1: TMenuItem;
    ActUbah: TAction;
    ActUbah1: TMenuItem;
    ActOpen: TAction;
    OpenDialog1: TOpenDialog;
    Open1: TMenuItem;
    N1: TMenuItem;
    ActListFile: TAction;
    ActHapusFile: TAction;
    Edit1: TEdit;
    ActUbahFile: TAction;
    UbahFile1: TMenuItem;
    HapusFile1: TMenuItem;
    StatusBar1: TStatusBar;
    procedure FormShow(Sender: TObject);
    procedure ActTambahExecute(Sender: TObject);
    procedure ActHapusExecute(Sender: TObject);
    procedure ActUbahExecute(Sender: TObject);
    procedure AcSimpanExecute(Sender: TObject);
    procedure ActOpenExecute(Sender: TObject);
    procedure ActListFileExecute(Sender: TObject);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListBox1DblClick(Sender: TObject);
    procedure ActHapusFileExecute(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure ActUbahFileExecute(Sender: TObject);
  private
    { Private declarations }
    function PathDirectory: string;
    function RefreshFile(fDirFile: string): TStrings;
    procedure FindFilePattern(root: String; pattern: String);
    procedure RefreshCount;
  public
    { Public declarations }
  end;

  TCustomSortStyle = (cssAlphaNum, cssNumeric, cssDateTime);

var
  Form1: TForm1;

  { variable to hold the sort style }
  LvSortStyle: TCustomSortStyle;
  { array to hold the sort order }
  LvSortOrder: array [0 .. 4] of Boolean;
  // High[LvSortOrder] = Number of Lv Columns

implementation

{$R *.dfm}

function CustomSortProc(Item1, Item2: TListItem; SortColumn: Integer)
  : Integer; stdcall;
var
  s1, s2: string;
  i1, i2: Integer;
  r1, r2: Boolean;
  d1, d2: TDateTime;

  { Helper functions }

  function IsValidNumber(AString: string; var AInteger: Integer): Boolean;
  var
    Code: Integer;
  begin
    Val(AString, AInteger, Code);
    Result := (Code = 0);
  end;

  function IsValidDate(AString: string; var ADateTime: TDateTime): Boolean;
  begin
    Result := True;
    try
      ADateTime := StrToDateTime(AString);
    except
      ADateTime := 0;
      Result := False;
    end;
  end;

  function CompareDates(dt1, dt2: TDateTime): Integer;
  begin
    if (dt1 > dt2) then
      Result := 1
    else if (dt1 = dt2) then
      Result := 0
    else
      Result := -1;
  end;

  function CompareNumeric(AInt1, AInt2: Integer): Integer;
  begin
    if AInt1 > AInt2 then
      Result := 1
    else if AInt1 = AInt2 then
      Result := 0
    else
      Result := -1;
  end;

begin
  Result := 0;

  if (Item1 = nil) or (Item2 = nil) then
    Exit;

  case SortColumn of
    - 1:
      { Compare Captions }
      begin
        s1 := Item1.Caption;
        s2 := Item2.Caption;
      end;
  else
    { Compare Subitems }
    begin
      s1 := '';
      s2 := '';
      { Check Range }
      if (SortColumn < Item1.SubItems.Count) then
        s1 := Item1.SubItems[SortColumn];
      if (SortColumn < Item2.SubItems.Count) then
        s2 := Item2.SubItems[SortColumn]
    end;
  end;

  { Sort styles }

  case LvSortStyle of
    cssAlphaNum:
      Result := lstrcmp(PChar(s1), PChar(s2));
    cssNumeric:
      begin
        r1 := IsValidNumber(s1, i1);
        r2 := IsValidNumber(s2, i2);
        Result := ord(r1 or r2);
        if Result <> 0 then
          Result := CompareNumeric(i2, i1);
      end;
    cssDateTime:
      begin
        r1 := IsValidDate(s1, d1);
        r2 := IsValidDate(s2, d2);
        Result := ord(r1 or r2);
        if Result <> 0 then
          Result := CompareDates(d1, d2);
      end;
  end;

  { Sort direction }

  if LvSortOrder[SortColumn + 1] then
    Result := -Result;
end;

procedure TForm1.AcSimpanExecute(Sender: TObject);
var
  LIniFile: TIniFile;
  I: Integer;
begin
  /// Save Data IniFile Format
  try
    /// Delete File
    if FileExists(PathDirectory + '\' + FileName.Text) then
      DeleteFile(PathDirectory + '\' + FileName.Text);

    LIniFile := TIniFile.Create(PathDirectory + '\' + FileName.Text + '.ini');

    /// Save Record TO File
    with LIniFile, ListView1 do
    begin
      for I := 0 to Items.Count - 1 do
      begin
        WriteString(IntToStr(I), 'Nama', Items[I].SubItems[0]);
        WriteString(IntToStr(I), 'Status', Items[I].SubItems[1]);
        WriteString(IntToStr(I), 'Keterangan', Items[I].SubItems[2]);
      end;
    end;

    MessageDlg('Data Berhasil diSimpan', mtInformation, [mbOK], 0);
    ActListFileExecute(Sender);

    // Hitung Jumlah
    RefreshCount;
  finally
    LIniFile.Free;
  end;
end;

procedure TForm1.ActHapusExecute(Sender: TObject);
begin
  /// Delete ListView
  with ListView1 do
  begin
    case MessageDlg('Apakah Anda Ingin Menghapus?', mtConfirmation,
      [mbYes, mbNo], 0) of
      mrYes:
        begin
          Items[ItemIndex].Delete;
          // Hitung Jumlah
          RefreshCount;
        end;
      mrNo:
        ;
    end;

  end;
end;

procedure TForm1.ActHapusFileExecute(Sender: TObject);
begin
  /// Delete File
  case MessageDlg('Apakah anda Yakin ingin menghapus file?',
    TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) of
    mrYes:
      begin
        if FileExists(LPath.Caption + '\' + ListBox1.Items[ListBox1.ItemIndex])
        then
        begin
          DeleteFile(LPath.Caption + '\' + ListBox1.Items[ListBox1.ItemIndex]);
          ActListFileExecute(Sender);

          // Hitung Jumlah
          RefreshCount;
        end;
      end;

    mrNo:
      ;
  end;
end;

procedure TForm1.ActListFileExecute(Sender: TObject);
begin
  ListBox1.Items.Clear;
  FindFilePattern(LPath.Caption + '\', '*.*');
  // Hitung Jumlah
  RefreshCount;
end;

procedure TForm1.ActOpenExecute(Sender: TObject);
var
  LIniFile: TIniFile;
  LStringList: TStringList;
  I: Integer;
  LI: TListItem;
  fFileName: String;
begin
  /// Pilih File
  with OpenDialog1 do
  begin
    Execute;
    /// baca File
    try
      LIniFile := TIniFile.Create(FileName);
      LStringList := TStringList.Create;
      LIniFile.ReadSections(LStringList);

      with LIniFile, ListView1 do
      begin

        if LStringList.Count > 0 then
        begin
          /// Clear
          Items.Clear;
          /// Loop Data From IniFile
          for I := 0 to LStringList.Count - 1 do
          begin
            LI := Items.Add;
            LI.Caption := IntToStr(I);
            LI.SubItems.Add(ReadString(IntToStr(I), 'Nama', ''));
            LI.SubItems.Add(ReadString(IntToStr(I), 'Status', ''));
            LI.SubItems.Add(ReadString(IntToStr(I), 'Keterangan', ''));
          end;

        end;

      end;

    finally
      LStringList.Free;
      LIniFile.Free;
    end;

  end;

  fFileName := OpenDialog1.Files[0];
  Delete(fFileName, 1, Length(PathDirectory) + 1);
  FileName.Text := fFileName;

  // Hitung Jumlah
  RefreshCount;
end;

procedure TForm1.ActTambahExecute(Sender: TObject);
var
  LAValue: array [0 .. 3] of string;
  LocalItem: TListItem;
  fNumber: Integer;
begin
  /// Isi data
  LAValue[0] := '';
  LAValue[1] := '';
  LAValue[2] := '';
  InputQuery('Input Data', ['Nama', 'Status', 'Keterangan'], LAValue);

  // Masukkan Ke ListView
  fNumber := ListView1.Items.Count + 1;
  LocalItem := ListView1.Items.Add;

  with LocalItem do
  begin
    Caption := IntToStr(fNumber);
    SubItems.Add(LAValue[0]);
    SubItems.Add(LAValue[1]);
    SubItems.Add(LAValue[2]);
  end;

  // Hitung Jumlah
  RefreshCount;

end;

procedure TForm1.ActUbahExecute(Sender: TObject);
var
  LAValue: array [0 .. 3] of string;

begin
  /// Ubah Data
  with ListView1 do
  begin
    Items.BeginUpdate;

    /// Identification Value
    LAValue[0] := Items[Selected.Index].SubItems[0];
    LAValue[1] := Items[Selected.Index].SubItems[1];
    LAValue[2] := Items[Selected.Index].SubItems[2];
    InputQuery('Input Data', ['Nama', 'Status', 'Keterangan'], LAValue);

    /// Chande Value
    Items[Selected.Index].SubItems[0] := LAValue[0];
    Items[Selected.Index].SubItems[1] := LAValue[1];
    Items[Selected.Index].SubItems[2] := LAValue[2];

    Items.EndUpdate;
  end;

end;

procedure TForm1.ActUbahFileExecute(Sender: TObject);
var
  NewFile: String;
begin
  /// Rename File
  NewFile := ReplaceStr(ListBox1.Items[ListBox1.ItemIndex], '.ini', '');
  InputQuery('Rename File', 'Masukkan Nama File Baru', NewFile);
  RenameFile(PathDirectory + '\' + ListBox1.Items[ListBox1.ItemIndex],
    PathDirectory + '\' + NewFile + '.ini');

  { Refresh ListFile }
  ActListFileExecute(Sender);
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
var
  I: Integer;
begin
  if Key = #13 then
  begin
    ListBox1.Items.BeginUpdate;
    try
      for I := 0 to ListBox1.Items.Count - 1 do
        ListBox1.Selected[I] := ContainsText(ListBox1.Items[I], Edit1.Text);
    finally
      ListBox1.Items.EndUpdate;
    end;
  end;
end;

procedure TForm1.FindFilePattern(root, pattern: String);
var
  SR: TSearchRec;
begin
  root := IncludeTrailingPathDelimiter(root);
  if FindFirst(root + '*.*', faAnyFile, SR) = 0 then
    try
      repeat
        Application.ProcessMessages;
        if (SR.Attr and faDirectory) <> 0 then
        begin
          if (SR.Name <> '.') and (SR.Name <> '..') then
            FindFilePattern(root + SR.Name, pattern);
        end
        else
        begin
          if MatchesMask(SR.Name, pattern) then
            Form1.ListBox1.Items.Add(SR.Name);
        end;
      until FindNext(SR) <> 0;
    finally
      FindClose(SR);
    end;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  I: Integer;
begin
  /// Path Directory to Save File.
  LPath.Caption := PathDirectory;

  if not DirectoryExists(PathDirectory) then
    ForceDirectories(PathDirectory);

  /// List File To ListBox
  ActListFileExecute(Sender);

end;

procedure TForm1.ListBox1DblClick(Sender: TObject);
var
  LIniFile: TIniFile;
  LStringList: TStringList;
  LI: TListItem;
  I: Integer;
begin
  /// Read Record From File
  /// baca File
  try
    LIniFile := TIniFile.Create(LPath.Caption + '\' + ListBox1.Items
      [ListBox1.ItemIndex]);
    LStringList := TStringList.Create;
    LIniFile.ReadSections(LStringList);

    with LIniFile, ListView1 do
    begin

      if LStringList.Count > 0 then
      begin
        /// Clear
        Items.Clear;
        /// Loop Data From IniFile
        for I := 0 to LStringList.Count - 1 do
        begin
          LI := Items.Add;
          LI.Caption := IntToStr(I);
          LI.SubItems.Add(ReadString(IntToStr(I), 'Nama', ''));
          LI.SubItems.Add(ReadString(IntToStr(I), 'Status', ''));
          LI.SubItems.Add(ReadString(IntToStr(I), 'Keterangan', ''));
        end;

      end;

    end;

    // Hitung Jumlah
    RefreshCount;

  finally
    LStringList.Free;
    LIniFile.Free;
  end;
end;

procedure TForm1.ListView1ColumnClick(Sender: TObject; Column: TListColumn);
begin
  { determine the sort style }
  if Column.Index = Column.Index then
    LvSortStyle := cssAlphaNum
  else
    LvSortStyle := cssNumeric;

  { Call the CustomSort method }
  ListView1.CustomSort(@CustomSortProc, Column.Index - 1);

  { Set the sort order for the column }
  LvSortOrder[Column.Index] := not LvSortOrder[Column.Index];
end;

function TForm1.PathDirectory: string;
begin
  Result := ExtractFileDir(Application.ExeName) + '\Notes';
end;

procedure TForm1.RefreshCount;
begin
  /// Hitung Jumlah File
  StatusBar1.Panels[1].Text := IntToStr(ListBox1.Items.Count);
  /// Jumlah data Inifile
  StatusBar1.Panels[3].Text := IntToStr(ListView1.Items.Count);
end;

function TForm1.RefreshFile(fDirFile: string): TStrings;
// var
// LStringList: TStringList;
begin
  try
    // LStringList := TStringList.Create;

    Result.Create;

    with Result do
    begin
      Add('File01');
      Add('File02');
      Add('File03');
      Add('File04');
    end;

  finally
    // LStringList.Free;
  end;
end;

end.
