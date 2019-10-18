unit SHL_Files; // Part of SHL, licensed under WTFPL

interface

uses
  Windows, Classes, SysUtils, SHL_TextUtils, SHL_Types;

type
  MProcess = procedure(const Param: WideString);

  MProcessArgs = function(const Args: ArrayOfWide): Boolean;

type
  RHandles = record
    Read, Write, Error: THandle;
  end;

type
  RFindFile = record
    Name: WideString;
    Attr: Integer;
    Size: Int64;
    CreationTime, WriteTime: TFileTime;
  end;

  AFindFile = array of RFindFile;

type
  SFiles = class
  private
    class function ScanAndGet(const Text: WideString; Delim: SetOfChar; Tail:
      Boolean): WideString;
    class function ReadFile(Stream: THandleStream; MaxSize: Integer; MinSize:
      Integer): DataString;
    class function WriteFile(Stream: THandleStream; Data: Pointer; Size: Integer):
      Boolean;
  public
    class function ReadEntireFile(const Filename: TextString; MaxSize: Integer =
      -1; MinSize: Integer = -1): DataString; overload;
    class function ReadEntireFile(const Filename: WideString; MaxSize: Integer =
      -1; MinSize: Integer = -1): DataString; overload;
    class function WriteEntireFile(const Filename: TextString; Data: Pointer;
      Size: Integer): Boolean; overload;
    class function WriteEntireFile(const Filename: WideString; Data: Pointer;
      Size: Integer): Boolean; overload;
    class function WriteEntireFile(const Filename: TextString; const Data:
      DataString): Boolean; overload;
    class function WriteEntireFile(const Filename: WideString; const Data:
      DataString): Boolean; overload;
    class function OpenRead(const Filename: TextString): THandleStream; overload;
    class function OpenRead(const Filename: WideString): THandleStream; overload;
    class function OpenWrite(const Filename: TextString): THandleStream; overload;
    class function OpenWrite(const Filename: WideString): THandleStream; overload;
    class function OpenNew(const Filename: TextString): THandleStream; overload;
    class function OpenNew(const Filename: WideString): THandleStream; overload;
    class function OpenConsole(const Filename: TextString): THandle;
    class procedure CloseStream(var Stream: THandleStream);
    class function GetArguments(): ArrayOfWide;
    class function GetExecutable(Dll: Integer = 0): WideString;
    class function GetProgramDirectory(): WideString;
    class function RemoveLastSlash(const Filepath: WideString): WideString;
    class function GetLastSlash(const Filepath: WideString; Noslash: Boolean =
      False): WideString;
    class function RemoveExtension(const Filepath: WideString; Count: Integer =
      1): WideString;
    class function GetExtension(const Filepath: WideString; NoDot: Boolean =
      False; LowCase: Boolean = False): WideString;
    class function SeekExtension(const Filepath, Ext: WideString): WideString;
    class function NoBackslash(const Filepath: WideString; YesSlash: Boolean =
      False): WideString;
    class procedure ResetCurrentDir();
    class function IsDirectory(const Filepath: WideString): Boolean;
    class function IsFile(const Filepath: WideString): Boolean;
    class function Exists(const Filepath: WideString; TheFile: Boolean = False): Boolean;
    class function GetFullName(const Filepath: WideString): WideString;
    class function CreateDirectory(const Filepath: WideString): Boolean;
    class function EnsureDirectory(const Filepath: WideString): Boolean;
    class function GetAllFiles(const Dir: WideString; Folders: Trilean =
      Anything): ArrayOfWide;
    class function GetAllFilesExt(const Mask: WideString): AFindFile;
    class function RedirectFile(out Old: RHandles; const Read, Write, Error:
      WideString): Boolean;
    class procedure RedirectRestore(var Old: RHandles);
    class procedure RedirectInit(out Old: RHandles);
    class function OpenStreamInput(): THandleStream;
    class function OpenStreamOutput(): THandleStream;
    class function OpenStreamError(): THandleStream;
    class function UseCurrentDirectory(const Path: WideString = ''): WideString;
    class function UseEnvironmentVariable(const Name: WideString; Value:
      WideString = ''): WideString;
    class function DeleteFile(const Filename: DeprecatedType): DeprecatedType;
    class function DelFile(const Filename: WideString): Boolean;
    class function CopyFile(const Source, Target: WideString; Over: Boolean): Boolean;
    class function MoveFile(const Source, Target: WideString): Boolean;
    class procedure SetTime(const Filename: WideString; const CreationTime,
      WriteTime: FILETIME);
    class procedure PreserveTime(Handle: THandle); overload;
    class procedure PreserveTime(Stream: THandleStream); overload;
    class function RecursiveDirectory(const Create: WideString): Boolean;
    class function DeleteEmptyDirs(const Root: WideString; Recursive: Boolean =
      True): Boolean;
    class function ProcessArguments(Process: MProcess; const ShowHelp:
      TextString = ''): Boolean;
    class function ProcessArgumentsArray(Process: MProcessArgs; const ShowHelp:
      TextString = ''): Boolean;
    class function TouchFile(const Name: WideString): Boolean; overload;
    class function TouchFile(const Name: TextString): Boolean; overload;
    class function NextFile(const Name, Mask: WideString; Next: Boolean): WideString;
    class function RecursiveDelete(const Name: WideString): Boolean;
    class function LowerExt(const Name: WideString): TextString;
    class function FeedStream(Source, Target: TStream; BufferSize: Integer = 64
      * 1024): Boolean;
    class function FeedFile(Stream: TStream; const Name: WideString; BufferSize:
      Integer = 64 * 1024): Boolean;
    class function EnvironmentGet(const Name: WideString): WideString; overload;
    class function EnvironmentGet(const Name: TextString): TextString; overload;
    class function EnvironmentSet(const Name, Value: TextString): Boolean; overload;
    class function EnvironmentSet(const Name, Value: WideString): Boolean; overload;
    class function FileSize(const Name: WideString): Int64;
  end;

