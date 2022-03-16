* SAS code used to decode MSH data;

* Code to load the Clinical format file (clin_fmts.sas7bdat);
libname fmt1 '/home/sasuser/MSH/Clinical/format';
proc format cntlin = fmt1.clin_fmts;
* After running this code, the format was automatically applied to the other sas7bdat files;

* Set library to Data file, then export files as CSV;
libname clinical '/home/sasuser/MSH/Clinical/Data';
proc export data=clinical.courses outfile="/home/sasuser/MSH/output/clinical_courses.csv"
	;
	delimiter=',';
	run;
proc export data=clinical.crc outfile="/home/sasuser/MSH/output/clinical_crc.csv"
	;
	delimiter=',';
	run;
proc export data=clinical.curstops outfile="/home/sasuser/MSH/output/clinical_curstops.csv"
	;
	delimiter=',';
	run;
proc export data=clinical.endp96a outfile="/home/sasuser/MSH/output/clinical_endp96a.csv"
	;
	delimiter=',';
	run;
proc export data=clinical.f44_keep outfile="/home/sasuser/MSH/output/clinical_f44_keep.csv"
	;
	delimiter=',';
	run;
proc export data=clinical.form01 outfile="/home/sasuser/MSH/output/clinical_form01.csv"
	;
	delimiter=',';
	run;
proc export data=clinical.form02 outfile="/home/sasuser/MSH/output/clinical_form02.csv"
	;
	delimiter=',';
	run;
proc export data=clinical.form03 outfile="/home/sasuser/MSH/output/clinical_form03.csv"
	;
	delimiter=',';
	run;
proc export data=clinical.form04 outfile="/home/sasuser/MSH/output/clinical_form04.csv"
	;
	delimiter=',';
	run;
proc export data=clinical.form05 outfile="/home/sasuser/MSH/output/clinical_form05.csv"
	;
	delimiter=',';
	run;
	
proc export data=clinical.form07 outfile="/home/sasuser/MSH/output/clinical_form07.csv"
	;
	delimiter=',';
	run;
proc export data=clinical.form08 outfile="/home/sasuser/MSH/output/clinical_form08.csv"
	;
	delimiter=',';
	run;
proc export data=clinical.form09 outfile="/home/sasuser/MSH/output/clinical_form09.csv"
	;
	delimiter=',';
	run;
proc export data=clinical.form11 outfile="/home/sasuser/MSH/output/clinical_form11.csv"
	;
	delimiter=',';
	run;
	
proc export data=clinical.form12 outfile="/home/sasuser/MSH/output/clinical_form12.csv"
	;
	delimiter=',';
	run;
proc export data=clinical.form14 outfile="/home/sasuser/MSH/output/clinical_form14.csv"
	;
	delimiter=',';
	run;
proc export data=clinical.form20 outfile="/home/sasuser/MSH/output/clinical_form20.csv"
	;
	delimiter=',';
	run;
proc export data=clinical.form22 outfile="/home/sasuser/MSH/output/clinical_form22.csv"
	;
	delimiter=',';
	run;
	
	
proc export data=clinical.form23 outfile="/home/sasuser/MSH/output/clinical_form23.csv"
	;
	delimiter=',';
	run;
proc export data=clinical.form25 outfile="/home/sasuser/MSH/output/clinical_form25.csv"
	;
	delimiter=',';
	run;
proc export data=clinical.form30 outfile="/home/sasuser/MSH/output/clinical_form30.csv"
	;
	delimiter=',';
	run;
proc export data=clinical.form31 outfile="/home/sasuser/MSH/output/clinical_form31.csv"
	;
	delimiter=',';
	run;
proc export data=clinical.form32 outfile="/home/sasuser/MSH/output/clinical_form32.csv"
	;
	delimiter=',';
	run;
proc export data=clinical.form33 outfile="/home/sasuser/MSH/output/clinical_form33.csv"
	;
	delimiter=',';
	run;
proc export data=clinical.form34 outfile="/home/sasuser/MSH/output/clinical_form34.csv"
	;
	delimiter=',';
	run;
proc export data=clinical.form35 outfile="/home/sasuser/MSH/output/clinical_form35.csv"
	;
	delimiter=',';
	run;
	
	
proc export data=clinical.form36 outfile="/home/sasuser/MSH/output/clinical_form36.csv"
	;
	delimiter=',';
	run;
