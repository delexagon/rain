##replace THIS_CLASS-->>TileData
##replace `-->>##<THIS_CLASS>
##replace ~-->>self->
##replace \.\.o-->>__Object
##replace \.\.td-->>__TileData
##replace \.\.p-->>__PushArray

##requires "push_array"
##requires "style_components"
typedef struct Object Object;
##includes "object"

#include <stdlib.h>
#include <stdio.h>

typedef struct THIS_CLASS THIS_CLASS;

struct THIS_CLASS {
    PushArray* objects;
    struct ColorRGB default_bg;
};

`
THIS_CLASS* new() {
    THIS_CLASS* data = calloc(1,sizeof(THIS_CLASS*));
    data->objects = NULL;
    data->default_bg.r = rand()%50;
    data->default_bg.g = rand()%50+100;
    data->default_bg.b = rand()%50+25;
    return data;
}

`func
CharS get_char() {
    CharS schar;
    schar.c = ' ';
    if(~objects == NULL || size..p(~objects) == 0) {
        schar.style = DEFAULTSTYLE;
        schar.style.bg = ~default_bg;
        return schar;
    }
    schar = style..o(get..p(~objects, 0))->char_style;
    int size = size..p(~objects);
    for(int i = 0; i < size; i++) {
        PartialCharS* sty = style..o(get..p(~objects, i));
        if(sty->has_bg) {
            schar.style.bg = sty->char_style.style.bg;
            return schar;
        }
    }
    schar.style.bg = ~default_bg;
    return schar;
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


