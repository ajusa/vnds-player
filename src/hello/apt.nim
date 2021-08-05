import types
## *
##  @file apt.h
##  @brief APT (Applet) service.
##

## *
##  @brief NS Application IDs.
##
##  Retrieved from http://3dbrew.org/wiki/NS_and_APT_Services#AppIDs
##

type
  NS_APPID* {.size: sizeof(cint).} = enum
    APPID_NONE = 0, APPID_HOMEMENU = 0x101, ## /< Home Menu
    APPID_CAMERA = 0x110,       ## /< Camera applet
    APPID_FRIENDS_LIST = 0x112, ## /< Friends List applet
    APPID_GAME_NOTES = 0x113,   ## /< Game Notes applet
    APPID_WEB = 0x114,          ## /< Internet Browser
    APPID_INSTRUCTION_MANUAL = 0x115, ## /< Instruction Manual applet
    APPID_NOTIFICATIONS = 0x116, ## /< Notifications applet
    APPID_MIIVERSE = 0x117,     ## /< Miiverse applet (olv)
    APPID_MIIVERSE_POSTING = 0x118, ## /< Miiverse posting applet (solv3)
    APPID_AMIIBO_SETTINGS = 0x119, ## /< Amiibo settings applet (cabinet)
    APPID_APPLICATION = 0x300,  ## /< Application
    APPID_ESHOP = 0x301,        ## /< eShop (tiger)
    APPID_SOFTWARE_KEYBOARD = 0x401, ## /< Software Keyboard
    APPID_APPLETED = 0x402,     ## /< appletEd
    APPID_PNOTE_AP = 0x404,     ## /< PNOTE_AP
    APPID_SNOTE_AP = 0x405,     ## /< SNOTE_AP
    APPID_ERROR = 0x406,        ## /< error
    APPID_MINT = 0x407,         ## /< mint
    APPID_EXTRAPAD = 0x408,     ## /< extrapad
    APPID_MEMOLIB = 0x409       ## /< memolib


## / APT applet position.

type
  APT_AppletPos* {.size: sizeof(cint).} = enum
    APTPOS_NONE = -1,           ## /< No position specified.
    APTPOS_APP = 0,             ## /< Application.
    APTPOS_APPLIB = 1,          ## /< Application library (?).
    APTPOS_SYS = 2,             ## /< System applet.
    APTPOS_SYSLIB = 3,          ## /< System library (?).
    APTPOS_RESIDENT = 4         ## /< Resident applet.
  APT_AppletAttr* = u8


discard "forward decl of PtmWakeEvents"
# proc aptMakeAppletAttr*(pos: APT_AppletPos; manualGpuRights: bool;
#                        manualDspRights: bool): APT_AppletAttr {.inline.} =
#   return (pos and 7) or (if manualGpuRights: BIT(3) else: 0) or
#       (if manualDspRights: BIT(4) else: 0)

## / APT query reply.

type
  APT_QueryReply* {.size: sizeof(cint).} = enum
    APTREPLY_REJECT = 0, APTREPLY_ACCEPT = 1, APTREPLY_LATER = 2


## / APT signals.

type
  APT_Signal* {.size: sizeof(cint).} = enum
    APTSIGNAL_NONE = 0,         ## /< No signal received.
    APTSIGNAL_HOMEBUTTON = 1,   ## /< HOME button pressed.
    APTSIGNAL_HOMEBUTTON2 = 2,  ## /< HOME button pressed (again?).
    APTSIGNAL_SLEEP_QUERY = 3,  ## /< Prepare to enter sleep mode.
    APTSIGNAL_SLEEP_CANCEL = 4, ## /< Triggered when ptm:s GetShellStatus() returns 5.
    APTSIGNAL_SLEEP_ENTER = 5,  ## /< Enter sleep mode.
    APTSIGNAL_SLEEP_WAKEUP = 6, ## /< Wake from sleep mode.
    APTSIGNAL_SHUTDOWN = 7,     ## /< Shutdown.
    APTSIGNAL_POWERBUTTON = 8,  ## /< POWER button pressed.
    APTSIGNAL_POWERBUTTON2 = 9, ## /< POWER button cleared (?).
    APTSIGNAL_TRY_SLEEP = 10,   ## /< System sleeping (?).
    APTSIGNAL_ORDERTOCLOSE = 11 ## /< Order to close (such as when an error happens?).


