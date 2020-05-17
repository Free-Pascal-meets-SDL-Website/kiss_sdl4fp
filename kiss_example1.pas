program kiss_example1;

{<
  Translation of example program kiss_example1.c (version 1.2.0).

  This program is part of the C to Free Pascal conversion project kiss_sdl4fp.
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

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  SysUtils,
  FileUtil, // Lazarus or Delphi unit
  SDL2,
  kiss_draw,
  kiss_posix,
  kiss_general,
  kiss_widgets;

var
  renderer: PSDL_Renderer;
  e: TSDL_Event;
  objects, a1, a2: Tkiss_array;
  window1, window2: Tkiss_window;
  label1, label2, label_sel, label_res: Tkiss_label;
  button_ok1, button_ok2, button_cancel: Tkiss_button;
  textbox1, textbox2: Tkiss_textbox;
  vscrollbar1, vscrollbar2: Tkiss_vscrollbar;
  progressbar: Tkiss_progressbar;
  entry: Tkiss_entry;
  textbox_width, textbox_height, window2_width, window2_height, draw, quit:
    LongInt;

procedure text_reset(textbox: Pkiss_textbox; vscrollbar: Pkiss_vscrollbar);
begin
  { Conv.: Quicksort algorithm qsort() not implemented here. In Windows the
           file items are sorted anyways, in Linux they are not. }
  vscrollbar^.step := 0.0;
  if (textbox^.array_^.length - textbox^.maxlines > 0) then
    vscrollbar^.step := 1.0 / (textbox^.array_^.length - textbox^.maxlines);
  textbox^.firstline := 0;
  textbox^.highlightline := -1;
  vscrollbar^.fraction := 0.0;
end;

{ Read directory entries into the textboxes }
procedure dirent_read(textbox1: Pkiss_textbox; vscrollbar1: Pkiss_vscrollbar;
  textbox2: Pkiss_textbox; vscrollbar2: Pkiss_vscrollbar;
  label_sel: Pkiss_label);
var
  ent: PKiss_dirent;
  s: Tkiss_stat; // TSearchRec
  dir: Pkiss_dir;
  buf: string;
begin
  kiss_array_free(textbox1^.array_);
  kiss_array_free(textbox2^.array_);
  kiss_array_new(textbox1^.array_);
  kiss_array_new(textbox2^.array_);
  kiss_getcwd(buf);
  kiss_string_copy(label_sel^.text, buf, DirectorySeparator);
  dir := kiss_opendir(AllDirectoryEntriesMask);
  ent := kiss_readdir(dir);
  while (Assigned(ent)) do
  begin
    if (ent^.d_name = '') then
      continue;
    s := dir^.fdata;
    if (kiss_isdir(s) = 0) then
      kiss_array_appendstring(textbox1^.array_, STRING_TYPE, ent^.d_name,
        DirectorySeparator)
    else if (kiss_isreg(s) = 0) then
      kiss_array_appendstring(textbox2^.array_, STRING_TYPE, ent^.d_name, '');
    ent := kiss_readdir(dir);
  end;
  kiss_closedir(dir);
  text_reset(textbox1, vscrollbar1);
  text_reset(textbox2, vscrollbar2);
end;

{ The widget arguments are widgets that this widget talks with }
procedure textbox1_event(textbox: Pkiss_textbox; e: PSDL_Event;
  vscrollbar1: Pkiss_vscrollbar; textbox2: Pkiss_textbox;
  vscrollbar2: Pkiss_vscrollbar; label_sel: Pkiss_label; draw: PLongInt);
var
  index: LongInt;
begin
  if (kiss_textbox_event(textbox, e, draw) <> 0) then
  begin
    index := textbox^.firstline + textbox^.selectedline;
    if (PString(kiss_array_data(textbox^.array_, index))^ <> '') then
    begin
      textbox^.selectedline := -1;
      kiss_chdir(PString(kiss_array_data((textbox^.array_), index))^);
      dirent_read(textbox, vscrollbar1, textbox2, vscrollbar2, label_sel);
      draw^ := 1;
    end;
  end;
end;

procedure vscrollbar1_event(vscrollbar: Pkiss_vscrollbar; e: PSDL_Event;
  textbox1: Pkiss_textbox; draw: PLongInt);
var
  firstline: LongInt;
begin
  if (kiss_vscrollbar_event(vscrollbar, e, draw) <> 0) and
    (textbox1^.array_^.length - textbox1^.maxlines > 0) then
  begin
    firstline := Round((textbox1^.array_^.length - textbox1^.maxlines) *
      vscrollbar^.fraction + 0.5);
    if firstline >= 0 then
      textbox1^.firstline := firstline;
    draw^ := 1;
  end;
end;

procedure textbox2_event(textbox: Pkiss_textbox; e: PSDL_Event;
  vscrollbar2: Pkiss_vscrollbar; entry: Pkiss_entry; draw: PLongInt);
var
  index: LongInt;
begin
  if kiss_textbox_event(textbox, e, draw) <> 0 then
  begin
    index := textbox^.firstline + textbox^.selectedline;
    if PAnsiString(kiss_array_data(textbox^.array_, index))^ <> '' then
    begin
      kiss_string_copy(entry^.text,
        PAnsiString(kiss_array_data(textbox^.array_, index))^, '');
      draw^ := 1;
    end;
  end;
end;

procedure vscrollbar2_event(vscrollbar: Pkiss_vscrollbar; e: PSDL_Event;
  textbox2: Pkiss_textbox; draw: PLongInt);
var
  firstline: LongInt;
begin
  if (kiss_vscrollbar_event(vscrollbar, e, draw) <> 0) and
    (textbox2^.array_^.Length <> 0) then
  begin
    firstline := Round((textbox2^.array_^.length - textbox2^.maxlines) *
      vscrollbar^.fraction + 0.5);
    if firstline >= 0 then
      textbox2^.firstline := firstline;
    draw^ := 1;
  end;
end;

procedure button_ok1_event(button: Pkiss_button; e: PSDL_Event;
  window1: Pkiss_window; window2: Pkiss_window; label_sel: Pkiss_label;
  entry: Pkiss_entry; label_res: Pkiss_label; progressbar: Pkiss_progressbar;
  draw: PLongInt);
var
  buf: string;
begin
  if kiss_button_event(button, e, draw) <> 0 then
  begin
    kiss_string_copy(buf, label_sel^.text, entry^.text);
    //kiss_string_copy(label_res^.text,
    //  'The following path was selected:'+LineEnding, buf);
                                { Conv.: C's \n newline cmd. doesn't work here;
                                  not really necessary though. }
    kiss_string_copy(label_res^.text, buf, '');
    window2^.visible := 1;
    window2^.focus := 1;
    window1^.focus := 0;
    button^.prelight := 0;
    progressbar^.fraction := 0;
    progressbar^.run := 1;
    draw^ := 1;
  end;
end;

procedure button_cancel_event(button: Pkiss_button; e: PSDL_Event;
  quit: PLongInt; draw: PLongInt);
begin
  if kiss_button_event(button, e, draw) <> 0 then
    quit^ := 1;
end;

procedure button_ok2_event(button: Pkiss_button; e: PSDL_Event;
  window1: Pkiss_window; window2: Pkiss_window; progressbar: Pkiss_progressbar;
  draw: PLongInt);
begin
  if kiss_button_event(button, e, draw) <> 0 then
  begin
    window2^.visible := 0;
    window1^.focus := 1;
    button^.prelight := 0;
    progressbar^.fraction := 0.0;
    progressbar^.run := 0;
    draw^ := 1;
  end;
end;

begin
  quit := 0;
  draw := 1;
  textbox_width := 250;
  textbox_height := 250;
  window2_width := 400;
  window2_height := 168;
  renderer := kiss_init('kiss_sdl example 1', @objects, 640, 480);
  if not Assigned(renderer) then
    halt(1);
  kiss_array_new(@a1);
  kiss_array_append(@objects, ARRAY_TYPE, @a1);
  kiss_array_new(@a2);
  kiss_array_append(@objects, ARRAY_TYPE, @a2);

  { Arrange the widgets nicely relative to each other }
  kiss_window_new(@window1, nil, 1, 0, 0, kiss_screen_width,
    kiss_screen_height);
  kiss_textbox_new(@textbox1, @window1, 1, @a1, kiss_screen_width div 2 -
    (2 * textbox_width + 2 * kiss_up.w - kiss_edge) div 2, 3 * kiss_normal.h,
    textbox_width, textbox_height);
  kiss_vscrollbar_new(@vscrollbar1, @window1, textbox1.rect.x +
    textbox_width, textbox1.rect.y, textbox_height);
  kiss_textbox_new(@textbox2, @window1, 1, @a2, vscrollbar1.uprect.x +
    kiss_up.w, textbox1.rect.y, textbox_width, textbox_height);
  kiss_vscrollbar_new(@vscrollbar2, @window1, textbox2.rect.x +
    textbox_width, vscrollbar1.uprect.y, textbox_height);
  kiss_label_new(@label1, @window1, 'Folders', textbox1.rect.x +
    kiss_edge, textbox1.rect.y - kiss_textfont.lineheight);
  kiss_label_new(@label2, @window1, 'Files', textbox2.rect.x +
    kiss_edge, textbox1.rect.y - kiss_textfont.lineheight);
  kiss_label_new(@label_sel, @window1, ' ', textbox1.rect.x +
    kiss_edge, textbox1.rect.y + textbox_height + kiss_normal.h);
  kiss_entry_new(@entry, @window1, 1, 'kiss', textbox1.rect.x,
    label_sel.rect.y + kiss_textfont.lineheight, 2 * textbox_width +
    2 * kiss_up.w + kiss_edge);
  kiss_button_new(@button_cancel, @window1, 'Cancel',
    entry.rect.x + entry.rect.w - kiss_edge - kiss_normal.w,
    entry.rect.y + entry.rect.h + kiss_normal.h);
  kiss_button_new(@button_ok1, @window1, 'OK', button_cancel.rect.x -
    2 * kiss_normal.w, button_cancel.rect.y);
  kiss_window_new(@window2, nil, 1, kiss_screen_width div 2 -
    window2_width div 2, kiss_screen_height div 2 - window2_height div 2,
    window2_width, window2_height);
  { Conv.: To create an empty label, the #0 character is used here by chr(0),
    as in the C version. If you use '' (empty string) it will translate to a nil
    pointer and prevent the label from being created at all. }
  kiss_label_new(@label_res, @window2, chr(0), window2.rect.x + kiss_up.w,
    window2.rect.y + kiss_vslider.h);
  label_res.textcolor := kiss_blue;
  kiss_progressbar_new(@progressbar, @window2,
    window2.rect.x + kiss_up.w - kiss_edge,
    window2.rect.y + window2.rect.h div 2 - kiss_bar.h div 2 - kiss_border,
    window2.rect.w - 2 * kiss_up.w + 2 * kiss_edge);
  kiss_button_new(@button_ok2, @window2, 'OK',
    window2.rect.x + window2.rect.w div 2 - kiss_normal.w div 2,
    progressbar.rect.y + progressbar.rect.h + 2 * kiss_vslider.h);

  dirent_read(@textbox1, @vscrollbar1, @textbox2, @vscrollbar2, @label_sel);
  { Do that, and all widgets associated with the window will show }
  window1.visible := 1;

  while not(quit <> 0) do
  begin

    { Some code may be written here }

    SDL_Delay(10);
    while (SDL_PollEvent(@e) <> 0) do
    begin
      if e.type_ = SDL_QUITEV then
        quit := 1;

      kiss_window_event(@window1, @e, @draw);
      kiss_window_event(@window2, @e, @draw);
      textbox1_event(@textbox1, @e, @vscrollbar1, @textbox2, @vscrollbar2,
        @label_sel, @draw);
      vscrollbar1_event(@vscrollbar1, @e, @textbox1, @draw);
      textbox2_event(@textbox2, @e, @vscrollbar2, @entry, @draw);
      vscrollbar2_event(@vscrollbar2, @e, @textbox2, @draw);
      button_ok1_event(@button_ok1, @e, @window1, @window2, @label_sel, @entry,
        @label_res, @progressbar, @draw);
      button_cancel_event(@button_cancel, @e, @quit, @draw);
      kiss_entry_event(@entry, @e, @draw);
      button_ok2_event(@button_ok2, @e, @window1, @window2, @progressbar,
        @draw);
    end;
    vscrollbar1_event(@vscrollbar1, nil, @textbox1, @draw);
    vscrollbar2_event(@vscrollbar2, nil, @textbox2, @draw);
    kiss_progressbar_event(@progressbar, nil, @draw);

    if not(draw <> 0) then
      continue;
    SDL_RenderClear(renderer);

    kiss_window_draw(@window1, renderer);
    kiss_label_draw(@label1, renderer);
    kiss_label_draw(@label2, renderer);
    kiss_textbox_draw(@textbox1, renderer);
    kiss_vscrollbar_draw(@vscrollbar1, renderer);
    kiss_textbox_draw(@textbox2, renderer);
    kiss_vscrollbar_draw(@vscrollbar2, renderer);
    kiss_label_draw(@label_sel, renderer);
    kiss_entry_draw(@entry, renderer);
    kiss_button_draw(@button_ok1, renderer);
    kiss_button_draw(@button_cancel, renderer);
    kiss_window_draw(@window2, renderer);
    kiss_label_draw(@label_res, renderer);
    kiss_progressbar_draw(@progressbar, renderer);
    kiss_button_draw(@button_ok2, renderer);

    SDL_RenderPresent(renderer);
    draw := 0;
  end;
  kiss_clean(@objects);
end.







