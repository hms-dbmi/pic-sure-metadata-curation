*SAS file to decode BABY HUG data;

/*
The following code follows this general format:
1. Set reference library to folder with sas7bdat files
2. Read in formats file and set as reference
3. Set formats for the data
4. Export decoded data
*/

libname fusitest '/home/sasuser/babyhug/FUS_I';

FILENAME REFFILE '/home/sasuser/babyhug/formats_fus_i.csv' TERMSTR=NL;

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT;
	GETNAMES=YES;
	DATAROW=2;
	GUESSINGROWS=575;
RUN;

proc format cntlin = work.import;

proc export data=fusitest.abdominal_sonogram 
		outfile="/home/sasuser/babyhug/output/fusi_abdominal_sonogram.csv";
	delimiter=',';
run;
proc export data=fusitest.blood 
		outfile="/home/sasuser/babyhug/output/fusi_blood.csv";
	delimiter=',';
run;
proc export data=fusitest.creatinine
		outfile="/home/sasuser/babyhug/output/fusi_creatinine.csv";
	delimiter=',';
run;
proc export data=fusitest.cystatin 
		outfile="/home/sasuser/babyhug/output/fusi_cystatin.csv";
	delimiter=',';
run;
proc export data=fusitest.fm001
		outfile="/home/sasuser/babyhug/output/fusi_fm001.csv";
	delimiter=',';
run;
proc export data=fusitest.fm002
		outfile="/home/sasuser/babyhug/output/fusi_fm002.csv";
	delimiter=',';
run;
proc export data=fusitest.fm003
		outfile="/home/sasuser/babyhug/output/fusi_fm003.csv";
	delimiter=',';
run;
proc export data=fusitest.fm010
		outfile="/home/sasuser/babyhug/output/fusi_fm010.csv";
	delimiter=',';
run;
proc export data=fusitest.fm011
		outfile="/home/sasuser/babyhug/output/fusi_fm011.csv";
	delimiter=',';
run;
proc export data=fusitest.fm012
		outfile="/home/sasuser/babyhug/output/fusi_fm012.csv";
	delimiter=',';
run;
proc export data=fusitest.fm013
		outfile="/home/sasuser/babyhug/output/fusi_fm013.csv";
	delimiter=',';
run;
proc export data=fusitest.fm020
		outfile="/home/sasuser/babyhug/output/fusi_fm020.csv";
	delimiter=',';
run;
proc export data=fusitest.fm021
		outfile="/home/sasuser/babyhug/output/fusi_fm021.csv";
	delimiter=',';
run;
proc export data=fusitest.fm022
		outfile="/home/sasuser/babyhug/output/fusi_fm022.csv";
	delimiter=',';
run;
proc export data=fusitest.fm023
		outfile="/home/sasuser/babyhug/output/fusi_fm023.csv";
	delimiter=',';
run;
proc export data=fusitest.fm024
		outfile="/home/sasuser/babyhug/output/fusi_fm024.csv";
	delimiter=',';
run;
proc export data=fusitest.fm025
		outfile="/home/sasuser/babyhug/output/fusi_fm025.csv";
	delimiter=',';
run;
proc export data=fusitest.fm026
		outfile="/home/sasuser/babyhug/output/fusi_fm026.csv";
	delimiter=',';
run;
proc export data=fusitest.fm027
		outfile="/home/sasuser/babyhug/output/fusi_fm027.csv";
	delimiter=',';
run;
proc export data=fusitest.fm031
		outfile="/home/sasuser/babyhug/output/fusi_fm031.csv";
	delimiter=',';
run;
proc export data=fusitest.fm033
		outfile="/home/sasuser/babyhug/output/fusi_fm033.csv";
	delimiter=',';
run;

proc export data=fusitest.hbf
		outfile="/home/sasuser/babyhug/output/fusi_hbf.csv";
	delimiter=',';
run;
proc export data=fusitest.hjb
		outfile="/home/sasuser/babyhug/output/fusi_hjb.csv";
	delimiter=',';
run;
proc export data=fusitest.liver_spleen_scan
		outfile="/home/sasuser/babyhug/output/fusi_liver_spleen_scan.csv";
	delimiter=',';
