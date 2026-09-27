# Mines

A Minesweeper game written in C using SDL2.

## Disclaimer

This code is intentionally written very roughly. It is not a real product: its
only purpose is to simplify the frontend of the LLVM course project and to serve
as a simple test bed for LLVM IR generation. Barely any quality bar is applied.

## Build (with Conan)

    conan install . --build=missing
    cmake --preset conan-release
    cmake --build --preset conan-release

Run:

    ./build/Release/mines

## Build (without Conan)

Make sure `libsdl2-dev` is installed, then:

    cmake -S . -B build/Release -DCMAKE_BUILD_TYPE=Release
    cmake --build build/Release

## Extra targets

- `cmake --build build/Release --target gen` — generate LLVM IR (`*.ll`, `full.bc`) and assembly (`*.s`) into `build/Release`
- `cmake --build build/Release --target format` — format sources with clang-format (LLVM style)