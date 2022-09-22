##include "push_array"
##replace \.\.p-->>__PushArray

#include <stdlib.h>

typedef struct Runner Runner;

##private
struct FuncObj {
    void* obj;
    void (*on_run)(void* obj);
};

struct Runner {
    PushArray* to_run;
};

##<Runner>
Runner* create() {
    Runner* r = malloc(sizeof(Runner));
    r->to_run = new..p();
    return r;
}

##<Runner> func
void add(void* obj, void (*on_run)(void* obj)) {
    struct FuncObj* in = malloc(sizeof(struct FuncObj));
    in->obj = obj;
    in->on_run = on_run;
    append..p(self->to_run, in);
}

##<Runner> func
void run() {
    for(int i = 0; i < size..p(self->to_run); i++) {
        struct FuncObj* out = get..p(self->to_run, i);
        if(out->on_run != NULL) {
            (out->on_run)(out->obj);
        }
    }
}

##<Runner> func
void free() {
    for(int i = 0; i < size..p(self->to_run); i++) {
        free(get..p(self->to_run, i));
    }
    free..p(self->to_run);
    free(self);
}

