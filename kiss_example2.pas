program kiss_example2;

{<
  Translation of example program kiss_example2.c (version 1.2.0).

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
  SDL2,
  SysUtils,
  kiss_general,
  kiss_posix,
  kiss_draw,
  kiss_widgets;

type
  TCity = record
    name: string;
    population: LongInt;
    area: LongInt;
  end;

const
  cities: array[0..29] of TCity = (
    (name: 'Atlanta'; population: 5268860; area: 8376),
    (name: 'Baltimore'; population: 2710489; area: 2710),
    (name: 'Boston'; population: 4552402; area: 1422),
    (name: 'Charlotte'; population: 2217012; area: 3198),
    (name: 'Chicago'; population: 9461105; area: 10856),
    (name: 'Cincinnati'; population: 2130151; area: 4808),
    (name: 'Cleveland'; population: 2077240; area: 82),
    (name: 'Dallas'; population: 6426214; area: 9286),
    (name: 'Denver'; population: 2543482; area: 155),
    (name: 'Detroit'; population: 4290060; area: 3888),
    (name: 'Houston'; population: 5920416; area: 10062),
    (name: 'Kansas City'; population: 2035334; area: 7952),
    (name: 'Los Angeles'; population: 12828837; area: 4850),
    (name: 'Miami'; population: 5564635; area: 6137),
    (name: 'Minneapolis'; population: 3279833; area: 8120),
    (name: 'New York'; population: 19069796; area: 13318),
    (name: 'Orlando'; population: 2134411; area: 4012),
    (name: 'Philadelphia'; population: 5965343; area: 5118),
    (name: 'Phoenix'; population: 4192887; area: 14598),
    (name: 'Pittsburgh'; population: 2356285; area: 5706),
    (name: 'Portland'; population: 2226009; area: 6684),
    (name: 'Sacramento'; population: 2149127; area: 21429),
    (name: 'San Antonio'; population: 2142508; area: 7387),
    (name: 'San Diego'; population: 3095313; area: 372),
    (name: 'San Francisco'; population: 4335391; area: 6984),
    (name: 'Seattle'; population: 4039809; area: 5872),
    (name: 'St. Louis'; population: 2812896; area: 8458),
    (name: 'Tampa'; population: 2783243; area: 2554),
    (name: 'Washington'; population: 5582170; area: 5564),
    (name: ''; population: 0; area: 0)
  );

var
  renderer: PSDL_Renderer;
  e: TSDL_Event;
  objects, a: Tkiss_array;
  window: Tkiss_window;
  label1, label2: Tkiss_label;
  button_ok: Tkiss_button;
  hscrollbar: Tkiss_hscrollbar;
  entry: Tkiss_entry;
  combobox: Tkiss_combobox;
  select1, select2: Tkiss_selectbutton;
  stext: string;
  combobox_width, combobox_height, entry_width: LongInt;
  first, draw, quit, i: LongInt;

  procedure select1_event(select1: Pkiss_selectbutton; e: PSDL_Event;
    select2: Pkiss_selectbutton; draw: PLongInt);
  begin
    if (kiss_selectbutton_event(select1, e, draw) <> 0) then
      select2^.selected := select2^.selected xor 1;
  end;

  procedure select2_event(select2: Pkiss_selectbutton; e: PSDL_Event;
    select1: Pkiss_selectbutton; draw: PLongInt);
  begin
    if (kiss_selectbutton_event(select2, e, draw) <> 0) then
      select1^.selected := select1^.selected xor 1;
  end;

procedure combobox_event(combobox: Pkiss_combobox; e: PSDL_Event; var stext: string;
  entry: Pkiss_entry; select1: Pkiss_selectbutton; select2: Pkiss_selectbutton;
  hscrollbar: Pkiss_hscrollbar; draw: PLongInt);
var
  p: PPointer;
  s: string;
begin
  { Conv.: Replaced the binary search by linear search for shorter code. }
  if (kiss_combobox_event(combobox, e, draw) <> 0) then
  begin
    s := combobox^.entry.text;
    p := combobox^.textbox.array_^.data;
    i := 0;
    for i := 0 to combobox^.textbox.array_^.length-1 do
    begin
      if not(kiss_string_compare(s, PString(p[i])^) <> 0) then
      begin
        if (select1^.selected <> 0) then
          stext := 'The population of the metropolitan area of ' +
            cities[i].name + ' is ' + IntToStr(cities[i].population) + '.'
        else
          stext := 'The metropolitan area of ' + cities[i].name +
            ' is ' + IntToStr(cities[i].area) + ' square miles.';
        break;
      end else
        stext := 'Data not found';
    end;
    entry^.text := stext;
    hscrollbar^.fraction := 0.;
    hscrollbar^.step := 0.;
    if (Length(stext) - entry^.textwidth / kiss_textfont.advance > 0) then
      hscrollbar^.step := 1. / (Length(stext) - entry^.textwidth /
        kiss_textfont.advance);
    entry^.text := Copy(stext, 1, Round(entry^.textwidth /
      kiss_textfont.advance));
    draw^ := 1;
  end;
end;

{ This is to show the hscrollbar, only works with ASCII characters }
procedure hscrollbar_event(hscrollbar: Pkiss_hscrollbar; e: PSDL_Event;
  var stext: string; first: PLongInt; entry: Pkiss_entry; draw: PLongInt);
var
  p: string;
begin
  p := stext;
  if (kiss_hscrollbar_event(hscrollbar, e, draw) <> 0) and (Length(stext) -
    entry^.textwidth / kiss_textfont.advance > 0) then
  begin
    first^ := Round((Length(stext) - entry^.textwidth /
      kiss_textfont.advance) * hscrollbar^.fraction + 0.5);
    if (first^ >= 0) then
    begin
      { Conv.: Copy() is 1-based, therefore first^+1. }
      entry^.text := Copy(p, first^+1, Round(entry^.textwidth /
        kiss_textfont.advance));
      draw^ := 1;
    end;
  end;
end;

procedure button_ok_event(button_ok: Pkiss_button; e: PSDL_Event;
quit: PLongInt; draw: PLongInt);
begin
  if kiss_button_event(button_ok, e, draw) <> 0 then
    quit^ := 1;
end;

begin
  quit := 0;
  draw := 1;
  first := 0;
  stext := '';
  { Combobox textbox width and height }
  combobox_width := 150;
  combobox_height := 66;
  entry_width := 250;
  renderer := kiss_init('kiss_sdl example 2', @objects, 640, 480);
  if not Assigned(renderer) then
    halt(1);
  kiss_array_new(@a);
  i := 0;
  while cities[i].population <> 0 do
  begin
    kiss_array_appendstring(@a, 0, cities[i].name, '');
    inc(i);
  end;
  kiss_array_append(@objects, ARRAY_TYPE, @a);

  { Arrange the widgets nicely relative to each other }
  kiss_window_new(@window, nil, 1, 0, 0, kiss_screen_width,
    kiss_screen_height);
  kiss_label_new(@label1, @window, 'Population', kiss_screen_width div 2 -
    (combobox_width + kiss_up.w - kiss_edge) div 2 + kiss_edge,
    6 * kiss_textfont.lineheight);
  kiss_selectbutton_new(@select1, @window, label1.rect.x + combobox_width +
    kiss_up.w - kiss_edge - kiss_selected.w, label1.rect.y +
    kiss_textfont.ascent - kiss_selected.h);
  kiss_label_new(@label2, @window, 'Area', label1.rect.x, label1.rect.y +
    2 * kiss_textfont.lineheight);
  kiss_selectbutton_new(@select2, @window, select1.rect.x, label2.rect.y +
    kiss_textfont.ascent - kiss_selected.h);
  kiss_combobox_new(@combobox, @window, 'none', @a, label1.rect.x -
    kiss_edge, label2.rect.y + 2 * kiss_textfont.lineheight, combobox_width,
    combobox_height);
  kiss_entry_new(@entry, @window, 1, '', kiss_screen_width div 2 -
    entry_width div 2 + kiss_edge, combobox.entry.rect.y +
    combobox.entry.rect.h + 2 * kiss_textfont.lineheight +
    kiss_border, entry_width);
  kiss_hscrollbar_new(@hscrollbar, @window, entry.rect.x,
    entry.rect.y + entry.rect.h, entry.rect.w);
  kiss_button_new(@button_ok, @window, 'OK',
    entry.rect.x + entry.rect.w - kiss_edge - kiss_normal.w,
    entry.rect.y + entry.rect.h + kiss_normal.h);

  select1.selected := 1;
  hscrollbar.step := 0.0;
  { Do that, and all widgets associated with the window will show }
  window.visible := 1;

  while not(quit <> 0) do
  begin

    { Some code may be written here }

    SDL_Delay(10);
    while (SDL_PollEvent(@e) <> 0) do
    begin
      if e.type_ = SDL_QUITEV then
        quit := 1;

      kiss_window_event(@window, @e, @draw);
      select1_event(@select1, @e, @select2, @draw);
      select2_event(@select2, @e, @select1, @draw);
      combobox_event(@combobox, @e, stext, @entry, @select1, @select2,
        @hscrollbar, @draw);
      hscrollbar_event(@hscrollbar, @e, stext, @first,
       @entry, @draw);
      button_ok_event(@button_ok, @e, @quit, @draw);
    end;
    kiss_combobox_event(@combobox, nil, @draw);
    hscrollbar_event(@hscrollbar, nil, stext, @first, @entry, @draw);

    if not(draw <> 0) then
      continue;
    SDL_RenderClear(renderer);

    kiss_window_draw(@window, renderer);
    kiss_button_draw(@button_ok, renderer);
    kiss_hscrollbar_draw(@hscrollbar, renderer);
    kiss_entry_draw(@entry, renderer);
    kiss_combobox_draw(@combobox, renderer);
    kiss_selectbutton_draw(@select2, renderer);
    kiss_label_draw(@label2, renderer);
    kiss_selectbutton_draw(@select1, renderer);
    kiss_label_draw(@label1, renderer);

    SDL_RenderPresent(renderer);
    draw := 0;
  end;
  kiss_clean(@objects);
end.







