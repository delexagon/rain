#include "runner.h"
#include "push_array.h"

#include <stdlib.h>


struct FuncObj {
    void* obj;
    void (*on_run)(void* obj);
};

struct Runner {
    PushArray* to_run;
};

Runner* create__Runner() {
    Runner* r = malloc(sizeof(Runner));
    r->to_run = new__PushArray();
    return r;
}

void add__Runner(Runner* self, void* obj, void (*on_run)(void* obj)) {
    struct FuncObj* in = malloc(sizeof(struct FuncObj));
    in->obj = obj;
    in->on_run = on_run;
    append__PushArray(self->to_run, in);
}

void run__Runner(Runner* self) {
    for(int i = 0; i < size__PushArray(self->to_run); i++) {
        struct FuncObj* out = get__PushArray(self->to_run, i);
        if(out->on_run != NULL) {
            (out->on_run)(out->obj);
        }
    }
}

void free__Runner(Runner* self) {
    for(int i = 0; i < size__PushArray(self->to_run); i++) {
        free(get__PushArray(self->to_run, i));
    }
    free__PushArray(self->to_run);
    free(self);
}

