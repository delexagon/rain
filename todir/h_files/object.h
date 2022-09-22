#ifndef __object_h__
#define __object_h__
#include "term.h"
#include "tiles.h"
typedef struct Object Object;
struct Object;
Object* new__Object(Tile* t, char chr);
Tile* tile__Object(Object* self);
int move__Object(Object* self, char direction);
void vision__Object(Object* self);
#endif