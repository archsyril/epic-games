import sdl2 as sdl
import sdl2/image as img
import sdl2/ttf

template pause=
  while stdin.readline() != "":
    discard

type
  State= object
    init*, free*: proc(): void
    draw*, update*: proc(): void {.inline.}
  Game= object
    win: WindowPtr
    rnd: RendererPtr
    states: seq[State]

proc declare=
  var x: array[256, tuple[x,y: int32, s: int8]]

pause()
declare()
pause()