implementation

class function SFiles.ReadFile(Stream: THandleStream; MaxSize: Integer; MinSize:
  Integer): DataString;
var
  Size: Int64;
begin
  Result := '';
  if Stream = nil then
    Exit;
  if MaxSize < MinSize then
    ExchangeInteger(MaxSize, MinSize);
  Size := Stream.Size;
  if Size >= $7fffffff then
    Exit;
  if (MaxSize >= 0) and (Size > MaxSize) then
    Exit;
  if (MinSize >= 0) and (Size < MinSize) then
    Exit;
  SetLength(Result, Stream.Size);
  SetLength(Result, Stream.Read(Cast(Result)^, Length(Result)));
  CloseStream(Stream);
end;

class function SFiles.ReadEntireFile(const Filename: TextString; MaxSize:
  Integer = -1; MinSize: Integer = -1): DataString;
begin
  Result := ReadFile(OpenRead(Filename), MaxSize, MinSize);
end;

class function SFiles.ReadEntireFile(const Filename: WideString; MaxSize:
  Integer = -1; MinSize: Integer = -1): DataString;
begin
  Result := ReadFile(OpenRead(Filename), MaxSize, MinSize);
end;

class function SFiles.WriteFile(Stream: THandleStream; Data: Pointer; Size:
  Integer): Boolean;
begin
  Result := False;
  if Stream <> nil then
  begin
    if (Data <> nil) and (Size > 0) then
      Result := Stream.Write(Data^, Size) = Size;
    CloseStream(Stream);
  end;
end;

class function SFiles.WriteEntireFile(const Filename: TextString; Data: Pointer;
  Size: Integer): Boolean;
begin
  Result := WriteFile(OpenNew(Filename), Data, Size);
end;

class function SFiles.WriteEntireFile(const Filename: WideString; Data: Pointer;
  Size: Integer): Boolean;
begin
  Result := WriteFile(OpenNew(Filename), Data, Size);
end;

class function SFiles.WriteEntireFile(const Filename: TextString; const Data:
  DataString): Boolean;
begin
  Result := WriteFile(OpenNew(Filename), Cast(Data), Length(Data));
end;

class function SFiles.WriteEntireFile(const Filename: WideString; const Data:
  DataString): Boolean;
begin
  Result := WriteFile(OpenNew(Filename), Cast(Data), Length(Data));
end;

class function SFiles.OpenRead(const Filename: TextString): THandleStream;
var
  Handle: THandle;
