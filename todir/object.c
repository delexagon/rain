#include "object.h"
#include <stdlib.h>

#include "tiledata.h"
#include "visionmap.h"
#include "runner.h"


struct Object {
    Traverser t;
    char chr;
};

Object* new__Object(Traverser t, char chr) {
    Object* o = malloc(sizeof(Object));
    o->t = t;
    o->chr = chr;
    if(t.tile != NULL) {
        data__Tile(t.tile)->chr = chr;
    }
    return o;
}

Traverser traverser__Object(Object* self) {
    return self->t;
}

Tile* tile__Object(Object* self) {
    return self->t.tile;
}

int move__Object(Object* self, char direction) {
    if(self->t.tile == NULL) {
        return 0;
    }
    Traverser t2 = travel(self->t, direction);
    if(t2.tile == NULL) {
        // Can't move there.
        return 0;
    }
    data__Tile(self->t.tile)->chr = ' ';
    data__Tile(t2.tile)->chr = self->chr;
    self->t = t2;
    return 1;
}

void vision__Object(Object* self) {
    cons_clear();
    print__visionmap(31,31,self->t);
}