## / APT commands.

type
  APT_Command* {.size: sizeof(cint).} = enum
    APTCMD_NONE = 0,            ## /< No command received.
    APTCMD_WAKEUP = 1,          ## /< Applet should wake up.
    APTCMD_REQUEST = 2,         ## /< Source applet sent us a parameter.
    APTCMD_RESPONSE = 3,        ## /< Target applet replied to our parameter.
    APTCMD_EXIT = 4,            ## /< Exit (??)
    APTCMD_MESSAGE = 5,         ## /< Message (??)
    APTCMD_HOMEBUTTON_ONCE = 6, ## /< HOME button pressed once.
    APTCMD_HOMEBUTTON_TWICE = 7, ## /< HOME button pressed twice (double-pressed).
    APTCMD_DSP_SLEEP = 8,       ## /< DSP should sleep (manual DSP rights related?).
    APTCMD_DSP_WAKEUP = 9,      ## /< DSP should wake up (manual DSP rights related?).
    APTCMD_WAKEUP_EXIT = 10,    ## /< Applet wakes up due to a different applet exiting.
    APTCMD_WAKEUP_PAUSE = 11,   ## /< Applet wakes up after being paused through HOME menu.
    APTCMD_WAKEUP_CANCEL = 12,  ## /< Applet wakes up due to being cancelled.
    APTCMD_WAKEUP_CANCELALL = 13, ## /< Applet wakes up due to all applets being cancelled.
    APTCMD_WAKEUP_POWERBUTTON = 14, ## /< Applet wakes up due to POWER button being pressed (?).
    APTCMD_WAKEUP_JUMPTOHOME = 15, ## /< Applet wakes up and is instructed to jump to HOME menu (?).
    APTCMD_SYSAPPLET_REQUEST = 16, ## /< Request for sysapplet (?).
    APTCMD_WAKEUP_LAUNCHAPP = 17 ## /< Applet wakes up and is instructed to launch another applet (?).


## / APT capture buffer information.

type
  INNER_C_STRUCT_apt_112* {.importc: "aptCaptureBufInfo::no_name", header: "apt.h",
                           bycopy.} = object
    leftOffset* {.importc: "leftOffset".}: u32
    rightOffset* {.importc: "rightOffset".}: u32
    format* {.importc: "format".}: u32

  aptCaptureBufInfo* {.importc: "aptCaptureBufInfo", header: "apt.h", bycopy.} = object
    size* {.importc: "size".}: u32
    is3D* {.importc: "is3D".}: u32
    top* {.importc: "top".}: INNER_C_STRUCT_apt_112
    bottom* {.importc: "bottom".}: INNER_C_STRUCT_apt_112


## / APT hook types.

type
  APT_HookType* {.size: sizeof(cint).} = enum
    APTHOOK_ONSUSPEND = 0,      ## /< App suspended.
    APTHOOK_ONRESTORE,        ## /< App restored.
    APTHOOK_ONSLEEP,          ## /< App sleeping.
    APTHOOK_ONWAKEUP,         ## /< App waking up.
    APTHOOK_ONEXIT,           ## /< App exiting.
    APTHOOK_COUNT             ## /< Number of APT hook types.


## / APT hook function.

type
  aptHookFn* = proc (hook: APT_HookType; param: pointer)

## / APT hook cookie.

# type
#   aptHookCookie* {.importc: "aptHookCookie", header: "apt.h", bycopy.} = object
#     next* {.importc: "next".}: ptr tag_aptHookCookie ## /< Next cookie.
#     callback* {.importc: "callback".}: aptHookFn ## /< Hook callback.
#     param* {.importc: "param".}: pointer ## /< Callback parameter.


## / APT message callback.

type
  aptMessageCb* = proc (user: pointer; sender: NS_APPID; msg: pointer; msgsize: csize_t)

## / Initializes APT.

proc aptInit*(): Result {.importc: "aptInit", header: "apt.h".}
## / Exits APT.

