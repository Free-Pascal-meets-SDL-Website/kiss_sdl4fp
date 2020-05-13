unit kiss_draw;

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
  SDL2_TTF,
  SDL2_Image,
  kiss_general;

{$ifndef RESDIR}
const
  RESDIR = '';
{$endif}

type
  Pkiss_image = ^kiss_image;
  kiss_image = record
    image : PSDL_Texture;
    magic : LongInt;
    w : LongInt;
    h : LongInt;
  end;
  Tkiss_image = kiss_image;

type
  Pkiss_font = ^kiss_font;
  kiss_font = record
    font : PTTF_Font;
    magic : LongInt;
    fontheight : LongInt;
    spacing : LongInt;
    lineheight : LongInt;
    advance : LongInt;
    ascent : LongInt;
  end;
  Tkiss_font = kiss_font;

var
  kiss_textfont, kiss_buttonfont : Tkiss_font;
  kiss_normal, kiss_prelight, kiss_active, kiss_bar,
    kiss_up, kiss_down, kiss_left, kiss_right, kiss_vslider,
    kiss_hslider, kiss_selected, kiss_unselected, kiss_combo: Tkiss_image;
  kiss_screen_width, kiss_screen_height : LongInt;
  kiss_textfont_size : LongInt = 15;
  kiss_buttonfont_size: LongInt = 12;
  kiss_click_interval : LongInt = 140;
  kiss_progress_interval: LongInt = 50;
  kiss_slider_padding : LongInt = 2;
  kiss_edge: LongInt = 2;
  kiss_border : LongInt = 6;
  kiss_spacing : double = 0.5;
  kiss_white : TSDL_Color = (r: 255; g: 255; b: 255; a: 255);
  kiss_black : TSDL_Color = (r: 0; g: 0; b: 0; a: 255);
  kiss_green : TSDL_Color = (r: 0; g: 150; b: 0; a: 255);
  kiss_blue : TSDL_Color = (r: 0; g: 0; b: 255; a: 255);
  kiss_lightblue : TSDL_Color = (r: 20; g: 255; b: 255; a: 255);

function kiss_getticks:dword;

//function kiss_maxlength(font:kiss_font; width:LongInt; str1:Pchar;
//  str2:Pchar):LongInt;

function kiss_textwidth(font:kiss_font; str1:string; str2:string):LongInt;

function kiss_renderimage(renderer:PSDL_Renderer; image:kiss_image; x:LongInt;
  y:LongInt; clip:PSDL_Rect):LongInt;

function kiss_rendertext(renderer:PSDL_Renderer; text:string; x:LongInt;
  y:LongInt; font:kiss_font; color:TSDL_Color):LongInt;

function kiss_fillrect(renderer:PSDL_Renderer; rect:PSDL_Rect;
  color:TSDL_Color):LongInt;

function kiss_decorate(renderer:PSDL_Renderer; rect:PSDL_Rect; color:TSDL_Color;
  edge:LongInt):LongInt;

function kiss_image_new(image:Pkiss_image; fname:string; a:Pkiss_array;
  renderer:PSDL_Renderer):LongInt;

function kiss_font_new(font:Pkiss_font; fname:string; a:Pkiss_array;
  size:LongInt):LongInt;

function kiss_init(title:Pchar; a:Pkiss_array; w:LongInt;
  h:LongInt):PSDL_Renderer;

function kiss_clean(a: Pkiss_array):LongInt;

