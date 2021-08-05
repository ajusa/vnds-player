## *
##  @file gspgpu.h
##  @brief GSPGPU service.
##
import types

const
  GSP_SCREEN_TOP* = 0
  GSP_SCREEN_BOTTOM* = 1
  GSP_SCREEN_WIDTH* = 240
  GSP_SCREEN_HEIGHT_TOP* = 400
  GSP_SCREEN_HEIGHT_TOP_2X* = 800
  GSP_SCREEN_HEIGHT_BOTTOM* = 320

## / Framebuffer information.

type
  GSPGPU_FramebufferInfo* {.importc: "GSPGPU_FramebufferInfo", header: "<3ds/services/gspgpu.h>",
                           bycopy.} = object
    active_framebuf* {.importc: "active_framebuf".}: u32 ## /< Active framebuffer. (0 = first, 1 = second)
    framebuf0_vaddr* {.importc: "framebuf0_vaddr".}: ptr u32 ## /< Framebuffer virtual address, for the main screen this is the 3D left framebuffer.
    framebuf1_vaddr* {.importc: "framebuf1_vaddr".}: ptr u32 ## /< For the main screen: 3D right framebuffer address.
    framebuf_widthbytesize* {.importc: "framebuf_widthbytesize".}: u32 ## /< Value for 0x1EF00X90, controls framebuffer width.
    format* {.importc: "format".}: u32 ## /< Framebuffer format, this u16 is written to the low u16 for LCD register 0x1EF00X70.
    framebuf_dispselect* {.importc: "framebuf_dispselect".}: u32 ## /< Value for 0x1EF00X78, controls which framebuffer is displayed.
    unk* {.importc: "unk".}: u32 ## /< Unknown.


## / Framebuffer format.

type
  GSPGPU_FramebufferFormat* {.size: sizeof(cint).} = enum
    GSP_RGBA8_OES = 0,          ## /< RGBA8. (4 bytes)
    GSP_BGR8_OES = 1,           ## /< BGR8. (3 bytes)
    GSP_RGB565_OES = 2,         ## /< RGB565. (2 bytes)
    GSP_RGB5_A1_OES = 3,        ## /< RGB5A1. (2 bytes)
    GSP_RGBA4_OES = 4


## / Capture info entry.

type
  GSPGPU_CaptureInfoEntry* {.importc: "GSPGPU_CaptureInfoEntry",
                            header: "<3ds/services/gspgpu.h>", bycopy.} = object
    framebuf0_vaddr* {.importc: "framebuf0_vaddr".}: ptr u32 ## /< Left framebuffer.
    framebuf1_vaddr* {.importc: "framebuf1_vaddr".}: ptr u32 ## /< Right framebuffer.
    format* {.importc: "format".}: u32 ## /< Framebuffer format.
    framebuf_widthbytesize* {.importc: "framebuf_widthbytesize".}: u32 ## /< Framebuffer pitch.


## / Capture info.

type
  GSPGPU_CaptureInfo* {.importc: "GSPGPU_CaptureInfo", header: "<3ds/services/gspgpu.h>", bycopy.} = object
    screencapture* {.importc: "screencapture".}: array[2, GSPGPU_CaptureInfoEntry] ## /< Capture info entries, one for each screen.


## / GSPGPU events.

type
  GSPGPU_Event* {.size: sizeof(cint).} = enum
    GSPGPU_EVENT_PSC0 = 0,      ## /< Memory fill completed.
    GSPGPU_EVENT_PSC1,        ## /< TODO
    GSPGPU_EVENT_VBlank0,     ## /< TODO
    GSPGPU_EVENT_VBlank1,     ## /< TODO
    GSPGPU_EVENT_PPF,         ## /< Display transfer finished.
    GSPGPU_EVENT_P3D,         ## /< Command list processing finished.
    GSPGPU_EVENT_DMA,         ## /< TODO
    GSPGPU_EVENT_MAX          ## /< Used to know how many events there are.


## *
##  @brief Gets the number of bytes per pixel for the specified format.
##  @param format See \ref GSPGPU_FramebufferFormat.
##  @return Bytes per pixel.
##

proc gspGetBytesPerPixel*(format: GSPGPU_FramebufferFormat): cuint {.inline.} =
  ## !!!Ignored construct:  switch ( format ) { case GSP_RGBA8_OES : return 4 ; default : case GSP_BGR8_OES : return 3 ; case GSP_RGB565_OES : case GSP_RGB5_A1_OES : case GSP_RGBA4_OES : return 2 ; } }
  ## Error: token expected: } but got: [identifier]!!!

## / Initializes GSPGPU.

proc gspInit*(): Result {.importc: "gspInit", header: "<3ds/services/gspgpu.h>".}
## / Exits GSPGPU.

proc gspExit*() {.importc: "gspExit", header: "<3ds/services/gspgpu.h>".}
## / Returns true if the application currently has GPU rights.

