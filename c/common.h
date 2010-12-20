#ifndef __ZACHRIGGLE_TOOLS_H__
#define __ZACHRIGGLE_TOOLS_H__ 

#include <iso646.h>

#if not defined(__CPLUSPLUS__) and not defined(__cplusplus)
typedef char bool;
#define true 1
#define false 0
#endif

#define repeat 		for(;;)
#define unless(C)	if(not (C))
#define until(C)	while(not (C))

typedef unsigned char byte;

#endif /* __ZACHRIGGLE_TOOLS_H__ */
