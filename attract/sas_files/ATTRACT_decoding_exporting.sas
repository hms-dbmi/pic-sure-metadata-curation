*Code used to decode and export ATTRACT study data;

libname ATTRACT "/home/sasuser/ATTRACT";

*ATTRACT format file was provided, so we loaded it using proc format as intended;
proc format cntlin=attract.attract_formats;
run;

*Export Files;
proc export data=attract.acoagchg outfile="/home/sasuser/ATTRACT/Output/acoagchg.csv";
delimiter=',';
run;

*Export Metadata for json generation in R;
proc datasets lib=attract;
contents data=_ALL_ out=attract.metadata;
run;

proc export data=attract.metadata outfile="/home/sasuser/ATTRACT/Output/attract_metadata.csv";
delimiter=',';
run;