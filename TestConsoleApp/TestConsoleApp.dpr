program TestConsoleApp;

{$APPTYPE CONSOLE}

uses
  Windows, SysUtils;

var
  i: Integer;

begin
  while True do
  begin
    for i := 1 to StrToIntDef(ParamStr(1), 1) do
      Write('....................................................................................................');
    Write('???');
    ReadLn;
  end;
end.
