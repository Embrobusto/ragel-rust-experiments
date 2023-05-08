RAGEL_C = ragel
RAGEL_RUST = ragel-rust
CC = gcc
RUSTC = rustc
OBJECTS = atoi.o params.o
RUST_RAGEL_SOURCES = $(wildcard *.rs.rl)
EXECUTABLES = $(OBJECTS:.o=_c) $(RUST_RAGEL_SOURCES:.rs.rl=_rust)
INTERMEDIATES = $(RUST_RAGEL_SOURCES:.rs.rl=.rs)
INTERMEDIATES += $(OBJECTS:.o=.c)
KEEP_INTERMEDIATES ?= 0

ifneq ($(KEEP_INTERMEDIATES),0)
    $(info [BUILD] Keeping intermediate sources)
    .PRECIOUS: %.c %.rs
else
    $(info [BUILD] Not keeping intermediate sources)
    .INTERMEDIATE: %.c %.rs
endif

$(info [BUILD] Intermediate $(.INTERMEDIATE))
$(info [BUILD] Executables: $(EXECUTABLES))

all: $(EXECUTABLES)

clean:
	@echo [CLEAN]
	find . -name '*.o' | xargs -n 1 rm -f
	find . -name '*.ri' | xargs -n 1 rm -f
	rm -f $(EXECUTABLES)
	rm -f $(INTERMEDIATES)

%_c: %.o
	@echo [CC] $@
	@$(CC) -o $@ $^ -fPIC

%_rust: %.rs
	@echo [RUSTC] $@
	@$(RUSTC) $< -o $@

%.rs: %.rs.rl
	@echo [RAGEL] $@
	@$(RAGEL_RUST) $< -o $*.rs

%.c: %.c.rl
	@echo [RAGEL_C] $<
	@$(RAGEL_C) $< -o $*.c

%.o: %.c
	@echo [CC] $<
	@$(CC) -c -Wall $< -o $*.o
