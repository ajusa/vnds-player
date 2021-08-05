## *
##  @file types.h
##  @brief Various system types.
##

## / The maximum value of a u64.


## / would be nice if newlib had this already

when not defined(SSIZE_MAX):
  when defined(SIZE_MAX):
    const
      SSIZE_MAX* = ((SIZE_MAX) shr 1)
type
  u8* = uint8

## /<  8-bit unsigned integer

type
  u16* = uint16

## /< 16-bit unsigned integer

type
  u32* = uint32

## /< 32-bit unsigned integer

type
  u64* = uint64

## /< 64-bit unsigned integer

type
  s8* = int8

## /<  8-bit signed integer

type
  s16* = int16

## /< 16-bit signed integer

type
  s32* = int32

## /< 32-bit signed integer

type
  s64* = int64

## /< 64-bit signed integer

type
  vu8* = u8

## /<  8-bit volatile unsigned integer.

type
  vu16* = u16

## /< 16-bit volatile unsigned integer.

type
  vu32* = u32

## /< 32-bit volatile unsigned integer.

type
  vu64* = u64

## /< 64-bit volatile unsigned integer.

type
  vs8* = s8

## /<  8-bit volatile signed integer.

type
  vs16* = s16

## /< 16-bit volatile signed integer.

type
  vs32* = s32

## /< 32-bit volatile signed integer.

type
  vs64* = s64

## /< 64-bit volatile signed integer.

type
  Handle* = u32

## /< Resource handle.

type
  Result* = s32

## /< Function result.

type
  ThreadFunc* = proc (a1: pointer)

## /< Thread entrypoint function.

type
  voidfn* = proc ()


## / Aligns a struct (and other types?) to m, making sure that the size of the struct is a multiple of m.

## / Packs a struct (and other types?) so it won't include padding bytes.

## / Structure representing CPU registers

type
  CpuRegisters* {.importc: "CpuRegisters", header: "types.h", bycopy.} = object
    r* {.importc: "r".}: array[13, u32] ## /< r0-r12.
    sp* {.importc: "sp".}: u32   ## /< sp.
    lr* {.importc: "lr".}: u32   ## /< lr.
    pc* {.importc: "pc".}: u32   ## /< pc. May need to be adjusted.
    cpsr* {.importc: "cpsr".}: u32 ## /< cpsr.


## / Structure representing FPU registers

## !!!Ignored construct:  typedef struct { union { struct __attribute__ ( ( packed ) ) { double d [ 16 ] ; } ; /< d0-d15. float s [ 32 ] ; /< s0-s31. } ; u32 fpscr ; /< fpscr. u32 fpexc ; /< fpexc. } FpuRegisters ;
## Error: token expected: ; but got: {!!!
