##===- TEST.basicaa.Makefile ---------------------------*- Makefile -*-===##
#
# Usage: 
#     make TEST=basicaa (detailed list with time passes, etc.)
#     make TEST=basicaa report
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
	$(PROJ_SRC_ROOT)/TEST.basicaa.Makefile 
	$(VERB) $(RM) -f $@		
	@echo "---------------------------------------------------------------" >> $@
	@echo ">>> ========= '$(RELDIR)/$*' Program" >> $@
	@echo "---------------------------------------------------------------" >> $@
	@opt -mem2reg -instnamer $< -o $<.mem.bc 2>>$@
	@opt -basicaa -aa-eval $<.mem.bc -o $<.mem.bc 2>>$@ 