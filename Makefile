#This is an example of Makefile

PROGRAM = test

#header directory
INCDIRS += files/include

#source directory
SRCDIRS += files/src

#library directory
LIBDIRS += somewhere/lib

#libaraies
LDLIBS += somelib

CFLAGS   += -m32 -mhard-float -DNCP_LINUX -DNCP_BIG_ENDIAN -DPROC_PPC476 -DDEBUG --sysroot $(SYSROOT)/$(ARCH)
CXXFLAGS += -m32 -mhard-float -DNCP_LINUX -DNCP_BIG_ENDIAN -DPROC_PPC476 -DDEBUG --sysroot $(SYSROOT)/$(ARCH)
LDFLAGS  += --sysroot $(SYSROOT)/$(ARCH)

include Common.mk
