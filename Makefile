# copyright (c) 2015, guillaume bury

NAME=cgroups

all: lib

lib:
	dune build @install -p $(NAME)

doc:
	dune build @doc -p $(NAME)

log:
	cat _build/log || true

clean:
	dune clean

.PHONY: clean doc all
