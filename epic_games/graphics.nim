import sdl2 as sdl
import sdl2/image as img
from ../epic_game import renderer

export ../epic_game.renderer

type
  Visual* = object of RootObj
    data: TexturePtr
    w*,h*: int32
  Image* = object of Visual

converter toTexturePtr*(v: Visual): TexturePtr {.inline.}= v.data
proc setData*(v: var Visual; s: SurfacePtr): void=
  v.data= renderer.createTextureFromSurface(s)

proc image(fn: string): Image=
  let surface= img.load(cstring(fn))
  if isNil(surface):
    echo "Failed to load `$1`" % fn
  result.w= surface.w
  result.h= surface.h
  result.setData(surface)
  #result.data= renderer.createTextureFromSurface(surface)
  destroy(surface)

proc png*(fn: string): Image= image("art/"&fn&".png")

proc rect*(x,y, w,h: int): Rect {.inline.}=
  rect(x.cint, y.cint, w.cint, h.cint)

proc copy*(img: Image) {.inline.}=
  renderer.copy(img, nil, nil)
proc copy*(img: Image; x,y: cint) {.inline.}=
  var dst= rect(x,y, img.w, img.h)
  renderer.copy(img, nil, addr dst)
proc copy*(img: Image; x,y, w,h: cint) {.inline.}=
  var dst= rect(x,y, w,h)
  renderer.copy(img, nil, addr dst)
proc copy*(img: Image; x,y: cint; size: cint) {.inline.}=
  var dst= rect(x,y, size,size)
  renderer.copy(img, nil, addr dst)

proc destroy*(v: Visual) {.inline.}=
  v.data.destroy()
proc destroy*(va: varargs[Visual])=
  for v in va:
    destroy(v.data)