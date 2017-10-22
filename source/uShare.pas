unit uShare;

interface

uses
  Classes;

type
  PNotifyEvent = ^TNotifyEvent;
  TNotifyEventList = class(TList)
  private
    function GetItem(AIndex: integer): TNotifyEvent;
    procedure SetItem(AIndex: integer; const Value: TNotifyEvent);
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  published
  public
    property Items[AIndex:integer]: TNotifyEvent read GetItem write SetItem;default;
    procedure Add(Item: TNotifyEvent);
    procedure Remove(Item: TNotifyEvent);
    procedure Fire(Sender: TObject);
  end;


type
  TShare = class(TObject)
  private
    FFileName: String;
    FFileNameUpdateListenerList: TNotifyEventList;

    FModified: Boolean;
    FModifiedUpdateListenerList: TNotifyEventList;

    FTitlePrefix: String;
    FTitlePrefixUpdateListenerList: TNotifyEventList;

    function GetFileName: String;
    procedure SetFileName(const Value: String);

    function GetModified: Boolean;
    procedure SetModified(const Value: Boolean);

    function GetTitlePrefix: String;
    procedure SetTitlePrefix(const Value: String);
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddFileNameUpdateListener(EventListener: TNotifyEvent);
    procedure AddModifiedUpdateListener(EventListener: TNotifyEvent);
    procedure AddTitlePrefixUpdateListener(EventListener: TNotifyEvent);
    property FileName: String read GetFileName write SetFileName;
    property Modified: Boolean read GetModified write SetModified;
    property TitlepRefix: String read GetTitlePrefix write SetTitlePrefix;
  end;

var
  Share: TShare;

implementation

{ TShare }

procedure TShare.AddFileNameUpdateListener(EventListener: TNotifyEvent);
begin
  FFileNameUpdateListenerList.Add(EventListener);
end;

procedure TShare.AddModifiedUpdateListener(EventListener: TNotifyEvent);
begin
  FModifiedUpdateListenerList.Add(EventListener);
end;

procedure TShare.AddTitlePrefixUpdateListener(EventListener: TNotifyEvent);
begin
  FTitlePrefixUpdateListenerList.Add(EventListener);
end;

constructor TShare.Create;
begin
  FFileName := '';
  FFileNameUpdateListenerList := TNotifyEventList.Create;
  FModifiedUpdateListenerList := TNotifyEventList.Create;
  FTitlePrefixUpdateListenerList := TNotifyEventList.Create;
end;

destructor TShare.Destroy;
begin
  FFileNameUpdateListenerList.Free;
  FModifiedUpdateListenerList.Free;
  FTitlePrefixUpdateListenerList.Free;

  inherited;
end;

function TShare.GetFileName: String;
begin
  Result := FFileName;
end;

function TShare.GetModified: Boolean;
begin
  Result := FModified;
end;

function TShare.GetTitlePrefix: String;
begin
  Result := FTitlePrefix;
end;

procedure TShare.SetFileName(const Value: String);
begin
  if Value <> FFileName then
  begin
    FFileName := Value;
    FFileNameUpdateListenerList.Fire(Self);
  end;
end;

procedure TShare.SetModified(const Value: Boolean);
begin
  if Value <> FModified then
  begin
    FModified := Value;
    FModifiedUpdateListenerList.Fire(Self);
  end;
end;

procedure TShare.SetTitlePrefix(const Value: String);
begin
  if Value <> FTitlePrefix then
  begin
    FTitlePrefix := Value;
    FTitlePrefixUpdateListenerList.Fire(Self);
  end;
end;

{ TNotifyEventList }

procedure TNotifyEventList.Add(Item: TNotifyEvent);
var
  Pointer: PNotifyEvent;
begin
  New(Pointer);
  Pointer^ := Item;
  inherited Add(Pointer);
end;

procedure TNotifyEventList.Fire(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    Items[i](Sender);
end;

function TNotifyEventList.GetItem(AIndex: integer): TNotifyEvent;
begin
  Result := PNotifyEvent(inherited Items[AIndex])^;
end;

procedure TNotifyEventList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  if Action = lnDeleted then
  begin
    Dispose(Ptr);
  end;
  inherited;
end;

procedure TNotifyEventList.Remove(Item: TNotifyEvent);
var
  i: Integer;
begin
  i := 0;
  while i < Count do
  begin
    if (TMethod(Items[i]).Code = TMethod(Item).Code) and
       (TMethod(Items[i]).Data = TMethod(Item).Data) then
    begin
      Delete(i);
    end;
    Inc(i);
  end;
end;

procedure TNotifyEventList.SetItem(AIndex: integer; const Value: TNotifyEvent);
begin
  inherited Items[AIndex] := @Value;
end;

initialization

Share := TShare.Create;

finalization

Share.Free;

end.