proc aptExit*() {.importc: "aptExit", header: "apt.h".}
## *
##  @brief Sends an APT command through IPC, taking care of locking, opening and closing an APT session.
##  @param aptcmdbuf Pointer to command buffer (should have capacity for at least 16 words).
##

proc aptSendCommand*(aptcmdbuf: ptr u32): Result {.importc: "aptSendCommand",
    header: "apt.h".}
## / Returns true if the application is currently in the foreground.

proc aptIsActive*(): bool {.importc: "aptIsActive", header: "apt.h".}
## / Returns true if the system has told the application to close.

proc aptShouldClose*(): bool {.importc: "aptShouldClose", header: "apt.h".}
## / Returns true if the system can enter sleep mode while the application is active.

proc aptIsSleepAllowed*(): bool {.importc: "aptIsSleepAllowed", header: "apt.h".}
## / Configures whether the system can enter sleep mode while the application is active.

proc aptSetSleepAllowed*(allowed: bool) {.importc: "aptSetSleepAllowed",
                                       header: "apt.h".}
## / Handles incoming sleep mode requests.

proc aptHandleSleep*() {.importc: "aptHandleSleep", header: "apt.h".}
## / Returns true if the user can press the HOME button to jump back to the HOME menu while the application is active.

proc aptIsHomeAllowed*(): bool {.importc: "aptIsHomeAllowed", header: "apt.h".}
## / Configures whether the user can press the HOME button to jump back to the HOME menu while the application is active.

proc aptSetHomeAllowed*(allowed: bool) {.importc: "aptSetHomeAllowed",
                                      header: "apt.h".}
## / Returns true if the system requires the application to jump back to the HOME menu.

proc aptShouldJumpToHome*(): bool {.importc: "aptShouldJumpToHome", header: "apt.h".}
## / Returns true if there is an incoming HOME button press rejected by the policy set by \ref aptSetHomeAllowed (use this to show a "no HOME allowed" icon).

proc aptCheckHomePressRejected*(): bool {.importc: "aptCheckHomePressRejected",
                                       header: "apt.h".}
## / \deprecated Alias for \ref aptCheckHomePressRejected.

## !!!Ignored construct:  static inline DEPRECATED bool aptIsHomePressed ( void ) { return aptCheckHomePressRejected ( ) ; } / Jumps back to the HOME menu. void aptJumpToHomeMenu ( void ) ;
## Error: token expected: ; but got: [identifier]!!!

## / Handles incoming jump-to-HOME requests.

proc aptHandleJumpToHome*() {.inline.} =
  if aptShouldJumpToHome():
    aptJumpToHomeMenu()

## *
##  @brief Main function which handles sleep mode and HOME/power buttons - call this at the beginning of every frame.
##  @return true if the application should keep running, false otherwise (see \ref aptShouldClose).
##

proc aptMainLoop*(): bool {.importc: "aptMainLoop", header: "apt.h".}
## *
##  @brief Sets up an APT status hook.
##  @param cookie Hook cookie to use.
##  @param callback Function to call when APT's status changes.
##  @param param User-defined parameter to pass to the callback.
##

proc aptHook*(cookie: ptr aptHookCookie; callback: aptHookFn; param: pointer) {.
    importc: "aptHook", header: "apt.h".}
## *
##  @brief Removes an APT status hook.
##  @param cookie Hook cookie to remove.
##

proc aptUnhook*(cookie: ptr aptHookCookie) {.importc: "aptUnhook", header: "apt.h".}
## *
##  @brief Sets the function to be called when an APT message from another applet is received.
##  @param callback Callback function.
##  @param user User-defined data to be passed to the callback.
##

proc aptSetMessageCallback*(callback: aptMessageCb; user: pointer) {.
    importc: "aptSetMessageCallback", header: "apt.h".}
## *
##  @brief Launches a library applet.
##  @param appId ID of the applet to launch.
##  @param buf Input/output buffer that contains launch parameters on entry and result data on exit.
##  @param bufsize Size of the buffer.
##  @param handle Handle to pass to the library applet.
##

proc aptLaunchLibraryApplet*(appId: NS_APPID; buf: pointer; bufsize: csize_t;
                            handle: Handle) {.importc: "aptLaunchLibraryApplet",
    header: "apt.h".}
