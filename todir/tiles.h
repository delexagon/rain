#ifndef __tiles_h__
#define __tiles_h__
#include "tiledata.h"
#include "runner.h"
typedef unsigned char uchar;
typedef struct Edge Edge;
typedef struct Tile Tile;
typedef struct Traverser Traverser;
struct Edge;
struct Tile;
void print__Tile(Tile* self);
struct Traverser {
    Tile* tile;
    uchar ab_is_lr;
    uchar ud_flipped;
    uchar lr_flipped;
};
void free__Tile(void* t);
Tile* new__Tile(Runner* cleaner);
TileData* data__Tile(Tile* self);
Traverser new__Traverser(Tile* tile);
void connect(Tile* tile1, uchar gate1, Tile* tile2, uchar gate2, uchar flip, Runner* cleaner);
// Look at test2 for calibration
// Preconditions: 0<=dir<4, all other variables = 0 or 1
uchar orientation_to_gate(uchar dir, uchar ab_is_lr, uchar ud_flipped, uchar lr_flipped);
// dir: 0 up, 1 down, 2 left, 3 right
// Look as test2 for calibration. The boolean algebra should be correct.
Traverser travel(Traverser t, uchar dir);
#endif