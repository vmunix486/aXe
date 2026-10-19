# aXe 6.1.3 Top-level Makefile
# Builds: axe, coaxe, Widgets/libaxe.a, Help/axinfo

include config.mk

# ============================================================================
# Directories and Programs
# ============================================================================
WIDGETS_DIR     = Widgets
HELP_DIR        = Help

WIDGETS_LIB     = $(WIDGETS_DIR)/libaxe.a

# ============================================================================
# Source Files (top-level only)
# ============================================================================
SRCS            = axe.c
OBJS            = axe.o

COAXE_SRCS      = coaxe.c
COAXE_OBJS      = coaxe.o

# ============================================================================
# Includes and Libraries
# ============================================================================
EXTRA_INCLUDES  = -I. -I$(WIDGETS_DIR) $(TABLE_INCLUDES) $(EXTN_INCLUDES) $(XAW3D_INCLUDES)

LOCAL_LDFLAGS   = $(TABLE_LDFLAGS) $(EXTN_LDFLAGS) $(XAW3D_LDFLAGS)
LOCAL_LIBS      = $(WIDGETS_LIB) $(TABLE_LIBS) $(EXTN_LIBS) $(XAW3D_LIBS)

SYS_LIBS        = $(XLIB)
DEPLIBS         = $(WIDGETS_LIB)

# ============================================================================
# Default Target
# ============================================================================
all: widgets help axe coaxe Axe.ad

widgets:
	$(MAKE) -C $(WIDGETS_DIR) all

help:
	$(MAKE) -C $(HELP_DIR) all

# ============================================================================
# axe - Main Editor
# ============================================================================
axe: $(OBJS) $(DEPLIBS)
	$(RM) $@
	$(CC) -o $@ $(OBJS) $(LDFLAGS) $(LOCAL_LIBS) $(SYS_LIBS)

axe.o: axe.c version.h
	$(CC) $(CFLAGS) $(DEFINES) $(EXTRA_INCLUDES) -Wno-implicit-int -c -o $@ $<

# Version dependency (from original SpecialObjectRule)
axe.o: version.h

# ============================================================================
# coaxe - Command-line version (also creates faxe/poleaxe symlinks)
# ============================================================================
coaxe: $(COAXE_OBJS) $(DEPLIBS) Help/compat_sys_errlist.o
	$(RM) $@
	$(CC) -o $@ $(COAXE_OBJS) Help/compat_sys_errlist.o $(LDFLAGS) $(LOCAL_LIBS) $(SYS_LIBS)

coaxe.o: coaxe.c
	$(CC) $(CFLAGS) $(DEFINES) $(EXTRA_INCLUDES) -Wno-implicit-int -Wno-implicit-function-declaration -c -o $@ $<

# ============================================================================
# App-Defaults Generation
# ============================================================================
Axe.ad: Axe.ad.sed version.h config.mk
	sed -e "s/VERSION/$(VERSION)/" \
	    -e "s+EXTENSION+$(EXTENSION_SED)+" \
	    -e "s+AXELIBDIR+$(LIBDIR)+" < $< > $@

# ============================================================================
# Xaw3d Symlink Setup
# ============================================================================
xaw3d-setup:
	@if [ "$(USE_XAW3D)" != "1" ]; then \
	    echo "USE_XAW3D=1 not set in config.mk"; \
	    exit 1; \
	fi
	$(MKDIRHIER) X11/Xaw3d/X11
	@(cd X11/Xaw3d/X11; \
	  for i in Xaw Xaw3d; do \
	    $(RM) $$i; \
	    $(LN) $(XAW3D_INCDIR) $$i; \
	  done)

# ============================================================================
# Installation
# ============================================================================
install: all install-axe install-coaxe install-axe-ad install-axe-tcl

install-axe: axe
	$(MKDIRHIER) $(DESTDIR)$(BINDIR)
	$(INSTALL_PROGRAM) axe $(DESTDIR)$(BINDIR)/axe

install-coaxe: coaxe
	$(MKDIRHIER) $(DESTDIR)$(BINDIR)
	$(INSTALL_PROGRAM) coaxe $(DESTDIR)$(BINDIR)/coaxe
	@if [ -f $(DESTDIR)$(BINDIR)/faxe ]; then :; else \
	    (cd $(DESTDIR)$(BINDIR) && $(LN) coaxe faxe); \
	fi
	@if [ -f $(DESTDIR)$(BINDIR)/poleaxe ]; then :; else \
	    (cd $(DESTDIR)$(BINDIR) && $(LN) coaxe poleaxe); \
	fi

install-axe-ad: Axe.ad
	$(MKDIRHIER) $(DESTDIR)$(XAPPLOADDIR)
	$(INSTALL_DATA) Axe.ad $(DESTDIR)$(XAPPLOADDIR)/Axe

install-axe-tcl: axe.tcl
	$(MKDIRHIER) $(DESTDIR)$(LIBDIR)
	$(INSTALL_DATA) axe.tcl $(DESTDIR)$(LIBDIR)/axe.tcl

install.man: axe.man
	$(MKDIRHIER) $(DESTDIR)$(MANDIR)
	$(INSTALL_DATA) axe.man $(DESTDIR)$(MANDIR)/axe.1

# Also install help system
install-help:
	$(MAKE) -C $(HELP_DIR) install

# Full install including help
install-all: install install-help

# ============================================================================
# Cleanup
# ============================================================================
clean:
	$(RM) $(OBJS) $(COAXE_OBJS) axe coaxe Axe.ad
	$(MAKE) -C $(WIDGETS_DIR) clean
	$(MAKE) -C $(HELP_DIR) clean

distclean: clean
	$(RM) config.mk.bak
	$(MAKE) -C $(WIDGETS_DIR) distclean
	$(MAKE) -C $(HELP_DIR) distclean
	@if [ -d X11/Xaw3d/X11 ]; then $(RM) -r X11/Xaw3d; fi

# ============================================================================
# Dependencies
# ============================================================================
depend:
	$(MAKE) -C $(WIDGETS_DIR) depend
	$(MAKE) -C $(HELP_DIR) depend

.PHONY: all widgets help install install-axe install-coaxe install-axe-ad \
        install-axe-tcl install.man install-help install-all clean distclean \
        depend xaw3d-setup