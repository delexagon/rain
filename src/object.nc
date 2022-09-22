#include <stdlib.h>
##replace \.\.t-->>__Tile

##requires "term"
##include "tiledata"
##requires "tiles"
##include "visionmap"
##include "runner"

typedef struct Object Object;

struct Object {
    Traverser t;
    char chr;
};

##<Object>
Object* new(Tile* t, char chr) {
    Object* o = malloc(sizeof(Object));
    o->t = create__traverser(t);
    o->chr = chr;
    if(t != NULL) {
        data..t(t)->chr = chr;
    }
    return o;
}

##<Object> func
Tile* tile() {
    return self->t.tile;
}

##<Object> func
int move(char direction) {
    if(self->t.tile == NULL) {
        return 0;
    }
    Traverser t2 = travel(self->t, direction);
    if(t2.tile == NULL) {
        // Can't move there.
        return 0;
    }
    data..t(self->t.tile)->chr = ' ';
    data..t(t2.tile)->chr = self->chr;
    self->t = t2;
    return 1;
}

##<Object> func
void vision() {
    cons_clear();
    print__visionmap(31,31,self->t);
}