proc export data=clinical.form37 outfile="/home/sasuser/MSH/output/clinical_form37.csv"
	;
	delimiter=',';
	run;
proc export data=clinical.form39 outfile="/home/sasuser/MSH/output/clinical_form39.csv"
	;
	delimiter=',';
	run;
proc export data=clinical.form44 outfile="/home/sasuser/MSH/output/clinical_form44.csv"
	;
	delimiter=',';
	run;
proc export data=clinical.form45 outfile="/home/sasuser/MSH/output/clinical_form45.csv"
	;
	delimiter=',';
	run;
proc export data=clinical.form64 outfile="/home/sasuser/MSH/output/clinical_form64.csv"
	;
	delimiter=',';
	run;
proc export data=clinical.form70 outfile="/home/sasuser/MSH/output/clinical_form70.csv"
	;
	delimiter=',';
	run;



proc export data=clinical.form73 outfile="/home/sasuser/MSH/output/clinical_form73.csv"
	;
	delimiter=',';
	run;
proc export data=clinical.form74 outfile="/home/sasuser/MSH/output/clinical_form74.csv"
	;
	delimiter=',';
	run;
proc export data=clinical.form75 outfile="/home/sasuser/MSH/output/clinical_form75.csv"
	;
	delimiter=',';
	run;
proc export data=clinical.lab outfile="/home/sasuser/MSH/output/clinical_lab.csv"
	;
	delimiter=',';
	run;
proc export data=clinical.lab_8wk outfile="/home/sasuser/MSH/output/clinical_lab_8wk.csv"
	;
	delimiter=',';
	run;
proc export data=clinical.msh outfile="/home/sasuser/MSH/output/clinical_msh.csv"
	;
	delimiter=',';
	run;
proc export data=clinical.rx outfile="/home/sasuser/MSH/output/clinical_rx.csv"
	;
	delimiter=',';
	run;
proc export data=clinical.scores outfile="/home/sasuser/MSH/output/clinical_scores.csv"
	;
	delimiter=',';
	run;
proc export data=clinical.visits outfile="/home/sasuser/MSH/output/clinical_visits.csv"
	;
	delimiter=',';
	run;

** Code to load the PFU format file (pfu_fmts.sas7bdat);
libname fmt2 '/home/sasuser/MSH/PFU/format';
proc format cntlin = fmt2.pfu_fmts;

libname pfu '/home/sasuser/MSH/PFU/Data';
filename output "/home/sasuser/MSH/output2/pfu_demo.csv" encoding='utf-8';
proc export data=pfu.demo outfile=output dbms='csv';
	run;
filename output "/home/sasuser/MSH/output2/pfu_fm40.csv" encoding='utf-8';
proc export data=pfu.fm40 outfile=output dbms='csv';
	run;
filename output "/home/sasuser/MSH/output2/pfu_fm42.csv" encoding='utf-8';
proc export data=pfu.fm42 outfile=output dbms='csv';
	run;
filename output "/home/sasuser/MSH/output2/pfu_fm43.csv" encoding='utf-8';
proc export data=pfu.fm43 outfile=output dbms='csv';
	run;
filename output "/home/sasuser/MSH/output2/pfu_fm44.csv" encoding='utf-8';
proc export data=pfu.fm44 outfile=output dbms='csv';
	run;
filename output "/home/sasuser/MSH/output2/pfu_fm47.csv" encoding='utf-8';
proc export data=pfu.fm47 outfile=output dbms='csv';
	run;
filename output "/home/sasuser/MSH/output2/pfu_fm48.csv" encoding='utf-8';
proc export data=pfu.fm48 outfile=output dbms='csv';
	run;
filename output "/home/sasuser/MSH/output2/pfu_fm49.csv" encoding='utf-8';
proc export data=pfu.fm49 outfile=output dbms='csv';
	run;
filename output "/home/sasuser/MSH/output2/pfu_fm50.csv" encoding='utf-8';
proc export data=pfu.fm50 outfile=output dbms='csv';
	run;
filename output "/home/sasuser/MSH/output2/pfu_fm55.csv" encoding='utf-8';
proc export data=pfu.fm55 outfile=output dbms='csv';
	run;
filename output "/home/sasuser/MSH/output2/pfu_fm66.csv" encoding='utf-8';
proc export data=pfu.fm66 outfile=output dbms='csv';
	run;