## / Clears the chainloader state.

proc aptClearChainloader*() {.importc: "aptClearChainloader", header: "apt.h".}
## *
##  @brief Configures the chainloader to launch a specific application.
##  @param programID ID of the program to chainload to.
##  @param mediatype Media type of the program to chainload to.
##

proc aptSetChainloader*(programID: u64; mediatype: u8) {.
    importc: "aptSetChainloader", header: "apt.h".}
## / Configures the chainloader to relaunch the current application (i.e. soft-reset)

proc aptSetChainloaderToSelf*() {.importc: "aptSetChainloaderToSelf",
                                header: "apt.h".}
## *
##  @brief Gets an APT lock handle.
##  @param flags Flags to use.
##  @param lockHandle Pointer to output the lock handle to.
##

proc APT_GetLockHandle*(flags: u16; lockHandle: ptr Handle): Result {.
    importc: "APT_GetLockHandle", header: "apt.h".}
## *
##  @brief Initializes an application's registration with APT.
##  @param appId ID of the application.
##  @param attr Attributes of the application.
##  @param signalEvent Pointer to output the signal event handle to.
##  @param resumeEvent Pointer to output the resume event handle to.
##

proc APT_Initialize*(appId: NS_APPID; attr: APT_AppletAttr; signalEvent: ptr Handle;
                    resumeEvent: ptr Handle): Result {.importc: "APT_Initialize",
    header: "apt.h".}
## *
##  @brief Terminates an application's registration with APT.
##  @param appID ID of the application.
##

proc APT_Finalize*(appId: NS_APPID): Result {.importc: "APT_Finalize", header: "apt.h".}
## / Asynchronously resets the hardware.

proc APT_HardwareResetAsync*(): Result {.importc: "APT_HardwareResetAsync",
                                      header: "apt.h".}
## *
##  @brief Enables APT.
##  @param attr Attributes of the application.
##

proc APT_Enable*(attr: APT_AppletAttr): Result {.importc: "APT_Enable",
    header: "apt.h".}
## *
##  @brief Gets applet management info.
##  @param inpos Requested applet position.
##  @param outpos Pointer to output the position of the current applet to.
##  @param req_appid Pointer to output the AppID of the applet at the requested position to.
##  @param menu_appid Pointer to output the HOME menu AppID to.
##  @param active_appid Pointer to output the AppID of the currently active applet to.
##

proc APT_GetAppletManInfo*(inpos: APT_AppletPos; outpos: ptr APT_AppletPos;
                          req_appid: ptr NS_APPID; menu_appid: ptr NS_APPID;
                          active_appid: ptr NS_APPID): Result {.
    importc: "APT_GetAppletManInfo", header: "apt.h".}
## *
##  @brief Gets the menu's app ID.
##  @return The menu's app ID.
##

proc aptGetMenuAppID*(): NS_APPID {.inline.} =
  var menu_appid: NS_APPID
  APT_GetAppletManInfo(APTPOS_NONE, nil, nil, addr(menu_appid), nil)
  return menu_appid

## *
##  @brief Gets an applet's information.
##  @param appID AppID of the applet.
##  @param pProgramID Pointer to output the program ID to.
##  @param pMediaType Pointer to output the media type to.
##  @param pRegistered Pointer to output the registration status to.
##  @param pLoadState Pointer to output the load state to.
##  @param pAttributes Pointer to output the applet atrributes to.
##

proc APT_GetAppletInfo*(appID: NS_APPID; pProgramID: ptr u64; pMediaType: ptr u8;
                       pRegistered: ptr bool; pLoadState: ptr bool;
                       pAttributes: ptr APT_AppletAttr): Result {.
    importc: "APT_GetAppletInfo", header: "apt.h".}
## *
##  @brief Gets an applet's program information.
##  @param id ID of the applet.
##  @param flags Flags to use when retreiving the information.
##  @param titleversion Pointer to output the applet's title version to.
##
##  Flags:
##  - 0x01: Use AM_ListTitles with NAND media type.
##  - 0x02: Use AM_ListTitles with SDMC media type.
##  - 0x04: Use AM_ListTitles with GAMECARD media type.
##  - 0x10: Input ID is an app ID. Must be set if 0x20 is not.
##  - 0x20: Input ID is a program ID. Must be set if 0x10 is not.
##  - 0x100: Sets program ID high to 0x00040000, else it is 0x00040010. Only used when 0x20 is set.
##

