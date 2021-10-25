unit Unit1;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Printers,
  Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Button2: TButton;
    Button1: TButton;
    Memo1: TMemo;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  printDialog : TPrintDialog;
  LocalPrinter: TPrinter;

begin

  // Create a printer selection dialog
  printDialog := TPrintDialog.Create(Form1);

  // If the user has selected a printer (or default), then print!
  if printDialog.Execute then
  begin
    // Use the Printer function to get access to the
    // global TPrinter object.
    // All references below are to the TPrinter object
    LocalPrinter := printer;
    with LocalPrinter do
    begin
      // Start printing
      BeginDoc;

      // Set up a large blue font
      Canvas.Font.Size  := 20;
      Canvas.Font.Color := clBlue;

      // Write out the page size
      Canvas.TextOut(20, 20, 'Page  width = ' + IntToStr(PageWidth));
      Canvas.TextOut(20, 150, 'Page height = ' + IntToStr(PageHeight));

      Canvas.Font.Name  := 'Cambria';
      Canvas.Font.Size  := 8;
      Canvas.Font.Color := clBlack;

      Canvas.TextOut(10, 300, 'data');
      Canvas.TextOut(10, 600, 'makan');

      // Finish printing
      EndDoc;
    end;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  bmp: TBitmap;
begin
{Create Component Images}
  try
    bmp := TBitmap.Create;
    try
      bmp.Width  := 400;
      bmp.Height := 400;
      // your Barcode - Code here
      bmp.LoadFromFile(ExtractFileDir(Application.ExeName)+'/picture.bmp');
      bmp.Canvas.Ellipse(10, 10, 300, 300);
      printer.BeginDoc;
      printer.Canvas.Draw(10, 10, bmp);
      printer.EndDoc;
    finally
    {Release Component when Finish Code}
      bmp.Free;
    end;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end;

procedure TForm1.Button3Click(Sender: TObject);
var
  printDialog : TPrintDialog;
  LocalPrinter: TPrinter;

begin
  try
    // Create a printer selection dialog
    printDialog := TPrintDialog.Create(Form1);

    // If the user has selected a printer (or default), then print!
    if printDialog.Execute then
    begin
      // Use the Printer function to get access to the
      // global TPrinter object.
      // All references below are to the TPrinter object
      LocalPrinter := printer;
      with LocalPrinter do
      begin
        // Start printing
        BeginDoc;

        // Set up a large blue font
        Canvas.Font.Size  := 10;
        Canvas.Font.Color := clBlack;

        // Write out the page size
        // Canvas.TextOut(10, 10, '12345678910' );
        Canvas.TextOut(0, 0, Memo1.Lines.Text);

        Canvas.Font.Size  := 20;
        Canvas.Font.Color := clBlack;
        Canvas.Font.Name  := 'Cambria';
        Canvas.Font.Style := [fsBold];
        Canvas.TextOut(0, 20, Memo1.Lines.Text);

        // Finish printing
        EndDoc;
      end;
    end;
  finally
    printDialog.Free;
  end;
end;

end.
