#include "render.h"
#include "sim.h"

#include <stdint.h>
#include <stdlib.h>

#define COLOR_IDLE 0xFFA0A0A0
#define COLOR_OPENED 0xFFC8C8C8
#define COLOR_GRID 0xFF505050
#define COLOR_MARK 0xFFFF2020
#define COLOR_MINE 0xFF000000

#define DIGIT_W 5
#define DIGIT_H 7
#define DIGIT_SCALE 2

static const int64_t DigitFont[10][DIGIT_H] = {
    {14, 17, 19, 21, 25, 17, 14}, // 0
    {4, 12, 4, 4, 4, 4, 14},      // 1
    {14, 17, 1, 2, 4, 8, 31},     // 2
    {31, 1, 2, 4, 2, 1, 31},      // 3
    {2, 6, 10, 18, 31, 2, 2},     // 4
    {31, 16, 16, 31, 1, 1, 31},   // 5
    {14, 16, 16, 30, 17, 17, 14}, // 6
    {31, 1, 2, 4, 4, 4, 4},       // 7
    {14, 17, 17, 14, 17, 17, 14}, // 8
    {14, 17, 17, 15, 1, 1, 14},   // 9
};

static const int64_t DigitColor[8] = {
    0xFF2020FF, // 1
    0xFF00AA00, // 2
    0xFFFF2020, // 3
    0xFF000080, // 4
    0xFF800000, // 5
    0xFF008080, // 6
    0xFF000000, // 7
    0xFF808080, // 8
};

static void fillRect(int64_t x0, int64_t y0, int64_t w, int64_t h,
                     int64_t argb) {
  for (int64_t y = y0; y < y0 + h; ++y)
    for (int64_t x = x0; x < x0 + w; ++x)
      simPutPixel(x, y, argb);
}

static void drawLine(int64_t x0, int64_t y0, int64_t x1, int64_t y1,
                     int64_t argb) {
  int64_t dx = llabs(x1 - x0);
  int64_t sx = x0 < x1 ? 1 : -1;
  int64_t dy = -llabs(y1 - y0);
  int64_t sy = y0 < y1 ? 1 : -1;
  int64_t err = dx + dy;
  while (1) {
    simPutPixel(x0, y0, argb);
    if (x0 == x1 && y0 == y1)
      break;
    int64_t e2 = 2 * err;
    if (e2 >= dy) {
      err += dy;
      x0 += sx;
    }
    if (e2 <= dx) {
      err += dx;
      y0 += sy;
    }
  }
}

static void fillCircle(int64_t cx, int64_t cy, int64_t r, int64_t argb) {
  for (int64_t dy = -r; dy <= r; ++dy)
    for (int64_t dx = -r; dx <= r; ++dx)
      if (dx * dx + dy * dy <= r * r)
        simPutPixel(cx + dx, cy + dy, argb);
}

static void drawGrid(void) {
  int64_t right = FIELD_OFFSET_X + FIELD_WIDTH * CELL_SIZE;
  int64_t bottom = FIELD_OFFSET_Y + FIELD_HEIGHT * CELL_SIZE;
  for (int64_t x = FIELD_OFFSET_X; x <= right; x += CELL_SIZE)
    for (int64_t y = 0; y < bottom; ++y)
      simPutPixel(x, y, COLOR_GRID);
  for (int64_t y = FIELD_OFFSET_Y; y <= bottom; y += CELL_SIZE)
    for (int64_t x = 0; x < right; ++x)
      simPutPixel(x, y, COLOR_GRID);
}

static void drawMarked(int64_t px, int64_t py) {
  int64_t m = 8;
  int64_t x0 = px + m, y0 = py + m;
  int64_t x1 = px + CELL_SIZE - m, y1 = py + CELL_SIZE - m;
  drawLine(x0, y0, x1, y1, COLOR_MARK);
  drawLine(x0 + 1, y0 + 1, x1 + 1, y1 + 1, COLOR_MARK);
  drawLine(x1, y0, x0, y1, COLOR_MARK);
  drawLine(x1 + 1, y0 + 1, x0 + 1, y1 + 1, COLOR_MARK);
}

static void drawDigit(int64_t digit, int64_t px, int64_t py, int64_t argb) {
  int64_t w = DIGIT_W * DIGIT_SCALE;
  int64_t h = DIGIT_H * DIGIT_SCALE;
  int64_t x0 = px + (CELL_SIZE - w) / 2;
  int64_t y0 = py + (CELL_SIZE - h) / 2;
  for (int64_t row = 0; row < DIGIT_H; ++row) {
    int64_t bits = DigitFont[digit][row];
    for (int64_t col = 0; col < DIGIT_W; ++col)
      if (bits & (1 << (DIGIT_W - 1 - col)))
        fillRect(x0 + col * DIGIT_SCALE, y0 + row * DIGIT_SCALE, DIGIT_SCALE,
                 DIGIT_SCALE, argb);
  }
}

static void drawOpened(int64_t neighbors, int64_t px, int64_t py) {
  if (neighbors > 0 && neighbors < 9)
    drawDigit(neighbors, px, py, DigitColor[neighbors - 1]);
}

static void drawMine(int64_t px, int64_t py) {
  fillCircle(px + CELL_SIZE / 2, py + CELL_SIZE / 2, CELL_SIZE / 4, COLOR_MINE);
}

void renderField(const int64_t state[FIELD_HEIGHT][FIELD_WIDTH],
                 const int64_t neighbors[FIELD_HEIGHT][FIELD_WIDTH]) {
  for (int64_t y = 0; y < FIELD_HEIGHT; ++y)
    for (int64_t x = 0; x < FIELD_WIDTH; ++x)
      fillRect(FIELD_OFFSET_X + x * CELL_SIZE, FIELD_OFFSET_Y + y * CELL_SIZE,
               CELL_SIZE, CELL_SIZE,
               state[y][x] == CELL_STATE_OPENED ? COLOR_OPENED : COLOR_IDLE);

  for (int64_t y = 0; y < FIELD_HEIGHT; ++y) {
    for (int64_t x = 0; x < FIELD_WIDTH; ++x) {
      int64_t px = FIELD_OFFSET_X + x * CELL_SIZE;
      int64_t py = FIELD_OFFSET_Y + y * CELL_SIZE;
      if (state[y][x] == CELL_STATE_MARKED) {
        drawMarked(px, py);
      } else if (state[y][x] == CELL_STATE_OPENED) {
        drawOpened(neighbors[y][x], px, py);
      } else if (state[y][x] == CELL_STATE_MINE) {
        drawMine(px, py);
      }
    }
  }

  drawGrid();
}