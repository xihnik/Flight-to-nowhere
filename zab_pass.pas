unit zab_pass;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, reg, auth;

type
  Tfzab_pass = class(TForm)
    Image1: TImage;
    lsecret: TEdit;
    Lreg: TLabel;
    llogin: TEdit;
    lx: TLabel;
    Panel1: TPanel;
    lok: TLabel;
    Memo1: TMemo;
    ifon: TImage;
    procedure LregMouseEnter(Sender: TObject);
    procedure LregMouseLeave(Sender: TObject);
    procedure LregMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lxMouseEnter(Sender: TObject);
    procedure lxMouseLeave(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lokMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lokMouseEnter(Sender: TObject);
    procedure lokMouseLeave(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fzab_pass: Tfzab_pass;

implementation

{$R *.dfm}

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

procedure Tfzab_pass.lxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  fauth.Show;
  Close;
end;

procedure Tfzab_pass.lxMouseEnter(Sender: TObject);
begin
  lx.Font.Color := clSilver;
end;

procedure Tfzab_pass.lxMouseLeave(Sender: TObject);
begin
  lx.Font.Color := clWhite;
end;

procedure Tfzab_pass.FormShow(Sender: TObject);
begin
llogin.Text:='';
lsecret.Text:='';
  Panel1.Visible := false;
end;

procedure Tfzab_pass.Image1MouseDown(Sender: TObject; Button: TMouseButton;
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

procedure Tfzab_pass.lokMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Panel1.Visible := false;
end;

procedure Tfzab_pass.lokMouseEnter(Sender: TObject);
begin
  lok.Font.Color := clWhite;
end;

procedure Tfzab_pass.lokMouseLeave(Sender: TObject);
begin
  lok.Font.Color := clSilver;
end;

procedure Tfzab_pass.LregMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Var
  bil: boolean;
  file_input: textfile;
begin

  if (llogin.Text = '') or (lsecret.Text = '') then
  begin
    Panel1.Visible := true;
    Memo1.Text := 'Поля не могут быть пустыми!';
    exit;
  end;

  If (proverka_napisanogo(llogin.Text, lsecret.Text) = false) then
  begin
    Panel1.Visible := true;
    Memo1.Text := 'Проверьте правильность данных';
    exit;
  end;
  if (FileExists('input.txt')) then
  begin
    assignfile(file_input, 'input.txt');
    reset(file_input);
    bil := false;
    while (not Eof(file_input)) do
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
        if (peoples.secret_password = lsecret.Text) then
        begin
          Panel1.Visible := true;
          Memo1.Text := 'Ваш пароль "' + peoples.password + '"';
          /// ShowMessage('Ваш пароль "' + peoples.password + '"');
          bil := true;
        end

      end
    end;
    CloseFile(file_input);
    if (bil = false) then
    begin
      Panel1.Visible := true;
      Memo1.Text := 'Такого пользователя не нашлось';
    end

  end
  else
  begin
    /// ShowMessage('Такого пользователя не нашлось');
    Panel1.Visible := true;
    Memo1.Text := 'Такого пользователя не нашлось';
  end;

end;

procedure Tfzab_pass.LregMouseEnter(Sender: TObject);
begin
  Lreg.Font.Color := clSilver;
end;

procedure Tfzab_pass.LregMouseLeave(Sender: TObject);
begin
  Lreg.Font.Color := clWhite;
end;

end.
