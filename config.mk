# aXe 6.1.3 Configuration
# Edit this file to customize build options and installation paths
# Then run: make xaw3d-setup (if USE_XAW3D=1) && make && make install

# ============================================================================
# Installation Paths (standard DESTDIR/PREFIX layout)
# ============================================================================
PREFIX          = /usr/local
DESTDIR         =

BINDIR          = $(PREFIX)/bin
XAPPLOADDIR     = $(PREFIX)/lib/app-defaults
MANDIR          = $(PREFIX)/man/man1
LIBDIR          = $(PREFIX)/lib

# ============================================================================
# Optional Features (0 = disabled, 1 = enabled)
# ============================================================================

# Use system Wcl Table widget (requires Xp and Wc libraries)
# If 0, builds bundled Table.c/TableVec.c/TableLoc.c
USE_SYSTEM_TABLE = 0

# Tcl extension language (requires Tcl library)
# If 1, builds Language.c and links -ltcl -lm
USE_TCL          = 0

# Xaw3d compatibility (requires Xaw3d headers/library)
# If 1, creates X11/Xaw3d symlinks and compiles with -DXAW3D
USE_XAW3D        = 0

# System doesn't have <dirent.h>, use <sys/dir.h> instead
NODIRENT         = 0

# System doesn't have scandir/alphasort, use bundled versions
NOSCANDIR        = 0

# Have X11R5 patchlevel 20 or later (fixes regex query-replace bug)
HAVE_X11R5_PL20  = 0

# Maximum path length (if not defined in system headers)
# MAXPATHLEN_VAL = 1024

# ============================================================================
# External Library Paths (only needed if corresponding USE_*=1)
# ============================================================================

# Wcl Table widget
XP_INCDIR        = /usr/local/Wcl/include
XP_LIBDIR        = /usr/local/Wcl/lib

# Tcl
TCL_INCDIR       = /usr/local/tcl/include
TCL_LIBDIR       = /usr/local/tcl/lib

# Xaw3d
XAW3D_INCDIR     = /usr/local/Xaw3d/include/X11/Xaw3d
XAW3D_LIBDIR     = /usr/local/Xaw3d/lib

# ============================================================================
# Compiler and Tools (normally auto-detected, override if needed)
# ============================================================================
CC              = cc
CFLAGS          = -O
LDFLAGS         =
INSTALL         = install
INSTALL_PROGRAM = $(INSTALL) -c -m 755
INSTALL_DATA    = $(INSTALL) -c -m 644
MKDIRHIER       = mkdir -p
RM              = rm -f
LN              = ln -s

# ============================================================================
# X11 Configuration (normally from xmkmf/imake, set manually if needed)
# ============================================================================
X11BASE       = /usr/X11R6
XINCDIR       = $(X11BASE)/include
XLIBDIR       = $(X11BASE)/lib
XAWLIB        = -lXaw
XMULIB        = -lXmu
XTOLIB        = -lXt
XEXTLIB       = -lXext
X11LIB        = -lX11
XLIB          = $(XAWLIB) $(XMULIB) $(XTOLIB) $(XEXTLIB) $(X11LIB)

# ============================================================================
# Derived Variables (do not edit)
# ============================================================================
VERSION         = aXe 6.1.3

# Extension flags
# Compiler flag: -DEXTENSION when USE_TCL=1
EXTENSION_CFLAG = $(if $(filter 1,$(USE_TCL)),-DEXTENSION,)
# Sed replacement: /**/ when USE_TCL=0 (comments out extension in app-defaults)
EXTENSION_SED   = $(if $(filter 1,$(USE_TCL)),,/\*\*/)

# Xaw3d flag
XAW3D_FLAG      = $(if $(filter 1,$(USE_XAW3D)),-DXAW3D,)

# HAVE_X11R5_PL20 flag
PL20_FLAG       = $(if $(filter 1,$(HAVE_X11R5_PL20)),-DHAVEX11R5PL20,)

# MAXPATHLEN flag
MAXPATHLEN_FLAG = $(if $(MAXPATHLEN_VAL),-DMAXPATHLEN=$(MAXPATHLEN_VAL),)

# NODIRENT flag
NODIRENT_FLAG   = $(if $(filter 1,$(NODIRENT)),-DNODIRENT,)

# Combined DEFINES
DEFINES         = $(EXTENSION_CFLAG) $(XAW3D_FLAG) $(PL20_FLAG) $(MAXPATHLEN_FLAG) $(NODIRENT_FLAG)

# Table widget sources/objects
ifeq ($(USE_SYSTEM_TABLE),1)
TABLE_SRCS      =
TABLE_OBJS      =
TABLE_INCLUDES  = -I$(XP_INCDIR)
TABLE_LDFLAGS   = -L$(XP_LIBDIR)
TABLE_LIBS      = -lXp -lWc
else
TABLE_SRCS      = Table.c TableVec.c TableLoc.c
TABLE_OBJS      = Table.o TableVec.o TableLoc.o
TABLE_INCLUDES  =
TABLE_LDFLAGS   =
TABLE_LIBS      =
endif

# Tcl extension sources/objects
ifeq ($(USE_TCL),1)
EXTN_SRCS       = Language.c
EXTN_OBJS       = Language.o
EXTN_INCLUDES   = -I$(TCL_INCDIR)
EXTN_LDFLAGS    = -L$(TCL_LIBDIR)
EXTN_LIBS       = -ltcl -lm
else
EXTN_SRCS       =
EXTN_OBJS       =
EXTN_INCLUDES   =
EXTN_LDFLAGS    =
EXTN_LIBS       =
endif

# Xaw3d
ifeq ($(USE_XAW3D),1)
XAW3D_INCLUDES  = -I./X11/Xaw3d
XAW3D_LDFLAGS   = -L$(XAW3D_LIBDIR)
XAW3D_LIBS      = -lXaw3d
else
XAW3D_INCLUDES  =
XAW3D_LDFLAGS   =
XAW3D_LIBS      = -lXaw
endif

# Scandir
ifeq ($(NOSCANDIR),1)
SCANDIR_SRCS    = scandir.c
SCANDIR_OBJS    = scandir.o
else
SCANDIR_SRCS    =
SCANDIR_OBJS    =
endif

# X11R4 vs X11R5 sources
# Default to R5 (Viewlist.c). Set USE_R4=1 for R4 (Porthole.c).
ifeq ($(USE_R4),1)
R4ONLY_SRCS     = Porthole.c
R4ONLY_OBJS     = Porthole.o
R5ONLY_SRCS     =
R5ONLY_OBJS     =
else
R4ONLY_SRCS     =
R4ONLY_OBJS     =
R5ONLY_SRCS     = Viewlist.c
R5ONLY_OBJS     = Viewlist.o
endif