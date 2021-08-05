import strformat, os
const name = "hello"
let devkitPro = getEnv("DEVKITPRO")
let devkitArm = getEnv("DEVKITARM")
let libctru = devkitPro & "/libctru"
let libs = "-lctru -lm"
let arch = "-march=armv6k -mtune=mpcore -mfloat-abi=hard -mtp=soft"
let specs = &"-specs={devkitArm}/arm-none-eabi/lib/3dsx.specs"
let ldflags = "{libs} {specs} -g {arch} -Wl,-Map,{name}.map".fmt
let cflags = &"-g -Wall -O3 -mword-relocations -ffunction-sections {arch} -DARM11 -D_3DS"
# LDFLAGS	=	-specs=3dsx.specs -g $(ARCH) -Wl,-Map,$(notdir $*.map)
put "arm.android.gcc.path", "/opt/devkitpro/devkitARM/bin"
put "arm.android.gcc.exe", "arm-none-eabi-gcc"
put "arm.android.gcc.linkerexe", "arm-none-eabi-gcc"
put "arm.android.gcc.options.linker", ldflags
put "arm.android.gcc.options.always", cflags
# noMain
# noLinking
# header = "output.h"
switch "cpu", "arm"
switch "os", "android"
switch "out", name & ".elf"
# --debugger:native
switch "define", "useMalloc"
switch "define", "danger"
switch "header"
switch "nimCache", "nimcache"  # output C sources to local directory
switch "cincludes", libctru/"include"
switch "cincludes", devkitArm/"arm-none-eabi/include"
switch "cincludes", projectDir()/"nimcache"
switch "clibdir", libctru/"lib"
switch "gc", "arc"
switch "define", "lto"

# -d:useMalloc
# -d:danger
# -d:lto
# gc = "arc"
# --passC="-DARM11 -D_3DS"
# --passC="-g -Wall -O2 -mword-relocations -ffunction-sections"
# --passC="-specs=3dsx.specs -g -march=armv6k -mtune=mpcore -mfloat-abi=hard -mtp=soft -Wl,-Map,3dsfun.map   -L/opt/devkitpro/libctru/lib -lctru -lm"
task build, "builds 3dsx file":
  selfExec "c main.nim".fmt
  exec "{devkitPro}/tools/bin/3dsxtool {name}.elf {name}.3dsx".fmt

task emulate, "builds 3dsx file and runs in citra":
  buildTask()
  exec "citra {name}.3dsx".fmt

