#include "sim.h"
#include <SDL2/SDL.h>
#include <SDL2/SDL_events.h>
#include <assert.h>
#include <stdlib.h>
#include <time.h>

#define FRAME_TICKS 30

static SDL_Renderer *Renderer = NULL;
static SDL_Window *Window = NULL;
static Uint32 Ticks = 0;

void simInit() {
  SDL_Init(SDL_INIT_VIDEO);
  SDL_CreateWindowAndRenderer(SIM_X_SIZE, SIM_Y_SIZE, 0, &Window, &Renderer);
  SDL_SetRenderDrawColor(Renderer, 0, 0, 0, 0);
  SDL_RenderClear(Renderer);
  srand((unsigned int)time(NULL));
  simPutPixel(0, 0, 0);
  simFlush();
}

void simExit() {
  SDL_Event event;
  while (1) {
    if (SDL_PollEvent(&event) && event.type == SDL_QUIT)
      break;
  }
  SDL_DestroyRenderer(Renderer);
  SDL_DestroyWindow(Window);
  SDL_Quit();
}

void simFlush() {
  SDL_PumpEvents();
  Uint32 cur_ticks = SDL_GetTicks() - Ticks;
  if (cur_ticks < FRAME_TICKS) {
    // SDL_Delay(FRAME_TICKS - cur_ticks);
  }
  SDL_RenderPresent(Renderer);
}

void simPutPixel(int64_t x, int64_t y, int64_t argb) {
  assert(0 <= x && x < SIM_X_SIZE && "Out of range");
  assert(0 <= y && y < SIM_Y_SIZE && "Out of range");
  Uint8 a = (Uint8)(argb >> 24);
  Uint8 r = (Uint8)((argb >> 16) & 0xFF);
  Uint8 g = (Uint8)((argb >> 8) & 0xFF);
  Uint8 b = (Uint8)(argb & 0xFF);
  SDL_SetRenderDrawColor(Renderer, r, g, b, a);
  SDL_RenderDrawPoint(Renderer, (int)x, (int)y);
  Ticks = SDL_GetTicks();
}

int64_t simRand() { return (int64_t)rand(); }

int64_t simHasClick() {
  SDL_PumpEvents();
  return SDL_TRUE == SDL_HasEvent(SDL_MOUSEBUTTONDOWN);
}

int64_t simHasQuit() {
  SDL_PumpEvents();
  return SDL_TRUE == SDL_HasEvent(SDL_QUIT);
}

static int64_t getClick(Uint8 button) {
  while (1) {
    SDL_PumpEvents();
    SDL_Event event;
    while (SDL_PollEvent(&event)) {
      if (event.type == SDL_MOUSEBUTTONDOWN && event.button.button == button) {
        int64_t xy = ((int64_t)event.button.x << 16) +
                     (int64_t)(event.button.y & 0xFFFF);
        SDL_FlushEvent(SDL_MOUSEBUTTONDOWN);
        return xy;
      }
    }
  }
}

int64_t simGetClick() { return getClick(SDL_BUTTON_LEFT); }

int64_t simGetRightClick() { return getClick(SDL_BUTTON_RIGHT); }

int64_t simPollClick(int64_t *x, int64_t *y) {
  SDL_PumpEvents();
  SDL_Event event;
  while (SDL_PollEvent(&event)) {
    if (event.type == SDL_MOUSEBUTTONDOWN) {
      if (event.button.button == SDL_BUTTON_LEFT) {
        *x = event.button.x;
        *y = event.button.y;
        SDL_FlushEvent(SDL_MOUSEBUTTONDOWN);
        return SIM_CLICK_LEFT;
      }
      if (event.button.button == SDL_BUTTON_RIGHT) {
        *x = event.button.x;
        *y = event.button.y;
        SDL_FlushEvent(SDL_MOUSEBUTTONDOWN);
        return SIM_CLICK_RIGHT;
      }
    }
  }
  return 0;
}