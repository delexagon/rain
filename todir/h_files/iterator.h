#ifndef __iterator_h__
#define __iterator_h__
typedef struct Iterator Iterator;
struct Iterator;
void free__Iterator(Iterator* self);
Iterator* new__Iterator(void* collection, void* data, void* (*next)(void* collection, void* data));
void* next__Iterator(Iterator* self);
#endif