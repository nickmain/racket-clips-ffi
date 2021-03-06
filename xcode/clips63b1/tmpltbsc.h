   /*******************************************************/
   /*      "C" Language Integrated Production System      */
   /*                                                     */
   /*             CLIPS Version 6.26  06/05/06            */
   /*                                                     */
   /*       DEFTEMPLATE BASIC COMMANDS HEADER FILE        */
   /*******************************************************/

/*************************************************************/
/* Purpose: Implements core commands for the deftemplate     */
/*   construct such as clear, reset, save, undeftemplate,    */
/*   ppdeftemplate, list-deftemplates, and                   */
/*   get-deftemplate-list.                                   */
/*                                                           */
/* Principal Programmer(s):                                  */
/*      Gary D. Riley                                        */
/*                                                           */
/* Contributing Programmer(s):                               */
/*      Brian L. Dantes                                      */
/*                                                           */
/* Revision History:                                         */
/*      6.23: Corrected compilation errors for files         */
/*            generated by constructs-to-c. DR0861           */
/*                                                           */
/*      6.24: Renamed BOOLEAN macro type to intBool.         */
/*                                                           */
/*************************************************************/

#ifndef _H_tmpltbsc
#define _H_tmpltbsc

#ifndef _H_evaluatn
#include "evaluatn.h"
#endif

#ifdef LOCALE
#undef LOCALE
#endif

#ifdef _TMPLTBSC_SOURCE_
#define LOCALE
#else
#define LOCALE extern
#endif

#define GetDeftemplateList(a,b) EnvGetDeftemplateList(GetCurrentEnvironment(),a,b)
#define ListDeftemplates(a,b) EnvListDeftemplates(GetCurrentEnvironment(),a,b)
#define Undeftemplate(a) EnvUndeftemplate(GetCurrentEnvironment(),a)
#define GetDeftemplateWatch(a) EnvGetDeftemplateWatch(GetCurrentEnvironment(),a)
#define SetDeftemplateWatch(a,b) EnvSetDeftemplateWatch(GetCurrentEnvironment(),a,b)

   LOCALE void                           DeftemplateBasicCommands(void *);
   LOCALE void                           UndeftemplateCommand(void *);
   LOCALE intBool                        EnvUndeftemplate(void *,void *);
   LOCALE void                           GetDeftemplateListFunction(void *,DATA_OBJECT_PTR);
   LOCALE void                           EnvGetDeftemplateList(void *,DATA_OBJECT_PTR,void *);
   LOCALE void                          *DeftemplateModuleFunction(void *);
#if DEBUGGING_FUNCTIONS
   LOCALE void                           PPDeftemplateCommand(void *);
   LOCALE int                            PPDeftemplate(void *,char *,char *);
   LOCALE void                           ListDeftemplatesCommand(void *);
   LOCALE void                           EnvListDeftemplates(void *,char *,void *);
   LOCALE unsigned                       EnvGetDeftemplateWatch(void *,void *);
   LOCALE void                           EnvSetDeftemplateWatch(void *,unsigned,void *);
   LOCALE unsigned                       DeftemplateWatchAccess(void *,int,unsigned,struct expr *);
   LOCALE unsigned                       DeftemplateWatchPrint(void *,char *,int,struct expr *);
#endif

#endif


