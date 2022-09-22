#ifndef __term_h__
#define __term_h__
#define CONS_BUFF_SIZE 10
void on_cons_resize();
extern int CONS_HEIGHT, CONS_WIDTH;
extern const int CONS_ESC_DELAY;
extern char* CONS_BUFFER;
extern char CONS_CURSOR_ACTIVATED;
extern int CONS_WINCH_CODE;
void cons_restore();
void print_to_cons(char* string);
void cons_resize(int code);
void cons_die(int code);
void cons_clear();
void cons_cursor_mode(int code);
void cons_cursor_toggle();
void cons_init();
void cons_move(int row, int col);
int getch();
#endif