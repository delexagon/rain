#include "iterator.h"
#include <stdlib.h>

struct Iterator {
    void* data;
    void* collection;
    void* (*next)(void* collection, void* data);
};

void free__Iterator(Iterator* self) {
    free(self->data);
    free(self);
}

Iterator* new__Iterator(void* collection, void* data, void* (*next)(void* collection, void* data)) {
    Iterator* p = malloc(sizeof(Iterator));
    p->collection = collection;
    p->data = data;
    p->next = next;
    return p;
}

void* next__Iterator(Iterator* self) {
    return self->next(self->collection, self->data);
}

