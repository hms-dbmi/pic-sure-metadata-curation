* Used for manually decoding the ORCHID dataset for PIC-SURE;

* Set library;
libname orcin "/home/sasuser/ORCHID";

* Read in alldata.csv - alldata.sas7bdat was corrupt;
* Got error "shorter than expected";
FILENAME NALLDATA '/home/sasuser/ORCHID/alldata.csv' TERMSTR=NL;

* Add to library;
PROC IMPORT DATAFILE=NALLDATA
	DBMS=CSV
	OUT=orcin.NALLDATA;
	GETNAMES=YES;
	DATAROW=2;
	GUESSINGROWS=680;
RUN;

* Apply formats.csv;
FILENAME fmts '/home/sasuser/ORCHID/formats.csv' TERMSTR=nl;

PROC IMPORT DATAFILE=fmts
	DBMS=CSV replace
	OUT=work.fmts;
	GETNAMES=YES;
	DATAROW=2;
	GUESSINGROWS=1211;
RUN;

proc format cntlin = work.fmts;

* Export metadata;
proc datasets lib=orcin;
contents data=_ALL_ out=orcin.metadata;
run;
