program DropTarget;

uses
  Forms,
  main in 'main.pas' {Form1},
  DDTText in 'DDTText.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
