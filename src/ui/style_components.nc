
##public
struct ColorRGB {
    unsigned char r;
    unsigned char g;
    unsigned char b;
};

##public
struct Style {
    struct ColorRGB fg;
    struct ColorRGB bg;
    unsigned char ital:1;
    unsigned char bold:1;
    unsigned char line:1;
};

##public
struct CharS {
    struct Style style;
    unsigned char c;
};

##public
struct StringS {
    struct Style style;
    char* str;
    int len;
};
