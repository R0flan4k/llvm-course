#ifndef SIM_H
#define SIM_H

#include <stdint.h>

#define SIM_X_SIZE 1536 // 512
#define SIM_Y_SIZE 768  // 256

#define SIM_CLICK_LEFT 1
#define SIM_CLICK_RIGHT 2

#ifndef __sim__
void simInit();
void app();
void simExit();
void simFlush();
void simPutPixel(int64_t x, int64_t y, int64_t argb);
int64_t simRand();
int64_t simHasClick();
int64_t simGetClick();
int64_t simGetRightClick();
int64_t simPollClick(int64_t *x, int64_t *y);
int64_t simHasQuit();
#endif // __sim__

#endif // SIM_H