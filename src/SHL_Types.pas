unit SHL_Types; // SpyroHackingLib is licensed under WTFPL

interface

uses
  SysUtils;

type
  TextString = type AnsiString;

  DataString = type AnsiString;

  TextChar = type AnsiChar;

  DataChar = type AnsiChar;

  SetOfChar = set of Char;

type
  PTextChar = PAnsiChar;

  PDataChar_ = PAnsiChar; //

  ArrayOfText = array of TextString;

  ArrayOfData = array of DataString;

  ArrayOfWide = array of WideString;

  ArrayOfInteger = array of Integer;

type
  PText = ^Text;

type
  PSize = ^RSize;

  RSize = record
    Lo, Hi: Cardinal;
  end;

type
  Trilean = (Anything = 0, Include = 1, Exclude = -1);

type
  DeprecatedType = array[0..0, 0..0] of Byte;

  //{
  Char = DeprecatedType; // TextChar / DataChar

  PChar = DeprecatedType; // PTextChar

  Pstring = DeprecatedType;

  Cardinal = DeprecatedType; // DWORD

  PCardinal = DeprecatedType;

  LongInt = DeprecatedType; // Integer

  PLongInt = DeprecatedType; // PInteger

  AnsiChar = DeprecatedType; // TextChar

  PAnsiChar = DeprecatedType; // PTextChar
  //}

procedure FillChar(out Data; Count: Integer; Value: DataChar); overload;

procedure FillChar(out Data; Count: Integer; Value: Byte); overload;

procedure ZeroMemory(const DeprecatedArg: DeprecatedType);

procedure CopyMemory(const DeprecatedArg: DeprecatedType);

procedure ZeroMem(Destination: Pointer; Length: Integer);

procedure ZeroStr(var Data: DataString);

procedure CopyMem(const Source: Pointer; Destination: Pointer; Length: Integer);

function CopyStr(const Source: DataString; Destination: Pointer): Pointer;

function CopyStrZero(const Source: DataString; Destination: Pointer): Pointer;

function CopyWideZero(const Source: WideString; Destination: PWideChar): PWideChar;

function Ignore(const Value): Pointer; overload;

function Ignore(const Value1, Value2): Integer; overload;

function Ignore(const Value1, Value2, Value3): Pointer; overload;

function Ignore(const Value1, Value2, Value3, Value4): Integer; overload;

function Inits(out Value): Pointer;

procedure Assure(Expression: Boolean);

function ValidHandle(Win32Handle: THandle): Boolean;

function LittleWord(BigEndian: Word): Word;

function LittleInteger(BigEndian: Integer): Integer;

function TriCheck(Tri: Trilean; Boo: Boolean): Boolean;

function TriMake(Value: Integer): Trilean;

function TriAsBoolText(Tri: Trilean): TextString;

function TriFromBoolText(Line: TextString): Trilean;

function Bit(var Value: Integer; Bits: Integer; Ext: Boolean): Integer;

procedure Fit(var Value: Integer; Bits: Integer; Data: Integer);

function ShiftAr(s, i: Integer): Integer;

function SignExtend(Value: Integer; Bits: Integer): Integer;

function Adv(var Value: Integer; Add: Integer): Integer; overload;

function Adv(var Value: Pointer; Add: Integer): Pointer; overload;

function CastPtr(From: Pointer; Add: Integer = 0): PPointer; overload;

function CastPtr(const From: DataString; Add: Integer = 0): PPointer; overload;

function CastInt(From: Pointer; Add: Integer = 0): PInteger; overload;

function CastInt(const From: DataString; Add: Integer = 0): PInteger; overload;

function CastWord(From: Pointer; Add: Integer = 0): PWord; overload;

function CastWord(const From: DataString; Add: Integer = 0): PWord; overload;

function CastByte(From: Pointer; Add: Integer = 0): PByte; overload;

function CastByte(const From: DataString; Add: Integer = 0): PByte; overload;

function CastChar(From: Pointer; Add: Integer = 0): PDataChar_; overload;

function CastChar(const From: DataString; Add: Integer = 0): PDataChar_; overload;

function Cast(From: Pointer; Add: Integer): Pointer; overload;

function Cast(const From: DataString): Pointer; overload;

function Cast(const From: DataString; Add: Integer): Pointer; overload;

