#ifndef __you_h__
#define __you_h__
#include "tiles.h"
typedef struct You You;
struct You;
You* new__You(Tile* t);
void update__You(void* obj);
#endif