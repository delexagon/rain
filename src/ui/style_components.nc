// Defining all UI elements in one file

##public
struct ColorRGB {
    unsigned char r;
    unsigned char g;
    unsigned char b;
};

typedef struct Style Style;

##public
struct Style {
    struct ColorRGB fg;
    struct ColorRGB bg;
    unsigned char ital:1;
    unsigned char bold:1;
    unsigned char line:1;
};

typedef struct CharS CharS;

##public
struct CharS {
    struct Style style;
    unsigned char c;
};

typedef struct PartialCharS PartialCharS;

##public
struct PartialCharS {
    struct CharS char_style;
    unsigned char has_bg:1;
};

##public
struct StringS {
    struct Style style;
    char* str;
    int len;
};

##vars
const struct ColorRGB BLACK = {   0,   0,   0 };
const struct ColorRGB WHITE = { 255, 255, 255 };
const struct Style DEFAULTSTYLE = { WHITE, BLACK, 0, 0, 0 };
const struct CharS BLOCKEDTILE = { DEFAULTSTYLE, '#' };
##endvars
