unit gmenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, mmsystem, math;

type
  Tfmenu = class(TForm)
    Image1: TImage;
    lplay: TLabel;
    lx: TLabel;
    lshop: TLabel;
    lrecords: TLabel;
    lsettings: TLabel;
    lrazrabot: TLabel;
    CheckBox1: TCheckBox;
    lbesk: TLabel;
    lHelp: TLabel;
    Panel1: TPanel;
    lok: TLabel;
    Memo1: TMemo;
    ifon: TImage;
    procedure lplayMouseEnter(Sender: TObject);
    procedure lshopMouseEnter(Sender: TObject);
    procedure lrecordsMouseEnter(Sender: TObject);
    procedure lsettingsMouseEnter(Sender: TObject);
    procedure lrazrabotMouseEnter(Sender: TObject);
    procedure lxMouseEnter(Sender: TObject);
    procedure lplayMouseLeave(Sender: TObject);
    procedure lshopMouseLeave(Sender: TObject);
    procedure lrecordsMouseLeave(Sender: TObject);
    procedure lsettingsMouseLeave(Sender: TObject);
    procedure lrazrabotMouseLeave(Sender: TObject);
    procedure lxMouseLeave(Sender: TObject);
    procedure lxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lbeskMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lbeskMouseEnter(Sender: TObject);
    procedure lbeskMouseLeave(Sender: TObject);
    procedure lrazrabotMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lsettingsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lplayMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lshopMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lrecordsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure lokMouseEnter(Sender: TObject);
    procedure lokMouseLeave(Sender: TObject);
    procedure lokMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CheckBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmenu: Tfmenu;
  showf: boolean;
  besk: boolean;
  sl: Integer;

implementation

{$R *.dfm}

uses auth, setting, game, shop, Records;

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

procedure Tfmenu.CheckBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (CheckBox1.Checked) then
  begin
    CheckBox1.Checked := false;
    besk := false;
  end
  else
  begin
    CheckBox1.Checked := true;
    besk := true;
  end;
end;

procedure Tfmenu.FormShow(Sender: TObject);
Var
  rand: Integer;
begin
  sl := slozhnost;
  CheckBox1.Checked := false;
  besk := false;
  if (showf = true) then
  begin
    randomize;
    SetVolume(sound, sound);
    rand := randomrange(1, 12);
    fauth.MediaPlayer1.FileName := 'Resourses//music//' + rand.ToString
      + '.mp3';
    fauth.MediaPlayer1.Open;
    fauth.MediaPlayer1.Play;
    showf := false;
  end;
end;

procedure Tfmenu.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  Perform(WM_SysCommand, $F012, 0);
end;

procedure Tfmenu.lbeskMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (CheckBox1.Checked) then
  begin
    CheckBox1.Checked := false;
    besk := false;
  end
  else
  begin
    CheckBox1.Checked := true;
    besk := true;
  end;
end;

procedure Tfmenu.lbeskMouseEnter(Sender: TObject);
begin
  lbesk.Font.Color := clSilver;
end;

procedure Tfmenu.lbeskMouseLeave(Sender: TObject);
begin
  lbesk.Font.Color := clWhite;
end;

procedure Tfmenu.lokMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Panel1.Visible := false;
end;

procedure Tfmenu.lokMouseEnter(Sender: TObject);
begin
  lok.Font.Color := clSilver;
end;

procedure Tfmenu.lokMouseLeave(Sender: TObject);
begin
  lok.Font.Color := clWhite;
end;

procedure Tfmenu.lplayMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (CheckBox1.Checked) then
  begin
    besk := true;
  end
  else
  begin
    besk := false;
  end;

  fgame.show;
  hide;
end;

procedure Tfmenu.lplayMouseEnter(Sender: TObject);
begin
  lplay.Font.Color := clSilver;
end;

procedure Tfmenu.lsettingsMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  fsettings.show;
  Close;
end;

procedure Tfmenu.lsettingsMouseEnter(Sender: TObject);
begin
  lsettings.Font.Color := clSilver;
end;

procedure Tfmenu.lsettingsMouseLeave(Sender: TObject);
begin
  lsettings.Font.Color := clWhite;
end;

procedure Tfmenu.lshopMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  fshop.show;
  hide;
end;

procedure Tfmenu.lshopMouseEnter(Sender: TObject);
begin
  lshop.Font.Color := clSilver;
end;

procedure Tfmenu.lshopMouseLeave(Sender: TObject);
begin
  lshop.Font.Color := clWhite;
end;

procedure Tfmenu.lxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  fauth.MediaPlayer1.Stop;
  fauth.MediaPlayer1.Close;
  showf := true;
  fauth.show;
  Close;
end;

procedure Tfmenu.lxMouseEnter(Sender: TObject);
begin
  lx.Font.Color := clSilver;
end;

procedure Tfmenu.lxMouseLeave(Sender: TObject);
begin
  lx.Font.Color := clWhite;
end;

procedure Tfmenu.lplayMouseLeave(Sender: TObject);
begin
  lplay.Font.Color := clWhite;
end;

procedure Tfmenu.lrazrabotMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Memo1.Text :=
    'Игра создана учащимся группы П-1708 Шкадинским Артуром Романовичем!';
  Panel1.Visible := true;
end;

procedure Tfmenu.lrazrabotMouseEnter(Sender: TObject);
begin
  lrazrabot.Font.Color := clSilver;
end;

procedure Tfmenu.lrazrabotMouseLeave(Sender: TObject);
begin
  lrazrabot.Font.Color := clWhite;
end;

procedure Tfmenu.lrecordsMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  frecords.show;
  Close;
end;

procedure Tfmenu.lrecordsMouseEnter(Sender: TObject);
begin
  lrecords.Font.Color := clSilver;
end;

procedure Tfmenu.lrecordsMouseLeave(Sender: TObject);
begin
  lrecords.Font.Color := clWhite;
end;

end.
