# aXe 6.1.3 Widgets/Makefile
# Builds libaxe.a from all widget sources

include ../config.mk

# ============================================================================
# Source Files
# ============================================================================
SRCS = $(TABLE_SRCS) $(EXTN_SRCS) $(R4ONLY_SRCS) $(R5ONLY_SRCS) $(SCANDIR_SRCS) \
       AxeWindow.c AxeEditor.c AxeMenuBtn.c AxeSimMenu.c \
       AxeSmeBSB.c AxeCommand.c AxeTextDeck.c AxeText.c \
       AxeiiText.c AxeiiUndo.c AxeiiSink.c \
       FileNomWin.c FileNom.c ScrollText.c \
       NumericPad.c CtrlCodeSel.c Preference.c Confirmer.c \
       regexp.c insertfile.c match.c util.c

OBJS = $(TABLE_OBJS) $(EXTN_OBJS) $(R4ONLY_OBJS) $(R5ONLY_OBJS) $(SCANDIR_OBJS) \
       AxeWindow.o AxeEditor.o AxeMenuBtn.o AxeSimMenu.o \
       AxeSmeBSB.o AxeCommand.o AxeTextDeck.o AxeText.o \
       AxeiiText.o AxeiiUndo.o AxeiiSink.o \
       FileNomWin.o FileNom.o ScrollText.o \
       NumericPad.o CtrlCodeSel.o Preference.o Confirmer.o \
       regexp.o insertfile.o match.o util.o

# ============================================================================
# Compiler Flags
# ============================================================================
CFLAGS_W = $(CFLAGS) $(DEFINES) $(TABLE_INCLUDES) -I. -I.. $(EXTN_INCLUDES) $(XAW3D_INCLUDES) -Wno-implicit-function-declaration

# Table sources need string.h for modern compiler strictness
# Suppress incompatible-pointer-types for old qsort compare functions
TABLE_CFLAGS = $(CFLAGS_W) -Wno-incompatible-pointer-types

# ============================================================================
# Library Target
# ============================================================================
LIBRARY = libaxe.a

all: $(LIBRARY)

$(LIBRARY): $(OBJS)
	$(RM) $@
	ar rc $@ $(OBJS)
	ranlib $@

# ============================================================================
# Special Compilation Rules
# ============================================================================

# Table sources need -include ctype.h for isspace/isalnum
Table.o: Table.c
	$(CC) $(TABLE_CFLAGS) -c -o $@ $<

TableVec.o: TableVec.c
	$(CC) $(TABLE_CFLAGS) -c -o $@ $<

TableLoc.o: TableLoc.c
	$(CC) $(TABLE_CFLAGS) -c -o $@ $<

# FileNom.c needs -DNODIRENT if NODIRENT=1
ifeq ($(NODIRENT),1)
FileNom.o: FileNom.c
	$(CC) $(CFLAGS_W) -DNODIRENT -c -o $@ $<
else
FileNom.o: FileNom.c
	$(CC) $(CFLAGS_W) -c -o $@ $<
endif

# scandir.c needs -DNODIRENT if both NODIRENT=1 and NOSCANDIR=1
ifeq ($(NODIRENT),1)
ifeq ($(NOSCANDIR),1)
scandir.o: scandir.c
	$(CC) $(CFLAGS_W) -DNODIRENT -c -o $@ $<
else
scandir.o: scandir.c
	$(CC) $(CFLAGS_W) -c -o $@ $<
endif
else
scandir.o: scandir.c
	$(CC) $(CFLAGS_W) -c -o $@ $<
endif

# regexp.c has conflicting malloc declaration with stdlib.h
regexp.o: regexp.c
	$(CC) $(CFLAGS) $(DEFINES) $(TABLE_INCLUDES) -I. -I.. $(EXTN_INCLUDES) $(XAW3D_INCLUDES) -Wno-implicit-function-declaration -c -o $@ $<

# Generic rule for all other objects
%.o: %.c
	$(CC) $(CFLAGS_W) -c -o $@ $<

# ============================================================================
# Cleanup
# ============================================================================
clean:
	$(RM) $(OBJS) $(LIBRARY)

distclean: clean

# ============================================================================
# Dependencies
# ============================================================================
depend:
	@$(CC) $(CFLAGS_W) -MM $(SRCS) > .depend 2>/dev/null || true

-include .depend

.PHONY: all clean distclean depend