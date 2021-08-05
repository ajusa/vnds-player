import gspgpu
import types
## *
##  @file gfx.h
##  @brief Simple framebuffer API
##
##  This API provides basic functionality needed to bring up framebuffers for both screens,
##  as well as managing display mode (stereoscopic 3D) and double buffering.
##  It is mainly an abstraction over the gsp service.
##
##  Please note that the 3DS uses *portrait* screens rotated 90 degrees counterclockwise.
##  Width/height refer to the physical dimensions of the screen; that is, the top screen
##  is 240 pixels wide and 400 pixels tall; while the bottom screen is 240x320.
##

## / Converts red, green, and blue components to packed RGB565.

template RGB565*(r, g, b: untyped): untyped =
  (((b) and 0x1f) or (((g) and 0x3f) shl 5) or (((r) and 0x1f) shl 11))

## / Converts packed RGB8 to packed RGB565.

template RGB8_to_565*(r, g, b: untyped): untyped =
  (((b) shr 3) and 0x1f) or ((((g) shr 2) and 0x3f) shl 5) or
      ((((r) shr 3) and 0x1f) shl 11)

## / Screen IDs.

type
  gfxScreen_t* {.size: sizeof(cint).} = enum
    GFX_TOP = GSP_SCREEN_TOP,   ## /< Top screen
    GFX_BOTTOM = GSP_SCREEN_BOTTOM ## /< Bottom screen


## *
##  @brief Top screen framebuffer side.
##
##  This is only meaningful when stereoscopic 3D is enabled on the top screen.
##  In any other case, use \ref GFX_LEFT.
##

type
  gfx3dSide_t* {.size: sizeof(cint).} = enum
    GFX_LEFT = 0,               ## /< Left eye framebuffer
    GFX_RIGHT = 1               ## /< Right eye framebuffer


## /@name Initialization and deinitialization
## /@{
## *
##  @brief Initializes the LCD framebuffers with default parameters
##  This is equivalent to calling: @code gfxInit(GSP_BGR8_OES,GSP_BGR8_OES,false); @endcode
##

proc gfxInitDefault*() {.importc: "gfxInitDefault", header: "<3ds/gfx.h>".}
## *
##  @brief Initializes the LCD framebuffers.
##  @param topFormat The format of the top screen framebuffers.
##  @param bottomFormat The format of the bottom screen framebuffers.
##  @param vramBuffers Whether to allocate the framebuffers in VRAM.
##
##  This function allocates memory for the framebuffers in the specified memory region.
##  Initially, stereoscopic 3D is disabled and double buffering is enabled.
##
##  @note This function internally calls \ref gspInit.
##

proc gfxInit*(topFormat: GSPGPU_FramebufferFormat;
             bottomFormat: GSPGPU_FramebufferFormat; vrambuffers: bool) {.
    importc: "gfxInit", header: "<3ds/gfx.h>".}
## *
##  @brief Deinitializes and frees the LCD framebuffers.
##  @note This function internally calls \ref gspExit.
##

proc gfxExit*() {.importc: "gfxExit", header: "<3ds/gfx.h>".}
## /@}
## /@name Control
## /@{
## *
##  @brief Enables or disables the 3D stereoscopic effect on the top screen.
##  @param enable Pass true to enable, false to disable.
##  @note Stereoscopic 3D is disabled by default.
##

proc gfxSet3D*(enable: bool) {.importc: "gfxSet3D", header: "<3ds/gfx.h>".}
## *
##  @brief Retrieves the status of the 3D stereoscopic effect on the top screen.
##  @return true if 3D enabled, false otherwise.
##

proc gfxIs3D*(): bool {.importc: "gfxIs3D", header: "<3ds/gfx.h>".}
## *
##  @brief Retrieves the status of the 800px (double-height) high resolution display mode of the top screen.
##  @return true if wide mode enabled, false otherwise.
##

proc gfxIsWide*(): bool {.importc: "gfxIsWide", header: "<3ds/gfx.h>".}
## *
##  @brief Enables or disables the 800px (double-height) high resolution display mode of the top screen.
##  @param enable Pass true to enable, false to disable.
##  @note Wide mode is disabled by default.
##  @note Wide and stereoscopic 3D modes are mutually exclusive.
##  @note In wide mode pixels are not square, since scanlines are half as tall as they normally are.
##  @warning Wide mode does not work on Old 2DS consoles (however it does work on New 2DS XL consoles).
##

