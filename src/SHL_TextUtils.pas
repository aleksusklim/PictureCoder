unit SHL_TextUtils; // SpyroHackingLib is licensed under WTFPL

interface

uses
  Windows, ShellAPI, SysUtils, Classes, DateUtils, IniFiles, SHL_Types;

type
  STextUtils = class
  public
    class function IntToStrPad(Value, Len: Integer; Zero: TextChar = '0'): TextString;
    class function StrPad(const T: TextString; C: Integer; Zero: TextChar = ' '):
      TextString;
    class function NumToStrPad(Value, Max: Integer): TextString;
    class function DateToString(const Time: TFileTime; Empty: TextString = '-/-'):
      TextString;
    class function SizeToString(Size: RSize): TextString; overload;
    class function SizeToString(Bytes: Int64; Pad: Boolean = False): TextString; overload;
    class procedure DebugPrintArray(const Arr: ArrayOfWide);
    class function StringToken(var Line: PTextChar; const Delims: array of
      TextChar): PTextChar;
    class function IntegerToBase26(Number, Size: Integer): TextString;
    class function TimeToString(Time: TDateTime): TextString;
    class function WriteText(Stream: TStream; const Text: TextString): Boolean; overload;
    class function WriteText(Stream: TStream; const Text: WideString): Boolean; overload;
    class function WriteText(Stream: TStream; Text: PTextChar): Boolean; overload;
    class function WriteText(Stream: TStream; Text: PWideChar): Boolean; overload;
    class function WriteText(Stream: TStream; Text: Pointer; Size: Integer):
      Boolean; overload;
    class function WriteLine(Stream: TStream; Utf8: Boolean): Boolean;
    class function WriteBom(Stream: TStream; Utf8: Boolean): Boolean;
    class procedure PrintWide(Text: Pointer);
    class function StrToHex(const Data: DataString): TextString;
    class function HexToStr(const Text: TextString): DataString;
    class function SplitChar(const Data: DataString; Delims: SetOfChar; Separate:
      Boolean = False): ArrayOfData;
    class function JoinDataArray(const Data: ArrayOfData; const Separator:
      DataString; LastToo: Boolean): DataString;
    class function JoinWideArray(const Data: ArrayOfWide; const Separator:
      WideString; LastToo: Boolean): WideString;
    class function WideToData(const Wide: WideString): DataString;
    class function DataToWide(const Data: DataString): WideString;
    class function WideArrayToZeroList(const Arr: ArrayOfWide): WideString;
    class function IniRead(const Path: WideString; Ini: TMemIniFile = nil): TMemIniFile;
    class function IniWrite(const Path: WideString; Ini: TMemIniFile): Boolean;
    class function Utf8BomAdd(const Text: TextString = ''): TextString;
    class function Utf8BomDel(const Text: TextString): TextString;
    class function Utf8BomSkip(Text: PTextChar): PTextChar;
    class function StringHalf(const Line, Split: TextString; out A, B:
      TextString): Boolean;
    class function StringListToDataPool(List: TStringList): DataString;
    class procedure StringListTailDups(ValueList: TStringList);
    class function TextToSet(const Line: TextString): SetOfChar;
    class function SetToText(const Line: SetOfChar): TextString;
    class function TextToLinesArray(const Data: DataString; TrimEmpty: Boolean):
      ArrayOfText;
    class function StringFilter(const Line: TextString; Allow: SetOfChar;
      Replace: TextChar; DenyInstead: Boolean): TextString;
    class function StringFilterFilename(const Line: TextString): TextString;
    class function TextToArrayOfLines(Text: PWideChar): ArrayOfWide;
  end;

implementation

uses
  SHL_Files, SHL_Helpers, StrUtils, Clipbrd;

class function STextUtils.IntToStrPad(Value, Len: Integer; Zero: TextChar = '0'):
  TextString;
begin
  Result := IntToStr(Value);
  Dec(Len, Length(Result));
  if Len > 0 then
    Result := StringOfChar(Zero, Len) + Result;
end;

class function STextUtils.StrPad(const T: TextString; C: Integer; Zero: TextChar
  = ' '): TextString;
var
  D: Integer;
