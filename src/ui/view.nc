##require "object"
##include "traverser"
##require "intermediate_ui"
##include "visionmap"

#include <stdlib.h>

typedef struct View View;

struct View {
    void (*compose)(View* self);
    void (*draw)(View* self, struct Boundary bound);
    void (*free)(View* self);
    void* data;
};

void draw__View(View* view, struct Boundary bound) {
    view->compose(view);
    view->draw(view, bound);
}

void free_View(View* self) {
    self->free(self);
}

##private
struct MapViewData {
    Object* following;
    Traverser* array;
    CharS* area;
    int array_height;
    int array_width;
};

##private
void draw__MapView(View* self, struct Boundary bound) {
    struct MapViewData* data = (struct MapViewData*)self->data;
    print__CharArea(data->area, data->array_height, data->array_width, bound);
}

##private
void compose__MapView(View* self) {
    struct MapViewData* data = (struct MapViewData*)self->data;
    make_map_array(data->array, data->array_height, data->array_width, traverser__Object(data->following));
    write_to__CharArea(data->array, data->area, data->array_height, data->array_width);
}

##private
void free__MapView(View* self) {
    struct MapViewData* data = (struct MapViewData*)self->data;
    free(data->area);
    free(data->array);
    free(data);
    free(self);
}

View* new__MapView(Object* following, int height, int width) {
    Traverser* array = calloc(height*width, sizeof(Traverser));
    CharS* area = calloc(height*width, sizeof(CharS));
    struct MapViewData* data = malloc(sizeof(struct MapViewData));
    *data = (struct MapViewData) { following, array, area, height, width };
    View* this = malloc(sizeof(View));
    *this = (struct View) { compose__MapView, draw__MapView, free__MapView, data };
    return this;
}
