import sdl2 as sdl
import sdl2/image as img
import sdl2/ttf
import sdl2/gfx
import epic_games/ [util, state, input]

export Scancode

converter toCint*(i: int): cint= i.cint

var
  window*: WindowPtr
  renderer*: RendererPtr
  states*: StateMachine
type Game* = object
  frameRate*: cint

proc init*(game: var Game; title: cstring; w,h: cint): bool=
  if not sdl.init(INIT_VIDEO): err("SDL2")
  if img.init(IMG_INIT_PNG) != IMG_INIT_PNG: err("SDL_image")
  if not ttf.init(): err("SDL_ttf")

  if not isNil(window): destroy(window)
  window= createWindow(title, SDL_WINDOWPOS_UNDEFINED,SDL_WINDOWPOS_UNDEFINED, w,h, 0)
  if isNil(window): err("window")

  if not isNil(renderer): destroy(renderer)
  renderer= window.createRenderer(0, Renderer_Accelerated or Renderer_PresentVsync)
  if isNil(renderer): err("renderer")
  game.frameRate= 30

  return true

proc makeFpsManager(frameRate: cint): FpsManager=
  gfx.init(result)
  discard result.setFramerate(frameRate)

proc run*(game: var Game; initalState: State): void=
  var
    event: Event
    fpsMngr = makeFpsManager(game.frameRate)
    active: bool = true
  states.push(initalState)
  echo "sup"
  while active:
    while pollEvent(event) == True32:
      case event.kind
      of QuitEvent:
        active= false
        break
      else: discard
    run(states)
    delay(fpsMngr)
    updateKeys()
  clean(states)

proc `destroy=`*(game: var Game)=
  echo "game destroyed"
  kill(renderer)
  kill(window)
  ttf.quit()
  img.quit()
  sdl.quit()

proc clear*()   {.inline.}= renderer.clear()
proc present*() {.inline.}= renderer.present()
proc drawcolor*(r,g,b: uint8) {.inline.}=
  renderer.setDrawColor(r,g,b,255)