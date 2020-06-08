unit kiss_widgets;

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
  kiss_draw,
  kiss_general;

type
  Pkiss_window = ^kiss_window;
  kiss_window = record
      visible : LongInt;
      focus : LongInt;
      rect : TSDL_Rect;
      decorate : LongInt;
      bg : TSDL_Color;
      wdw : Pkiss_window;
    end;
  Tkiss_window = kiss_window;

  Pkiss_label = ^kiss_label;
  kiss_label = record
      visible : LongInt;
      rect : TSDL_Rect;
      text : string;
      textcolor : TSDL_Color;
      font : kiss_font;
      wdw : Pkiss_window;
    end;
  Tkiss_label = kiss_label;

  Pkiss_button = ^kiss_button;
  kiss_button = record
      visible : LongInt;
      focus : LongInt;
      rect : TSDL_Rect;
      textx : LongInt;
      texty : LongInt;
      text : string;
      active : LongInt;
      prelight : LongInt;
      textcolor : TSDL_Color;
      font : kiss_font;
      normalimg : kiss_image;
      activeimg : kiss_image;
      prelightimg : kiss_image;
      wdw : Pkiss_window;
    end;
  Tkiss_button = kiss_button;

  Pkiss_selectbutton = ^kiss_selectbutton;
  kiss_selectbutton = record
      visible : LongInt;
      focus : LongInt;
      rect : TSDL_Rect;
      selected : LongInt;
      selectedimg : kiss_image;
      unselectedimg : kiss_image;
      wdw : Pkiss_window;
    end;
  Tkiss_selectbutton = kiss_selectbutton;

  Pkiss_vscrollbar = ^kiss_vscrollbar;
  kiss_vscrollbar = record
      visible : LongInt;
      focus : LongInt;
      uprect : TSDL_Rect;
      downrect : TSDL_Rect;
      sliderrect : TSDL_Rect;
      maxpos : LongInt;
      fraction : double;
      step : double;
      lasttick : dword;
      downclicked : LongInt;
      upclicked : LongInt;
      sliderclicked : LongInt;
      up : kiss_image;
      down : kiss_image;
      vslider : kiss_image;
      wdw : Pkiss_window;
    end;
  Tkiss_vscrollbar = kiss_vscrollbar;

  Pkiss_hscrollbar = ^kiss_hscrollbar;
  kiss_hscrollbar = record
      visible : LongInt;
      focus : LongInt;
      leftrect : TSDL_Rect;
      rightrect : TSDL_Rect;
      sliderrect : TSDL_Rect;
      maxpos : LongInt;
      fraction : double;
      step : double;
      lasttick : dword;
      leftclicked : LongInt;
      rightclicked : LongInt;
      sliderclicked : LongInt;
      left : kiss_image;
      right : kiss_image;
      hslider : kiss_image;
      wdw : Pkiss_window;
    end;
  Tkiss_hscrollbar = kiss_hscrollbar;

  Pkiss_progressbar = ^kiss_progressbar;
  kiss_progressbar = record
      visible : LongInt;
      rect : TSDL_Rect;
      barrect : TSDL_Rect;
      width : LongInt;
      fraction : double;
      step : double;
      bg : TSDL_Color;
      lasttick : dword;
      run : LongInt;
      bar : kiss_image;
      wdw : Pkiss_window;
    end;
  Tkiss_progressbar = kiss_progressbar;

  Pkiss_entry = ^kiss_entry;
  kiss_entry = record
      visible : LongInt;
      focus : LongInt;
      rect : TSDL_Rect;
      decorate : LongInt;
      textx : LongInt;
      texty : LongInt;
      text : string;
      active : LongInt;
      textwidth : LongInt;
      selection : array[0..3] of LongInt;
      cursor : array[0..1] of LongInt;
      normalcolor : TSDL_Color;
      activecolor : TSDL_Color;
      bg : TSDL_Color;
      font : kiss_font;
      wdw : Pkiss_window;
    end;
  Tkiss_entry = kiss_entry;

  Pkiss_textbox = ^kiss_textbox;
  kiss_textbox = record
      visible : LongInt;
      focus : LongInt;
      rect : TSDL_Rect;
      decorate : LongInt;
      array_ : Pkiss_array;
      textrect : TSDL_Rect;
      firstline : LongInt;
      maxlines : LongInt;
      textwidth : LongInt;
      highlightline : LongInt;
      selectedline : LongInt;
      selection : array[0..3] of LongInt;
      cursor : array[0..1] of LongInt;
      textcolor : TSDL_Color;
      hlcolor : TSDL_Color;
      bg : TSDL_Color;
      font : kiss_font;
      wdw : Pkiss_window;
    end;
  Tkiss_textbox = kiss_textbox;

  Pkiss_combobox = ^kiss_combobox;
  kiss_combobox = record
      visible : LongInt;
      text : string;
      entry : kiss_entry;
      window : kiss_window;
      vscrollbar : kiss_vscrollbar;
      textbox : kiss_textbox;
      combo : kiss_image;
      wdw : Pkiss_window;
    end;
  Tkiss_combobox = kiss_combobox;

function kiss_window_new(window:Pkiss_window; wdw:Pkiss_window;
  decorate:LongInt; x:LongInt; y:LongInt; w:LongInt; h:LongInt):LongInt;

function kiss_window_event(window:Pkiss_window; event:PSDL_Event; draw:PLongInt
  ):LongInt;

function kiss_window_draw(window:Pkiss_window; renderer:PSDL_Renderer):LongInt;

function kiss_label_new(label_:Pkiss_label; wdw:Pkiss_window; text:string;
  x:LongInt; y:LongInt):LongInt;

function kiss_label_draw(label_:Pkiss_label; renderer:PSDL_Renderer):LongInt;

function kiss_button_new(button:Pkiss_button; wdw:Pkiss_window; text:string;
  x:LongInt; y:LongInt):LongInt;

function kiss_button_event(button:Pkiss_button; event:PSDL_Event; draw:PLongInt
  ):LongInt;

function kiss_button_draw(button:Pkiss_button; renderer:PSDL_Renderer):LongInt;

function kiss_selectbutton_new(selectbutton: Pkiss_selectbutton;
  wdw: Pkiss_window; x:LongInt; y:LongInt):LongInt;

function kiss_selectbutton_event(selectbutton: Pkiss_selectbutton;
  event:PSDL_Event; draw: PLongInt):LongInt;

function kiss_selectbutton_draw(selectbutton: Pkiss_selectbutton;
  renderer:PSDL_Renderer):LongInt;

function kiss_vscrollbar_new(vscrollbar:Pkiss_vscrollbar; wdw:Pkiss_window;
  x:LongInt; y:LongInt; h:LongInt):LongInt;

function kiss_vscrollbar_event(vscrollbar:Pkiss_vscrollbar; event:PSDL_Event;
  draw:PLongInt):LongInt;