run;
proc export data=fusitest.metadata
		outfile="/home/sasuser/babyhug/output/fusi_metadata.csv";
	delimiter=',';
run;
proc export data=fusitest.pitted_cell
		outfile="/home/sasuser/babyhug/output/fusi_pitted_cell.csv";
	delimiter=',';
run;
proc export data=fusitest.tcd
		outfile="/home/sasuser/babyhug/output/fusi_tcd.csv";
	delimiter=',';
run;
proc export data=fusitest.urine
		outfile="/home/sasuser/babyhug/output/fusi_urine.csv";
	delimiter=',';
run;
proc export data=fusitest.vdj
		outfile="/home/sasuser/babyhug/output/fusi_vdj.csv";
	delimiter=',';
run;


FILENAME REFFILE2 '/home/sasuser/babyhug/formats_fus_ii.csv' TERMSTR=NL;

PROC IMPORT DATAFILE=REFFILE2
	DBMS=CSV
	OUT=WORK.IMPORT2;
	GETNAMES=YES;
	DATAROW=2;
	GUESSINGROWS=432;
RUN;
libname fusii '/home/sasuser/babyhug/FUS_II';
proc format lib=fusii cntlin = work.import2;

proc export data=fusii.abdsono
		outfile="/home/sasuser/babyhug/output/fusii_abdsono.csv";
	delimiter=',';
run;
proc export data=fusii.creatinine
		outfile="/home/sasuser/babyhug/output/fusii_creatinine.csv";
	delimiter=',';
run;
proc export data=fusii.cystatin
		outfile="/home/sasuser/babyhug/output/fusii_cystatin.csv";
	delimiter=',';
run;
proc export data=fusii.echo
		outfile="/home/sasuser/babyhug/output/fusii_echo.csv";
	delimiter=',';
run;
proc export data=fusii.fm001
		outfile="/home/sasuser/babyhug/output/fusii_fm001.csv";
	delimiter=',';
run;

proc export data=fusii.fm003
		outfile="/home/sasuser/babyhug/output/fusii_fm003.csv";
	delimiter=',';
run;
proc export data=fusii.fm004
		outfile="/home/sasuser/babyhug/output/fusii_fm004.csv";
	delimiter=',';
run;
proc export data=fusii.fm010
		outfile="/home/sasuser/babyhug/output/fusii_fm010.csv";
	delimiter=',';
run;
proc export data=fusii.fm012
		outfile="/home/sasuser/babyhug/output/fusii_fm012.csv";
	delimiter=',';
run;
proc export data=fusii.fm013
		outfile="/home/sasuser/babyhug/output/fusii_fm013.csv";
	delimiter=',';
run;
proc export data=fusii.fm014
		outfile="/home/sasuser/babyhug/output/fusii_fm014.csv";
	delimiter=',';
run;
proc export data=fusii.fm015
		outfile="/home/sasuser/babyhug/output/fusii_fm015.csv";
	delimiter=',';
run;
proc export data=fusii.fm020
		outfile="/home/sasuser/babyhug/output/fusii_fm020.csv";
	delimiter=',';
run;
proc export data=fusii.fm021
		outfile="/home/sasuser/babyhug/output/fusii_fm021.csv";
	delimiter=',';
run;
proc export data=fusii.fm023
		outfile="/home/sasuser/babyhug/output/fusii_fm023.csv";
	delimiter=',';
run;
proc export data=fusii.fm026
		outfile="/home/sasuser/babyhug/output/fusii_fm026.csv";
	delimiter=',';
run;
proc export data=fusii.fm027
		outfile="/home/sasuser/babyhug/output/fusii_fm027.csv";
	delimiter=',';
run;
proc export data=fusii.fm028
		outfile="/home/sasuser/babyhug/output/fusii_fm028.csv";
	delimiter=',';
run;
proc export data=fusii.fm029
		outfile="/home/sasuser/babyhug/output/fusii_fm029.csv";
	delimiter=',';
