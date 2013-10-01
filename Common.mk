#TODO list:
# 1) If a header file is renamed, autodependency will not work by
#    complaining the file not existing. 
#    WA: make clean && make
#
#########################################################################
#!INPUT VARIABLES

#These variables should be defined

#PRAGRAM  : program name if an executable is to be built
#LIB      : library name if an library is to be built
#LIBTYPE  : library type (static or shared)

#INCDIRS  : the directory with header files
#SRCDIRS  : the directory with source files
#LIBDIRS  : the direcotry with libraries
#LIBS     : the (dynamic) libraries to be linked
#SLIBS    : the (static) libraries (with full path) to be linked
#CFILES   : (opt) the individual files
#CXXFILES : (opt) the individual files
#EXFILES  : (opt) the individual files to be excluded

#########################################################################
#!TOOLCHAIN

TOOLCHAIN_PREFIX ?= 

CPP := $(TOOLCHAIN_PREFIX)gcc
CC  := $(TOOLCHAIN_PREFIX)gcc
CXX := $(TOOLCHAIN_PREFIX)g++
AR  := $(TOOLCHAIN_PREFIX)ar
AS  := $(TOOLCHAIN_PREFIX)as
NM  := $(TOOLCHAIN_PREFIX)nm
OBJDUMP := $(TOOLCHAIN_PREFIX)objdump
OBJCOPY := $(TOOLCHAIN_PREFIX)objcopy
RANLIB  := $(TOOLCHAIN_PREFIX)ranlib
STRIP := $(TOOLCHAIN_PREFIX)strip

########################################################################
#!TOOLS

SCP ?= scp

#########################################################################
#!OUTPUT VARIABLES

ifdef PROGRAM
   TARGET = $(BINDIR)/$(PROGRAM)
else #LIB
   ifeq ($(LIBTYPE), static)
      TARGET = $(LIBDIR)/lib$(LIB).a
   else
      TARGET = $(LIBDIR)/lib$(LIB).so
   endif
endif

OBJDIR = obj/$(ARCH)
LIBDIR = lib/$(ARCH)
BINDIR = bin/$(ARCH)

#########################################################################
#!COMMON FLAGS

#debug
CFLAGS   += -g 
CXXFLAGS += -g

#optimization
CFLAGS   += -O
CXXFLAGS += -O

#warning
CFLAGS   += -Wall -Wextra
CXXFLAGS += -Wall -Wextra

#dialect
CFLAGS  += -std=gnu99


ifdef LIB
   ifeq ($(LIBTYPE), dynamic)
      CFLAGS   += -fPIC
      CXXFLAGS += -fPIC
   endif
endif

#########################################################################
#!PRE-PROCESSING

INCDIRS += $(SRCDIRS)

VPATH = $(INCDIRS) $(SRCDIRS) 

CFILES   += $(foreach dir, $(SRCDIRS), $(wildcard $(dir)/*.c)) 
CXXFILES += $(foreach dir, $(SRCDIRS), $(wildcard $(dir)/*.cc)) 

#SRCFILES += $(filter-out $(EXFILES), $(CFILES))
#SRCFILES += $(filter-out $(EXFILES), $(CXXFILES))

OBJECTS += $(patsubst %.c,$(OBJDIR)/%.o,$(notdir $(CFILES)))
OBJECTS += $(patsubst %.cc,$(OBJDIR)/%.o,$(notdir $(CXXFILES)))

CFLAGS   += $(patsubst %,-I%,$(INCDIRS))
CXXFLAGS += $(patsubst %,-I%,$(INCDIRS))
LDFLAGS  += $(patsubst %,-L%,$(LIBDIRS))
LDFLAGS  += $(patsubst %,-l%,$(LIBS))
LDFLAGS  += $(SLIBS)

#########################################################################
#!RECIPE

.PHONY: all dirs clean install

all:  dirs $(TARGET)

dirs:
	@mkdir -p $(OBJDIR) $(LIBDIR) $(BINDIR)

-include $(OBJECTS:.o=.d)

ifdef PROGRAM
ifeq ($(strip $(CXXFILES)),)
   $(TARGET): $(OBJECTS)
	$(CC) -o $@ $^ $(LDFLAGS) 
else
   $(TARGET): $(OBJECTS)
	$(CXX) -o $@ $^ $(LDFLAGS) 
endif
else #LIB
   ifeq ($(LIBTYPE), static)
      $(TARGET): $(OBJECTS)
	$(AR) rcs $@ $^
   else  #shared LIB
      ifeq ($(strip $(CXXFILES)),)
         $(TARGET): $(OBJECTS)
		$(CC) -shared -o $@ $(LDFLAGS) $^
      else
         $(TARGET): $(OBJECTS)
		$(CXX) -shared -o $@ $(LDFLAGS) $^
      endif
   endif
endif

$(OBJDIR)/%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@
	$(CC) $(CFLAGS) -M -MT $@ $< > $(@:.o=.d)
	
$(OBJDIR)/%.o: %.cc
	$(CXX) $(CXXFLAGS) -c $< -o $@
	$(CXX) $(CXXFLAGS) -M -MT $@ $< > $(@:.o=.d)

clean:
	rm -f  $(OBJECTS) $(OBJECTS:.o=.d) $(TARGET)

install:
	$(SCP) $(TARGET) $(DEST)
