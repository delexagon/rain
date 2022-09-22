#include "../h_files/magic.h"
#include <stdlib.h>

#include "../h_files/object.h"
#include "../h_files/globals.h"


struct Magic {
    Object* obj;
    char dir;
};

Magic* new__Magic(Tile* t, char dir) {
    Magic* m = malloc(sizeof(Magic));
    m->obj = new__Object(t, '*');
    m->dir = dir;
    
    add__Runner(UPDATER, m, update__Magic);
    return m;
}

void update__Magic(void* p) {
    Magic* self = (Magic*)p;
    int moved = move__Object(self->obj, self->dir);
    if(moved == 0) {
        self->dir = (self->dir)^1;
    }
}

