// The following ifdef block is the standard way of creating macros which make exporting 
// from a DLL simpler. All files within this DLL are compiled with the LIBCLIPS63B1_EXPORTS
// symbol defined on the command line. This symbol should not be defined on any project
// that uses this DLL. This way any other project whose source files include this file see 
// LIBCLIPS63B1_API functions as being imported from a DLL, whereas this DLL sees symbols
// defined with this macro as being exported.
#ifdef LIBCLIPS63B1_EXPORTS
#define LIBCLIPS63B1_API __declspec(dllexport)
#else
#define LIBCLIPS63B1_API __declspec(dllimport)
#endif

// This class is exported from the libclips63b1.dll
class LIBCLIPS63B1_API Clibclips63b1 {
public:
	Clibclips63b1(void);
	// TODO: add your methods here.
};

extern LIBCLIPS63B1_API int nlibclips63b1;

LIBCLIPS63B1_API int fnlibclips63b1(void);
