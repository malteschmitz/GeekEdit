unit uFindApp;

interface

function FindApp(const AFileName, ACaption: String): THandle;

implementation

uses
  TLHelp32, Windows, SysUtils;

type
  TFindAppInfo = record
    ProcessID: THandle;
    WindowCaption: String;
    WindowHandle: THandle;
  end;
  PFindAppInfo = ^TFindAppInfo;

function EnumFunc(AHandle: THandle; LParam: LongWord): Bool; stdcall;
var
  ProcessID: THandle;
  WindowCaption: String;
begin
  Result := True; // continue enumeration
  if IsWindowVisible(AHandle) then
  begin
    ProcessID := 0;
    // if process id given then get process id of current window
    // otherwise ProcessID = 0 = PFindAppInfo(LParam).ProcessID
    if PFindAppInfo(LParam).ProcessID > 0 then
      GetWindowThreadProcessID(AHandle, ProcessID);

    WindowCaption := '';
    // if window caption is given then get window caption of current window
    // otherwise WindowCaption = '' = PFindAppInfo(LParam).WindowCaption
    if PFindAppInfo(LParam).WindowCaption > '' then
    begin
      SetLength(WindowCaption, 255);
      SetLength(WindowCaption, GetWindowText(AHandle, @WindowCaption[1], 255));
    end;

    if ProcessID = PFindAppInfo(LParam).ProcessID then
      if WindowCaption = PFindAppInfo(LParam).WindowCaption then
      begin
        PFindAppInfo(LParam).WindowHandle := AHandle;
        Result := False; // stop enumeration
      end;
  end;
end;

function FindApp(const AFileName, ACaption: String): THandle;
var
  SnapShot: THandle;
  p: TProcessEntry32;
  Info: TFindAppInfo;
begin
  Info.WindowCaption := ACaption;
  Info.WindowHandle := 0;
  Info.ProcessID := 0;

  if AFileName = '' then
    EnumWindows(@EnumFunc, LongInt(@Info))
  else
  begin
    p.dwSize := SizeOf(p);
    SnapShot := CreateToolhelp32Snapshot(TH32CS_SnapProcess, 0);
    try
      if Process32First(SnapShot, p) then
        repeat
          if AnsiLowerCase(AFileName) = AnsiLowerCase(p.szExeFile) then
          begin
            Info.ProcessID := p.th32ProcessID;
            EnumWindows(@EnumFunc, LongInt(@Info));
          end;
        until not Process32Next(SnapShot, p);
    finally
      CloseHandle(SnapShot);
    end;
  end;
  Result := Info.WindowHandle;
end;

end.
