import parser, tables, strutils, parseutils, fusion/matching, with, lenientops
{.experimental: "caseStmtMacros".}
type 
  TypeKind = enum tkString, tkInt, tkFloat
  VNType = object
    case kind: TypeKind
    of tkString: stringVal*: string
    of tkInt: intVal*: int
    of tkFloat: floatVal*: float
  Interpreter* = object
    instructions: seq[Instruction]
    n: int
    globalTable: TableRef[string, VNType]
    localTable: TableRef[string, VNType]
    labels: TableRef[string, int]

proc eval*(state: Interpreter, ins: Instruction): Instruction =
  ## Evaluates the instruction and returns the "filled in" version
  echo ins

proc initInterpreter*(instructions: string): Interpreter =
  result = Interpreter(
    instructions: instructions.parse,
    n: 0,
    globalTable: newTable[string, VNType](),
    localTable: newTable[string, VNType](),
    labels: newTable[string, int]()
  )
  # Mark down where each label is
  for i, ins in result.instructions:
    if ins.kind == label:
      result.labels[ins.name] = i
proc initVNType*(
    x: string,
    local = newTable[string, VNType](),
    global = newTable[string, VNType]()
  ): VNType =
  ## Figures out the type of a literal, uses local/global to lookup variable value as well
  if x[0] == '"':
    return VNType(kind: tkString, stringVal: x)
  if "." in x:
    return VNType(kind: tkFloat, floatVal: x.parseFloat)
  var intVal: int
  if x.parseInt(intVal) != 0:
    return VNType(kind: tkInt, intVal: intVal)
  result =
    if x in local: local[x]
    elif x in global: global[x]
    else: VNType(kind: tkString, stringVal: "")
template numericOperator(op: untyped, stringDefined = false): untyped =
  proc `-` (a, b: VNType): VNType =
    case (a.kind, b.kind):
      of (tkInt, tkInt):
        return VNType(kind: tkInt, intVal: op(a.intVal, b.intVal))
      of (tkFloat, tkFloat):
        return VNType(kind: tkFloat, floatVal: op(a.floatVal, b.floatVal))
      of (tkInt, tkFloat):
        return VNType(kind: tkFloat, floatVal: op(a.intVal, b.floatVal))
      of (tkFloat, tkInt):
        return VNType(kind: tkFloat, floatVal: op(a.floatVal, b.intVal))
      of (tkString, tkFloat):
        return VNType(kind: tkString, stringVal: a.stringVal & $b.floatVal)
      of (tkString, tkInt):
        return VNType(kind: tkString, stringVal: a.stringVal & $b.intVal)
      of (tkInt, tkString):
        return VNType(kind: tkString, stringVal: $a.intVal & b.stringVal)
      of (tkFloat, tkString):
        return VNType(kind: tkString, stringVal: $a.floatVal & b.stringVal)
numericOperator(`-`)
proc `-=` (a: var VNType, b: VNType) = a = a - b
proc `+` (a, b: VNType): VNType = a
proc `+=` (a: var VNType, b: VNType) = a = a + b

proc run*(state: var Interpreter) =
  with state:
    while n < instructions.len:
      var ins = instructions[n]
      case ins:
        of (kind: in {setvar, gsetvar}):
          var table = if ins.kind == setvar: localTable else: globalTable
          var val = ins.setValue.initVNType(localTable, globalTable)
          case ins.modifier:
            of equals: table[ins.setVariable] = val
            of plus: table[ins.setVariable] += val
            of minus: table[ins.setVariable] -= val
          echo val
        of text():
          echo ins
        else: discard
      inc n
