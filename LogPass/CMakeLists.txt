cmake_minimum_required(VERSION 3.16)
project(LogPass)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

find_program(LLVM_CONFIG llvm-config REQUIRED)
find_program(CLANG clang REQUIRED)
find_program(CLANGXX clang++ REQUIRED)
find_program(PYTHON3 python3 REQUIRED)

execute_process(COMMAND ${LLVM_CONFIG} --includedir
                OUTPUT_VARIABLE LLVM_INCLUDE_DIR
                OUTPUT_STRIP_TRAILING_WHITESPACE)

set(LOG_DIR ${CMAKE_SOURCE_DIR})
set(MINES_DIR ${CMAKE_SOURCE_DIR}/../mines)
set(GEN_DIR ${CMAKE_BINARY_DIR})

# Build the instrumenting pass as a clang plugin (like the mines 'ir' target)
add_custom_target(plugin
  COMMAND ${CLANGXX} -O2 -fPIC -shared -std=c++17 -I${LLVM_INCLUDE_DIR}
          ${LOG_DIR}/LogPass.cpp -o ${GEN_DIR}/libLogPass.so
  COMMENT "Building LogPass plugin libLogPass.so"
  USES_TERMINAL)

# Compile mines.c with the plugin and link the instrumented app
# with the runtime logger.
add_custom_target(trace DEPENDS plugin
  COMMAND ${CLANG} -O2 -fpass-plugin=${GEN_DIR}/libLogPass.so
          -I${MINES_DIR}/include -c ${MINES_DIR}/lib/mines.c
          -o ${GEN_DIR}/mines_instr.o
  COMMAND ${CLANG} -O2 -I${MINES_DIR}/include -c ${MINES_DIR}/lib/sim.c
          -o ${GEN_DIR}/sim.o
  COMMAND ${CLANG} -O2 -I${MINES_DIR}/include -c ${MINES_DIR}/lib/render.c
          -o ${GEN_DIR}/render.o
  COMMAND ${CLANG} ${GEN_DIR}/mines_instr.o ${GEN_DIR}/sim.o ${GEN_DIR}/render.o
          ${LOG_DIR}/log.c -lSDL2 -o ${GEN_DIR}/mines_logged
  WORKING_DIRECTORY ${LOG_DIR}
  COMMENT "Building instrumented mines app (build/mines_logged)"
  USES_TERMINAL)

# Analyze the trace: frequent patterns with window 1..5 -> stats.txt
add_custom_target(stats DEPENDS trace
  COMMAND ${PYTHON3} ${LOG_DIR}/analyze.py ${LOG_DIR}/trace.txt ${LOG_DIR}/stats.txt
  WORKING_DIRECTORY ${LOG_DIR}
  COMMENT "Analyzing trace patterns (window 1..5) into stats.txt"
  USES_TERMINAL)