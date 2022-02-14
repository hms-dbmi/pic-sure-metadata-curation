* SAS file used to decode STOP-II data;

* Set reference library with data files;
libname outlib "/home/sasuser/example/STOP-II/redacted_data";

/*
The following code follows this general format:
1. Copy/paste the proc format code from the *fmts.txt files
2. Apply the formats to the data
*/

*F002fmts.txt;
proc format;

  value H_H_DRAWF
    1='1: No'
    2='2: Yes';

  value EXAM_RSNF
    1='1: Routine TCD Screening Examination to determine eligibility for transfusion'
    2='2: Confirmatory TCD Examination to determine eligibility for transfusion'
    3='3: TCD Screening Examination to determine eligibility for randomization'
    4='4: Confirmatory TCD Screening Examination to determine eligibility for randomization'
    5='5: Entry/Quarterly Visit for potential subject'
    6='6: Quarterly or 6 week Follow-up Visit for trial patient'
    7='7: Neurological Event';

  value $EXAM_INTF
    "1"="1: Normal"
    "2A"="2A: Conditional A"
    "2B"="2B: Conditional B"
    "2C"="2C: Conditional C"
    "3"="3: Abnormal"
    "4"="4: Inadequate"
    "5"="5: Inadequate (technical)";

proc datasets library=outlib;
	modify P002_FINAL;
	format h_h_draw h_h_drawf. exam_rsn exam_rsnf. exam_intp $exam_intf.;
	run;

data test;
	retain Idu_id;
  set outlib.p002_final (drop=Idu_id);
run;


*F003fmts.txt;

proc format;

  value DECISIONF
    1='1: No'
    2='2: Yes';

  value REASON1F
    1='1: Concerns about transfusion safety'
    2='2: Difficulty participating in program/anticipated compliance problems'
    3='3: Family/patient not convinced that transfusion is needed'
    4='4: Other';

  value REASON2F
    1='1: Concerns about transfusion safety'
    2='2: Difficulty participating in program/anticipated compliance problems'
    3='3: Family/patient not convinced that transfusion is needed'
    4='4: Other';

  value REASON3F
    1='1: Concerns about transfusion safety'
    2='2: Difficulty participating in program/anticipated compliance problems'
    3='3: Family/patient not convinced that transfusion is needed'
    4='4: Other';

proc datasets library=outlib;
	modify P003_FINAL;
	format decision decisionf. reason1 reason1f. reason2 reason2f. reason3 reason3f.;
	run;

*F006fmts.txt;

proc format;

  value CUR_CHELF
    1='1: No'
    2='2: Yes';

  value CUR_HUF
    1='1: No'
    2='2: Yes';

  value REC_HUF
    1='1: No'
    2='2: Yes';

  value RECREGTRF
    1='1: No'
    2='2: Yes';

  value TX_DEC1F
    1='1: Restart transfusions'
    2='2: Remain off of transfusions';

  value TX_DEC2F
    1='1: Continue transfusions'
    2='2: Discontinue transfusions';
    
proc datasets library=outlib;
	modify P006_FINAL;
	format cur_chel cur_chelf. cur_hu cur_huf. rec_hu rec_huf. recregtr recregtrf. tx_dec1 tx_dec1f. tx_dec2 tx_dec2f.;
	run;

*F010fmts.txt;

proc format;

  value STOPRANDF
    1='1: No'
    2='2: Yes';

  value DIAG_HBSF
    1='1: No'
    2='2: Yes';

  value ABN_CONFF
    1='1: No'
    2='2: Yes';

  value AGE_RANGF
    1='1: No'
    2='2: Yes';

  value TR_CONFF
    1='1: No'
    2='2: Yes';

  value NORMCONFF
    1='1: No'
    2='2: Yes';

  value HX_STROKF
    1='1: No'
    2='2: Yes';

  value BAD_MRAF
    1='1: No'
    2='2: Yes';

  value OTH_PROTF
    1='1: No'
    2='2: Yes';

  value OTH_RXF
    1='1: No'
    2='2: Yes';

  value MED_CONDF
    1='1: No'
    2='2: Yes';

  value MED_CND2F
    1='1: No'
    2='2: Yes';

  value PT_ELIGF
    1='1: No'
    2='2: Yes';

  value CONSENTF
    1='1: No'
    2='2: Yes';

  value CONSREASF
    1='1: Fear of stroke'
    2='2: Other';

  value PIS_CONFF
    1='1: No'
    2='2: Yes';

  value GROUP2F
    1='1: Continuation of transfusion'
    2='2: Discontinuation of transfusion';

  value PREV_POTF
    1='1: No'
    2='2: Yes';

  value CONS_POTF
    1='1: No'
    2='2: Yes';

  value CONT_POTF
    1='1: No'
    2='2: Yes';

  value DNA_SAMPF
    1='1: No'
    2='2: Yes';

proc datasets library=outlib;
	modify P010_FINAL;
	format stoprand stoprandf. diag_hbs diag_hbsf. abn_conf abn_conff. age_rang age_rangf. tr_conf tr_conff. normconf normconff. hx_strok hx_strokf. bad_mra bad_mraf. oth_prot oth_protf. oth_rx oth_rxf. med_cond med_condf. med_cnd2 med_cnd2f. pt_elig pt_eligf. consent consentf. consreas consreasf. pis_conf pis_conff. group2 group2f. prev_pot prev_potf. cons_pot cons_potf. cont_pot cont_potf. dna_samp dna_sampf.;
	run;

*F011fmts.txt;

proc format;

  value INTERVIWF
    1='1: Patient'
    2='2: Parent'
    3='3: Legal Guardian'
    4='4: Other';

  value A_T_VERIF
    1='1: No'
    2='2: Yes';

  value ANY_MEDSF
    1='1: No'
    2='2: Yes';

  value OTH_ANTIF
    1='1: No'
    2='2: Yes';

  value FOLATEF
    1='1: No'
    2='2: Yes';

  value HUF
    1='1: No'
    2='2: Yes';

  value IRONCHELF
    1='1: No'
    2='2: Yes';

  value OTH_MEDSF
    1='1: No'
    2='2: Yes';
   
  value ACSF
    1='1: No'
    2='2: Yes';

  value MENINGITF
    1='1: No'
    2='2: Yes';

  value PENICILNF
    1='1: No'
    2='2: Yes';

  value SEENMENIF
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value SPLENICSF
    1='1: No'
    2='2: Yes';

  value SEENSPLNF
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value APLASTICF
    1='1: No'
    2='2: Yes';

  value SEENAPLSF
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value H_F_SYNDF
    1='1: No'
    2='2: Yes';

  value SEENHFSF
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value SEPTICEMF
    1='1: No'
    2='2: Yes';

  value SEENSEPTF
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value OSTEOMYLF
    1='1: No'
    2='2: Yes';

  value SEENOSTEF
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value SEENPRIAF
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value T_REACTNF
    1='1: No'
    2='2: Yes';

  value SEENREACF
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value SPLENECTF
    1='1: No'
    2='2: Yes';

  value LIVER_BXF
    1='1: No'
    2='2: Yes';

  value PORTCATHF
    1='1: No'
    2='2: Yes';

  value STR_MOTHF
    1='1: No'
    2='2: Yes'
    3="3: Don't know";

  value STR_FATHF
    1='1: No'
    2='2: Yes'
    3="3: Don't know";

  value STR_BROTF
    1='1: No'
    2='2: Yes'
    3="3: Don't know"
    4='4: NA- no brothers';

  value STR_SISTF
    1='1: No'
    2='2: Yes'
    3="3: Don't know"
    4='4: NA- no sisters';

  value LEGULCERF
    1='1: No'
    2='2: Yes';

  value ANECROSF
    1='1: No'
    2='2: Yes';

  value SC_RETINF
    1='1: No'
    2='2: Yes';

  value CHR_LUNGF
    1='1: No'
    2='2: Yes';

  value ASTHMAF
    1='1: No'
    2='2: Yes';

  value CHDF
    1='1: No'
    2='2: Yes';

  value CHR_LVRDF
    1='1: No'
    2='2: Yes';

  value CHR_RNLDF
    1='1: No'
    2='2: Yes';

  value DIALYSISF
    1='1: No'
    2='2: Yes';

  value IRON_OLF
    1='1: No'
    2='2: Yes';

  value DIABETESF
    1='1: No'
    2='2: Yes';

  value RHEU_FVRF
    1='1: No'
    2='2: Yes';

  value TUBERCULF
    1='1: No'
    2='2: Yes';

  value ELEVLEADF
    1='1: No'
    2='2: Yes';

  value HEP_CF
    1='1: No'
    2='2: Yes';

  value OTHCONDF
    1='1: No'
    2='2: Yes';

  value STOPRANDF
    1='1: No'
    2='2: Yes';

  value BLOODGRPF
    1='1: A'
    2='2: B'
    3='3: AB'
    4='4: O';

  value RH_ANT_DF
    1='1: Absent'
    2='2: Present';

  value RH_ANT_CF
    1='1: Absent'
    2='2: Present';

  value RH_ANT_EF
    1='1: Absent'
    2='2: Present';

  value RHANT_EF
    1='1: Absent'
    2='2: Present';

  value RHANT_CF
    1='1: Absent'
    2='2: Present';

  value RH_ANT_FF
    1='1: Absent'
    2='2: Present';

  value RH_ANT_VF
    1='1: Absent'
    2='2: Present';

  value KELL_KELF
    1='1: Absent'
    2='2: Present';

  value KELL_KF
    1='1: Absent'
    2='2: Present';

  value KELL_JSAF
    1='1: Absent'
    2='2: Present';

  value KELL_JSBF
    1='1: Absent'
    2='2: Present';

  value KELL_KPAF
    1='1: Absent'
    2='2: Present';

  value KELL_KPBF
    1='1: Absent'
    2='2: Present';

  value DUF_FYAF
    1='1: Absent'
    2='2: Present';

  value DUF_FYBF
    1='1: Absent'
    2='2: Present';

  value KID_JKAF
    1='1: Absent'
    2='2: Present';

  value KID_JKBF
    1='1: Absent'
    2='2: Present';

  value LEW_LEAF
    1='1: Absent'
    2='2: Present';

  value LEW_LEBF
    1='1: Absent'
    2='2: Present';

  value LUTH_LUAF
    1='1: Absent'
    2='2: Present';

  value LUTH_LUBF
    1='1: Absent'
    2='2: Present';

  value LUTH_LU3F
    1='1: Absent'
    2='2: Present';

  value P1_ANTIGF
    1='1: Absent'
    2='2: Present';

  value MNS_MF
    1='1: Absent'
    2='2: Present';

  value MNS_NF
    1='1: Absent'
    2='2: Present';

  value MNS_SF
    1='1: Absent'
    2='2: Present';

  value MNS_A_SF
    1='1: Absent'
    2='2: Present';

  value MNS_UF
    1='1: Absent'
    2='2: Present';

  value ANTI_DF
    1='1: No'
    2='2: Yes';

  value ANTI_CF
    1='1: No'
    2='2: Yes';

  value ANTI_EF
    1='1: No'
    2='2: Yes';

  value ANTI_MF
    1='1: No'
    2='2: Yes';

  value ANTI_SF
    1='1: No'
    2='2: Yes';

  value ANTI_KF
    1='1: No'
    2='2: Yes';

  value ANTI_FYAF
    1='1: No'
    2='2: Yes';

  value ANTI_FYBF
    1='1: No'
    2='2: Yes';

  value ANTI_JKBF
    1='1: No'
    2='2: Yes';

  value ANTI_LEAF
    1='1: No'
    2='2: Yes';

  value ANTI_LEBF
    1='1: No'
    2='2: Yes';

  value ANTI_OTHF
    1='1: No'
    2='2: Yes';

  value TRANREACF
    1='1: No'
    2='2: Yes'
    3="3: Don't Know";

  value HEPBVACCF
    1='1: No'
    2='2: Yes';

  value NONSTSITF
    1='1: No'
    2='2: Yes';

  value PHEN_SRCF
    1='1: No'
    2='2: Yes';

  value HEP_BF
    1='1: No'
    2='2: Yes';

  value PRIAPISMF
    1='1: No'
    2='2: Yes';

  value PRIAPSMF
    1='1: No'
    2='2: Yes';
    
