#ifndef __runner_h__
#define __runner_h__
typedef struct Runner Runner;
struct Runner;
Runner* create__Runner();
void add__Runner(Runner* self, void* obj, void (*on_run)(void* obj));
void run__Runner(Runner* self);
void free__Runner(Runner* self);
#endif