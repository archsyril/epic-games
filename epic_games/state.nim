type
  State* = object
    init*, free*,
      draw*, update*: proc: void {.inline.}
  StateMachine* = seq[State]

# State
template state*[T](name): untyped=
  var
    name* {.inject.}: State
    `data name` {.inject.}: ptr T= nil
  name.free= (proc(): void {.inline.}= dealloc(`data name`))
template make(name; meat): untyped {.dirty.}=
  template name*(state; body): untyped= 
    type T= typeof `data state`[]
    {.warning[Deprecated]: off, this: self.}
    proc `name state`(self: var ptr T): void {.inline.}= meat
    state.name= (proc: void {.inline.}= `name state`(`data state`))
    {.warning[Deprecated]: on.}

template ptrLoc(pt): int= cast[int](pt)
#crafting init, quit, draw, update with templates
make init:
  if not isNil(self):
    state.free()
  self= cast[ptr T](alloc0(sizeof(T)))
  body
make free:
  body
  dealloc self
make draw: body
make update: body

# StateMachine
proc push*(sm: var StateMachine; state: State): void=
  sm.add(state)
  state.init()
proc pull*(sm: var StateMachine): void=
  sm.pop().free()
proc clean*(sm: var StateMachine): void=
  while sm.len != 0:
    sm.pull()
proc run*(sm: StateMachine): void {.inline.}=
  let state= sm[sm.len-1]
  state.update()
  state.draw()