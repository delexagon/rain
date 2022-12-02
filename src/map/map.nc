##replace THIS_CLASS-->>Map
##replace `-->>##<THIS_CLASS>
##replace ~-->>self->

##replace \.\.p-->>__PushArray
##replace \.\.t-->>__Tile

##require "tiles"
##include "push_array"
##include "mt19937_64"

#include <stdlib.h>

typedef struct Map Map;

struct Map {
    unsigned long long id;
    PushArray* tiles;
};

`func
void free() {
    for(int i = 0; i < size..p(~tiles); i++) {
        free..t(get..p(~tiles, i));
    }
    free..p(~tiles);
    free(self);
}

`
Map* new() {
    Map* this = malloc(sizeof(Map));
    this->id = int64__Rand();
    this->tiles = new..p();
    return this;
}

`func
Tile* gen_tile() {
    Tile* tile = new..t(~id);
    add..p(~tiles, tile);
    return tile;
}
