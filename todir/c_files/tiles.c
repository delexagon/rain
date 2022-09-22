#include "../h_files/tiles.h"
#include <stdlib.h>




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

void print__Tile(Tile* self) {
    if(self->data != NULL) {
        print__TileData(self->data);
    }
}


void free__Tile(void* t) {
    Tile* tn = (Tile*) t;
    free(tn->gates);
    free(tn->data);
    free(t);
}

Tile* new__Tile(Runner* cleaner) {
    Tile* t = malloc(sizeof(Tile));
    t->gates = calloc(4,sizeof(Edge*));
    
    t->data = new__TileData();
    
    add__Runner(cleaner, t, free__Tile);
    return t;
}

TileData* data__Tile(Tile* self) {
    if(self != NULL) {
        return self->data;
    }
    return NULL;
}

Traverser create__traverser(Tile* tile) {
    Traverser t;
    t.tile = tile;
    t.ab_is_lr = 0;
    t.ud_flipped = 0;
    t.lr_flipped = 0;
    return t;
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
    add__Runner(cleaner, e, free);
}

uchar orientation_to_gate(uchar dir, uchar ab_is_lr, uchar ud_flipped, uchar lr_flipped) {
    uchar flipped = (dir/2==0)*ud_flipped+(dir/2==1)*lr_flipped;
    return ab_is_lr*2+flipped+dir-(2*((dir%2)&flipped))-(4*((dir/2)&ab_is_lr));
}

Traverser travel(Traverser t, uchar dir) {
    const Tile* ti = t.tile;
    Traverser new_t = t;
    Tile* tile = NULL;
    if(ti == NULL) {
        new_t.tile = NULL;
        return new_t;
    }
    uchar gate_to = orientation_to_gate(dir, t.ab_is_lr, t.ud_flipped, t.lr_flipped);
    Edge* e = ti->gates[gate_to];
    
    uchar gate_from = -1;
    if(e == NULL) {
        new_t.tile = NULL;
        return new_t;
    }
    if(e->tile1 == ti && e->gate1 == gate_to) {
        gate_from = e->gate2;
        tile = e->tile2;
    }
    if(e->tile2 == ti && e->gate2 == gate_to) {
        gate_from = e->gate1;
        tile = e->tile1;
    }
    new_t.tile = tile;
    if(gate_from == -1) {
        return new_t;
    }
    new_t.ab_is_lr = gate_from/2!=dir/2;
    uchar primary_flipped = gate_from%2==dir%2;
    if(dir/2 == 0) {
        new_t.ud_flipped = primary_flipped;
        new_t.lr_flipped = e->flip!=t.lr_flipped;
    } else {
        new_t.lr_flipped = primary_flipped;
        new_t.ud_flipped = e->flip!=t.ud_flipped;
    }
    return new_t;
}