proc gfxSetWide*(enable: bool) {.importc: "gfxSetWide", header: "<3ds/gfx.h>".}
## *
##  @brief Changes the pixel format of a screen.
##  @param screen Screen ID (see \ref gfxScreen_t)
##  @param format Pixel format (see \ref GSPGPU_FramebufferFormat)
##  @note If the currently allocated framebuffers are too small for the specified format,
##        they are freed and new ones are reallocated.
##

proc gfxSetScreenFormat*(screen: gfxScreen_t; format: GSPGPU_FramebufferFormat) {.
    importc: "gfxSetScreenFormat", header: "<3ds/gfx.h>".}
## *
##  @brief Retrieves the current pixel format of a screen.
##  @param screen Screen ID (see \ref gfxScreen_t)
##  @return Pixel format (see \ref GSPGPU_FramebufferFormat)
##

proc gfxGetScreenFormat*(screen: gfxScreen_t): GSPGPU_FramebufferFormat {.
    importc: "gfxGetScreenFormat", header: "<3ds/gfx.h>".}
## *
##  @brief Enables or disables double buffering on a screen.
##  @param screen Screen ID (see \ref gfxScreen_t)
##  @param enable Pass true to enable, false to disable.
##  @note Double buffering is enabled by default.
##

proc gfxSetDoubleBuffering*(screen: gfxScreen_t; enable: bool) {.
    importc: "gfxSetDoubleBuffering", header: "<3ds/gfx.h>".}
## /@}
## /@name Rendering and presentation
## /@{
## *
##  @brief Retrieves the framebuffer of the specified screen to which graphics should be rendered.
##  @param screen Screen ID (see \ref gfxScreen_t)
##  @param side Framebuffer side (see \ref gfx3dSide_t) (pass \ref GFX_LEFT if not using stereoscopic 3D)
##  @param width Pointer that will hold the width of the framebuffer in pixels.
##  @param height Pointer that will hold the height of the framebuffer in pixels.
##  @return A pointer to the current framebuffer of the chosen screen.
##
##  Please remember that the returned pointer will change every frame if double buffering is enabled.
##

proc gfxGetFramebuffer*(screen: gfxScreen_t; side: gfx3dSide_t; width: ptr u16;
                       height: ptr u16): ptr UncheckedArray[uint8] {.importc: "gfxGetFramebuffer",
    header: "<3ds/gfx.h>".}
## *
##  @brief Flushes the data cache for the current framebuffers.
##  @warning This is **only used during software rendering**. Since this function has significant overhead,
##           it is preferred to call this only once per frame, after all software rendering is completed.
##

proc gfxFlushBuffers*() {.importc: "gfxFlushBuffers", header: "<3ds/gfx.h>".}
## *
##  @brief Updates the configuration of the specified screen, swapping the buffers if double buffering is enabled.
##  @param scr Screen ID (see \ref gfxScreen_t)
##  @param hasStereo For the top screen in 3D mode: true if the framebuffer contains individual images
##                   for both eyes, or false if the left image should be duplicated to the right eye.
##  @note Previously rendered content will be displayed on the screen after the next VBlank.
##  @note This function is still useful even if double buffering is disabled, as it must be used to commit configuration changes.
##  @warning Only call this once per screen per frame, otherwise graphical glitches will occur
##           since this API does not implement triple buffering.
##

proc gfxScreenSwapBuffers*(scr: gfxScreen_t; hasStereo: bool) {.
    importc: "gfxScreenSwapBuffers", header: "<3ds/gfx.h>".}
## *
##  @brief Same as \ref gfxScreenSwapBuffers, but with hasStereo set to true.
##  @param scr Screen ID (see \ref gfxScreen_t)
##  @param immediate This parameter no longer has any effect and is thus ignored.
##  @deprecated This function has been superseded by \ref gfxScreenSwapBuffers, please use that instead.
##

## !!!Ignored construct:  DEPRECATED void gfxConfigScreen ( gfxScreen_t scr , bool immediate ) ;
## Error: token expected: ; but got: [identifier]!!!

## *
##  @brief Updates the configuration of both screens.
##  @note This function is equivalent to: \code gfxScreenSwapBuffers(GFX_TOP,true); gfxScreenSwapBuffers(GFX_BOTTOM,true); \endcode
##

proc gfxSwapBuffers*() {.importc: "gfxSwapBuffers", header: "<3ds/gfx.h>".}
## / Same as \ref gfxSwapBuffers (formerly different).

proc gfxSwapBuffersGpu*() {.importc: "gfxSwapBuffersGpu", header: "<3ds/gfx.h>".}
## /@}