proc datasets library=outlib;
	modify P011_FINAL;
	format interviw interviwf. a_t_veri a_t_verif. any_meds any_medsf. oth_anti oth_antif. folate folatef. hu huf. ironchel ironchelf. oth_meds oth_medsf. acs acsf. meningit meningitf. peniciln penicilnf. seenmeni seenmenif. splenics splenicsf. seenspln seensplnf. aplastic aplasticf. seenapls seenaplsf. h_f_synd h_f_syndf. seenhfs seenhfsf. septicem septicemf. seensept seenseptf. osteomyl osteomylf. seenoste seenostef. seenpria seenpriaf. t_reactn t_reactnf. seenreac seenreacf. splenect splenectf. liver_bx liver_bxf. portcath portcathf. str_moth str_mothf. str_fath str_fathf. str_brot str_brotf. str_sist str_sistf. legulcer legulcerf. anecros anecrosf. sc_retin sc_retinf. chr_lung chr_lungf. asthma asthmaf. chd chdf. chr_lvrd chr_lvrdf. chr_rnld chr_rnldf. dialysis dialysisf. iron_ol iron_olf. diabetes diabetesf. rheu_fvr rheu_fvrf. tubercul tuberculf. elevlead elevleadf. hep_c hep_cf. othcond othcondf. stoprand stoprandf. bloodgrp bloodgrpf. rh_ant_d rh_ant_df. rh_ant_c rh_ant_cf. rh_ant_e rh_ant_ef. rhant_e rhant_ef. rhant_c rhant_cf. rh_ant_f rh_ant_ff. rh_ant_v rh_ant_vf. kell_kel kell_kelf. kell_k kell_kf. kell_jsa kell_jsaf. kell_jsb kell_jsbf. kell_kpa kell_kpaf. kell_kpb kell_kpbf. duf_fya duf_fyaf. duf_fyb duf_fybf. kid_jka kid_jkaf. kid_jkb kid_jkbf. lew_lea lew_leaf. lew_leb lew_lebf. luth_lua luth_luaf. luth_lub luth_lubf. luth_lu3 luth_lu3f. P1_antig P1_antigf. mns_m mns_mf. mns_n mns_nf. mns_s mns_sf. mns_a_s mns_a_sf. mns_u mns_uf. anti_d anti_df. anti_c anti_cf. anti_e anti_ef. anti_m anti_mf. anti_s anti_sf. anti_k anti_kf. anti_fya anti_fyaf. anti_fyb anti_fybf. anti_jkb anti_jkbf. anti_lea anti_leaf. anti_leb anti_lebf. anti_oth anti_othf. tranreac tranreacf. hepbvacc hepbvaccf. nonstsit nonstsitf. phen_src phen_srcf. hep_b hep_bf. priapism priapismf. priapsm priapsmf.;
	run;

* F012fmts.txt;

proc format;

  value GENAPPERF
    1='1: Normal'
    2='2: Abnormal';

  value EYESF
    1='1: Normal'
    2='2: Abnormal';

  value EARSF
    1='1: Normal'
    2='2: Abnormal';

  value N_T_MF
    1='1: Normal'
    2='2: Abnormal';

  value TONSILSF
    1='1: Normal'
    2='2: Enlarged'
    3='3: Absent';

  value RALESF
    1='1: Absent'
    2='2: Present';

  value RHONCHIF
    1='1: Absent'
    2='2: Present';

  value WHEEZEF
    1='1: Absent'
    2='2: Present';

  value M_BREATHF
    1='1: Absent'
    2='2: Present';

  value OTH_ABNF
    1='1: Absent'
    2='2: Present';

  value RHYTHMF
    1='1: Absent'
    2='2: Present';

  value MURMURF
    1='1: Absent'
    2='2: Present';

  value OTHERABNF
    1='1: Absent'
    2='2: Present';

  value ABDOMENF
    1='1: Normal'
    2='2: Abnormal';

  value SPLEENF
    1='1: Not Enlarged'
    2='2: Enlarged'
    3='3: N/A Splenectomy';

  value LIVERF
    1='1: Not Enlarged'
    2='2: Enlarged';

  value TENDERF
    1='1: Absent'
    2='2: Present';

  value RIGHTHIPF
    1='1: No'
    2='2: Yes';

  value LEFTHIPF
    1='1: No'
    2='2: Yes';

  value R_SHOLDRF
    1='1: No'
    2='2: Yes';

  value L_SHOLDRF
    1='1: No'
    2='2: Yes';

  value LEGULCERF
    1='1: Absent'
    2='2: Present';

  value WHICHLEGF
    1='1: Right'
    2='2: Left'
    3='3: Both';

  value LE_EDEMAF
    1='1: Absent'
    2='2: Present';

  value WHICH_LEF
    1='1: Right'
    2='2: Left'
    3='3: Both';

  value SKINF
    1='1: Normal'
    2='2: Abnormal';

  value L_NODESF
    1='1: No'
    2='2: Yes';

proc datasets library=outlib;
	modify P012_FINAL;
	format genapper genapperf. eyes eyesf. ears earsf. n_t_m n_t_mf. tonsils tonsilsf. rales ralesf. rhonchi rhonchif. wheeze wheezef. m_breath m_breathf. oth_abn oth_abnf. rhythm rhythmf. murmur murmurf. otherabn otherabnf. abdomen abdomenf. spleen spleenf. liver liverf. tender tenderf. righthip righthipf. lefthip lefthipf. r_sholdr r_sholdrf. l_sholdr l_sholdrf. legulcer legulcerf. whichleg whichlegf. le_edema le_edemaf. which_le which_lef. skin skinf. l_nodes l_nodesf.;
	run;


*F013fmts.txt;

proc format;

  value REASON1F
    1='1: Baseline visit'
    2='2: Quarterly visit'
    3='3: Annual visit'
    4='4: Exit from study'
    5='5: Transfusion'
    6='6: Neurological event';

  value REASON2F
    1='1: Baseline visit'
    2='2: Quarterly visit'
    3='3: Annual visit'
    4='4: Exit from study'
    5='5: Transfusion'
    6='6: Neurological event';

  value TRANSF_4F
    1='1: No'
    2='2: Yes';

  value HBA_PHENF
    1='1: SS'
    2='2: S-Beta thalassemia'
    3='3: Other';

  value HEPATI_BF
    1='1: Negative'
    2='2: Positive';

  value HEPATI_CF
    1='1: Negative'
    2='2: Positive';

  value S_REPOSIF
    1='1: No'
    2='2: Yes';

proc datasets library=outlib;
	modify P013_FINAL;
	format reason1 reason1f. reason2 reason2f. transf_4 transf_4f. hba_phen hba_phenf. hepati_b hepati_bf. hepati_c hepati_cf. s_reposi s_reposif.;
	run;

*F014fmts.txt;

proc format;

  value ABDOMENF
    1='1: Normal'
    2='2: Abnormal';

  value ABN_MOVEF
    1='1: No'
    2='2: Yes';

  value ARM_LTF
    1='1: No'
    2='2: Yes';

  value ARM_RTF
    1='1: No'
    2='2: Yes';

  value ARMLEFTF
    1='1: No'
    2='2: Yes';

  value ARMRIGHTF
    1='1: No'
    2='2: Yes';

  value ARRHYTHMF
    1='1: Absent'
    2='2: Present';

  value ATAXLARMF
    1='1: Absent'
    2='2: Present';

  value ATAXLLEGF
    1='1: Absent'
    2='2: Present';

  value ATAXRARMF
    1='1: Absent'
    2='2: Present';

  value ATAXRLEGF
    1='1: Absent'
    2='2: Present';

  value BALANC_LF
    1='1: No'
    2='2: Yes';

  value BALANC_RF
    1='1: No'
    2='2: Yes';

  value CHESTF
    1='1: Normal'
    2='2: Abnormal';

  value CLUMSINSF
    1='1: No'
    2='2: Yes';

  value COMPAMPMF
    1='1: AM'
    2='2: PM';

  value COMPAPPRF
    1='1: No'
    2='2: Yes';

  value CONCIOSF
    1='1: No'
    2='2: Yes';

  value CONS_ABNF
    1='1: Lethargy'
    2='2: Stupor'
    3='3: Coma'
    4='4: Other';

  value COORDINLF
    1='1: Normal'
    2='2: Abnormal';

  value COORDINRF
    1='1: Normal'
    2='2: Abnormal';

  value CORNEALF
    1='1: Normal'
    2='2: Abnormal';

  value DRAWAPPRF
    1='1: No'
    2='2: Yes';

  value DYSARTHRF
    1='1: Absent'
    2='2: Mild'
    3='3: Moderate'
    4='4: Severe';

  value EXAMTYPEF
    1='1: Baseline'
    2='2: Annual'
    3='3: Neurological event'
    4='4: Post-Meningitis'
    5='5: Post-head injury';

  value FACE_LTF
    1='1: No'
    2='2: Yes';

  value FACE_RTF
    1='1: No'
    2='2: Yes';

  value FACELEFTF
    1='1: No'
    2='2: Yes';

  value FACERIGTF
    1='1: No'
    2='2: Yes';

  value FACIAL_SF
    1='1: Normal'
    2='2: Abnormal';

  value GAGF
    1='1: Normal'
    2='2: Abnormal';

  value GAITF
    1='1: Normal'
    2='2: Abnormal';

  value GAZEF
    1='1: Normal'
    2='2: Abnormal';

  value GENDERF
    1='1: Male'
    2='2: Female';

  value HEADACHEF
    1='1: No'
    2='2: Yes';

  value HEADNECKF
    1='1: Normal'
    2='2: Abnormal';

  value HEARINGF
    1='1: Normal'
    2='2: Abnormal';

  value HEMIPAREF
    1='1: No'
    2='2: Yes';

  value HOPLFOOTF
    1='1: No'
    2='2: Yes';

  value HOPRFOOTF
    1='1: No'
    2='2: Yes';

  value INTERVIEF
    1='1: Patient'
    2='2: Parent'
    3='3: Legal guardian'
    4='4: Other';

  value LARMDISTF
    0='0: No contraction'
    1='1: Flicker or trace of contraction'
    2='2: Active movement, with gravity eliminated'
    3='3: Active movement against gravity'
    4='4: Active movement against gravity and resistance'
    5='5: Normal power';

  value LARMPINPF
    1='1: Normal'
    2='2: Abnormal';

  value LARMPROPF
    1='1: Normal'
    2='2: Abnormal';

  value LARMPROXF
    0='0: No contraction'
    1='1: Flicker or trace of contraction'
    2='2: Active movement, with gravity eliminated'
    3='3: Active movement against gravity'
    4='4: Active movement against gravity and resistance'
    5='5: Normal power';

  value LARMTOUCF
    1='1: Normal'
    2='2: Abnormal';

  value LARMVIBF
    1='1: Normal'
    2='2: Abnormal';

  value LEG_LTF
    1='1: No'
    2='2: Yes';

  value LEG_RTF
    1='1: No'
    2='2: Yes';

  value LEGLEFTF
    1='1: No'
    2='2: Yes';

  value LEGRIGHTF
    1='1: No'
    2='2: Yes';

  value LEV_CONSF
    1='1: Normal'
    2='2: Abnormal';

  value LFACE_TF
    1='1: Normal'
    2='2: Abnormal';

  value LFACEPINF
    1='1: Normal'
    2='2: Abnormal';

  value LL_FACEF
    1='1: Normal'
    2='2: Weak';

  value LLEGDISTF
    0='0: No contraction'
    1='1: Flicker or trace of contraction'
    2='2: Active movement, with gravity eliminated'
    3='3: Active movement against gravity'
    4='4: Active movement against gravity and resistance'
    5='5: Normal power';

  value LLEGPINPF
    1='1: Normal'
    2='2: Abnormal';

  value LLEGPROPF
    1='1: Normal'
    2='2: Abnormal';

  value LLEGPROXF
    0='0: No contraction'
    1='1: Flicker or trace of contraction'
    2='2: Active movement, with gravity eliminated'
    3='3: Active movement against gravity'
    4='4: Active movement against gravity and resistance'
    5='5: Normal power';

  value LLEGTOUCF
    1='1: Normal'
    2='2: Abnormal';

  value LLEGVIBF
    1='1: Normal'
    2='2: Abnormal';

  value LTRUNK_TF
    1='1: Normal'
    2='2: Abnormal';

  value LTRUNKPPF
    1='1: Normal'
    2='2: Abnormal';

  value LU_FACEF
    1='1: Normal'
    2='2: Weak';

  value MURMURF
    1='1: Absent'
    2='2: Present';

  value NAMEAPPRF
    1='1: No'
    2='2: Yes';

  value OCULARMVF
    1='1: Normal'
    2='2: Abnormal';

  value ONHEELSF
    1='1: No'
    2='2: Yes';

  value ONSET_APF
    1='1: AM'
    2='2: PM';

  value ORIENAPPF
    1='1: No'
    2='2: Yes';

  value PAIN_CRIF
    1='1: No'
    2='2: Yes';

  value PALATELVF
    1='1: Normal'
    2='2: Abnormal';

  value PAPILLEDF
    1='1: Absent'
    2='2: Present';

  value PLANTR_LF
    1='1: Normal'
    2='2: Abnormal';

  value PLANTR_RF
    1='1: Normal'
    2='2: Abnormal';

  value POS_SEIZF
    1='1: No'
    2='2: Yes';

  value PTHANDEDF
    1='1: Right'
    2='2: Left'
    3='3: Ambidexterous'
    4='4: Undetermined';

  value PUPILSF
    1='1: Normal'
    2='2: Abnormal';

  value RARMDISTF
    0='0: No contraction'
    1='1: Flicker or trace of contraction'
    2='2: Active movement, with gravity eliminated'
    3='3: Active movement against gravity'
    4='4: Active movement against gravity and resistance'
    5='5: Normal power';

  value RARMPINPF
    1='1: Normal'
    2='2: Abnormal';

  value RARMPROPF
    1='1: Normal'
    2='2: Abnormal';

  value RARMPROXF
    0='0: No contraction'
    1='1: Flicker or trace of contraction'
    2='2: Active movement, with gravity eliminated'
    3='3: Active movement against gravity'
    4='4: Active movement against gravity and resistance'
    5='5: Normal power';

  value RARMTOUCF
    1='1: Normal'
    2='2: Abnormal';

  value RARMVIBF
    1='1: Normal'
    2='2: Abnormal';

  value READAPPRF
    1='1: No'
    2='2: Yes';

  value REPITAPPF
    1='1: No'
    2='2: Yes';

  value RFACE_TF
    1='1: Normal'
    2='2: Abnormal';

  value RFACEPINF
    1='1: Normal'
    2='2: Abnormal';

  value RL_FACEF
    1='1: Normal'
    2='2: Weak';

  value RLEGDISTF
    0='0: No contraction'
    1='1: Flicker or trace of contraction'
    2='2: Active movement, with gravity eliminated'
    3='3: Active movement against gravity'
    4='4: Active movement against gravity and resistance'
    5='5: Normal power';

  value RLEGPINPF
    1='1: Normal'
    2='2: Abnormal';

  value RLEGPROPF
    1='1: Normal'
    2='2: Abnormal';

  value RLEGPROXF
    0='0: No contraction'
    1='1: Flicker or trace of contraction'
    2='2: Active movement, with gravity eliminated'
    3='3: Active movement against gravity'
    4='4: Active movement against gravity and resistance'
    5='5: Normal power';

  value RLEGTOUCF
    1='1: Normal'
    2='2: Abnormal';

  value RLEGVIBF
    1='1: Normal'
    2='2: Abnormal';

  value RTRUNK_TF
    1='1: Normal'
    2='2: Abnormal';

  value RTRUNKPPF
    1='1: Normal'
    2='2: Abnormal';

  value RU_FACEF
    1='1: Normal'
    2='2: Weak';

  value SENS_DISF
    1='1: No'
    2='2: Yes';

  value SKINF
    1='1: Normal'
    2='2: Abnormal';

  value SPEECHF
    1='1: No'
    2='2: Yes';

  value SPINEF
    1='1: Normal'
    2='2: Abnormal';

  value STROKEF
    1='1: Definitely yes'
    2='2: Probably yes'
    3='3: Unclear'
    4='4: Probably not'
    5='5: Definitely not';

  value SYM_BEFRF
    1='1: No'
    2='2: Yes';

  value TIPTOESF
    1='1: No'
    2='2: Yes';

  value TONELARMF
    1='1: Normal'
    2='2: Increased'
    3='3: Decreased';

  value TONELLEGF
    1='1: Normal'
    2='2: Increased'
    3='3: Decreased';

  value TONERARMF
    1='1: Normal'
    2='2: Increased'
    3='3: Decreased';

  value TONERLEGF
    1='1: Normal'
    2='2: Increased'
    3='3: Decreased';

  value TONGUE_SF
    1='1: Normal'
    2='2: Abnormal';

  value TRAPEZISF
    1='1: Normal'
    2='2: Abnormal';

  value VIS_LOSSF
    1='1: No'
    2='2: Yes';

  value VISUAL_CF
    1='1: Normal'
    2='2: Abnormal';

  value WCHFOOTF
    1='1: Right'
    2='2: Left'
    3='3: Both';

  value WHATFOOTF
    1='1: Right'
    2='2: Left'
    3='3: Both';

  value WITNES_EF
    1='1: No'
    2='2: Yes';

  value WRITAPPRF
    1='1: No'
    2='2: Yes';

