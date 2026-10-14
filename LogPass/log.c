#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define TRACE_CAPACITY 2000000

static char *TraceUser[TRACE_CAPACITY];
static char *TraceOperand[TRACE_CAPACITY];
static int64_t TraceCount = 0;
static int64_t DumpRegistered = 0;

static void dumpTrace(void) {
  FILE *f = fopen("trace.txt", "w");
  if (f == NULL) {
    fprintf(stderr, "[LOG] cannot open trace.txt\n");
    return;
  }
  for (int64_t i = 0; i < TraceCount; ++i)
    fprintf(f, "%s <- %s\n", TraceUser[i], TraceOperand[i]);
  fclose(f);
  fprintf(stderr, "[LOG] trace dumped: %lld records\n", (long long)TraceCount);
}

void useLogger(char *userName, char *operandName) {
  if (!DumpRegistered) {
    atexit(dumpTrace);
    DumpRegistered = 1;
  }
  if (TraceCount >= TRACE_CAPACITY)
    return;
  TraceUser[TraceCount] = userName;
  TraceOperand[TraceCount] = operandName;
  ++TraceCount;
  if (TraceCount == TRACE_CAPACITY) {
    fprintf(stderr, "[LOG] trace buffer full\n");
    dumpTrace();
  }
}