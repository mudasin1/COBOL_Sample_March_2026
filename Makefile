# Local build uses GnuCOBOL (cobc). z/OS batch uses JCL in jcl/.
COBC      ?= cobc
COBCFLAGS ?= -I cpy -O2
BIN_DIR   := build/bin
T         := tests

.PHONY: all clean test dirs

DRIVER_NB   := $(BIN_DIR)/driver-nbuw001
DRIVER_SVC  := $(BIN_DIR)/driver-svcbill001
DRIVER_CLM  := $(BIN_DIR)/driver-clmadj001

all: dirs $(DRIVER_NB) $(DRIVER_SVC) $(DRIVER_CLM)

dirs:
	@mkdir -p $(BIN_DIR)

$(DRIVER_NB): cobol/drivers/DRIVER-NBUW001.cob cobol/NB-UW-001.cob cpy/POLDATA.cpy | dirs
	$(COBC) $(COBCFLAGS) -x -o $@ cobol/drivers/DRIVER-NBUW001.cob cobol/NB-UW-001.cob

$(DRIVER_SVC): cobol/drivers/DRIVER-SVCBILL001.cob cobol/SVC-BILL-001.cob cpy/POLDATA.cpy | dirs
	$(COBC) $(COBCFLAGS) -x -o $@ cobol/drivers/DRIVER-SVCBILL001.cob cobol/SVC-BILL-001.cob

$(DRIVER_CLM): cobol/drivers/DRIVER-CLMADJ001.cob cobol/CLM-ADJ-001.cob cpy/POLDATA.cpy | dirs
	$(COBC) $(COBCFLAGS) -x -o $@ cobol/drivers/DRIVER-CLMADJ001.cob cobol/CLM-ADJ-001.cob

clean:
	rm -rf build

test: all
	sh $(T)/run-tests.sh
