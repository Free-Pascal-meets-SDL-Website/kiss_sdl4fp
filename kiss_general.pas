unit kiss_general;

{<
  This unit is part of the C to Free Pascal conversion project kiss_sdl4fp.
  It converts the

    kiss_sdl widget toolkit
    Copyright (c) 2016 Tarvo Korrovits <tkorrovi@mail.com>.

  The original files are:

    kiss_sdl.h (version 1.2.0, in parts automatically converted by H2Pas 1.0.0)
    kiss_posix.c (version 1.2.0)
    kiss_general.c (version 1.2.0)
    kiss_widgets.c (version 1.2.4)
    kiss_draw.c (version 1.2.4).

  For more information on kiss_sdl4fp, visit:
  https://github.com/Free-Pascal-meets-SDL-Website/kiss_sdl4fp

  Copyright (c) 2020 Matthias J. Molski

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to
  deal in the Software without restriction, including without limitation the
  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
  sell copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
  IN THE SOFTWARE.
}

{$I kiss_sdl.inc}

interface

uses
  SDL2,
  SysUtils;

const
  {$IFDEF WINDOWS}
   External_library='kernel32'; {Setup as you need}
  {$ELSE}
   External_library='';
  {$ENDIF}

const
  KISS_MAX_LENGTH = 200;
  KISS_MIN_LENGTH = 10;
  KISS_MAX_LABEL = 500;
  KISS_MAGIC = 12345;

const
  OTHER_TYPE = 1;
  WINDOW_TYPE = 2;
  RENDERER_TYPE = 3;
  TEXTURE_TYPE = 4;
  SURFACE_TYPE = 5;
  FONT_TYPE = 6;
  STRING_TYPE = 7;
  ARRAY_TYPE = 8;

type
  Pkiss_array = ^kiss_array;
  kiss_array = record
      data : Ppointer;
      id : PLongInt;
      length : LongInt; { --> obsolete in Free Pascal, bc. contained in Length(arr), not true bc. array system of FP not used here }
      size : LongInt; { --> obsolete in Free Pascal, bc. automatically managed FP, not true bc. array system of FP not used here }
      ref : LongInt; { single ref. value for entire array, store in 0th element? }
    end;
  Tkiss_array = kiss_array;

function kiss_makerect(rect:PSDL_Rect; x:LongInt; y:LongInt; w:LongInt; h:LongInt):LongInt;

function kiss_pointinrect(x:LongInt; y:LongInt; rect:PSDL_Rect):LongInt;

function kiss_string_copy(var dest:string; str1:string; str2:string):string;

function kiss_string_compare(const a:string; const b:string):LongInt;

function kiss_backspace(var str:string):string;

function kiss_array_new(a: Pkiss_array):LongInt;

function kiss_array_data(a:Pkiss_array; index:LongInt):pointer;

function kiss_array_id(var a:Pkiss_array; index:LongInt):LongInt;

//function kiss_array_assign(var a:kiss_array; index:LongInt; id:LongInt; data:pointer):LongInt;cdecl;external External_library name 'kiss_array_assign';

function kiss_array_append(a:Pkiss_array; id:LongInt; data:pointer):LongInt;

function kiss_array_appendstring(a:Pkiss_array; id:LongInt; text1:string; text2:string):LongInt;

//function kiss_array_insert(var a:kiss_array; index:LongInt; id:LongInt; data:pointer):LongInt;cdecl;external External_library name 'kiss_array_insert';

//function kiss_array_remove(var a:kiss_array; index:LongInt):LongInt;cdecl;external External_library name 'kiss_array_remove';

function kiss_array_free(a:Pkiss_array):LongInt;

