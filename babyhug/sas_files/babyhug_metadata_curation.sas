* BABY HUG metadata curation;
* Generation of the metadata file used to generate JSON;
* Be sure to run the babyhug_decode.sas program first to load appropriate formats and set up libraries;


proc datasets lib=fusitest;
contents data=_ALL_ out=fusitest.metadata;
run;


proc datasets lib=fusii;
contents data=_ALL_ out=fusii.metadata;
run;

proc datasets lib=phaseiii;
contents data=_ALL_ out=phaseiii.metadata;
run;