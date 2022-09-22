#include "hashmap.h"
#include <stdlib.h>

struct HashMap {
    void*** keys;
    void*** items;
    int bins;
    int size;
    char (*eqfunc)(void* key1, void* key2);
    int (*hashfunc)(void* key);
};

void free__HashMap(HashMap* self) {
    for(int i = 0; i < self->bins; i++) {
        if(self->keys[i] != NULL) {
            free(self->keys[i]);
        }
    }
    for(int i = 0; i < self->bins; i++) {
        if(self->items[i] != NULL) {
            free(self->items[i]);
        }
    }
    free(self->items);
    free(self);
}

HashMap* new__HashMap(int bins, char (*eqfunc)(void* key1, void* key2), int (*hashfunc)(void* key)) {
    HashMap* p = malloc(sizeof(HashMap));
    p->keys = calloc(bins, sizeof(void**));
    p->items = calloc(bins, sizeof(void**));
    p->size = 0;
    p->bins = bins;
    return p;
}

int size__HashMap(HashMap* self) {
    return self->size;
}

void* get__HashMap(HashMap* self, void* key) {
    int hash = self->hashfunc(key) % self->bins;
    for(int i = 0; self->keys[hash] != NULL; i++) {
        if(key == self->keys[hash][i] || (self->eqfunc != NULL && self->eqfunc(self->keys[hash][i], key))) {
            return self->items[hash][i];
        }
    }
    return NULL;
}

void* remove__HashMap(HashMap* self, void* key) {
    int hash = self->hashfunc(key) % self->bins;
    for(int i = 0; self->keys[hash] != NULL; i++) {
        if(key == self->keys[hash][i] || (self->eqfunc != NULL && self->eqfunc(self->keys[hash][i], key))) {
            return self->items[hash][i];
        }
    }
    return NULL;
}

void* set__HashMap(HashMap* self, void* key, void* item) {
    void*** keys = self->keys;
    void*** items = self->items;
    if(item == NULL || key == NULL) {
        return NULL;
    }
    int hash = self->hashfunc(key) % self->bins;
    if(keys[hash] == NULL) {
        keys[hash] = calloc(16, sizeof(void*));
        items[hash] = calloc(16, sizeof(void*));
        keys[hash][0] = key;
        items[hash][0] = item;
    } else {
        int i = 0;
        for(int i = 0; keys[hash] != NULL; i++) {
            if(key == keys[hash][i] || (self->eqfunc != NULL && self->eqfunc(keys[hash][i], key))) {
                break;
            }
        }
        if(self->keys[hash][i] != NULL) {
            if(i > 10 && (i & (i-1) == 0)) {
                keys[hash] = realloc(keys[hash], 2*sizeof(void*)*i);
                items[hash] = realloc(items[hash], 2*sizeof(void*)*i);
            }
            keys[hash][i] = key;
            items[hash][i] = item;
        } else {
            keys[hash][i] = key;
            items[hash][i] = item;
            keys[hash][i+1] = NULL;
            items[hash][i+1] = NULL;
        }
    }
    return item;
}

void* first_itr__HashMap(HashMap* self) {
    void*** keys = self->keys;
    for(int bin = 0; bin < self->bins; bin++) {
        for(int i = 0; self->keys[i] != NULL; i++) {
            if(keys[bin][i] != NULL) {
                int* vals = malloc(sizeof(int) * 2);
                vals[0] = bin;
                vals[1] = i;
                return vals;
            }
        }
    }
    return NULL;
}

void* next_itr__HashMap(HashMap* self, void* obj, void* data) {
    int* vals = (int*) data;
    self = (HashMap*)(obj);
    void*** keys = self->keys;
    for(int bin = vals[0]; bin < self->bins; bin++) {
        for(int i = vals[1]+1; self->keys[i] != NULL; i++) {
            if(keys[bin][i] != NULL) {
                vals[0] = bin;
                vals[1] = i;
                return self->items[bin][i];
            }
        }
    }
    return NULL;
}

