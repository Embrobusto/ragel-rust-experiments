RAGEL_C = ragel
RAGEL_RUST = ragel-rust
CC = gcc
OBJECTS = atoi.o params.o
EXECUTABLES = $(OBJECTS:.o=_c)
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

%_c: %.o
	@echo [CC] $@
	@$(CC) -o $@ $^ -fPIC

%.c: %.c.rl
	@echo [RAGEL_C] $<
	@$(RAGEL_C) $< -o $*.c

%.o: %.c
	@echo [CC] $<
	@$(CC) -c -Wall $< -o $*.o
