type 
  Key* {.size: sizeof(uint32).} = enum
    KEY_A = 0               ## /< A
    KEY_B = 1               ## /< B
    KEY_SELECT = 2          ## /< Select
    KEY_START = 3           ## /< Start
    KEY_DRIGHT = 4          ## /< D-Pad Right
    KEY_DLEFT = 5           ## /< D-Pad Left
    KEY_DUP = 6             ## /< D-Pad Up
    KEY_DDOWN = 7           ## /< D-Pad Down
    KEY_R = 8               ## /< R
    KEY_L = 9               ## /< L
    KEY_X = 10              ## /< X
    KEY_Y = 11              ## /< Y
    KEY_ZL = 14             ## /< ZL (New 3DS only)
    KEY_ZR = 15             ## /< ZR (New 3DS only)
    KEY_TOUCH = 20          ## /< Touch (Not actually provided by HID)
    KEY_CSTICK_RIGHT = 24   ## /< C-Stick Right (New 3DS only)
    KEY_CSTICK_LEFT = 25    ## /< C-Stick Left (New 3DS only)
    KEY_CSTICK_UP = 26      ## /< C-Stick Up (New 3DS only)
    KEY_CSTICK_DOWN = 27    ## /< C-Stick Down (New 3DS only)
    KEY_CPAD_RIGHT = 28     ## /< Circle Pad Right
    KEY_CPAD_LEFT = 29      ## /< Circle Pad Left
    KEY_CPAD_UP = 30        ## /< Circle Pad Up
    KEY_CPAD_DOWN = 31      ## /< Circle Pad Down
const
  KEY_DOWN* = {KEY_DDOWN, KEY_CPAD_DOWN}
  KEY_LEFT* = {KEY_DLEFT, KEY_CPAD_LEFT} ## /< D-Pad Left or Circle Pad Left
  KEY_RIGHT* = {KEY_DRIGHT, KEY_CPAD_RIGHT} ## /< D-Pad Right or Circle Pad Right
  KEY_UP* = {KEY_DUP, KEY_CPAD_UP}

