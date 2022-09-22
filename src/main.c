##noh
##replace \.\.r-->>__Runner
#include <stdlib.h>
#include <time.h>
#include <stdio.h>

#include "../h_files/globals.h"
#include "../h_files/you.h"
#include "../h_files/tiles.h"
#include "../h_files/visionmap.h"
#include "../h_files/make_tiles.h"
#include "../h_files/runner.h"
#include "../h_files/object.h"
#include "../h_files/controller.h"

int main() {
    init__terminal();
    
    time_t t;
    
    srand((unsigned) time(&t));
    
    Runner* cleaner = create..r();
    UPDATER = create..r();
    int height = 4;
    int width = 6;
    Tile** room = make_room(height,width, cleaner);
    make_hallway(room[width/2], 0, room[(height-1)*width+width/2-1], 1, cleaner);
    make_hallway(room[width/2+1], 0, room[(height-1)*width+width/2], 1, cleaner);
    make_hallway(room[width/2-1], 0, room[(height/2)*width], 2, cleaner);
    
    new__You(room[0]);
    free(room);
    while(!QUITTING_NOW) {
        run..r(UPDATER);
    }
    
    
    run..r(cleaner);
    free..r(cleaner);
    printf("Exit.\n");
    return 0;
}