begin
  if C > 0 then
    D := C - Length(T)
  else
    D := -C - Length(T);
  if (C = 0) or (D < 1) then
  begin
    Result := T;
    Exit;
  end;
  if C < 0 then
    Result := T + StringOfChar(Zero, D)
  else
    Result := StringOfChar(Zero, D) + T;
end;

class function STextUtils.NumToStrPad(Value, Max: Integer): TextString;
begin
  Result := IntToStrPad(Value, Length(IntToStr(Max)));
end;

class function STextUtils.DateToString(const Time: TFileTime; Empty: TextString
  = '-/-'): TextString;
var
  Sys: TSystemTime;
  Loc: TFileTime;
begin
  if (Time.dwLowDateTime = 0) and (Time.dwHighDateTime = 0) then
  begin
    Result := Empty;
    Exit;
  end;
  FileTimeToLocalFileTime(Time, Loc);
  FileTimeToSystemTime(Loc, Sys);
  Result := IntToStrPad(Sys.wDay, 2) + '.' + IntToStrPad(Sys.wMonth, 2) + '.' +
    IntToStr(Sys.wYear) + ', ' + IntToStr(Sys.wHour) + ':' + IntToStrPad(Sys.wMinute, 2);
end;

class function STextUtils.SizeToString(Size: RSize): TextString;
begin
  Result := SizeToString(SizeToInt(Size));
end;

class function STextUtils.SizeToString(Bytes: Int64; Pad: Boolean = False): TextString;
var
  Index, L, R: Integer;
  Size: Int64;
const
  Names: array[0..4] of TextString = (' b ', ' Kb', ' MB', ' GB', ' TB');

  function StrPad(const I: TextString; Z: Integer): TextString;
  begin
    Result := I;
  end;

begin
  if Pad then
  begin
    L := 3;
    R := -2;
  end
  else
  begin
    L := 0;
    R := 0;
  end;
  Result := '0';
  if Bytes < 0 then
    Exit;
  if Bytes < 1024 then
  begin
    if Pad then
      Result := StrPad(IntToStr(Bytes), L) + StrPad('', R - 1) + Names[0]
    else
      Result := IntToStr(Bytes) + ' b';
    Exit;
  end;
  if Bytes > $100000 then
    Size := (Bytes div 1024) * 1000
  else
    Size := (Bytes * 1000) div 1024;
  for Index := 1 to 4 do
  begin
    if Size < 1000 then
    begin
      Result := IntToStr(Size);
      Result := StrPad('0', L) + '.' + StrPad(Result[1] + Result[2], R) + Names[Index];
      Exit;
    end;
    if Size < 10000 then
    begin
      Result := IntToStr(Size);
      Result := StrPad(Result[1], L) + '.' + StrPad(Result[2] + Result[3], R) +
        Names[Index];
      Exit;
    end;
    if Size < 100000 then
    begin
      Result := IntToStr(Size);
      Result := StrPad(Result[1] + Result[2], L) + '.' + StrPad(Result[3], R) +
        Names[Index];
      Exit;
    end;
    if Size < 1000000 then
    begin
      Result := IntToStr(Size);
      Result := StrPad(Result[1] + Result[2] + Result[3], L) + StrPad('', R - 1)
        + Names[Index];
      Exit;
    end;
    Size := Size div 1024;
  end;
end;

class procedure STextUtils.DebugPrintArray(const Arr: ArrayOfWide);
var
  Index: Integer;
begin
  for Index := 0 to Length(Arr) - 1 do
    Writeln(Arr[Index]);
end;

class function STextUtils.StringToken(var Line: PTextChar; const Delims: array
  of TextChar): PTextChar;
var
  I, J, Len: Integer;
  F: Boolean;
begin
  Result := Line;
  if Line = nil then
    Exit;
  Len := Length(Delims) - 1;
  while Line^ <> #0 do
  begin
    for I := 0 to Len do
      if Line^ = Delims[I] then
      begin
        repeat
          Line^ := #0;
          Inc(Line);
          F := True;
          for J := 0 to Len do
          begin
            if Line^ = Delims[J] then
            begin
              F := False;
              Break;
            end;
          end;
          if F then
            Exit;
        until Line^ = #0;
        Exit;
      end;
    Inc(Line);
  end;
  Line := nil;
