##===- TEST.basicaa-sraa.Makefile ---------------------------*- Makefile -*-===##
#
# Usage: 
#     make TEST=basicaa-sraa (detailed list with time passes, etc.)
#     make TEST=basicaa-sraa report
#
##===----------------------------------------------------------------------===##

CURDIR  := $(shell cd .; pwd)
PROGDIR := $(PROJ_SRC_ROOT)
RELDIR  := $(subst $(PROGDIR),,$(CURDIR))

$(PROGRAMS_TO_TEST:%=test.$(TEST).%): \
test.$(TEST).%: Output/%.$(TEST).report.txt
	@cat $<

$(PROGRAMS_TO_TEST:%=Output/%.$(TEST).report.txt):  \
Output/%.$(TEST).report.txt: Output/%.linked.rbc $(LOPT) \
	$(PROJ_SRC_ROOT)/TEST.basicaa-sraa.Makefile 
	$(VERB) $(RM) -f $@		
	@echo "---------------------------------------------------------------" >> $@
	@echo ">>> ========= '$(RELDIR)/$*' Program" >> $@
	@echo "---------------------------------------------------------------" >> $@
	@opt -mem2reg -instnamer $< -o $<.mem.bc 2>>$@
	@opt -load obaa.dylib -break-crit-edges -vssa -sraa -basicaa -aa-eval $<.mem.bc -o $<.mem.bc 2>>$@ 