function kiss_vscrollbar_draw(vscrollbar:Pkiss_vscrollbar;
  renderer:PSDL_Renderer):LongInt;

function kiss_hscrollbar_new(hscrollbar:Pkiss_hscrollbar; wdw:Pkiss_window;
  x:LongInt; y:LongInt; w:LongInt):LongInt;

function kiss_hscrollbar_event(hscrollbar:Pkiss_hscrollbar; event:PSDL_Event;
  draw:PLongInt):LongInt;

function kiss_hscrollbar_draw(hscrollbar:Pkiss_hscrollbar;
  renderer:PSDL_Renderer):LongInt;

function kiss_progressbar_new(progressbar:Pkiss_progressbar; wdw:Pkiss_window;
  x:LongInt; y:LongInt; w:LongInt):LongInt;

function kiss_progressbar_event(progressbar:Pkiss_progressbar; event:PSDL_Event;
  draw:PLongInt):LongInt;

function kiss_progressbar_draw(progressbar:Pkiss_progressbar;
  renderer:PSDL_Renderer):LongInt;

function kiss_entry_new(entry:Pkiss_entry; wdw:Pkiss_window; decorate:LongInt;
  text:string; x:LongInt; y:LongInt; w:LongInt):LongInt;

function kiss_entry_event(entry:Pkiss_entry; event:PSDL_Event; draw:PLongInt
  ):LongInt;

function kiss_entry_draw(entry:Pkiss_entry; renderer:PSDL_Renderer):LongInt;

function kiss_textbox_new(textbox:Pkiss_textbox; wdw:Pkiss_window;
  decorate:LongInt; a:Pkiss_array; x:LongInt; y:LongInt; w:LongInt; h:LongInt
  ):LongInt;

function kiss_textbox_event(textbox:Pkiss_textbox; event:PSDL_Event;
  draw:PLongInt):LongInt;

function kiss_textbox_draw(textbox:Pkiss_textbox; renderer:PSDL_Renderer
  ):LongInt;

function kiss_combobox_new(combobox:Pkiss_combobox; wdw:Pkiss_window;
  text:string; a:Pkiss_array; x:LongInt; y:LongInt; w:LongInt; h:LongInt
  ):LongInt;

function kiss_combobox_event(combobox:Pkiss_combobox; event:PSDL_Event;
  draw:PLongInt):LongInt;

function kiss_combobox_draw(combobox:Pkiss_combobox; renderer:PSDL_Renderer
  ):LongInt;

