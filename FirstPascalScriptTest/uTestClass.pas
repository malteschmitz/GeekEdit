unit uTestClass;

interface

type
  TTestClass = class
  private
    function GetWurst: String;
    procedure SetWurst(const Value: String);
  public
    procedure Test(a,b,c,d: String);
    property Wurst: String read GetWurst write SetWurst;
  end;

implementation

uses
  Dialogs;

{ TTestClass }

function TTestClass.GetWurst: String;
begin
  Result := 'Wurst';
end;

procedure TTestClass.SetWurst(const Value: String);
begin
  ShowMessage('SetWurst(' + Value + ')');
end;

procedure TTestClass.Test(a, b, c, d: String);
begin
  ShowMessage('Test(' + a + ', ' + b + ', ' + c + ', ' + d + ')');
end;

end.