begin
  Handle := CreateFileA(Cast(Filename), GENERIC_READ, FILE_SHARE_READ or
    FILE_SHARE_WRITE, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  if ValidHandle(Handle) then
    Result := THandleStream.Create(Handle)
  else
    Result := nil;
end;

class function SFiles.OpenRead(const Filename: WideString): THandleStream;
var
  Handle: THandle;
begin
  Handle := CreateFileW(PWideChar(Filename), GENERIC_READ, FILE_SHARE_READ or
    FILE_SHARE_WRITE, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  if ValidHandle(Handle) then
    Result := THandleStream.Create(Handle)
  else
    Result := nil;
end;

class function SFiles.OpenWrite(const Filename: TextString): THandleStream;
var
  Handle: THandle;
begin
  Handle := CreateFileA(Cast(Filename), GENERIC_READ or GENERIC_WRITE,
    FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  if ValidHandle(Handle) then
    Result := THandleStream.Create(Handle)
  else
    Result := nil;
end;

class function SFiles.OpenWrite(const Filename: WideString): THandleStream;
var
  Handle: THandle;
begin
  Handle := CreateFileW(PWideChar(Filename), GENERIC_READ or GENERIC_WRITE,
    FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  if ValidHandle(Handle) then
    Result := THandleStream.Create(Handle)
  else
    Result := nil;
end;

class function SFiles.OpenNew(const Filename: TextString): THandleStream;
var
  Handle: THandle;
begin
  Handle := CreateFileA(Cast(Filename), GENERIC_READ or GENERIC_WRITE,
    FILE_SHARE_READ or FILE_SHARE_WRITE, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  if ValidHandle(Handle) then
    Result := THandleStream.Create(Handle)
  else
    Result := nil;
end;

class function SFiles.OpenNew(const Filename: WideString): THandleStream;
var
  Handle: THandle;
begin
  Handle := CreateFileW(PWideChar(Filename), GENERIC_READ or GENERIC_WRITE,
    FILE_SHARE_READ or FILE_SHARE_WRITE, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  if ValidHandle(Handle) then
    Result := THandleStream.Create(Handle)
  else
    Result := nil;
end;

class function SFiles.OpenConsole(const Filename: TextString): THandle;
begin
  Result := CreateFileA(Cast(Filename), GENERIC_READ or GENERIC_WRITE,
    FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);
  if Result = INVALID_HANDLE_VALUE then
    Result := 0;
end;

class procedure SFiles.CloseStream(var Stream: THandleStream);
var
  Handle: Integer;
begin
  if Stream <> nil then
  begin
    Handle := Stream.Handle;
    Stream.Destroy();
    Stream := nil;
    CloseHandle(Handle);
  end;
end;

class function SFiles.GetArguments(): ArrayOfWide;
var
  Size, Count, Data: Integer;
  Start, Last, Arg: PWideChar;
  Quote: Boolean;
begin
  Size := 16;
  SetLength(Result, Size);
  Count := 0;
  Start := GetCommandLineW();
  repeat
    Quote := False;
    while Start^ <> #0 do
      if (Start^ = #32) or (Start^ = #9) then
        Inc(Start)
      else
        Break;
    if Start^ = #0 then
      Break;
    Last := Start;
    Data := 0;
    while Last^ <> #0 do
    begin
      if Quote then
      begin
        if Last^ = '"' then
        begin
          Inc(Last);
          if Last^ = #0 then
            Break;
          if Last^ = '"' then
            Inc(Data)
          else if (Last^ = #32) or (Last^ = #9) then
            Break
          else
            Quote := False;
        end
        else
          Inc(Data);
      end
      else if (Last^ = #32) or (Last^ = #9) then
        Break
      else
      begin
        if Last^ = '"' then
          Quote := True
        else
          Inc(Data);
      end;
      Inc(Last);
    end;
    if Count = Size then
    begin
      Size := (Size + 8) * 2;
      SetLength(Result, Size);
    end;
    SetLength(Result[Count], Data);
    Arg := PWideChar(Result[Count]);
    Quote := False;
    while Start <> Last do
    begin
      if Quote then
      begin
        if Start^ <> '"' then
        begin
          Arg^ := Start^;
          Inc(Arg);
        end
        else
        begin
          Inc(Start);
          if Start = Last then
            Break;
          if Start^ = '"' then
          begin
            Arg^ := '"';
            Inc(Arg);
          end
          else
            Quote := False;
        end;
      end
      else if Start^ = '"' then
        Quote := True
      else
      begin
        Arg^ := Start^;
        Inc(Arg);
      end;
      Inc(Start);
    end;
    Inc(Count);
  until False;
  SetLength(Result, Count);
end;

class function SFiles.GetExecutable(Dll: Integer = 0): WideString;
var
  Size: Integer;
begin
  SetLength(Result, 512);
  repeat
    Size := GetModuleFileNameW(Dll, PWideChar(Result), Length(Result));
  until Size < Length(Result) - 2;
  SetLength(Result, Size);
end;

class function SFiles.GetProgramDirectory(): WideString;
begin
  Result := RemoveLastSlash(GetExecutable()) + WideString('\');
end;

class function SFiles.ScanAndGet(const Text: WideString; Delim: SetOfChar; Tail:
  Boolean): WideString;
var
  Step: PWideChar;
  Len: Integer;
begin
  if Tail then
    Result := Text
  else
    Result := '';
  Step := PWideChar(Text);
  if Step = nil then
    Exit;
  Len := Length(Text);
  Inc(Step, Len);
  while Len > 0 do
  begin
    Dec(Len);
    Dec(Step);
    if TextChar(Step^) in Delim then
    begin
      if Tail then
        Result := Copy(Text, Len + 1, Length(Text))
      else
        Result := Copy(Text, 1, Len);
      Break;
    end;
  end;
end;

class function SFiles.RemoveLastSlash(const Filepath: WideString): WideString;
begin
  Result := ScanAndGet(Filepath, ['\', '/'], False);
end;

class function SFiles.GetLastSlash(const Filepath: WideString; Noslash: Boolean
  = False): WideString;
begin
  Result := ScanAndGet(Filepath, ['\', '/'], True);
  if Noslash and (Length(Result) > 0) and (Result[1] = '\') then
    Delete(Result, 1, 1);
end;

class function SFiles.RemoveExtension(const Filepath: WideString; Count: Integer
  = 1): WideString;
var
  Old: WideString;
begin
  if Count = 1 then
  begin
    Result := ScanAndGet(Filepath, ['.'], False);
    Exit;
  end;
  Result := Filepath;
  if Count < 1 then
    while True do
    begin
      Old := ScanAndGet(Result, ['.'], False);
      if Old = '' then
        Exit;
      Result := Old;
    end;
  while Count > 0 do
  begin
    Old := Result;
    Result := ScanAndGet(Result, ['.'], False);
    Dec(Count);
    if Old = Result then
      Exit;
  end;
end;

class function SFiles.GetExtension(const Filepath: WideString; NoDot: Boolean =
  False; LowCase: Boolean = False): WideString;
begin
  Result := ScanAndGet(Filepath, ['.'], True);
  if (Result = '') or (Result[1] <> '.') then
  begin
    Result := '';
    Exit;
  end;
  if NoDot and (Result <> '') and (Result[1] = '.') then
    Delete(Result, 1, 1);
  if LowCase then
    Result := LowerCase(Result);
end;

class function SFiles.SeekExtension(const Filepath, Ext: WideString): WideString;
var
  Old: WideString;
begin
  Result := Filepath + Ext;
  while True do
  begin
    Old := Result;
    Result := RemoveExtension(Old);
    if Exists(Result + Ext) then
    begin
      Result := Result + Ext;
      Exit;
    end;
    if Old = Result then
    begin
      Result := '';
      Exit;
    end;
  end;
end;

class function SFiles.NoBackslash(const Filepath: WideString; YesSlash: Boolean
  = False): WideString;
var
  Len: Integer;
begin
  Len := Length(Filepath);
  while (Len > 0) and ((Filepath[Len] = '/') or (Filepath[Len] = '\')) do
    Dec(Len);
  if YesSlash then
    Result := Copy(Filepath, 1, Len) + WideString('\')
  else
    Result := Copy(Filepath, 1, Len);
end;

class procedure SFiles.ResetCurrentDir();
var
  Path: WideString;
begin
  Path := GetExecutable();
  Path := RemoveLastSlash(Path);
  SetCurrentDirectoryW(PWideChar(Path));
end;

class function SFiles.IsDirectory(const Filepath: WideString): Boolean;
var
  Code: Integer;
begin
  Code := Integer(GetFileAttributesW(PWideChar(Filepath)));
  Result := (Code <> -1) and ((FILE_ATTRIBUTE_DIRECTORY and Code) <> 0);
end;

class function SFiles.IsFile(const Filepath: WideString): Boolean;
var
  Code: Integer;
begin
  Code := Integer(GetFileAttributesW(PWideChar(Filepath)));
  Result := (Code <> -1) and ((FILE_ATTRIBUTE_DIRECTORY and Code) = 0);
end;

class function SFiles.Exists(const Filepath: WideString; TheFile: Boolean =
  False): Boolean;
var
  Code: Integer;
begin
  Code := Integer(GetFileAttributesW(PWideChar(Filepath)));
  Result := (Code <> -1);
  if TheFile and ((FILE_ATTRIBUTE_DIRECTORY and Code) <> 0) then
    Result := False;
end;

class function SFiles.GetFullName(const Filepath: WideString): WideString;
var
  Ignore: PWideChar;
begin
  SetLength(Result, GetFullPathNameW(PWideChar(Filepath), 0, nil, Ignore) + 4);
  SetLength(Result, GetFullPathNameW(PWideChar(Filepath), Length(Result),
    PWideChar(Result), Ignore));
end;

class function SFiles.CreateDirectory(const Filepath: WideString): Boolean;
begin
  Result := CreateDirectoryW(PWideChar(Filepath), nil);
end;

class function SFiles.EnsureDirectory(const Filepath: WideString): Boolean;
begin
  if IsDirectory(Filepath) then
    Result := True
  else
    Result := CreateDirectory(Filepath);
end;

class function SFiles.GetAllFiles(const Dir: WideString; Folders: Trilean =
  Anything): ArrayOfWide;
var
  Path: WideString;
  Find: TWIN32FindDataW;
  Handle: THandle;
  Size: Integer;
const
  W1: WideString = '.';
  W2: WideString = '..';
begin
  Size := 0;
  SetLength(Result, 16);
  Path := NoBackslash(Dir);
  if Path <> '' then
    Path := Path + '\*'
  else
    Path := Path + '*';
  Handle := FindFirstFileW(PWideChar(Path), Find);
  if (Handle <> INVALID_HANDLE_VALUE) and (Handle <> 0) then
  begin
    repeat
      if TriCheck(Folders, (Find.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) <> 0) then
      begin
        if Size >= Length(Result) then
          SetLength(Result, (Size + 8) * 2);
        if (Find.cFileName <> W1) and (Find.cFileName <> W2) then
        begin
          Result[Size] := Find.cFileName;
          Inc(Size);
        end;
      end;
    until not FindNextFileW(Handle, Find);
    windows.FindClose(Handle);
  end;
  SetLength(Result, Size);
end;

class function SFiles.GetAllFilesExt(const Mask: WideString): AFindFile;
var
  Find: TWIN32FindDataW;
  Handle: THandle;
  Cnt: Integer;
const
  W1: WideString = '.';
  W2: WideString = '..';
begin
  Cnt := 0;
  SetLength(Result, 16);
  Handle := FindFirstFileW(PWideChar(Mask), Find);
  if (Handle <> INVALID_HANDLE_VALUE) and (Handle <> 0) then
  begin
    repeat
      if Cnt >= Length(Result) then
        SetLength(Result, (Cnt + 8) * 2);
      if (Find.cFileName <> W1) and (Find.cFileName <> W2) then
        with Result[Cnt] do
        begin
          Name := Find.cFileName;
          Attr := Find.dwFileAttributes;
          Size := Int64(Find.nFileSizeLow) or Int64(Find.nFileSizeHigh shl 32);
          CreationTime := Find.ftCreationTime;
          WriteTime := Find.ftLastWriteTime;
          Inc(Cnt);
        end;
    until not FindNextFileW(Handle, Find);
    windows.FindClose(Handle);
  end;
  SetLength(Result, Cnt);
end;

class function SFiles.RedirectFile(out Old: RHandles; const Read, Write, Error:
  WideString): Boolean;
var
  Handle: THandle;
  Stream: THandleStream;
begin
  Result := True;
  Old.Read := THandle(-2);
  if Read <> '' then
  begin
    Stream := OpenRead(Read);
    if Stream <> nil then
    begin
      Handle := GetStdHandle(STD_INPUT_HANDLE);
      Old.Read := Handle;
      SetStdHandle(STD_INPUT_HANDLE, Stream.Handle);
      Stream.Free();
      AssignFile(Input, '');
      Reset(Input);
    end
    else
      Result := False;
  end;
  Old.Write := THandle(-2);
  if Write <> '' then
  begin
    Stream := OpenNew(Write);
    if Stream <> nil then
    begin
      Flush(Output);
      Handle := GetStdHandle(STD_OUTPUT_HANDLE);
      Old.Write := Handle;
      SetStdHandle(STD_OUTPUT_HANDLE, Stream.Handle);
      Stream.Free();
      AssignFile(Output, '');
      Rewrite(Output);
    end
    else
      Result := False;
  end;
end;

class procedure SFiles.RedirectRestore(var Old: RHandles);
var
  Handle: THandle;
begin
  if Old.Read <> THandle(-2) then
  begin
    Handle := GetStdHandle(STD_INPUT_HANDLE);
    if (Handle <> 0) and (Handle <> INVALID_HANDLE_VALUE) then
      CloseHandle(Handle);
    SetStdHandle(STD_INPUT_HANDLE, Old.Read);
    AssignFile(Input, '');
    Reset(Input);
  end;
  if Old.Write <> THandle(-2) then
  begin
    Flush(Output);
    Handle := GetStdHandle(STD_OUTPUT_HANDLE);
    if (Handle <> 0) and (Handle <> INVALID_HANDLE_VALUE) then
      CloseHandle(Handle);
    SetStdHandle(STD_OUTPUT_HANDLE, Old.Write);
    AssignFile(Output, '');
    Rewrite(Output);
  end;
end;

class procedure SFiles.RedirectInit(out Old: RHandles);
begin
  Old.Read := THandle(-2);
  Old.Write := THandle(-2);
  Old.Error := THandle(-2);
end;

class function SFiles.OpenStreamInput(): THandleStream;
var
  Handle: Integer;
begin
  Handle := GetStdHandle(STD_INPUT_HANDLE);
  if (Handle <> 0) and (Handle <> -1) then
    Result := THandleStream.Create(Handle)
  else
    Result := nil;
end;

class function SFiles.OpenStreamOutput(): THandleStream;
var
  Handle: Integer;
begin
  Handle := GetStdHandle(STD_OUTPUT_HANDLE);
  if (Handle <> 0) and (Handle <> -1) then
    Result := THandleStream.Create(Handle)
  else
    Result := nil;
end;

class function SFiles.OpenStreamError(): THandleStream;
var
  Handle: Integer;
begin
  Handle := GetStdHandle(STD_ERROR_HANDLE);
  if (Handle <> 0) and (Handle <> -1) then
    Result := THandleStream.Create(Handle)
  else
    Result := nil;
end;

class function SFiles.UseCurrentDirectory(const Path: WideString = ''): WideString;
begin
  SetLength(Result, GetCurrentDirectoryW(0, nil));
  SetLength(Result, GetCurrentDirectoryW(Length(Result), PWideChar(Result)));
  if Path <> '' then
    SetCurrentDirectoryW(PWideChar(Path));
end;

class function SFiles.UseEnvironmentVariable(const Name: WideString; Value:
  WideString = ''): WideString;
begin
  SetLength(Result, GetEnvironmentVariableW(PWideChar(Name), nil, 0));
  if Length(Result) <> 0 then
    SetLength(Result, GetEnvironmentVariableW(PWideChar(Name), PWideChar(Result),
      Length(Result)));
  if Value <> '' then
    SetEnvironmentVariableW(PWideChar(Name), PWideChar(Value));
end;

class function SFiles.DeleteFile(const Filename: DeprecatedType): DeprecatedType;
begin
  Result := Filename;
end;

class function SFiles.DelFile(const Filename: WideString): Boolean;
begin
  Result := windows.DeleteFileW(PWideChar(Filename));
end;

class function SFiles.CopyFile(const Source, Target: WideString; Over: Boolean): Boolean;
begin
  Result := windows.CopyFileW(PWideChar(Source), PWideChar(Target), not Over);
end;

class function SFiles.MoveFile(const Source, Target: WideString): Boolean;
begin
  Result := windows.MoveFileW(PWideChar(Source), PWideChar(Target));
end;

class procedure SFiles.SetTime(const Filename: WideString; const CreationTime,
  WriteTime: TFileTime);
const
  FILE_WRITE_ATTRIBUTES = $100;
var
  Handle: THandle;
begin
  Handle := CreateFileW(PWideChar(Filename), FILE_WRITE_ATTRIBUTES,
    FILE_SHARE_READ or FILE_SHARE_WRITE or FILE_SHARE_DELETE, nil, OPEN_EXISTING,
    FILE_ATTRIBUTE_NORMAL, 0);
  if ValidHandle(Handle) then
  begin
    SetFileTime(Handle, @CreationTime, nil, @WriteTime);
    CloseHandle(Handle);
  end;
end;

class procedure SFiles.PreserveTime(Handle: THandle);
var
  Time: TFileTime;
begin
  Integer(Time.dwLowDateTime) := -1;
  Integer(Time.dwHighDateTime) := -1;
  SetFileTime(Handle, nil, @Time, @Time);
end;

class procedure SFiles.PreserveTime(Stream: THandleStream);
begin
  if Stream <> nil then
    PreserveTime(Stream.Handle);
end;

class function SFiles.RecursiveDirectory(const Create: WideString): Boolean;
var
  Code: Integer;
  Path: PWideChar;

  procedure Recur(Len: Integer);
  var
    Seek: PWideChar;
  begin
    if Path^ = #0 then
      Exit;
    Code := GetFileAttributesW(Path);
    if (Code <> -1) and ((FILE_ATTRIBUTE_DIRECTORY and Code) <> 0) then
      Exit;
    Seek := Path;
    Inc(Seek, Len);
    repeat
      Dec(Seek);
      Dec(Len);
      if Len = 0 then
        Exit;
    until (Seek^ = '\');
    Seek^ := #0;
    Recur(Len);
    Seek^ := '\';
    CreateDirectoryW(Path, nil);
  end;

begin
  Path := PWideChar(NoBackslash(Create));
  Recur(Length(Create));
  Result := IsDirectory(Create);
end;

class function SFiles.DeleteEmptyDirs(const Root: WideString; Recursive: Boolean
  = True): Boolean;
var
  Target, Name: WideString;
  Handle: THandle;
  Find: TWIN32FindDataW;
  Trydel: Boolean;
begin
  Result := False;
  Trydel := True;
  Handle := 0;
  try
    Target := NoBackslash(Root, True);
    if Recursive then
    begin
      Handle := FindFirstFileW(PWideChar(Target + '*'), Find);
      if Handle = INVALID_HANDLE_VALUE then
        Handle := 0;
      if Handle <> 0 then
      begin
        Trydel := True;
        repeat
          Name := WideString(Find.cFileName);
          if (Name <> '.') and (Name <> '..') then
          begin
            if Find.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY <> 0 then
            begin
              if not DeleteEmptyDirs(Target + Name, True) then
                Trydel := False;
            end
            else
              Trydel := False;
          end;
        until not FindNextFileW(Handle, Find);
      end;
    end;
  except
  end;
  if Handle <> 0 then
    windows.FindClose(Handle);
  if Trydel then
    Result := RemoveDirectoryW(PWideChar(Target));
end;

class function SFiles.ProcessArguments(Process: MProcess; const ShowHelp:
  TextString = ''): Boolean;
var
  Arg: ArrayOfWide;
  Par: Integer;
  Wait: TextString;
begin
  Arg := GetArguments();
  for Par := 1 to Length(Arg) - 1 do
  try
    Process(SFiles.GetFullName(Arg[Par]));
  except
  end;
  Result := Length(Arg) > 1;
  if not Result and (ShowHelp <> '') then
  begin
    Writeln(ShowHelp);
    Readln(Wait);
  end;
end;

class function SFiles.ProcessArgumentsArray(Process: MProcessArgs; const
  ShowHelp: TextString = ''): Boolean;
var
  Arg: ArrayOfWide;
  Wait: TextString;
begin
  Arg := GetArguments();
  try
    Result := Process(Arg);
  except
    Result := True;
  end;
  if not Result and (ShowHelp <> '') then
  begin
    Writeln(ShowHelp);
    Readln(Wait);
  end;
end;

class function SFiles.TouchFile(const Name: WideString): Boolean;
var
  Stream: THandleStream;
begin
  Stream := OpenNew(Name);
  Result := Stream <> nil;
  CloseStream(Stream);
end;

class function SFiles.TouchFile(const Name: TextString): Boolean;
var
  Stream: THandleStream;
begin
  Stream := OpenNew(Name);
  Result := Stream <> nil;
  CloseStream(Stream);
end;

class function SFiles.NextFile(const Name, Mask: WideString; Next: Boolean): WideString;
var
  Arr: AFindFile;
  Seek, Base: WideString;
  Index, Target, Len: Integer;
begin
  Result := '';
  Base := NoBackslash(RemoveLastSlash(Name)) + WideString('\');
  Seek := WideUpperCase(GetLastSlash(Name, True));
  Arr := GetAllFilesExt(Base + Mask);
  Len := Length(Arr);
  if Len < 1 then
    Exit;
  Target := -2;
  for Index := 0 to Len - 1 do
    if WideUpperCase(Arr[Index].Name) = Seek then
    begin
      Target := Index;
      Break;
    end;
  if (Len = 1) and (Target <> -2) then
    Exit;
  if Target = -2 then
  begin
    if Next then
      Target := 0
    else
      Target := Len - 1;
  end
  else
  begin
    if Next then
      Inc(Target)
    else
      Dec(Target);
    if Target = -1 then
      Target := Len - 1
    else if Target = Len then
      Target := 0;
  end;
  Result := Base + Arr[Target].Name;
end;

class function SFiles.RecursiveDelete(const Name: WideString): Boolean;
const
  W1: WideString = '.';
  W2: WideString = '..';
var
  Find: TWIN32FindDataW;
  Handle: Integer;
begin
  if Name = '' then
  begin
    Result := False;
    Exit;
  end;
  Result := True;
  Handle := windows.FindFirstFileW(PWideChar(Name + '\*'), Find);
  if (Handle <> -1) and (Handle <> 0) then
  begin
    repeat
      if (Find.dwFileAttributes and faDirectory <> 0) then
      begin
        if (Find.cFileName <> W1) and (Find.cFileName <> W2) then
        begin
          if not RecursiveDelete(Name + '\' + Find.cFileName) then
            Result := False;
        end;
      end
      else
      begin
        if not windows.DeleteFileW(PWideChar(Name + '\' + Find.cFileName)) then
          Result := False;
      end;
    until not FindNextFileW(Handle, Find);
    windows.FindClose(Handle);
  end;
  if not windows.RemoveDirectoryW(PWideChar(Name)) then
    Result := False;
end;

class function SFiles.LowerExt(const Name: WideString): TextString;
begin
  Result := LowerCase(TextString(GetExtension(Name, True)));
end;

class function SFiles.FeedStream(Source, Target: TStream; BufferSize: Integer =
  64 * 1024): Boolean;
var
  Buffer: Pointer;
  Count: Integer;
begin
  Result := False;
  Buffer := nil;
  try
    Assure((BufferSize > 0) and (Source <> nil) and (Target <> nil));
    GetMem(Buffer, BufferSize);
    repeat
      Count := Source.Read(Buffer^, BufferSize);
      if Count = 0 then
        Break;
      Target.WriteBuffer(Buffer^, Count);
    until False;
    Result := True;
  except
  end;
  if Buffer <> nil then
    FreeMem(Buffer);
end;

class function SFiles.FeedFile(Stream: TStream; const Name: WideString;
  BufferSize: Integer = 64 * 1024): Boolean;
var
  Pipe: THandleStream;
begin
  Result := False;
  Pipe := nil;
  try
    Assure((BufferSize > 0) and (Stream <> nil) and (Name <> ''));
    Pipe := OpenRead(Name);
    Assure(FeedStream(Pipe, Stream, BufferSize));
    Result := True;
  except
  end;
  CloseStream(Pipe);
end;

class function SFiles.EnvironmentGet(const Name: WideString): WideString;
var
  Size: Integer;
begin
  Result := '';
  Size := GetEnvironmentVariableW(Cast(Name), nil, 0);
  if Size = 0 then
    Exit;
  SetLength(Result, Size - 1);
  if GetEnvironmentVariableW(Cast(Name), Cast(Result), Size) = 0 then
    Result := '';
end;

class function SFiles.EnvironmentGet(const Name: TextString): TextString;
var
  Size: Integer;
begin
  Result := '';
  Size := GetEnvironmentVariableA(Cast(Name), nil, 0);
  if Size = 0 then
    Exit;
  SetLength(Result, Size - 1);
  if GetEnvironmentVariableA(Cast(Name), Cast(Result), Size) = 0 then
    Result := '';
end;

class function SFiles.EnvironmentSet(const Name, Value: TextString): Boolean;
begin
  Result := SetEnvironmentVariableA(Cast(Name), Cast(Value));
end;

class function SFiles.EnvironmentSet(const Name, Value: WideString): Boolean;
begin
  Result := SetEnvironmentVariableW(Cast(Name), Cast(Value));
end;

class function SFiles.FileSize(const Name: WideString): Int64;
var
  Stream: THandleStream;
begin
  Stream := OpenRead(Name);
  if Stream = nil then
  begin
    Result := -1;
    Exit;
  end;
  Result := Stream.Size;
  CloseStream(Stream);
end;

end.