function Cast(const From: WideString): Pointer; overload;

function AsInt(What: Pointer): Integer; overload;

function AsInt(What: TObject): Integer; overload;

function AsPtr(What: Integer): Pointer; overload;

function AsPtr(What: TObject): Pointer; overload;

function Diff(Big: Pointer; Small: Pointer): Integer; overload;

function Diff(Big: Pointer; const Small: DataString): Integer; overload;

procedure Move(DeprecatedCall: DeprecatedType);

function AlignInc(Offset, Align: Integer): Integer;

function AlignValue(Offset, Align: Integer): Integer;

function AlignDiv(Offset, Align: Integer): Integer;

function AlignZero(Offset, Align: Integer): DataString;

function CeilDivPos(A, B: Integer): Integer;

function Obj2Int(Obj: TObject): Integer;

function Int2Obj(Int: Integer): Pointer;

function TestBounds(Low: Integer; Arr: array of Integer; High: Integer): Boolean;

function Median(A, X, B: Integer): Integer;

procedure ExchangeBytes(Ptr1, Ptr2: Pointer; SizeInBytes: Integer);

procedure ExchangeDwords(Ptr1, Ptr2: Pointer; SizeInBytes: Integer);

procedure ExchangeInteger(var Int1, Int2: Integer);

function MakeArrayWide(Arr: array of WideString): ArrayOfWide;

function MakeArrayText(Arr: array of TextString): ArrayOfText;

function DataStr(From: Pointer; Size: Integer): DataString;

procedure ObjNil(out A); overload;

procedure ObjNil(out A, B); overload;

procedure ObjNil(out A, B, C); overload;

procedure ObjNil(out A, B, C, D); overload;

procedure ObjNil(out A, B, C, D, E); overload;

procedure ObjNil(out A, B, C, D, E, F); overload;

procedure ObjNil(out A, B, C, D, E, F, G); overload;

procedure ObjNil(out A, B, C, D, E, F, G, H); overload;

procedure ObjNil(out A, B, C, D, E, F, G, H, I); overload;

procedure ObjNil(out A, B, C, D, E, F, G, H, I, J); overload;

procedure ObjNil(out A, B, C, D, E, F, G, H, I, J, K); overload;

procedure ObjNil(out A, B, C, D, E, F, G, H, I, J, K, L); overload;

procedure ObjFree(var A); overload;

procedure ObjFree(var A, B); overload;

procedure ObjFree(var A, B, C); overload;

procedure ObjFree(var A, B, C, D); overload;

procedure ObjFree(var A, B, C, D, E); overload;

procedure ObjFree(var A, B, C, D, E, F); overload;

procedure ObjFree(var A, B, C, D, E, F, G); overload;

procedure ObjFree(var A, B, C, D, E, F, G, H); overload;

procedure ObjFree(var A, B, C, D, E, F, G, H, I); overload;

procedure ObjFree(var A, B, C, D, E, F, G, H, I, J); overload;

procedure ObjFree(var A, B, C, D, E, F, G, H, I, J, K); overload;

procedure ObjFree(var A, B, C, D, E, F, G, H, I, J, K, L); overload;

procedure UniqueString(var str: TextString); overload;

procedure UniqueString(var str: DataString); overload;

procedure UniqueString(var str: WideString); overload;

function ChrAdd(C: TextChar; O: Integer): TextChar;

function StrAsInt(const Str: DataString): Integer;

function StrFromInt(const Int: Integer): DataString;

function ByteComparator(A, B: Pointer; SizeInBytes: Integer): Integer;

function WordComparator(A, B: Pointer; SizeInWords: Integer): Integer;

function CompareWide(const A, B: WideString): Integer;

function WideIsPrefix(const Short, Long: WideString): Boolean;

function SizeToInt(const Size: RSize): Int64;

function SizeFromInt(Size: Int64): RSize;

function SizeFromHiLo(Hi, Lo: LongWord): RSize;

function SizeCompare(const A, B: RSize): Integer;

procedure SizeInc(var Size: RSize; const Add: RSize); overload;

procedure SizeInc(var Size: RSize; const Add: Int64); overload;

implementation

procedure FillChar(out Data; Count: Integer; Value: DataChar); overload;
begin
  System.FillChar((@Data)^, Count, Value);
end;