proc APT_GetAppletProgramInfo*(id: u32; flags: u32; titleversion: ptr u16): Result {.
    importc: "APT_GetAppletProgramInfo", header: "apt.h".}
## *
##  @brief Gets the current application's program ID.
##  @param pProgramID Pointer to output the program ID to.
##

proc APT_GetProgramID*(pProgramID: ptr u64): Result {.importc: "APT_GetProgramID",
    header: "apt.h".}
## / Prepares to jump to the home menu.

proc APT_PrepareToJumpToHomeMenu*(): Result {.
    importc: "APT_PrepareToJumpToHomeMenu", header: "apt.h".}
## *
##  @brief Jumps to the home menu.
##  @param param Parameters to jump with.
##  @param Size of the parameter buffer.
##  @param handle Handle to pass.
##

proc APT_JumpToHomeMenu*(param: pointer; paramSize: csize_t; handle: Handle): Result {.
    importc: "APT_JumpToHomeMenu", header: "apt.h".}
## *
##  @brief Prepares to jump to an application.
##  @param exiting Specifies whether the applet is exiting.
##

proc APT_PrepareToJumpToApplication*(exiting: bool): Result {.
    importc: "APT_PrepareToJumpToApplication", header: "apt.h".}
## *
##  @brief Jumps to an application.
##  @param param Parameters to jump with.
##  @param Size of the parameter buffer.
##  @param handle Handle to pass.
##

proc APT_JumpToApplication*(param: pointer; paramSize: csize_t; handle: Handle): Result {.
    importc: "APT_JumpToApplication", header: "apt.h".}
## *
##  @brief Gets whether an application is registered.
##  @param appID ID of the application.
##  @param out Pointer to output the registration state to.
##

proc APT_IsRegistered*(appID: NS_APPID; `out`: ptr bool): Result {.
    importc: "APT_IsRegistered", header: "apt.h".}
## *
##  @brief Inquires as to whether a signal has been received.
##  @param appID ID of the application.
##  @param signalType Pointer to output the signal type to.
##

proc APT_InquireNotification*(appID: u32; signalType: ptr APT_Signal): Result {.
    importc: "APT_InquireNotification", header: "apt.h".}
## *
##  @brief Requests to enter sleep mode, and later sets wake events if allowed to.
##  @param wakeEvents The wake events. Limited to "shell" (bit 1) for the PDN wake events part
##  and "shell opened", "shell closed" and "HOME button pressed" for the MCU interrupts part.
##

proc APT_SleepSystem*(wakeEvents: ptr PtmWakeEvents): Result {.
    importc: "APT_SleepSystem", header: "apt.h".}
## *
##  @brief Notifies an application to wait.
##  @param appID ID of the application.
##

proc APT_NotifyToWait*(appID: NS_APPID): Result {.importc: "APT_NotifyToWait",
    header: "apt.h".}
## *
##  @brief Calls an applet utility function.
##  @param id Utility function to call.
##  @param out Pointer to write output data to.
##  @param outSize Size of the output buffer.
##  @param in Pointer to the input data.
##  @param inSize Size of the input buffer.
##

proc APT_AppletUtility*(id: cint; `out`: pointer; outSize: csize_t; `in`: pointer;
                       inSize: csize_t): Result {.importc: "APT_AppletUtility",
    header: "apt.h".}
## / Sleeps if shell is closed (?).

proc APT_SleepIfShellClosed*(): Result {.importc: "APT_SleepIfShellClosed",
                                      header: "apt.h".}
## *
##  @brief Locks a transition (?).
##  @param transition Transition ID.
##  @param flag Flag (?)
##

proc APT_LockTransition*(transition: u32; flag: bool): Result {.
    importc: "APT_LockTransition", header: "apt.h".}
