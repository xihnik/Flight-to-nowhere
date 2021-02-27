unit setting;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, auth, MMSystem;

type
  Tfsettings = class(TForm)
    Image1: TImage;
    lenter: TLabel;
    TrackBar1: TTrackBar;
    Label1: TLabel;
    Label2: TLabel;
    ComboBox1: TComboBox;
    lx: TLabel;
    procedure lxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lxMouseEnter(Sender: TObject);
    procedure lxMouseLeave(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ComboBox1Change(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fsettings: Tfsettings;

implementation

{$R *.dfm}

uses gmenu;

function shifr(s: string): string;
Var
  i: Integer;
  rashifr: string;
begin
  for i := 1 to length(s) do
    if (s[i] >= 'A') and (s[i] <= 'Z') then
    begin
      if ((ord(s[i]) + 3) > ord('Z')) then
        rashifr := rashifr + chr(ord(s[i]) - 23)
      else
        rashifr := rashifr + chr(ord(s[i]) + 3);
    end
    else if (s[i] >= 'a') and (s[i] <= 'z') then
    begin
      if ((ord(s[i]) + 3) > ord('z')) then
        rashifr := rashifr + chr(ord(s[i]) - 23)
      else
        rashifr := rashifr + chr(ord(s[i]) + 3);
    end
    else
      rashifr := rashifr + s[i];

  result := rashifr;
end;

function deshifr(s: string): string;
Var
  i: Integer;
  destr: string;
begin
  for i := 1 to length(s) do
    if (s[i] >= 'A') and (s[i] <= 'Z') then
    begin
      if ((ord(s[i]) - 3) < ord('A')) then
        destr := destr + chr(ord(s[i]) + 23)
      else
        destr := destr + chr(ord(s[i]) - 3);
    end
    else if (s[i] >= 'a') and (s[i] <= 'z') then
    begin
      if ((ord(s[i]) - 3) < ord('a')) then
        destr := destr + chr(ord(s[i]) + 23)
      else
        destr := destr + chr(ord(s[i]) - 3)
    end
    else
      destr := destr + s[i];

  result := destr;
end;

procedure change_textfile(k1: Integer);
var
  f, f1: textfile;
begin
  AssignFile(f, 'input.txt');
  Reset(f);
  AssignFile(f1, 'input1.txt');
  Rewrite(f1);
  While not eof(f) do
  begin

    readln(f, peoples.login);
    peoples.login := deshifr(peoples.login);

    readln(f, peoples.password);
    peoples.password := deshifr(peoples.password);

    readln(f, peoples.secret_password);
    peoples.secret_password := deshifr(peoples.secret_password);

    readln(f, peoples.records);
    peoples.records := StrToFloat(deshifr(FloatToStr(peoples.records)));

    readln(f, peoples.sound);
    peoples.sound := StrToInt(deshifr(IntToStr(peoples.sound)));

    readln(f, peoples.complexity);
    peoples.complexity := deshifr(peoples.complexity);

    readln(f, peoples.money);
    peoples.money := StrToInt(deshifr(IntToStr(peoples.money)));

    readln(f, peoples.ammo);
    peoples.ammo := StrToInt(deshifr(IntToStr(peoples.ammo)));

    readln(f, peoples.bak);
    peoples.bak := StrToInt(deshifr(IntToStr(peoples.bak)));

    readln(f, peoples.speed_ammo);
    peoples.speed_ammo := StrToFloat(deshifr(FloatToStr(peoples.speed_ammo)));

    readln(f, peoples.buy_ammo);
    peoples.buy_ammo := StrToInt(deshifr(IntToStr(peoples.buy_ammo)));

    readln(f, peoples.buy_jet);
    peoples.buy_jet := StrToInt(deshifr(IntToStr(peoples.buy_jet)));

    if login <> peoples.login then
    begin
      writeln(f1, shifr(peoples.login));
      writeln(f1, shifr(peoples.password));
      writeln(f1, shifr(peoples.secret_password));
      writeln(f1, shifr(FloatToStr(peoples.records)));
      writeln(f1, shifr(IntToStr(peoples.sound)));
      writeln(f1, shifr((peoples.complexity)));
      writeln(f1, shifr(IntToStr(peoples.money)));
      writeln(f1, shifr(IntToStr(peoples.ammo)));
      writeln(f1, shifr(IntToStr(peoples.bak)));
      writeln(f1, shifr(FloatToStr(peoples.speed_ammo)));
      writeln(f1, shifr(IntToStr(peoples.buy_ammo)));
      writeln(f1, shifr(IntToStr(peoples.buy_jet)));
    end
    else
    begin
      /// ShowMessage(k1.ToString);
      peoples.sound := k1;
      writeln(f1, shifr(peoples.login));
      writeln(f1, shifr(peoples.password));
      writeln(f1, shifr(peoples.secret_password));
      writeln(f1, shifr(FloatToStr(peoples.records)));
      writeln(f1, shifr(IntToStr(peoples.sound)));
      writeln(f1, shifr((peoples.complexity)));
      writeln(f1, shifr(IntToStr(peoples.money)));
      writeln(f1, shifr(IntToStr(peoples.ammo)));
      writeln(f1, shifr(IntToStr(peoples.bak)));
      writeln(f1, shifr(FloatToStr(peoples.speed_ammo)));
      writeln(f1, shifr(IntToStr(peoples.buy_ammo)));
      writeln(f1, shifr(IntToStr(peoples.buy_jet)));
    end;
  end;
  CloseFile(f);
  CloseFile(f1);

  DeleteFile('input.txt');
  RenameFile('input1.txt', 'input.txt');
  DeleteFile('input1.txt');

end;

procedure change_textfile1(k2: string);
var
  f, f1: textfile;
begin
  AssignFile(f, 'input.txt');
  Reset(f);
  AssignFile(f1, 'input1.txt');
  Rewrite(f1);
  While not eof(f) do
  begin

    readln(f, peoples.login);
    peoples.login := deshifr(peoples.login);

    readln(f, peoples.password);
    peoples.password := deshifr(peoples.password);

    readln(f, peoples.secret_password);
    peoples.secret_password := deshifr(peoples.secret_password);

    readln(f, peoples.records);
    peoples.records := StrToFloat(deshifr(FloatToStr(peoples.records)));

    readln(f, peoples.sound);
    peoples.sound := StrToInt(deshifr(IntToStr(peoples.sound)));

    readln(f, peoples.complexity);
    peoples.complexity := deshifr(peoples.complexity);

    readln(f, peoples.money);
    peoples.money := StrToInt(deshifr(IntToStr(peoples.money)));

    readln(f, peoples.ammo);
    peoples.ammo := StrToInt(deshifr(IntToStr(peoples.ammo)));

    readln(f, peoples.bak);
    peoples.bak := StrToInt(deshifr(IntToStr(peoples.bak)));

    readln(f, peoples.speed_ammo);
    peoples.speed_ammo := StrToFloat(deshifr(FloatToStr(peoples.speed_ammo)));

    readln(f, peoples.buy_ammo);
    peoples.buy_ammo := StrToInt(deshifr(IntToStr(peoples.buy_ammo)));

    readln(f, peoples.buy_jet);
    peoples.buy_jet := StrToInt(deshifr(IntToStr(peoples.buy_jet)));

    if login <> peoples.login then
    begin
      writeln(f1, shifr(peoples.login));
      writeln(f1, shifr(peoples.password));
      writeln(f1, shifr(peoples.secret_password));
      writeln(f1, shifr(FloatToStr(peoples.records)));
      writeln(f1, shifr(IntToStr(peoples.sound)));
      writeln(f1, shifr((peoples.complexity)));
      writeln(f1, shifr(IntToStr(peoples.money)));
      writeln(f1, shifr(IntToStr(peoples.ammo)));
      writeln(f1, shifr(IntToStr(peoples.bak)));
      writeln(f1, shifr(FloatToStr(peoples.speed_ammo)));
      writeln(f1, shifr(IntToStr(peoples.buy_ammo)));
      writeln(f1, shifr(IntToStr(peoples.buy_jet)));
    end
    else
    begin
      /// ShowMessage(k2);
      peoples.complexity := k2;
      writeln(f1, shifr(peoples.login));
      writeln(f1, shifr(peoples.password));
      writeln(f1, shifr(peoples.secret_password));
      writeln(f1, shifr(FloatToStr(peoples.records)));
      writeln(f1, shifr(IntToStr(peoples.sound)));
      writeln(f1, shifr((peoples.complexity)));
      writeln(f1, shifr(IntToStr(peoples.money)));
      writeln(f1, shifr(IntToStr(peoples.ammo)));
      writeln(f1, shifr(IntToStr(peoples.bak)));
      writeln(f1, shifr(FloatToStr(peoples.speed_ammo)));
      writeln(f1, shifr(IntToStr(peoples.buy_ammo)));
      writeln(f1, shifr(IntToStr(peoples.buy_jet)));
    end;
  end;
  CloseFile(f);
  CloseFile(f1);
  DeleteFile('input.txt');
  RenameFile('input1.txt', 'input.txt');
  DeleteFile('input1.txt');

end;

procedure Tfsettings.ComboBox1Change(Sender: TObject);
begin
  case ComboBox1.ItemIndex of
    0:
      begin
        peoples.complexity := 'easy';
        slozhnost := -1;
      end;
    1:
      begin
        peoples.complexity := 'medium';
        slozhnost := 0;
      end;
    2:
      begin
        peoples.complexity := 'hard';
        slozhnost := 1;
      end;
  end;
  change_textfile1(peoples.complexity);

end;

procedure Tfsettings.FormShow(Sender: TObject);
begin

  TrackBar1.Position := sound;
  ComboBox1.ItemIndex := slozhnost + 1;
end;

procedure Tfsettings.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  Perform(WM_SysCommand, $F012, 0);
end;

procedure Tfsettings.lxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  fmenu.show;
  Close;
end;

procedure Tfsettings.lxMouseEnter(Sender: TObject);
begin
  lx.Font.Color := clSilver;
end;

procedure Tfsettings.lxMouseLeave(Sender: TObject);
begin
  lx.Font.Color := clWhite;
end;

procedure SetVolume(const volL, volR: Word);
var
  hWO: HWAVEOUT;
  waveF: TWAVEFORMATEX;
  vol: DWORD;
begin
  FillChar(waveF, SizeOf(waveF), 0);
  waveOutOpen(@hWO, WAVE_MAPPER, @waveF, 0, 0, 0);
  vol := volL + volR shl 16;
  waveOutSetVolume(hWO, vol);
  waveOutClose(hWO);
end;

procedure Tfsettings.TrackBar1Change(Sender: TObject);
var
  ScrollPos: Integer;
begin
  sound := TrackBar1.Position;
  SetVolume(sound, sound);
  change_textfile(TrackBar1.Position);
end;

end.
