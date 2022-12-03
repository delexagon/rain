#include <stdlib.h>
##replace \.\.t-->>__Tile
##replace \[([^\]]*),([^\]]*)]-->>[(\1)*width+(\2)]

##require "traverser"
##include "intermediate_ui"

#include <stdio.h>

void print__visionmap(int height, int width, Traverser t) {
    Traverser* array = calloc(width*height, sizeof(Traverser));
    make_map_array(array, height, width, t);
    CharS* area = malloc(sizeof(CharS)*width*height);
    write_to__CharArea(array, area, height, width);
    print__CharArea(area, height, width, (struct Boundary) { 0, 0, 20, 20 });
    free(array);
    free(area);
}

void write_to__CharArea(Traverser* array, CharS* area, int height, int width) {
    for(int i = 0; i < height*width; i++) {
        if(array[i].tile != NULL) {
            area[i] = get_char__TileData(data__Tile(array[i].tile));
        } else {
            area[i] = BLOCKEDTILE;
        }
    }
}

void make_map_array(Traverser* array, int height, int width, Traverser t) {
    int center_col = width/2;
    int center_row = height/2;
    // Create center
    array[center_row, center_col] = t;
    // Scan outwards in lines from the center
    for(int i = 0; i < 4; i++) {
        int x = center_col;
        int y = center_row;
        int chx, chy;
        if(i == 0) {
            chx =  0;
            chy = -1;
        } else if (i == 1) {
            chx =  0;
            chy =  1;
        } else if (i == 2) {
            chx = -1;
            chy =  0;
        } else if (i == 3) {
            chx =  1;
            chy =  0;
        }
        while(x+chx >= 0 && x+chx < width && y+chy >= 0 && y+chy < height && array[y*width+x].tile != NULL) {
            x += chx;
            y += chy;
            array[y, x] = travel(array[y-chy, x-chx], i);
        }
    }
    // Scan the corners
    for(int i = 0; i < 4; i++) {
        int chx, chy;
        int dirx, diry;
        if(i == 0) {
            chx =  1;
            chy = -1;
            dirx = 3;
            diry = 0;
        } else if (i == 1) {
            chx =  1;
            chy =  1;
            dirx = 3;
            diry = 1;
        } else if (i == 2) {
            chx = -1;
            chy = -1;
            dirx = 2;
            diry = 0;
        } else if (i == 3) {
            chx = -1;
            chy =  1;
            dirx = 2;
            diry = 1;
        }
        int start_x = center_col+chx;
        int start_y = center_row+chy;
        int do_x;
        int do_y;
        Traverser do_t;
        while(start_y >= 0 && start_y < height) {
            do_x = start_x;
            do_y = start_y;
            while(do_y != center_row && do_x >= 0 && do_x < width) {
                //TODO: Note that if x and y refer to the same tile but in different orientations, this code will incorrectly
                // prioritize the y result, leading to invalid tiles being shown.
                if((do_t = travel(array[do_y, do_x-chx], dirx)).tile == travel(array[do_y-chy, do_x], diry).tile) {
                    array[do_y, do_x] = do_t;
                }
                do_x += chx;
                do_y -= chy;
            }
            start_y += chy;
        }
        start_y -= chy;
        while(start_x >= 0 && start_x < width) {
            do_x = start_x;
            do_y = start_y;
            while(do_y != center_row && do_x >= 0 && do_x < width) {
                if((do_t = travel(array[do_y, do_x-chx], dirx)).tile == travel(array[do_y-chy, do_x], diry).tile) {
                    array[do_y, do_x] = do_t;
                }
                do_x += chx;
                do_y -= chy;
            }
            start_x += chx;
        }
    }
}

