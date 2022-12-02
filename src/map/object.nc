##replace THIS_CLASS-->>Object
##replace `-->>##<THIS_CLASS>
##replace ~-->>self->
##replace \.\.td-->>__TileData

#include <stdlib.h>
##replace \.\.t-->>__Tile

##require "traverser"
##require "term"
##require "tiles"
##include "tiledata"
##include "visionmap"
##include "runner"

typedef struct THIS_CLASS THIS_CLASS;

struct THIS_CLASS {
    Traverser t;
    char chr;
};

`
THIS_CLASS* new(Traverser t, char chr) {
    THIS_CLASS* o = malloc(sizeof(THIS_CLASS));
    o->t = t;
    o->chr = chr;
    if(t.tile != NULL) {
        obj_add..td(data..t(t.tile), o);
    }
    return o;
}

`func
Traverser traverser() {
    return self->t;
}

`func
Tile* tile() {
    return self->t.tile;
}

`func
char chr() {
    return ~chr;
}

`func
char move(char direction) {
    if(self->t.tile == NULL) {
        return 0;
    }
    Traverser t2 = travel(self->t, direction);
    if(t2.tile == NULL) {
        // Can't move there.
        return 0;
    }
    obj_move..td(data..t(~t.tile), data..t(t2.tile), self);
    self->t = t2;
    return 1;
}

`func
void vision() {
    cons_clear();
    print__visionmap(31,31,self->t);
}
