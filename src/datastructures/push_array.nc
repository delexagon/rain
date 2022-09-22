#include <stdlib.h>

typedef struct PushArray PushArray;

struct PushArray {
    void** array;
    int size;
    int alloc_size;
};

##<PushArray> func
void free() {
    free(self->array);
    free(self);
}

##<PushArray>
PushArray* new() {
    PushArray* p = malloc(sizeof(PushArray));
    p->array = calloc(16, sizeof(void*));
    p->size = 0;
    p->alloc_size = 16;
    return p;
}

##<PushArray> func
int size() {
    return self->size;
}

##<PushArray> func
void* get(int i) {
    if(i < 0 || i >= self->size) {
        return NULL;
    }
    return self->array[i];
}

##<PushArray> func
void* set(int i, void* obj) {
    if(i < 0 || i >= self->size) {
        return NULL;
    }
    self->array[i] = obj;
    return self->array[i];
}

##<PushArray> func
void* append(void* obj) {
    self->array[self->size] = obj;
    self->size++;
    if(self->size >= self->alloc_size) {
        self->alloc_size = self->alloc_size*2;
        self->array = realloc(self->array, self->alloc_size*sizeof(void*));
    }
    self->array[self->size] = NULL;
    return obj;
}