proc datasets library=outlib;
	modify P014_FINAL;
	format abdomen abdomenf. abn_move abn_movef. arm_lt arm_ltf. arm_rt arm_rtf. armleft armleftf. armright armrightf. arrhythm arrhythmf. ataxlarm ataxlarmf. ataxlleg ataxllegf. ataxrarm ataxrarmf. ataxrleg ataxrlegf. balanc_l balanc_lf. balanc_r balanc_rf. chest chestf. clumsins clumsinsf. compampm compampmf. compappr compapprf. concios conciosf. cons_abn cons_abnf. coordinl coordinlf. coordinr coordinrf. corneal cornealf. drawappr drawapprf. dysarthr dysarthrf. examtype examtypef. face_lt face_ltf. face_rt face_rtf. faceleft faceleftf. facerigt facerigtf. facial_s facial_sf. gag gagf. gait gaitf. gaze gazef. gender genderf. headache headachef. headneck headneckf. hearing hearingf. hemipare hemiparef. hoplfoot hoplfootf. hoprfoot hoprfootf. intervie intervief. larmdist larmdistf. larmpinp larmpinpf. larmprop larmpropf. larmprox larmproxf. larmtouc larmtoucf. larmvib larmvibf. leg_lt leg_ltf. leg_rt leg_rtf. legleft legleftf. legright legrightf. lev_cons lev_consf. lface_t lface_tf. lfacepin lfacepinf. ll_face ll_facef. llegdist llegdistf. llegpinp llegpinpf. llegprop llegpropf. llegprox llegproxf. llegtouc llegtoucf. llegvib llegvibf. ltrunk_t ltrunk_tf. ltrunkpp ltrunkppf. lu_face lu_facef. murmur murmurf. nameappr nameapprf. ocularmv ocularmvf. onheels onheelsf. onset_ap onset_apf. orienapp orienappf. pain_cri pain_crif. palatelv palatelvf. papilled papilledf. plantr_l plantr_lf. plantr_r plantr_rf. pos_seiz pos_seizf. pthanded pthandedf. pupils pupilsf. rarmdist rarmdistf. rarmpinp rarmpinpf. rarmprop rarmpropf. rarmprox rarmproxf. rarmtouc rarmtoucf. rarmvib rarmvibf. readappr readapprf. repitapp repitappf. rface_t rface_tf. rfacepin rfacepinf. rl_face rl_facef. rlegdist rlegdistf. rlegpinp rlegpinpf. rlegprop rlegpropf. rlegprox rlegproxf. rlegtouc rlegtoucf. rlegvib rlegvibf. rtrunk_t rtrunk_tf. rtrunkpp rtrunkppf. ru_face ru_facef. sens_dis sens_disf. skin skinf. speech speechf. spine spinef. stroke strokef. sym_befr sym_befrf. tiptoes tiptoesf. tonelarm tonelarmf. tonelleg tonellegf. tonerarm tonerarmf. tonerleg tonerlegf. tongue_s tongue_sf. trapezis trapezisf. vis_loss vis_lossf. visual_c visual_cf. wchfoot wchfootf. whatfoot whatfootf. witnes_e witnes_ef. writappr writapprf.;
	run;
*F015.txt;

proc format;

  value BAD_FILMF
    1='1: Incomplete study'
    2='2: Motion artifact'
    3='3: Other';

  value DWI_PERF
    1='1: No'
    2='2: Yes';

  value EV_TYPEF
    1='1: TIA'
    2='2: Cerebral infarction'
    3='3: Intracranial hemorrhage'
    4='4: Other';

  value FILMS_OKF
    1='1: No'
    2='2: Yes';

  value REASON_PF
    1='1: Pre-randomization study'
    2='2: Routine follow-up study'
    3='3: Exit from study'
    4='4: TCD endpoint or 3 inadequate TCD exams'
    5='5: New neurological event'
    6='6: Post-meningitis event'
    7='7: Post-head injury event';

  value ACCEPTABF
    1='1: No'
    2='2: Yes';

  value ATROPHYF
    1='1: No atrophy'
    2='2: Atrophy'
    3='3: Equivocal';

  value BASILARF
    0='0: Not seen (technically)'
    1='1: Visualized (Patent)'
    2='2: Occluded';

  value BLD_VESSF
    1='1: Right'
    2='2: Left'
    3='3: Both'
    4='4: Not present';

  value $BONY_BASF
    "A"="A: Improved"
    "B"="B: Same"
    "C"="C: New"
    "D"="D: Worse"
    "E"="E: Cannot Determine"
    "F"="F: N/A";

  value $BONY_PREF
    "A"="A: Improved"
    "B"="B: Same"
    "C"="C: New"
    "D"="D: Worse"
    "E"="E: Cannot Determine"
    "F"="F: N/A";

  value BONYCHNGF
    1='1: Normal'
    2='2: Diffuse thickening'
    3='3: Focal abnormality';

  value $BSTAT_FF
    "A"="A: Improved"
    "B"="B: Same"
    "C"="C: New"
    "D"="D: Worse"
    "E"="E: Cannot Determine"
    "F"="F: N/A";

  value COMPREVF
    1='1: No'
    2='2: Yes';

  value DWI_FILMF
    1='1: No'
    2='2: Yes';

  value F_SULCALF
    1='1: No'
    2='2: Yes';

  value F_VENTRF
    1='1: No'
    2='2: Yes';

  value FILM_REVF
    1='1: No'
    2='2: Yes';

  value FOCALF
    1='1: No'
    2='2: Yes';

  value $FSTAT_BF
    "A"="A: Improved"
    "B"="B: Same"
    "C"="C: New"
    "D"="D: Worse"
    "E"="E: Cannot Determine"
    "F"="F: N/A";

  value $FSTAT_PF
    "A"="A: Improved"
    "B"="B: Same"
    "C"="C: New"
    "D"="D: Worse"
    "E"="E: Cannot Determine"
    "F"="F: N/A";

  value G_SEVF
    1='1: Mild'
    2='2: Moderate'
    3='3: Severe';

  value G_SULCALF
    1='1: No'
    2='2: Yes';

  value G_VENTRF
    1='1: No'
    2='2: Yes';

  value GENERALF
    1='1: No'
    2='2: Yes';

  value $GSTAT_BF
    "A"="A: Improved"
    "B"="B: Same"
    "C"="C: New"
    "D"="D: Worse"
    "E"="E: Cannot Determine"
    "F"="F: N/A";

  value $GSTAT_PF
    "A"="A: Improved"
    "B"="B: Same"
    "C"="C: New"
    "D"="D: Worse"
    "E"="E: Cannot Determine"
    "F"="F: N/A";

  value INTHEMORF
    1='1: No'
    2='2: Yes';

  value INTRAHEMF
    1='1: Not Checked'
    2='2: Checked';

  value LACAF
    0='0: Not seen (technically)'
    1='1: Visualized (Patent)'
    2='2: Occluded';

  value LIC_SUPRF
    0='0: Not seen (technically)'
    1='1: Visualized (Patent)'
    2='2: Occluded';

  value LICCAVERF
    0='0: Not seen (technically)'
    1='1: Visualized (Patent)'
    2='2: Occluded';

  value LMCAF
    0='0: Not seen (technically)'
    1='1: Visualized (Patent)'
    2='2: Occluded';

  value LOC1_FF
    0='0: Frontal'
    1='1: Temporal'
    2='2: Parietal'
    3='3: Occipital'
    4='4: Basal ganglia or Thalamic'
    5='5: Cortex'
    6='6: Capsular/Corona'
    7='7: Deep white mattter or periventricular'
    8='8: Brain stem'
    9='9: Cerebellum'
    10='10: Subarachnoid'
    11='11: Intraventricular';

  value LOC2_FF
    0='0: Frontal'
    1='1: Temporal'
    2='2: Parietal'
    3='3: Occipital'
    4='4: Basal ganglia or Thalamic'
    5='5: Cortex'
    6='6: Capsular/Corona'
    7='7: Deep white mattter or periventricular'
    8='8: Brain stem'
    9='9: Cerebellum'
    10='10: Subarachnoid'
    11='11: Intraventricular';

  value LOC3_FF
    0='0: Frontal'
    1='1: Temporal'
    2='2: Parietal'
    3='3: Occipital'
    4='4: Basal ganglia or Thalamic'
    5='5: Cortex'
    6='6: Capsular/Corona'
    7='7: Deep white mattter or periventricular'
    8='8: Brain stem'
    9='9: Cerebellum'
    10='10: Subarachnoid'
    11='11: Intraventricular';

  value LOC4_FF
    0='0: Frontal'
    1='1: Temporal'
    2='2: Parietal'
    3='3: Occipital'
    4='4: Basal ganglia or Thalamic'
    5='5: Cortex'
    6='6: Capsular/Corona'
    7='7: Deep white mattter or periventricular'
    8='8: Brain stem'
    9='9: Cerebellum'
    10='10: Subarachnoid'
    11='11: Intraventricular';

  value LPCAF
    0='0: Not seen (technically)'
    1='1: Visualized (Patent)'
    2='2: Occluded';

  value MRI_PERFF
    1='1: Not Checked'
    2='2: Checked';

  value OTH_REASF
    1='1: Not Checked'
    2='2: Checked';

  value $PSTAT_FF
    "A"="A: Improved"
    "B"="B: Same"
    "C"="C: New"
    "D"="D: Worse"
    "E"="E: Cannot Determine"
    "F"="F: N/A";

  value RACAF
    0='0: Not seen (technically)'
    1='1: Visualized (Patent)'
    2='2: Occluded';

  value RIC_SUPRF
    0='0: Not seen (technically)'
    1='1: Visualized (Patent)'
    2='2: Occluded';

  value RICCAVERF
    0='0: Not seen (technically)'
    1='1: Visualized (Patent)'
    2='2: Occluded';

  value RMCAF
    0='0: Not seen (technically)'
    1='1: Visualized (Patent)'
    2='2: Occluded';

  value RPCAF
    0='0: Not seen (technically)'
    1='1: Visualized (Patent)'
    2='2: Occluded';

  value SCANENCLF
    1='1: No'
    2='2: Yes';

  value SCANQUALF
    1='1: Excellent'
    2='2: Adequate, slight artifact/motion'
    3='3: Inadequate, severe artifact/motion';

  value $SIDE_FF
    "R"="R: Right"
    "L"="L: Left";

  value SIZE_FF
    0='0: Small (punctate)'
    1='1: Medium (ovoid)'
    2='2: Large (geographic)';

  value $TYPE_FF
    "H"="H: Hemorrhage"
    "I"="I: Infarct"
    "HI"="HI: Hemorrhagic infarct";

  value $VASC_BASF
    "A"="A: Improved"
    "B"="B: Same"
    "C"="C: New"
    "D"="D: Worse"
    "E"="E: Cannot Determine"
    "F"="F: N/A";

  value $VASC_PREF
    "A"="A: Improved"
    "B"="B: Same"
    "C"="C: New"
    "D"="D: Worse"
    "E"="E: Cannot Determine"
    "F"="F: N/A";