proc gspHasGpuRight*(): bool {.importc: "gspHasGpuRight", header: "<3ds/services/gspgpu.h>".}
## *
##  @brief Presents a buffer to the specified screen.
##  @param screen Screen ID (see \ref GSP_SCREEN_TOP and \ref GSP_SCREEN_BOTTOM)
##  @param swap Specifies which set of framebuffer registers to configure and activate (0 or 1)
##  @param fb_a Pointer to the framebuffer (in stereo mode: left eye)
##  @param fb_b Pointer to the secondary framebuffer (only used in stereo mode for the right eye, otherwise pass the same as fb_a)
##  @param stride Stride in bytes between scanlines
##  @param mode Mode configuration to be written to LCD register
##  @return true if a buffer had already been presented to the screen but not processed yet by GSP, false otherwise.
##  @note The most recently presented buffer is processed and configured during the specified screen's next VBlank event.
##

proc gspPresentBuffer*(screen: cuint; swap: cuint; fb_a: pointer; fb_b: pointer;
                      stride: u32; mode: u32): bool {.importc: "gspPresentBuffer",
    header: "<3ds/services/gspgpu.h>".}
## *
##  @brief Returns true if a prior \ref gspPresentBuffer command is still pending to be processed by GSP.
##  @param screen Screen ID (see \ref GSP_SCREEN_TOP and \ref GSP_SCREEN_BOTTOM)
##

proc gspIsPresentPending*(screen: cuint): bool {.importc: "gspIsPresentPending",
    header: "<3ds/services/gspgpu.h>".}
## *
##  @brief Configures a callback to run when a GSPGPU event occurs.
##  @param id ID of the event.
##  @param cb Callback to run.
##  @param data Data to be passed to the callback.
##  @param oneShot When true, the callback is only executed once. When false, the callback is executed every time the event occurs.
##

proc gspSetEventCallback*(id: GSPGPU_Event; cb: ThreadFunc; data: pointer;
                         oneShot: bool) {.importc: "gspSetEventCallback",
                                        header: "<3ds/services/gspgpu.h>".}
## *
##  @brief Waits for a GSPGPU event to occur.
##  @param id ID of the event.
##  @param nextEvent Whether to discard the current event and wait for the next event.
##

proc gspWaitForEvent*(id: GSPGPU_Event; nextEvent: bool) {.
    importc: "gspWaitForEvent", header: "<3ds/services/gspgpu.h>".}
## *
##  @brief Waits for any GSPGPU event to occur.
##  @return The ID of the event that occurred.
##
##  The function returns immediately if there are unprocessed events at the time of call.
##

proc gspWaitForAnyEvent*(): GSPGPU_Event {.importc: "gspWaitForAnyEvent",
                                        header: "<3ds/services/gspgpu.h>".}
## / Waits for PSC0

template gspWaitForPSC0*(): untyped =
  gspWaitForEvent(GSPGPU_EVENT_PSC0, false)

## / Waits for PSC1

template gspWaitForPSC1*(): untyped =
  gspWaitForEvent(GSPGPU_EVENT_PSC1, false)

## / Waits for VBlank.

template gspWaitForVBlank*(): untyped =
  gspWaitForVBlank0()

## / Waits for VBlank0.

template gspWaitForVBlank0*(): untyped =
  gspWaitForEvent(GSPGPU_EVENT_VBlank0, true)

## / Waits for VBlank1.

template gspWaitForVBlank1*(): untyped =
  gspWaitForEvent(GSPGPU_EVENT_VBlank1, true)

## / Waits for PPF.

template gspWaitForPPF*(): untyped =
  gspWaitForEvent(GSPGPU_EVENT_PPF, false)

## / Waits for P3D.

template gspWaitForP3D*(): untyped =
  gspWaitForEvent(GSPGPU_EVENT_P3D, false)

## / Waits for DMA.

template gspWaitForDMA*(): untyped =
  gspWaitForEvent(GSPGPU_EVENT_DMA, false)

## *
##  @brief Submits a GX command.
##  @param gxCommand GX command to execute.
##

proc gspSubmitGxCommand*(gxCommand: array[0x8, u32]): Result {.
    importc: "gspSubmitGxCommand", header: "<3ds/services/gspgpu.h>".}
## *
##  @brief Acquires GPU rights.
##  @param flags Flags to acquire with.
##

proc GSPGPU_AcquireRight*(flags: u8): Result {.importc: "GSPGPU_AcquireRight",
    header: "<3ds/services/gspgpu.h>".}
## / Releases GPU rights.

proc GSPGPU_ReleaseRight*(): Result {.importc: "GSPGPU_ReleaseRight",
                                   header: "<3ds/services/gspgpu.h>".}
## *
##  @brief Retrieves display capture info.
##  @param captureinfo Pointer to output capture info to.
##

