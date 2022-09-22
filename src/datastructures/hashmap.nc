##replace THIS_CLASS-->>HashMap
##replace `-->>##<THIS_CLASS>
##replace ~-->>self->
#include <stdlib.h>

typedef struct THIS_CLASS THIS_CLASS;
struct THIS_CLASS {
    void*** keys;
    void*** items;
    int bins;
    int size;
    char (*eqfunc)(void* key1, void* key2);
    int (*hashfunc)(void* key);
};

`func
void free() {
    for(int i = 0; i < ~bins; i++) {
        if(~keys[i] != NULL) {
            free(~keys[i]);
        }
    }
    for(int i = 0; i < ~bins; i++) {
        if(~items[i] != NULL) {
            free(~items[i]);
        }
    }
    free(~items);
    free(self);
}

`
HashMap* new(int bins, char (*eqfunc)(void* key1, void* key2), int (*hashfunc)(void* key)) {
    HashMap* p = malloc(sizeof(HashMap));
    p->keys = calloc(bins, sizeof(void**));
    p->items = calloc(bins, sizeof(void**));
    p->size = 0;
    p->bins = bins;
    return p;
}

`func
int size() {
    return ~size;
}

`func
void* get(void* key) {
    int hash = ~hashfunc(key) % ~bins;
    for(int i = 0; ~keys[hash] != NULL; i++) {
        if(key == ~keys[hash][i] || (~eqfunc != NULL && ~eqfunc(~keys[hash][i], key))) {
            return ~items[hash][i];
        }
    }
    return NULL;
}

`func
void* remove(void* key) {
    int hash = ~hashfunc(key) % ~bins;
    for(int i = 0; ~keys[hash] != NULL; i++) {
        if(key == ~keys[hash][i] || (~eqfunc != NULL && ~eqfunc(~keys[hash][i], key))) {
            return ~items[hash][i];
        }
    }
    return NULL;
}

`func
void* set(void* key, void* item) {
    void*** keys = ~keys;
    void*** items = ~items;
    if(item == NULL || key == NULL) {
        return NULL;
    }
    int hash = ~hashfunc(key) % ~bins;
    if(keys[hash] == NULL) {
        keys[hash] = calloc(16, sizeof(void*));
        items[hash] = calloc(16, sizeof(void*));
        keys[hash][0] = key;
        items[hash][0] = item;
    } else {
        int i = 0;
        for(int i = 0; keys[hash] != NULL; i++) {
            if(key == keys[hash][i] || (~eqfunc != NULL && ~eqfunc(keys[hash][i], key))) {
                break;
            }
        }
        if(~keys[hash][i] != NULL) {
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

`func
void* first_itr() {
    void*** keys = ~keys;
    for(int bin = 0; bin < ~bins; bin++) {
        for(int i = 0; ~keys[i] != NULL; i++) {
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

`func
void* next_itr(void* obj, void* data) {
    int* vals = (int*) data;
    self = (THIS_CLASS*)(obj);
    void*** keys = ~keys;
    for(int bin = vals[0]; bin < ~bins; bin++) {
        for(int i = vals[1]+1; ~keys[i] != NULL; i++) {
            if(keys[bin][i] != NULL) {
                vals[0] = bin;
                vals[1] = i;
                return ~items[bin][i];
            }
        }
    }
    return NULL;
}

