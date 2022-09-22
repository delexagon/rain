#ifndef __tiledata_h__
#define __tiledata_h__
typedef struct TileData TileData;
struct TileData {
    char chr;
    unsigned char bgr;
    unsigned char bgg;
    unsigned char bgb;
};
TileData* new__TileData();
void print__TileData(TileData* self);
#endif