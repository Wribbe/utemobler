DIR_BIN := bin

all: bom

${DIR_BIN}:
	@[ -d $@ ] || mkdir $@

bom: bom.c | ${DIR_BIN}
	gcc -g $(filter %.c, $^) -o ${DIR_BIN}/$@

.PHONY: dir_bin
