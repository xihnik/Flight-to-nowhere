unit reg;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, clipbrd;

type
  Tfreg = class(TForm)
    Image1: TImage;
    llogin: TEdit;
    lpass: TEdit;
    lpass2: TEdit;
    lsecret: TEdit;
    Lreg: TLabel;
    lx: TLabel;
    Panel1: TPanel;
    lok: TLabel;
    Memo1: TMemo;
    Timer1: TTimer;
    ifon: TImage;
    procedure lxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LregMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LregMouseEnter(Sender: TObject);
    procedure LregMouseLeave(Sender: TObject);
    procedure lxMouseEnter(Sender: TObject);
    procedure lxMouseLeave(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lokMouseEnter(Sender: TObject);
    procedure lokMouseLeave(Sender: TObject);
    procedure lokMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Type
  Men = record
    login, password, secret_password, complexity: string;
    sound, money, ammo, bak, buy_ammo, buy_jet: Integer;
    speed_ammo: real;
    records: real;
  end;

var
  freg: Tfreg;

  peoples: Men;

implementation

{$R *.dfm}

uses auth;

procedure Tfreg.FormHide(Sender: TObject);
begin
  Timer1.Enabled := false;
end;

procedure Tfreg.FormShow(Sender: TObject);
begin
  freg.llogin.Text := '';
  freg.lpass.Text := '';
  freg.lpass2.Text := '';
  freg.lsecret.Text := '';
  Timer1.Enabled := true;
end;

procedure Tfreg.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  Perform(WM_SysCommand, $F012, 0);
end;

function proverka_napisanogo(stroka1, stroka2, stroka3,
  stroka4: string): boolean;
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

  for i := 1 to length(stroka3) do
    if not(stroka3[i] in ['A' .. 'Z', 'a' .. 'z', '0' .. '9']) then
      proverka := false;

  for i := 1 to length(stroka4) do
    if not(stroka4[i] in ['A' .. 'Z', 'a' .. 'z', '0' .. '9']) then
      proverka := false;

  result := proverka;
end;

procedure Tfreg.lokMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Panel1.Visible := false;
end;

procedure Tfreg.lokMouseEnter(Sender: TObject);
begin
  lok.Font.Color := clSilver;
end;

procedure Tfreg.lokMouseLeave(Sender: TObject);
begin
  lok.Font.Color := clWhite;
end;

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

procedure Tfreg.LregMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Var
  i: Integer;
  file_input: textfile;
  propysk, zah, dezah: string;
  bil: boolean;
begin

  if (llogin.Text = '') or (lpass.Text = '') or (lpass2.Text = '') or
    (lsecret.Text = '') then
  begin
    Memo1.Text := 'Поля не могут быть пустыми!';
    Panel1.Visible := true;
    exit;
  end;

  If (proverka_napisanogo(llogin.Text, lpass.Text, lpass2.Text, lsecret.Text)
    = false) then
  begin
    Memo1.Text := 'Проверьте правильность данных';
    Panel1.Visible := true;
    exit;
  end;

  if (lpass.Text <> lpass2.Text) then
  begin
    Memo1.Text := 'Пароли не совпадают!';
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

      if (peoples.login = llogin.Text) then
      begin
        bil := true;
      end
    end;
    if (bil = false) then
    begin
      If (proverka_napisanogo(llogin.Text, lpass.Text, lpass2.Text,
        lsecret.Text) = false) then
      begin
        Memo1.Text := 'Проверьте правильность данных';
        Panel1.Visible := true;
        exit;
      end;
    end;
    CloseFile(file_input);

  end;

  if (not FileExists('input.txt')) then
  begin
    assignfile(file_input, 'input.txt');
    Rewrite(file_input);
    CloseFile(file_input);
  end;

  assignfile(file_input, 'input.txt');
  Append(file_input);

  peoples.login := (llogin.Text);
  peoples.password := (lpass.Text);
  peoples.secret_password := (lsecret.Text);
  peoples.records := 0;
  peoples.sound := 10000;
  peoples.complexity := 'easy';
  peoples.money := 0;
  peoples.ammo := 0;
  peoples.bak := 2;
  peoples.speed_ammo := 3;
  peoples.buy_ammo := 5;
  peoples.buy_jet := 3;
  writeln(file_input, shifr(peoples.login));
  writeln(file_input, shifr(peoples.password));
  writeln(file_input, shifr(peoples.secret_password));
  writeln(file_input, shifr(FloatToStr(peoples.records)));
  writeln(file_input, shifr(IntToStr(peoples.sound)));
  writeln(file_input, shifr((peoples.complexity)));
  writeln(file_input, shifr(IntToStr(peoples.money)));
  writeln(file_input, shifr(IntToStr(peoples.ammo)));
  writeln(file_input, shifr(IntToStr(peoples.bak)));
  writeln(file_input, shifr(FloatToStr(peoples.speed_ammo)));
  writeln(file_input, shifr(IntToStr(peoples.buy_ammo)));
  writeln(file_input, shifr(IntToStr(peoples.buy_jet)));

  Memo1.Text := 'Пользователь был зарегистрирован!';
  Panel1.Visible := true;

  if (bil = true) then
  begin
    Memo1.Text := 'Пользователь с таким именем уже существует';
    Panel1.Visible := true;
  end;
  CloseFile(file_input);
end;

procedure Tfreg.LregMouseEnter(Sender: TObject);
begin
  Lreg.Font.Color := clSilver;
end;

procedure Tfreg.LregMouseLeave(Sender: TObject);
begin
  Lreg.Font.Color := clWhite;
end;

procedure Tfreg.lxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  fauth.Show;
  Close;
end;

procedure Tfreg.lxMouseEnter(Sender: TObject);
begin
  lx.Font.Color := clSilver;
end;

procedure Tfreg.lxMouseLeave(Sender: TObject);
begin
  lx.Font.Color := clWhite;
end;

procedure Tfreg.Timer1Timer(Sender: TObject);
begin
  try
    Clipboard.asText :=
      'На данном моменте копировать-вставить использовать нельзя!';

  except

  end;
end;

end.