implementation

  function kiss_window_new(window: Pkiss_window; wdw: Pkiss_window;
    decorate: LongInt; x: LongInt; y: LongInt; w: LongInt; h: LongInt): LongInt;
  begin
    if not Assigned(window) then
    begin
      result := -1;
      exit;
    end;
    window^.bg := kiss_white;
    kiss_makerect(@window^.rect, x, y, w, h);
    window^.decorate := decorate;
    window^.visible := 0;
    window^.focus := 1;
    window^.wdw := wdw;
    result := 0;
  end;

  function kiss_window_event(window: Pkiss_window; event: PSDL_Event;
    draw: PLongInt): LongInt;
  begin
    if (not Assigned(window)) or (not(window^.visible <> 0)) or
      (not Assigned(event)) then
    begin
      result := 0;
      exit;
    end;
    if (event^.type_ = SDL_WINDOWEVENT) and
      (event^.window.event = SDL_WINDOWEVENT_EXPOSED) then
      draw^ := 1;
    if (not(window^.focus <> 0)) and ((not Assigned(window^.wdw)) or
      ((Assigned(window^.wdw)) and (not(window^.wdw^.focus <> 0)))) then
    begin
      result := 0;
      exit;
    end;
    if (event^.type_ = SDL_MOUSEBUTTONDOWN) and (kiss_pointinrect(event^.button.x,
      event^.button.y, @window^.rect) <> 0) then
    begin
      result := 1;
      exit;
    end;
    result := 0;
  end;

  function kiss_window_draw(window: Pkiss_window; renderer: PSDL_Renderer
    ): LongInt;
  begin
    if Assigned(window) and Assigned(window^.wdw) then
      window^.visible := window^.wdw^.visible;
    if (not Assigned(window)) or (not(window^.visible <> 0)) or
      (not Assigned(renderer)) then
    begin
      result := 0;
      exit;
    end;
    kiss_fillrect(renderer, @window^.rect, window^.bg);
    if (window^.decorate <> 0) then
      kiss_decorate(renderer, @window^.rect, kiss_blue, kiss_edge);
    Result := 1;
  end;

  function kiss_label_new(label_: Pkiss_label; wdw: Pkiss_window;
    text: string; x: LongInt; y: LongInt): LongInt;
  begin
    if (not Assigned(label_)) then
      Exit(-1);
    if label_^.font.magic <> KISS_MAGIC then
      label_^.font := kiss_textfont;
    label_^.textcolor := kiss_black;
    kiss_makerect(@label_^.rect, x, y, 0, 0);
    kiss_string_copy(label_^.text, text, '');
    label_^.visible := 0;
    label_^.wdw := wdw;
    Result := 0;
  end;

  function kiss_label_draw(label_: Pkiss_label; renderer: PSDL_Renderer): LongInt;
  var
    len, y: LongInt;
  begin
    if (Assigned(label_) and Assigned(label_^.wdw)) then
      label_^.visible := label_^.wdw^.visible;
    if (not Assigned(label_)) or (not(label_^.visible <> 0)) or
      (not Assigned(renderer)) then
        Exit(0);
    y := label_^.rect.y + label_^.font.spacing div 2;
    len := Length(label_^.text); // Conv.: Probably obsolete for Pascal Strings.

    { Conv.: Original C Code: Inserts a line break, I guess.
	  if (len > KISS_MAX_LABEL - 2)
		  label->text[len - 1] = '\n';
	  else
		  strcat(label->text, "\n");
	  for (p = label->text; *p; p = strchr(p, '\n') + 1) {
		  kiss_string_copy(buf, strcspn(p, "\n") + 1, p, NULL);
		  kiss_rendertext()renderer, buf, label->rect.x, y,
			  label->font, label->textcolor);
		  y += label->font.lineheight;
	  }
    }

    kiss_rendertext(renderer, label_^.text, label_^.rect.x, y, label_^.font,
      label_^.textcolor);
    Result := 1;
  end;

  function kiss_button_new(button: Pkiss_button; wdw: Pkiss_window;
    text: string; x: LongInt; y: LongInt): LongInt;
  begin
    if (not Assigned(button)) or (Length(text) = 0) then
      Exit(-1);
    if button^.font.magic <> KISS_MAGIC then
      button^.font := kiss_buttonfont;
    if button^.normalimg.magic <> KISS_MAGIC then
      button^.normalimg := kiss_normal;
    if button^.activeimg.magic <> KISS_MAGIC then
      button^.activeimg := kiss_active;
    if button^.prelightimg.magic <> KISS_MAGIC then
      button^.prelightimg := kiss_prelight;
    kiss_makerect(@button^.rect, x, y, button^.normalimg.w, button^.normalimg.h);
    button^.textcolor := kiss_white;
    button^.text := text;
    button^.textx := x + button^.normalimg.w div 2 - kiss_textwidth(button^.font,
      text, '') div 2;
    button^.texty := y + button^.normalimg.h div 2 -
      button^.font.fontheight div 2;
    button^.active := 0;
    button^.prelight := 0;
    button^.visible := 0;
    button^.focus := 0;
    button^.wdw := wdw;
    Result := 0;
  end;

  function kiss_button_event(button: Pkiss_button; event: PSDL_Event;
    draw: PLongInt): LongInt;
  begin
    if (not Assigned(button)) or not(button^.visible <> 0) or
      (not Assigned(event)) then
      Exit(0);
    if (event^.type_ = SDL_WINDOWEVENT) and
      (event^.window.event = SDL_WINDOWEVENT_EXPOSED) then
      draw^ := 1;
    if not(button^.focus <> 0) and (not Assigned(button^.wdw) or
      ((Assigned(button^.wdw)) and not(button^.wdw^.focus <> 0))) then
      Exit(0);
    if (event^.type_ = SDL_MOUSEBUTTONDOWN) and (kiss_pointinrect(event^.button.x,
      event^.button.y, @button^.rect) <> 0) then
    begin
      button^.active := 1;
      draw^ := 1;
    end
    else if (event^.type_ = SDL_MOUSEBUTTONUP) and
      (kiss_pointinrect(event^.button.x, event^.button.y, @button^.rect) <> 0) and
      (button^.active = 1) then
    begin
      button^.active := 0;
      draw^ := 1;
      Result := 1;
      Exit;
    end
    else if (event^.type_ = SDL_MOUSEMOTION) and
      (kiss_pointinrect(event^.motion.x, event^.motion.y, @button^.rect) <> 0) then
    begin
      button^.prelight := 1;
      draw^ := 1;
    end
    else if (event^.type_ = SDL_MOUSEMOTION) and
      not(kiss_pointinrect(event^.motion.x, event^.motion.y, @button^.rect) <> 0) then
    begin
      button^.prelight := 0;
      draw^ := 1;
      if (button^.active <> 0) then
      begin
        button^.active := 0;
        Result := 1;
        Exit;
      end;
    end;
    Result := 0;
  end;

  function kiss_button_draw(button: Pkiss_button; renderer: PSDL_Renderer
    ): LongInt;
  begin
    if Assigned(button) and Assigned(button^.wdw) then
      button^.visible := button^.wdw^.visible;
    if (not Assigned(button)) or not(button^.visible <> 0) or
      (not Assigned(renderer)) then
    begin
      result := 0;
      exit;
    end;
    if button^.active = 1 then
      kiss_renderimage(renderer, button^.activeimg, button^.rect.x,
        button^.rect.y, nil)
    else if (button^.prelight = 1) and (button^.active = 0) then
      kiss_renderimage(renderer, button^.prelightimg, button^.rect.x,
        button^.rect.y, nil)
    else
      kiss_renderimage(renderer, button^.normalimg, button^.rect.x,
        button^.rect.y, nil);
    kiss_rendertext(renderer, button^.text, button^.textx, button^.texty,
      button^.font, button^.textcolor);
    result := 1;
  end;

  function kiss_selectbutton_new(selectbutton: Pkiss_selectbutton;
    wdw: Pkiss_window; x: LongInt; y: LongInt): LongInt;
  begin
    if not Assigned(selectbutton) then
    begin
      result := -1;
      exit;
    end;
    if (selectbutton^.selectedimg.magic <> KISS_MAGIC) then
      selectbutton^.selectedimg := kiss_selected;
    if (selectbutton^.unselectedimg.magic <> KISS_MAGIC) then
      selectbutton^.unselectedimg := kiss_unselected;
    kiss_makerect(@selectbutton^.rect, x, y, selectbutton^.selectedimg.w,
      selectbutton^.selectedimg.h);
    selectbutton^.selected := 0;
    selectbutton^.focus := 0;
    selectbutton^.wdw := wdw;
    result := 0;
  end;

  function kiss_selectbutton_event(selectbutton: Pkiss_selectbutton;
    event: PSDL_Event; draw: PLongInt): LongInt;
  begin
    if (not Assigned(selectbutton)) or (not(selectbutton^.visible <> 0)) or
      (not Assigned(event)) then
    begin
      result := 0;
      exit;
    end;
    if (event^.type_ = SDL_WINDOWEVENT) and
      (event^.window.event = SDL_WINDOWEVENT_EXPOSED) then
      draw^ := 1;
    if (not(selectbutton^.focus <> 0)) and ((not Assigned(selectbutton^.wdw)) or
      ((Assigned(selectbutton^.wdw)) and (not(selectbutton^.wdw^.focus <> 0)))) then
    begin
      result := 0;
      exit;
    end;
    if (event^.type_ = SDL_MOUSEBUTTONDOWN) and (kiss_pointinrect(event^.button.x,
      event^.button.y, @selectbutton^.rect) <> 0) then
    begin
      selectbutton^.selected := selectbutton^.selected xor 1;
      draw^ := 1;
      result := 1;
      exit;
    end;
    result := 0;
  end;

  function kiss_selectbutton_draw(selectbutton: Pkiss_selectbutton;
    renderer: PSDL_Renderer): LongInt;
  begin
    if (Assigned(selectbutton)) and (Assigned(selectbutton^.wdw)) then
      selectbutton^.visible := selectbutton^.wdw^.visible;
    if (not Assigned(selectbutton)) or (not(selectbutton^.visible <> 0)) or
      (not Assigned(renderer)) then
    begin
      result := 0;
      exit;
    end;
    if (selectbutton^.selected <> 0) then
      kiss_renderimage(renderer, selectbutton^.selectedimg, selectbutton^.rect.x,
        selectbutton^.rect.y, nil)
    else
      kiss_renderimage(renderer, selectbutton^.unselectedimg, selectbutton^.rect.x,
        selectbutton^.rect.y, nil);
    result := 1;
  end;

  function kiss_vscrollbar_new(vscrollbar: Pkiss_vscrollbar; wdw: Pkiss_window;
    x: LongInt; y: LongInt; h: LongInt): LongInt;
  begin
    if not Assigned(vscrollbar) then
    begin
      result := -1;
      exit;
    end;
    if (vscrollbar^.up.magic <> KISS_MAGIC) then
      vscrollbar^.up := kiss_up;
    if (vscrollbar^.down.magic <> KISS_MAGIC) then
      vscrollbar^.down := kiss_down;
    if (vscrollbar^.vslider.magic <> KISS_MAGIC) then
      vscrollbar^.vslider := kiss_vslider;
    if (vscrollbar^.up.h + vscrollbar^.down.h + 2 * kiss_edge +
      2 * kiss_slider_padding + vscrollbar^.vslider.h > h) then
    begin
      result := -1;
      exit;
    end;
    kiss_makerect(@vscrollbar^.uprect, x, y + kiss_edge,
      vscrollbar^.up.w, vscrollbar^.up.h + kiss_slider_padding);
    kiss_makerect(@vscrollbar^.downrect, x, y + h - vscrollbar^.down.h -
      kiss_slider_padding - kiss_edge, vscrollbar^.down.w,
      vscrollbar^.down.h + kiss_slider_padding);
    kiss_makerect(@vscrollbar^.sliderrect, x, y + vscrollbar^.uprect.h +
      kiss_edge, vscrollbar^.vslider.w, vscrollbar^.vslider.h);
    vscrollbar^.maxpos := h - 2 * kiss_slider_padding - 2 * kiss_edge -
      vscrollbar^.up.h - vscrollbar^.down.h -
      vscrollbar^.vslider.h;
    vscrollbar^.fraction := 0;
    vscrollbar^.step := 0.1;
    vscrollbar^.upclicked := 0;
    vscrollbar^.downclicked := 0;
    vscrollbar^.sliderclicked := 0;
    vscrollbar^.lasttick := 0;
    vscrollbar^.visible := 0;
    vscrollbar^.focus := 0;
    vscrollbar^.wdw := wdw;
    result := 0;
  end;

  procedure vnewpos(vscrollbar: Pkiss_vscrollbar; step: double; draw: PLongInt);
  begin
    draw^ := 1;
    vscrollbar^.fraction := vscrollbar^.fraction + step;
    vscrollbar^.lasttick := kiss_getticks;
    if vscrollbar^.fraction < -0.000001 then
      vscrollbar^.fraction := 0.0;
    if vscrollbar^.fraction > 0.999999 then
      vscrollbar^.fraction := 1.0;
    vscrollbar^.sliderrect.y := vscrollbar^.uprect.y + vscrollbar^.uprect.h +
      Round(vscrollbar^.fraction * vscrollbar^.maxpos + 0.5);
    if (vscrollbar^.fraction > 0.000001) and (vscrollbar^.fraction < 0.999999) then
      exit;
    vscrollbar^.upclicked := 0;
    vscrollbar^.downclicked := 0;
  end;

  function kiss_vscrollbar_event(vscrollbar: Pkiss_vscrollbar; event: PSDL_Event;
    draw: PLongInt): LongInt;
  begin
    if not Assigned(vscrollbar) or not(vscrollbar^.visible <> 0) then
    begin
      result := 0;
      exit;
    end;
    if not((SDL_GetMouseState(nil, nil) and SDL_Button(SDL_BUTTON_LEFT)) <> 0) then
    begin
      vscrollbar^.upclicked := 0;
      vscrollbar^.downclicked := 0;
      vscrollbar^.lasttick := 0;
    end
    else if (vscrollbar^.upclicked <> 0) and (kiss_getticks >    // does this work??
      (vscrollbar^.lasttick + kiss_click_interval)) then
    begin
      vnewpos(vscrollbar, -vscrollbar^.step, draw);
      result := 1;
      exit;
    end
    else if (vscrollbar^.downclicked <> 0) and (kiss_getticks >
      (vscrollbar^.lasttick + kiss_click_interval)) then
    begin
      vnewpos(vscrollbar, vscrollbar^.step, draw);
      result := 1;
      exit;
    end;
    if not Assigned(event) then
    begin
      result := 0;
      exit;
    end;
    if (event^.type_ = SDL_WINDOWEVENT) and
      (event^.window.event = SDL_WINDOWEVENT_EXPOSED) then
      draw^ := 1;
    if (not(vscrollbar^.focus <> 0)) and ((not Assigned(vscrollbar^.wdw)) or
      (Assigned(vscrollbar^.wdw) and (not(vscrollbar^.wdw^.focus <> 0)))) then
    begin
      result := 0;
      exit;
    end;
    if (event^.type_ = SDL_MOUSEBUTTONDOWN) and (kiss_pointinrect(event^.button.x,
      event^.button.y, @(vscrollbar^.uprect)) <> 0) and
      (vscrollbar^.fraction > 0.000001) then
    begin
      vscrollbar^.upclicked := 1;
      if Assigned(vscrollbar^.wdw) then
        vscrollbar^.wdw^.focus := 0;
      vscrollbar^.focus := 1;
      vscrollbar^.lasttick := kiss_getticks - kiss_click_interval - 1;
    end
    else if (event^.type_ = SDL_MOUSEBUTTONDOWN) and
      (kiss_pointinrect(event^.button.x, event^.button.y,
        @(vscrollbar^.downrect)) <> 0) and (vscrollbar^.step > 0.000001) then
    begin
      if vscrollbar^.fraction < 0.999999 then
      begin
        vscrollbar^.downclicked := 1;
        if Assigned(vscrollbar^.wdw) then
          vscrollbar^.wdw^.focus := 0;
        vscrollbar^.focus := 1;
      end;
      vscrollbar^.lasttick := kiss_getticks - kiss_click_interval - 1;
    end
    else if (event^.type_ = SDL_MOUSEBUTTONDOWN) and
      (kiss_pointinrect(event^.button.x, event^.button.y,
        @(vscrollbar^.sliderrect)) <> 0) and (vscrollbar^.step > 0.000001) then
    begin
      if Assigned(vscrollbar^.wdw) then
        vscrollbar^.wdw^.focus := 0;
      vscrollbar^.focus := 1;
      vscrollbar^.sliderclicked := 1;
    end
    else if event^.type_ = SDL_MOUSEBUTTONUP then
    begin
      vscrollbar^.upclicked := 0;
      vscrollbar^.downclicked := 0;
      vscrollbar^.lasttick := 0;
      if Assigned(vscrollbar^.wdw) then
        vscrollbar^.wdw^.focus := 1;
      vscrollbar^.focus := 0;
      vscrollbar^.sliderclicked := 0;
    end
    else if (event^.type_ = SDL_MOUSEMOTION) and
      ((event^.motion.state and SDL_BUTTON(SDL_BUTTON_LEFT)) <> 0) and
      (vscrollbar^.sliderclicked = 1) then
    begin
      vnewpos(vscrollbar, 1.0 * event^.motion.yrel / vscrollbar^.maxpos, draw);
      result := 1;
      exit;
    end;
    result := 0;
  end;

  function kiss_vscrollbar_draw(vscrollbar: Pkiss_vscrollbar;
    renderer: PSDL_Renderer): LongInt;
  begin
    if Assigned(vscrollbar) and Assigned(vscrollbar^.wdw) then
      vscrollbar^.visible := vscrollbar^.wdw^.visible;
    if (not Assigned(vscrollbar)) or not(vscrollbar^.visible <> 0) or
      (not Assigned(renderer)) then
    begin
      result := 0;
      exit;
    end;
    vscrollbar^.sliderrect.y := vscrollbar^.uprect.y +
      vscrollbar^.uprect.h + Round(vscrollbar^.fraction * vscrollbar^.maxpos);
    kiss_renderimage(renderer, vscrollbar^.up, vscrollbar^.uprect.x,
      vscrollbar^.uprect.y, nil);
    kiss_renderimage(renderer, vscrollbar^.down, vscrollbar^.downrect.x,
      vscrollbar^.downrect.y + kiss_slider_padding, nil);
    kiss_renderimage(renderer, vscrollbar^.vslider,
      vscrollbar^.sliderrect.x, vscrollbar^.sliderrect.y, nil);
    result := 1;
  end;

  function kiss_hscrollbar_new(hscrollbar: Pkiss_hscrollbar; wdw: Pkiss_window;
    x: LongInt; y: LongInt; w: LongInt): LongInt;
  begin
    if not Assigned(hscrollbar) then
    begin
      result := -1;
      exit;
    end;
    if (hscrollbar^.left.magic <> KISS_MAGIC) then
      hscrollbar^.left := kiss_left;
    if (hscrollbar^.right.magic <> KISS_MAGIC) then
      hscrollbar^.right := kiss_right;
    if (hscrollbar^.hslider.magic <> KISS_MAGIC) then
      hscrollbar^.hslider := kiss_hslider;
    if (hscrollbar^.left.w + hscrollbar^.right.w + 2 * kiss_edge +
      2 * kiss_slider_padding + hscrollbar^.hslider.w > w) then
    begin
      result := -1;
      exit;
    end;
    kiss_makerect(@hscrollbar^.leftrect, x + kiss_edge, y, hscrollbar^.left.w +
      kiss_slider_padding, hscrollbar^.left.h);
    kiss_makerect(@hscrollbar^.rightrect, x + w - hscrollbar^.right.w -
      kiss_slider_padding - kiss_edge, y, hscrollbar^.right.w +
      kiss_slider_padding, hscrollbar^.right.h);
    kiss_makerect(@hscrollbar^.sliderrect, x + hscrollbar^.leftrect.w +
      kiss_edge, y, hscrollbar^.hslider.w, hscrollbar^.hslider.h);
    hscrollbar^.maxpos := w - 2 * kiss_slider_padding - 2 * kiss_edge -
      hscrollbar^.left.w - hscrollbar^.right.w - hscrollbar^.hslider.w;
    hscrollbar^.fraction := 0.;
    hscrollbar^.step := 0.1;
    hscrollbar^.leftclicked := 0;
    hscrollbar^.rightclicked := 0;
    hscrollbar^.sliderclicked := 0;
    hscrollbar^.lasttick := 0;
    hscrollbar^.visible := 0;
    hscrollbar^.focus := 0;
    hscrollbar^.wdw := wdw;
    result := 0;
  end;

  procedure hnewpos(hscrollbar: Pkiss_hscrollbar; step: double; draw: PLongInt);
  begin
    draw^ := 1;
    hscrollbar^.fraction := hscrollbar^.fraction + step;
    hscrollbar^.lasttick := kiss_getticks;
    if (hscrollbar^.fraction < -0.000001) then
      hscrollbar^.fraction := 0.;
    if (hscrollbar^.fraction > 0.999999) then
      hscrollbar^.fraction := 1.;
    hscrollbar^.sliderrect.x := hscrollbar^.leftrect.x + hscrollbar^.leftrect.w +
      Round(hscrollbar^.fraction * hscrollbar^.maxpos + 0.5);
    if (hscrollbar^.fraction > 0.000001) and
      (hscrollbar^.fraction < 0.999999) then
      exit;
    hscrollbar^.leftclicked := 0;
    hscrollbar^.rightclicked := 0;
  end;

  function kiss_hscrollbar_event(hscrollbar: Pkiss_hscrollbar; event: PSDL_Event;
    draw: PLongInt): LongInt;
  begin
    if (not Assigned(hscrollbar)) or (not(hscrollbar^.visible <> 0)) then
    begin
      result := 0;
      exit;
    end;
    if not((SDL_GetMouseState(nil, nil) and
      SDL_BUTTON(SDL_BUTTON_LEFT)) <> 0) then
    begin
      hscrollbar^.leftclicked := 0;
      hscrollbar^.rightclicked := 0;
      hscrollbar^.lasttick := 0;
    end
    else if (hscrollbar^.leftclicked <> 0) and (kiss_getticks >
      hscrollbar^.lasttick + kiss_click_interval) then
    begin
      hnewpos(hscrollbar, -hscrollbar^.step, draw);
      result := 1;
      exit;
    end
    else if (hscrollbar^.rightclicked <> 0) and (kiss_getticks >
      hscrollbar^.lasttick + kiss_click_interval) then
    begin
      hnewpos(hscrollbar, hscrollbar^.step, draw);
      result := 1;
      exit;
    end;
    if not Assigned(event) then
    begin
      result := 0;
      exit;
    end;
    if (event^.type_ = SDL_WINDOWEVENT) and
      (event^.window.event = SDL_WINDOWEVENT_EXPOSED) then
      draw^ := 1;
    if (not(hscrollbar^.focus <> 0) and (not Assigned(hscrollbar^.wdw) or
      (Assigned(hscrollbar^.wdw) and not(hscrollbar^.wdw^.focus <> 0)))) then
    begin
      result := 0;
      exit;
    end;
    if (event^.type_ = SDL_MOUSEBUTTONDOWN) and
      (kiss_pointinrect(event^.button.x, event^.button.y,
      @hscrollbar^.leftrect) <> 0) then
    begin
      if (hscrollbar^.fraction > 0.000001) then
      begin
        hscrollbar^.leftclicked := 1;
        if Assigned(hscrollbar^.wdw) then
          hscrollbar^.wdw^.focus := 0;
        hscrollbar^.focus := 1;
      end;
      hscrollbar^.lasttick := kiss_getticks - kiss_click_interval - 1;
    end
    else if (event^.type_ = SDL_MOUSEBUTTONDOWN) and
      (kiss_pointinrect(event^.button.x, event^.button.y,
      @hscrollbar^.rightrect) <> 0) and (hscrollbar^.step > 0.000001) then
    begin
      if (hscrollbar^.fraction < 0.999999) then
      begin
        hscrollbar^.rightclicked := 1;
        if Assigned(hscrollbar^.wdw) then
          hscrollbar^.wdw^.focus := 0;
        hscrollbar^.focus := 1;
      end;
      hscrollbar^.lasttick := kiss_getticks - kiss_click_interval - 1;
    end
    else if (event^.type_ = SDL_MOUSEBUTTONDOWN) and
      (kiss_pointinrect(event^.button.x, event^.button.y,
      @hscrollbar^.sliderrect) <> 0) and (hscrollbar^.step > 0.000001) then
    begin
      if Assigned(hscrollbar^.wdw) then
        hscrollbar^.wdw^.focus := 0;
      hscrollbar^.focus := 1;
      hscrollbar^.sliderclicked := 1;
    end
    else if (event^.type_ = SDL_MOUSEBUTTONUP) then
    begin
      hscrollbar^.leftclicked := 0;
      hscrollbar^.rightclicked := 0;
      hscrollbar^.lasttick := 0;
      if Assigned(hscrollbar^.wdw) then
        hscrollbar^.wdw^.focus := 1;
      hscrollbar^.focus := 0;
      hscrollbar^.sliderclicked := 0;
    end
    else if (event^.type_ = SDL_MOUSEMOTION) and
      ((event^.motion.state and SDL_BUTTON(SDL_BUTTON_LEFT)) <> 0) and
      (hscrollbar^.sliderclicked <> 0) then
    begin
      hnewpos(hscrollbar, 1. * event^.motion.xrel / hscrollbar^.maxpos, draw);
      result := 1;
      exit;
    end;
    result := 0;
  end;

  function kiss_hscrollbar_draw(hscrollbar: Pkiss_hscrollbar;
    renderer: PSDL_Renderer): LongInt;
  begin
    if Assigned(hscrollbar) and Assigned(hscrollbar^.wdw) then
      hscrollbar^.visible := hscrollbar^.wdw^.visible;
    if (not Assigned(hscrollbar)) or (not(hscrollbar^.visible <> 0)) or
      (not Assigned(renderer)) then
    begin
      result := 0;
      exit;
    end;
    hscrollbar^.sliderrect.x := hscrollbar^.leftrect.x +
      hscrollbar^.leftrect.w + Round(hscrollbar^.fraction *
      hscrollbar^.maxpos);
    kiss_renderimage(renderer, hscrollbar^.left, hscrollbar^.leftrect.x,
      hscrollbar^.leftrect.y, nil);
    kiss_renderimage(renderer, hscrollbar^.right, hscrollbar^.rightrect.x +
      kiss_slider_padding, hscrollbar^.rightrect.y, nil);
    kiss_renderimage(renderer, hscrollbar^.hslider, hscrollbar^.sliderrect.x,
      hscrollbar^.sliderrect.y, nil);
    result := 1;
  end;

  function kiss_progressbar_new(progressbar: Pkiss_progressbar;
    wdw: Pkiss_window; x: LongInt; y: LongInt; w: LongInt): LongInt;
  begin
    if (not Assigned(progressbar)) or (w < 2 * kiss_border + 1) then
    begin
      result := -1;
      exit;
    end;
    if (progressbar^.bar.magic <> KISS_MAGIC) then
      progressbar^.bar := kiss_bar;
    progressbar^.bg := kiss_white;
    kiss_makerect(@progressbar^.rect, x, y, w, progressbar^.bar.h + 2 * kiss_border);
    kiss_makerect(@progressbar^.barrect, x + kiss_border, y + kiss_border, 0,
      progressbar^.bar.h);
    progressbar^.width := w - 2 * kiss_border;
    progressbar^.fraction := 0;
    progressbar^.step := 0.02;
    progressbar^.lasttick := 0;
    progressbar^.run := 0;
    progressbar^.visible := 0;
    progressbar^.wdw := wdw;
    result := 0;
  end;

  function kiss_progressbar_event(progressbar: Pkiss_progressbar;
    event: PSDL_Event; draw: PLongInt): LongInt;
  begin
    if (not Assigned(progressbar)) or not(progressbar^.visible <> 0) then
    begin
      result := 0;
      exit;
    end;
    if (progressbar^.run <> 0) and (kiss_getticks > progressbar^.lasttick +
      kiss_progress_interval) then
    begin
      progressbar^.fraction := progressbar^.fraction + progressbar^.step;
      if progressbar^.fraction > 0.999999 then
      begin
        progressbar^.run := 0;
        progressbar^.fraction := 1.0;
      end;
      progressbar^.lasttick := kiss_getticks;
      draw^ := 1;
    end;
    result := 1;
  end;

  function kiss_progressbar_draw(progressbar: Pkiss_progressbar;
    renderer: PSDL_Renderer): LongInt;
  var
    clip: TSDL_Rect;
  begin
    if Assigned(progressbar) and Assigned(progressbar^.wdw) then
      progressbar^.visible := progressbar^.wdw^.visible;
    if (not Assigned(progressbar)) or (not(progressbar^.visible <> 0)) or
      (not Assigned(renderer)) then
    begin
      result := 0;
      exit;
    end;
    kiss_fillrect(renderer, @progressbar^.rect, progressbar^.bg);
    kiss_decorate(renderer, @progressbar^.rect, kiss_blue, kiss_edge);
    progressbar^.barrect.w := Round(
      progressbar^.width * progressbar^.fraction + 0.5);
    kiss_makerect(@clip, 0, 0, progressbar^.barrect.w, progressbar^.barrect.h);
    kiss_renderimage(renderer, progressbar^.bar, progressbar^.barrect.x,
      progressbar^.barrect.y, @clip);
    result := 1;
  end;

  function kiss_entry_new(entry: Pkiss_entry; wdw: Pkiss_window;
    decorate: LongInt; text: string; x: LongInt; y: LongInt; w: LongInt
    ): LongInt;
  begin
    if (not Assigned(entry)) then
      Exit(-1);
    if (entry^.font.magic <> KISS_MAGIC) then
      entry^.font := kiss_textfont;
    if (w < 2 * kiss_border + entry^.font.advance) then
      Exit(-1);
    entry^.bg := kiss_white;
    entry^.normalcolor := kiss_black;
    entry^.activecolor := kiss_blue;
    entry^.textwidth := w - 2 * kiss_border;
    entry^.text := text;
    kiss_makerect(@entry^.rect, x, y, w, entry^.font.fontheight +
      2 * kiss_border);
    entry^.decorate := decorate;
    entry^.textx := x + kiss_border;
    entry^.texty := y + kiss_border;
    entry^.active := 0;
    entry^.visible := 0;
    entry^.focus := 0;
    entry^.wdw := wdw;
    result := 0;
  end;

  function kiss_entry_event(entry: Pkiss_entry; event: PSDL_Event; draw: PLongInt
    ): LongInt;
  begin
    if (not Assigned(entry)) or (not(entry^.visible <> 0)) or
      (not Assigned(event)) then
    begin
      result := 0;
      exit;
    end;
    if (event^.type_ = SDL_WINDOWEVENT) and
      (event^.window.event = SDL_WINDOWEVENT_EXPOSED) then
      draw^ := 1;
    if (not(entry^.focus <> 0)) and ((not Assigned(entry^.wdw)) or
      ((Assigned(entry^.wdw)) and (not(entry^.wdw^.focus <> 0)))) then
    begin
      result := 0;
      exit;
    end;
    if (event^.type_ = SDL_MOUSEBUTTONDOWN) and (not(entry^.active <> 0)) and
      (kiss_pointinrect(event^.button.x, event^.button.y, @entry^.rect) <> 0) then
    begin
      entry^.active := 1;
      SDL_StartTextInput;
      if (Assigned(entry^.wdw)) then
        entry^.wdw^.focus := 0;
      entry^.focus := 1;
      draw^ := 1;
    end
    else if (event^.type_ = SDL_KEYDOWN) and (entry^.active <> 0) and
      (event^.key.keysym.scancode = SDL_SCANCODE_RETURN) then
    begin
      entry^.active := 0;
      SDL_StopTextInput;
      if Assigned(entry^.wdw) then
        entry^.wdw^.focus := 1;
      entry^.focus := 0;
      draw^ := 1;
      result := 1;
      exit;
    end
    else if (event^.type_ = SDL_TEXTINPUT) and (entry^.active <> 0) then
    begin
      if (kiss_textwidth(entry^.font, entry^.text, string(event^.text.text)) <
        entry^.textwidth) and (Length(entry^.text) + Length(string(event^.text.text)) <
        KISS_MAX_LENGTH) then
        entry^.text := entry^.text + string(event^.text.text);
      draw^ := 1;
    end
    else if (event^.type_ = SDL_KEYDOWN) and (entry^.active <> 0) and
      (event^.key.keysym.scancode = SDL_SCANCODE_BACKSPACE) then
    begin
      kiss_backspace(entry^.text);
      draw^ := 1;
    end
    else if (event^.type_ = SDL_KEYDOWN) and (entry^.active <> 0) and
      ((event^.key.keysym._mod and KMOD_CTRL) <> 0) and
      (event^.key.keysym.scancode = SDL_SCANCODE_U) then
    begin
      entry^.text := '';
      draw^ := 1;
    end
    else if (event^.type_ = SDL_MOUSEBUTTONDOWN) and (entry^.active <> 0) and
      (kiss_pointinrect(event^.button.x, event^.button.y, @entry^.rect) <> 0) then
    begin
      entry^.text := '';
      draw^ := 1;
    end;
    result := 0;
  end;

  function kiss_entry_draw(entry: Pkiss_entry; renderer: PSDL_Renderer): LongInt;
  var
    color: TSDL_Color;
  begin
    if Assigned(entry) and Assigned(entry^.wdw) then
      entry^.visible := entry^.wdw^.visible;
    if (not Assigned(entry)) or (not(entry^.visible <> 0)) or
      (not Assigned(renderer)) then
    begin
      result := 0;
      exit;
    end;
    kiss_fillrect(renderer, @entry^.rect, entry^.bg);
    color := kiss_blue;
    if entry^.active <> 0 then
      color := kiss_green;
    if entry^.decorate <> 0 then
      kiss_decorate(renderer, @entry^.rect, color, kiss_edge);
    color := entry^.normalcolor;
    if entry^.active <> 0 then
      color := entry^.activecolor;
    kiss_rendertext(renderer, entry^.text, entry^.textx, entry^.texty,
      entry^.font, color);
    result := 1;
  end;

  function kiss_textbox_new(textbox: Pkiss_textbox; wdw: Pkiss_window;
    decorate: LongInt; a: Pkiss_array; x: LongInt; y: LongInt; w: LongInt;
    h: LongInt): LongInt;
  begin
    if (not Assigned(textbox)) or (not Assigned(a)) then
    begin
      result := -1;
      exit;
    end;
    if (textbox^.font.magic <> KISS_MAGIC) then
      textbox^.font := kiss_textfont;
    if (h - 2 * kiss_border < textbox^.font.lineheight) then
    begin
      result := -1;
      exit;
    end;
    textbox^.bg := kiss_white;
    textbox^.textcolor := kiss_black;
    textbox^.hlcolor := kiss_lightblue;
    kiss_makerect(@textbox^.rect, x, y, w, h);
    kiss_makerect(@textbox^.textrect, x + kiss_border, y + kiss_border,
      w - 2 * kiss_border, h - 2 * kiss_border);
    textbox^.decorate := decorate;
    textbox^.array_ := a;
    textbox^.firstline := 0;
    textbox^.maxlines := (h - 2 * kiss_border) div textbox^.font.lineheight;
    textbox^.textwidth := w - 2 * kiss_border;
    textbox^.highlightline := -1;
    textbox^.selectedline := -1;
    textbox^.visible := 0;
    textbox^.focus := 0;
    textbox^.wdw := wdw;
    result := 0;
  end;

  function textbox_numoflines(textbox: Pkiss_textbox): LongInt;
  var
    numoflines: LongInt;
  begin
    numoflines := textbox^.maxlines;
    if (textbox^.array_^.length - textbox^.firstline < textbox^.maxlines) then
      numoflines := textbox^.array_^.length - textbox^.firstline;
    result := numoflines;
  end;

  function kiss_textbox_event(textbox: Pkiss_textbox; event: PSDL_Event;
    draw: PLongInt): LongInt;
  var
    texty, textmaxy, numoflines: LongInt;
  begin
    if (not Assigned(textbox)) or (textbox^.visible = 0) or
      (not Assigned(event)) or (not Assigned(textbox^.array_)) or
      (textbox^.array_^.length = 0) then
    begin
      result := 0;
      exit;
    end;
    if (event^.type_ = SDL_WINDOWEVENT) and
      (event^.window.event = SDL_WINDOWEVENT_EXPOSED) then
      draw^ := 1;
    if (not(textbox^.focus <> 0)) and ((not Assigned(textbox^.wdw)) or
      (Assigned(textbox^.wdw) and (not(textbox^.wdw^.focus <> 0)))) then
    begin
      result := 0;
      exit;
    end;
    if (event^.type_ = SDL_MOUSEBUTTONDOWN) and
      (kiss_pointinrect(event^.button.x, event^.button.y,
      @textbox^.textrect) <> 0) then
    begin
      numoflines := textbox_numoflines(textbox);
      texty := event^.button.y - textbox^.textrect.y;
      textmaxy := numoflines * textbox^.font.lineheight;
      if (texty < textmaxy) then
      begin
        textbox^.selectedline := texty div textbox^.font.lineheight;
        result := 1;
        exit;
      end;
    end
    else if (event^.type_ = SDL_MOUSEMOTION) and
      (kiss_pointinrect(event^.motion.x, event^.motion.y,
      @textbox^.textrect) <> 0) then
    begin
      numoflines := textbox_numoflines(textbox);
      texty := event^.motion.y - textbox^.textrect.y;
      textmaxy := numoflines * textbox^.font.lineheight;
      textbox^.highlightline := -1;
      if (texty < textmaxy) then
          textbox^.highlightline := texty div textbox^.font.lineheight;
      draw^ := 1;
    end
    else if (event^.type_ = SDL_MOUSEMOTION) and
      (kiss_pointinrect(event^.motion.x, event^.motion.y,
      @textbox^.textrect) = 0) then
    begin
      textbox^.highlightline := -1;
      draw^ := 1;
    end;
    result := 0;
  end;

  function kiss_textbox_draw(textbox: Pkiss_textbox; renderer: PSDL_Renderer
    ): LongInt;
  var
    highlightrect: TSDL_Rect;
    buf: string;
    numoflines, i: LongInt;
  begin
    if (Assigned(textbox)) and (Assigned(textbox^.wdw)) then
      textbox^.visible := textbox^.wdw^.visible;
    if (not Assigned(textbox)) or (textbox^.visible = 0) or
      (not Assigned(renderer)) then
    begin
      result := 0;
      exit;
    end;
    kiss_fillrect(renderer, @textbox^.rect, textbox^.bg);
    if (textbox^.decorate <> 0) then
      kiss_decorate(renderer, @textbox^.rect, kiss_blue, kiss_edge);
    if (textbox^.highlightline >= 0) then
    begin
      kiss_makerect(@highlightrect, textbox^.textrect.x,
        textbox^.textrect.y +
        textbox^.highlightline * textbox^.font.lineheight,
        textbox^.textrect.w, textbox^.font.lineheight);
      kiss_fillrect(renderer, @highlightrect, textbox^.hlcolor);
    end;
    if (not Assigned(textbox^.array_)) or (textbox^.array_^.length = 0) then
    begin
      result := 0;
      exit;
    end;
    numoflines := textbox_numoflines(textbox);
    for i := 0 to (numoflines - 1) do
    begin
      kiss_string_copy(buf,
        PString(kiss_array_data(textbox^.array_, textbox^.firstline + i))^,
        '');
      kiss_rendertext(renderer, buf, textbox^.textrect.x,
        textbox^.textrect.y + i * textbox^.font.lineheight +
        textbox^.font.spacing div 2, textbox^.font,
        textbox^.textcolor);
    end;
    result := 1;
  end;

  function kiss_combobox_new(combobox: Pkiss_combobox; wdw: Pkiss_window;
    text: string; a: Pkiss_array; x: LongInt; y: LongInt; w: LongInt; h: LongInt
    ): LongInt;
  begin
    if (not Assigned(combobox)) or (not Assigned(a)) then
    begin
      result := -1;
      exit;
    end;
    if (combobox^.combo.magic <> KISS_MAGIC) then
      combobox^.combo := kiss_combo;
    kiss_entry_new(@combobox^.entry, wdw, 1, text, x, y, w);
    combobox^.text := combobox^.entry.text;
    kiss_window_new(@combobox^.window, nil, 0, x, y + combobox^.entry.rect.h,
      w + combobox^.vscrollbar.up.w, h);
    if (kiss_textbox_new(@combobox^.textbox, @combobox^.window, 1, a, x,
      y + combobox^.entry.rect.h, w, h) = -1) then
    begin
      result := -1;
      exit;
    end;
    if (kiss_vscrollbar_new(@combobox^.vscrollbar, @combobox^.window,
      x + combobox^.textbox.rect.w, combobox^.textbox.rect.y,
      combobox^.textbox.rect.h) = -1) then
    begin
      result := -1;
      exit;
    end;
    combobox^.visible := 0;
    combobox^.wdw := wdw;
    combobox^.vscrollbar.step := 0;
    if (combobox^.textbox.array_^.length - combobox^.textbox.maxlines > 0) then
      combobox^.vscrollbar.step := 1.0 / (combobox^.textbox.array_^.length -
        combobox^.textbox.maxlines);
    result := 0;
  end;

  function kiss_combobox_event(combobox: Pkiss_combobox; event: PSDL_Event;
    draw: PLongInt): LongInt;
  var
    firstline, index: LongInt;
  begin
    if (not Assigned(combobox)) or (not(combobox^.visible <> 0)) then
    begin
      result := 0;
      exit;
    end;
    if (kiss_vscrollbar_event(@combobox^.vscrollbar, event, draw) <> 0) and
      (combobox^.textbox.array_^.length - combobox^.textbox.maxlines >= 0) then
    begin
      combobox^.vscrollbar.step := 0.0;
      if (combobox^.textbox.array_^.length - combobox^.textbox.maxlines > 0) then
        combobox^.vscrollbar.step := 1.0 / (combobox^.textbox.array_^.length -
          combobox^.textbox.maxlines);
      firstline := Round((combobox^.textbox.array_^.length -
        combobox^.textbox.maxlines) * combobox^.vscrollbar.fraction + 0.5);
      if (firstline >= 0) then
        combobox^.textbox.firstline := firstline;
      draw^ := 1;
    end;
    if (not Assigned(event)) then
    begin
      result := 0;
      exit;
    end;
    if (event^.type_ = SDL_WINDOWEVENT) and
      (event^.window.event = SDL_WINDOWEVENT_EXPOSED) then
      draw^ := 1;
    if (event^.type_ = SDL_MOUSEBUTTONDOWN) and
      (kiss_pointinrect(event^.button.x, event^.button.y,
      @combobox^.entry.rect) <> 0) then
    begin
      combobox^.window.visible := 1;
      draw^ := 1;
    end;
    if (kiss_entry_event(@combobox^.entry, event, draw) <> 0) then
    begin
      combobox^.window.visible := 0;
      combobox^.text := combobox^.entry.text;
      draw^ := 1;
      SDL_StopTextInput;
      result := 1;
      exit;
    end
    else if (kiss_textbox_event(@combobox^.textbox, event, draw) <> 0) then
    begin
      combobox^.window.visible := 0;
      combobox^.entry.active := 0;
      if Assigned(combobox^.entry.wdw) then
        combobox^.entry.wdw^.focus := 1;
      combobox^.entry.focus := 0;
      index := combobox^.textbox.firstline + combobox^.textbox.selectedline;
      kiss_string_copy(combobox^.entry.text,  // Conv.: Why two times in C code?
        PString(kiss_array_data(combobox^.textbox.array_, index))^, '');
      draw^ := 1;
      SDL_StopTextInput;
      result := 1;
      exit;
    end;
    result := 0;
  end;

  function kiss_combobox_draw(combobox: Pkiss_combobox; renderer: PSDL_Renderer
    ): LongInt;
  begin
    if (Assigned(combobox)) and (Assigned(combobox^.wdw)) then
      combobox^.visible := combobox^.wdw^.visible;
    if (not Assigned(combobox)) or (not(combobox^.visible <> 0)) or
      (not Assigned(renderer)) then
    begin
      result := 0;
      exit;
    end;
    kiss_renderimage(renderer, combobox^.combo,
      combobox^.entry.rect.x + combobox^.entry.rect.w,
      combobox^.entry.rect.y + combobox^.entry.rect.h -
      combobox^.combo.h - kiss_edge, nil);
    kiss_entry_draw(@combobox^.entry, renderer);
    kiss_window_draw(@combobox^.window, renderer);
    kiss_vscrollbar_draw(@combobox^.vscrollbar, renderer);
    kiss_textbox_draw(@combobox^.textbox, renderer);
    result := 1;
  end;

end.

