#include "../h_files/you.h"
#include <stdlib.h>

#include "../h_files/object.h"
#include "../h_files/visionmap.h"
#include "../h_files/globals.h"
#include "../h_files/magic.h"
#include "../h_files/controller.h"

#include <stdio.h>


struct You {
    Object* obj;
};

You* new__You(Tile* t) {
    You* you = malloc(sizeof(You));
    you->obj = new__Object(t, '@');
    add__Runner(UPDATER, you, update__You);
    return you;
}

void update__You(void* obj) {
    You* you = (You*)obj;
    vision__Object(you->obj);
    bool acted = false;
    while(!acted) {
        int ch = getch();
        if(get_dir(ch) != -1) {
            acted = move__Object(you->obj, get_dir(ch));
        } else if(ch == 'z') {
            char dir = get_dir(getch());
            if(dir != -1) {
                acted = true;
                new__Magic(tile__Object(you->obj), dir);
            }
        } else if(ch == 'q') {
            QUITTING_NOW = true;
            acted = true;
        } else if(ch == ' ') {
            acted = true;
        }
        if(!acted) {
            printf("Invalid move.\n");
        }
    }
}

