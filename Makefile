rad-eo.obo:
	blip ontol-query -r eo -query "class(R,'radiation treatment'),subclassRT(ID,R)" -to obo > $@

rad-xco.obo:
	blip ontol-query -r obo/xco -query "class(R,'radiation exposure'),subclassRT(ID,R)" -to obo > $@

rad-zeco.obo:
	blip ontol-query -r zeco -query "class(R,'electromagnetic radiation experimental conditions'),subclassRT(ID,R)" -to obo > $

rad-snomed.obo:
	blip ontol-query -r snomed_tidy -query "class(R,'Exposure to radiation'),subclassRT(ID,R)" -to obo > $@

rad-ncit.obo:
	blip ontol-query -r ncit -query "class(R,'Electromagnetic Radiation'),subclassRT(ID,R)" -to obo > $@