end;

class function STextUtils.IntegerToBase26(Number, Size: Integer): TextString;
var
  Modulo: Integer;
begin
  Result := StringOfChar('A', Size);
  repeat
    if Size = 0 then
    begin
      Size := 1;
      Result := '_' + Result;
    end;
    Modulo := Number mod 26;
    Result[Size] := Chr(Ord('A') + Modulo);
    Number := Number div 26;
    Dec(Size);
  until Number = 0;
end;

class function STextUtils.TimeToString(Time: TDateTime): TextString;
begin
  Result := IntegerToBase26(DateTimeToUnix(Time) - DateTimeToUnix(EncodeDate(2017,
    1, 1)), 6);
end;

class function STextUtils.WriteText(Stream: TStream; const Text: TextString): Boolean;
var
  Size: Integer;
begin
  Result := False;
  if Stream = nil then
    Exit;
  Size := Length(Text);
  if Size < 1 then
    Exit;
  Result := Stream.Write(Cast(Text)^, Size) = Size;
end;

class function STextUtils.WriteText(Stream: TStream; const Text: WideString): Boolean;
var
  Size: Integer;
begin
  Result := False;
  if Stream = nil then
    Exit;
  Size := Length(Text) * 2;
  if Size < 1 then
    Exit;
  Result := Stream.Write(Cast(Text)^, Size) = Size;
end;

class function STextUtils.WriteText(Stream: TStream; Text: PTextChar): Boolean;
var
  Size: Integer;
begin
  Result := False;
  if Stream = nil then
    Exit;
  Size := lstrlenA(Text);
  if Size < 1 then
    Exit;
  Result := Stream.Write(Pointer(Text)^, Size) = Size;
end;

class function STextUtils.WriteText(Stream: TStream; Text: PWideChar): Boolean;
var
  Size: Integer;
begin
  Result := False;
  if Stream = nil then
    Exit;
  Size := lstrlenW(Text) * 2;
  if Size < 1 then
    Exit;
  Result := Stream.Write(Pointer(Text)^, Size) = Size;
end;

class function STextUtils.WriteText(Stream: TStream; Text: Pointer; Size:
  Integer): Boolean;
begin
  Result := False;
  if (Stream = nil) or (Size < 1) then
    Exit;
  Result := Stream.Write(Text^, Size) = Size;
end;

class function STextUtils.WriteLine(Stream: TStream; Utf8: Boolean): Boolean;
var
  Nl: Integer;
begin
  Result := False;
  if Stream = nil then
    Exit;
  if Utf8 then
  begin
    Nl := $0A0D;
    Result := Stream.Write(Nl, 2) = 2;
    Exit;
  end;
  Nl := $000A000D;
  Result := Stream.Write(Nl, 4) = 4;
end;

class function STextUtils.WriteBom(Stream: TStream; Utf8: Boolean): Boolean;
var
  Bom: Integer;