value frontalF
    1="1: Yes"
     .= ".: No";

value temporalF
    1="1: Yes"
    .= ".: No";

value parietalF
    1="1: Yes"
     .= ".: No";

value occipitaF
    1="1: Yes"
     .= ".: No";

value basalganF
    1="1: Yes"
     .=  ".: No";

value capsularF
    1="1: Yes"
     .= ".: No";

value brainsteF
    1="1: Yes"
     .=  ".: No";

value cerebellF
    1="1: Yes"
     .=  ".: No";

value cortexF
    1="1: Yes"
    .= ".: No";

value whitematF
    1="1: Yes"
     .=  ".: No";

value cortwhiteF
    1="1: Yes"
    .=  ".: No";

value les_chngfrbaseF
     1="1: No"
     2="2: Yes, new lesion"
     3="3: Yes, worse but no new lesion";

value frontal_sideF
      0="0: No"
      1="1: Left"
      2="2: Right"
      3="3: Both Left & Right";

value parietal_sideF
      0="0: No"
      1="1: Left"
      2="2: Right"
      3="3: Both Left & Right";

value temporal_sideF
     0="0: No"
     1="1: Left"
     2="2: Right"
     3="3: Both Left & Right";

value occipita_sideF 
      0="0: No"
      1="1: Left"
      2="2: Right"
      3="3: Both Left & Right";

value basalgan_sideF
      0="0: No"
      1="1: Left"
      2="2: Right"
      3="3: Both Left & Right";

value capsular_sideF
      0="0: No"
      1="1: Left"
      2="2: Right"
      3="3: Both Left & Right";

value cerebell_sideF 
      0="0: No"
      1="1: Left"
      2="2: Right"
      3="3: Both Left & Right";

proc datasets library=outlib;
	modify P015_FINAL;
	format bad_film bad_filmf. dwi_per dwi_perf. ev_type ev_typef. films_ok films_okf. on_disk reason_p reason_pf. acceptab acceptabf. atrophy atrophyf. basilar basilarf. bld_vess bld_vessf. bony_bas $bony_basf. bony_pre $bony_pref. bonychng bonychngf. bstat_f $bstat_ff. comprev comprevf. dwi_film dwi_filmf. f_sulcal f_sulcalf. f_ventr f_ventrf. film_rev film_revf. focal focalf. fstat_b $fstat_bf. fstat_p $fstat_pf. g_sev g_sevf. g_sulcal g_sulcalf. g_ventr g_ventrf. general generalf. gstat_b $gstat_bf. gstat_p $gstat_pf. inthemor inthemorf. intrahem intrahemf. laca lacaf. lic_supr lic_suprf. liccaver liccaverf. lmca lmcaf. loc1_f loc1_ff. loc2_f loc2_ff. loc3_f loc3_ff. loc4_f loc4_ff. lpca lpcaf. mri_perf mri_perff. oth_reas oth_reasf. pstat_f $pstat_ff. raca racaf. ric_supr ric_suprf. riccaver riccaverf. rmca rmcaf. rpca rpcaf. scanencl scanenclf. scanqual scanqualf. side_f $side_ff. size_f size_ff. type_f $type_ff. vasc_bas $vasc_basf. vasc_pre $vasc_pref. frontal frontalF. temporal temporalF. parietal parietalF. occipita occipitaF. basalgan basalganF. capsular capsularF. brainste brainsteF. cerebell cerebellF. cortex cortexF. whitemat whitematF. cortwhite cortwhiteF. les_chngfrbase les_chngfrbaseF. frontal_side frontal_sideF. parietal_side parietal_sideF. temporal_side temporal_sideF. occipita_side occipita_sideF. basalgan_side basalgan_sideF. capsular_side capsular_sideF. cerebell_side cerebell_sideF.;
	run;
* WARNING: Variable ON_DISK not found in data set OUTLIB.P015_FINAL.;
* WARNING: Variable CORTWHITE not found in data set OUTLIB.P015_FINAL.;

*F016fmts.txt;

proc format;

  value A_T_VERIF
    1='1: No'
    2='2: Yes';

  value ANYMEDSF
    1='1: No'
    2='2: Yes';

  value APLASTICF
    1='1: No'
    2='2: Yes';

  value FEVERF
    1='1: No'
    2='2: Yes';

  value FOLATEF
    1='1: No'
    2='2: Yes';

  value H_F_SYNDF
    1='1: No'
    2='2: Yes';

  value HEADINJRF
    1='1: No'
    2='2: Yes';

  value HYDROXYUF
    1='1: No'
    2='2: Yes';

  value INT_TYPEF
    1='1: Patient'
    2='2: Parent'
    3='3: Legal guardian'
    4='4: Other';

  value IRONCHELF
    1='1: No'
    2='2: Yes';

  value MENINGITF
    1='1: No'
    2='2: Yes';

  value OSTEOMYLF
    1='1: No'
    2='2: Yes';

  value OTH_ANTIF
    1='1: No'
    2='2: Yes';

  value OTH_EVNTF
    1='1: No'
    2='2: Yes';

  value OTH_MEDF
    1='1: No'
    2='2: Yes';

  value PENCILLNF
    1='1: No'
    2='2: Yes';

  value PNEUMONIF
    1='1: No'
    2='2: Yes';

  value PRIAPISMF
    1='1: No'
    2='2: Yes';

  value SEENAPLSF
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value SEENFEVRF
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value SEENHFSF
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value SEENOSTEF
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value SEENOTHF
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value SEENPNEUF
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value SEENPRIAF
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value SEENREACF
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value SEENSEPTF
    1='1: STOP II Center'
    2='2: Non-STOP II Center';
 
  value SEENSTRKF
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value SEENSURGF
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value SEENTRANF
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value SEENVASOF
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value SEIZURESF
    1='1: No'
    2='2: Yes';

  value SEPTICEMF
    1='1: No'
    2='2: Yes';

  value SPLENICSF
    1='1: No'
    2='2: Yes';

  value STROKEF
    1='1: No'
    2='2: Yes';

  value SURGERYF
    1='1: No'
    2='2: Yes';

  value T_REACTNF
    1='1: No'
    2='2: Yes';

  value TRANFUSNF
    1='1: No'
    2='2: Yes';

  value VASOPAINF
    1='1: No'
    2='2: Yes';

  value A_NECROSF
    1='1: No'
    2='2: Yes';

  value ASTHMAF
    1='1: No'
    2='2: Yes';

  value CANCERF
    1='1: No'
    2='2: Yes';

  value CHDF
    1='1: No'
    2='2: Yes';

  value CHR_LUNGF
    1='1: No'
    2='2: Yes';

  value CHRLIVERF
    1='1: No'
    2='2: Yes';

  value CHRRENALF
    1='1: No'
    2='2: Yes';

  value $D_VISIONF
    "1"="1: No"
    "2"="2: Yes";

  value DIABETESF
    1='1: No'
    2='2: Yes';

  value DIF_UNDSF
    1='1: No'
    2='2: Yes';

  value DIFFUNDRF
    1='1: No'
    2='2: Yes';

  value DIZZINESSF
    1='1: No'
    2='2: Yes';

  value ELEV_BLDF
    1='1: No'
    2='2: Yes';

  value EXPRESSF
    1='1: No'
    2='2: Yes';

  value HANDCHNGF
    1='1: No'
    2='2: Yes';

  value HEADACHEF
    1='1: No'
    2='2: Yes';

  value HEADFREQF
    1='1: Less than 1 per month'
    2='2: Greater than or equal to 1 per month';

  value HEPBVACCF
    1='1: No'
    2='2: Yes';

  value INV_REVF
    1='1: No'
    2='2: Yes';

  value $INVOLMOVF
    "1"="1: No"
    "2"="2: Yes";

  value IRONOVERF
    1='1: No'
    2='2: Yes';

  value LANGFUNCF
    1='1: No'
    2='2: Yes';

  value LOSSCONSF
    1='1: No'
    2='2: Yes';

  value LULCERSF
    1='1: No'
    2='2: Yes';

  value MOVELARMF
    1='1: No'
    2='2: Yes';

  value MOVELLEGF
    1='1: No'
    2='2: Yes';

  value MOVERARMF
    1='1: No'
    2='2: Yes';

  value MOVERLEGF
    1='1: No'
    2='2: Yes';

  value MOVLFACEF
    1='1: No'
    2='2: Yes';

  value MOVRFACEF
    1='1: No'
    2='2: Yes';

  value NEWNEUROF
    1='1: No'
    2='2: Yes';

  value NEWREPRTF
    1='1: No'
    2='2: Yes';

  value NON_STOPF
    1='1: No'
    2='2: Yes';

  value NUMBLARMF
    1='1: No'
    2='2: Yes';

  value NUMBLLEGF
    1='1: No'
    2='2: Yes';

  value NUMBNESSF
    1='1: No'
    2='2: Yes';

  value NUMBRARMF
    1='1: No'
    2='2: Yes';

  value NUMBRLEGF
    1='1: No'
    2='2: Yes';

  value NUMLFACEF
    1='1: No'
    2='2: Yes';

  value NUMRFACEF
    1='1: No'
    2='2: Yes';

  value OTHCONDF
    1='1: No'
    2='2: Yes';

  value PRIAPF
    1='1: No'
    2='2: Yes';

  value RBCANTIF
    1='1: No'
    2='2: Yes';

  value RHEUMATCF
    1='1: No'
    2='2: Yes';

  value SC_RETINF
    1='1: No'
    2='2: Yes';

  value SIGNEUROF
    1='1: No'
    2='2: Yes';

  value SLURRINGF
    1='1: No'
    2='2: Yes';

  value TUBERCULF
    1='1: No'
    2='2: Yes';

  value $VISION_LF
    "1"="1: No"
    "2"="2: Yes";

  value WEAKLARMF
    1='1: No'
    2='2: Yes';

  value WEAKLFACEF
    1='1: No'
    2='2: Yes';

  value WEAKLLEGF
    1='1: No'
    2='2: Yes';

  value WEAKNESSF
    1='1: No'
    2='2: Yes';

  value WEAKRARMF
    1='1: No'
    2='2: Yes';

  value WEAKRFACEF
    1='1: No'
    2='2: Yes';

  value WEAKRLEGF
    1='1: No'
    2='2: Yes';

  value WHCHHANDF
    1='1: Right'
    2='2: Left';

proc datasets library=outlib;
	modify P016_FINAL;
	format a_t_veri a_t_verif. anymeds anymedsf. aplastic aplasticf. fever feverf. folate folatef. h_f_synd h_f_syndf. headinjr headinjrf. hydroxyu hydroxyuf. int_type int_typef. ironchel ironchelf. meningit meningitf. osteomyl osteomylf. oth_anti oth_antif. oth_evnt oth_evntf. oth_med oth_medf. pencilln pencillnf. pneumoni pneumonif. priapism priapismf. seenapls seenaplsf. seenfevr seenfevrf. seenhfs seenhfsf. seenoste seenostef. seenoth seenothf. seenpneu seenpneuf. seenpria seenpriaf. seenreac seenreacf. seensept seenseptf. seenstrk seenstrkf. seensurg seensurgf. seentran seentranf. seenvaso seenvasof. seizures seizuresf. septicem septicemf. splenics splenicsf. stroke strokef. surgery surgeryf. t_reactn t_reactnf. tranfusn tranfusnf. vasopain vasopainf. a_necros a_necrosf. asthma asthmaf. cancer cancerf. chd chdf. chr_lung chr_lungf. chrliver chrliverf. chrrenal chrrenalf. d_vision $d_visionf. diabetes diabetesf. dif_unds dif_undsf. diffundr diffundrf. dizziness dizzinessf. elev_bld elev_bldf. express expressf. handchng handchngf. headache headachef. headfreq headfreqf. hepbvacc hepbvaccf. inv_rev inv_revf. involmov $involmovf. ironover ironoverf. langfunc langfuncf. losscons lossconsf. lulcers lulcersf. movelarm movelarmf. movelleg movellegf. moverarm moverarmf. moverleg moverlegf. movlface movlfacef. movrface movrfacef. newneuro newneurof. newreprt newreprtf. non_stop non_stopf. numblarm numblarmf. numblleg numbllegf. numbness numbnessf. numbrarm numbrarmf. numbrleg numbrlegf. numlface numlfacef. numrface numrfacef. othcond othcondf. priap priapf. rbcanti rbcantif. rheumatc rheumatcf. sc_retin sc_retinf. signeuro signeurof. slurring slurringf. tubercul tuberculf. vision_l $vision_lf. weaklarm weaklarmf. weaklface weaklfacef. weaklleg weakllegf. weakness weaknessf. weakrarm weakrarmf. weakrface weakrfacef. weakrleg weakrlegf. whchhand whchhandf.;
	run;

*F018fmts.txt;

proc format;

  value DROP_OUTF
    1='1: No'
    2='2: Yes';

  value LOST_FUPF
    1='1: No'
    2='2: Yes';

  value MISS_TCDF
    1='1: No'
    2='2: Yes';

  value MISS_VSTF
    1='1: No'
    2='2: Yes';

  value PT_DIEF
    1='1: No'
    2='2: Yes';

proc datasets library=outlib;
	modify P018_FINAL;
	format drop_out drop_outf. lost_fup lost_fupf. miss_tcd miss_tcdf. miss_vst miss_vstf. pt_die pt_dief.;
	run;

*F019fmts.txt;

