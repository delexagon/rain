##noh
##replace \.\.r-->>__Runner
#include <stdlib.h>
#include <time.h>
#include <stdio.h>

#include "globals.h"
#include "you.h"
#include "tiles.h"
#include "visionmap.h"
#include "make_tiles.h"
#include "runner.h"
#include "object.h"
#include "controller.h"
#include "map.h"
#include "mt19937_64.h"

int main() {
    unsigned long long init[4]={0x12345ULL, 0x23456ULL, 0x34567ULL, 0x45678ULL}, length=4;
    init_by_array__Rand(init, length);

    init__terminal();
    
    time_t t;
    
    Map* map = new__Map();
    
    srand((unsigned) time(&t));
    
    UPDATER = create..r();
    int height = 4;
    int width = 6;
    Tile** room = make_room(map, height,width);
    make_hallway(map, room[width/2], 0, room[(height-1)*width+width/2-1], 1);
    make_hallway(map, room[width/2+1], 0, room[(height-1)*width+width/2], 1);
    make_hallway(map, room[width/2-1], 0, room[(height/2)*width], 2);
    
    new__You(room[0]);
    free(room);
    while(!QUITTING_NOW) {
        run..r(UPDATER);
    }
    
    printf("Exit.\n");
    return 0;
}