run;
proc export data=fusii.fm030
		outfile="/home/sasuser/babyhug/output/fusii_fm030.csv";
	delimiter=',';
run;
proc export data=fusii.fm031
		outfile="/home/sasuser/babyhug/output/fusii_fm031.csv";
	delimiter=',';
run;
proc export data=fusii.fm032
		outfile="/home/sasuser/babyhug/output/fusii_fm032.csv";
	delimiter=',';
run;
proc export data=fusii.fm033
		outfile="/home/sasuser/babyhug/output/fusii_fm033.csv";
	delimiter=',';
run;

proc export data=fusii.fusii_majorevents
		outfile="/home/sasuser/babyhug/output/fusii_fusii_majorevents.csv";
	delimiter=',';
run;
proc export data=fusii.hbf
		outfile="/home/sasuser/babyhug/output/fusii_hbf.csv";
	delimiter=',';
run;
proc export data=fusii.hjb
		outfile="/home/sasuser/babyhug/output/fusii_hjb.csv";
	delimiter=',';
run;
proc export data=fusii.liverspleenscan
		outfile="/home/sasuser/babyhug/output/fusii_liverspleenscan.csv";
	delimiter=',';
run;
proc export data=fusii.metadata
		outfile="/home/sasuser/babyhug/output/fusii_metadata.csv";
	delimiter=',';
run;
proc export data=fusii.mra
		outfile="/home/sasuser/babyhug/output/fusii_mra.csv";
	delimiter=',';
run;
proc export data=fusii.mri
		outfile="/home/sasuser/babyhug/output/fusii_mri.csv";
	delimiter=',';
run;
proc export data=fusii.pitted_cell
		outfile="/home/sasuser/babyhug/output/fusii_pitted_cell.csv";
	delimiter=',';
run;
proc export data=fusii.tcd
		outfile="/home/sasuser/babyhug/output/fusii_tcd.csv";
	delimiter=',';
run;
proc export data=fusii.urine
		outfile="/home/sasuser/babyhug/output/fusii_urine.csv";
	delimiter=',';
run;
proc export data=fusii.vdj
		outfile="/home/sasuser/babyhug/output/fusii_vdj.csv";
	delimiter=',';
run;
proc export data=fusii.vsit_dtl_visit
		outfile="/home/sasuser/babyhug/output/fusii_vsit_dtl_visit.csv";
	delimiter=',';
run;


filename reffile3 '/home/sasuser/babyhug/formats_rct.csv' termstr = NL;

proc import datafile = reffile3
	DBMS = CSV
	out=work.import3;
	getnames=yes;
	datarow=2;
	guessingrows=1417;
run;

libname phaseiii '/home/sasuser/babyhug/PHASE_III';

/*proc datasets lib=phaseiii memtype=data;
   modify _ALL_;
     attrib _all_ label=' ';
     attrib _all_ format=;
contents data=phaseiii._ALL_;
run;
quit;


PROC DATASETS lib=phaseiii;
MODIFY _all_;
FORMAT _all_;
INFORMAT _all_;
RUN;
*/


proc format lib=phaseiii cntlin = work.import3;

proc export data=phaseiii.abdominal_sonogram 
		outfile="/home/sasuser/babyhug/output/phaseiii_abdominal_sonogram.csv";
	delimiter=',';
run;
proc export data=phaseiii.bhrct_fm50 
		outfile="/home/sasuser/babyhug/output/phaseiii_bhrct_fm50.csv";
	delimiter=',';
run;
proc export data=phaseiii.bhug_pneumo_lab 
		outfile="/home/sasuser/babyhug/output/phaseiii_bhug_pneumo_lab.csv";
	delimiter=',';
run;
proc export data=phaseiii.blackhc 
		outfile="/home/sasuser/babyhug/output/phaseiii_blackhc.csv";
	delimiter=',';
run;
proc export data=phaseiii.consent_dt
		outfile="/home/sasuser/babyhug/output/phaseiii_consent_dt.csv";
	delimiter=',';
run;


proc export data=phaseiii.csscdht 
		outfile="/home/sasuser/babyhug/output/phaseiii_csscdht.csv";
	delimiter=',';