proc format;

  value ADEQUATEF
    1='1: No'
    2='2: Yes';

  value AD_REASNF
    1='1: Incomplete study'
    2='2: Motion artifact'
    3='3: Other';

  value MANUFACTF
    1='1: GE'
    2='2: Siemens'
    3='3: Picker Edge'
    4='4: Marconi'
    5='5: Phillips'
    6='6: Other';

  value REAS_MRAF
    1='1: Pre-randomization study'
    2='2: Routine follow-up study'
    3='3: Exit from study'
    4='4: TCD endpoint or 3 inadequte TCD exams'
    5='5: New neurological event'
    6='6: Post-meningitis event'
    7='7: Post-head injury event';

  value EV_TYPEF
    1='1: TIA'
    2='2: Cerebral infarction'
    3='3: Intracranial hemorrhage'
    4='4: Other';

proc datasets library=outlib;
	modify P019_FINAL;
	format adequate adequatef. ad_reasn ad_reasnf. manufact manufactf. reas_mra reas_mraf. ev_type ev_typef.;
	run;

*F01Afmts.txt;

proc format;

  value NEW_RACEF
    1='1: Black/African American/not Latin origin'
    2='2: Black/African American/of Latin origin'
    3='3: Other';

  value HBS_DIAGF
    1='1: No'
    2='2: Yes';

  value BONE_MARF
    1='1: No'
    2='2: Yes';

  value PREVF1AF
    1='1: No'
    2='2: Yes';

  value DOB_CORF
    1='1: No'
    2='2: Yes';

  value GEND_CORF
    1='1: No'
    2='2: Yes';

  value COR_GENDF
    1='1: Female'
    2='2: Male';

  value STROKE_HF
    1='1: No'
    2='2: Yes';

  value ELIG_TCDF
    1='1: No'
    2='2: Yes';

  value CONSNT_SF
    1='1: No'
    2='2: Yes';

  value AGE2_16F
    1='1: No'
    2='2: Yes';

proc datasets library=outlib;
	modify P01A_FINAL;
	format race racef. hbs_diag hbs_diagf. bone_mar bone_marf. prevf1a prevf1af. dob_cor dob_corf. gend_cor gend_corf. cor_gend cor_gendf. stroke_h stroke_hf. elig_tcd elig_tcdf. consnt_s consnt_sf. age2_16 age2_16f.;
	run;

*F01Bfmts.txt;

proc format;

  value H_STROKEF
    1='1: No'
    2='2: Yes';

  value BONE_MARF
    1='1: No'
    2='2: Yes';

  value ELIG_P1F
    1='1: No'
    2='2: Yes';

  value NEW_RACEF
    1='1: Black/African American/not Latin origin'
    2='2: Black/African American/of Latin origin'
    3='3: Other';

  value HBS_DIAGF
    1='1: No'
    2='2: Yes';

  value ABN_TCDSF
    1='1: No'
    2='2: Yes';

  value CONSENTF
    1='1: No'
    2='2: Yes';

  value GEND_CORF
    1='1: No'
    2='2: Yes';

  value PREVF1BF
    1='1: No'
    2='2: Yes';

  value DOB_CORF
    1='1: No'
    2='2: Yes';

  value COR_GENDF
    1='1: Female'
    2='2: Male';

  value PRE_RANDF
    1='1: No'
    2='2: Yes';

  value AGE2_20F
    1='1: No'
    2='2: Yes';

  value TX_RECPTF
    1='1: No'
    2='2: Yes';

proc datasets library=outlib;
	modify P01B_FINAL;
	format h_stroke h_strokef. bone_mar bone_marf. elig_p1 elig_p1f. race racef. hbs_diag hbs_diagf. abn_tcds abn_tcdsf. consent consentf. gend_cor gend_corf. prevf1b prevf1bf. dob_cor dob_corf. cor_gend cor_gendf. pre_rand pre_randf. age2_20 age2_20f. tx_recpt tx_recptf.;
	run;
	
*WARNING: Variable RACE not found in data set OUTLIB.P01B_FINAL.;

*F01Cfmts.txt;

proc format;

  value PREVF1CF
    1='1: No'
    2='2: Yes';

  value AGE4_20F
    1='1: No'
    2='2: Yes';

  value TX_ADQTF
    1='1: No'
    2='2: Yes';

  value H_STROKEF
    1='1: No'
    2='2: Yes';

  value NEW_RACEF
    1='1: Black/African American/not Latin origin'
    2='2: Black/African American/of Latin origin'
    3='3: Other';
  
  value HBS_DIAGF
    1='1: No'
    2='2: Yes';

  value ABN_TCDSF
    1='1: No'
    2='2: Yes';

  value CONSENTF
    1='1: No'
    2='2: Yes';

  value ELIG_PRF
    1='1: No'
    2='2: Yes';

  value BONE_MARF
    1='1: No'
    2='2: Yes';

  value TX_RECPTF
    1='1: No'
    2='2: Yes';

  value COR_GENDF
    1='1: Female'
    2='2: Male';

  value GEND_CORF
    1='1: No'
    2='2: Yes';

  value DOB_CORF
    1='1: No'
    2='2: Yes';

proc datasets library=outlib;
	modify P01C_FINAL;
	format prevf1c prevf1cf. age4_20 age4_20f. tx_adqt tx_adqtf. h_stroke h_strokef. race racef. hbs_diag hbs_diagf. abn_tcds abn_tcdsf. consent consentf. elig_pr elig_prf. bone_mar bone_marf. tx_recpt tx_recptf. cor_gend cor_gendf. gend_cor gend_corf. dob_cor dob_corf.;
	run;
*WARNING: Variable RACE not found in data set OUTLIB.P01C_FINAL.;

*F020fmts.txt;

proc format;

  value NEW_DF
    1='1: No'
    2='2: Yes';

  value NEW_CF
    1='1: No'
    2='2: Yes';

  value NEW_EF
    1='1: No'
    2='2: Yes';

  value NEW_E2F
    1='1: No'
    2='2: Yes';

    value NEW_S2F
    1='1: No'
    2='2: Yes';

  value NEW_UF
    1='1: No'
    2='2: Yes';

  value NEW_KPAF
    1='1: No'
    2='2: Yes';

  value NEW_JSAF
    1='1: No'
    2='2: Yes';

  value ANTI_JSBF
    1='1: No'
    2='2: Yes';

  value ANTI_KELF
    1='1: No'
    2='2: Yes';

  value NEW_KELF
    1='1: No'
    2='2: Yes';

  value ANTI_K2F
    1='1: No'
    2='2: Yes';

  value NEW_K2F
    1='1: No'
    2='2: Yes';

  value ANTI_FYAF
    1='1: No'
    2='2: Yes';

  value NEW_FYAF
    1='1: No'
    2='2: Yes';

  value ANTI_FYBF
    1='1: No'
    2='2: Yes';

  value ANTI_JKAF
    1='1: No'
    2='2: Yes';

  value ANTI_JSAF
    1='1: No'
    2='2: Yes';

  value NEW_JKAF
    1='1: No'
    2='2: Yes';

  value ANTI_JKBF
    1='1: No'
    2='2: Yes';

  value NEW_JKBF
    1='1: No'
    2='2: Yes';

  value ANTI_LEAF
    1='1: No'
    2='2: Yes';

  value ANTI_LEBF
    1='1: No'
    2='2: Yes';

  value DIRECT_AF
    1='1: Negative'
    2='2: Positive';

  value INDIR_AF
    1='1: Negative'
    2='2: Positive';

  value ANTI_DF
    1='1: No'
    2='2: Yes';

  value ANTI_CF
    1='1: No'
    2='2: Yes';

  value ANTI_EF
    1='1: No'
    2='2: Yes';

  value ANTI_E2F
    1='1: No'
    2='2: Yes';

  value ANTI_C2F
    1='1: No'
    2='2: Yes';

  value ANTI_F2F
    1='1: No'
    2='2: Yes';

  value ANTI_VF
    1='1: No'
    2='2: Yes';

  value ANTI_MF
    1='1: No'
    2='2: Yes';

  value ANTI_NF
    1='1: No'
    2='2: Yes';

  value ANTI_SF
    1='1: No'
    2='2: Yes';

  value ANTI_S2F
    1='1: No'
    2='2: Yes';

  value ANTI_UF
    1='1: No'
    2='2: Yes';

  value ANTI_KPAF
    1='1: No'
    2='2: Yes';

  value ANTI_KPBF
    1='1: No'
    2='2: Yes';

  value WHYTRAN1F
    1='1: STOP�II�Trial�transfusion�for�primary�stroke�prevention'
    2='2: Acute�Anemic�Episode'
    3='3: Acute�Chest�Event'
    4='4: CVA'
    5='5: Surgery'
    6='6: Priapism'
    7='7: Other';

  value WHYTRAN2F
    1='1: STOP�II�Trial�transfusion�for�primary�stroke�prevention'
    2='2: Acute�Anemic�Episode'
    3='3: Acute�Chest�Event'
    4='4: CVA'
    5='5: Surgery'
    6='6: Priapism'
    7='7: Other';

  value WHYTRAN3F
    1='1: STOP�II�Trial�transfusion�for�primary�stroke�prevention'
    2='2: Acute�Anemic�Episode'
    3='3: Acute�Chest�Event'
    4='4: CVA'
    5='5: Surgery'
    6='6: Priapism'
    7='7: Other';

  value PHYS_EXF
    1='1: Normal'
    2='2: Abnormal';

  value TRS_AMPMF
    1='1: AM'
    2='2: PM';

  value TOT_VOLF
    1='1: No'
    2='2: Yes';

  value ANTI_P1F
    1='1: No'
    2='2: Yes';

  value NEW_P1F
    1='1: No'
    2='2: Yes';

  value ANTI_IF
    1='1: No'
    2='2: Yes';

  value ANTI_OTHF
    1='1: No'
    2='2: Yes';

  value NEW_OTHF
    1='1: No'
    2='2: Yes';

  value COMPNOTEF
    1='1: No'
    2='2: Yes';

  value HEMOLYTF
    1='1: No'
    2='2: Yes';

  value HEM_DAPF
    1='1: AM'
    2='2: PM';

  value FEBRILEF
    1='1: No'
    2='2: Yes';

  value FEB_DAPF
    1='1: AM'
    2='2: PM';

  value ALLERGICF
    1='1: No'
    2='2: Yes';

  value ALL_DAPF
    1='1: AM'
    2='2: PM';

  value ALL_RAPF
    1='1: AM'
    2='2: PM';

  value ALL2F
    1='1: No'
    2='2: Yes';

  value ALL2_DAPF
    1='1: AM'
    2='2: PM';

  value ALL2_RAPF
    1='1: AM'
    2='2: PM';

  value FLUIDF
    1='1: No'
    2='2: Yes';

  value HYPERTENF
    1='1: No'
    2='2: Yes';

  value HYP_DAPF
    1='1: AM'
    2='2: PM';

  value HYP_RAPF
    1='1: AM'
    2='2: PM';

  value OTHCOMPLF
    1='1: No'
    2='2: Yes';

  value OTH_DAPF
    1='1: AM'
    2='2: PM';

  value OTH_RAPF
    1='1: AM'
    2='2: PM';

  value ANTIG_APF
    1='1: AM'
    2='2: PM';

  value A_DIR_HF
    1='1: Negative'
    2='2: Positive';

  value A_IND_HF
    1='1: Negative'
    2='2: Positive';

 value HOSPF
    1='1: No'
    2='2: Yes';

  value FEB_RAPF
    1='1: AM'
    2='2: PM';

  value HEM_RAPF
    1='1: AM'
    2='2: PM';

  value TRE_AMPMF
    1='1: AM'
    2='2: PM';

proc datasets library = outlib;
	modify P020_FINAL;
	format new_d new_df. new_c new_cf. new_e new_ef. new_e2 new_e2f. new_s2 new_s2f. new_u new_uf. new_kpa new_kpaf. new_jsa new_jsaf. anti_jsb anti_jsbf. anti_kel anti_kelf. new_kel new_kelf. anti_k2 anti_k2f. new_k2 new_k2f. anti_fya anti_fyaf. new_fya new_fyaf. anti_fyb anti_fybf. anti_jka anti_jkaf. anti_jsa anti_jsaf. new_jka new_jkaf. anti_jkb anti_jkbf. new_jkb new_jkbf. anti_lea anti_leaf. anti_leb anti_lebf. direct_a direct_af. indir_a indir_af. anti_d anti_df. anti_c anti_cf. anti_e anti_ef. anti_e2 anti_e2f. anti_c2 anti_c2f. anti_f2 anti_f2f. anti_v anti_vf. anti_m anti_mf. anti_n anti_nf. anti_s anti_sf. anti_s2 anti_s2f. anti_u anti_uf. anti_kpa anti_kpaf. anti_kpb anti_kpbf. whytran1 whytran1f. whytran2 whytran2f. whytran3 whytran3f. phys_ex phys_exf. trs_ampm trs_ampmf. tot_vol tot_volf. anti_p1 anti_p1f. new_p1 new_p1f. anti_i anti_if. anti_oth anti_othf. new_oth new_othf. compnote compnotef. hemolyt hemolytf. hem_dap hem_dapf. febrile febrilef. feb_dap feb_dapf. allergic allergicf. all_dap all_dapf. all_rap all_rapf. all2 all2f. all2_dap all2_dapf. all2_rap all2_rapf. fluid fluidf. flu_dap flu_dapf. flu_rap flu_rapf. hyperten hypertenf. hyp_dap hyp_dapf. hyp_rap hyp_rapf. othcompl othcomplf. oth_dap oth_dapf. oth_rap oth_rapf. antig_ap antig_apf. a_dir_h a_dir_hf. a_ind_h a_ind_hf. hosp hospf. feb_rap feb_rapf. hem_rap hem_rapf. tre_ampm tre_ampmf.;
	run;
