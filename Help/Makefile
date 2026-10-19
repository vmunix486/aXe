# aXe 6.1.3 Help/Makefile
# Builds axinfo help browser

include ../config.mk

# ============================================================================
# Source Files
# ============================================================================
SRCS = axinfo.c Hyper.c compat_sys_errlist.c
OBJS = axinfo.o Hyper.o compat_sys_errlist.o

PROGRAM = axinfo

# ============================================================================
# Compiler Flags
# ============================================================================
DEFINES_H = -D_NO_PROTO $(DEFINES)

EXTRA_INCLUDES = -I../Widgets $(TABLE_INCLUDES) $(XAW3D_INCLUDES)

LOCAL_LDFLAGS = $(TABLE_LDFLAGS) $(XAW3D_LDFLAGS)
LOCAL_LIBS    = ../Widgets/libaxe.a $(TABLE_LIBS) $(XAW3D_LIBS)

SYS_LIBS      = $(XLIB)
DEPLIBS       = ../Widgets/libaxe.a

# ============================================================================
# Targets
# ============================================================================
all: $(PROGRAM) Axinfo.ad

$(PROGRAM): $(OBJS) $(DEPLIBS)
	$(RM) $@
	$(CC) -o $@ $(OBJS) $(LDFLAGS) $(LOCAL_LIBS) $(SYS_LIBS)

# Version dependency (from original SpecialObjectRule)
axinfo.o: ../version.h

# axinfo.c has conflicting malloc/realloc declarations with stdlib.h
# Also needs -Wno-implicit-function-declaration and -Wno-implicit-int
axinfo.o: axinfo.c
	$(CC) $(CFLAGS) $(DEFINES_H) -I../Widgets $(TABLE_INCLUDES) $(XAW3D_INCLUDES) -Wno-implicit-function-declaration -Wno-implicit-int -c -o $@ $<

%.o: %.c
	$(CC) $(CFLAGS) $(DEFINES_H) $(EXTRA_INCLUDES) -Wno-implicit-int -Wno-return-mismatch -c -o $@ $<

# ============================================================================
# App-Defaults Generation
# ============================================================================
Axinfo.ad: Axinfo.ad.sed ../version.h ../config.mk
	sed -e "s/VERSION/`sed -e 's/.*VERSION \(.*\)/\1/;q' <../version.h`/" \
	    -e "s+AXINFOLIBDIR+$(LIBDIR)+" < $< > $@

# ============================================================================
# Xaw3d Symlink Setup (for Help directory too)
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
install: all install-axinfo install-axinfo-ad install-info-files

install-axinfo: $(PROGRAM)
	$(MKDIRHIER) $(DESTDIR)$(BINDIR)
	$(INSTALL_PROGRAM) $(PROGRAM) $(DESTDIR)$(BINDIR)/$(PROGRAM)

install-axinfo-ad: Axinfo.ad
	$(MKDIRHIER) $(DESTDIR)$(XAPPLOADDIR)
	$(INSTALL_DATA) Axinfo.ad $(DESTDIR)$(XAPPLOADDIR)/Axinfo

install-info-files: axe.info axe.info-1 axe.info-2
	$(MKDIRHIER) $(DESTDIR)$(LIBDIR)
	$(INSTALL_DATA) axe.info $(DESTDIR)$(LIBDIR)/axe.info
	$(INSTALL_DATA) axe.info-1 $(DESTDIR)$(LIBDIR)/axe.info-1
	$(INSTALL_DATA) axe.info-2 $(DESTDIR)$(LIBDIR)/axe.info-2

install.man: axinfo.man
	$(MKDIRHIER) $(DESTDIR)$(MANDIR)
	$(INSTALL_DATA) axinfo.man $(DESTDIR)$(MANDIR)/axinfo.1

# ============================================================================
# Cleanup
# ============================================================================
clean:
	$(RM) $(OBJS) $(PROGRAM) Axinfo.ad

distclean: clean

# ============================================================================
# Dependencies
# ============================================================================
depend:
	@$(CC) $(CFLAGS) $(DEFINES_H) $(EXTRA_INCLUDES) -MM $(SRCS) > .depend 2>/dev/null || true

-include .depend

.PHONY: all install install-axinfo install-axinfo-ad install-info-files \
        install.man clean distclean depend xaw3d-setup