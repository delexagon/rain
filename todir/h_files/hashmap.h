#ifndef __hashmap_h__
#define __hashmap_h__
typedef struct HashMap HashMap;
struct HashMap;
void free__HashMap(HashMap* self);
HashMap* new__HashMap(int bins, char (*eqfunc)(void* key1, void* key2), int (*hashfunc)(void* key));
int size__HashMap(HashMap* self);
void* get__HashMap(HashMap* self, void* key);
void* set__HashMap(HashMap* self, void* key, void* item);
void* first_itr__HashMap(HashMap* self);
void* next_itr__HashMap(HashMap* self, void* this, void* data);
#endif