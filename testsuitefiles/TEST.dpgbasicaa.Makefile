##===- TEST.dpgbasicaa.Makefile ---------------------------*- Makefile -*-===##
#
# Usage: 
#     make TEST=dpgbasicaa (detailed list with time passes, etc.)
#     make TEST=dpgbasicaa report
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
	$(PROJ_SRC_ROOT)/TEST.dpgbasicaa.Makefile 
	$(VERB) $(RM) -f $@
	@echo "---------------------------------------------------------------" >> $@
	@echo ">>> ========= '$(RELDIR)/$*' Program" >> $@
	@echo "---------------------------------------------------------------" >> $@
	@opt -mem2reg -instnamer -loop-simplify $< -o $<.mem.bc 2>>$@
	@opt -load TaskMiner.dylib -basicaa -aa-eval -ModuleDepGraph -stats $<.mem.bc -o $<.mem.bc 2>>$@ 