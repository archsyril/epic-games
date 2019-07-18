import sdl2 as sdl

type
  Keyboard* = array[0..512, uint8]
  KeyboardPtr* = ptr Keyboard

var
  keys: KeyboardPtr = sdl.getKeyboardState(nil)
  prevKeys: Keyboard

proc updateKeys*() {.inline.}= prevKeys= keys[]

proc down*(s: Scancode): bool {.inline.}=
  keys[s.uint8] != 0
proc held*(s: Scancode): bool {.inline.}=
  keys[s.uint8] != 0 and prevKeys[s.uint8] != 0
proc tapped*(s: Scancode): bool {.inline.}=
  keys[s.uint8] != 0 and prevKeys[s.uint8] == 0

proc onPress*(s: Scancode): bool {.inline.}=
  keys[s.uint8] != 0 and prevKeys[s.uint8] == 0
proc onRelease*(s: Scancode): bool {.inline.}=
  keys[s.uint8] == 0 and prevKeys[s.uint8] != 0