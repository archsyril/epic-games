import sdl2 as sdl
import graphics

template color*(r,g,b: range[0..255]): Color= color(r,g,b,255)
const
  White* = color(255, 255, 255)
  Black* = color( 0 ,  0 ,  0 )

template colormod*(i: Visual; c: Color)=
  discard setTextureColorMod(i, c.r,c.g,c.b)
template colormod*(i: Visual; c: Color; body)=
  colormod(i,c); body; colormod(i,White)
template colormod*(i: Visual; r,g,b: uint8)=
  discard setTextureColorMod(i, r,g,b)
template colormod*(i: Visual; r,g,b: uint8; body)=
  colormod(i,r,g,b); body; colormod(i,White)