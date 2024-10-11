SELECT participant_id, enroll_protocol, enroll_site_id, enroll_hub_site_id, enroll_site_path, enroll_date, enroll_category, enroll_index_date, sex_at_birth, dob, age_at_enrollment, enroll_zip_code, withdrawn, withdraw_date, deceased, deceased_date
	into pediatric.demographics
	FROM peds.demographics;