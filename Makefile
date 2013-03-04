#This is an example of Makefile

PROGRAM = test
ARCH    = powerpc
OS      = ose

#header directory
INCDIRS += 

#source directory
SRCDIRS += .

include dusg2.mk

include Common.mk
