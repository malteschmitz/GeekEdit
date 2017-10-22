unit frmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TPipeReadThread = class;

  TMainForm = class(TForm)
    MemoOutput: TMemo;
    EdCmd: TEdit;
    BtnWriteCmd: TButton;
    LabelCmd: TLabel;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnWriteCmdClick(Sender: TObject);
    procedure EdCmdKeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
  private
    fInputPipeRead,
    fInputPipeWrite,
    fOutputPipeRead,
    fOutputPipeWrite: Cardinal;
    fProcess: Cardinal;
    fPipeReadThread: TPipeReadThread;
    procedure FClbProc(Sender: TObject; const ABuffer: String; ABufSize: Cardinal);
    procedure FOpenProcess;
    procedure FCloseProcess;
    procedure FWriteToStdIn(const AText: String);
    procedure PipeReadThreadTerminate(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

  TPipeClbProc = procedure(Sender: TObject; const ABuffer: String; ABufSize: Cardinal) of Object;
  TPipeReadThread = class(TThread)
  private
    fBuffer: String;
    fBytesRead: Cardinal;
    fClbProc: TPipeClbProc;
    fPipeOutput: Cardinal;
    procedure FSyncProc;
  protected
    procedure Execute; override;
    constructor Create(AClbProc: TPipeClbProc; APipeOutput: Cardinal);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

{==============================================================================}

constructor TPipeReadThread.Create(AClbProc: TPipeClbProc; APipeOutput: Cardinal);
begin
  inherited Create(True);
  fClbProc    := AClbProc;
  fPipeOutput := APipeOutput;
  SetLength(fBuffer, 5000);
  FreeOnTerminate := True;
  Resume;
end;

{==============================================================================}

procedure TPipeReadThread.Execute;
var LBufSize: Cardinal;
    LRes    : Boolean;
begin
  LBufSize   := Length(fBuffer);
  repeat
    LRes := ReadFile(fPipeOutput, fBuffer[1], LBufSize, fBytesRead, nil);
    Synchronize(fSyncProc);
  until not(LRes) or Terminated;
  ShowMessage('Ich habe fertig!');
end;

{==============================================================================}

procedure TPipeReadThread.FSyncProc;
begin
  fClbProc(Self, fBuffer, fBytesRead);
end;

{==============================================================================}
{==============================================================================}
{==============================================================================}

procedure TMainForm.FClbProc(Sender: TObject; const ABuffer: String; ABufSize: Cardinal);
var LNew: String;
    LPos: Integer;
begin
  LNew := copy(ABuffer, 1, ABufSize);
  LPos := pos(#$C, LNew);
  if (LPos > 0) then
  begin
    MemoOutput.Text := '';
    LNew := copy(LNew, LPos + 1, Length(LNew));
  end;
  MemoOutput.Text := MemoOutput.Text + LNew;
  PostMessage(MemoOutput.Handle, WM_VSCROLL, SB_BOTTOM, 0);
end;

{==============================================================================}

procedure TMainForm.FOpenProcess;
var LStartupInfo: TStartupInfo;
    LProcessInfo: TProcessInformation;
    LSecurityAttr: TSECURITYATTRIBUTES;
    LSecurityDesc: TSecurityDescriptor;
begin
  FillChar(LSecurityDesc, SizeOf(LSecurityDesc), 0);
  InitializeSecurityDescriptor(@LSecurityDesc, SECURITY_DESCRIPTOR_REVISION);
  SetSecurityDescriptorDacl(@LSecurityDesc, True, nil, False);

  LSecurityAttr.nLength := SizeOf(LSecurityAttr);
  LSecurityAttr.lpSecurityDescriptor := @LSecurityDesc;
  LSecurityAttr.bInheritHandle := True;

  fProcess := 0;
  //if CreatePipe(fInputPipeRead, fInputPipeWrite, @LSecurityAttr, 0) then  //Input-Pipe
  //begin
    if CreatePipe(fOutputPipeRead, fOutputPipeWrite, @LSecurityAttr, 0) then //Output-Pipe
    begin
      FillChar(LStartupInfo, SizeOf(LStartupInfo), 0);
      FillChar(LProcessInfo, SizeOf(LProcessInfo), 0);
      LStartupInfo.cb := SizeOf(LStartupInfo);
      LStartupInfo.hStdOutput  := fOutputPipeWrite;
      // LStartupInfo.hStdInput   := fInputPipeRead;
      LStartupInfo.hStdError   := fOutputPipeWrite;
      LStartupInfo.dwFlags     := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
      LStartupInfo.wShowWindow := SW_HIDE;
      if CreateProcess(nil, 'cmd', @LSecurityAttr, nil, True, 0, nil, nil, LStartupInfo, LProcessInfo) then
      begin
        fProcess := LProcessInfo.hProcess;
        fPipeReadThread := TPipeReadThread.Create(FClbProc, fOutputPipeRead);
        fPipeReadThread.OnTerminate := PipeReadThreadTerminate;
        // CloseHandle(fOutputPipeWrite); // ICH will nichts in die output pipe schreiben
      end else begin
        CloseHandle(fInputPipeRead);
        CloseHandle(fInputPipeWrite);
        CloseHandle(fOutputPipeRead);
        CloseHandle(fOutputPipeWrite);
      end;
    end else begin
      CloseHandle(fInputPipeRead);
      CloseHandle(fInputPipeWrite);
    end;
  //end
end;

{==============================================================================}

procedure TMainForm.FCloseProcess;
begin
  if (fProcess <> 0) then
  begin
    CloseHandle(fInputPipeRead);
    CloseHandle(fInputPipeWrite);
    CloseHandle(fOutputPipeRead);
    CloseHandle(fOutputPipeWrite);
    TerminateProcess(fProcess, 0);
    fProcess := 0;
  end;
end;

{==============================================================================}

procedure TMainForm.FWriteToStdIn(const AText: String);
var LPos,
    LWritten: Cardinal;
    LRes    : Boolean;
begin
  LPos := 1;
  repeat
    LWritten := 0;
    LRes := WriteFile(fInputPipeWrite, AText[LPos], Cardinal(Length(AText)) - LPos + 1, LWritten, nil);
    inc(LPos, LWritten);
  until not(LRes) or (LPos > Cardinal(Length(AText)));
end;

procedure TMainForm.PipeReadThreadTerminate(Sender: TObject);
begin
  ShowMessage('ENDE!');
end;

{==============================================================================}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  fProcess := 0;
  FOpenProcess;
end;

{==============================================================================}

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FCloseProcess;
end;

{==============================================================================}

procedure TMainForm.BtnWriteCmdClick(Sender: TObject);
begin
  FWriteToStdIn(EdCmd.Text + #13#10);
  EdCmd.Text := '';
end;

{==============================================================================}

procedure TMainForm.Button1Click(Sender: TObject);
begin
  if fPipeReadThread.Terminated then
    ShowMessage('Beendet')
  else
    ShowMessage('läuft noch');
end;

procedure TMainForm.EdCmdKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    BtnWriteCmdClick(nil);
  end;
end;

{==============================================================================}

end.
