#This is an example of Makefile

PROGRAM = test
ARCH    = powerpc
OS      = ose (or linux)

#header directory
INCDIRS += 

#source directory
SRCDIRS += .

include dusg2.mk

include Common.mk
