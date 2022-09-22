##replace THIS_CLASS-->>Iterator
##replace `-->>##<THIS_CLASS>
##replace ~-->>self->
#include <stdlib.h>

typedef struct THIS_CLASS THIS_CLASS;
struct THIS_CLASS {
    void* data;
    void* collection;
    void* (*next)(void* collection, void* data);
};

`func
void free() {
    free(~data);
    free(self);
}

`
THIS_CLASS* new(void* collection, void* data, void* (*next)(void* collection, void* data)) {
    THIS_CLASS* p = malloc(sizeof(THIS_CLASS));
    p->collection = collection;
    p->data = data;
    p->next = next;
    return p;
}

`func
void* next() {
    return ~next(~collection, ~data);
}

