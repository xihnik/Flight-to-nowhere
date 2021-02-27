unit game;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, MATH, Vcl.StdCtrls,
  Vcl.Imaging.pngimage;

type
  Tfgame = class(TForm)
    Timer1: TTimer;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    lcoin: TLabel;
    lammo: TLabel;
    ldistance: TLabel;
    lheart: TLabel;
    llocation: TLabel;
    Image6: TImage;
    ljet: TLabel;
    Panel1: TPanel;
    lyes: TLabel;
    lno: TLabel;
    Memo1: TMemo;
    ifon: TImage;
    procedure Timer1Timer(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure lyesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lnoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lyesMouseEnter(Sender: TObject);
    procedure lyesMouseLeave(Sender: TObject);
    procedure lnoMouseEnter(Sender: TObject);
    procedure lnoMouseLeave(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Type
  Tround = object
    X, Y: Integer;
    fly: boolean;
    procedure draw();
    procedure popal(i: Integer);
  end;

  Tnow = object
    rates, money, ammo, health: Integer;
  end;

  Tmessage = object
    pynkt: Integer;
  end;

  Tglobal = object
    int, speed: Integer;
  end;

  Tbullet = object
    now, all: Integer;
  end;

  Tcenter = object
    X, Y: Integer;
  end;

  Tplayer = object
    X, Y: Integer;
    rasstoianie, money, ammo: Integer;
    view_men: Integer;
  end;

  Tground = object
    X, Y: Integer;
    seychas_vnizy: boolean;
  end;

  Tii = object
    X, Y, move, health: Integer;
    agry_on_player, create, wait: boolean;
    frequency: Integer;
    storona: boolean;
    procedure popadanie_in_robot;
  end;

  Tmoney = object
    X, Y, move: Integer;
    create, vverx, platforma, platforma_yzhe, wait: boolean;
    frequency: Integer;
  end;

  Tammo = object(Tmoney)
  end;

  Tlocation = object
    number: Integer;
    new, pomenialos: boolean;
  end;

var
  fgame: Tfgame;
  my: record mbullet: array [1 .. 100] of Tround;
  fly_bullet: Tround;
  now: Tnow;
  player: Tplayer;
  Message: Tmessage;
  global: Tglobal;
  bullet: Tbullet;
  center: Tcenter;
  ground: Tground;
  ii: Tii;
  money: Tmoney;
  ammo: Tammo;
  location: Tlocation;
end;

implementation

{$R *.dfm}

uses gmenu, auth;

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

procedure Tround.popal(i: Integer);
begin
  if (Y + 33 > my.ii.Y) AND (Y < my.ii.Y + 146) and (X + 13 > my.ii.X) and
    (X < my.ii.X + 88) then
  begin
    if (my.ii.health <= 0) then
    begin
      my.ii.Y := -1000;
      my.ii.X := -1000;
      my.player.rasstoianie := 0;
      my.ii.create := false;
      my.ii.move := 0;
      my.ii.agry_on_player := false;

      my.mbullet[i].fly := false;

      fgame.lammo.caption := my.now.ammo.ToString;
    end
    else
    begin
      my.mbullet[i].fly := false;
      dec(my.ii.health, 50);
      fgame.lammo.caption := my.now.ammo.ToString;
    end;
  end;
end;

procedure Tii.popadanie_in_robot;

var
  i: Integer;
begin
  for i := 1 to my.bullet.all do
    my.mbullet[i].popal(i);
end;

procedure init_bullet;

Var
  i: Integer;
  bil: boolean;
begin
  my.ii.popadanie_in_robot;

  bil := false;
  if (my.bullet.now > 0) then
  begin
    for i := 1 to my.bullet.all do
    begin
      if (my.mbullet[i].fly) then
      begin
        bil := true;
        if (my.mbullet[i].Y > -50) then
        begin
          dec(my.mbullet[i].Y, Trunc(peoples.speed_ammo));
          my.mbullet[i].draw();
        end
        else
        begin
          my.mbullet[i].fly := false;
        end;
      end;
    end;
    if (bil = false) then
    begin
      my.bullet.now := 0;
      my.bullet.all := 0;
    end;
  end;

end;

procedure change_textfile(k1: real);

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
      peoples.records := k1;
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

procedure change_money(k1: Integer);

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
      peoples.money := k1;
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

procedure change_ammo(k1: Integer);

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
      peoples.ammo := k1;
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

procedure clean;
begin
  with fgame.Image1.Canvas do
  begin
    Brush.Color := ClBlack;
    Rectangle(0, 0, fgame.Width, fgame.Height);
  end;
end;

procedure yvelichenie_speed();
begin
  if (my.location.pomenialos) then
  begin
    case sl of
      - 1:
        iF (my.global.speed <= 30) then
          inc(my.global.speed, 4);
      0:
        iF (my.global.speed <= 30) then
          inc(my.global.speed, 6);
      1:
        iF (my.global.speed <= 30) then
          inc(my.global.speed, 8);
    end;
    my.location.pomenialos := false;
  end;
end;

procedure location;

Var
  bm1, bm2: TBitmap;
begin
  with fgame.Image1.Canvas do
  begin
    case my.location.number of
      1:
        begin
          if (my.location.new = false) then
          begin
            Brush.Color := ClWhite;
            bm1 := TBitmap.create;
            bm1.LoadFromFile('Resourses\locations\earthl1.bmp');
            bm2 := TBitmap.create;
            bm2.Width := fgame.Width;
            bm2.Height := fgame.Height;
            bm2.Canvas.Brush.Bitmap := bm1;
            bm2.Canvas.FillRect(bm2.Canvas.ClipRect);
            StretchDraw(Rect(0, 0, fgame.Width, fgame.Height), bm1);

            bm2.Free;
            bm1.Free;
            my.location.new := true;
          end
          else
          begin
            Brush.Color := ClWhite;
            bm1 := TBitmap.create;
            bm1.LoadFromFile('Resourses\locations\earth11.bmp');
            bm2 := TBitmap.create;
            bm2.Width := fgame.Width;
            bm2.Height := fgame.Height;
            bm2.Canvas.Brush.Bitmap := bm1;
            bm2.Canvas.FillRect(bm2.Canvas.ClipRect);
            StretchDraw(Rect(0, 0, fgame.Width, fgame.Height), bm1);
            my.location.new := false;
            bm2.Free;
            bm1.Free;
          end;
          fgame.llocation.caption := 'Земля';
        end;
      2:
        begin
          if (my.location.new = false) then
          begin
            Brush.Color := ClWhite;
            bm1 := TBitmap.create;
            bm1.LoadFromFile('Resourses\locations\marthl1.bmp');
            bm2 := TBitmap.create;
            bm2.Width := fgame.Width;
            bm2.Height := fgame.Height;
            bm2.Canvas.Brush.Bitmap := bm1;
            bm2.Canvas.FillRect(bm2.Canvas.ClipRect);
            StretchDraw(Rect(0, 0, fgame.Width, fgame.Height), bm1);

            bm2.Free;
            bm1.Free;
            my.location.new := true;
          end
          else
          begin
            Brush.Color := ClWhite;
            bm1 := TBitmap.create;
            bm1.LoadFromFile('Resourses\locations\marth11.bmp');
            bm2 := TBitmap.create;
            bm2.Width := fgame.Width;
            bm2.Height := fgame.Height;
            bm2.Canvas.Brush.Bitmap := bm1;
            bm2.Canvas.FillRect(bm2.Canvas.ClipRect);
            StretchDraw(Rect(0, 0, fgame.Width, fgame.Height), bm1);
            my.location.new := false;
            bm2.Free;
            bm1.Free;
          end;
          fgame.llocation.caption := 'Марс';
        end;
      3:
        begin
          if (my.location.new = false) then
          begin
            Brush.Color := ClWhite;
            bm1 := TBitmap.create;
            bm1.LoadFromFile('Resourses\locations\Mercuriy11.bmp');
            bm2 := TBitmap.create;
            bm2.Width := fgame.Width;
            bm2.Height := fgame.Height;
            bm2.Canvas.Brush.Bitmap := bm1;
            bm2.Canvas.FillRect(bm2.Canvas.ClipRect);
            StretchDraw(Rect(0, 0, fgame.Width, fgame.Height), bm1);

            bm2.Free;
            bm1.Free;
            my.location.new := true;
          end
          else
          begin
            Brush.Color := ClWhite;
            bm1 := TBitmap.create;
            bm1.LoadFromFile('Resourses\locations\Mercuriyl1.bmp');
            bm2 := TBitmap.create;
            bm2.Width := fgame.Width;
            bm2.Height := fgame.Height;
            bm2.Canvas.Brush.Bitmap := bm1;
            bm2.Canvas.FillRect(bm2.Canvas.ClipRect);
            StretchDraw(Rect(0, 0, fgame.Width, fgame.Height), bm1);
            my.location.new := false;
            bm2.Free;
            bm1.Free;
          end;
          fgame.llocation.caption := 'Меркурий';
        end;
      4:
        begin
          if (my.location.new = false) then
          begin
            Brush.Color := ClWhite;
            bm1 := TBitmap.create;
            bm1.LoadFromFile('Resourses\locations\Upiter11.bmp');
            bm2 := TBitmap.create;
            bm2.Width := fgame.Width;
            bm2.Height := fgame.Height;
            bm2.Canvas.Brush.Bitmap := bm1;
            bm2.Canvas.FillRect(bm2.Canvas.ClipRect);
            StretchDraw(Rect(0, 0, fgame.Width, fgame.Height), bm1);

            bm2.Free;
            bm1.Free;
            my.location.new := true;
          end
          else
          begin
            Brush.Color := ClWhite;
            bm1 := TBitmap.create;
            bm1.LoadFromFile('Resourses\locations\Upiterl1.bmp');
            bm2 := TBitmap.create;
            bm2.Width := fgame.Width;
            bm2.Height := fgame.Height;
            bm2.Canvas.Brush.Bitmap := bm1;
            bm2.Canvas.FillRect(bm2.Canvas.ClipRect);
            StretchDraw(Rect(0, 0, fgame.Width, fgame.Height), bm1);
            my.location.new := false;
            bm2.Free;
            bm1.Free;
          end;
          fgame.llocation.caption := 'Юпитер';
        end;
      5:
        begin
          if (my.location.new = false) then
          begin
            Brush.Color := ClWhite;
            bm1 := TBitmap.create;
            bm1.LoadFromFile('Resourses\locations\Venera11.bmp');
            bm2 := TBitmap.create;
            bm2.Width := fgame.Width;
            bm2.Height := fgame.Height;
            bm2.Canvas.Brush.Bitmap := bm1;
            bm2.Canvas.FillRect(bm2.Canvas.ClipRect);
            StretchDraw(Rect(0, 0, fgame.Width, fgame.Height), bm1);

            bm2.Free;
            bm1.Free;
            my.location.new := true;
          end
          else
          begin
            Brush.Color := ClWhite;
            bm1 := TBitmap.create;
            bm1.LoadFromFile('Resourses\locations\Veneral1.bmp');
            bm2 := TBitmap.create;
            bm2.Width := fgame.Width;
            bm2.Height := fgame.Height;
            bm2.Canvas.Brush.Bitmap := bm1;
            bm2.Canvas.FillRect(bm2.Canvas.ClipRect);
            StretchDraw(Rect(0, 0, fgame.Width, fgame.Height), bm1);
            my.location.new := false;
            bm2.Free;
            bm1.Free;
          end;
          fgame.llocation.caption := 'Венера';
        end;
      6:
        begin
          if (my.location.new = false) then
          begin
            Brush.Color := ClWhite;
            bm1 := TBitmap.create;
            bm1.LoadFromFile('Resourses\locations\Sun11.bmp');
            bm2 := TBitmap.create;
            bm2.Width := fgame.Width;
            bm2.Height := fgame.Height;
            bm2.Canvas.Brush.Bitmap := bm1;
            bm2.Canvas.FillRect(bm2.Canvas.ClipRect);
            StretchDraw(Rect(0, 0, fgame.Width, fgame.Height), bm1);

            bm2.Free;
            bm1.Free;
            my.location.new := true;
          end
          else
          begin
            Brush.Color := ClWhite;
            bm1 := TBitmap.create;
            bm1.LoadFromFile('Resourses\locations\Sunl1.bmp');
            bm2 := TBitmap.create;
            bm2.Width := fgame.Width;
            bm2.Height := fgame.Height;
            bm2.Canvas.Brush.Bitmap := bm1;
            bm2.Canvas.FillRect(bm2.Canvas.ClipRect);
            StretchDraw(Rect(0, 0, fgame.Width, fgame.Height), bm1);
            my.location.new := false;
            bm2.Free;
            bm1.Free;
          end;
          fgame.llocation.caption := 'Солнце';
        end;
    end;
  end;
end;

procedure men(Chto, X, Y: Integer);

Var
  bm1, bm2: TBitmap;
begin
  with fgame.Image1.Canvas do
  begin
    case Chto of
      1:
        begin
          Brush.Color := ClBlack;
          bm1 := TBitmap.create;
          bm1.LoadFromFile('Resourses\Characters\irobot.bmp');
          bm2 := TBitmap.create;
          bm2.Width := 88;
          bm2.Height := 146;
          bm2.Canvas.Brush.Bitmap := bm1;
          bm2.Canvas.FillRect(bm2.Canvas.ClipRect);

          bm2.Transparent := true;
          draw(X, Y, bm2);

          bm2.Free;
          bm1.Free;
        end;
      2:
        begin
          Brush.Color := ClBlack;
          bm1 := TBitmap.create;
          bm1.LoadFromFile('Resourses\Characters\rirobot.bmp');
          bm2 := TBitmap.create;
          bm2.Width := 88;
          bm2.Height := 146;
          bm2.Canvas.Brush.Bitmap := bm1;
          bm2.Canvas.FillRect(bm2.Canvas.ClipRect);

          bm2.Transparent := true;
          draw(X, Y, bm2);

          bm2.Free;
          bm1.Free;
        end;
      3:
        begin
          Brush.Color := ClBlack;
          bm1 := TBitmap.create;
          bm1.LoadFromFile('Resourses\Characters\lirobot.bmp');
          bm2 := TBitmap.create;
          bm2.Width := 88;
          bm2.Height := 146;
          bm2.Canvas.Brush.Bitmap := bm1;
          bm2.Canvas.FillRect(bm2.Canvas.ClipRect);

          bm2.Transparent := true;
          draw(X, Y, bm2);

          bm2.Free;
          bm1.Free;
        end;
      4:
        begin
          Brush.Color := ClBlack;
          bm1 := TBitmap.create;
          bm1.LoadFromFile('Resourses\Characters\jirobot.bmp');
          bm2 := TBitmap.create;
          bm2.Width := 88;
          bm2.Height := 146;
          bm2.Canvas.Brush.Bitmap := bm1;
          bm2.Canvas.FillRect(bm2.Canvas.ClipRect);

          bm2.Transparent := true;
          draw(X, Y, bm2);

          bm2.Free;
          bm1.Free;
        end;
    end;
  end;
end;

procedure endthegame();

Var
  buttonSelected: Integer;
begin

  if (besk) then
  begin
    change_textfile(my.now.rates);
    change_money(peoples.money);

    if (my.now.rates > rates) then
    begin
      fgame.Memo1.Text := 'Игра проиграна! Вы побили свой рекорд! Ваш рекорд: '
        + my.now.rates.ToString + '. Вы хотите переиграть?';
      fgame.Panel1.Visible := true;
      my.Message.pynkt := 2;
      fgame.lcoin.caption := '0';
      fgame.lammo.caption := '0';
      fgame.llocation.caption := '0';
      fgame.lheart.caption := '3';
    end
    else
    begin
      fgame.Memo1.Text := 'Игра проиграна! Ваш рекорд: ' + my.now.rates.ToString
        + '. Вы хотите переиграть?';
      fgame.Panel1.Visible := true;
      my.Message.pynkt := 3;
      fgame.lcoin.caption := '0';
      fgame.lammo.caption := '0';
      fgame.llocation.caption := '0';
      fgame.lheart.caption := '3';
    end;
  end
  else
  begin
    change_money(peoples.money);

    if (my.location.number = 7) and (not besk) then
    begin
      fgame.Memo1.Text := 'Вы достигли конца! Пролетевшее расстояние: ' +
        my.now.rates.ToString + '. Вы хотите переиграть?';
      fgame.Panel1.Visible := true;
      my.Message.pynkt := 3;
      fgame.lcoin.caption := '0';
      fgame.lammo.caption := '0';
      fgame.llocation.caption := '0';
      fgame.lheart.caption := '3';
      exit;
    end;

    fgame.Memo1.Text := 'Игра проиграна! Ваш рекорд: ' + my.now.rates.ToString +
      '. Вы хотите переиграть?';
    fgame.Panel1.Visible := true;
    my.Message.pynkt := 4;
    fgame.lcoin.caption := '0';
    fgame.lammo.caption := '0';
    fgame.llocation.caption := '0';
    fgame.lheart.caption := '3';
  end;

end;

procedure health_finish(who: Integer);
begin
  inc(my.now.health);
  case who of
    1:
      begin
        case my.now.health of
          3:
            begin
              my.ground.Y := 0;
              my.ground.X := -1000;

              if (my.ammo.create) and (my.ammo.platforma_yzhe) then
              begin
                my.ammo.vverx := true;
              end;

              if (my.money.create) and (my.money.platforma_yzhe) then
              begin
                my.money.vverx := true;
              end;

              if (my.ii.create) then
              begin
                my.ii.create := false;
                my.ii.Y := -1000;
                my.ii.X := -1000;
                my.player.rasstoianie := 0;
                my.ii.create := false;
                my.ii.move := 0;
                my.ii.agry_on_player := false;
              end;

              fgame.Timer1.Enabled := false;
              endthegame;
              exit;
            end
        else
          begin
            my.ground.Y := 0;
            my.ground.X := -1000;

            if (my.ammo.create) and (my.ammo.platforma_yzhe) then
            begin
              my.ammo.vverx := true;
            end;

            if (my.money.create) and (my.money.platforma_yzhe) then
            begin
              my.money.vverx := true;
            end;

            if (my.ii.create = true) then
            begin
              my.ii.create := false;
              my.ii.Y := -1000;
              my.ii.X := -1000;
              my.player.rasstoianie := 0;
              my.ii.create := false;
              my.ii.move := 0;
              my.ii.agry_on_player := false;
            end;
          end;
        end;
      end;
    2:
      case my.now.health of
        3:
          begin
            my.player.Y := 0;
            my.player.X := -1000;
            fgame.Timer1.Enabled := false;
            endthegame;
            exit;
          end
      else
        begin
          my.ii.create := false;
          my.ii.agry_on_player := false;
          my.ii.wait := false;
          my.ii.Y := -1000;
          my.ii.X := -1000;
        end;
      end;
  end;
  fgame.lheart.caption := (3 - my.now.health).ToString;
end;

procedure finish;
begin
  /// GROUND
  if (my.player.Y + 146 > my.ground.Y) AND (my.player.Y < my.ground.Y + 25) and
    (my.player.X + 88 > my.ground.X) and (my.player.X < my.ground.X + 300) then
    health_finish(1);
  /// ROB
  if (my.player.Y + 146 > my.ii.Y) AND (my.player.Y < my.ii.Y + 146) and
    (my.player.X + 88 > my.ii.X) and (my.player.X < my.ii.X + 88) then
    health_finish(2);

  if (my.location.number = 7) then
  begin
    if (not besk) then
    begin
      fgame.Timer1.Enabled := false;
      endthegame;
      exit;
    end
    else
      my.location.number := 1;
  end;

end;

procedure Tround.draw();

Var
  bm1, bm2: TBitmap;
begin
  with fgame.Image1.Canvas do
  begin
    Brush.Color := ClWhite;
    bm1 := TBitmap.create;
    bm1.LoadFromFile('Resourses\Help\round.bmp');
    bm2 := TBitmap.create;
    bm2.Width := 13;
    bm2.Height := 33;
    bm2.Canvas.Brush.Bitmap := bm1;
    bm2.Canvas.FillRect(bm2.Canvas.ClipRect);
    bm2.TransparentColor := ClWhite;
    bm2.Transparent := true;
    draw(X, Y, bm2);

    bm2.Free;
    bm1.Free;
  end;
end;

procedure ground(X, Y: Integer);

Var
  bm1, bm2: TBitmap;
begin
  with fgame.Image1.Canvas do
  begin
    Brush.Color := ClWhite;
    bm1 := TBitmap.create;
    bm1.LoadFromFile('Resourses\Blocks\meteor.bmp');
    bm2 := TBitmap.create;
    bm2.Width := 300;
    bm2.Height := 25;
    bm2.Canvas.Brush.Bitmap := bm1;
    bm2.Canvas.FillRect(bm2.Canvas.ClipRect);
    bm2.Transparent := true;
    draw(X, Y, bm2);

    bm2.Free;
    bm1.Free;
  end;
end;

procedure Tfgame.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Timer1.Enabled := false;
end;

procedure Tfgame.FormHide(Sender: TObject);
begin
  Timer1.Enabled := false;
end;

procedure Tfgame.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);

Var
  i: Integer;
  bil: boolean;
begin
  bil := false;
  if (ssCtrl in Shift) then
  begin
    if (my.now.ammo > 0) then
    begin
      dec(my.now.ammo);
      fgame.lammo.caption := my.now.ammo.ToString;
      if my.bullet.all > 0 then
      begin
        for i := 1 to my.bullet.all do
          if (not my.mbullet[i].fly) then
          begin
            bil := true;
            inc(my.bullet.now);
            my.mbullet[i].fly := true;
            my.mbullet[i].X := my.player.X + 35;
            my.mbullet[i].Y := my.player.Y + 80;
          end;
        if (not bil) then
        begin
          inc(my.bullet.now);
          inc(my.bullet.all);
          my.mbullet[my.bullet.all].fly := true;
          my.mbullet[my.bullet.all].X := my.player.X + 35;
          my.mbullet[my.bullet.all].Y := my.player.Y + 80;
        end;
      end
      else
      begin
        inc(my.bullet.now);
        inc(my.bullet.all);
        my.mbullet[my.bullet.all].fly := true;
        my.mbullet[my.bullet.all].X := my.player.X + 35;
        my.mbullet[my.bullet.all].Y := my.player.Y + 80;
      end;
    end;
  end;
end;

procedure jet();
begin
  if (peoples.bak > 0) then
  begin
    if (my.global.speed > 7) then
    begin
      dec(my.global.speed, 1);
      dec(peoples.bak, 1);
    end;
    fgame.ljet.caption := IntToStr(peoples.bak);
  end;
end;

procedure Tfgame.FormKeyPress(Sender: TObject; var Key: Char);

Var
  buttonSelected: Integer;
  bm1, bm2: TBitmap;
begin

  if (Key = #90) or (Key = #122) then
  begin
    if (my.player.X > 12) then
    begin
      dec(my.player.X, 12);
      my.player.view_men := 2;

      if (my.ii.X + 44 > my.ground.X + 150) then
    end;
  end;

  if (Key = #88) or (Key = #120) then
  begin
    if (my.player.X + 88 < Width - 12) then
    begin
      inc(my.player.X, 12);
      my.player.view_men := 3;
    end;
  end;

  if (Key = #32) then
  begin
    jet();
    my.player.view_men := 4;
  end;

  If (Key = #27) then
  begin
    Timer1.Enabled := false;

    Memo1.Text := 'Игра на паузе! Вы действительно хотите выйти?';
    Panel1.Visible := true;
    my.Message.pynkt := 1;
  end;
end;

procedure Tfgame.FormShow(Sender: TObject);
begin
  lcoin.caption := '0';
  lammo.caption := '0';
  ldistance.caption := '0';
  lheart.caption := '3';
  llocation.caption := 'Земля';
  ljet.caption := '0';
  if (besk) then
  begin
    sl := 1
  end
  else
  begin
    sl := slozhnost;
  end;

  my.ground.seychas_vnizy := false;
  my.ii.create := false;
  my.ii.agry_on_player := false;

  my.money.create := false;

  my.ammo.create := false;

  my.money.frequency := 1200;
  my.ammo.frequency := 800;
  my.ii.frequency := 1500;

  my.global.int := 0;
  my.player.view_men := 1;
  my.now.health := 0;
  my.now.ammo := 0;
  my.now.money := 0;
  my.now.rates := 0;
  my.location.pomenialos := false;
  location;
  my.center.X := fgame.Width div 2;
  my.center.Y := fgame.Height div 2;

  my.player.Y := my.center.Y - 150;
  my.player.X := my.center.X;
  my.ground.Y := fgame.Height;
  my.ground.X := 10;
  case sl of
    - 1:
      my.global.speed := 5;
    0:
      my.global.speed := 6;
    1:
      my.global.speed := 7;
  end;
  my.player.rasstoianie := 0;
  my.ii.create := false;
  my.ii.Y := -1000;
  my.ii.X := -1000;
  my.ii.move := 0;
  my.ii.agry_on_player := false;
  my.location.number := 1;
  fgame.ljet.caption := IntToStr(peoples.bak);
  Timer1.Enabled := true;
end;

procedure Tfgame.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  Perform(WM_SysCommand, $F012, 0);
end;

procedure Tfgame.lyesMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  case my.Message.pynkt of
    1:
      begin
        peoples.money := peoples.money;
        change_money(peoples.money);

        Panel1.Visible := false;
        fgame.Timer1.Enabled := false;

        my.now.health := 0;
        my.now.ammo := 0;
        my.now.money := 0;
        my.now.rates := 0;
        my.location.pomenialos := false;
        location;
        my.center.X := fgame.Width div 2;
        my.center.Y := fgame.Height div 2;

        my.player.Y := my.center.Y - 150;
        my.player.X := my.center.X;
        my.ground.Y := fgame.Height;
        my.ground.X := 10;

        my.money.X := -100;
        my.money.Y := -100;

        my.ammo.X := -100;
        my.ammo.Y := -100;
        case sl of
          - 1:
            my.global.speed := 5;
          0:
            my.global.speed := 6;
          1:
            my.global.speed := 7;
        end;
        my.player.rasstoianie := 0;
        my.ii.create := false;
        my.ii.Y := -1000;
        my.ii.X := -1000;
        my.ii.move := 0;
        my.ii.agry_on_player := false;
        my.location.number := 1;
        fgame.Timer1.Enabled := true;
        fmenu.Show;
        fgame.close;
      end;
    2:
      begin
        Panel1.Visible := false;
        fgame.Timer1.Enabled := false;

        my.now.health := 0;
        my.now.ammo := 0;
        my.now.money := 0;
        my.now.rates := 0;
        my.location.pomenialos := false;
        location;
        my.center.X := fgame.Width div 2;
        my.center.Y := fgame.Height div 2;

        my.player.Y := my.center.Y - 150;
        my.player.X := my.center.X;
        my.ground.Y := fgame.Height;
        my.ground.X := 10;

        my.money.X := -100;
        my.money.Y := -100;

        my.ammo.X := -100;
        my.ammo.Y := -100;
        case sl of
          - 1:
            my.global.speed := 5;
          0:
            my.global.speed := 6;
          1:
            my.global.speed := 7;
        end;
        my.player.rasstoianie := 0;
        my.ii.create := false;
        my.ii.Y := -1000;
        my.ii.X := -1000;
        my.ii.move := 0;
        my.ii.agry_on_player := false;
        my.location.number := 1;
        fgame.Timer1.Enabled := true;
      end;
    3:
      begin
        Panel1.Visible := false;
        fgame.Timer1.Enabled := false;

        my.now.health := 0;
        my.now.ammo := 0;
        my.now.money := 0;
        my.now.rates := 0;
        my.location.pomenialos := false;
        location;
        my.center.X := fgame.Width div 2;
        my.center.Y := fgame.Height div 2;

        my.player.Y := my.center.Y - 150;
        my.player.X := my.center.X;
        my.ground.Y := fgame.Height;
        my.ground.X := 10;

        my.money.X := -100;
        my.money.Y := -100;

        my.ammo.X := -100;
        my.ammo.Y := -100;
        case sl of
          - 1:
            my.global.speed := 5;
          0:
            my.global.speed := 6;
          1:
            my.global.speed := 7;
        end;
        my.player.rasstoianie := 0;
        my.ii.create := false;
        my.ii.Y := -1000;
        my.ii.X := -1000;
        my.ii.move := 0;
        my.ii.agry_on_player := false;
        my.location.number := 1;
        fgame.Timer1.Enabled := true;
      end;
    4:
      begin
        Panel1.Visible := false;
        fgame.Timer1.Enabled := false;

        my.now.health := 0;
        my.now.ammo := 0;
        my.now.money := 0;
        my.now.rates := 0;
        my.location.pomenialos := false;
        location;
        my.center.X := fgame.Width div 2;
        my.center.Y := fgame.Height div 2;

        my.player.Y := my.center.Y - 150;
        my.player.X := my.center.X;
        my.ground.Y := fgame.Height;
        my.ground.X := 10;

        my.money.X := -100;
        my.money.Y := -100;

        my.ammo.X := -100;
        my.ammo.Y := -100;
        case sl of
          - 1:
            my.global.speed := 5;
          0:
            my.global.speed := 6;
          1:
            my.global.speed := 7;
        end;
        my.player.rasstoianie := 0;
        my.ii.create := false;
        my.ii.Y := -1000;
        my.ii.X := -1000;
        my.ii.move := 0;
        my.ii.agry_on_player := false;
        my.location.number := 1;
        fgame.Timer1.Enabled := true;
      end
  end;
end;

procedure Tfgame.lyesMouseEnter(Sender: TObject);
begin
  lyes.Font.Color := clSilver;
end;

procedure Tfgame.lyesMouseLeave(Sender: TObject);
begin
  lyes.Font.Color := ClWhite;
end;

procedure Tfgame.lnoMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  case my.Message.pynkt of
    1:
      begin
        Panel1.Visible := false;
        Timer1.Enabled := true;
      end;
    2:
      begin
        Panel1.Visible := false;
        my.ground.Y := fgame.Height;
        my.ground.X := 10;

        my.money.X := -100;
        my.money.Y := -100;

        my.ammo.X := -100;
        my.ammo.Y := -100;

        fmenu.Show;
        fgame.close;
      end;
    3:
      begin
        Panel1.Visible := false;
        my.ground.Y := fgame.Height;
        my.ground.X := 10;

        my.money.X := -100;
        my.money.Y := -100;

        my.ammo.X := -100;
        my.ammo.Y := -100;

        fmenu.Show;
        fgame.close;
      end;
    4:
      begin
        Panel1.Visible := false;
        my.ground.Y := fgame.Height;
        my.ground.X := 10;

        my.money.X := -100;
        my.money.Y := -100;

        my.ammo.X := -100;
        my.ammo.Y := -100;

        fmenu.Show;
        fgame.close;
      end;
  end;
end;

procedure Tfgame.lnoMouseEnter(Sender: TObject);
begin
  lno.Font.Color := clSilver;
end;

procedure Tfgame.lnoMouseLeave(Sender: TObject);
begin
  lno.Font.Color := ClWhite;
end;

procedure init_i_i(X, Y: Integer);

Var
  bm1, bm2: TBitmap;
begin

  begin
    with fgame.Image1.Canvas do
    begin
      Brush.Color := ClWhite;
      bm1 := TBitmap.create;
      bm1.LoadFromFile('Resourses\Characters\iirobot.bmp');
      bm2 := TBitmap.create;
      bm2.Width := 88;
      bm2.Height := 146;
      bm2.Canvas.Brush.Bitmap := bm1;
      bm2.Canvas.FillRect(bm2.Canvas.ClipRect);

      bm2.Transparent := true;
      draw(X, Y, bm2);

      bm2.Free;
      bm1.Free;
    end;
  end;
end;

procedure init_money(X, Y: Integer);

Var
  bm1, bm2: TBitmap;
begin

  begin
    with fgame.Image1.Canvas do
    begin
      Brush.Color := ClWhite;
      bm1 := TBitmap.create;
      bm1.LoadFromFile('Resourses\Help\coin.bmp');
      bm2 := TBitmap.create;
      bm2.Width := 44;
      bm2.Height := 44;
      bm2.Canvas.Brush.Bitmap := bm1;
      bm2.Canvas.FillRect(bm2.Canvas.ClipRect);

      bm2.Transparent := true;
      draw(X, Y, bm2);

      bm2.Free;
      bm1.Free;
    end;
  end;
  if (my.money.Y > fgame.Height + 200) then
  begin
    my.money.create := false;
    my.money.platforma := false;
    my.money.vverx := false;
  end;
end;

procedure init_ammo(X, Y: Integer);

Var
  bm1, bm2: TBitmap;
begin

  begin
    with fgame.Image1.Canvas do
    begin
      Brush.Color := ClWhite;
      bm1 := TBitmap.create;
      bm1.LoadFromFile('Resourses\Help\ammo.bmp');
      bm2 := TBitmap.create;
      bm2.Width := 44;
      bm2.Height := 44;
      bm2.Canvas.Brush.Bitmap := bm1;
      bm2.Canvas.FillRect(bm2.Canvas.ClipRect);

      bm2.Transparent := true;
      draw(X, Y, bm2);

      bm2.Free;
      bm1.Free;
    end;
  end;
  if (my.ammo.Y > fgame.Height + 200) then
  begin
    my.ammo.create := false;
    my.ammo.platforma := false;
    my.ammo.vverx := false;
  end;
end;

procedure money();

Var
  ran: Integer;
begin
  randomize;
  ran := 1;
  if (not my.money.create) then
  begin
    if (ran = 1) then
    begin
      my.money.X := randomrange(my.ground.X, my.ground.X + 200);
      my.money.Y := -44;
      my.money.create := true;
      my.money.vverx := true;
      my.money.platforma := false;
      my.money.platforma_yzhe := false;
      my.money.wait := true;
    end;
  end;
end;

procedure ammo();

Var
  ran: Integer;
begin
  randomize;
  ran := 1;
  if (not my.ammo.create) then
  begin
    if (ran = 1) then
    begin
      my.ammo.X := randomrange(my.ground.X, my.ground.X + 200);
      my.ammo.Y := -44;
      my.ammo.create := true;
      my.ammo.vverx := false;
      my.ammo.platforma := false;
      my.ammo.platforma_yzhe := false;
    end;
  end;
end;

procedure ready_ii();
begin
  if (not my.ii.create) then
  begin
    my.ii.create := true;
  end;
end;

procedure i_i();

Var
  ran: Integer;
begin
  randomize;
  ran := 1;
  if (not my.ii.create) then
  begin
    if (ran = 1) then
    begin
      my.ii.wait := false;
      /// ShowMessage('hi');
      my.ii.X := randomrange(my.ground.X, my.ground.X + 200);
      my.ii.Y := my.ground.Y + 25;
      init_i_i(my.ii.X, my.ii.Y);
      my.ii.create := true;

      case sl of
        - 1:
          my.ii.health := 500;
        0:
          my.ii.health := 600;
        1:
          my.ii.health := 1000;
      end;
      my.ii.agry_on_player := false;

    end;
  end;
end;

procedure ini_men(Chto: Integer);
begin
  men(Chto, my.player.X, my.player.Y);
end;

procedure ini_niz_form();
begin
  if (my.ground.Y <= -300) then
  BEGIN

    if (my.ii.X + 44 > my.ground.X + 150) then
      my.ii.storona := false
    else
      my.ii.storona := true;

    my.ground.seychas_vnizy := true;

    my.ground.Y := fgame.Height;
    my.ground.X := random(fgame.Width - 300);

    if (my.money.create = true) then
    begin
      my.money.vverx := true;

    end
    else
    begin
      my.money.vverx := false;
    end;

    if (my.ammo.create = true) then
    begin
      my.ammo.vverx := true;
    end
    else
      my.ammo.vverx := false;
  END
  else
    my.ground.seychas_vnizy := false;

  if (my.ground.Y >= fgame.Height) and (my.ii.wait) then
  begin
    i_i;
  end;
end;

procedure ini_location();
begin
  location;
  case sl of
    - 1:
      begin
        if ((my.player.rasstoianie <> 0) and (my.global.int mod 5000 = 0)) then
        begin
          inc(my.location.number);
          my.location.pomenialos := true;

        end;
      end;
    0:
      begin
        if ((my.player.rasstoianie <> 0) and (my.global.int mod 7000 = 0)) then
        begin
          inc(my.location.number);
          my.location.pomenialos := true;
        end;
      end;
    1:
      begin
        if ((my.player.rasstoianie <> 0) and (my.global.int mod 8000 = 0)) then
        begin
          inc(my.location.number);
          my.location.pomenialos := true;
        end;
      end;
  end;

end;

procedure ini_ground();
begin
  ground(my.ground.X, my.ground.Y);
  my.ground.Y := my.ground.Y - my.global.speed div 5;
end;

procedure ini_ii();
begin
  IF (my.ii.create) and (not my.ii.agry_on_player) then
  begin
    if (my.ii.Y + 300 <= my.player.Y) then
      my.ii.agry_on_player := true
    else
    begin
      my.ii.Y := my.ii.Y - my.global.speed div 5;
      init_i_i(my.ii.X, my.ii.Y);
    end;
  end;
  inc(my.player.rasstoianie);

  IF (my.ii.create) and (my.ii.agry_on_player) THEN
  begin
    if (my.ii.X + 88 > my.ground.X) and (my.ii.X < my.ground.X + 300) then
    begin

      if (my.ii.X + 88 > my.ground.X + 150) then
        my.ii.storona := true
      else
        my.ii.storona := false;

      if (my.ii.storona) then
        /// левая
        inc(my.ii.X, 2)
      else
        dec(my.ii.X, 2);
      /// правая
      init_i_i(my.ii.X, my.ii.Y);
    end
    else
    begin
      if (my.ii.X + 89 < my.ground.X) or (my.ii.X > my.ground.X + 301) then
      begin
        if (my.ii.X < my.player.X) then
        begin
          inc(my.ii.X, 2);
        end
        else if (my.ii.X > my.player.X + 2) then
          dec(my.ii.X, 2)
        ELSE
        BEGIN
          if (my.ii.Y < my.player.Y) then
          begin
            case sl of
              - 1:
                inc(my.ii.Y, 1);
              0:
                inc(my.ii.Y, 1);
              1:
                inc(my.ii.Y, 2);
            end;

          end;
        END;
        init_i_i(my.ii.X, my.ii.Y);

        /// finish;
      end
      else
      begin
        if (my.ii.X < my.player.X) then
        begin
          inc(my.ii.X, 2);
        end
        else if (my.ii.X > my.player.X) then
          dec(my.ii.X, 2)
        else if (my.ii.storona) then
          /// левая
          inc(my.ii.X, 1)
        else
          dec(my.ii.X, 1);
      end;
    end;
    init_i_i(my.ii.X, my.ii.Y);
  end;
end;

procedure ini_money();
begin
  if (my.ground.Y >= fgame.Height) then
  begin
    /// money;
    my.money.platforma_yzhe := true;
  end;

  if (my.money.create = true) and (my.money.platforma_yzhe) then
  begin

    if (my.money.vverx = true) then
      inc(my.money.Y, my.global.speed div 5)
    else
      dec(my.money.Y, my.global.speed div 5);
    init_money(my.money.X, my.money.Y);
  end;
end;

procedure ini_ammo();
begin
  if (my.ground.Y >= fgame.Height) then
  begin
    /// ammo();
    my.ammo.platforma_yzhe := true;
  end;

  if (my.ammo.create) and (my.ammo.platforma_yzhe) then
  begin

    if (my.ammo.vverx = true) then
      inc(my.ammo.Y, my.global.speed div 5)
    else
      dec(my.ammo.Y, my.global.speed div 5);
    init_ammo(my.ammo.X, my.ammo.Y);
  end
  else
  begin
    my.ammo.platforma_yzhe := false;
  end;
end;

procedure distance();
begin
  if (my.global.int mod 10 = 0) then
  begin
    inc(my.now.rates, Trunc(my.global.speed / 5));
    fgame.ldistance.caption := my.now.rates.ToString;
  end;
end;

procedure help;
begin
  /// Money
  if (my.player.Y + 146 > my.money.Y) AND (my.player.Y < my.money.Y + 44) and
    (my.player.X + 88 > my.money.X) and (my.player.X < my.money.X + 44) then
  begin
    my.money.create := false;
    my.money.X := -100;
    my.money.Y := -100;
    inc(peoples.money);
    inc(my.now.money);
    fgame.lcoin.caption := my.now.money.ToString;
  end;

  /// Ammo
  if (my.player.Y + 146 > my.ammo.Y) AND (my.player.Y < my.ammo.Y + 44) and
    (my.player.X + 88 > my.ammo.X) and (my.player.X < my.ammo.X + 44) then
  begin
    my.ammo.create := false;
    my.ammo.X := -100;
    my.ammo.Y := -100;
    inc(peoples.ammo);
    inc(my.now.ammo, 10);
    fgame.lammo.caption := my.now.ammo.ToString;

  end;
end;

procedure frequency();
begin
  if (my.global.int mod my.money.frequency = 0) and (my.money.create = false)
  then
  begin
    money();
  end;

  if (my.global.int mod my.ammo.frequency = 0) and (my.ammo.create = false) then
  begin
    ammo();
  end;

  if (my.global.int mod my.ii.frequency = 0) and (my.ii.create = false) then
  begin
    my.ii.wait := true;
  end;
end;

procedure global_ini(Chto: Integer);
begin
  with fgame.Image1.Canvas do
  begin
    clean;
    ini_location;
    ini_men(Chto);
    ini_ground;
    frequency;
    ini_niz_form;

    ini_ii;
    ini_money;
    ini_ammo;
    init_bullet;
    yvelichenie_speed;
    distance;

    help;
    inc(my.global.int);
  end;
  finish;
  my.player.view_men := 1;
end;

procedure Tfgame.Timer1Timer(Sender: TObject);
begin
  global_ini(my.player.view_men);
end;

end.
