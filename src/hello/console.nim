import types
import gfx
## *
##  @file console.h
##  @brief 3ds stdio support.
##
##  Provides stdio integration for printing to the 3DS screen as well as debug print
##  functionality provided by stderr.
##
##  General usage is to initialize the console by:
##  @code
##  consoleDemoInit()
##  @endcode
##  or to customize the console usage by:
##  @code
##  consoleInit()
##  @endcode
##

template CONSOLE_ESC*(x: untyped): untyped =
  "\e["

## !!!Ignored construct:  # CONSOLE_RESET CONSOLE_ESC ( 0m ) [NewLine] # CONSOLE_BLACK CONSOLE_ESC ( 30m ) [NewLine] # CONSOLE_RED CONSOLE_ESC ( 31 ;
## Error: did not expect ;!!!

## !!!Ignored construct:  1m ) [NewLine] # CONSOLE_GREEN CONSOLE_ESC ( 32 ;
## Error: expected ';'!!!

## !!!Ignored construct:  1m ) [NewLine] # CONSOLE_YELLOW CONSOLE_ESC ( 33 ;
## Error: expected ';'!!!

## !!!Ignored construct:  1m ) [NewLine] # CONSOLE_BLUE CONSOLE_ESC ( 34 ;
## Error: expected ';'!!!

## !!!Ignored construct:  1m ) [NewLine] # CONSOLE_MAGENTA CONSOLE_ESC ( 35 ;
## Error: expected ';'!!!

## !!!Ignored construct:  1m ) [NewLine] # CONSOLE_CYAN CONSOLE_ESC ( 36 ;
## Error: expected ';'!!!

## !!!Ignored construct:  1m ) [NewLine] # CONSOLE_WHITE CONSOLE_ESC ( 37 ;
## Error: expected ';'!!!

## !!!Ignored construct:  1m ) [NewLine] / A callback for printing a character. typedef bool ( * ConsolePrint ) ( void * con , int c ) ;
## Error: expected ';'!!!

## / A font struct for the console.

type
  ConsoleFont* {.importc: "ConsoleFont", header: "<3ds/console.h>", bycopy.} = object
    gfx* {.importc: "gfx".}: ptr u8 ## /< A pointer to the font graphics
    asciiOffset* {.importc: "asciiOffset".}: u16 ## /< Offset to the first valid character in the font table
    numChars* {.importc: "numChars".}: u16 ## /< Number of characters in the font graphics


## *
##  @brief Console structure used to store the state of a console render context.
##
##  Default values from consoleGetDefault();
##  @code
##  PrintConsole defaultConsole =
##  {
##  	//Font:
##  	{
##  		(u8*)default_font_bin, //font gfx
##  		0, //first ascii character in the set
##  		128, //number of characters in the font set
## 	},
## 	0,0, //cursorX cursorY
## 	0,0, //prevcursorX prevcursorY
## 	40, //console width
## 	30, //console height
## 	0,  //window x
## 	0,  //window y
## 	32, //window width
## 	24, //window height
## 	3, //tab size
## 	0, //font character offset
## 	0,  //print callback
## 	false //console initialized
##  };
##  @endcode
##

type
  PrintConsole* {.importc: "PrintConsole", header: "<3ds/console.h>", bycopy.} = object
    font* {.importc: "font".}: ConsoleFont ## /< Font of the console
    frameBuffer* {.importc: "frameBuffer".}: ptr u16 ## /< Framebuffer address
    cursorX* {.importc: "cursorX".}: cint ## /< Current X location of the cursor (as a tile offset by default)
    cursorY* {.importc: "cursorY".}: cint ## /< Current Y location of the cursor (as a tile offset by default)
    prevCursorX* {.importc: "prevCursorX".}: cint ## /< Internal state
    prevCursorY* {.importc: "prevCursorY".}: cint ## /< Internal state
    consoleWidth* {.importc: "consoleWidth".}: cint ## /< Width of the console hardware layer in characters
    consoleHeight* {.importc: "consoleHeight".}: cint ## /< Height of the console hardware layer in characters
    windowX* {.importc: "windowX".}: cint ## /< Window X location in characters (not implemented)
    windowY* {.importc: "windowY".}: cint ## /< Window Y location in characters (not implemented)
    windowWidth* {.importc: "windowWidth".}: cint ## /< Window width in characters (not implemented)
    windowHeight* {.importc: "windowHeight".}: cint ## /< Window height in characters (not implemented)
    tabSize* {.importc: "tabSize".}: cint ## /< Size of a tab
    fg* {.importc: "fg".}: cint  ## /< Foreground color
    bg* {.importc: "bg".}: cint  ## /< Background color
    flags* {.importc: "flags".}: cint ## /< Reverse/bright flags
    # PrintChar* {.importc: "PrintChar".}: ConsolePrint ## /< Callback for printing a character. Should return true if it has handled rendering the graphics (else the print engine will attempt to render via tiles).
    consoleInitialised* {.importc: "consoleInitialised".}: bool ## /< True if the console is initialized


