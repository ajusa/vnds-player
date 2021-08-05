import libctru
import pixie
# var tmpimage = newImage(320, 240)
var tmpscreen = newContext(320, 240)

proc printf(formatstr: cstring) {.importc: "printf", varargs,
                                  header: "<stdio.h>".}
proc main =
  let trees = readImage("./trees.png")
  var flag = false
  gfxInit(GSP_BGR8_OES, GSP_BGR8_OES, false)
  discard consoleInit(GFX_TOP, nil)
  gfxSetDoubleBuffering(GFX_BOTTOM, true)
  printf("Hello")
  tmpscreen.fillStyle = rgba(255, 0, 0, 255)
  var i = 0
  tmpscreen.drawImage(trees, vec2(0, 0))
  while aptMainLoop():
    var fb = gfxGetFramebuffer(GFX_BOTTOM, GFX_LEFT, nil, nil)
    hidScanInput()
    var kDown = hidKeysDown()
    if KEY_START in kDown:
      break 
    if KEY_A in kDown:
      tmpscreen.fillStyle = rgba(0, 255, 0, 255)
      flag = not flag
      if flag:
        tmpscreen.fillStyle = rgba(255, 0, 0, 255)
    tmpscreen.fillRect(rect(vec2(100, 100), vec2(150 + i.float, 100)))
    if i < 200:
      inc i
    var w = tmpscreen.image.width
    var h = tmpscreen.image.height
    var i = 0
    for c in countUp(0, w - 1):
      for r in countDown(h-1, 0):
        var color = tmpscreen.image.getRGBAUnsafe(c, r)
        fb[i] = color.b
        fb[i + 1] = color.g
        fb[i + 2] = color.r
        i = i + 3
    gfxFlushBuffers()
    gfxSwapBuffers()
    gspWaitForVBlank()

  gfxExit()

main()
