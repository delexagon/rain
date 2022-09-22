#include "../h_files/object.h"
#include <stdlib.h>

#include "../h_files/tiledata.h"
#include "../h_files/visionmap.h"
#include "../h_files/runner.h"


struct Object {
    Traverser t;
    char chr;
};

Object* new__Object(Tile* t, char chr) {
    Object* o = malloc(sizeof(Object));
    o->t = create__traverser(t);
    o->chr = chr;
    if(t != NULL) {
        data__Tile(t)->chr = chr;
    }
    return o;
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

