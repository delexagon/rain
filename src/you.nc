#include <stdlib.h>

##include "object"
##requires "tiles"
##include "visionmap"
##include "globals"
##include "magic"
##include "controller"
##replace \.\.r-->>__Runner
##replace \.\.m-->>__Magic
##replace \.\.o-->>__Object

#include <stdio.h>

typedef struct You You;

struct You {
    Object* obj;
};

##<You>
You* new(Tile* t) {
    You* you = malloc(sizeof(You));
    you->obj = new..o(new__Traverser(t), '@');
    add..r(UPDATER, you, update__You);
    return you;
}

##<You>
void update(void* obj) {
    You* you = (You*)obj;
    vision..o(you->obj);
    bool acted = false;
    while(!acted) {
        int ch = getch();
        if(get_dir(ch) != -1) {
            acted = move..o(you->obj, get_dir(ch));
        } else if(ch == 'z') {
            char dir = get_dir(getch());
            if(dir != -1) {
                acted = true;
                new..m(traverser..o(you->obj), dir);
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

