GTEST_ROOT := /home/eyonggu/3pp/gtest-1.7.0
GMOCK_ROOT := /home/eyonggu/3pp/gmock-1.7.0

INCDIRS += $(GTEST_ROOT)/include
SLIBS   += $(GTEST_ROOT)/lib/.libs/libgtest.a
#SLIBS   += $(GTEST_ROOT)/lib/.libs/libgtest_main.a

INCDIRS += $(GMOCK_ROOT)/include
SLIBS   += $(GMOCK_ROOT)/lib/.libs/libgmock.a
SLIBS   += $(GMOCK_ROOT)/lib/.libs/libgmock_main.a

LIBS += pthread
