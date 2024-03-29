SML := sml
SMLFLAGS := -Cprint.depth=10

MLTON := mlton

CM_FILE := gorge.cm
MLB_FILE := gorge.mlb

CM_TEST_FILE := gorge-test.cm
TEST_BIN := gorge-test

BIN = gorge

SRC := src/*.sig src/*.sml
TEST_SRC := test/*.sml

VENDOR_DIR := vendor

MLUNIT := $(VENDOR_DIR)/mlunit
MLUNIT_URL := https://github.com/eudoxia0/mlunit.git

PARSIMONY := $(VENDOR_DIR)/parsimony
PARSIMONY_URL := https://github.com/eudoxia0/parsimony.git

DEPS := $(MLUNIT) $(PARSIMONY)

all: compile

$(VENDOR_DIR):
	mkdir -p $(VENDOR_DIR)

$(PARSIMONY): $(VENDOR_DIR)
	@[ -d "$(VENDOR_DIR)/parsimony/" ] || echo "cloning parsimony"
	@[ -d "$(VENDOR_DIR)/parsimony/" ] || git clone $(PARSIMONY_URL) $(PARSIMONY) >/dev/null 2>&1

$(MLUNIT): $(VENDOR_DIR)
	@[ -d "$(VENDOR_DIR)/mlunit/" ] || echo "cloning mlunit"
	@[ -d "$(VENDOR_DIR)/mlunit/" ] || git clone $(MLUNIT_URL) $(MLUNIT) >/dev/null 2>&1

compile: $(SRC) $(DEPS)
	$(SML) $(SMLFLAGS) -m $(CM_FILE)

$(BIN): $(SRC) $(DEPS)
	$(MLTON) $(MLB_FILE)

$(TEST_BIN): $(SRC) $(TEST_SRC) $(DEPS)
	$(SML) $(SMLFLAGS) -m $(CM_TEST_FILE)

.PHONY: test
test: $(TEST_BIN)

clean:
	rm -rf src/.cm/ test/.cm/ $(VENDOR_DIR)
	rm -f $(TEST_BIN)