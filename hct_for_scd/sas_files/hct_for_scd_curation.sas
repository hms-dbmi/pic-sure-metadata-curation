* Metadata curation and decoding data for HCT for SCD in PIC-SURE;

* Establish library;
libname hct "/home/sasuser/HCT_for_SCD/";

* Apply formats from Codebook.xlsx;
* Patient-related and disease-related variables;
proc format;
	value yesno
		0="No" 1="Yes";
	value country
		1 = "USA";
	value agegpff
		0 = '<=10' 1 = '11-17' 2 = '18-29' 3 = '30-49' 4 = '>=50';
	value sex 1 = 'Male' 2 = 'Female';
	value ethnicit  1 = 'Hispanic or Latino' 2 = 'Non-Hispanic or non-Latino' 3 = 'Non-resident of the U.S.' 99 = 'Not Reported';
	value racegp 1 = 'Caucasian' 2 = 'African-American' 3 = 'Asian' 4 = 'Pacific islander' 5 = 'Native American' 7 = 'Others' 8 = 'More than one race' 99 = 'Not Reported';
	value kps  0 = '<90' 1 = '>=90' 98 = '>=80 (before 2008)' 99 = 'Not Reported';
	value hctcigpf  1 = '0-2' 2 = '3+' 98 = 'Not collected before 2008' 99 = 'Not Reported';
	value subdis1f 1 = 'Hemoglobin SS' 2 = 'Hemoglobin Sß-thalassemia';
run;

proc datasets library=hct;
modify curesc_year2_v2;
format flag_lancet flag_blood yesno.
	country country. agegpff agegpff. sex sex. ethnicit ethnicit.
	raceg racegp. kps kps. hctcigpf hctcigpf. subdis1f subdis1f.;
run;
	
* Transplant-related variables;
proc format;
	value txtype 1 = 'Allogeneic';
	value donorf  1 = 'HLA identical sibling' 3 = 'HLA mismatch relative' 4 = 'Matched unrelated donor' 5 = 'Mismatched unrelated donor';
	value graftype 1 = "Bone marrow" 22 = 'peripheral blood' 23 = 'Unrelated cord blood';
	value condgrpf  1 = 'Myeloablative' 2 = 'Reduced-intensity conditioning' 3 = 'Non-myeloablative' 99 = 'Not Reported';
	value condgrp_final 1 = 'TBI/Cy' 2 = 'TBI/Cy/Flu' 3 = 'TBI/Cy/Flu/TT' 4 = 'TBI/Mel' 5 = 'TBI/Flu' 6 = 'TBI alone (300/400cGy)' 7 = 'Bu/Cy' 8 = 'Bu/Mel' 9 = 'Flu/Bu/TT' 10 = 'Flu/Bu' 11 = 'Flu/Mel/TT' 12 = 'Flu/Mel' 13 = 'Cy/Flu' 14 = 'Treosulfan' 15 = 'Cy alone' 99 = 'Not Reported';
	value atgf  1 = 'ATG' 2 = 'Alemtuzumab' 3 = 'None' 99 = 'Not Reported';
	value gvhd_final  1 = 'Ex-vivo T-cell depletion' 2 = 'CD 34 selection' 3 = 'Post-CY + siro +/- MMF' 4 = 'Post-CY + MMF + CNI' 5 = 'CNI + MMF' 6 = 'CNI + MTX' 7 = 'CNI alone' 8 = 'CNI + siro' 9 = 'Siro alone' 10 = 'MMF + MTX' 11 = 'MMF + siro' 12 = 'MMF alone' 13 = 'MTX alone' 14 = 'MTX + siro' 99 = 'Not Reported';
	value hla_final 1 = '8/8' 2 = '7/8' 3 = '<=6/8';
	value rcmvpr  0 = 'Negative' 1 = 'Positive' 98 = 'Not collected before 2008' 99 = 'Not Reported';
	value yeargpf 1 = '< 2008' 2 = '2008-2012' 3 = '2013-2017' 4 = '2018-2019';
run;

proc datasets library=hct;
	modify curesc_year2_v2;
	format txtype txtype. donorf donorf. graftype graftype. condgrpf condgrpf.
	condgrp_final condgrp_final. atgf atgf. gvhd_final gvhd_final.
	hla_final hla_final. rcmvpr rcmvpr. yeargpf yeargpf.;
run;

