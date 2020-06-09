unit kiss_posix;

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
  SysUtils;

type
  Pkiss_stat = ^kiss_stat;
  kiss_stat = TSearchRec;
  Tkiss_stat = kiss_stat;

type
  Pkiss_dirent = ^kiss_dirent;
  kiss_dirent = record
    d_name : string;
  end;
  Tkiss_dirent = kiss_dirent;

  Pkiss_dir = ^kiss_dir;
  kiss_dir = record
    fhandle : LongInt; // Conv.: ptrdiff_t;
    fdata : TSearchRec; // Conv.: _finddata_t;
    ent : Tkiss_dirent;
    name : string;
  end;
  Tkiss_dir = kiss_dir;

type
  //stat = kiss_stat; // Conv.: Implement?
  dirent = kiss_dirent;
  //kiss_dir = DIR; // Conv.: Implement?

function kiss_getcwd(var buf: string):string;

function kiss_chdir(path:string):LongInt;

function kiss_getstat(pathname:string; buf:Pkiss_stat):LongInt;

function kiss_opendir(name:string):Pkiss_dir;

function kiss_readdir(dirp:Pkiss_dir):Pkiss_dirent;

function kiss_closedir(dirp:Pkiss_dir):LongInt;

function kiss_isdir(s:Tkiss_stat):LongInt;

function kiss_isreg(s:Tkiss_stat):LongInt;

implementation

  function kiss_getcwd(var buf: string): string;
  begin
    buf := GetCurrentDir;
    Result := GetCurrentDir;
  end;

  function kiss_chdir(path: string): LongInt;
  begin
    if SetCurrentDir(path) = False then
      Exit(-1);
    Result := 0;
  end;

  { Conv.: kiss_stat: contains file attr. like file creation date,
           file loc. on disk, ...
           FP provides analogue at "baseunix", but it isn't cross-platform!
           Solution: Instead of using Stat, use FP cross-platform functions. }
  function kiss_getstat(pathname: string; buf: Pkiss_stat): LongInt;
  begin
    {Conv.: Probably obsolete.}
  end;

  function kiss_opendir(name: string): Pkiss_dir;
  var
    dir: Pkiss_dir;
  begin
    if (name = '') then
      Exit(nil);
    New(dir);
    dir^.ent.d_name := '';
    dir^.name := name;
    dir^.fhandle := FindFirst(dir^.name, faAnyFile, dir^.fdata);
    if (dir^.fhandle <> 0) then
    begin
      FreeAndNil(dir);
      Exit(nil);
    end;
    Result := dir;
  end;

  function kiss_readdir(dirp: Pkiss_dir): Pkiss_dirent;
  begin
    if (dirp^.ent.d_name <> '') and (FindNext(dirp^.fdata) <> 0) then
      Exit(nil);
    dirp^.ent.d_name := dirp^.fdata.Name;
    Result := @dirp^.ent;
  end;

  function kiss_closedir(dirp: Pkiss_dir): LongInt;
  begin
    if (not Assigned(dirp)) or (dirp^.fhandle <> 0) then
      Exit(-1);
    FindClose(dirp^.fdata);

    Dispose(dirp);          //Conv.: FreeAndNil(dirp) --> SIGSEV
    dirp := nil;
    Result := 0;
  end;

  function kiss_isdir(s: Tkiss_stat): LongInt;
  begin
    if (s.Attr and faDirectory) = faDirectory then
      Exit(0)
    else
      Result := -1;
  end;

  function kiss_isreg(s: Tkiss_stat): LongInt; // Conv.: dummy func.
  begin                                        //        for code compatibility
    Result := 0;
  end;

end.

