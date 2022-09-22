#include "push_array.h"
#include <stdlib.h>


struct PushArray {
    void** array;
    int size;
    int alloc_size;
};

void free__PushArray(PushArray* self) {
    free(self->array);
    free(self);
}

PushArray* new__PushArray() {
    PushArray* p = malloc(sizeof(PushArray));
    p->array = calloc(16, sizeof(void*));
    p->size = 0;
    p->alloc_size = 16;
    return p;
}

int size__PushArray(PushArray* self) {
    return self->size;
}

void* get__PushArray(PushArray* self, int i) {
    if(i < 0 || i >= self->size) {
        return NULL;
    }
    return self->array[i];
}

void* set__PushArray(PushArray* self, int i, void* obj) {
    if(i < 0 || i >= self->size) {
        return NULL;
    }
    self->array[i] = obj;
    return self->array[i];
}

void* append__PushArray(PushArray* self, void* obj) {
    self->array[self->size] = obj;
    self->size++;
    if(self->size >= self->alloc_size) {
        self->alloc_size = self->alloc_size*2;
        self->array = realloc(self->array, self->alloc_size*sizeof(void*));
    }
    self->array[self->size] = NULL;
    return obj;
}

