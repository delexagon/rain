##replace THIS_CLASS-->>TileData
##replace `-->>##<THIS_CLASS>
##replace ~-->>self->
##replace \.\.o-->>__Object
##replace \.\.td-->>__TileData
##replace \.\.p-->>__PushArray

##requires "push_array"
typedef struct Object Object;
##includes "object"

#include <stdlib.h>
#include <stdio.h>

typedef struct THIS_CLASS THIS_CLASS;

struct THIS_CLASS {
    PushArray* objects;
    unsigned char bgr;
    unsigned char bgg;
    unsigned char bgb;
};

`
THIS_CLASS* new() {
    THIS_CLASS* data = calloc(1,sizeof(THIS_CLASS*));
    data->objects = NULL;
    data->bgr = rand()%50;
    data->bgg = rand()%50+100;
    data->bgb = rand()%50+25;
    return data;
}

`func
void print() {
    char chr;
    if(~objects != NULL && size..p(~objects) > 0) {
        chr = chr..o(get..p(~objects, 0));
    } else {
        chr = ' ';
    }
    printf("\x1b[48;2;%d;%d;%dm", self->bgr,self->bgg, self->bgb);
    printf("%c", chr);
    printf("\x1b[0m");
}

`func
void obj_add(Object* o) {
    if(o == NULL) {
        return;
    }
    if(~objects == NULL) {
        ~objects = sized_new..p(2);
    }
    add..p(~objects, o);
}

`func
void* obj_remove(Object* o) {
    Object* myo = remove..p(~objects, o);
    if(size..p(~objects) == 0) {
        free..p(~objects);
        ~objects = NULL;
    }
}

`func
void obj_move(TileData* other, Object* o) {
    if(~objects == NULL) {
        return;
    }
    if(other->objects == NULL && size..p(~objects) == 1) {
        other->objects = ~objects;
        ~objects = NULL;
    } else {
        Object* myo = remove..p(~objects, o);
        if(myo != NULL) {
            obj_add..td(other, myo);
        }
    }
}