## *
##  @brief Tries to lock a transition (?).
##  @param transition Transition ID.
##  @param succeeded Pointer to output whether the lock was successfully applied.
##

proc APT_TryLockTransition*(transition: u32; succeeded: ptr bool): Result {.
    importc: "APT_TryLockTransition", header: "apt.h".}
## *
##  @brief Unlocks a transition (?).
##  @param transition Transition ID.
##

proc APT_UnlockTransition*(transition: u32): Result {.
    importc: "APT_UnlockTransition", header: "apt.h".}
## *
##  @brief Glances at a receieved parameter without removing it from the queue.
##  @param appID AppID of the application.
##  @param buffer Buffer to receive to.
##  @param bufferSize Size of the buffer.
##  @param sender Pointer to output the sender's AppID to.
##  @param command Pointer to output the command ID to.
##  @param actualSize Pointer to output the actual received data size to.
##  @param parameter Pointer to output the parameter handle to.
##

proc APT_GlanceParameter*(appID: NS_APPID; buffer: pointer; bufferSize: csize_t;
                         sender: ptr NS_APPID; command: ptr APT_Command;
                         actualSize: ptr csize_t; parameter: ptr Handle): Result {.
    importc: "APT_GlanceParameter", header: "apt.h".}
## *
##  @brief Receives a parameter.
##  @param appID AppID of the application.
##  @param buffer Buffer to receive to.
##  @param bufferSize Size of the buffer.
##  @param sender Pointer to output the sender's AppID to.
##  @param command Pointer to output the command ID to.
##  @param actualSize Pointer to output the actual received data size to.
##  @param parameter Pointer to output the parameter handle to.
##

proc APT_ReceiveParameter*(appID: NS_APPID; buffer: pointer; bufferSize: csize_t;
                          sender: ptr NS_APPID; command: ptr APT_Command;
                          actualSize: ptr csize_t; parameter: ptr Handle): Result {.
    importc: "APT_ReceiveParameter", header: "apt.h".}
## *
##  @brief Sends a parameter.
##  @param source AppID of the source application.
##  @param dest AppID of the destination application.
##  @param command Command to send.
##  @param buffer Buffer to send.
##  @param bufferSize Size of the buffer.
##  @param parameter Parameter handle to pass.
##

proc APT_SendParameter*(source: NS_APPID; dest: NS_APPID; command: APT_Command;
                       buffer: pointer; bufferSize: u32; parameter: Handle): Result {.
    importc: "APT_SendParameter", header: "apt.h".}
## *
##  @brief Cancels a parameter which matches the specified source and dest AppIDs.
##  @param source AppID of the source application (use APPID_NONE to disable the check).
##  @param dest AppID of the destination application (use APPID_NONE to disable the check).
##  @param success Pointer to output true if a parameter was cancelled, or false otherwise.
##

proc APT_CancelParameter*(source: NS_APPID; dest: NS_APPID; success: ptr bool): Result {.
    importc: "APT_CancelParameter", header: "apt.h".}
## *
##  @brief Sends capture buffer information.
##  @param captureBuf Capture buffer information to send.
##

proc APT_SendCaptureBufferInfo*(captureBuf: ptr aptCaptureBufInfo): Result {.
    importc: "APT_SendCaptureBufferInfo", header: "apt.h".}
## *
##  @brief Replies to a sleep query.
##  @param appID ID of the application.
##  @param reply Query reply value.
##

proc APT_ReplySleepQuery*(appID: NS_APPID; reply: APT_QueryReply): Result {.
    importc: "APT_ReplySleepQuery", header: "apt.h".}
## *
##  @brief Replies that a sleep notification has been completed.
##  @param appID ID of the application.
##

proc APT_ReplySleepNotificationComplete*(appID: NS_APPID): Result {.
    importc: "APT_ReplySleepNotificationComplete", header: "apt.h".}
## *
##  @brief Prepares to close the application.
##  @param cancelPreload Whether applet preloads should be cancelled.
##

proc APT_PrepareToCloseApplication*(cancelPreload: bool): Result {.
    importc: "APT_PrepareToCloseApplication", header: "apt.h".}
## *
##  @brief Closes the application.
##  @param param Parameters to close with.
##  @param paramSize Size of param.
##  @param handle Handle to pass.
##

