##replace THIS_CLASS-->>Tile
##replace `-->>##<THIS_CLASS>
##replace ~-->>self->

#include <stdlib.h>
##replace \.\.d-->>__TileData

##requires "tiledata"
##requires "runner"

typedef unsigned char uchar;

typedef struct Edge Edge;
typedef struct Tile Tile;

##public
struct Edge {
    Tile* tile;
    int mapid;
    uchar gate;
    uchar flip;
};

struct Tile {
    TileData* data;
    // A,B,C,D
    Edge gates[4];
};

`func
void print() {
    if(self->data != NULL) {
        print..d(self->data);
    }
}

`func
void free() {
    free(self->data);
    free(self);
}

`
Tile* new() {
    Tile* t = malloc(sizeof(Tile));  
    t->data = new..d();
    return t;
}

`func
TileData* data() {
    if(self != NULL) {
        return self->data;
    }
    return NULL;
}

`func
Edge* edge(char gate_to) {
    return &(~gates[gate_to]);
}

void connect(Tile* tile1, uchar gate1, Tile* tile2, uchar gate2, uchar flip) {
    // Do not connect if there is already a gate here
    if(tile1->gates[gate1].mapid != 0 || tile2->gates[gate2].mapid != 0) {
        return;
    }
    tile1->gates[gate1].tile = tile2;
    tile2->gates[gate2].tile = tile1;
    tile1->gates[gate1].gate = gate2;
    tile2->gates[gate2].gate = gate1;
    tile1->gates[gate2].flip = flip;
    tile2->gates[gate2].flip = flip;
    tile1->gates[gate1].mapid = 1;
    tile2->gates[gate2].mapid = 1;
}
