#include "term.h"
#include <termios.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <string.h>
#include <time.h>



struct termios CONS_INITIAL;

int CONS_HEIGHT, CONS_WIDTH;
const int CONS_ESC_DELAY = .02;
char* CONS_BUFFER;
char CONS_CURSOR_ACTIVATED;
int CONS_WINCH_CODE;

void cons_restore() {
  printf("\x1b[?25h");
  printf("\x1b[0 q");
  
  // return to original buffer
  printf("\x1b[?1049l");
  
  // return to saved termios settings
  tcsetattr(1, TCSANOW, &CONS_INITIAL);
  
  free(CONS_BUFFER);
}

void print_to_cons(char* string) {
  printf("\x1b[?1049l%s\x1b[?1049h", string);
}

void cons_resize(int code) {
  struct winsize windata;
  ioctl(1, TIOCGWINSZ, &windata);
  CONS_HEIGHT = windata.ws_row;
  CONS_WIDTH = windata.ws_col;
  CONS_WINCH_CODE = code;
  #ifdef USE_CONS_RESIZE
  on_cons_resize();
  #endif
}

void cons_die(int code) {
  exit(code);
}

void cons_clear() {
  printf("\x1b[0;0H\x1b[2J");
}

void cons_cursor_mode(int code) {
  printf("\x1b[%d q", code);
}

void cons_cursor_toggle() {
  if(CONS_CURSOR_ACTIVATED) {
    printf("\x1b[?25l");
    CONS_CURSOR_ACTIVATED = 0;
  } else {
    printf("\x1b[?25h");
    CONS_CURSOR_ACTIVATED = 1;
  }
}

void cons_init() {
  // remove output buffer for better printing
  setvbuf(stdout, NULL, _IONBF, 0);
  
  // load termios structure for changing
  struct termios t;
  tcgetattr(1, &t);
  // save initial termios structure
  CONS_INITIAL = t;
  // turn off echoing typed keys, buffer until pressing enter
  t.c_lflag &= (~ECHO & ~ICANON);
  // load changed termios structure
  tcsetattr(1, TCSANOW, &t);

  // need to make sure the console returns to normal when done
  atexit(cons_restore);
  
  signal(SIGTERM, cons_die);
  signal(SIGINT, cons_die);
  signal(SIGWINCH, cons_resize);
  
  // create alternate buffer for work
  printf("\x1b[?1049h");
  
  struct winsize windata;
  ioctl(1, TIOCGWINSZ, &windata);
  CONS_HEIGHT = windata.ws_row;
  CONS_WIDTH = windata.ws_col;
  
  CONS_BUFFER = (char*)malloc(sizeof(char) * CONS_BUFF_SIZE);
  CONS_CURSOR_ACTIVATED = 1;
  
}

void cons_move(int row, int col) {
  printf("\x1b[%d;%dH", row, col);
}

int getch() {
  char ret = 0;
  
  read(1, &ret, 1);
  if(ret != 27) {
   return (int)ret;
  }
  for(int qq = 0; qq < CONS_BUFF_SIZE; qq++) {
    CONS_BUFFER[qq] = 0;
  }
  sleep(CONS_ESC_DELAY);
  read(1, CONS_BUFFER, CONS_BUFF_SIZE);
  if(CONS_BUFFER[0] == 27) {
    return 27;
  }
  if(CONS_BUFFER[0] == '[') {
    switch(CONS_BUFFER[1]) {
      case 'A':
        return 128; // up
      case 'B':
        return 129; // down
      case 'C':
        return 130; // right
      case 'D':
        return 131; // left
    }
  }
  
  return CONS_BUFFER[0]+256;
}

