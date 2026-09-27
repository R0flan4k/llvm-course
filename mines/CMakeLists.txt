cmake_minimum_required(VERSION 3.16)
project(mines C)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()

find_package(SDL2 REQUIRED)

add_executable(mines lib/mines.c lib/sim.c lib/render.c)
target_include_directories(mines PRIVATE include)
target_link_libraries(mines PRIVATE SDL2::SDL2)

set(GEN_DIR ${CMAKE_BINARY_DIR})
set(SOURCES_DIR ${CMAKE_SOURCE_DIR}/lib)

# LLVM IR and bytecode generation (into build/Release)
add_custom_target(ir
  COMMAND clang -I${CMAKE_SOURCE_DIR}/include -emit-llvm -S ${SOURCES_DIR}/mines.c -o ${GEN_DIR}/mines.ll
  COMMAND clang -I${CMAKE_SOURCE_DIR}/include -emit-llvm -S ${SOURCES_DIR}/sim.c -o ${GEN_DIR}/sim.ll
  COMMAND clang -I${CMAKE_SOURCE_DIR}/include -emit-llvm -S ${SOURCES_DIR}/render.c -o ${GEN_DIR}/render.ll
  COMMAND llvm-link ${GEN_DIR}/mines.ll ${GEN_DIR}/sim.ll ${GEN_DIR}/render.ll -o ${GEN_DIR}/full.bc
  COMMENT "Generating LLVM IR into ${GEN_DIR}"
  USES_TERMINAL)

# Assembly generation (into build/Release)
add_custom_target(asm
  COMMAND clang -I${CMAKE_SOURCE_DIR}/include -S ${SOURCES_DIR}/mines.c -o ${GEN_DIR}/mines.s
  COMMAND clang -I${CMAKE_SOURCE_DIR}/include -S ${SOURCES_DIR}/sim.c -o ${GEN_DIR}/sim.s
  COMMAND clang -I${CMAKE_SOURCE_DIR}/include -S ${SOURCES_DIR}/render.c -o ${GEN_DIR}/render.s
  COMMENT "Generating assembly into ${GEN_DIR}"
  USES_TERMINAL)

add_custom_target(gen DEPENDS ir asm)

# Code formatting (LLVM style)
file(GLOB FORMAT_SOURCES CONFIGURE_DEPENDS lib/*.c include/*.h)
find_program(CLANG_FORMAT clang-format)
if(CLANG_FORMAT)
  add_custom_target(format
    COMMAND ${CLANG_FORMAT} -i -style=LLVM ${FORMAT_SOURCES}
    COMMENT "Formatting sources with clang-format (LLVM style)"
    USES_TERMINAL)
endif()