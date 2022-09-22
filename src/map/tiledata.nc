#include <stdlib.h>
#include <stdio.h>

typedef struct TileData TileData;

##public
struct TileData {
    char chr;
    unsigned char bgr;
    unsigned char bgg;
    unsigned char bgb;
};

##<TileData>
TileData* new() {
    TileData* data = calloc(1,sizeof(TileData*));
    data->chr = ' ';
    data->bgr = rand()%50;
    data->bgg = rand()%50+100;
    data->bgb = rand()%50+25;
    return data;
}

##<TileData> func
void print() {
    printf("\x1b[48;2;%d;%d;%dm", self->bgr,self->bgg, self->bgb);
    printf("%c", self->chr);
    printf("\x1b[0m");
}

