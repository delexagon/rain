##replace \.\.r-->>__Runner
##replace \.\.o-->>__Object
#include <stdlib.h>

##include "object"
##include "globals"
##requires "tiles"

typedef struct Magic Magic;

struct Magic {
    Object* obj;
    char dir;
};

##<Magic>
Magic* new(Traverser t, char dir) {
    Magic* m = malloc(sizeof(Magic));
    m->obj = new..o(t, '*');
    m->dir = dir;
    
    add..r(UPDATER, m, update__Magic);
    return m;
}

##<Magic>
void update(void* p) {
    Magic* self = (Magic*)p;
    int moved = move..o(self->obj, self->dir);
    if(moved == 0) {
        self->dir = (self->dir)^1;
    }
}

