import hid
export hid
{.push header: "<3ds.h>".}
# proc gfxInitDefault*()
proc aptMainLoop*(): bool
# proc gfxExit*()
proc hidScanInput*()
proc hidKeysDown*(): set[Key]
{.pop.}

import console
export console
import gspgpu
export gspgpu
import gfx
export gfx
