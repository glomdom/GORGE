SML := sml
SMLFLAGS := -Cprint.depth=10

CM_FILES := gorge.cm

SRC := src/*.sig src/*.sml

all: compile

compile: $(SRC)
	$(SML) $(SMLFLAGS) -m $(CM_FILES)