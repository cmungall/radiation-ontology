all: probs.tsv m.tsv unmapped.tsv rpt.html merged-rad.obo axioms-r.obo 

rad-eo.obo:
	blip ontol-query -r eo -query "class(R,'radiation treatment'),subclassRT(ID,R)" -to obo > $@

rad-xco.obo:
	blip ontol-query -r obo/xco -query "class(R,'radiation exposure'),subclassRT(ID,R)" -to obo > $@

rad-zeco.obo:
	blip ontol-query -r zeco -query "class(R,'electromagnetic radiation experimental conditions'),subclassRT(ID,R)" -to obo > $

rad-snomed.obo:
	blip ontol-query -r snomed_tidy -query "class(R,'Exposure to radiation'),subclassRT(ID,R)" -to obo | perl -npe 's@SCTID_@SCTID:@g' > $@

rad-ncit.obo:
	blip ontol-query -r ncit -query "class(R,'Electromagnetic Radiation'),subclassRT(ID,R)" -to obo > $@

rad-go.obo:
	blip ontol-query -r go -query "class(R,'response to radiation'),subclassRT(ID,R)" -to obo | obo-grep.pl -r 'name: response to' - > $@

rad-pato.obo:
	blip ontol-query -r pato -query "class(R,'radiation quality'),subclassRT(ID,R)" -to obo  > $@



combined-rad.obo:
	obo-cat.pl rad-*.obo | grep -v ^namespace: | grep -v ^property_value: | ./add-syns.pl > $@

probs.tsv: combined-rad.obo ignore.pro
	blip-findall  -i ignore.pro -debug index -goal nlp_index_all -i $< -u metadata_nlp entity_pair_mprobs/6 -no_pred > $@

m.tsv: combined-rad.obo ignore.pro
	blip-findall  -i ignore.pro -debug index -goal nlp_index_all -i $< -u metadata_nlp entity_pair_label_match/6 -label -no_pred > $@

unmapped.tsv: combined-rad.obo ignore.pro
	blip-findall  -i ignore.pro -debug index -goal nlp_index_all -i $< -u metadata_nlp "entity_nomatch/1" -label -no_pred > $@

OBO=http://purl.obolibrary.org/obo
combined-rad.owl: combined-rad.obo
	owltools $< --set-ontology-id $(OBO)/rad.owl -o $@

MAX_E=8
axioms.owl: combined-rad.owl probs.tsv
	kboom --experimental  --splitSize 50 --max $(MAX_E) -m rpt.md -j rpt.json -n -o $@ -t probs.tsv $<

rpt.html: axioms.owl
	pandoc rpt.md -o rpt.html

axioms.obo: axioms.owl
	owltools $< combined-rad.owl --set-ontology-id $(OBO)/rad/axioms -o -f obo $@

axioms-r.obo: combined-rad.obo  axioms.obo
	obo-add-comments.pl -r -t id -t equivalent_to -t is_a $^ > $@

ORD = xx NCIT 10 xx EO 8 xx ZECO 6 xx XCO 4
ORD_C = echo $(patsubst xx,-c,$(ORD))
ORD_D = echo $(patsubst xx,-D,$(ORD))
ORD_L = echo $(patsubst xx,-l,$(ORD))
#PRIORITIES := -l NCIT 10 -l EO 8 -l ZECO 5  -s NCIT 10 -s EO 8 -s ZECO 5 

merged-rad.owl: combined-rad.owl axioms.owl
	owltools $^ --merge-support-ontologies --reasoner elk --merge-equivalence-sets $(ORD_C) $(ORD_D) $(ORD_L) --set-ontology-id $(OBO)/rad.owl -o $@
.PRECIOUS: merged-rad.owl

merged-rad.obo: merged-rad.owl
	owltools $< -o -f obo --no-check $@

merged-rad.hier: merged-rad.obo
	blip ontol-subset -i $< -n % > $@

merged-rad.png: merged-rad.obo
	blip ontol-subset -i $< -n $< -to png -u ontol_config_rad  -n % > $@
