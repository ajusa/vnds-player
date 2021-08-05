import interpreter, parser, print

var vndsInterpreter = initInterpreter("""
setvar a = 5
setvar a + 5
text $a
""")

vndsInterpreter.run()

echo initVNType(""""hello there"""")
echo initVNType("5.0")
echo initVNType("5")

import fusion/matching
{.experimental: "caseStmtMacros".}
type
  TypeKind = enum tkString, tkInt, tkFloat
  VNType = object
    case kind: TypeKind
    of tkString: stringVal*: string
    of tkInt: intVal*: int
    of tkFloat: floatVal*: float
template value(x: VNType, name, body: untyped): untyped =
  if x.kind == tkInt:
    var name {.inject.} = x.intVal
    body
  if x.kind == tkFloat:
    var name {.inject.} = x.floatVal
    body
  if x.kind == tkString:
    var name {.inject.} = x.stringVal
    body

template makeGeneric(lhs, rhs: set[TypeKind], body: untyped): untyped =
  for kind in lhs:
    if kind == a.kind:
      a.value(val1):
        for kind in rhs:
          if kind == b.kind:
            b.value(val2):
              body

var a = VNType(kind: tkInt, intVal: 4)
var b = VNType(kind: tkInt, intVal: 4)
makeGeneric({tkInt, tkFloat}, {tkInt}):
  echo val1
proc `-` (a, b: VNType): VNType =
  case (a, b):
    of ((intVal: @val1(a.kind == tkInt) or (floatVal: @val1(a.kind == floatVal))), (intVal: @val2(b.kind == tkInt))):
      return VNType(intVal: val1 - val2, kind: tkInt)