implementation

  function kiss_makerect(rect: PSDL_Rect; x: LongInt; y: LongInt; w: LongInt;
    h: LongInt): LongInt;
  begin
    if not Assigned(rect) then
    begin
      Result := -1;
      Exit;
    end;
    rect^.x := x;
    rect^.y := y;
    rect^.w := w;
    rect^.h := h;
    Result := 0;
  end;

  function kiss_pointinrect(x: LongInt; y: LongInt; rect: PSDL_Rect): LongInt;
  begin
    Result := 0;
    if (x >= rect^.x) and (x < rect^.x + rect^.w) and (y >= rect^.y) and
      (y < rect^.y + rect^.h) then
      Result := 1;
  end;

  function kiss_string_copy(var dest: string; str1: string;
    str2: string): string;
  begin
    dest := '';
    if (str1 <> '') then
      dest := dest + str1;
    if not(str2 <> '') then
    begin
      Result := dest;
      Exit;
    end;
    dest := dest + str2;
    Result := dest;
  end;

  function kiss_string_compare(const a: string; const b: string): LongInt;
  begin
    Result := CompareStr(a, b);
  end;

  function kiss_backspace(var str: string): string;
  begin
    if (str = '') then
    begin
      Result := str;
      Exit;
    end;
    SetLength(str, Length(str)-1);
    Result := str;
  end;

  function kiss_array_new(a: Pkiss_array): LongInt;
  begin
    if not Assigned(a) then
    begin
      Result := -1;
      Exit;
    end;
    a^.size := KISS_MIN_LENGTH;
    a^.length := 0;
    a^.ref := 1;
    a^.data := GetMem(KISS_MIN_LENGTH * SizeOf(pointer));
    a^.id := GetMem(KISS_MIN_LENGTH * SizeOf(LongInt));
  end;

  function kiss_array_data(a: Pkiss_array; index: LongInt): pointer;
  begin
    if (index < 0) or (index >= a^.size) or (not Assigned(a)) then
      Result := nil
    else
      Result := a^.data[index];
  end;

  function kiss_array_id(var a: Pkiss_array; index: LongInt): LongInt;
  begin
    if (index < 0) or (index >= a^.size) or (not Assigned(a)) then
      Result := 0
    else
      Result := a^.id[index];
  end;

  function kiss_array_append(a: Pkiss_array; id: LongInt; data: pointer): LongInt;
  var
    i: LongInt;
  begin
    if not Assigned(a) then
    begin
      Result := -1;
      Exit;
    end;
    if a^.length >= a^.size then
    begin
      a^.size := a^.size * 2;
      a^.data := ReAllocMem(a^.data, a^.size * SizeOf(pointer));
      a^.id := ReAllocMem(a^.id, a^.size * SizeOf(LongInt));
      for i := a^.length to a^.size-1 do
      begin
        a^.data[i] := nil;
        a^.id[i] := 0;
      end;
    end;
    a^.data[a^.length] := data;
    a^.id[a^.length] := id;
    Inc(a^.length);
    Result := 0;
  end;

  function kiss_array_appendstring(a: Pkiss_array; id: LongInt;
    text1: string; text2: string): LongInt;
  var
    p: PString;
  begin
    if (not Assigned(a)) then
    begin
      Result := -1;
      Exit;
    end;
    New(p);
    kiss_string_copy(p^, text1, text2);
    kiss_array_append(a, id, p);
    Result := 0;
  end;

  function kiss_array_free(a: Pkiss_array): LongInt;
  var
    i: LongInt;
  begin
    if (not Assigned(a)) or (a^.ref = 0) then
    begin
      Result := -1;
      Exit;
    end;
    if a^.ref > 1 then
    begin
      Dec(a^.ref);
      Result := 0;
      Exit;
    end;
    if a^.length > 0 then
    begin
      for i := 0 to a^.length-1 do
        if a^.id[i] = STRING_TYPE then    // Conv.: necessary for string feature
          Dispose(PString(a^.data[i]))
        else
          FreeMem(a^.data[i]);
    end;
    FreeMem(a^.data);
    FreeMem(a^.id);
    a^.data := nil;
    a^.id := nil;
    a^.size := 0;
    a^.length := 0;
    a^.ref := 0;
    Result := 0;
  end;

end.

