#define KEY_UP 128
#define KEY_DOWN 129
#define KEY_RIGHT 130
#define KEY_LEFT 131

##include "term"

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

