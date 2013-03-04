#This is DUSg2 common of Makefile

PROJECTHOME  = /proj/rt_tn/usr/eyonggu/tn-comps
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
   LDLIBS += linx lits xte coli sds
endif

CFLAGS   += -m32 -mhard-float -DNCP_LINUX -DNCP_BIG_ENDIAN -DPROC_PPC476 -DDEBUG --sysroot $(SYSROOT)/$(ARCH)
CXXFLAGS += -m32 -mhard-float -DNCP_LINUX -DNCP_BIG_ENDIAN -DPROC_PPC476 -DDEBUG --sysroot $(SYSROOT)/$(ARCH)
LDFLAGS  += --sysroot $(SYSROOT)/$(ARCH)
ifeq ($(OS), ose)
   LDFLAGS  += -Wl,--wrap,main -Wl,-rpath,$(RCSIFDIR)/rcs-rhai/lib/$(ARCH)
endif

#for install
SCP = scp_put
DEST = /srv/netboot/users/eyonggu/nand/bootfs/mnt/homepartition1/sirpa/software/TN-TCU_CXP9022846_1_eyonggu_udpsh_0227_4f9c4a4_20130228-1422/bin


