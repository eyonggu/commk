#########################################################################
#!TOOLCHAIN

CROSSTOOLCHAIN_PATH := /app/rbs/wrtools/5.0.1d2

ARCH ?= powerpc

ifeq ($(ARCH), powerpc)
   TOOLCHAIN_PREFIX := $(CROSSTOOLCHAIN_PATH)/bin/powerpc-wrs-linux-gnu-
else
   TOOLCHAIN_PREFIX := 
endif

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

TARGET = $(BINDIR)/$(PROGRAM)

OBJDIR = obj/$(ARCH)
LIBDIR = lib/$(ARCH)
BINDIR = bin/$(ARCH)



#########################################################################
#!INPUT VARIABLES

#These variables should be defined
#INCDIRS  : the directory with header files
#SRCDIRS  : the directory with source files
#LIBDIRS  : the direcotry with libraries
#LDLIBS   : the libraries to be linked
#CFILES   : (opt) the individual files
#CXXFILES : (opt) the individual files
#EXFILES  : (opt) the individual files to be excluded


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


#########################################################################
#!PRE-PROCESSING

INCDIRS += $(SRCDIRS)

VPATH = $(INCDIRS) $(SRCDIRS) 

CFILES   += $(foreach dir, $(SRCDIRS), $(wildcard $(dir)/*.c)) 
CXXFILES += $(foreach dir, $(SRCDIRS), $(wildcard $(dir)/*.cc)) 

#CFILES   := $(filter-out $(EXFILES), $(CFILES))
#CXXFILES := $(filter-out $(EXFILES), $(CXXFILES))

OBJECTS  = $(patsubst %.c,$(OBJDIR)/%.o,$(notdir $(CFILES)))
OBJECTS += $(patsubst %.cc,$(OBJDIR)/%.o,$(notdir $(CXXFILES)))

CFLAGS   += $(patsubst %,-I%,$(INCDIRS))
CXXFLAGS += $(patsubst %,-I%,$(INCDIRS))
LDFLAGS  += $(patsubst %,-L%,$(LIBDIRS))
LDFLAGS  += $(patsubst %,-l%,$(LDLIBS))



#########################################################################
#!RECIPE

.PHONY: all dirs clean install

all:  dirs $(TARGET)

dirs:
	@mkdir -p $(OBJDIR) $(LIBDIR) $(BINDIR)

ifeq ($(strip $(CXXFILES)),)
   $(TARGET): $(OBJECTS)
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@ 
else
   $(TARGET): $(OBJECTS)
        @echo $(CFILES)
	$(CXX) $(OBJECTS) -$(LDFLAGS) o $@ 
endif

$(OBJDIR)/%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@
	
$(OBJDIR)/%.o: %.cc
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	rm -f  $(OBJECTS) $(TARGET)

install:
	$(SCP) $(TARGET) $(DEST)
