##requires "tiles"
#include <stddef.h>

typedef unsigned char uchar;
typedef struct Traverser Traverser;

##public
struct Traverser {
    Tile* tile;
    uchar ab_is_lr:1;
    uchar ud_flipped:1;
    uchar lr_flipped:1;
};

##<Traverser>
Traverser new(Tile* tile) {
    Traverser t;
    t.tile = tile;
    t.ab_is_lr = 0;
    t.ud_flipped = 0;
    t.lr_flipped = 0;
    return t;
}

// Look at test2 for calibration
// Preconditions: 0<=dir<4, all other variables = 0 or 1
##private
uchar orientation_to_gate(uchar dir, uchar ab_is_lr, uchar ud_flipped, uchar lr_flipped) {
    uchar flipped = (dir/2==0)*ud_flipped+(dir/2==1)*lr_flipped;
    return ab_is_lr*2+flipped+dir-(2*((dir%2)&flipped))-(4*((dir/2)&ab_is_lr));
}

// dir: 0 up, 1 down, 2 left, 3 right
// Look as test2 for calibration. The boolean algebra should be correct.
Traverser travel(Traverser t, uchar dir) {
    Tile* this_tile = t.tile;
    Traverser new_t = t;
    if(this_tile == NULL) {
        new_t.tile = NULL;
        return new_t;
    }
    uchar gate_to = orientation_to_gate(dir, t.ab_is_lr, t.ud_flipped, t.lr_flipped);
    Edge* e = edge__Tile(this_tile, gate_to);
    
    if(e->mapid == 0) {
        new_t.tile = NULL;
        return new_t;
    }
    new_t.tile = e->tile;
    
    uchar gate_from = e->gate;
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

