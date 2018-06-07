all: bom

bom: bom.txt

bom.txt: scad/sofa.scad
	@openscad scad/sofa.scad -o test.csg  2> bom.txt
	@rm test.csg
	./bom.py

.PHONY: bom