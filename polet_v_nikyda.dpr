program polet_v_nikyda;

uses
  Vcl.Forms,
  auth in 'auth.pas' {fauth},
  reg in 'reg.pas' {freg},
  zab_pass in 'zab_pass.pas' {fzab_pass},
  gmenu in 'gmenu.pas' {fmenu},
  setting in 'setting.pas' {fsettings},
  game in 'game.pas' {fgame},
  shop in 'shop.pas' {fshop},
  Records in 'Records.pas' {frecords};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfauth, fauth);
  Application.CreateForm(Tfreg, freg);
  Application.CreateForm(Tfzab_pass, fzab_pass);
  Application.CreateForm(Tfmenu, fmenu);
  Application.CreateForm(Tfsettings, fsettings);
  Application.CreateForm(Tfgame, fgame);
  Application.CreateForm(Tfshop, fshop);
  Application.CreateForm(Tfrecords, frecords);
  Application.Run;
end.
