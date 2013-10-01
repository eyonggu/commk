#This is DUSg2 common of Makefile

CROSSTOOLCHAIN_PATH := /app/rbs/wrtools/5.0.1d2

ARCH ?= powerpc

ifeq ($(ARCH), powerpc)
   TOOLCHAIN_PREFIX := $(CROSSTOOLCHAIN_PATH)/bin/powerpc-wrs-linux-gnu-
else
   TOOLCHAIN_PREFIX := 
endif

PROJECTHOME  = /proj/rt_tn/usr/${USER}/tn-comps
SYSROOT  = $(PROJECTHOME)/build/devfs/dus41/rcs-distro
RCSIFDIR = $(PROJECTHOME)/build/devfs/dus41

#header directory
ifeq ($(OS), ose)
   INCDIRS += $(RCSIFDIR)/rcs-coli/include
   INCDIRS += $(RCSIFDIR)/rcs-liblits/include
   INCDIRS += $(RCSIFDIR)/rcs-xte/include
   INCDIRS += $(RCSIFDIR)/rcs-linx/include
   INCDIRS += $(RCSIFDIR)/rcs-linxns/include
   INCDIRS += $(RCSIFDIR)/rcs-libsds/include
endif

#library directory
LIBDIRS += $(SYSROOT)/$(ARCH)/usr/lib
LIBDIRS += $(SYSROOT)/$(ARCH)/lib
ifeq ($(OS), ose)
   LIBDIRS += $(RCSIFDIR)/rcs-coli/lib/$(ARCH)
   LIBDIRS += $(RCSIFDIR)/rcs-liblits/lib/$(ARCH)
   LIBDIRS += $(RCSIFDIR)/rcs-xte/lib/$(ARCH)
   LIBDIRS += $(RCSIFDIR)/rcs-linx/lib/$(ARCH)
   LIBDIRS += $(RCSIFDIR)/rcs-libsds/lib/$(ARCH)
endif

#libaraies
ifeq ($(OS), ose)
   LIBS += linx lits xte coli sds
endif

CFLAGS   += -m32 -mhard-float -DNCP_LINUX -DNCP_BIG_ENDIAN -DPROC_PPC476 -DDEBUG --sysroot $(SYSROOT)/$(ARCH)
CXXFLAGS += -m32 -mhard-float -DNCP_LINUX -DNCP_BIG_ENDIAN -DPROC_PPC476 -DDEBUG --sysroot $(SYSROOT)/$(ARCH)
LDFLAGS  += --sysroot $(SYSROOT)/$(ARCH)
#LDFLAGS  += -Wl,-rpath,$(RCSIFDIR)/rcs-rhai/lib/$(ARCH)
ifeq ($(OS), ose)
   LDFLAGS  += -Wl,--wrap,main 
endif

#for install
SCP = scp_put
DEST = $(shell echo /srv/netboot/users/${USER}/nand/bootfs/mnt/rootfs1/software/TN-TCU_*/bin)


