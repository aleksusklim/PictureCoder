program PictureCoder2;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  SysUtils,
  Classes,
  Math,
  Graphics,
  PNGImage,
  SHL_Files,
  SHL_TextUtils,
  SHL_Types;

const
  P0 = 19778;
  P1 = 0;
  P2 = 54;
  P3 = 40;
  P4 = 1572865;
  P5 = 0;

type
  RHeader = packed record
    P0: Word;
    Size, P1, P2, P3, Width, Height, P4, P5, Data: Integer;
    P7: array[0..15] of Byte;
    My: Byte;
  end;

function MakeDivide(Divident, Divisor: Integer; var Large: Byte): Integer;
begin
  Large := Divident mod Divisor;
  if Large = 0 then
  begin
    Result := Divident;
    Large := 1;
  end
  else if Large < (Divisor div 2) then
  begin
    Result := Divident - Large;
    Large := 0;
  end
  else
  begin
    Result := Divisor - Large + Divident;
    Large := 1;
  end;
end;

function SetDivide(Divident, Divisor: Integer; Large: Boolean): Integer;
begin
  Result := Divident mod Divisor;
  if Result = 0 then
    Result := Divident
  else if Large then
    Result := Divisor - Result + Divident
  else
    Result := Divident - Result;
end;

function Main(Filename: WideString): Boolean;
var
  Width, Height, Modifer, Size, Square, Last, Count, Good, New, Curr: Integer;
  Divider: Real;
  lSquare: Byte;
  Head: RHeader;
  Ok: Boolean;
  Ext: TextString;
  Buf: DataString;
  Wide: WideString;
  Data: Integer;
var
  Mem: TMemoryStream;
  Png: TPNGObject;
  Bmp: TBitmap;
  Stream: THandleStream;
begin
  Result := False;
  if Filename = '' then
    Exit;
  Stream := nil;
  ObjNil(Png, Bmp, Mem);
  try
    Ext := UTF8Encode(SFiles.GetExtension(Filename, True, True));
    if Ext = 'png' then
    begin
      Bmp := TBitmap.Create();
      Png := TPNGObject.Create();
      Stream := SFiles.OpenRead(Filename);
      Assure(Stream <> nil);
      Png.LoadFromStream(Stream);
      SFiles.CloseStream(Stream);
      Bmp.Assign(Png);
      FreeAndNil(Png);
      Mem := TMemoryStream.Create();
      Bmp.SaveToStream(Mem);
      FreeAndNil(Bmp);
      Mem.Position := 0;
      Mem.ReadBuffer(Head, SizeOf(Head));
      SetLength(Ext, Head.My);
      if Length(Ext) > 0 then
        Mem.ReadBuffer(Cast(Ext)^, Head.My);
      Mem.ReadBuffer(Count, 4);
      Wide := UTF8Decode(Trim(STextUtils.StringFilter(Ext, [#0, '\', '/', '.'],
        '_', True)));
      if Wide = '' then
        Wide := '~';
      Stream := SFiles.OpenNew(Filename + '.' + Wide);
      if Count > 0 then
        Stream.CopyFrom(Mem, Count);
      FreeAndNil(Mem);
      SFiles.CloseStream(Stream);
    end
    else
    begin
      if Length(Ext) > 255 then
        Ext := Copy(Ext, 1, 255);
      Modifer := 8;
      Divider := 4 / 3;
      Stream := SFiles.OpenRead(Filename);
      Assure(Stream.Size < $7fffffff);
      if Ext = '' then
        Ext := '~';
      Data := Stream.Size + 5 + Length(Ext);
      Size := Ceil(Data / 3);
      Square := MakeDivide(Round(Sqrt(Size)), Modifer, lSquare);
      Width := SetDivide(Round(Sqrt(Size * Divider)), Modifer, false);
      Height := SetDivide(Round(Sqrt(Size / Divider)), Modifer, True);
      if Width * Height = 0 then
      begin
        Square := SetDivide(Round(Sqrt(Size)), Modifer, True);
        Width := Square;
        lSquare := 1;
        Height := Ceil(Size / Width);
      end;
      Last := $7fffffff;
      Good := Last;
      Count := 0;
      Ok := False;
      repeat
        if Odd(Count + lSquare) then
          New := Square + Count * Modifer
        else
          New := Square - Count * Modifer;
        if New < 1 then
        begin
          Inc(Count);
          if Ok then
            Break;
          Ok := True;
          Continue;
        end;
        Curr := (New * Ceil(Size / New)) - Size;
        if (Curr < Last) and (New <= Width) and (New >= Height) then
        begin
          Last := Curr;
          Good := New;
        end;
        if Ok then
          Break;
        if (New > Width) or (New < Height) then
          Ok := True;
        Inc(Count);
      until False;
      if Good = $7fffffff then
        Good := Square;
      Width := Good;
      Height := Ceil(Size / Good);
      FillChar(Head, SizeOf(Head), #0);
      Head.P0 := P0;
      Head.P1 := P1;
      Head.P2 := P2;
      Head.P3 := P3;
      Head.P4 := P4;
      Head.P5 := P5;
      Head.Data := Data;
      Head.Width := Width;
      Head.Height := Height;
      Head.Size := (SizeOf(Head) - 1) + Width * Height * 3;
      Head.My := Length(Ext);
      Mem := TMemoryStream.Create();
      Mem.WriteBuffer(Head, SizeOf(Head));
      Mem.WriteBuffer(Cast(Ext)^, Head.My);
      Count := Stream.Size;
      Mem.WriteBuffer(Count, 4);
      if Count > 0 then
        Mem.CopyFrom(Stream, Count);
      Buf := StringOfChar(#0, Head.Size - Mem.Size);
      if Length(Buf) > 0 then
        Mem.WriteBuffer(Cast(Buf)^, Length(Buf));
      SFiles.CloseStream(Stream);
      Mem.Position := 0;
      Bmp := TBitmap.Create();
      Bmp.LoadFromStream(Mem);
      FreeAndNil(Mem);
      Png := TPNGObject.Create();
      Png.Assign(Bmp);
      Png.CompressionLevel := 8;
      Stream := SFiles.OpenNew(Filename + '.png');
      Png.SaveToStream(Stream);
      FreeAndNil(Png);
      SFiles.CloseStream(Stream);
      FreeAndNil(Bmp);
    end;
    Result := True;
  except
  end;
  ObjFree(Png, Bmp, Mem);
end;

var
  Args: ArrayOfWide;
  Index: Integer;
  Fail: Integer;
  Wait: TextString;

begin
  Fail := 0;
  Args := SFiles.GetArguments();
  if Length(Args) < 2 then
  begin
    Writeln('PictureCoder2 v2.0, by Kly_Men_COmpany!');
    Writeln('Converts any file to PNG image and back.');
    Writeln('Usage: drag-and-drop .png or any file.');
    Writeln('Original file extension is preserved, supports Unicode.');
    Writeln('');
    Writeln('Press ENTER to exit.');
    ReadLn(Wait);
    Exit;
  end;
  for Index := 1 to Length(Args) - 1 do
  begin
    Write(Args[Index] + ' ... ');
    if Main(Args[Index]) then
      Writeln('ok')
    else
    begin
      Inc(Fail);
      Writeln(' FAIL!');
    end;
  end;
  if Fail = 0 then
    Writeln('No errors, exiting.')
  else
  begin
    Writeln('Errors: ', Fail, ', press ENTER to exit');
    ReadLn(Wait);
  end;
end.

