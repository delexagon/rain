
##require "push_array"
##require "style_components"

typedef PushArray Line;
typedef PushArray TextLines;

##public
struct Boundary {
    int height;
    int width;
    int start_x;
    int start_y;
};

##public
struct CharArea {
    int height;
    int width;
    CharS* chars;
};

void write_to__CharArea() {
    
}

void print__TextLines() {
}

void print__CharArea() {
}