*WARNING: Variable FLU_DAP not found in data set OUTLIB.P020_FINAL.
*WARNING: Variable FLU_RAP not found in data set OUTLIB.P020_FINAL.;

*F021fmts.txt;

proc format;

  value ANT_CF
    1='1: No'
    2='2: Yes';

  value ANT_EF
    1='1: No'
    2='2: Yes';

  value ANT_OTHF
    1='1: No'
    2='2: Yes';

  value SIMPL_TRF
    1='1: No'
    2='2: Yes';

  value FULL_EXF
    1='1: No'
    2='2: Yes';

  value METHOD_FF
    1='1: Manual'
    2='2: Red�Cell�Pheresis';

  value DELIVR_FF
    1='1: Intermittent'
    2='2: Continuous';

  value REC_WITHF
    1='1: Saline'
    2='2: Albumin'
    3='3: Plasma'
    4='4: Other';

  value LEUK_FLTF
    1='1: No'
    2='2: Yes';

  value ANT_KELLF
    1='1: No'
    2='2: Yes';

  value $LEUKPROCF
    "A"="A: Prestorage leukodepletion"
    "B"="B: Leukodepletion in blood bank"
    "C"="C: Bedside filtration"
    "D"="D: Other";

proc datasets library = outlib;
	modify P021_FINAL;
	format ant_c ant_cf. ant_e ant_ef. ant_oth ant_othf. simpl_tr simpl_trf. full_ex full_exf. method_f method_ff. delivr_f delivr_ff. rec_with rec_withf. leuk_flt leuk_fltf. ant_kell ant_kellf. leukproc $leukprocf.;
	run;

* F022fmts.txt;

proc format;

  value TX_REASNF
    1='1: Primary stroke prevention'
    2='2: Other';

  value ON_CHELF
    1='1: No'
    2='2: Yes';

proc datasets library = outlib;
	modify P022_FINAL;
	format tx_reasn tx_reasnf. on_chel on_chelf.;
	run;

*F030fmts.txt;

proc format;

  value A_ANEMIAF
    1='1: No'
    2='2: Yes'
    3="3: Don't Know";

  value A_CHESTF
    1='1: No'
    2='2: Yes'
    3="3: Don't Know";

  value A_FEBRILF
    1='1: No'
    2='2: Yes'
    3="3: Don't Know";

  value A_PRIAPISMF
    1='1: No'
    2='2: Yes'
    3="3: Don't Know";

  value ANESTHESF
    1='1: No'
    2='2: Yes'
    3="3: Don't Know";

  value ARTERIOGF
    1='1: Not Done'
    2='2: Done';

  value BEHAVIORF
    1='1: No'
    2='2: Yes';

  value CHG_MENTF
    1='1: No'
    2='2: Yes';

  value COORDINAF
    1='1: No'
    2='2: Yes';

  value CT_BRAINF
    1='1: Not Done'
    2='2: Done';

  value D_VISIONF
    1='1: No'
    2='2: Yes';

  value DIF_SPEKF
    1='1: No'
    2='2: Yes';

  value DIZZINESF
    1='1: No'
    2='2: Yes';

  value DSWALLOWF
    1='1: No'
    2='2: Yes';

  value DWI_PERFF
    1='1: No'
    2='2: Yes';

  value EV_TYPEF
    1='1: Cerebral Infarction'
    2='2: Intracranial Hemorrhage'
    3='3: TIA'
    4='4: Seizure'
    5='5: Other';

  value HEAD_INJF
    1='1: No'
    2='2: Yes'
    3="3: Don't Know";

  value HEAD_LOCF
    1='1: Diffuse'
    2='2: Focal';

  value HEADACHEF
    1='1: No'
    2='2: Yes';

  value INTERVIEF
    1='1: Patient'
    2='2: Parent'
    3='3: Other';

  value LOSSCONSF
    1='1: No'
    2='2: Yes';

  value MRABRAINF
    1='1: Not Done'
    2='2: Done';

  value MRIBRAINF
    1='1: Not Done'
    2='2: Done';

  value NEUREVALF
    1='1: No'
    2='2: Yes';

  value O_EVENTSF
    1='1: No'
    2='2: Yes';

  value O_IMAGEF
    1='1: Not Done'
    2='2: Done';

  value OTH_EXPRF
    1='1: No'
    2='2: Yes'
    3="3: Don't Know";

  value PAINFULF
    1='1: No'
    2='2: Yes'
    3="3: Don't Know";

  value PETBRAINF
    1='1: Not Done'
    2='2: Done';

  value PT_DIEF
    1='1: No'
    2='2: Yes';

  value PT_HOSPF
    1='1: No'
    2='2: Yes';

  value PT_TRANSF
    1='1: No'
    2='2: Yes';

  value SEIZUREF
    1='1: No'
    2='2: Yes';

  value SENSDISTF
    1='1: No'
    2='2: Yes';

  value SENSSIDEF
    1='1: Right'
    2='2: Left'
    3='3: Both';

  value SYMPRPTDF
    1='1: No'
    2='2: Yes';

  value TRANSDOPF
    1='1: Not Done'
    2='2: Done';

  value TRANSFUSF
    1='1: No'
    2='2: Yes'
    3="3: Don't Know";

   value VIS_SIDEF
    1='1: Right'
    2='2: Left'
    3='3: Both';

  value WEAKNESSF
    1='1: No'
    2='2: Yes';

  value WEAKSIDEF
    1='1: Right'
    2='2: Left'
    3='3: Both';

  value WHERSEENF
    1='1: Stop II Center'
    2='2: Other';

  value WITNES_EF
    1='1: No'
    2='2: Yes';

proc datasets library = outlib;
	modify P030_FINAL;
	format a_anemia a_anemiaf. a_chest a_chestf. a_febril a_febrilf. a_priapism a_priapismf. anesthes anesthesf. arteriog arteriogf. behavior behaviorf. chg_ment chg_mentf. coordina coordinaf. ct_brain ct_brainf. d_vision d_visionf. dif_spek dif_spekf. dizzines dizzinesf. dswallow dswallowf. dwi_perf dwi_perff. ev_type ev_typef. head_inj head_injf. head_loc head_locf. headache headachef. intervie intervief. losscons lossconsf. mrabrain mrabrainf. mribrain mribrainf. neureval neurevalf. o_events o_eventsf. o_image o_imagef. oth_expr oth_exprf. painful painfulf. petbrain petbrainf. pt_die pt_dief. pt_hosp pt_hospf. pt_trans pt_transf. seizure seizuref. sensdist sensdistf. sensside senssidef. symprptd symprptdf. transdop transdopf. transfus transfusf. vis_side vis_sidef. weakness weaknessf. weakside weaksidef. wherseen wherseenf. witnes_e witnes_ef.;
	run;

*F031fmts.txt;

proc format;

  value ACUTEINFF
    1='1: No'
    2='2: Yes'
    3="3: Don't know";

  value ADMITTEDF
    1='1: No'
    2='2: Yes';

  value CONT_EVTF
    1='1: No'
    2='2: Yes'
    9="9: Don't know";

  value CULTSAMPF
    1='1: No'
    2='2: Yes';

  value DAYSVENTF
    1='1: No'
    2='2: Yes';

  value DIE_EVNTF
    1='1: No'
    2='2: Yes';

  value OTHEVENTF
    1='1: No'
    2='2: Yes';

  value PT_TRANFF
    1='1: No'
    2='2: Yes';

  value RESULT1F
    1='1: Negative'
    2='2: Positive';

  value RESULT2F
    1='1: Negative'
    2='2: Positive';

  value RESULT3F
    1='1: Negative'
    2='2: Positive';

  value RESULT4F
    1='1: Negative'
    2='2: Positive';

  value SAME_EVTF
    1='1: No'
    2='2: Yes';

  value SERL_POSF
    1='1: No'
    2='2: Yes';

  value SEROLOGYF
    1='1: No'
    2='2: Yes';

  value VENTILATF
    1='1: No'
    2='2: Yes';

proc datasets library = outlib;
	modify P031_FINAL;
	format acuteinf acuteinff. admitted admittedf. cont_evt cont_evtf. cultsamp cultsampf. daysvent daysventf. die_evnt die_evntf. othevent otheventf. pt_tranf pt_tranff. result1 result1f. result2 result2f. result3 result3f. result4 result4f. same_evt same_evtf. serl_pos serl_posf. serology serologyf. ventilat ventilatf.;
	run;

*F032fmts.txt;

proc format;

  value ADM_REAF
    1='1: No'
    2='2: Yes';

  value ANA_MILDF
    1='1: No'
    2='2: Yes';

  value ANA_SEVF
    1='1: No'
    2='2: Yes';

  value ANTI_CF
    1='1: No'
    2='2: Yes';

  value ANTI_DF
    1='1: No'
    2='2: Yes';

  value ANTI_EF
    1='1: No'
    2='2: Yes';

  value ANTI_FCF
    1='1: No'
    2='2: Yes';

  value ANTI_FYF
    1='1: No'
    2='2: Yes';

  value ANTI_JBF
    1='1: No'
    2='2: Yes';

  value ANTI_JDF
    1='1: No'
    2='2: Yes';

  value ANTI_JKF
    1='1: No'
    2='2: Yes';

  value ANTI_JSF
    1='1: No'
    2='2: Yes';

  value ANTI_KF
    1='1: No'
    2='2: Yes';

  value ANTI_KAF
    1='1: No'
    2='2: Yes';

  value ANTI_KPF
    1='1: No'
    2='2: Yes';

  value ANTI_LEF
    1='1: No'
    2='2: Yes';

  value ANTI_LFF
    1='1: No'
    2='2: Yes';

  value ANTI_MF
    1='1: No'
    2='2: Yes';

  value ANTI_NF
    1='1: No'
    2='2: Yes';

  value ANTI_OTF
    1='1: No'
    2='2: Yes';

  value ANTI_P1F
    1='1: No'
    2='2: Yes';

  value ANTI_SF
    1='1: No'
    2='2: Yes';

  value ANTI_VF
    1='1: No'
    2='2: Yes';

  value ANTIB_CF
    1='1: No'
    2='2: Yes';

  value ANTIB_EF
    1='1: No'
    2='2: Yes';

  value ANTIB_FF
    1='1: No'
    2='2: Yes';

  value ANTIB_KF
    1='1: No'
    2='2: Yes';

  value ANTIB_SF
    1='1: No'
    2='2: Yes';

  value ANTIB_UF
    1='1: No'
    2='2: Yes';

  value BBA_RECF
    1='1: No'
    2='2: Yes';

  value BBP_RECF
    1='1: No'
    2='2: Yes';

  value CBCF
    1='1: Not Done'
    2='2: Done';

  value CBC_RECF
    1='1: No'
    2='2: Yes';

  value CHEM_RECF
    1='1: No'
    2='2: Yes';

  value COOMBSF
    1='1: Not Done'
    2='2: Done';

  value DEL_HEMF
    1='1: No'
    2='2: Yes';

  value DIRECTF
    1='1: Negative'
    2='2: Positive';

  value DISC_SUF
    1='1: No'
    2='2: Yes';

  value ERNOTESF
    1='1: No'
    2='2: Yes';

  value FEBRILEF
    1='1: No'
    2='2: Yes';

  value FLD_OVLF
    1='1: No'
    2='2: Yes';

  value FORMCOMF
    1='1: No'
    2='2: Yes';

  value HYDRATNF
    1='1: No'
    2='2: Yes';

  value HYPERTEF
    1='1: No'
    2='2: Yes';

  value INDIRECF
    1='1: Negative'
    2='2: Positive';

  value LABRPTSF
    1='1: No'
    2='2: Yes';

  value NEW_KF
    1='1: No'
    2='2: Yes';

  value NEW_OTHF
    1='1: No'
    2='2: Yes';

  value OTHREACF
    1='1: No'
    2='2: Yes';

  value OTHTREAF
    1='1: No'
    2='2: Yes';

  value PT_DIEF
    1='1: No'
    2='2: Yes';

  value SER_CHEF
    1='1: Not Done'
    2='2: Done';

  value TRANSFUF
    1='1: No'
    2='2: Yes';

  value URIN_RECF
    1='1: No'
    2='2: Yes';

  value URINALYF
    1='1: Not Done'
    2='2: Done';

  value URINHEMF
    1='1: Neg'
    2='2: Trace'
    3='3: 1+'
    4='4: 2+'
    5='5: 3+'
    6='6: 4+';

proc datasets library = outlib;
	modify P032_FINAL;
	format adm_rea adm_reaf. ana_mild ana_mildf. ana_sev ana_sevf. anti_c anti_cf. anti_d anti_df. anti_e anti_ef. anti_fc anti_fcf. anti_fy anti_fyf. anti_jb anti_jbf. anti_jd anti_jdf. anti_jk anti_jkf. anti_js anti_jsf. anti_k anti_kf. anti_ka anti_kaf. anti_kp anti_kpf. anti_le anti_lef. anti_lf anti_lff. anti_m anti_mf. anti_n anti_nf. anti_ot anti_otf. anti_p1 anti_p1f. anti_s anti_sf. anti_v anti_vf. antib_c antib_cf. antib_e antib_ef. antib_f antib_ff. antib_k antib_kf. antib_s antib_sf. antib_u antib_uf. bba_rec bba_recf. bbp_rec bbp_recf. cbc cbcf. cbc_rec cbc_recf. chem_rec chem_recf. coombs coombsf. del_hem del_hemf. direct directf. disc_su disc_suf. ernotes ernotesf. febrile febrilef. fld_ovl fld_ovlf. formcom formcomf. hydratn hydratnf. hyperte hypertef. indirec indirecf. labrpts labrptsf. new_k new_kf. new_oth new_othf. othreac othreacf. othtrea othtreaf. pt_die pt_dief. ser_che ser_chef. transfu transfuf. urin_rec urin_recf. urinaly urinalyf. urinhem urinhemf.;
	run;

