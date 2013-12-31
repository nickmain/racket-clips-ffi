// libclips63b1.cpp : Defines the exported functions for the DLL application.
//

#include "stdafx.h"
#include "libclips63b1.h"


// This is an example of an exported variable
LIBCLIPS63B1_API int nlibclips63b1=0;

// This is an example of an exported function.
LIBCLIPS63B1_API int fnlibclips63b1(void)
{
	return 42;
}

// This is the constructor of a class that has been exported.
// see libclips63b1.h for the class definition
Clibclips63b1::Clibclips63b1()
{
	return;
}
