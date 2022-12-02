##replace \.\.t-->>__Tile
##replace \.\.m-->>__Map
#include <stdlib.h>

##requires "map"
##requires "tiles"

Tile** make_room(Map* map, int height, int width) {
    Tile** tiles = calloc(height*width, sizeof(Tile*));
    // Create the tiles
    for(int i = 0; i < height*width; i++) {
        tiles[i] = gen_tile..m(map);
    }
    // Create the edges
    for(int row = 0; row < height; row++) {
        for(int col = 0; col < width; col++) {
            // Connect this to above
            if(row > 0) {
                // Connect gate 'a' of this tile (the a-b and c-d gates are paired) to gate 'b' of the tile above.
                // By convention, in standard orientation gate 'a' is up, 'b' is down, 'c' is left, and 'd' is right.
                connect(tiles[row*width+col], 0, tiles[(row-1)*width+col], 1, 0);
            }
            // Connect this to left
            if(col > 0) {
                connect(tiles[row*width+col], 2, tiles[row*width+col-1], 3, 0);
            }
            // Connect this to below
            if(row < height-1) {
                connect(tiles[row*width+col], 1, tiles[(row+1)*width+col], 0, 0);
            }
            // Connect this to right
            if(col < width-1) {
                connect(tiles[row*width+col], 3, tiles[row*width+col+1], 2, 0);
            }
        }
    }
    return tiles;
}

Tile* make_hallway(Map* map, Tile* tile1, char gate1, Tile* tile2, char gate2) {
    Tile* hallway = gen_tile..m(map);
    connect(tile1, gate1, hallway, 1, 0);
    connect(tile2, gate2, hallway, 0, 0);
    return hallway;
}

