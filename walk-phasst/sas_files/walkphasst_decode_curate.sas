* Code used to decode walk-PHaSST and curate metadata for PIC-SURE;

* Set reference library;
libname walk "/home/sasuser/walk-phasst/redacted_data/";

* Retrieve metadata;
proc datasets lib=walk;
contents data=_ALL_ out=walk.metadata;
run;

* Data was already in decoded state. Export decoded data with encoded headers.;
proc export data=walk.adecho_r
		outfile="/home/sasuser/walk-phasst/output/adecho_r.csv";
	delimiter=',';
run;

proc export data=walk.adsl_r
		outfile="/home/sasuser/walk-phasst/output/adsl_r.csv";
	delimiter=',';
run;
proc export data=walk.ae_r
		outfile="/home/sasuser/walk-phasst/output/ae_r.csv";
	delimiter=',';
run;
proc export data=walk.aexpcode_m_r
		outfile="/home/sasuser/walk-phasst/output/aexpcode_m_r.csv";
	delimiter=',';
run;
proc export data=walk.aexpcode_o_r
		outfile="/home/sasuser/walk-phasst/output/aexpcode_o_r.csv";
	delimiter=',';
run;
proc export data=walk.aexpcode_s_r
		outfile="/home/sasuser/walk-phasst/output/aexpcode_s_r.csv";
	delimiter=',';
run;
proc export data=walk.bnp_r
		outfile="/home/sasuser/walk-phasst/output/bnp_r.csv";
	delimiter=',';
run;
proc export data=walk.bpiq_m_r
		outfile="/home/sasuser/walk-phasst/output/bpiq_m_r.csv";
	delimiter=',';
run;
proc export data=walk.bpiqt_r
		outfile="/home/sasuser/walk-phasst/output/bpiqt_r.csv";
	delimiter=',';
run;
proc export data=walk.chem_m_r
		outfile="/home/sasuser/walk-phasst/output/chem_m_r.csv";
	delimiter=',';
run;
proc export data=walk.chem_s_r
		outfile="/home/sasuser/walk-phasst/output/chem_s_r.csv";
	delimiter=',';
run;
proc export data=walk.cmedcode_o_r
		outfile="/home/sasuser/walk-phasst/output/cmedcode_o_r.csv";
	delimiter=',';
run;
proc export data=walk.conmed_r
		outfile="/home/sasuser/walk-phasst/output/conmed_r.csv";
	delimiter=',';
run;
proc export data=walk.cxra_m_r
		outfile="/home/sasuser/walk-phasst/output/cxra_m_r.csv";
	delimiter=',';
run;
proc export data=walk.demo_s_r
		outfile="/home/sasuser/walk-phasst/output/demo_s_r.csv";
	delimiter=',';
run;
proc export data=walk.dgts_s_r
		outfile="/home/sasuser/walk-phasst/output/dgts_s_r.csv";
	delimiter=',';
run;
proc export data=walk.disc_o_r
		outfile="/home/sasuser/walk-phasst/output/disc_o_r.csv";
	delimiter=',';
run;
proc export data=walk.drlg_o_r
		outfile="/home/sasuser/walk-phasst/output/drlg_o_r.csv";
	delimiter=',';
run;
proc export data=walk.echo_m_r
		outfile="/home/sasuser/walk-phasst/output/echo_m_r.csv";
	delimiter=',';
run;
proc export data=walk.echo_s_r
		outfile="/home/sasuser/walk-phasst/output/echo_s_r.csv";
	delimiter=',';
run;
proc export data=walk.echot_r
		outfile="/home/sasuser/walk-phasst/output/echot_r.csv";
	delimiter=',';
run;
proc export data=walk.heel_m_r
		outfile="/home/sasuser/walk-phasst/output/heel_m_r.csv";
	delimiter=',';
run;
proc export data=walk.hema_m_r
		outfile="/home/sasuser/walk-phasst/output/heel_m_r.csv";
	delimiter=',';
run;
proc export data=walk.hema_s_r
		outfile="/home/sasuser/walk-phasst/output/hema_s_r.csv";
	delimiter=',';
run;
proc export data=walk.labt_r
		outfile="/home/sasuser/walk-phasst/output/lab_t_r.csv";
	delimiter=',';
run;
proc export data=walk.mdx1_r
		outfile="/home/sasuser/walk-phasst/output/mdx1_r.csv";
	delimiter=',';
