#include <stdlib.h>
##replace \.\.r-->>__Runner
##replace \.\.d-->>__TileData

##requires "tiledata"
##requires "runner"

typedef unsigned char uchar;

typedef struct Edge Edge;
typedef struct Tile Tile;

##public
struct Edge {
    Tile* tile1;
    Tile* tile2;
    int mapid;
    uchar gate1;
    uchar gate2;
    uchar flip;
};

struct Tile {
    TileData* data;
    // A,B,C,D
    Edge** gates;
};

##<Tile> func
void print() {
    if(self->data != NULL) {
        print..d(self->data);
    }
}

##<Tile>
void free(void* t) {
    Tile* tn = (Tile*) t;
    free(tn->gates);
    free(tn->data);
    free(t);
}

##<Tile>
Tile* new(Runner* cleaner) {
    Tile* t = malloc(sizeof(Tile));
    t->gates = calloc(4,sizeof(Edge*));
    
    t->data = new..d();
    
    add..r(cleaner, t, free__Tile);
    return t;
}

##<Tile> func
TileData* data() {
    if(self != NULL) {
        return self->data;
    }
    return NULL;
}

##<Tile> func
Edge* edge(char gate_to) {
    return self->gates[gate_to];
}

void connect(Tile* tile1, uchar gate1, Tile* tile2, uchar gate2, uchar flip, Runner* cleaner) {
    // Do not connect if there is already a gate here
    if(tile1->gates[gate1] != NULL || tile2->gates[gate2] != NULL) {
        return;
    }
    Edge* e = malloc(sizeof(Edge));
    e->tile1 = tile1;
    e->tile2 = tile2;
    e->gate1 = gate1;
    e->gate2 = gate2;
    e->flip = flip;
    tile1->gates[gate1] = e;
    tile2->gates[gate2] = e;
    add..r(cleaner, e, free);
}
