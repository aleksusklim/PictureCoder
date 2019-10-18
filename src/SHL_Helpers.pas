unit SHL_Helpers; // SpyroHackingLib is licensed under WTFPL

interface

uses
  Windows, Classes, SHL_Files, SHL_Types;

type
  TIntegerListSortCompare = function(Item1, Item2: Integer): Integer;

  TIntegerList = class(TList)
  protected
    function Get(Index: Integer): Integer;
    procedure Put(Index: Integer; Item: Integer);
  public
    function Add(Item: Integer): Integer;
    function Extract(Item: Integer): Integer;
    function First(): Integer;
    function IndexOf(Item: Integer): Integer;
    procedure Insert(Index: Integer; Item: Integer);
    function Last(): Integer;
    function Remove(Item: Integer): Integer;
    procedure Sort(Compare: TIntegerListSortCompare; Dedup: Boolean = False);
    procedure SortAsc(Dedup: Boolean = False);
    procedure SortDsc(Dedup: Boolean = False);
    function CalcMaxDupsOnSorted(out Value: Integer): Integer;
    function Find(Value: Integer): Integer; overload;
    function Find(Value: Integer; var Index: Integer): Boolean; overload;
    property Items[Index: Integer]: Integer read Get write Put; default;
  public
    class procedure SelfTest();
  end;

type
  TStringValueList = class(TStringList)
  private
    function GetValue(Index: Integer): Integer;
    procedure PutValue(Index: Integer; Value: Integer);
  public
    function AddValue(const Line: DataString; Value: Integer): Integer;
    property Values[Index: Integer]: Integer read GetValue write PutValue;
    function WriteToFile(const FileName: WideString): Boolean;
    function ReadFromFile(const FileName: WideString): Boolean;
    procedure SortByValue(Asc: Boolean);
  end;

implementation

function IntegerListSortAsc(Item1, Item2: Pointer): Integer;
begin
  Result := Integer(Item1) - Integer(Item2);
end;

function IntegerListSortDsc(Item1, Item2: Pointer): Integer;
begin
  Result := Integer(Item2) - Integer(Item1);
end;

function TIntegerList.Get(Index: Integer): Integer;
begin
  Result := Integer(inherited Get(Index));
end;

procedure TIntegerList.Put(Index: Integer; Item: Integer);
begin
  inherited Put(Index, Pointer(Item));
end;

function TIntegerList.Add(Item: Integer): Integer;
begin
  Result := inherited Add(Pointer(Item));
end;

function TIntegerList.Extract(Item: Integer): Integer;
begin
  Result := Integer(inherited Extract(Pointer(Item)));
end;

function TIntegerList.First(): Integer;
begin
  Result := Integer(inherited First());
end;

function TIntegerList.IndexOf(Item: Integer): Integer;
begin
  Result := inherited IndexOf(Pointer(Item));
end;

procedure TIntegerList.Insert(Index: Integer; Item: Integer);
begin
  inherited Insert(Index, Pointer(Item));
end;

function TIntegerList.Last(): Integer;
begin
  Result := Integer(inherited Last());
end;

function TIntegerList.Remove(Item: Integer): Integer;
begin
  Result := inherited Remove(Pointer(Item));
end;

procedure TIntegerList.Sort(Compare: TIntegerListSortCompare; Dedup: Boolean);
var
  Index, Next: Integer;
begin
  inherited Sort(TListSortCompare(Compare));
  if Dedup then
  begin
    Next := Count - 1;
    for Index := Next downto 1 do
    begin
      if inherited Get(Index) = inherited Get(Index - 1) then
      begin
        inherited Put(Index, inherited Get(Next));
        Dec(Next);
      end;
    end;
    Count := Next + 1;
    inherited Sort(TListSortCompare(Compare));
  end;
end;

procedure TIntegerList.SortAsc(Dedup: Boolean);
begin
  Sort(@IntegerListSortAsc, Dedup);
end;

procedure TIntegerList.SortDsc(Dedup: Boolean);
begin
  Sort(@IntegerListSortDsc);
end;

function TIntegerList.CalcMaxDupsOnSorted(out Value: Integer): Integer;
var
  Index, Current: Integer;
  Have: Pointer;
