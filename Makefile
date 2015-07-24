# copyright (c) 2015, guillaume bury

LOG=build.log
COMP=ocamlbuild -log $(LOG) -use-ocamlfind -classic-display
FLAGS=
DIRS=-Is subsystems,hierarchy,util
DOC=cgroups.docdir/index.html

NAME=cgroups

LIB=$(addprefix $(NAME), .cma .cmxa .cmxs)

all: lib

lib:
	$(COMP) $(FLAGS) $(DIRS) $(LIB)

doc:
	$(COMP) $(FLAGS) $(DIRS) $(DOC)

log:
	cat _build/$(LOG) || true

clean:
	$(COMP) -clean

TO_INSTALL=META $(addprefix _build/,$(LIB) $(NAME).a $(NAME).cmi)

install: lib
	ocamlfind install $(NAME) $(TO_INSTALL)

uninstall:
	ocamlfind remove $(NAME)

reinstall: all
	ocamlfind remove $(NAME) || true
	ocamlfind install $(NAME) $(TO_INSTALL)

.PHONY: clean doc all install uninstall reinstall