const
  CONSOLE_COLOR_BOLD* = (1 shl 0) ## /< Bold text
  CONSOLE_COLOR_FAINT* = (1 shl 1) ## /< Faint text
  CONSOLE_ITALIC* = (1 shl 2)     ## /< Italic text
  CONSOLE_UNDERLINE* = (1 shl 3)  ## /< Underlined text
  CONSOLE_BLINK_SLOW* = (1 shl 4) ## /< Slow blinking text
  CONSOLE_BLINK_FAST* = (1 shl 5) ## /< Fast blinking text
  CONSOLE_COLOR_REVERSE* = (1 shl 6) ## /< Reversed color text
  CONSOLE_CONCEAL* = (1 shl 7)    ## /< Concealed text
  CONSOLE_CROSSED_OUT* = (1 shl 8) ## /< Crossed out text

## / Console debug devices supported by libnds.

type
  debugDevice* {.size: sizeof(cint).} = enum
    debugDevice_NULL,         ## /< Swallows prints to stderr
    debugDevice_SVC,          ## /< Outputs stderr debug statements using svcOutputDebugString, which can then be captured by interactive debuggers
    debugDevice_CONSOLE       ## /< Directs stderr debug statements to 3DS console window

const
  debugDevice_3DMOO* = debugDevice_SVC

## *
##  @brief Loads the font into the console.
##  @param console Pointer to the console to update, if NULL it will update the current console.
##  @param font The font to load.
##

proc consoleSetFont*(console: ptr PrintConsole; font: ptr ConsoleFont) {.
    importc: "consoleSetFont", header: "<3ds/console.h>".}
## *
##  @brief Sets the print window.
##  @param console Console to set, if NULL it will set the current console window.
##  @param x X location of the window.
##  @param y Y location of the window.
##  @param width Width of the window.
##  @param height Height of the window.
##

proc consoleSetWindow*(console: ptr PrintConsole; x: cint; y: cint; width: cint;
                      height: cint) {.importc: "consoleSetWindow",
                                    header: "<3ds/console.h>".}
## *
##  @brief Gets a pointer to the console with the default values.
##  This should only be used when using a single console or without changing the console that is returned, otherwise use consoleInit().
##  @return A pointer to the console with the default values.
##

proc consoleGetDefault*(): ptr PrintConsole {.importc: "consoleGetDefault",
    header: "<3ds/console.h>".}
## *
##  @brief Make the specified console the render target.
##  @param console A pointer to the console struct (must have been initialized with consoleInit(PrintConsole* console)).
##  @return A pointer to the previous console.
##

proc consoleSelect*(console: ptr PrintConsole): ptr PrintConsole {.
    importc: "consoleSelect", header: "<3ds/console.h>".}
## *
##  @brief Initialise the console.
##  @param screen The screen to use for the console.
##  @param console A pointer to the console data to initialize (if it's NULL, the default console will be used).
##  @return A pointer to the current console.
##

proc consoleInit*(screen: gfxScreen_t; console: ptr PrintConsole): ptr PrintConsole {.
    importc: "consoleInit", header: "<3ds/console.h>".}
## *
##  @brief Initializes debug console output on stderr to the specified device.
##  @param device The debug device (or devices) to output debug print statements to.
##

proc consoleDebugInit*(device: debugDevice) {.importc: "consoleDebugInit",
    header: "<3ds/console.h>".}
## / Clears the screen by using iprintf("\x1b[2J");

proc consoleClear*() {.importc: "consoleClear", header: "<3ds/console.h>".}
