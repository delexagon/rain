#ifndef __push_array_h__
#define __push_array_h__
typedef struct PushArray PushArray;
struct PushArray;
void free__PushArray(PushArray* self);
PushArray* new__PushArray();
int size__PushArray(PushArray* self);
void* get__PushArray(PushArray* self, int i);
void* set__PushArray(PushArray* self, int i, void* obj);
void* append__PushArray(PushArray* self, void* obj);
#endif