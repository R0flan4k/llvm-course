# LogPass

Instrumenting LLVM pass that collects a runtime trace of IR instruction
uses (`User <- Operand`) for the logical module of the mines application
(`lib/mines.c`) compiled with `-O2`.

Based on the lecture example
https://github.com/lisitsynSA/llvm_course/tree/main/LLVM_Pass 

## What it does

  For every instruction use, a call to the runtime `useLogger` (see `log.c`)
  is inserted **before** the user instruction, recording the opcode pair
  `user <- operand`.

## Build & run 

    cmake -S . -B build/Release
    cmake --build build/Release --target plugin   # libLogPass.so
    cmake --build build/Release --target trace    # build instrumented app only
    cmake --build build/Release --target stats    # analyze trace -> stats.txt

`stats` depends on `trace` which depends on `plugin`.

Collecting the trace:

1. `cmake --build LogPass/build --target trace` builds `build/mines_logged`
   (mines.c instrumented at `-O2`, linked with the runtime logger).
2. Run it: `./build/mines_logged`.
3. Close the window: `log.c` dumps `trace.txt` into `LogPass/` on exit
4. `cmake --build LogPass/build --target stats` writes `stats.txt`.


