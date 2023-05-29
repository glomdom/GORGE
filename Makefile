SML := sml
SMLFLAGS := -Cprint.depth=10

MLTON := mlton

CM_FILE := gorge.cm
MLB_FILE := gorge.mlb

MLB_TEST_FILE := gorge-test.mlb
TEST_BIN := gorge-test

SRC := src/*.sig src/*.sml

VENDOR_DIR := vendor
MLUNIT := $(VENDOR_DIR)/mlunit
MLUNIT_URL := https://github.com/eudoxia0/mlunit.git

all: compile

$(VENDOR_DIR):
	mkdir -p $(VENDOR_DIR)

$(MLUNIT): $(VENDOR_DIR)
	git clone $(MLUNIT_URL) $(MLUNIT) >/dev/null 2>&1 

compile: $(SRC)
	$(SML) $(SMLFLAGS) -m $(CM_FILE)

test: $(SRC) $(MLUNIT)
	$(MLTON) $(MLB_TEST_FILE)
	@./gorge-test

clean:
	rm -rf src/.cm/ $(VENDOR_DIR)