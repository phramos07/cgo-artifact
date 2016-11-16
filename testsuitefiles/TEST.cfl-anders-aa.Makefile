##===- TEST.cfl-aa.Makefile ---------------------------*- Makefile -*-===##
#
# Usage: 
#     make TEST=cfl-aa (detailed list with time passes, etc.)
#     make TEST=cfl-aa report
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
	$(PROJ_SRC_ROOT)/TEST.cfl-anders-aa.Makefile 
	$(VERB) $(RM) -f $@
	@echo "---------------------------------------------------------------" >> $@
	@echo ">>> ========= '$(RELDIR)/$*' Program" >> $@
	@echo "---------------------------------------------------------------" >> $@
	@/Users/pedroramos/programs/llvm-other-versions/llvmbuild/bin/opt -mem2reg -instnamer $< -o $<.mem.bc 2>>$@
	@/Users/pedroramos/programs/llvm-other-versions/llvmbuild/bin/opt -cfl-anders-aa -aa-eval $<.mem.bc -o $<.mem.bc 2>>$@ 