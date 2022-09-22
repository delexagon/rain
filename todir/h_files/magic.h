#ifndef __magic_h__
#define __magic_h__
#include "tiles.h"
typedef struct Magic Magic;
struct Magic;
Magic* new__Magic(Tile* t, char dir);
void update__Magic(void* p);
#endif