run;
proc export data=phaseiii.csscdwt
		outfile="/home/sasuser/babyhug/output/phaseiii_csscdwt.csv";
	delimiter=',';
run;
proc export data=phaseiii.cystatin
		outfile="/home/sasuser/babyhug/output/phaseiii_cystatin.csv";
	delimiter=',';
run;
proc export data=phaseiii.dtpa
		outfile="/home/sasuser/babyhug/output/phaseiii_dpta.csv";
	delimiter=',';
run;
proc export data=phaseiii.fm04
		outfile="/home/sasuser/babyhug/output/phaseiii_fm04.csv";
	delimiter=',';
run;

proc export data=phaseiii.fm05 
		outfile="/home/sasuser/babyhug/output/phaseiii_fm05.csv";
	delimiter=',';
run;
proc export data=phaseiii.fm06
		outfile="/home/sasuser/babyhug/output/phaseiii_fm06.csv";
	delimiter=',';
run;
proc export data=phaseiii.fm07
		outfile="/home/sasuser/babyhug/output/phaseiii_fm07.csv";
	delimiter=',';
run;
proc export data=phaseiii.fm08
		outfile="/home/sasuser/babyhug/output/phaseiii_fm08.csv";
	delimiter=',';
run;
proc export data=phaseiii.fm21
		outfile="/home/sasuser/babyhug/output/phaseiii_fm21.csv";
	delimiter=',';
run;

proc export data=phaseiii.fm22 
		outfile="/home/sasuser/babyhug/output/phaseiii_fm22.csv";
	delimiter=',';
run;
proc export data=phaseiii.fm23
		outfile="/home/sasuser/babyhug/output/phaseiii_fm23.csv";
	delimiter=',';
run;
proc export data=phaseiii.fm31
		outfile="/home/sasuser/babyhug/output/phaseiii_fm31.csv";
	delimiter=',';
run;
proc export data=phaseiii.fm32
		outfile="/home/sasuser/babyhug/output/phaseiii_fm32.csv";
	delimiter=',';
run;
proc export data=phaseiii.fm33
		outfile="/home/sasuser/babyhug/output/phaseiii_fm33.csv";
	delimiter=',';
run;
proc export data=phaseiii.fm34 
		outfile="/home/sasuser/babyhug/output/phaseiii_fm34.csv";
	delimiter=',';
run;
proc export data=phaseiii.fm35
		outfile="/home/sasuser/babyhug/output/phaseiii_fm35.csv";
	delimiter=',';
run;
proc export data=phaseiii.fm36
		outfile="/home/sasuser/babyhug/output/phaseiii_fm36.csv";
	delimiter=',';
run;
proc export data=phaseiii.fm37
		outfile="/home/sasuser/babyhug/output/phaseiii_fm37.csv";
	delimiter=',';
run;
proc export data=phaseiii.fm38
		outfile="/home/sasuser/babyhug/output/phaseiii_fm38.csv";
	delimiter=',';
run;
proc export data=phaseiii.fm39 
		outfile="/home/sasuser/babyhug/output/phaseiii_fm39.csv";
	delimiter=',';
run;
proc export data=phaseiii.fm40
		outfile="/home/sasuser/babyhug/output/phaseiii_fm40.csv";
	delimiter=',';
run;
proc export data=phaseiii.fm41
		outfile="/home/sasuser/babyhug/output/phaseiii_fm41.csv";
	delimiter=',';
run;
proc export data=phaseiii.fm42
		outfile="/home/sasuser/babyhug/output/phaseiii_fm42.csv";
	delimiter=',';
run;
proc export data=phaseiii.fm43
		outfile="/home/sasuser/babyhug/output/phaseiii_fm43.csv";
	delimiter=',';
run;

proc export data=phaseiii.fm44 
		outfile="/home/sasuser/babyhug/output/phaseiii_fm44.csv";
	delimiter=',';
run;
proc export data=phaseiii.fm45
		outfile="/home/sasuser/babyhug/output/phaseiii_fm45.csv";
	delimiter=',';
