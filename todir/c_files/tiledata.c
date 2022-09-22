#include "../h_files/tiledata.h"
#include <stdlib.h>
#include <stdio.h>



TileData* new__TileData() {
    TileData* data = calloc(1,sizeof(TileData*));
    data->chr = ' ';
    data->bgr = rand()%50;
    data->bgg = rand()%50+100;
    data->bgb = rand()%50+25;
    return data;
}

void print__TileData(TileData* self) {
    printf("\x1b[48;2;%d;%d;%dm", self->bgr,self->bgg, self->bgb);
    printf("%c", self->chr);
    printf("\x1b[0m");
}

