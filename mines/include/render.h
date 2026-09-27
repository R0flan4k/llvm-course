#ifndef RENDER_H
#define RENDER_H

#include <stdint.h>

#include "mines.h"

void renderField(const int64_t state[FIELD_HEIGHT][FIELD_WIDTH],
                 const int64_t neighbors[FIELD_HEIGHT][FIELD_WIDTH]);

#endif // RENDER_H