proc GSPGPU_ImportDisplayCaptureInfo*(captureinfo: ptr GSPGPU_CaptureInfo): Result {.
    importc: "GSPGPU_ImportDisplayCaptureInfo", header: "<3ds/services/gspgpu.h>".}
## / Saves the VRAM sys area.

proc GSPGPU_SaveVramSysArea*(): Result {.importc: "GSPGPU_SaveVramSysArea",
                                      header: "<3ds/services/gspgpu.h>".}
## / Resets the GPU

proc GSPGPU_ResetGpuCore*(): Result {.importc: "GSPGPU_ResetGpuCore",
                                   header: "<3ds/services/gspgpu.h>".}
## / Restores the VRAM sys area.

proc GSPGPU_RestoreVramSysArea*(): Result {.importc: "GSPGPU_RestoreVramSysArea",
    header: "<3ds/services/gspgpu.h>".}
## *
##  @brief Sets whether to force the LCD to black.
##  @param flags Whether to force the LCD to black. (0 = no, non-zero = yes)
##

proc GSPGPU_SetLcdForceBlack*(flags: u8): Result {.
    importc: "GSPGPU_SetLcdForceBlack", header: "<3ds/services/gspgpu.h>".}
## *
##  @brief Updates a screen's framebuffer state.
##  @param screenid ID of the screen to update.
##  @param framebufinfo Framebuffer information to update with.
##

proc GSPGPU_SetBufferSwap*(screenid: u32; framebufinfo: ptr GSPGPU_FramebufferInfo): Result {.
    importc: "GSPGPU_SetBufferSwap", header: "<3ds/services/gspgpu.h>".}
## *
##  @brief Flushes memory from the data cache.
##  @param adr Address to flush.
##  @param size Size of the memory to flush.
##

proc GSPGPU_FlushDataCache*(adr: pointer; size: u32): Result {.
    importc: "GSPGPU_FlushDataCache", header: "<3ds/services/gspgpu.h>".}
## *
##  @brief Invalidates memory in the data cache.
##  @param adr Address to invalidate.
##  @param size Size of the memory to invalidate.
##

proc GSPGPU_InvalidateDataCache*(adr: pointer; size: u32): Result {.
    importc: "GSPGPU_InvalidateDataCache", header: "<3ds/services/gspgpu.h>".}
## *
##  @brief Writes to GPU hardware registers.
##  @param regAddr Register address to write to.
##  @param data Data to write.
##  @param size Size of the data to write.
##

proc GSPGPU_WriteHWRegs*(regAddr: u32; data: ptr u32; size: u8): Result {.
    importc: "GSPGPU_WriteHWRegs", header: "<3ds/services/gspgpu.h>".}
## *
##  @brief Writes to GPU hardware registers with a mask.
##  @param regAddr Register address to write to.
##  @param data Data to write.
##  @param datasize Size of the data to write.
##  @param maskdata Data of the mask.
##  @param masksize Size of the mask.
##

proc GSPGPU_WriteHWRegsWithMask*(regAddr: u32; data: ptr u32; datasize: u8;
                                maskdata: ptr u32; masksize: u8): Result {.
    importc: "GSPGPU_WriteHWRegsWithMask", header: "<3ds/services/gspgpu.h>".}
## *
##  @brief Reads from GPU hardware registers.
##  @param regAddr Register address to read from.
##  @param data Buffer to read data to.
##  @param size Size of the buffer.
##

proc GSPGPU_ReadHWRegs*(regAddr: u32; data: ptr u32; size: u8): Result {.
    importc: "GSPGPU_ReadHWRegs", header: "<3ds/services/gspgpu.h>".}
## *
##  @brief Registers the interrupt relay queue.
##  @param eventHandle Handle of the GX command event.
##  @param flags Flags to register with.
##  @param outMemHandle Pointer to output the shared memory handle to.
##  @param threadID Pointer to output the GSP thread ID to.
##

proc GSPGPU_RegisterInterruptRelayQueue*(eventHandle: Handle; flags: u32;
                                        outMemHandle: ptr Handle; threadID: ptr u8): Result {.
    importc: "GSPGPU_RegisterInterruptRelayQueue", header: "<3ds/services/gspgpu.h>".}
## / Unregisters the interrupt relay queue.

proc GSPGPU_UnregisterInterruptRelayQueue*(): Result {.
    importc: "GSPGPU_UnregisterInterruptRelayQueue", header: "<3ds/services/gspgpu.h>".}
## / Triggers a handling of commands written to shared memory.

proc GSPGPU_TriggerCmdReqQueue*(): Result {.importc: "GSPGPU_TriggerCmdReqQueue",
    header: "<3ds/services/gspgpu.h>".}
## *
##  @brief Sets 3D_LEDSTATE to the input state value.
##  @param disable False = 3D LED enable, true = 3D LED disable.
##

proc GSPGPU_SetLedForceOff*(disable: bool): Result {.
    importc: "GSPGPU_SetLedForceOff", header: "<3ds/services/gspgpu.h>".}
