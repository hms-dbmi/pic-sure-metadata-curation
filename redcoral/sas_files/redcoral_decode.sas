* Decoding RED CORAL dataset for PIC-SURE upload;

* Set data folder as library;
libname redcoral '/home/sasuser/red_coral/data/Data/SAS_files';

* Load in formats.csv file to use as SAS formats;
FILENAME REFFILE1 '/home/sasuser/red_coral/data/Data/CSV_files/formats.csv' TERMSTR=NL;

PROC IMPORT DATAFILE=REFFILE1
	DBMS=CSV
	OUT=WORK.IMPORT;
	GETNAMES=YES;
	DATAROW=2;
	GUESSINGROWS=1344; * Argument helps SAS read file correctly;
RUN;

* Some slight issues with the given CSV file that were corrected;
filename reffile2 '/home/sasuser/red_coral/data/Data/CSV_files/formats1.csv' TERMSTR=NL;
PROC IMPORT DATAFILE=REFFILE2
	DBMS=CSV
	OUT=WORK.redcoral;
	GETNAMES=YES;
	DATAROW=2;
	GUESSINGROWS=1344;
RUN;

* Apply the formats1.csv file (work.redcoral) as formats;
proc format cntlin = work.redcoral;

* View contents;
proc contents data=redcoral.redcoral;* out=redcoral.fmts2;
run;

* Save output from contents;
proc contents data=work.import2 out=redcoral.fmts;
run;

* Export decoded data as the CSV file;
proc export data=redcoral.redcoral 
		outfile="/home/sasuser/red_coral/redcoral_decoded_newsearch.csv";
	delimiter=',';
run;

* Save dataset contents as metadata - later saved as CSV to use for JSON metadata correction;
proc datasets lib=redcoral;
contents data=_ALL_ out=fusitest.metadata;
run;