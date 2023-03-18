# Name of the filter file, *with* `.lua` file extension.
FILTER_FILE := $(wildcard *.lua)

# Allow to use a different pandoc binary, e.g. when testing.
PANDOC ?= pandoc
# Allow to adjust the diff command if necessary
DIFF = diff

# Use special expected output file if it exists.
expected_output = test/expected.$(PANDOC_VERSION).txt
ifeq ($(wildcard $(expected_output)),)
expected_output = test/expected.txt
endif

test: test/input.md $(FILTER_FILE)
	@$(PANDOC) -d test/test.yaml \
	    | $(DIFF) $(expected_output) -

.PHONY: test
