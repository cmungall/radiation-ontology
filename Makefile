rad-eo.obo:
	blip ontol-query -r eo -query "class(R,'radiation treatment'),subclassRT(ID,R)" -to obo > $@

rad-xco.obo:
	blip ontol-query -r obo/xco -query "class(R,'radiation exposure'),subclassRT(ID,R)" -to obo > $@

