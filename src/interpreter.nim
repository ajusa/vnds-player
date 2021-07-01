import strutils, parseutils, fusion/matching
{.experimental: "caseStmtMacros".}
type 
  InstructionKind* = enum
    bgload, setimg, sound, music, text, choice, setvar,gsetvar,
    conditional = "if", endConditional = "fi", jump, delay, random, label, goto
  Modifier* = enum equals = "=", plus = "+", minus = "-"
  TypeKind* = enum tkString, tkInt, tkFloat
  VNType* = object
    case kind: TypeKind
    of tkString: strVal*: string
    of tkInt: intVal*: int
    of tkFloat: floatVal*: float
  Comparison* = enum eq = "==", neq = "!=", lte = "<=", gte = ">=", lt = "<", gt = ">"
  Instruction* = object
    case kind: InstructionKind
    of bgload:
      bgloadFile*: string
      fadeFrames*: int
    of setimg:
      setimgFile*: string
      x*: int
      y*: int
    of sound:
      soundFile*: string
      times*: int
    of music: musicFile*: string
    of text: text*: string
    of choice: choices*: seq[string]
    of setvar, gsetvar:
      modifier*: Modifier
      setVariable*: string
      setValue*: string
    of conditional:
      comparison*: Comparison
      variable*: string
      value*: string
    of endConditional: discard
    of jump:
      jumpFile*: string
      label*: string
    of delay: delayFrames*: int
    of random:
      randomVariable*: string
      min*: int
      max*: int
    of label, goto: name*: string
proc stripQuotes(x: string): string =
  var cp = x
  cp.removeSuffix("\"")
  cp.removePrefix("\"")
  return cp

proc parse*(buffer: string): seq[Instruction] =
  for rawLine in buffer.splitLines:
    var line = rawLine.strip
    if line.len > 0 and not line.startsWith("#"):
      var instructionName: string
      discard line.parseUntil(instructionName, Whitespace)
      var args = line.split(" ")[1..^1]
      var instruction = Instruction(kind: parseEnum[InstructionKind](instructionName))
      case (instruction, args):
        of (bgload(), [@file, opt @frames or "16"]):
          instruction.bgloadFile = file
          instruction.fadeFrames = frames.parseInt
        of (setimg(), [@file, @x, @y]):
          instruction.setimgFile = file
          instruction.x = x.parseInt
          instruction.y = y.parseInt
        of (sound(), [@file, opt @times or "1"]):
          instruction.soundFile = file
          instruction.times = times.parseInt
        of (music(), [@file]):
          instruction.musicFile = file
        of (text(), @words):
          instruction.text = words.join(" ")
        of (choice(), @words):
          instruction.choices = words.join(" ").split("|")
        of ((kind: in {setvar, gsetvar}), [@variable, @modifier, all @words]):
          instruction.setVariable = variable
          instruction.modifier = parseEnum[Modifier](modifier)
          instruction.setValue = words.join(" ").stripQuotes
        of (conditional(), [@variable, @comparison, all @words]):
          instruction.variable = variable
          instruction.comparison = parseEnum[Comparison](comparison)
          instruction.value = words.join(" ").stripQuotes
        of (jump(), [@file, opt @label or ""]):
          instruction.jumpFile = file
          instruction.label = label
        of (delay(), [@frames]):
          instruction.delayFrames = frames.parseInt
        of (random(), [@variable, @min, @max]):
          instruction.randomVariable = variable
          instruction.min = min.parseInt
          instruction.max = max.parseInt
        of ((kind: {label, goto}), [@name]):
          instruction.name = name
        else: continue # unsupported instruction format
      result.add instruction