begin
  Result := True;
  if Utf8 then
  begin
    Bom := $BFBBEF;
    if Stream = nil then
      Write(#$EF#$BB#$BF)
    else
      Result := Stream.Write(Bom, 3) = 3;
    Exit;
  end;
  Bom := $FEFF;
  if Stream = nil then
    Write(#$FF#$FE)
  else
    Result := Stream.Write(Bom, 2) = 2;
end;

class procedure STextUtils.PrintWide(Text: Pointer);
begin
  if Text <> nil then
    while CastWord(Text)^ <> 0 do
    begin
      Write(IntToHex(LittleWord(CastWord(Text)^), 4));
      Adv(Text, 2);
    end;
  Writeln('');
end;

class function STextUtils.StrToHex(const Data: DataString): TextString;
begin
  SetLength(Result, Length(Data) * 2);
  BinToHex(Cast(Data), Cast(Result), Length(Data));
end;

class function STextUtils.HexToStr(const Text: TextString): DataString;
begin
  SetLength(Result, Length(Text) div 2);
  HexToBin(Cast(LowerCase(Text)), Cast(Result), Length(Result));
end;

class function STextUtils.SplitChar(const Data: DataString; Delims: SetOfChar;
  Separate: Boolean = False): ArrayOfData;
var
  Step, From, Last: PDataChar_;
  Index: Integer;
begin
  SetLength(Result, 0);
  if Data = '' then
    Exit;
  Index := 0;
  Step := Cast(Data);
  Last := Cast(Data, Length(Data));
  while Step < Last do
  begin
    repeat
      if not (Step^ in Delims) then
        Break;
      Inc(Step);
    until (Step = Last) or Separate;
    if Step = Last then
      Break;
    repeat
      if Step^ in Delims then
        Break;
      Inc(Step);
    until Step = Last;
    Inc(Index);
  end;
  if Index = 0 then
    Exit;
  SetLength(Result, Index);
  Index := 0;
  Step := Cast(Data);
  while Step < Last do
  begin
    repeat
      if not (Step^ in Delims) then
        Break;
      Inc(Step);
    until (Step = Last) or Separate;
    if Step = Last then
      Break;
    From := Step;
    repeat
      if Step^ in Delims then
        Break;
      Inc(Step);
    until Step = Last;
    SetString(Result[Index], From, Step - From);
    Inc(Index);
  end;
end;

class function STextUtils.JoinDataArray(const Data: ArrayOfData; const Separator:
  DataString; LastToo: Boolean): DataString;
var
  Index, Len, All, Sep: Integer;
  Step: Pointer;
begin
  All := Length(Data) - 1;
  if All < 0 then
  begin
    Result := '';
    Exit;
  end;
  Sep := Length(Separator);
  if LastToo then
    Len := Sep * (All + 1)
  else
    Len := Sep * All;
  for Index := 0 to Length(Data) - 1 do
    Inc(Len, Length(Data[Index]));
  SetLength(Result, Len);
  Step := Cast(Result);
  for Index := 0 to All do
  begin
    Len := Length(Data[Index]);
    CopyMem(Cast(Data[Index]), Step, Len);
    Adv(Step, Len);
    if LastToo or (Index < All) then
      CopyMem(Cast(Separator), Step, Sep);
    Adv(Step, Sep);
  end;
end;

class function STextUtils.JoinWideArray(const Data: ArrayOfWide; const Separator:
  WideString; LastToo: Boolean): WideString;
var
  Index, Len, All, Sep: Integer;
  Step: Pointer;
begin
  All := Length(Data) - 1;
  if All < 0 then
  begin
    Result := '';
    Exit;
  end;
  Sep := Length(Separator);
  if LastToo then
    Len := Sep * (All + 1)
  else
    Len := Sep * All;
  for Index := 0 to Length(Data) - 1 do
    Inc(Len, Length(Data[Index]));
  SetLength(Result, Len);
  Step := Cast(Result);
  Inc(Sep, Sep);
  for Index := 0 to All do
  begin
    Len := Length(Data[Index]) * 2;
    CopyMem(Cast(Data[Index]), Step, Len);
    Adv(Step, Len);
    if LastToo or (Index < All) then
      CopyMem(Cast(Separator), Step, Sep);
    Adv(Step, Sep);
  end;
end;

class function STextUtils.WideToData(const Wide: WideString): DataString;
begin
  if Wide = '' then
    Result := ''
  else
    SetString(Result, PTextChar(PWideChar(Wide)), Length(Wide) * 2);
end;

class function STextUtils.DataToWide(const Data: DataString): WideString;
begin
  if Data = '' then
    Result := ''
  else
    SetString(Result, PWideChar(Cast(Data)), (Length(Data) + 1) div 2);
end;

class function STextUtils.WideArrayToZeroList(const Arr: ArrayOfWide): WideString;
var
  Index, Count: Integer;
  Wide: PWideChar;
begin
  if Length(Arr) = 0 then
  begin
    Result := #0;
    Exit;
  end;
  Count := 0;
  for Index := 0 to Length(Arr) - 1 do
    Inc(Count, Length(Arr[Index]) + 1);
  SetLength(Result, Count);
  Wide := PWideChar(Result);
  for Index := 0 to Length(Arr) - 1 do
    Wide := CopyWideZero(Arr[Index], Wide);
end;

class function STextUtils.IniRead(const Path: WideString; Ini: TMemIniFile = nil):
  TMemIniFile;
var
  Stream: THandleStream;
  List: TStringList;
begin
  Result := nil;
  if Path = '' then
    Exit;
  List := nil;
  Stream := SFiles.OpenRead(Path);
  if Stream = nil then
    Exit;
  try
    List := TStringList.Create();
    List.LoadFromStream(Stream);
    if Ini <> nil then
      Result := Ini
    else
      Result := TMemIniFile.Create('');
    Result.SetStrings(List);
  except
    if Ini <> nil then
      Result.Free();
    Result := nil
  end;
  SFiles.CloseStream(Stream);
  List.Free();
end;

class function STextUtils.IniWrite(const Path: WideString; Ini: TMemIniFile): Boolean;
var
  Stream: THandleStream;
  List: TStringList;
begin
  Result := False;
  if (Ini = nil) or (Path = '') then
    Exit;
  List := nil;
  Stream := SFiles.OpenNew(Path);
  if Stream = nil then
    Exit;
  try
    List := TStringList.Create();
    Ini.GetStrings(List);
    List.SaveToStream(Stream);
    Result := True;
  except
  end;
  SFiles.CloseStream(Stream);
  List.Free();
end;

class function STextUtils.Utf8BomAdd(const Text: TextString = ''): TextString;
begin
  Result := Chr($EF) + Chr($BB) + Chr($BF) + Utf8BomDel(Text);
end;

class function STextUtils.Utf8BomDel(const Text: TextString): TextString;
begin
  Result := Text;
  if Length(Result) < 3 then
    Exit;
  if (Ord(Result[1]) = $EF) and (Ord(Result[2]) = $BB) and (Ord(Result[3]) = $BF) then
    Delete(Result, 1, 3);
end;

class function STextUtils.Utf8BomSkip(Text: PTextChar): PTextChar;
begin
  if (Text <> nil) and (Text[0] = Chr($EF)) and (Text[1] = Chr($BB)) and (Text[2]
    = Chr($BF)) then
    Result := @Text[3]
  else
    Result := Text;
end;

class function STextUtils.StringHalf(const Line, Split: TextString; out A, B:
  TextString): Boolean;
var
  I: Integer;
begin
  Result := False;
  I := Pos(Split, Line);
  if I < 1 then
    Exit;
  A := Copy(Line, 1, I - 1);
  B := Copy(Line, I + Length(Split), Length(Line) - I);
  Result := True;
end;

class function STextUtils.StringListToDataPool(List: TStringList): DataString;
var
  Index, Next, Size: Integer;
  Sort: TStringList;
  Take: array of Boolean;
  Mem: Pointer;
begin
  Result := '';
  if (List = nil) or (List.Count = 0) then
    Exit;
  SetLength(Take, List.Count);
  for Index := 0 to List.Count - 1 do
  begin
    Take[Index] := False;
    if List.Objects[Index] <> nil then
      Exit;
  end;
  Sort := TStringList.Create();
  Sort.Capacity := List.Count;
  Size := 0;
  repeat
    Next := -1;
    for Index := 0 to List.Count - 1 do
      if not Take[Index] then
        if (Next = -1) or (Length(List[Index]) > Length(List[Next])) then
          Next := Index;
    if Next <> -1 then
    begin
      Take[Next] := True;
      for Index := 0 to Sort.Count - 1 do
        if RightStr(Sort[Index], Length(List[Next])) = List[Next] then
        begin
          List.Objects[Next] := Pointer(Integer(Pointer(Sort.Objects[Index])) +
            Length(Sort[Index]) - Length(List[Next]));
          Next := -2;
          Break;
        end;
      if Next <> -2 then
      begin
        Sort.AddObject(List[Next], Pointer(Size));
        List.Objects[Next] := Pointer(Size);
        Inc(Size, Length(List[Next]) + 1);
      end;
    end;
  until Next = -1;
  SetLength(Result, Size);
  Mem := Cast(Result);
  for Index := 0 to Sort.Count - 1 do
    Mem := CopyStrZero(Sort[Index], Mem);
  Sort.Free();
end;

class procedure STextUtils.StringListTailDups(ValueList: TStringList);
var
  Index, Next: Integer;
  Sort, List: TStringValueList;
begin
  List := TStringValueList(ValueList);
  if (List = nil) then
    Abort;
  for Index := 0 to List.Count - 1 do
    List.Values[Index] := -2;
  Sort := TStringValueList.Create();
  Sort.Capacity := List.Count;
  repeat
    Next := -1;
    for Index := 0 to List.Count - 1 do
      if List.Values[Index] = -2 then
        if (Next = -1) or (Length(List[Index]) > Length(List[Next])) then
          Next := Index;
    if Next <> -1 then
    begin
      List.Values[Next] := -1;
      for Index := 0 to Sort.Count - 1 do
        if RightStr(Sort[Index], Length(List[Next])) = List[Next] then
        begin
          List.Values[Next] := Sort.Values[Index];
          Next := -2;
          Break;
        end;
      if Next <> -2 then
        Sort.AddValue(List[Next], Next);
    end;
  until Next = -1;
  Sort.Free();
end;

class function STextUtils.TextToSet(const Line: textString): SetOfChar;
var
  Index: Integer;
begin
  Result := [];
  for Index := 1 to Length(Line) do
    Result := Result + [Line[Index]];
end;

class function STextUtils.SetToText(const Line: SetOfChar): TextString;
var
  Index: Integer;
begin
  Result := '';
  for Index := 0 to 255 do
    if Chr(Index) in Line then
      Result := Result + Chr(Index);
end;

class function STextUtils.TextToLinesArray(const Data: DataString; TrimEmpty:
  Boolean): ArrayOfText;
var
  List: TStringList;
  Index, Count: Integer;
begin
  SetLength(Result, 0);
  List := nil;
  try
    List := TStringList.Create();
    List.Text := Data;
    SetLength(Result, List.Count);
    if TrimEmpty then
    begin
      Count := 0;
      for Index := 0 to List.Count - 1 do
      begin
        Result[Count] := Trim(List[Index]);
        if Result[Count] <> '' then
          Inc(Count)
      end;
      SetLength(Result, Count);
    end
    else
      for Index := 0 to List.Count - 1 do
        Result[Index] := List[Index];
  except
  end;
  List.Free();
end;

class function STextUtils.StringFilter(const Line: TextString; Allow: SetOfChar;
  Replace: TextChar; DenyInstead: Boolean): TextString;
var
  Index: Integer;
begin
  Result := Line;
  UniqueString(Result);
  if DenyInstead then
  begin
    for Index := 1 to Length(Result) do
      if Result[Index] in Allow then
        Result[Index] := Replace;
  end
  else
  begin
    for Index := 1 to Length(Result) do
      if not (Result[Index] in Allow) then
        Result[Index] := Replace;
  end;
end;

class function STextUtils.StringFilterFilename(const Line: TextString): TextString;
begin
  Result := StringFilter(Line, ['0'..'9', 'a'..'z', 'A'..'Z', ' ', ',', '.', '!',
    '#', '(', ')', '[', ']', '{', '}', '-', '+', ',', '$', '''', '=', '_', '@',
    '~', '`', #192..#255, #187, #150, #168, #184, #185, #173, #149], '_', False);
end;

class function STextUtils.TextToArrayOfLines(Text: PWideChar): ArrayOfWide;
var
  P, Start: PWideChar;
  Count: Integer;
const
  WideLineSeparator = WideChar($2028);
begin
  SetLength(Result, 0);
  Count := 0;
  P := Text;
  if P <> nil then
    while P^ <> #0 do
    begin
      while not (P^ in [WideChar(#0), WideChar(#10), WideChar(#13)]) and (P^ <>
        WideLineSeparator) do
        Inc(P);
      Inc(Count);
      if (P^ in [WideChar(#13), WideChar(#10)]) or (P^ = WideLineSeparator) then
        Inc(P);
    end;
  SetLength(Result, Count);
  Count := 0;
  P := Text;
  if P <> nil then
    while P^ <> #0 do
    begin
      Start := P;
      while not (P^ in [WideChar(#0), WideChar(#10), WideChar(#13)]) and (P^ <>
        WideLineSeparator) do
        Inc(P);
      SetString(Result[Count], Start, P - Start);
      Inc(Count);
      if (P^ in [WideChar(#13), WideChar(#10)]) or (P^ = WideLineSeparator) then
        Inc(P);
    end;
end;

end.