*F033fmts.txt;

proc format;

  value BACTERIF
    1='1: No'
    2='2: Yes';

  value BRAINEDF
    1='1: No'
    2='2: Yes';

  value DISAB_SF
    1='1: No symptoms'
    2='2: Symptoms but no disability'
    3='3: Mild-moderate disability'
    4='4: Major disability';

  value INFECTIF
    1='1: No'
    2='2: Yes';

  value OTH_INFF
    1='1: No'
    2='2: Yes';

  value PT_DISCF
    1='1: Home'
    2='2: Rehabilitation center'
    3='3: Chronic care facility'
    4='4: Died during hospitalization';

  value REASONF
    1='1: Neurological Event'
    2='2: Meningitis'
    3='3: Head injury';

  value SEIZUREF
    1='1: No'
    2='2: Yes';

  value STROKREF
    1='1: No'
    2='2: Yes';

  value VIRALF
    1='1: No'
    2='2: Yes';
    
proc datasets library = outlib;
	modify P033_FINAL;
	format bacteri bacterif. brained brainedf. disab_s disab_sf. infecti infectif. oth_inf oth_inff. pt_disc pt_discf. reason reasonf. seizure seizuref. strokre strokref. viral viralf.;
	run;

*F040fmts.txt;

proc format;

  value ADDRESSF
    1='1: A STOP Hospital'
    2='2: A non-STOP Hospital'
    3='3: A chronic care facility'
    4="4: The patient's home"
    5='5: Other';

  value AUTOPSYF
    1='1: No'
    2='2: Yes'
    9='9: DK';

  value CAUSCLASF
    1='1: Neurological Event'
    2='2: Other'
    3='3: Unkown - Sudden Death'
    4='4: Unknown - No Information';

  value CAUSTYPEF
    1='1: Cerebral Infarction'
    2='2: Intracranial Hemorrhage'
    3='3: Other';

  value DEATH_TMF
    1='1: Pronounced dead on arrival at hospital'
    2='2: Died in emergency room or within 24 hours of admission'
    3='3: Died more than 24 hours after admission';

  value DTH_CERTF
    1='1: No'
    2='2: Yes';

  value IMFAMILYF
    1='1: No'
    2='2: Yes';

  value INFO_OTHF
    1='1: No'
    2='2: Yes';

  value MED_PERSF
    1='1: No'
    2='2: Yes';

  value MED_RECSF
    1='1: No'
    2='2: Yes';

proc datasets library = outlib;
	modify P040_FINAL;
	format address addressf. autopsy autopsyf. causclas causclasf. caustype caustypef. death_tm death_tmf. dth_cert dth_certf. imfamily imfamilyf. info_oth info_othf. med_pers med_persf. med_recs med_recsf.;
	run;

*F052fmts.txt;

proc format;

  value NEWSTROKF
    1='1: No'
    2='2: Yes';

  value NSTRK_SPF
    1='1: Infraction'
    2='2: Intraparenchymal Hemorrhage'
    3='3: Subarachnoid Hemorrhage'
    4='4: Intraventricular Hemorrhage';

  value NSTRKDXF
    1='1: TIA'
    2='2: Seizure'
    3='3: Migraine'
    4='4: Non-CNS event'
    5='5: Other'
    6='6: Cannot determine';

  value STROK1F
    1='1: No'
    2='2: Yes';

  value STROK2F
    1='1: No'
    2='2: Yes';

  value STROK3F
    1='1: No'
    2='2: Yes';

proc datasets library = outlib;
	modify P052_FINAL;
	format newstrok newstrokf. nstrk_sp nstrk_spf. nstrkdx nstrkdxf. strok1 strok1f. strok2 strok2f. strok3 strok3f.;*F052fmts.txt;
	run;

*F13Bfmts.txt;

proc format;

  value REAS1F
    1='1: Entry Visit'
    2='2: Quarterly Visit'
    3='3: Pre-transfusion';

  value REAS2F
    1='1: Entry Visit'
    2='2: Quarterly Visit'
    3='3: Pre-transfusion';

  value TRANSF_4F
    1='1: No'
    2='2: Yes';

  value CBC_SRCEF
    1='1: No'
    2='2: Yes';

  value HBS_SRCEF
    1='1: No'
    2='2: Yes';

  value FERRSRCEF
    1='1: No'
    2='2: Yes';

  value LFT_SRCEF
    1='1: No'
    2='2: Yes';

proc datasets library = outlib;
	modify P13B_FINAL;
	format reas1 reas1f. reas2 reas2f. transf_4 transf_4f. cbc_srce cbc_srcef. hbs_srce hbs_srcef. ferrsrce ferrsrcef. lft_srce lft_srcef.;
	run;

*F15Afmts.txt;

proc format;

  value INTR_HEMF
    1='1: No'
    2='2: Yes';

  value MRI_PERFF
    1='1: No'
    2='2: Yes';

  value PI_REVF
    1='1: No'
    2='2: Yes';

  value ACCEPTABF
    1='1: No'
    2='2: Yes';

  value ATROPHYJF
    1='1: No atrophy'
    2='2: Atrophy'
    3='3: Equivocal';

  value INTHEMORF
    1='1: No'
    2='2: Yes';

  value SCANQUALF
    1='1: Excellent'
    2='2: Slight artifact/motion,Adequate'
    3='3: Severe artifact/motion,Inadequate';
  
proc datasets library = outlib;
	modify P15A_FINAL;
	format intr_hem intr_hemf. mri_perf mri_perff. pi_rev pi_revf. acceptab acceptabf. atrophyj atrophyjf. inthemor inthemorf. scanqual scanqualf.;
	run;

*F16Bfmts.txt;

proc format;

  value SEPTICEMF
    1='1: No'
    2='2: Yes';

  value SEIZURESF
    1='1: No'
    2='2: Yes';

  value A_NECROSF
    1='1: No'
    2='2: Yes';

  value A_T_VERIF
    1='1: No'
    2='2: Yes';

  value ANYMEDSF
    1='1: No'
    2='2: Yes';

  value APLASTICF
    1='1: No'
    2='2: Yes';

  value ASTHMAF
    1='1: No'
    2='2: Yes';

  value CANCERF
    1='1: No'
    2='2: Yes';

  value CHDF
    1='1: No'
    2='2: Yes';

  value CHR_LUNGF
    1='1: No'
    2='2: Yes';

  value CHRLIVERF
    1='1: No'
    2='2: Yes';

  value CHRRENALF
    1='1: No'
    2='2: Yes';

  value DIABETESF
    1='1: No'
    2='2: Yes';

  value ELEV_BLDF
    1='1: No'
    2='2: Yes';

  value FEVERF
    1='1: No'
    2='2: Yes';

  value FOLATEF
    1='1: No'
    2='2: Yes';

  value H_F_SYNDF
    1='1: No'
    2='2: Yes';

  value HEADINJRF
    1='1: No'
    2='2: Yes';

  value HEPBVACCF
    1='1: No'
    2='2: Yes';

  value HYDROXYUF
    1='1: No'
    2='2: Yes';

  value INT_TYPEF
    1='1: Patient'
    2='2: Parent'
    3='3: Legal guardian'
    4='4: Other';

  value IRONCHELF
    1='1: No'
    2='2: Yes';

  value IRONOVERF
    1='1: No'
    2='2: Yes';

  value LULCERSF
    1='1: No'
    2='2: Yes';

  value MENINGITF
    1='1: No'
    2='2: Yes';

  value NEWNEUROF
    1='1: No'
    2='2: Yes';

  value NON_STOPF
    1='1: No'
    2='2: Yes';

  value OSTEOMYLF
    1='1: No'
    2='2: Yes';

  value OTH_ANTIF
    1='1: No'
    2='2: Yes';

  value OTH_EVNTF
    1='1: No'
    2='2: Yes';

  value OTH_MEDF
    1='1: No'
    2='2: Yes';

  value OTHCONDF
    1='1: No'
    2='2: Yes';

  value PENCILLNF
    1='1: No'
    2='2: Yes';

  value PNEUMONIF
    1='1: No'
    2='2: Yes';

  value PORTACTHF
    1='1: No'
    2='2: Yes';

  value PRIAPF
    1='1: No'
    2='2: Yes';

  value PRIAPISMF
    1='1: No'
    2='2: Yes';

  value RBCANTIF
    1='1: No'
    2='2: Yes';

  value RHEUMATCF
    1='1: No'
    2='2: Yes';

  value SC_RETINF
    1='1: No'
    2='2: Yes';

  value SEENAPLSF
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value SEENFEVRF
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value SEENOTHF
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value SEENPNEUF
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value SEENPRIAF
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value SEENREACF
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value SEENSEPTF
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value SEENSPLNF
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value SEENSURGF
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value SEENTRANF
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value SEENVASOF
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value SPLENICSF
    1='1: No'
    2='2: Yes';

  value STROKEF
    1='1: No'
    2='2: Yes';

  value SURGERYF
    1='1: No'
    2='2: Yes';

  value T_REACTNF
    1='1: No'
    2='2: Yes';

  value TRANFUSNF
    1='1: No'
    2='2: Yes';

  value TUBERCULF
    1='1: No'
    2='2: Yes';

  value VASOPAINF
    1='1: No'
    2='2: Yes';

proc datasets library = outlib;
	modify P16B_FINAL;
	format septicem septicemf. seizures seizuresf. a_necros a_necrosf. a_t_veri a_t_verif. anymeds anymedsf. aplastic aplasticf. asthma asthmaf. cancer cancerf. chd chdf. chr_lung chr_lungf. chrliver chrliverf. chrrenal chrrenalf. diabetes diabetesf. elev_bld elev_bldf. fever feverf. folate folatef. h_f_synd h_f_syndf. headinjr headinjrf. hepbvacc hepbvaccf. hydroxyu hydroxyuf. int_type int_typef. ironchel ironchelf. ironover ironoverf. lulcers lulcersf. meningit meningitf. newneuro newneurof. non_stop non_stopf. osteomyl osteomylf. oth_anti oth_antif. oth_evnt oth_evntf. oth_med oth_medf. othcond othcondf. pencilln pencillnf. pneumoni pneumonif. portacth portacthf. priap priapf. priapism priapismf. rbcanti rbcantif. rheumatc rheumatcf. sc_retin sc_retinf. seenapls seenaplsf. seenfevr seenfevrf. seenoth seenothf. seenpneu seenpneuf. seenpria seenpriaf. seenreac seenreacf. seensept seenseptf. seenspln seensplnf. seensurg seensurgf. seentran seentranf. seenvaso seenvasof. splenics splenicsf. stroke strokef. surgery surgeryf. t_reactn t_reactnf. tranfusn tranfusnf. tubercul tuberculf. vasopain vasopainf.;
	run;

*F16Rfmts.txt;

proc format;

  value SEIZURESF
    1='1: No'
    2='2: Yes';

  value SEPSEEN1F
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value APLAS_C1F
    1='1: No'
    2='2: Yes';

  value APLASTICF
    1='1: No'
    2='2: Yes';

  value APLSEEN1F
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value FEVERF
    1='1: No'
    2='2: Yes';

  value FEVER_C1F
    1='1: No'
    2='2: Yes';

  value FEVER_C2F
    1='1: No'
    2='2: Yes';

  value FEVER_C3F
    1='1: No'
    2='2: Yes';

  value FEVER_C4F
    1='1: No'
    2='2: Yes';

  value FEVSEEN1F
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value FEVSEEN2F
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value FEVSEEN3F
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value FEVSEEN4F
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value HF_SYNDF
    1='1: No'
    2='2: Yes';

  value MENINGITF
    1='1: No'
    2='2: Yes';

  value OSTEO_C1F
    1='1: No'
    2='2: Yes';

  value OSTEOMYEF
    1='1: No'
    2='2: Yes';

  value OSTSEEN1F
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value OTHERF
    1='1: No'
    2='2: Yes';

  value OTHER_C1F
    1='1: No'
    2='2: Yes';

  value OTHER_C2F
    1='1: No'
    2='2: Yes';

  value OTHER_C3F
    1='1: No'
    2='2: Yes';

  value OTHSEEN1F
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value OTHSEEN2F
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value OTHSEEN3F
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value PNEUMONAF
    1='1: No'
    2='2: Yes';

  value PNEUSEN1F
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value PNUEM_C1F
    1='1: No'
    2='2: Yes';

  value PRIAP_C1F
    1='1: No'
    2='2: Yes';

  value PRIAPISMF
    1='1: No'
    2='2: Yes';

  value PRISEEN1F
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value PTGROUPF
    1='1: Potential Candidate'
    2='2: Randomized Patient';

  value RCTSEEN1F
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value REACT_C1F
    1='1: No'
    2='2: Yes';

  value SEPSEEN2F
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value SEPTC_C1F
    1='1: No'
    2='2: Yes';

  value SEPTC_C2F
    1='1: No'
    2='2: Yes';

  value SEPTICEMF
    1='1: No'
    2='2: Yes';

  value SPLENSEQF
    1='1: No'
    2='2: Yes';

  value SPLSEEN1F
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value SPLSEQC1F
    1='1: No'
    2='2: Yes';

  value STROK_C1F
    1='1: No'
    2='2: Yes';

  value STROKEF
    1='1: No'
    2='2: Yes';

  value STRSEEN1F
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value SURG_C1F
    1='1: No'
    2='2: Yes';

  value SURG_C2F
    1='1: No'
    2='2: Yes';

  value SURG_C3F
    1='1: No'
    2='2: Yes';

  value SURGERYF
    1='1: No'
    2='2: Yes';

  value SURGSEN1F
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value SURGSEN2F
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value SURGSEN3F
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value T_REACTNF
    1='1: No'
    2='2: Yes';

  value TIAF
    1='1: No'
    2='2: Yes';

  value TIA_C1F
    1='1: No'
    2='2: Yes';

  value TIASEEN1F
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value TRANF_C1F
    1='1: No'
    2='2: Yes';

  value TRANF_C2F
    1='1: No'
    2='2: Yes';

  value TRANF_C3F
    1='1: No'
    2='2: Yes';

  value TRANF_C4F
    1='1: No'
    2='2: Yes';

  value TRANF_C5F
    1='1: No'
    2='2: Yes';

  value TRANSFSNF
    1='1: No'
    2='2: Yes';

  value TRNSEEN1F
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value TRNSEEN2F
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value TRNSEEN3F
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value TRNSEEN4F
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value TRNSEEN5F
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value VASOP_C1F
    1='1: No'
    2='2: Yes';

  value VASOP_C2F
    1='1: No'
    2='2: Yes';

  value VASOP_C3F
    1='1: No'
    2='2: Yes';

  value VASOPAINF
    1='1: No'
    2='2: Yes';

  value VASOSEN1F
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value VASOSEN2F
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

  value VASOSEN3F
    1='1: STOP II Center'
    2='2: Non-STOP II Center';

