OUT_NAME = memory.a

#
# LIBRARY UNIVERSAL MAKEFILE
#

SRC_C_FILES = $(shell find src -name "*.c")
SRC_H_FILES = $(shell find src -name "*.h")
BUILD_OBJ_FILES = $(SRC_C_FILES:src/%.c=.build/src/%.o)
BUILD_OBJ_DIRS = $(sort $(dir $(BUILD_OBJ_FILES)))
OUTPUT_H_FILES = $(SRC_H_FILES:src/%.h=output/%.h)

TESTS_C_FILES = $(shell find tests -name "*.c")
TESTS_H_FILES = $(shell find tests -name "*.h")
TESTS_O_FILES = $(TESTS_C_FILES:tests/%.c=.build/tests/%.o)
TESTS_O_DIRS = $(sort $(dir $(TESTS_O_FILES)))

all: output/$(OUT_NAME) $(OUTPUT_H_FILES)

output/$(OUT_NAME): $(dir ./output/) $(BUILD_OBJ_DIRS) $(BUILD_OBJ_FILES)
	ar rsc $@ $(BUILD_OBJ_FILES)

$(BUILD_OBJ_DIRS) $(TESTS_O_DIRS): %:
	mkdir -p $@

$(OUTPUT_H_FILES): output/%.h: src/%.h
	cp $< $@

$(BUILD_OBJ_FILES): .build/src/%.o: src/%.c $(SRC_H_FILES)
	gcc -c $< -I . -o $@

$(TESTS_O_FILES): .build/tests/%.o: tests/%.c $(TESTS_O_DIRS) $(OUTPUT_H_FILES) $(TESTS_H_FILES)
	gcc -c $< -I output -I . -o $@

$(dir ./output/):
	mkdir -p $@

test: all output/test_bin
	./output/test_bin

output/test_bin: $(TESTS_O_FILES) output/$(OUT_NAME)
	gcc $^ -o $@

clean:
	rm -rf .build

cleanall: clean
	rm -rf output

rebuild: cleanall all

.PHONY: all test clean cleanall rebuild