begin
  if Count = 0 then
  begin
    Result := 0;
    Exit;
  end;
  Result := 1;
  Have := inherited Get(0);
  Current := 1;
  for Index := 1 to Count - 1 do
  begin
    if inherited Get(Index) = inherited Get(Index - 1) then
      Inc(Current)
    else
    begin
      if Current > Result then
      begin
        Result := Current;
        Have := inherited Get(Index - 1);
      end;
      Current := 1;
    end;
  end;
  if Current > Result then
  begin
    Result := Current;
    Have := inherited Get(Count - 1);
  end;
  Value := Integer(Have);
end;

function TIntegerList.Find(Value: Integer): Integer;
var
  L, H, I, C, D: Integer;
begin
  Result := -1;
  L := 0;
  H := Count - 1;
  if H < 0 then
    Exit;
  D := Integer(inherited Get(H)) - Integer(inherited Get(L));
  if D = 0 then
  begin
    Result := 0;
    Exit;
  end;
  while L <= H do
  begin
    I := (L + H) shr 1;
    if D < 0 then
      C := Value - Integer(inherited Get(I))
    else
      C := Integer(inherited Get(I)) - Value;
    if C < 0 then
      L := I + 1
    else
    begin
      if C = 0 then
      begin
        Result := I;
        Exit;
      end;
      H := I - 1;
    end;
  end;
end;

function TIntegerList.Find(Value: Integer; var Index: Integer): Boolean;
var
  Idx: Integer;
begin
  Idx := Find(Value);
  if Idx <> -1 then
  begin
    Index := Idx;
    Result := True;
  end
  else
    Result := False;
end;

class procedure TIntegerList.SelfTest();
var
  List: TIntegerList;

  procedure Print();
  var
    Index: Integer;
  begin
    for Index := 0 to List.Count - 1 do
      Write(List[Index], ' ');
    Writeln('');
  end;

var
  Index, Value: Integer;
begin
  List := TIntegerList.Create();
  for Index := 0 to 25 do
    List.Add(Random(10));
  Print();
  List.SortAsc(False);
  Print();
  for Index := 0 to 25 do
    if List.Find(Index, Value) then
      Write(Index, '(', Value, '),');
  Writeln('');
  List.SortDsc(False);
  Print();
  for Index := 0 to 25 do
    if List.Find(Index, Value) then
      Write(Index, '(', Value, '),');
  Writeln('');
  Write(List.CalcMaxDupsOnSorted(Index));
  Writeln(', ', Index);
  List.SortAsc(True);
  Print();
  List.Free();
end;

function TStringValueList.GetValue(Index: Integer): Integer;
begin
  Result := Integer(Pointer(Objects[Index]));
end;

procedure TStringValueList.PutValue(Index: Integer; Value: Integer);
begin
  Objects[Index] := Pointer(Value);
end;

function TStringValueList.AddValue(const Line: DataString; Value: Integer): Integer;
begin
  Result := AddObject(Line, Pointer(Value));
end;

function TStringValueList.WriteToFile(const FileName: WideString): Boolean;
var
  Stream: THandleStream;
begin
  Result := False;
  Stream := SFiles.OpenNew(FileName);
  if Stream = nil then
    Exit;
  try
    SaveToStream(Stream);
    Result := True;
  except
  end;
  SFiles.CloseStream(Stream);
end;

function TStringValueList.ReadFromFile(const FileName: WideString): Boolean;
var
  Stream: THandleStream;
begin
  Result := False;
  Stream := SFiles.OpenRead(FileName);
  if Stream = nil then
    Exit;
  try
    LoadFromStream(Stream);
    Result := True;
  except
  end;
  SFiles.CloseStream(Stream);
end;

function TStringValueList_SortByValue_Asc(List: TStringList; Index1, Index2:
  Integer): Integer;
begin
  Result := TStringValueList(List).Values[Index1] - TStringValueList(List).Values[Index2];
end;

function TStringValueList_SortByValue_Dsc(List: TStringList; Index1, Index2:
  Integer): Integer;
begin
  Result := TStringValueList(List).Values[Index2] - TStringValueList(List).Values[Index1];
end;

procedure TStringValueList.SortByValue(Asc: Boolean);
begin
  if Asc then
    CustomSort(TStringValueList_SortByValue_Asc)
  else
    CustomSort(TStringValueList_SortByValue_Dsc);
end;

end.