filename output "/home/sasuser/MSH/output2/pfu_hu_usag2.csv" encoding='utf-8';
proc export data=pfu.hu_usag2 outfile=output dbms='csv';
	run;
filename output "/home/sasuser/MSH/output2/pfu_patevts.csv" encoding='utf-8';
proc export data=pfu.patevts outfile=output dbms='csv';
	run;


** Code to load the EXT 1 format file (ext1_fmts.sas7bdat);
libname fmt3 '/home/sasuser/MSH/Ext_1/format';
proc format cntlin = fmt3. ext1_fmts;
libname ext1 '/home/sasuser/MSH/Ext_1/Data';

filename output "/home/sasuser/MSH/output2/ext1_demo.csv" encoding='utf-8';
proc export data=ext1.demo outfile=output dbms='csv';
	run;
filename output "/home/sasuser/MSH/output2/ext1_fm41.csv" encoding='utf-8';
proc export data=ext1.fm41 outfile=output dbms='csv';
	run;
filename output "/home/sasuser/MSH/output2/ext1_fm42.csv" encoding='utf-8';
proc export data=ext1.fm42 outfile=output dbms='csv';
	run;
filename output "/home/sasuser/MSH/output2/ext1_fm43.csv" encoding='utf-8';
proc export data=ext1.fm43 outfile=output dbms='csv';
	run;
filename output "/home/sasuser/MSH/output2/ext1_fm44.csv" encoding='utf-8';
proc export data=ext1.fm44 outfile=output dbms='csv';
	run;
filename output "/home/sasuser/MSH/output2/ext1_fm45.csv" encoding='utf-8';
proc export data=ext1.fm45 outfile=output dbms='csv';
	run;
filename output "/home/sasuser/MSH/output2/ext1_fm47.csv" encoding='utf-8';
proc export data=ext1.fm47 outfile=output dbms='csv';
	run;
filename output "/home/sasuser/MSH/output2/ext1_fm48.csv" encoding='utf-8';
proc export data=ext1.fm48 outfile=output dbms='csv';
	run;
filename output "/home/sasuser/MSH/output2/ext1_fm49.csv" encoding='utf-8';
proc export data=ext1.fm49 outfile=output dbms='csv';
	run;
filename output "/home/sasuser/MSH/output2/ext1_fm50.csv" encoding='utf-8';
proc export data=ext1.fm50 outfile=output dbms='csv';
	run;
filename output "/home/sasuser/MSH/output2/ext1_fm55.csv" encoding='utf-8';
proc export data=ext1.fm55 outfile=output dbms='csv';
	run;
filename output "/home/sasuser/MSH/output2/ext1_fm66.csv" encoding='utf-8';
proc export data=ext1.fm66 outfile=output dbms='csv';
	run;
filename output "/home/sasuser/MSH/output2/ext1_fm67.csv" encoding='utf-8';
proc export data=ext1.fm67 outfile=output dbms='csv';
	run;
filename output "/home/sasuser/MSH/output2/ext1_fm68.csv" encoding='utf-8';
proc export data=ext1.fm68 outfile=output dbms='csv';
	run;
filename output "/home/sasuser/MSH/output2/ext1_fm69.csv" encoding='utf-8';
proc export data=ext1.fm69 outfile=output dbms='csv';
	run;
filename output "/home/sasuser/MSH/output2/ext1_fm70.csv" encoding='utf-8';
proc export data=ext1.fm70 outfile=output dbms='csv';
	run;
filename output "/home/sasuser/MSH/output2/ext1_fup_labs.csv" encoding='utf-8';
proc export data=ext1.fup_labs outfile=output dbms='csv';
	run;
filename output "/home/sasuser/MSH/output2/ext1_hu_usag2.csv" encoding='utf-8';
proc export data=ext1.hu_usag2 outfile=output dbms='csv';
	run;
filename output "/home/sasuser/MSH/output2/ext1_patevts.csv" encoding='utf-8';
proc export data=ext1.patevts outfile=output dbms='csv';
	run;
	
* Save dataset contents as metadata - later saved as CSV to use for JSON metadata correction;
proc datasets lib=clinical;
contents data=_ALL_ out=clinical.metadata;
run;
proc datasets lib=ext1;
contents data=_ALL_ out=ext1.metadata;
run;
proc datasets lib=pfu;
contents data=_ALL_ out=pfu.metadata;
run;