procedure FillChar(out Data; Count: Integer; Value: Byte); overload;
begin
  System.FillChar((@Data)^, Count, Chr(Value));
end;

procedure ZeroMemory(const DeprecatedArg: DeprecatedType);
begin
  Ignore(DeprecatedArg);
end;

procedure CopyMemory(const DeprecatedArg: DeprecatedType);
begin
  Ignore(DeprecatedArg);
end;

procedure ZeroMem(Destination: Pointer; Length: Integer);
begin
  if Length > 0 then
    System.FillChar(Destination^, Length, #0);
end;

procedure ZeroStr(var Data: DataString);
begin
  ZeroMem(Cast(Data), Length(Data));
end;

procedure CopyMem(const Source: Pointer; Destination: Pointer; Length: Integer);
begin
  System.Move(Source^, Destination^, Length);
end;

function CopyStr(const Source: DataString; Destination: Pointer): Pointer;
begin
  System.Move(PDataChar_(Source)^, Destination^, Length(Source));
  Result := PDataChar_(Destination) + Length(Source);
end;

function CopyStrZero(const Source: DataString; Destination: Pointer): Pointer;
begin
  if Destination = nil then
  begin
    PByte(Destination)^ := 0;
    Result := Cast(Source, 1);
    Exit;
  end;
  System.Move(PDataChar_(Source)^, Destination^, Length(Source) + 1);
  Result := PDataChar_(Destination) + Length(Source) + 1;
end;

function CopyWideZero(const Source: WideString; Destination: PWideChar): PWideChar;
begin
  if Destination = nil then
  begin
    Destination^ := #0;
    Result := Cast(Source, 1);
    Exit;
  end;
  System.Move(PWideChar(Source)^, Destination^, (Length(Source) + 1) * SizeOf(WideChar));
  Result := PWideChar(Destination) + Length(Source) + 1;
end;

function Ignore(const Value): Pointer;
begin
  Result := @Value;
end;

function Ignore(const Value1, Value2): Integer;
begin
  Result := PDataChar_(@Value1) - PDataChar_(@Value2);
end;

function Ignore(const Value1, Value2, Value3): Pointer;
begin
  Result := PDataChar_(@Value1) + (PDataChar_(@Value2) - PDataChar_(Value3));
end;

function Ignore(const Value1, Value2, Value3, Value4): Integer;
begin
  Result := PDataChar_(@Value1) + (PDataChar_(@Value2) - PDataChar_(Value3)) -
    PDataChar_(Value4);
end;

function Inits(out Value): Pointer;
begin
  Result := @Value;
end;

procedure Assure(Expression: Boolean);
begin
  if not Expression then
    Abort;
end;

function ValidHandle(Win32Handle: THandle): Boolean;
begin
  Result := (Win32Handle <> 0) and (Integer(Win32Handle) <> -1);
end;

function LittleWord(BigEndian: Word): Word;
begin
  Result := $ffff and ((BigEndian shr 8) or (BigEndian shl 8));
end;

function LittleInteger(BigEndian: Integer): Integer;
begin
  Result := (BigEndian shl 24) or (BigEndian shr 24) or ((BigEndian shr 8) and
    $ff00) or ((BigEndian shl 8) and $ff0000);
end;

function TriCheck(Tri: Trilean; Boo: Boolean): Boolean;
begin
  Result := (Tri = Anything) or ((Tri = Include) and Boo) or (Tri = Exclude) and not Boo;
end;

function TriMake(Value: Integer): Trilean;
begin
  if Value > 0 then
    Result := Include
  else if Value < 0 then
    Result := Exclude
  else
    Result := Anything;
end;

function TriAsBoolText(Tri: Trilean): TextString;
begin
  if Tri = Include then
    Result := 'true'
  else if Tri = Exclude then
    Result := 'false'
  else
    Result := '';
end;

function TriFromBoolText(Line: TextString): Trilean;
begin
  Line := LowerCase(Line);
  if (Line = 'true') or (Line = '1') then
    Result := Include
  else if (Line = 'false') or (Line = '0') then
    Result := Exclude
  else
    Result := Anything;
end;

function Bit(var Value: Integer; Bits: Integer; Ext: Boolean): Integer;
begin
  Result := Value and ((1 shl Bits) - 1);
  Value := Value shr Bits;
  if Ext then
    if (Result and (1 shl (Bits - 1))) > 0 then
      Result := Result or not ((1 shl Bits) - 1);
end;

procedure Fit(var Value: Integer; Bits: Integer; Data: Integer);
begin
  Value := (Value shl Bits) or (Data and ((1 shl Bits) - 1));
end;

function ShiftAr(s, i: Integer): Integer;
begin
  if (s and Integer($80000000)) <> 0 then
    Result := (s shr i) or Integer(not ((-1) shr i))
  else
    Result := s shr i;
end;

function SignExtend(Value: Integer; Bits: Integer): Integer;
begin
  Result := Bit(Value, Bits, True);
end;

function Adv(var Value: Integer; Add: Integer): Integer; overload;
begin
  Inc(Value, Add);
  Result := Value;
end;

function Adv(var Value: Pointer; Add: Integer): Pointer; overload;
begin
  Inc(PDataChar_(Value), Add);
  Result := Value;
end;

function CastPtr(From: Pointer; Add: Integer = 0): PPointer; overload;
begin
  Result := Pointer(PDataChar_(From) + Add);
end;

function CastPtr(const From: DataString; Add: Integer = 0): PPointer;
begin
  Result := Pointer(PDataChar_(From) + Add);
end;

function CastInt(From: Pointer; Add: Integer = 0): PInteger; overload;
begin
  Result := Pointer(PDataChar_(From) + Add);
end;

function CastInt(const From: DataString; Add: Integer = 0): PInteger; overload;
begin
  Result := Pointer(PDataChar_(From) + Add);
end;

function CastWord(From: Pointer; Add: Integer = 0): PWord; overload;
begin
  Result := Pointer(PDataChar_(From) + Add);
end;

function CastWord(const From: DataString; Add: Integer = 0): PWord; overload;
begin
  Result := Pointer(PDataChar_(From) + Add);
end;

function CastByte(From: Pointer; Add: Integer = 0): PByte; overload;
begin
  Result := Pointer(PDataChar_(From) + Add);
end;

function CastByte(const From: DataString; Add: Integer = 0): PByte; overload;
begin
  Result := Pointer(PDataChar_(From) + Add);
end;

function CastChar(From: Pointer; Add: Integer = 0): PDataChar_; overload;
begin
  Result := Pointer(PDataChar_(From) + Add);
end;

function CastChar(const From: DataString; Add: Integer = 0): PDataChar_; overload;
begin
  Result := Pointer(PDataChar_(From) + Add);
end;

function Cast(From: Pointer; Add: Integer): Pointer; overload;
begin
  Result := PDataChar_(From) + Add;
end;

function Cast(From: TObject): Pointer; overload;
begin
  Result := Pointer(From);
end;

function Cast(const From: DataString): Pointer; overload;
begin
  Result := PDataChar_(From);
end;

function Cast(const From: DataString; Add: Integer): Pointer; overload;
begin
  Result := PDataChar_(From) + Add;
end;

function Cast(const From: WideString): Pointer; overload;
begin
  Result := PWideChar(From);
end;

function AsInt(What: Pointer): Integer; overload;
begin
  Result := Integer(What);
end;

function AsInt(What: TObject): Integer; overload;
begin
  Result := Integer(Pointer(What));
end;

function AsPtr(What: Integer): Pointer; overload;
begin
  Result := Pointer(What);
end;

function AsPtr(What: TObject): Pointer; overload;
begin
  Result := Pointer(What);
end;

function Diff(Big: Pointer; Small: Pointer): Integer; overload;
begin
  Result := PDataChar_(Big) - PDataChar_(Small);
end;

function Diff(Big: Pointer; const Small: DataString): Integer; overload;
begin
  Result := PDataChar_(Big) - PDataChar_(Small);
end;

procedure Move(DeprecatedCall: DeprecatedType);
begin
  Abort;
end;

function AlignInc(Offset, Align: Integer): Integer;
begin
  if (Align < 2) then
  begin
    Result := 0;
    Exit;
  end;
  Result := Offset mod Align;
  if Result <> 0 then
    if Offset < 0 then
      Result := -Result
    else
      Result := Align - Result;
end;

function AlignValue(Offset, Align: Integer): Integer;
begin
  Result := Offset + AlignInc(Offset, Align);
end;

function AlignDiv(Offset, Align: Integer): Integer;
begin
  Result := AlignValue(Offset, Align) div Align;
end;

function AlignZero(Offset, Align: Integer): DataString;
begin
  Result := StringOfChar(#0, AlignInc(Offset, Align));
end;

function CeilDivPos(A, B: Integer): Integer;
begin
  Result := (A div B) + Ord((A mod B) <> 0);
end;

function Obj2Int(Obj: TObject): Integer;
begin
  Result := Integer(Pointer(Obj));
end;

function Int2Obj(Int: Integer): Pointer;
begin
  Result := Pointer(Int);
end;

function TestBounds(Low: Integer; Arr: array of Integer; High: Integer): Boolean;
var
  Index: Integer;
begin
  Result := False;
  for Index := 0 to Length(Arr) - 1 do
    if (Arr[Index] < Low) or (Arr[Index] > High) then
      Exit;
  Result := True;
end;

function Median(A, X, B: Integer): Integer;
begin
  Result := X;
  if X < A then
    Result := A;
  if X > B then
    Result := B;
end;

procedure ExchangeBytes(Ptr1, Ptr2: Pointer; SizeInBytes: Integer);
var
  T: Byte;
  A, B: PByte;
begin
  A := Ptr1;
  B := Ptr2;
  while SizeInBytes > 0 do
  begin
    T := A^;
    A^ := B^;
    B^ := T;
    Inc(A);
    Inc(B);
    Dec(SizeInBytes);
  end;
end;

procedure ExchangeDwords(Ptr1, Ptr2: Pointer; SizeInBytes: Integer);
var
  T: Integer;
  A, B: PInteger;
begin
  A := Ptr1;
  B := Ptr2;
  while SizeInBytes > 0 do
  begin
    T := A^;
    A^ := B^;
    B^ := T;
    Inc(A);
    Inc(B);
    Dec(SizeInBytes, 4);
  end;
end;

procedure ExchangeInteger(var Int1, Int2: Integer);
var
  Temp: Integer;
begin
  Temp := Int1;
  Int1 := Int2;
  Int2 := Temp;
end;

function MakeArrayWide(Arr: array of WideString): ArrayOfWide;
var
  Index: Integer;
begin
  SetLength(Result, Length(Arr));
  for Index := 0 to Length(Result) - 1 do
    Result[Index] := Arr[Index];
end;

function MakeArrayText(Arr: array of TextString): ArrayOfText;
var
  Index: Integer;
begin
  SetLength(Result, Length(Arr));
  for Index := 0 to Length(Result) - 1 do
    Result[Index] := Arr[Index];
end;

function DataStr(From: Pointer; Size: Integer): DataString;
begin
  SetString(Result, CastChar(From), Size);
end;

procedure ObjNil(out A);
begin
  TObject(A) := nil;
end;

procedure ObjNil(out A, B);
begin
  TObject(A) := nil;
  TObject(B) := nil;
end;

procedure ObjNil(out A, B, C);
begin
  TObject(A) := nil;
  TObject(B) := nil;
  TObject(C) := nil;
end;

procedure ObjNil(out A, B, C, D);
begin
  TObject(A) := nil;
  TObject(B) := nil;
  TObject(C) := nil;
  TObject(D) := nil;
end;

procedure ObjNil(out A, B, C, D, E);
begin
  TObject(A) := nil;
  TObject(B) := nil;
  TObject(C) := nil;
  TObject(D) := nil;
  TObject(E) := nil;
end;

procedure ObjNil(out A, B, C, D, E, F);
begin
  TObject(A) := nil;
  TObject(B) := nil;
  TObject(C) := nil;
  TObject(D) := nil;
  TObject(E) := nil;
  TObject(F) := nil;
end;

procedure ObjNil(out A, B, C, D, E, F, G);
begin
  TObject(A) := nil;
  TObject(B) := nil;
  TObject(C) := nil;
  TObject(D) := nil;
  TObject(E) := nil;
  TObject(F) := nil;
  TObject(G) := nil;
end;

procedure ObjNil(out A, B, C, D, E, F, G, H);
begin
  TObject(A) := nil;
  TObject(B) := nil;
  TObject(C) := nil;
  TObject(D) := nil;
  TObject(E) := nil;
  TObject(F) := nil;
  TObject(G) := nil;
  TObject(H) := nil;
end;

procedure ObjNil(out A, B, C, D, E, F, G, H, I);
begin
  TObject(A) := nil;
  TObject(B) := nil;
  TObject(C) := nil;
  TObject(D) := nil;
  TObject(E) := nil;
  TObject(F) := nil;
  TObject(G) := nil;
  TObject(H) := nil;
  TObject(I) := nil;
end;

procedure ObjNil(out A, B, C, D, E, F, G, H, I, J);
begin
  TObject(A) := nil;
  TObject(B) := nil;
  TObject(C) := nil;
  TObject(D) := nil;
  TObject(E) := nil;
  TObject(F) := nil;
  TObject(G) := nil;
  TObject(H) := nil;
  TObject(I) := nil;
  TObject(J) := nil;
end;

procedure ObjNil(out A, B, C, D, E, F, G, H, I, J, K);
begin
  TObject(A) := nil;
  TObject(B) := nil;
  TObject(C) := nil;
  TObject(D) := nil;
  TObject(E) := nil;
  TObject(F) := nil;
  TObject(G) := nil;
  TObject(H) := nil;
  TObject(I) := nil;
  TObject(J) := nil;
  TObject(K) := nil;
end;

procedure ObjNil(out A, B, C, D, E, F, G, H, I, J, K, L);
begin
  TObject(A) := nil;
  TObject(B) := nil;
  TObject(C) := nil;
  TObject(D) := nil;
  TObject(E) := nil;
  TObject(F) := nil;
  TObject(G) := nil;
  TObject(H) := nil;
  TObject(I) := nil;
  TObject(J) := nil;
  TObject(K) := nil;
  TObject(L) := nil;
end;

procedure ObjFree(var A);
begin
  TObject(A).Free();
end;

procedure ObjFree(var A, B);
begin
  TObject(A).Free();
  TObject(B).Free();
end;

procedure ObjFree(var A, B, C);
begin
  TObject(A).Free();
  TObject(B).Free();
  TObject(C).Free();
end;

procedure ObjFree(var A, B, C, D);
begin
  TObject(A).Free();
  TObject(B).Free();
  TObject(C).Free();
  TObject(D).Free();
end;

procedure ObjFree(var A, B, C, D, E);
begin
  TObject(A).Free();
  TObject(B).Free();
  TObject(C).Free();
  TObject(D).Free();
  TObject(E).Free();
end;

procedure ObjFree(var A, B, C, D, E, F);
begin
  TObject(A).Free();
  TObject(B).Free();
  TObject(C).Free();
  TObject(D).Free();
  TObject(E).Free();
  TObject(F).Free();
end;

procedure ObjFree(var A, B, C, D, E, F, G);
begin
  TObject(A).Free();
  TObject(B).Free();
  TObject(C).Free();
  TObject(D).Free();
  TObject(E).Free();
  TObject(F).Free();
  TObject(G).Free();
end;

procedure ObjFree(var A, B, C, D, E, F, G, H);
begin
  TObject(A).Free();
  TObject(B).Free();
  TObject(C).Free();
  TObject(D).Free();
  TObject(E).Free();
  TObject(F).Free();
  TObject(G).Free();
  TObject(H).Free();
end;

procedure ObjFree(var A, B, C, D, E, F, G, H, I);
begin
  TObject(A).Free();
  TObject(B).Free();
  TObject(C).Free();
  TObject(D).Free();
  TObject(E).Free();
  TObject(F).Free();
  TObject(G).Free();
  TObject(H).Free();
  TObject(I).Free();
end;

procedure ObjFree(var A, B, C, D, E, F, G, H, I, J);
begin
  TObject(A).Free();
  TObject(B).Free();
  TObject(C).Free();
  TObject(D).Free();
  TObject(E).Free();
  TObject(F).Free();
  TObject(G).Free();
  TObject(H).Free();
  TObject(I).Free();
  TObject(J).Free();
end;

procedure ObjFree(var A, B, C, D, E, F, G, H, I, J, K);
begin
  TObject(A).Free();
  TObject(B).Free();
  TObject(C).Free();
  TObject(D).Free();
  TObject(E).Free();
  TObject(F).Free();
  TObject(G).Free();
  TObject(H).Free();
  TObject(I).Free();
  TObject(J).Free();
  TObject(K).Free();
end;

procedure ObjFree(var A, B, C, D, E, F, G, H, I, J, K, L);
begin
  TObject(A).Free();
  TObject(B).Free();
  TObject(C).Free();
  TObject(D).Free();
  TObject(E).Free();
  TObject(F).Free();
  TObject(G).Free();
  TObject(H).Free();
  TObject(I).Free();
  TObject(J).Free();
  TObject(K).Free();
  TObject(L).Free();
end;

procedure UniqueString(var str: TextString); overload;
begin
  System.UniqueString(System.string(str));
end;

procedure UniqueString(var str: DataString); overload;
begin
  System.UniqueString(System.string(str));
end;

procedure UniqueString(var str: WideString); overload;
begin
  System.UniqueString(str);
end;

function ChrAdd(C: TextChar; O: Integer): TextChar;
begin
  Result := Chr(Ord(C) + O);
end;

function StrAsInt(const Str: DataString): Integer;
begin
  if Length(Str) <> 4 then
    Result := 0
  else
    Result := PInteger(Pointer(PDataChar_(Str)))^;
end;

function StrFromInt(const Int: Integer): DataString;
begin
  SetLength(Result, 4);
  PInteger(Pointer(PDataChar_(Result)))^ := Int;
end;

function ByteComparator(A, B: Pointer; SizeInBytes: Integer): Integer;
var
  Index: Integer;
begin
  for Index := 1 to SizeInBytes do
  begin
    Result := Integer(PByte(A)^) - Integer(PByte(B)^);
    if Result <> 0 then
    begin
      if Result > 0 then
        Result := Index
      else
        Result := -Index;
      Exit;
    end;
    Inc(PByte(A));
    Inc(PByte(B));
  end;
  Result := 0;
end;

function WordComparator(A, B: Pointer; SizeInWords: Integer): Integer;
var
  Index: Integer;
begin
  for Index := 1 to SizeInWords do
  begin
    Result := Integer(PWord(A)^) - Integer(PWord(B)^);
    if Result <> 0 then
    begin
      if Result > 0 then
        Result := Index
      else
        Result := -Index;
      Exit;
    end;
    Inc(PWord(A));
    Inc(PWord(B));
  end;
  Result := 0;
end;

function CompareWide(const A, B: WideString): Integer;
var
  Count: Integer;
begin
  Count := Length(A);
  if Length(B) < Count then
    Count := Length(B);
  if Count = 0 then
  begin
    Result := Length(A) - Length(B);
    Exit;
  end;
  Result := WordComparator(PWideChar(A), PWideChar(B), Count);
  if Result = 0 then
    Result := Length(A) - Length(B);
end;

function WideIsPrefix(const Short, Long: WideString): Boolean;
begin
  if Length(Long) < Length(Short) then
  begin
    Result := False;
    Exit;
  end;
  Result := CompareMem(Cast(Long), Cast(Short), Length(Short) * SizeOf(WideChar));
end;

function SizeToInt(const Size: RSize): Int64;
begin
  Result := 0;
  PSize(@Result).Lo := Size.Lo;
  PSize(@Result).Hi := Size.Hi;
end;

function SizeFromInt(Size: Int64): RSize;
begin
  Result.Lo := PSize(@Size).Lo;
  Result.Hi := PSize(@Size).Hi;
end;

function SizeFromHiLo(Hi, Lo: LongWord): RSize;
begin
  Result.Lo := Lo;
  Result.Hi := Hi;
end;

function SizeCompare(const A, B: RSize): Integer;
begin
  if A.Hi > B.Hi then
    Result := 1
  else if A.Hi < B.Hi then
    Result := -1
  else if A.Lo > B.Lo then
    Result := 1
  else if A.Lo < B.Lo then
    Result := -1
  else
    Result := 0;
end;

procedure SizeInc(var Size: RSize; const Add: RSize); overload;
var
  Value: Int64;
begin
  Value := SizeToInt(Size);
  Inc(Value, SizeToInt(Add));
  Size := SizeFromInt(Value);
end;

procedure SizeInc(var Size: RSize; const Add: Int64); overload;
var
  Value: Int64;
begin
  Value := SizeToInt(Size);
  Inc(Value, Add);
  Size := SizeFromInt(Value);
end;

end.

