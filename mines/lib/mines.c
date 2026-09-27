#include "mines.h"
#include "render.h"
#include "sim.h"

#include <stdint.h>

static int64_t FieldType[FIELD_HEIGHT][FIELD_WIDTH];
static int64_t FieldState[FIELD_HEIGHT][FIELD_WIDTH];
static int64_t FieldNeighbors[FIELD_HEIGHT][FIELD_WIDTH];

static int64_t GameOver = 0;

static void generateField(void) {
  for (int64_t y = 0; y < FIELD_HEIGHT; ++y) {
    for (int64_t x = 0; x < FIELD_WIDTH; ++x) {
      FieldType[y][x] = (simRand() % 100) < MINE_PROBABILITY ? CELL_TYPE_MINE
                                                             : CELL_TYPE_EMPTY;
      FieldState[y][x] = CELL_STATE_IDLE;
      FieldNeighbors[y][x] = 0;
    }
  }
}

static int64_t countNeighbors(int64_t cx, int64_t cy) {
  int64_t count = 0;
  for (int64_t dy = -1; dy <= 1; ++dy) {
    for (int64_t dx = -1; dx <= 1; ++dx) {
      if (dx == 0 && dy == 0)
        continue;
      int64_t x = cx + dx;
      int64_t y = cy + dy;
      if (0 <= x && x < FIELD_WIDTH && 0 <= y && y < FIELD_HEIGHT &&
          FieldType[y][x] == CELL_TYPE_MINE)
        ++count;
    }
  }
  return count;
}

static void openCell(int64_t x, int64_t y) {
  if (FieldState[y][x] != CELL_STATE_IDLE)
    return;
  if (FieldType[y][x] == CELL_TYPE_MINE) {
    FieldState[y][x] = CELL_STATE_MINE;
    GameOver = 1;
    return;
  }
  FieldState[y][x] = CELL_STATE_OPENED;
  FieldNeighbors[y][x] = countNeighbors(x, y);
  if (FieldNeighbors[y][x] == 0) {
    for (int64_t dy = -1; dy <= 1; ++dy) {
      for (int64_t dx = -1; dx <= 1; ++dx) {
        if (dx == 0 && dy == 0)
          continue;
        int64_t nx = x + dx;
        int64_t ny = y + dy;
        if (0 <= nx && nx < FIELD_WIDTH && 0 <= ny && ny < FIELD_HEIGHT)
          openCell(nx, ny);
      }
    }
  }
}

static void handleClick(void) {
  if (GameOver)
    return;
  int64_t x, y;
  int64_t click = simPollClick(&x, &y);
  if (click == 0)
    return;
  int64_t cx = (x - FIELD_OFFSET_X) / CELL_SIZE;
  int64_t cy = (y - FIELD_OFFSET_Y) / CELL_SIZE;
  if (cx < 0 || cx >= FIELD_WIDTH || cy < 0 || cy >= FIELD_HEIGHT)
    return;

  if (click == SIM_CLICK_LEFT) {
    if (FieldState[cy][cx] == CELL_STATE_IDLE)
      openCell(cx, cy);
  } else if (click == SIM_CLICK_RIGHT) {
    if (FieldState[cy][cx] == CELL_STATE_IDLE)
      FieldState[cy][cx] = CELL_STATE_MARKED;
    else if (FieldState[cy][cx] == CELL_STATE_MARKED)
      FieldState[cy][cx] = CELL_STATE_IDLE;
  }
}

void app(void) {
  generateField();
  while (1) {
    if (simHasQuit()) {
      simExit();
      return;
    }
    handleClick();
    renderField(FieldState, FieldNeighbors);
    simFlush();
  }
}

int main(void) {
  simInit();
  app();
  return 0;
}