#ifndef __make_tiles_h__
#define __make_tiles_h__
#include "runner.h"
#include "tiles.h"
Tile** make_room(int height, int width, Runner* cleaner);
Tile* make_hallway(Tile* tile1, char gate1, Tile* tile2, char gate2, Runner* cleaner);
#endif