run;
proc export data=phaseiii.fm46
		outfile="/home/sasuser/babyhug/output/phaseiii_fm46.csv";
	delimiter=',';
run;
proc export data=phaseiii.fm47
		outfile="/home/sasuser/babyhug/output/phaseiii_fm47.csv";
	delimiter=',';
run;
proc export data=phaseiii.fm51
		outfile="/home/sasuser/babyhug/output/phaseiii_fm51.csv";
	delimiter=',';
run;
proc export data=phaseiii.fm51a 
		outfile="/home/sasuser/babyhug/output/phaseiii_fm51a.csv";
	delimiter=',';
run;
proc export data=phaseiii.fm52
		outfile="/home/sasuser/babyhug/output/phaseiii_fm52.csv";
	delimiter=',';
run;
proc export data=phaseiii.fm64
		outfile="/home/sasuser/babyhug/output/phaseiii_fm64.csv";
	delimiter=',';
run;
proc export data=phaseiii.fm65
		outfile="/home/sasuser/babyhug/output/phaseiii_fm65.csv";
	delimiter=',';
run;
proc export data=phaseiii.fm66
		outfile="/home/sasuser/babyhug/output/phaseiii_fm66.csv";
	delimiter=',';
run;
proc export data=phaseiii.fm80 
		outfile="/home/sasuser/babyhug/output/phaseiii_fm80.csv";
	delimiter=',';
run;
proc export data=phaseiii.fm81
		outfile="/home/sasuser/babyhug/output/phaseiii_fm81.csv";
	delimiter=',';
run;
proc export data=phaseiii.fm82
		outfile="/home/sasuser/babyhug/output/phaseiii_fm82.csv";
	delimiter=',';
run;
proc export data=phaseiii.fm84
		outfile="/home/sasuser/babyhug/output/phaseiii_fm84.csv";
	delimiter=',';
run;
proc export data=phaseiii.fm85
		outfile="/home/sasuser/babyhug/output/phaseiii_fm85.csv";
	delimiter=',';
run;

proc export data=phaseiii.fmcomment
		outfile="/home/sasuser/babyhug/output/phaseiii_fmcomment.csv";
	delimiter=',';
run;
proc export data=phaseiii.immunology_mmr
		outfile="/home/sasuser/babyhug/output/phaseiii_immunology_mmr.csv";
	delimiter=',';
run;
proc export data=phaseiii.inventory
		outfile="/home/sasuser/babyhug/output/phaseiii_inventory.csv";
	delimiter=',';
run;
proc export data=phaseiii.labs
		outfile="/home/sasuser/babyhug/output/phaseiii_labs.csv";
	delimiter=',';
run;
proc export data=phaseiii.labs_central_numeric
		outfile="/home/sasuser/babyhug/output/phaseiii_labs_central_numeric.csv";
	delimiter=',';
run;
proc export data=phaseiii.labs_history
		outfile="/home/sasuser/babyhug/output/phaseiii_labs_history.csv";
	delimiter=',';
run;
proc export data=phaseiii.metadata
		outfile="/home/sasuser/babyhug/output/phaseiii_metadata.csv";
	delimiter=',';
run;
proc export data=phaseiii.protocol_dev
		outfile="/home/sasuser/babyhug/output/phaseiii_protocol_dev.csv";
	delimiter=',';
run;
proc export data=phaseiii.titration
		outfile="/home/sasuser/babyhug/output/phaseiii_titration.csv";
	delimiter=',';
run;
proc export data=phaseiii.v_cytogenetics
		outfile="/home/sasuser/babyhug/output/phaseiii_v_cytogenetics.csv";
	delimiter=',';
run;
proc export data=phaseiii.v_dna_vdj
		outfile="/home/sasuser/babyhug/output/phaseiii_v_dna_vdj.csv";
	delimiter=',';
run;
proc export data=phaseiii.v_tcd
		outfile="/home/sasuser/babyhug/output/phaseiii_v_tcd.csv";
	delimiter=',';
run;
proc export data=phaseiii.visit_vis_stat
		outfile="/home/sasuser/babyhug/output/phaseiii_visit_vis_stat.csv";
	delimiter=',';
run;