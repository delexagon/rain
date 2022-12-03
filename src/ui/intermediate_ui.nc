
#include <stdio.h>
##require "style_components"
##include "term"


##public
struct Boundary {
    int start_row;
    int start_col;
    int height;
    int width;
};

void print__TextLines() {
}

void print__CharArea(CharS* chars, int field_height, int field_width, struct Boundary bound) {
    int center_row = field_height/2;
    int center_col = field_width/2;
    for(int row = bound.start_row; row < bound.start_row+bound.height; row++) {
        cons_move(row, bound.start_col);
        for(int col = bound.start_col; col < bound.start_col+bound.width; col++) {
            int field_row = center_row+row-bound.start_row-bound.height/2;
            int field_col = center_col+col-bound.start_col-bound.width /2;
            if(field_row < 0 || field_col < 0 || field_row >= field_height || field_col >= field_width) {
                print_schar(&BLOCKEDTILE);
            } else {
                print_schar(&chars[field_row*field_width+field_col]);
            }
        }
    }
}
