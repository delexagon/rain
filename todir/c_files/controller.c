#include "../h_files/controller.h"

#include "../h_files/term.h"

void init__terminal() {
    cons_init();
}

int get_dir(int ch) {
    if(ch == KEY_UP) {
        return 0;
    }
    if(ch == KEY_DOWN) {
        return 1;
    }
    if(ch == KEY_LEFT) {
        return 2;
    }
    if(ch == KEY_RIGHT) {
        return 3;
    }
    return -1;
}