* Outcomes;
proc format;
	value dead 0 = 'Alive' 1 = 'Dead' 99 = 'Not Reported';
	value efs 0 = 'No event' 1 = 'Event happened' 99 = 'Not Reported';
	value gf 0 = 'No' 1 = 'Yes' 99 = 'Not evaluable (Neutrophil recovery not reported)';
	value yesnonr 0 = 'No' 1 = 'Yes' 99 = 'Not Reported';
	value agvhd 0 = 'No' 1 = 'Yes' 98 = 'Acute GVHD, grade unknown' 99 = 'Not reported';
	value scdmal_final 0 = 'None' 1 = 'EBV lymphoma' 2 = 'Acute myelogenous leukemia' 3 = 'Central nervous system malignancy' 4 = 'Myelodysplastic syndrome' 5 = 'T-cell large granular lymphocyte leukemia' 6 = 'Sarcoma' 7 = 'Clonal cytogenetic abnormality: monosomy 7' 8 = 'TP53 mutation' 9 = 'Myofibroblastic tumor' 10 = 'Genitourinary malignancy' 11 = 'Clonal cytogenetic abnormality: unspecified' 99 = 'Not Reported';
run;

proc datasets library=hct;
modify curesc_year2_v2;
format dead dead. efs efs. gf gf. agvhd agvhd.
dwogf anc dwoanc platelet dwoplatelet 
dwoagvhd cgvhd dwocgvhd yesnonr.
scdmal_final scdmal_final.;
run;

* CRF data collection track only;
proc format;
value mgunit 1='mg/dL' 99='Not reported';
value gunit 1 = 'g/dL' 99 = 'Not reported';
value yesnonrlow 0 = 'No' 1 = 'Yes' 99 = 'Not reported';
value yesnonrna 0 = 'No' 1 = 'Yes' 99 = 'Not reported' -9 = 'N/A';
value arrhyth_type 1 = 'Atrial fibrillation or flutter' 2 = 'Sick sinus syndrome' -9 = 'N/A';
value nonr 0 = 'No' 99 = 'Not reported';
value yesnona 0 = 'No' 1 = 'Yes' -9 = 'N/A';
value iron_trt 1 = 'Phlebotomy and iron chelation' 2 = 'Phlebotomy only' 3 = 'Iron chelation only' -9 = 'N/A';
value omsgrdhi  0 = 'None' 1 = 'Mild' 2 = 'Moderate' 3 = 'Severe' 4 = 'Life-threatening' 99 = 'Not reported';
value kpspt 0 = '<90' 1 = '>=90' 99 = 'Not reported';
value vocfrqpr 1 = '< 3/yr' 2 = '>= 3/yr' 99 = 'Not reported' -9 = 'N/A';
value scatxrsn 1 = 'Stroke' 2 = 'ACS' 3 = 'Recurrent vaso-occlusive pain' 4 = 'Recurrent priapism' 5 = 'Excessive transfusion requirements' 6 = 'Abnormal transcranial doppler velocity' 7 = 'Cardio-pulmonary' 8 = 'Asymptomatic' 9 = 'Moya-Moya' 10 = 'Transplant for malignancy' 11 = 'Renal insufficiency' 99 = 'Not reported';
run;

proc datasets library=hct;
modify curesc_year2_v2;
format screprkw salbprkw hb1prkw yesno.
screunit screnunt mgunit.
salbunit salbnunt hb1unpr gunit.

cadpshi ostfxhi ostjawhi nonr.

hctfpr funghxpr ipnpshi pulmabhi eintubhi 
vod tmapshi adialyhi ckdnpshi arrhythi 
chfpshi infapshi htnrxhi dvtpehi
cnshemhi encephhi neurophi seizpshi strkpshi diabrxhi 
grwdpshi hyporxhi pancpshi godypshi hcyspshi avnpshi 
osteophi deprrxhi anxirxhi ptsdrxhi catapshi hylirxhi 
ironrxhi mucorxhi othorgpshi livbxpr acspr snephrpr 
strokepr voc2ypr snephrhi hbeppshi strokehi vocpshi acspshi yesnonrlow.

extubahi tmarslhi adiastls cdiastls htnstls dvtcathi 
diabstls grwdrxhi fibropr exchtfpr intubapr rbctrfpr yesnonrna.

arrhyth_type arrhyth_type.

hylistls yesnona.
omsgrdhi omsgrdhi.
iron_trt iron_trt.
kpspt kpspt. vocfrqpr vocfrqpr.
scatxrsn scatxrsn.;
run;

* Export decoded data with encoded header;
proc export data=hct.curesc_year2_v2 outfile="/home/sasuser/HCT_for_SCD/output/curesc_year2_v2_decoded.csv";
	delimiter=',';
	run;

* Save dataset contents as metadata - later saved as CSV to use for JSON metadata correction;
proc datasets lib=hct;
contents data=_ALL_ out=hct.metadata;
run;