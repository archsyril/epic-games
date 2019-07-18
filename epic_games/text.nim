import sdl2 as sdl
import sdl2/ttf
from ../epic_games import renderer
import graphics, color

export epic_games.renderer
export graphics.destroy
export color

var defaultFont: FontPtr

type
  Text* = object of Visual
  Font* = object
    data: FontPtr
    size*: cint
    loc: string

converter toFontPtr*(f: Font): FontPtr= f.data

proc ttf*(fn: string; size: cint=12): Font=
  result.loc= fn
  let fn= "font/"&fn&".ttf"
  result.data= openFont(fn, size)
  result.size= size
  if isNil(result): echo "Failed to load `$1`" % fn
  echo sdl.getError()
  if isNil(defaultFont): defaultFont= result

proc text*(str: cstring; color: Color= WHITE; font: FontPtr= defaultFont): Text {.inline.}=
  var surface= font.renderTextSolid(str, color)
  result.w= surface.w
  result.h= surface.h
  result.setData(surface)
template text*(color: Color; str: cstring; font: FontPtr= defaultFont): Text=
  text(str, color, font)

proc copy*(txt: Text; x,y: cint) {.inline.}=
  var dst= rect(x,y, txt.w, txt.h)
  renderer.copy(txt, nil, addr dst)
proc copy*(txt: Text; x,y: cint; scale: cint) {.inline.}=
  var dst= rect(x,y, txt.w*scale, txt.h*scale)
  renderer.copy(txt, nil, addr dst)

proc destroy*(f: Font)=
  f.data.close()

proc bigger*(f: var Font) {.inline.}=
  inc f.size; destroy(f); f.data= f.loc.ttf(f.size)
proc smaller*(f: var Font) {.inline.}=
  dec f.size; destroy(f); f.data= f.loc.ttf(f.size)