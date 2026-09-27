#ifndef MINES_H
#define MINES_H

#include <stdint.h>

#include "sim.h"

#define FIELD_WIDTH 20
#define FIELD_HEIGHT 20
#define CELL_SIZE 36

#define FIELD_OFFSET_X ((SIM_X_SIZE - FIELD_WIDTH * CELL_SIZE) / 2)
#define FIELD_OFFSET_Y ((SIM_Y_SIZE - FIELD_HEIGHT * CELL_SIZE) / 2)

#define MINE_PROBABILITY 10 // percent

#define CELL_TYPE_EMPTY 0
#define CELL_TYPE_MINE 1

#define CELL_STATE_IDLE 0
#define CELL_STATE_OPENED 1
#define CELL_STATE_MARKED 2
#define CELL_STATE_MINE 3

#ifndef __sim__
void app();
#endif // __sim__

#endif // MINES_H
