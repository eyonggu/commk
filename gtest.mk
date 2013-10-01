GTEST_ROOT := /home/eyonggu/3pp/gtest-1.7.0

INCDIRS += $(GTEST_ROOT)/include
SLIBS   += $(GTEST_ROOT)/lib/.libs/libgtest.a
SLIBS   += $(GTEST_ROOT)/lib/.libs/libgtest_main.a

LIBS += pthread
