
#include "date.h"

#define VOS_NT_WINDOWS32	(0x40004L)
#define VFT_APP	(0x1L)
#define VFT_DLL	(0x2L)
#ifdef PRODUCT_ISDLL
#define VFT_MY VFT_DLL
#define EXT_MY ".dll"
#else
#define VFT_MY VFT_APP
#define EXT_MY ".exe"
#endif
#if VERSION_MAJOR==0 
#define VERSION_MAJOR_ "0"
#else
#define VERSION_MAJOR_ #VERSION_MAJOR
#endif
#if VERSION_MINOR==0 
#define VERSION_MINOR_ "0"
#else
#define VERSION_MINOR_ #VERSION_MINOR
#endif

#define VERSION_STRING VERSION_MAJOR_ "." VERSION_MINOR_

#define DONE \
VS_VERSION_INFO VERSIONINFO \
FILEVERSION VERSION_MAJOR,VERSION_MINOR,0,0 \
FILEOS VOS_NT_WINDOWS32 \
FILETYPE VFT_APP \
{BLOCK "StringFileInfo" \
{BLOCK "040904E4"{ \
VALUE "FileDescription", PRODUCT_NAME " v" VERSION_STRING "!\0" \
VALUE "CompanyName", "Kly_Men_COmpany\0" \
VALUE "LegalCopyright", "Licensed under WTFPL\0" \
VALUE "OriginalFilename", PRODUCT_NAME EXT_MY "\0"  \
VALUE "FileVersion", VERSION_STRING "\0" \
VALUE "Comments", COMMENTS "\0" \
}} \
BLOCK "VarFileInfo" \
{VALUE "Translation", 0x409, 1251}} \
