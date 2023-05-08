RAGEL_C = ragel
RAGEL_RUST = ragel-rust
CC = gcc
EXECUTABLES := atoi_c
OBJECTS := *.o

all: $(EXECUTABLES)

clean:
	@echo [CLEAN]
	find . -name '*.o' | xargs -n 1 rm -f
	find . -name '*.ri' | xargs -n 1 rm -f
	rm -f $(EXECUTABLES)

atoi_c: $(OBJECTS)
	@echo [CC] $@
	@$(CC) -o $@ $^ -fPIC

%.c: %.c.rl
	@echo [RAGEL_C] $<
	@$(RAGEL_C) $< -o $*.c
	@cat $*.c

%.o: %.c
	@echo [CC] $<
	@$(CC) -c -Wall $< -o $*.o
