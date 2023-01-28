# Variables
DKCHECK      ?= dk check
DKDEP        ?= dk dep
BUILD_FOLDER = src
DKS = $(wildcard $(BUILD_FOLDER)/*.dk)
DKOS = $(DKS:.dk=.dko)


.PHONY: all check clean

all: plth logic check

# Generate the dependencies of [.dk] files
depend: $(BUILD_FOLDER)
	$(DKDEP) -I $(BUILD_FOLDER) $(BUILD_FOLDER)/*.dk > .depend


plth: plth.dk
	$(DKCHECK) -I $(BUILD_FOLDER) --eta -e plth.dk

logic: logic.dk
	$(DKCHECK) -I $(BUILD_FOLDER) --eta -e logic.dk

# Make sure .depend is generated then do the actual check
check: depend
	make actual_check

# Check and compile the generated [.dk]
actual_check: $(DKOS)

%.dko: %.dk | $(BUILD_FOLDER)
	$(DKCHECK) -I $(BUILD_FOLDER) --eta -e $<

clean:
	rm -f $(BUILD_FOLDER)/*.dko
	rm -f .depend

-include .depend
