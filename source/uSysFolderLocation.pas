// Project      : SHGetFolderLocation wrapper class
// Author       : Michael Puff http://www.michael-puff.de
// Date         : 2009-06-25

unit uSysFolderLocation;

interface

uses
  Windows,
  SysUtils,
  shlobj,
  ActiveX;

type
  TSysFolderLocation = class(TObject)
  private
    _CSIDL: Integer;
    function PathFromIDList(Pidl: PItemIdList): WideString;
  public
    property CSIDL: Integer read _CSIDL write _CSIDL;
    constructor Create(CSIDL: Integer);
    function GetShellFolder: WideString;
  end;

const
  CSIDL_PERSONAL = $0005; // My Documents
  CSIDL_MYMUSIC = $000D; // "My Music" folder
  CSIDL_APPDATA = $001A; // Application Data, new for NT4
  CSIDL_LOCAL_APPDATA = $001C; // non roaming, user\Local Settings\Application Data
  CSIDL_INTERNET_CACHE = $0020;
  CSIDL_COOKIES = $0021;
  CSIDL_HISTORY = $0022;
  CSIDL_COMMON_APPDATA = $0023; // All Users\Application Data
  CSIDL_WINDOWS = $0024; // GetWindowsDirectory()
  CSIDL_SYSTEM = $0025; // GetSystemDirectory()
  CSIDL_PROGRAM_FILES = $0026; // C:\Program Files
  CSIDL_MYPICTURES = $0027; // My Pictures, new for Win2K
  CSIDL_PROGRAM_FILES_COMMON = $002B; // C:\Program Files\Common
  CSIDL_COMMON_DOCUMENTS = $002E; // All Users\Documents
  CSIDL_RESOURCES = $0038; // %windir%\Resources\, For theme and other windows resources.
  CSIDL_RESOURCES_LOCALIZED = $0039; // %windir%\Resources\<LangID>, for theme and other windows specific resources.
  CSIDL_FLAG_CREATE = $8000; // new for Win2K, or this in to force creation of folder
  CSIDL_COMMON_ADMINTOOLS = $002F; // All Users\Start Menu\Programs\Administrative Tools
  CSIDL_ADMINTOOLS = $0030; // <user name>\Start Menu\Programs\Administrative Tools

implementation

{ SysFolderLocation }

function SHGetFolderLocation(hwndOwnder: THandle; nFolder: Integer; hToken: THandle; dwReserved: DWORD; ppidl:
  PItemIdList): HRESULT; stdcall; external 'shell32.dll' name 'SHGetFolderLocation';
function SHGetPathFromIDListW(Pidl: PItemIDList; pszPath: PWideChar): BOOL; stdcall; external 'shell32.dll'
name 'SHGetPathFromIDListW';

resourcestring
  rsE_GetPathFromIDList = 'Ordner kann nicht ermittelt werden';
  rsE_S_FALSE = 'Ordner existiert nicht';
  rsE_InvalidArgument = 'Argument ungültig';

constructor TSysFolderLocation.Create(CSIDL: Integer);
begin
  _CSIDL := CSIDL;
end;

function TSysFolderLocation.GetShellFolder: WideString;
var
  ppidl: PItemIdList;
begin
  try
    case SHGetFolderLocation(0, _CSIDL, 0, 0, @ppidl) of
      S_OK: Result := trim(PathFromIDList(ppidl));
      S_FALSE: raise Exception.Create(rsE_S_FALSE);
      E_INVALIDARG: raise Exception.Create(rsE_InvalidArgument);
    end;
  finally
    CoTaskMemFree(ppidl);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Procedure : PathFromIDList
// Comment   : Fridolin Walther
function TSysFolderLocation.PathFromIDList(Pidl: PItemIdList): WideString;
const
  NTFS_MAX_PATH = 32767;
var
  Path: PWideChar;
begin
  GetMem(Path, (NTFS_MAX_PATH + 1) * 2);
  try
    if not SHGetPathFromIDListW(Pidl, Path) then
    begin
      FreeMem(Path);
      raise Exception.Create(rsE_GetPathFromIDList);
    end;
    Result := WideString(Path);
  finally
    FreeMem(Path);
  end;
end;

end.
