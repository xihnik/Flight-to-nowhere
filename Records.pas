unit Records;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls;

type
  Tfrecords = class(TForm)
    ListBox1: TListBox;
    Image1: TImage;
    lx: TLabel;
    procedure FormShow(Sender: TObject);
    procedure lxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lxMouseEnter(Sender: TObject);
    procedure lxMouseLeave(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type
  people = record
    name: string;
    rec: real;
  end;

var
  frecords: Tfrecords;
  file_input: text;
  sort: array [1 .. 1000] of people;

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

procedure Tfrecords.FormShow(Sender: TObject);
Var
  i, j, n: Integer;
  zap: people;
begin
  ListBox1.Clear;
  n := 0;
  assignfile(file_input, 'input.txt');
  reset(file_input);
  while (not Eof(file_input)) do
  begin
    readln(file_input, peoples.login);
    peoples.login := deshifr(peoples.login);

    readln(file_input, peoples.password);
    peoples.password := deshifr(peoples.password);

    readln(file_input, peoples.secret_password);
    peoples.secret_password := deshifr(peoples.secret_password);

    readln(file_input, peoples.Records);
    peoples.Records := StrToFloat(deshifr(FloatToStr(peoples.Records)));

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
    inC(n);
    sort[n].name := peoples.login;
    sort[n].rec := peoples.Records;

  end;
  CloseFile(file_input);

  for i := 1 to n - 1 do
    for j := 1 to n - 1 do
      if (sort[j + 1].rec > sort[j].rec) then
      begin
        zap.name := sort[j].name;
        zap.rec := sort[j].rec;

        sort[j].name := sort[j + 1].name;
        sort[j].rec := sort[j + 1].rec;

        sort[j + 1].name := zap.name;
        sort[j + 1].rec := zap.rec;
      end;

  for i := 1 to n do
    ListBox1.Items.Add(sort[i].name + ' - ' + FloatToStr(sort[i].rec));

end;

procedure Tfrecords.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  Perform(WM_SysCommand, $F012, 0);
end;

procedure Tfrecords.ListBox1Click(Sender: TObject);
begin
  ListBox1.ItemIndex := -1;
end;

procedure Tfrecords.lxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  fmenu.show;
  Close;
end;

procedure Tfrecords.lxMouseEnter(Sender: TObject);
begin
  lx.Font.Color := clSilver;
end;

procedure Tfrecords.lxMouseLeave(Sender: TObject);
begin
  lx.Font.Color := clWhite;
end;

end.
