unit auth;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, gmenu, Vcl.MPlayer, Math, MMSystem, reg;

type
  Tfauth = class(TForm)
    Image1: TImage;
    llogin: TEdit;
    lpass: TEdit;
    lnet_akk: TLabel;
    lzab_pass: TLabel;
    lenter: TLabel;
    lx: TLabel;
    MediaPlayer1: TMediaPlayer;
    Panel1: TPanel;
    lok: TLabel;
    Memo1: TMemo;
    ifon: TImage;
    lHelp: TLabel;
    procedure lxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lenterMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lenterMouseEnter(Sender: TObject);
    procedure lenterMouseLeave(Sender: TObject);
    procedure lnet_akkMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lzab_passMouseEnter(Sender: TObject);
    procedure lzab_passMouseLeave(Sender: TObject);
    procedure lnet_akkMouseEnter(Sender: TObject);
    procedure lnet_akkMouseLeave(Sender: TObject);
    procedure lzab_passMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lxMouseEnter(Sender: TObject);
    procedure lxMouseLeave(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MediaPlayer1Notify(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lokMouseEnter(Sender: TObject);
    procedure lokMouseLeave(Sender: TObject);
    procedure lokMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lHelpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lHelpMouseEnter(Sender: TObject);
    procedure lHelpMouseLeave(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fauth: Tfauth;

  peoples: Men;
  r: Integer;
  sound, slozhnost: Integer;
  rates: real;
  login: string;

implementation

{$R *.dfm}

uses zab_pass;

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

procedure Tfauth.lxMouseEnter(Sender: TObject);
begin
  lx.Font.Color := clSilver;
end;

procedure Tfauth.lxMouseLeave(Sender: TObject);
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

procedure Tfauth.FormCreate(Sender: TObject);
begin
  showf := true;
  sound := 2000;
end;

procedure Tfauth.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  Perform(WM_SysCommand, $F012, 0);
end;

function proverka_napisanogo(stroka1: string; stroka2: string): boolean;
Var
  i: Integer;
  proverka: boolean;
begin
  proverka := true;

  for i := 1 to length(stroka1) do
    if not(stroka1[i] in ['A' .. 'Z', 'a' .. 'z', '0' .. '9']) then
      proverka := false;

  for i := 1 to length(stroka2) do
    if not(stroka2[i] in ['A' .. 'Z', 'a' .. 'z', '0' .. '9']) then
      proverka := false;
  result := proverka;
end;

procedure Tfauth.lenterMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Var
  bil: boolean;
  file_input: textfile;
  str_deshifr: string;
begin

  if (llogin.Text = '') or (lpass.Text = '') then
  begin
    Memo1.Text := 'Поля не могут быть пустыми!';
    Panel1.Visible := true;
    exit;
  end;

  If (proverka_napisanogo(llogin.Text, lpass.Text) = false) then
  begin
    Memo1.Text := 'Проверьте правильность данных';
    Panel1.Visible := true;
    exit;
  end;
  if (FileExists('input.txt')) then
  begin
    assignfile(file_input, 'input.txt');
    reset(file_input);
    bil := false;
    while not eof(file_input) do
    begin
      readln(file_input, peoples.login);
      peoples.login := deshifr(peoples.login);

      readln(file_input, peoples.password);
      peoples.password := deshifr(peoples.password);

      readln(file_input, peoples.secret_password);
      peoples.secret_password := deshifr(peoples.secret_password);

      readln(file_input, peoples.records);
      peoples.records := StrToFloat(deshifr(FloatToStr(peoples.records)));

      readln(file_input, peoples.sound);
      peoples.sound := StrToInt(deshifr(IntToStr(peoples.sound)));

      readln(file_input, peoples.complexity);
      peoples.complexity := deshifr(peoples.complexity);

      readln(file_input, peoples.money);
      peoples.money := StrToInt(deshifr(IntToStr(peoples.money)));

      readln(file_input, peoples.ammo);
      peoples.ammo := StrToInt(deshifr(IntToStr(peoples.ammo)));

      readln(file_input, peoples.bak);
      peoples.bak := StrToInt(deshifr(IntToStr(peoples.bak)));

      readln(file_input, peoples.speed_ammo);
      peoples.speed_ammo := StrToFloat(deshifr(FloatToStr(peoples.speed_ammo)));

      readln(file_input, peoples.buy_ammo);
      peoples.buy_ammo := StrToInt(deshifr(IntToStr(peoples.buy_ammo)));

      readln(file_input, peoples.buy_jet);
      peoples.buy_jet := StrToInt(deshifr(IntToStr(peoples.buy_jet)));

      if ((peoples.login = llogin.Text) and (peoples.password = lpass.Text))
      then
      begin
        rates := peoples.records;
        bil := true;
        sound := peoples.sound;

        if (peoples.complexity = 'easy') then
          slozhnost := -1;
        if (peoples.complexity = 'medium') then
          slozhnost := 0;
        if (peoples.complexity = 'hard') then
          slozhnost := 1;

        login := llogin.Text;
        CloseFile(file_input);
        fmenu.Show;
        Hide;
        exit;
      end;

    end;
    CloseFile(file_input);
  end
  else
  begin
    Memo1.Text :=
      'Ошибка, вы вероятнее всего еще не создали аккаунт, пройдите регистрацию!';
    Panel1.Visible := true;
  end;
  if (bil = false) then
  begin
    Memo1.Text := 'Такого пользователя нету';
    Panel1.Visible := true;
  end;

end;

procedure Tfauth.lenterMouseEnter(Sender: TObject);
begin
  lenter.Font.Color := clSilver;
end;

procedure Tfauth.lenterMouseLeave(Sender: TObject);
begin
  lenter.Font.Color := clWhite;
end;

procedure Tfauth.lHelpMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  WinExec('hh.exe Resourses\Help.chm', SW_SHOW);
end;

procedure Tfauth.lHelpMouseEnter(Sender: TObject);
begin
  lHelp.Font.Color := clSilver;
end;

procedure Tfauth.lHelpMouseLeave(Sender: TObject);
begin
  lHelp.Font.Color := clWhite;
end;

procedure Tfauth.lzab_passMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  fzab_pass.Show;
  Hide;
end;

procedure Tfauth.lzab_passMouseEnter(Sender: TObject);
begin
  lzab_pass.Font.Color := clSilver;
end;

procedure Tfauth.lzab_passMouseLeave(Sender: TObject);
begin
  lzab_pass.Font.Color := clWhite;
end;

procedure Tfauth.MediaPlayer1Notify(Sender: TObject);
Var
  rand: Integer;
begin
  randomize;
  rand := randomrange(2, 11);
  if MediaPlayer1.Mode = mpStopped then
  begin
    MediaPlayer1.FileName := 'Resourses//music//' + rand.ToString + '.mp3';
    MediaPlayer1.Open;
    MediaPlayer1.Play;
  end;
end;

procedure Tfauth.lnet_akkMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  freg.Show;
  Hide;
end;

procedure Tfauth.lnet_akkMouseEnter(Sender: TObject);
begin
  lnet_akk.Font.Color := clSilver;
end;

procedure Tfauth.lnet_akkMouseLeave(Sender: TObject);
begin
  lnet_akk.Font.Color := clWhite;
end;

procedure Tfauth.lokMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Panel1.Visible := false;
end;

procedure Tfauth.lokMouseEnter(Sender: TObject);
begin
  lok.Font.Color := clSilver;
end;

procedure Tfauth.lokMouseLeave(Sender: TObject);
begin
  lok.Font.Color := clWhite;
end;

procedure Tfauth.lxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Close;
end;

end.