proc APT_CloseApplication*(param: pointer; paramSize: csize_t; handle: Handle): Result {.
    importc: "APT_CloseApplication", header: "apt.h".}
## *
##  @brief Sets the application's CPU time limit.
##  @param percent CPU time limit percentage to set.
##

proc APT_SetAppCpuTimeLimit*(percent: u32): Result {.
    importc: "APT_SetAppCpuTimeLimit", header: "apt.h".}
## *
##  @brief Gets the application's CPU time limit.
##  @param percent Pointer to output the CPU time limit percentage to.
##

proc APT_GetAppCpuTimeLimit*(percent: ptr u32): Result {.
    importc: "APT_GetAppCpuTimeLimit", header: "apt.h".}
## *
##  @brief Checks whether the system is a New 3DS.
##  @param out Pointer to write the New 3DS flag to.
##

proc APT_CheckNew3DS*(`out`: ptr bool): Result {.importc: "APT_CheckNew3DS",
    header: "apt.h".}
## *
##  @brief Prepares for an applicaton jump.
##  @param flags Flags to use.
##  @param programID ID of the program to jump to.
##  @param mediatype Media type of the program to jump to.
##

proc APT_PrepareToDoApplicationJump*(flags: u8; programID: u64; mediatype: u8): Result {.
    importc: "APT_PrepareToDoApplicationJump", header: "apt.h".}
## *
##  @brief Performs an application jump.
##  @param param Parameter buffer.
##  @param paramSize Size of parameter buffer.
##  @param hmac HMAC buffer (should be 0x20 bytes long).
##

proc APT_DoApplicationJump*(param: pointer; paramSize: csize_t; hmac: pointer): Result {.
    importc: "APT_DoApplicationJump", header: "apt.h".}
## *
##  @brief Prepares to start a library applet.
##  @param appID AppID of the applet to start.
##

proc APT_PrepareToStartLibraryApplet*(appID: NS_APPID): Result {.
    importc: "APT_PrepareToStartLibraryApplet", header: "apt.h".}
## *
##  @brief Starts a library applet.
##  @param appID AppID of the applet to launch.
##  @param param Buffer containing applet parameters.
##  @param paramsize Size of the buffer.
##  @param handle Handle to pass to the applet.
##

proc APT_StartLibraryApplet*(appID: NS_APPID; param: pointer; paramSize: csize_t;
                            handle: Handle): Result {.
    importc: "APT_StartLibraryApplet", header: "apt.h".}
## *
##  @brief Prepares to start a system applet.
##  @param appID AppID of the applet to start.
##

proc APT_PrepareToStartSystemApplet*(appID: NS_APPID): Result {.
    importc: "APT_PrepareToStartSystemApplet", header: "apt.h".}
## *
##  @brief Starts a system applet.
##  @param appID AppID of the applet to launch.
##  @param param Buffer containing applet parameters.
##  @param paramSize Size of the parameter buffer.
##  @param handle Handle to pass to the applet.
##

proc APT_StartSystemApplet*(appID: NS_APPID; param: pointer; paramSize: csize_t;
                           handle: Handle): Result {.
    importc: "APT_StartSystemApplet", header: "apt.h".}
## *
##  @brief Retrieves the shared system font.
##  @brief fontHandle Pointer to write the handle of the system font memory block to.
##  @brief mapAddr Pointer to write the mapping address of the system font memory block to.
##

proc APT_GetSharedFont*(fontHandle: ptr Handle; mapAddr: ptr u32): Result {.
    importc: "APT_GetSharedFont", header: "apt.h".}
## *
##  @brief Receives the deliver (launch) argument
##  @param param Parameter buffer.
##  @param paramSize Size of parameter buffer.
##  @param hmac HMAC buffer (should be 0x20 bytes long).
##  @param sender Pointer to output the sender's AppID to.
##  @param received Pointer to output whether an argument was received to.
##

proc APT_ReceiveDeliverArg*(param: pointer; paramSize: csize_t; hmac: pointer;
                           sender: ptr u64; received: ptr bool): Result {.
    importc: "APT_ReceiveDeliverArg", header: "apt.h".}