proc datasets library = outlib;
	modify P16R_FINAL;
	format seizures seizuresf. sepseen1 sepseen1f. aplas_c1 aplas_c1f. aplastic aplasticf. aplseen1 aplseen1f. fever feverf. fever_c1 fever_c1f. fever_c2 fever_c2f. fever_c3 fever_c3f. fever_c4 fever_c4f. fevseen1 fevseen1f. fevseen2 fevseen2f. fevseen3 fevseen3f. fevseen4 fevseen4f. hf_synd hf_syndf. meningit meningitf. osteo_c1 osteo_c1f. osteomye osteomyef. ostseen1 ostseen1f. other otherf. other_c1 other_c1f. other_c2 other_c2f. other_c3 other_c3f. othseen1 othseen1f. othseen2 othseen2f. othseen3 othseen3f. pneumona pneumonaf. pneusen1 pneusen1f. pnuem_c1 pnuem_c1f. priap_c1 priap_c1f. priapism priapismf. priseen1 priseen1f. ptgroup ptgroupf. rctseen1 rctseen1f. react_c1 react_c1f. sepseen2 sepseen2f. septc_c1 septc_c1f. septc_c2 septc_c2f. septicem septicemf. splenseq splenseqf. splseen1 splseen1f. splseqc1 splseqc1f. strok_c1 strok_c1f. stroke strokef. strseen1 strseen1f. surg_c1 surg_c1f. surg_c2 surg_c2f. surg_c3 surg_c3f. surgery surgeryf. surgsen1 surgsen1f. surgsen2 surgsen2f. surgsen3 surgsen3f. t_reactn t_reactnf. tia tiaf. tia_c1 tia_c1f. tiaseen1 tiaseen1f. tranf_c1 tranf_c1f. tranf_c2 tranf_c2f. tranf_c3 tranf_c3f. tranf_c4 tranf_c4f. tranf_c5 tranf_c5f. transfsn transfsnf. trnseen1 trnseen1f. trnseen2 trnseen2f. trnseen3 trnseen3f. trnseen4 trnseen4f. trnseen5 trnseen5f. vasop_c1 vasop_c1f. vasop_c2 vasop_c2f. vasop_c3 vasop_c3f. vasopain vasopainf. vasosen1 vasosen1f. vasosen2 vasosen2f. vasosen3 vasosen3f.;
	run;

*F18Tfmts.txt;

proc format;

  value FIRST18TF
    1='1: No'
    2='2: Yes';

  value NEWVISITF
    1='1: No'
    2='2: Yes';

  value REAS_NOTF
    1='1: Patient Lost-To-Follow-Up'
    2='2: Patient Refusing'
    3='3: Patient Moved'
    4='4: Patient Ill'
    5='5: TCD Examiner Not Available'
    99='99: Other';

  value REASMIS1F
    1='1: Patient Did Not Show'
    2='2: Patient Ill'
    3='3: Patient Lost To Follow-Up'
    4='4: Patient Moved'
    5='5: TCD Examiner Not Available'
    6='6: TCD Machine Malfunction'
    99='99: Other';

  value REASMIS2F
    1='1: Patient Did Not Show'
    2='2: Patient Ill'
    3='3: Patient Lost To Follow-Up'
    4='4: Patient Moved'
    5='5: TCD Examiner Not Available'
    6='6: TCD Machine Malfunction'
    99='99: Other';

  value REASMIS3F
    1='1: Patient Did Not Show'
    2='2: Patient Ill'
    3='3: Patient Lost To Follow-Up'
    4='4: Patient Moved'
    5='5: TCD Examiner Not Available'
    6='6: TCD Machine Malfunction'
    99='99: Other';

  value TCDSCHEDF
    1='1: No'
    2='2: Yes';

proc datasets library = outlib;
	modify P18T_FINAL;
	format first18t first18tf. newvisit newvisitf. reas_not reas_notf. reasmis1 reasmis1f. reasmis2 reasmis2f. reasmis3 reasmis3f. reasmis4 reasmis4f. tcdsched tcdschedf.;
	run;

*WARNING: Variable REASMIS4 not found in data set OUTLIB.P18T_FINAL.;

*F23Afmts.txt;

proc format;

  value ADMNF
    1='1: At home'
    2='2: In clinic'
    3='3: In hospital'
    9='9: Other';

  value CH_THPYF
    1='1: No'
    2='2: Yes';

  value CMNTSF
    1='1: No'
    2='2: Yes';

  value $CURRCHELF
    "1"="1: Yes"
    "2"="2: No";

  value $DEG_COMPF
    "1"="1: High"
    "2"="2: Moderate"
    "3"="3: Poor";

  value METHODF
    1='1: Subcutaneous'
    2='2: Intravenous'
    3='3: Intramuscular';

proc datasets library = outlib;
	modify P23A_FINAL;
	format admn admnf. ch_thpy ch_thpyf. cmnts cmntsf. currchel $currchelf. deg_comp $deg_compf. method methodf.;
	run;

*FQ30fmts.txt;

proc format;

  value A_ANEMIAF
    1='1: No'
    2='2: Yes'
    3="3: Don't Know";

  value A_CHESTF
    1='1: No'
    2='2: Yes'
    3="3: Don't Know";

  value A_FEBRILF
    1='1: No'
    2='2: Yes'
    3="3: Don't Know";

  value A_PRIAPISMF
    1='1: No'
    2='2: Yes'
    3="3: Don't Know";

  value ANESTHESF
    1='1: No'
    2='2: Yes'
    3="3: Don't Know";

  value ARTERIOGF
    1='1: Not Done'
    2='2: Done';

  value BEHAVIORF
    1='1: No'
    2='2: Yes';

  value CHG_MENTF
    1='1: No'
    2='2: Yes';

  value COORDINAF
    1='1: No'
    2='2: Yes';

  value CT_BRAINF
    1='1: Not Done'
    2='2: Done';

  value D_VISIONF
    1='1: No'
    2='2: Yes';

  value DIF_SPEKF
    1='1: No'
    2='2: Yes';

  value DIZZINESF
    1='1: No'
    2='2: Yes';

  value DSWALLOWF
    1='1: No'
    2='2: Yes';

  value DWI_PERFF
    1='1: No'
    2='2: Yes';

  value EV_TYPEF
    1='1: Cerebral Infarction'
    2='2: Intracranial Hemorrhage'
    3='3: TIA'
    4='4: Seizure'
    5='5: Other';

  value HEAD_INJF
    1='1: No'
    2='2: Yes'
    3="3: Don't Know";

  value HEADACHEF
    1='1: No'
    2='2: Yes';

  value INTERVIEF
    1='1: Patient'
    2='2: Parent'
    3='3: Other';

  value LOSSCONSF
    1='1: No'
    2='2: Yes';

  value MRABRAINF
    1='1: Not Done'
    2='2: Done';

  value MRIBRAINF
    1='1: Not Done'
    2='2: Done';

  value NEUREVALF
    1='1: No'
    2='2: Yes';

  value O_EVENTSF
    1='1: No'
    2='2: Yes';

  value O_IMAGEF
    1='1: Not Done'
    2='2: Done';

  value OTH_EXPRF
    1='1: No'
    2='2: Yes'
    3="3: Don't Know";

  value PAINFULF
    1='1: No'
    2='2: Yes'
    3="3: Don't Know";

  value PETBRAINF
    1='1: Not Done'
    2='2: Done';

  value PT_DIEF
    1='1: No'
    2='2: Yes';

  value PT_HOSPF
    1='1: No'
    2='2: Yes';

  value PT_TRANSF
    1='1: No'
    2='2: Yes';

  value SEIZUREF
    1='1: No'
    2='2: Yes';

  value SENSDISTF
    1='1: No'
    2='2: Yes';

  value SYMPRPTDF
    1='1: No'
    2='2: Yes';

  value TRANSDOPF
    1='1: Not Done'
    2='2: Done';

  value TRANSFUSF
    1='1: No'
    2='2: Yes'
    3="3: Don't Know";

  value WEAKNESSF
    1='1: No'
    2='2: Yes';

  value WEAKSIDEF
    1='1: Right'
    2='2: Left'
    3='3: Both';

  value WHERSEENF
    1='1: Stop II Center'
    2='2: Other';

  value WITNES_EF
    1='1: No'
    2='2: Yes';

proc datasets library = outlib;
	modify PQ30_FINAL;
	format a_anemia a_anemiaf. a_chest a_chestf. a_febril a_febrilf. a_priapism a_priapismf. anesthes anesthesf. arteriog arteriogf. behavior behaviorf. chg_ment chg_mentf. coordina coordinaf. ct_brain ct_brainf. d_vision d_visionf. dif_spek dif_spekf. dizzines dizzinesf. dswallow dswallowf. dwi_perf dwi_perff. ev_type ev_typef. head_inj head_injf. headache headachef. intervie intervief. losscons lossconsf. mrabrain mrabrainf. mribrain mribrainf. neureval neurevalf. o_events o_eventsf. o_image o_imagef. oth_expr oth_exprf. painful painfulf. petbrain petbrainf. pt_die pt_dief. pt_hosp pt_hospf. pt_trans pt_transf. seizure seizuref. sensdist sensdistf. symprptd symprptdf. transdop transdopf. transfus transfusf. weakness weaknessf. weakside weaksidef. wherseen wherseenf. witnes_e witnes_ef.;
	run;

*FQ52fmts.txt;

proc format;

  value NEWSTROKF
    1='1: No'
    2='2: Yes';

  value NSTRKDXF
    1='1: TIA'
    2='2: Seizure'
    3='3: Migraine'
    4='4: Non-CNS event'
    5='5: Other'
    6='6: Cannot determine';

  value STROK1F
    1='1: No'
    2='2: Yes';

  value STROK2F
    1='1: No'
    2='2: Yes';

proc datasets library=outlib;
	modify PQ52_FINAL;
	format newstrok newstrokf. nstrkdx nstrkdxf. strok1 strok1f. strok2 strok2f.;
	run;

*Rand_tablefmts.txt;

proc format;

value INFARCTF
 1='1: No Infarct'
 2='2: Infarct';

value TREATMENTF
 1='1: Continue Transfusions'
 2='2: Discontinue Transfusions';

value DROPOUTF
 1='1: No'
 2='2: Yes';

value EPF
1='1: No'
2='2: Yes';

value EPWHYF
 1='1: 2 consecutive abnormal TCDs'
 2='2: Moving average >=200 cm/sec'
 3='3: Stroke'
 4='4: Three consecutive inadequate TCDs + mod.-severe stenosis on MRA';

value XOVERF
 1='1: No'
 2='2: Yes';

value POSTXO_EPF
 1='1: No'
 2='2: Yes';

value Q6M_MRASF
 1='1: No'
 2='2; Yes';

proc datasets library=outlib;
	modify PRAND_TABLE_FINAL;
	format infarct infarctf. treatment treatmentf. dropout dropoutf. ep epf. epwhy epwhyf. xover xoverf. postxo_ep postxo_epf. q6m_mras q6m_mrasf.;
	run;

*Rst2fmts.txt;

proc format;

   value GENDERF
    1='1: Female'
    2='2: Male';

  value HB_DIAGF
    1='1: SS'
    2='2: SB0 Thalassemia';

  value ANY_SIBSF
    1='1: No'
    2='2: Yes';

*  formats for variables added to rst2 dataset;
 
  value NEW_RACEF
    1='1: Black/African American/not Latin origin'
    2='2: Black/African American/of Latin origin'
    3='3: Other';

proc datasets library=outlib;
	modify PRST2_FINAL;
	format gender genderf. hb_diag hb_diagf. any_sibs any_sibsf. race racef.;
	run;
*WARNING: Variable RACE not found in data set OUTLIB.PRST2_FINAL.;

proc datasets lib=outlib;
contents data=_ALL_ out=outlib.metadata;
run;