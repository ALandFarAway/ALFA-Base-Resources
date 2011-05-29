#
# This makefile represents the baseline recursive makefile for the project
# tree.  Each subdirectory that desires to recurse into a child subdirectory
# ultimately includes this makefile.
#
# The makefile is structured so that the "dirs" file in the current directory
# is included, defining a DIRS= macro naming the list of directories that are
# to be recursed into.  These directories may either follow with a subsequent
# "dirs" file and an include makefile, or may define actual build targets with
# a local makefile.
#

!include makefile.def
!include dirs
!include recurse.mk
