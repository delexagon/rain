##replace THIS_CLASS-->>PushArray
##replace `-->>##<THIS_CLASS>
##replace ~-->>self->
##replace \.\.p-->>__PushArray
#include <stdlib.h>

typedef struct THIS_CLASS THIS_CLASS;

struct THIS_CLASS {
    void** array;
    int size;
    int alloc_size;
};

`func
void free() {
    free(self->array);
    free(self);
}

`
PushArray* new() {
    PushArray* p = malloc(sizeof(PushArray));
    p->array = calloc(16, sizeof(void*));
    p->size = 0;
    p->alloc_size = 16;
    return p;
}

`
PushArray* sized_new(int n) {
    PushArray* p = malloc(sizeof(PushArray));
    p->array = calloc(n, sizeof(void*));
    p->size = 0;
    p->alloc_size = n;
    return p;
}

`func
int size() {
    return self->size;
}

`func
void* get(int i) {
    if(i < 0 || i >= self->size) {
        return NULL;
    }
    return self->array[i];
}

`func
void* set(int i, void* obj) {
    if(i < 0 || i >= self->size) {
        return NULL;
    }
    self->array[i] = obj;
    return self->array[i];
}

`func
void* add(void* obj) {
    self->array[self->size] = obj;
    self->size++;
    if(self->size >= self->alloc_size) {
        self->alloc_size = self->alloc_size*2;
        self->array = realloc(self->array, self->alloc_size*sizeof(void*));
    }
    self->array[self->size] = NULL;
    return obj;
}

`func
void* remove(void* obj) {
    int i;
    int size = ~size;
    for(i = 0; i < size; i++) {
        if(~array[i] == obj) {
            for(; i < size; i++) {
                ~array[i] = ~array[i+1];
            }
            ~array[size] = NULL;
            ~size--;
            return obj;
        }
    }
    return NULL;
}