implementation

  function kiss_getticks: dword;
  begin
    result := SDL_GetTicks;
  end;

  function kiss_textwidth(font: kiss_font; str1: string; str2: string
    ): LongInt;
  var
    buf: string;
    width: LongInt;
  begin
    if (str1 = '') and (str2 = '') then
    begin
      result := -1;
      exit;
    end;
    kiss_string_copy(buf, str1, str2);
    TTF_SizeUTF8(font.font, PChar(buf), @width, nil);
    result := width;
  end;

  function kiss_renderimage(renderer: PSDL_Renderer; image: kiss_image;
    x: LongInt; y: LongInt; clip: PSDL_Rect): LongInt;
  var
    dst: TSDL_Rect;
  begin
    if (not Assigned(renderer)) or (not Assigned(image.image)) then
    begin
      result := -1;
      exit;
    end;
    kiss_makerect(@dst, x, y, image.w, image.h);
    if Assigned(clip) then
      dst.w := clip^.w;
    if Assigned(clip) then
      dst.h := clip^.h;
    SDL_RenderCopy(renderer, image.image, clip, @dst);
    result := 0;
  end;

  function kiss_fillrect(renderer: PSDL_Renderer; rect: PSDL_Rect;
    color: TSDL_Color): LongInt;
  begin
    if (not Assigned(renderer)) or (not Assigned(rect)) then
    begin
      result := -1;
      exit;
    end;
    SDL_SetRenderDrawColor(renderer, color.r, color.g, color.b, color.a);
    SDL_RenderFillRect(renderer, rect);
    result := 0;
  end;

  function kiss_decorate(renderer: PSDL_Renderer; rect: PSDL_Rect;
    color: TSDL_Color; edge: LongInt): LongInt;
  var
    outlinerect: TSDL_Rect;
    d, i: LongInt;
  begin
    d := 2 * edge;
    if (not Assigned(renderer)) or (not Assigned(rect)) or (rect^.w < d + 6)
      or (rect^.h < d + 6) then
    begin
      result := -1;
      exit;
    end;
    SDL_SetRenderDrawColor(renderer, color.r, color.g, color.b, color.a);
    for i := 0 to 1 do
    begin
      kiss_makerect(
        @outlinerect,
        rect^.x + edge + i,
        rect^.y + edge + i,
        rect^.w - d - i - i,
        rect^.h - d - i - i
      );
      SDL_RenderDrawRect(renderer, @outlinerect);
    end;
    result := 0;
  end;

  function kiss_rendertext(renderer: PSDL_Renderer; text: string; x: LongInt;
    y: LongInt; font: kiss_font; color: TSDL_Color): LongInt;
  var
    surface: PSDL_Surface;
    image: Tkiss_image;
  begin
    if (not(text <> '')) or (not Assigned(renderer)) or
      (not Assigned(font.font)) then
      begin
        result := -1;
        exit;
      end;
    surface := TTF_RenderUTF8_Blended(font.font, PChar(text), color);
    image.image := SDL_CreateTextureFromSurface(renderer, surface);
    SDL_QueryTexture(image.image, nil, nil, @image.w, @image.h);
    if Assigned(surface) then
      SDL_FreeSurface(surface);
    kiss_renderimage(renderer, image, x, y, nil);
    SDL_DestroyTexture(image.image);
    result := 0;
  end;

  function kiss_image_new(image: Pkiss_image; fname: string; a: Pkiss_array;
    renderer: PSDL_Renderer): LongInt;
  begin
    if (not Assigned(image)) or (fname = '') then
    begin
      result := -1;
      exit;
    end;
    image^.image := IMG_LoadTexture(renderer,PChar(RESDIR+fname));
    if not Assigned(image^.image) then
    begin
      writeln('Cannot load image ', fname);
      result := -1;
      exit;
    end;
    if Assigned(a) then
      kiss_array_append(a, TEXTURE_TYPE, image^.image);
    SDL_QueryTexture(image^.image, nil, nil, @image^.w, @image^.h);
    image^.magic := KISS_MAGIC;
    result := 0;
  end;

  function kiss_font_new(font: Pkiss_font; fname: string; a: Pkiss_array;
    size: LongInt): LongInt;
  begin
    if (not Assigned(font)) or (fname = '') then
    begin
      result := -1;
      exit;
    end;
    font^.font:=TTF_OpenFont(PChar(RESDIR+fname), size);
    if not Assigned(font^.font) then
    begin
      writeln('Cannot load font ', fname);
      result := -1;
      exit;
    end;
    if Assigned(a) then
      kiss_array_append(a, FONT_TYPE, font^.font);
    font^.fontheight := TTF_FontHeight(font^.font);
    font^.spacing := Round(kiss_spacing * font^.fontheight);
    font^.lineheight := font^.fontheight + font^.spacing;
    font^.ascent := TTF_FontAscent(font^.font);
    TTF_GlyphMetrics(font^.font, Ord('W'), nil, nil, nil, nil, @font^.advance);
    font^.magic := KISS_MAGIC;
    result := 0;
  end;

  function kiss_init(title: Pchar; a: Pkiss_array; w: LongInt; h: LongInt
    ): PSDL_Renderer;
  var
    window: PSDL_Window;
    renderer: PSDL_Renderer;
    srect: TSDL_Rect;
    r: LongInt = 0;
  begin
    SDL_Init(SDL_INIT_EVERYTHING);
    SDL_GetDisplayBounds(0, @srect);
    if (not Assigned(a)) or (w > srect.w) or (h > srect.h) then
    begin
      SDL_Quit;
      result := nil;
      exit;
    end;
    kiss_screen_width := w;
    kiss_screen_height := h;
    IMG_Init(IMG_INIT_PNG);
    TTF_Init;
    kiss_array_new(a);
    window := SDL_CreateWindow(title, (srect.w div 2 - w div 2),
      (srect.h div 2 - h div 2), w, h, SDL_WINDOW_SHOWN);
    if Assigned(window) then
      kiss_array_append(a, WINDOW_TYPE, window);
    //renderer := SDL_CreateRenderer(window, -1,
    //  SDL_RENDERER_ACCELERATED or SDL_RENDERER_PRESENTVSYNC);

    { Conv.: !!!
      These renderer settings made a strange effect, parts are blackened
      out, esp. after label widgets. Even extreme careful examation
      didn't solve this. I guess, it has something to do with my or any(?)
      graphic cards driver. There may be some problems with functions:
      TTF_RenderUTF8_Blended(); or
      SDL_CreateTextureFromSurface() in
      function kiss_rendertext.

      Solution: Use the software renderer for now.

      TODO: Closer examination! }

    renderer := SDL_CreateRenderer(window, -1,
      SDL_RENDERER_SOFTWARE);
    if Assigned(renderer) then
      kiss_array_append(a, RENDERER_TYPE, renderer);
    r := r + kiss_font_new(@kiss_textfont, 'kiss_font.ttf', a,
      kiss_textfont_size);
    r := r + kiss_font_new(@kiss_buttonfont, 'kiss_font.ttf', a,
      kiss_buttonfont_size);
    r := r + kiss_image_new(@kiss_normal, 'kiss_normal.png', a, renderer);
    r := r + kiss_image_new(@kiss_prelight, 'kiss_prelight.png', a, renderer);
    r := r + kiss_image_new(@kiss_active, 'kiss_active.png', a, renderer);
    r := r + kiss_image_new(@kiss_bar, 'kiss_bar.png', a, renderer);
    r := r + kiss_image_new(@kiss_vslider, 'kiss_vslider.png', a, renderer);
    r := r + kiss_image_new(@kiss_hslider, 'kiss_hslider.png', a, renderer);
    r := r + kiss_image_new(@kiss_up, 'kiss_up.png', a, renderer);
    r := r + kiss_image_new(@kiss_down, 'kiss_down.png', a, renderer);
    r := r + kiss_image_new(@kiss_left, 'kiss_left.png', a, renderer);
    r := r + kiss_image_new(@kiss_right, 'kiss_right.png', a, renderer);
    r := r + kiss_image_new(@kiss_combo, 'kiss_combo.png', a, renderer);
    r := r + kiss_image_new(@kiss_selected, 'kiss_selected.png', a, renderer);
    r := r + kiss_image_new(@kiss_unselected, 'kiss_unselected.png', a, renderer);
    if r > 0 then
    begin
      kiss_clean(a);
      result := nil;
      exit;
    end;
    result := renderer;
  end;

  function kiss_clean(a: Pkiss_array): LongInt;
  var
    i: LongInt;
  begin
    if not Assigned(a) then
    begin
      result := -1;
      exit;
    end;
    if a^.length > 0 then
    begin
      for i:=a^.length-1 downto 0 do
      begin
        if kiss_array_id(a, i) = FONT_TYPE then
        begin
          TTF_CloseFont(PTTF_Font(kiss_array_data(a, i)));
        end
        else if kiss_array_id(a, i) = TEXTURE_TYPE then
        begin
          SDL_DestroyTexture(PSDL_Texture(kiss_array_data(a, i)));
        end
        else if kiss_array_id(a, i) = RENDERER_TYPE then
        begin
          SDL_DestroyRenderer(PSDL_Renderer(kiss_array_data(a, i)));
        end
        else if kiss_array_id(a, i) = WINDOW_TYPE then
        begin
          SDL_DestroyWindow(PSDL_Window(kiss_array_data(a, i)));
        end
        else if kiss_array_id(a, i) = ARRAY_TYPE then
        begin
          kiss_array_free(Pkiss_array(kiss_array_data(a, i)));
        end
        else if kiss_array_id(a, i) = STRING_TYPE then
        begin
          // Conv.: Not sure if necessary, string type handling...
        end
        else
        begin
          FreeMem(a^.data[i]);
        end;
      end;
    end;
    a^.length := 0;
    kiss_array_free(a);
    TTF_Quit;
    IMG_Quit;
    SDL_Quit;
    result := 0;
  end;

end.