run;
proc export data=walk.mdx1_s_r
		outfile="/home/sasuser/walk-phasst/output/mdx1_s_r.csv";
	delimiter=',';
run;
proc export data=walk.mdx2_s_r
		outfile="/home/sasuser/walk-phasst/output/mdx2_s_r.csv";
	delimiter=',';
run;
proc export data=walk.mdx2t_r
		outfile="/home/sasuser/walk-phasst/output/mdx2t_r.csv";
	delimiter=',';
run;
proc export data=walk.mdx3t_r
		outfile="/home/sasuser/walk-phasst/output/mdx3t_r.csv";
	delimiter=',';
run;
proc export data=walk.mdx3_s_r
		outfile="/home/sasuser/walk-phasst/output/mdx3_s_r.csv";
	delimiter=',';
run;
proc export data=walk.patient_enr_r
		outfile="/home/sasuser/walk-phasst/output/patient_enr_r.csv";
	delimiter=',';
run;
proc export data=walk.phex_m_r
		outfile="/home/sasuser/walk-phasst/output/phex_m_r.csv";
	delimiter=',';
run;
proc export data=walk.phex_s_r
		outfile="/home/sasuser/walk-phasst/output/phex_s_r.csv";
	delimiter=',';
run;
proc export data=walk.phext_r
		outfile="/home/sasuser/walk-phasst/output/phext_r.csv";
	delimiter=',';
run;
proc export data=walk.rhca_m_r
		outfile="/home/sasuser/walk-phasst/output/rhca_m_r.csv";
	delimiter=',';
run;
proc export data=walk.rhcat_r
		outfile="/home/sasuser/walk-phasst/output/rhcat_r.csv";
	delimiter=',';
run;
proc export data=walk.sddy_m_r
		outfile="/home/sasuser/walk-phasst/output/sddy_m_r.csv";
	delimiter=',';
run;
proc export data=walk.sf36_m_r
		outfile="/home/sasuser/walk-phasst/output/sf36_m_r.csv";
	delimiter=',';
run;
proc export data=walk.sf36t_r
		outfile="/home/sasuser/walk-phasst/output/sf36t_r.csv";
	delimiter=',';
run;
proc export data=walk.sf36tl_r
		outfile="/home/sasuser/walk-phasst/output/sf36tl_r.csv";
	delimiter=',';
run;
proc export data=walk.sixm_m_r
		outfile="/home/sasuser/walk-phasst/output/sixm_m_r.csv";
	delimiter=',';
run;
proc export data=walk.sixm_s_r
		outfile="/home/sasuser/walk-phasst/output/sixm_s_r.csv";
	delimiter=',';
run;
proc export data=walk.sixmt_r
		outfile="/home/sasuser/walk-phasst/output/sixmt_r.csv";
	delimiter=',';
run;
proc export data=walk.status_enr_r
		outfile="/home/sasuser/walk-phasst/output/status_enr_r.csv";
	delimiter=',';
run;
proc export data=walk.subd_s_r
		outfile="/home/sasuser/walk-phasst/output/subd_s_r.csv";
	delimiter=',';
run;
proc export data=walk.syma_m_r
		outfile="/home/sasuser/walk-phasst/output/syma_m_r.csv";
	delimiter=',';
run;
proc export data=walk.symp_m_r
		outfile="/home/sasuser/walk-phasst/output/symp_m_r.csv";
	delimiter=',';
run;
proc export data=walk.sympt_r
		outfile="/home/sasuser/walk-phasst/output/sympt_r.csv";
	delimiter=',';
run;
proc export data=walk.term_m_r
		outfile="/home/sasuser/walk-phasst/output/term_m_r.csv";
	delimiter=',';
run;
proc export data=walk.tran_m_r
		outfile="/home/sasuser/walk-phasst/output/tran_m_r.csv";
	delimiter=',';
run;
proc export data=walk.urin_m_r
		outfile="/home/sasuser/walk-phasst/output/urin_m_r.csv";
	delimiter=',';
run;
proc export data=walk.urin_s_r
		outfile="/home/sasuser/walk-phasst/output/urin_s_r.csv";
	delimiter=',';
run;
proc export data=walk.visit_enr_r
		outfile="/home/sasuser/walk-phasst/output/visit_enr_r.csv";
	delimiter=',';
run;