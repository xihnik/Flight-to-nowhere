unit shop;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.StdCtrls;

type
  Tfshop = class(TForm)
    Image1: TImage;
    Image2: TImage;
    lplay: TLabel;
    Label1: TLabel;
    Image3: TImage;
    lx: TLabel;
    Panel1: TPanel;
    lyes: TLabel;
    lno: TLabel;
    Memo1: TMemo;
    Image4: TImage;
    lcoin: TLabel;
    lok: TLabel;
    ifon: TImage;
    procedure Image2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lxMouseEnter(Sender: TObject);
    procedure lxMouseLeave(Sender: TObject);
    procedure Image2MouseEnter(Sender: TObject);
    procedure Image2MouseLeave(Sender: TObject);
    procedure Image3MouseEnter(Sender: TObject);
    procedure Image3MouseLeave(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lyesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lnoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lyesMouseEnter(Sender: TObject);
    procedure lnoMouseEnter(Sender: TObject);
    procedure lyesMouseLeave(Sender: TObject);
    procedure lnoMouseLeave(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lokMouseEnter(Sender: TObject);
    procedure lokMouseLeave(Sender: TObject);
    procedure lokMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fshop: Tfshop;
  vibrali: Integer;

implementation

{$R *.dfm}

uses game, gmenu, auth;

procedure Tfshop.FormShow(Sender: TObject);
begin
  lcoin.Caption := peoples.money.ToString;
end;

procedure Tfshop.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  Perform(WM_SysCommand, $F012, 0);
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

procedure change_textfile(k1: Integer; k2: real; k3: Integer; k4: Integer;
  k5: Integer);
var
  f, f1: textfile; // файловая переменная
  del_str: string; // удаляемая строка
  str: string; // временная переменная для считываемых строк
begin
  del_str := 'some string';
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
      peoples.bak := peoples.bak + k1;
      peoples.speed_ammo := peoples.speed_ammo + k2;
      peoples.buy_ammo := peoples.buy_ammo + k3;
      peoples.buy_jet := peoples.buy_jet + k4;
      peoples.money := peoples.money - k5;

      writeln(f1, shifr(peoples.login));
      writeln(f1, shifr(peoples.password));
      writeln(f1, shifr(peoples.secret_password));
      writeln(f1, shifr(FloatToStr(peoples.records)));
      writeln(f1, shifr(IntToStr(peoples.sound)));
      writeln(f1, shifr((peoples.complexity)));
      writeln(f1, shifr(IntToStr(peoples.money)));
      writeln(f1, shifr(IntToStr(peoples.ammo)));
      writeln(f1, shifr(IntToStr(peoples.bak)));
      writeln(f1, shifr(FloatToStr(Trunc(peoples.speed_ammo))));
      writeln(f1, shifr(IntToStr(peoples.buy_ammo)));
      writeln(f1, shifr(IntToStr(peoples.buy_jet)));
    end;
  end;
  CloseFile(f1);
  CloseFile(f);
  Sleep(10);
  DeleteFile('input.txt');
   Sleep(10);
  RenameFile('input1.txt', 'input.txt');
   Sleep(10);
  DeleteFile('input1.txt');
  fshop.lcoin.Caption := peoples.money.ToString;
end;

procedure Tfshop.Image2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  buttonSelected: Integer;
  k1: Integer;
  k2: real;
begin
  fshop.lok.Visible := false;
  fshop.lyes.Visible := true;
  fshop.lno.Visible := true;

  vibrali := 1;
  Panel1.Visible := true;
  Memo1.Text := 'Улучшение стоит ' + (peoples.buy_jet).ToString +
    ' монет, у вас на данный момент ' + peoples.money.ToString +
    ', вы уверены, что хотите приобрести улучшение?';

end;

procedure click1(nomer: Integer);
Var
  k1: Integer;
  k2: real;
  k3, k4, k5: Integer;
begin
  case nomer of
    1:
      begin
        if (peoples.money >= ((peoples.buy_jet))) then
        begin
          k1 := 2;
          k2 := 0;
          k5 := peoples.buy_jet;
          k3 := 0;
          k4 := peoples.buy_jet * 3;

          change_textfile(k1, k2, k3, k4, k5);
          fshop.Panel1.Visible := true;
          fshop.Memo1.Text := 'Вы купили';
          fshop.lok.Visible := true;
          fshop.lyes.Visible := false;
          fshop.lno.Visible := false;
        end
        else
        begin
          fshop.Panel1.Visible := true;
          fshop.Memo1.Text := 'Отказано! У вас слишком мало монет!';
          fshop.lok.Visible := true;
          fshop.lyes.Visible := false;
          fshop.lno.Visible := false;
        end;
      end;
    2:
      begin
        if (peoples.money >= ((peoples.buy_ammo))) then
        begin
          k1 := 0;
          k2 := peoples.speed_ammo * 0.1;
          k3 := peoples.buy_ammo * 4;
          k5 := peoples.buy_ammo;
          k4 := 0;

          change_textfile(k1, k2, k3, k4, k5);
          fshop.Panel1.Visible := true;
          fshop.Memo1.Text := 'Вы купили';
          fshop.lok.Visible := true;
          fshop.lyes.Visible := false;
          fshop.lno.Visible := false;
        end
        else
        begin
          fshop.Panel1.Visible := true;
          fshop.Memo1.Text := 'Отказано! У вас слишком мало монет!';
          fshop.lok.Visible := true;
          fshop.lyes.Visible := false;
          fshop.lno.Visible := false;
        end;
      end;
  end;
  fshop.lcoin.Caption := peoples.money.ToString;
  /// fshop.Panel1.Visible := false;
end;

procedure Tfshop.Image2MouseEnter(Sender: TObject);
begin
  Image2.Picture.LoadFromFile('Resourses\\buttons\\up2.png');
end;

procedure Tfshop.Image2MouseLeave(Sender: TObject);
begin
  Image2.Picture.LoadFromFile('Resourses\\buttons\\up1.png');
end;

procedure Tfshop.Image3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  buttonSelected: Integer;
  k1: Integer;
  k2: real;
begin
  fshop.lok.Visible := false;
  fshop.lyes.Visible := true;
  fshop.lno.Visible := true;
  vibrali := 2;
  Panel1.Visible := true;
  Memo1.Text := 'Улучшение стоит ' + IntToStr(peoples.buy_ammo) +
    ' монет(а), у вас на данный момент ' + peoples.money.ToString +
    ', вы уверены, что хотите приобрести улучшение?';
    lcoin.Caption := peoples.money.ToString;
end;

procedure Tfshop.Image3MouseEnter(Sender: TObject);
begin
  Image3.Picture.LoadFromFile('Resourses\\buttons\\up2.png');
end;

procedure Tfshop.Image3MouseLeave(Sender: TObject);
begin
  Image3.Picture.LoadFromFile('Resourses\\buttons\\up1.png');
end;

procedure Tfshop.lyesMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Var
  k1: Integer;
  k2: real;
begin
  fshop.lok.Visible := false;
  fshop.lyes.Visible := true;
  fshop.lno.Visible := true;
  click1(vibrali);
end;

procedure Tfshop.lyesMouseEnter(Sender: TObject);
begin
  lyes.Font.Color := clSilver;
end;

procedure Tfshop.lyesMouseLeave(Sender: TObject);
begin
  lyes.Font.Color := clWhite;
end;

procedure Tfshop.lnoMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Panel1.Visible := false;
end;

procedure Tfshop.lnoMouseEnter(Sender: TObject);
begin
  lno.Font.Color := clSilver;
end;

procedure Tfshop.lnoMouseLeave(Sender: TObject);
begin
  lno.Font.Color := clWhite;
end;

procedure Tfshop.lokMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Panel1.Visible := false;
end;

procedure Tfshop.lokMouseEnter(Sender: TObject);
begin
  lok.Font.Color := clSilver;
end;

procedure Tfshop.lokMouseLeave(Sender: TObject);
begin
  lok.Font.Color := clWhite;
end;

procedure Tfshop.lxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  fmenu.show;
  Close;
end;

procedure Tfshop.lxMouseEnter(Sender: TObject);
begin
  lx.Font.Color := clSilver;
end;

procedure Tfshop.lxMouseLeave(Sender: TObject);
begin
  lx.Font.Color := clWhite;
end;

end.
