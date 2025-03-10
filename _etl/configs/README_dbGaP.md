
# dbGaP Single Study Data Schema Documentation

This document explains the structure and purpose of the `dbGaP Single Study Data` JSON schema.

## Overview

This schema is designed to structure data for a single dbGaP study, covering study-level information, subject data, and sequencing details.

## Schema Structure

### Top-Level Properties

- **error** *(object)*: Contains error information if the API processing failed.
  - **error_code** *(integer)*: Code representing the error.
  - **error_message** *(string)*: Descriptive message of the error.

- **pagination** *(object)*: Supports pagination for API responses.
  - **next_link** *(string)*: URL to the next page.
  - **prev_link** *(string)*: URL to the previous page.
  - **page** *(integer)*: Current page number.
  - **page_size** *(integer)*: Number of items per page.
  - **total** *(integer)*: Total number of items.

- **study** *(object)*: Main study information, including accession, consent groups, and sub-studies.
  - **accver** *(object, required)*: Accession and version information.
    - **accession** *(string)*: Study accession identifier.
    - **participant_set** *(integer)*: Participant set identifier.
    - **version** *(integer)*: Version number.
  - **admin_ic** *(string)*: Administrative information center.
  - **bioproject_ids** *(array)*: List of bioproject identifiers.
  - **consent_groups** *(array)*: All consent groups associated with the study.
  - **handle** *(string)*: Study handle.
  - **name** *(string)*: Name of the study.
  - **parent_study_accver** *(object)*: Parent study accession and version.
  - **repository** *(string)*: dbGaP subject namespace.
  - **study_status** *(string)*: Current status of the study.
  - **substudies** *(array)*: List of sub-studies.

- **study_stats** *(object)*: Statistics related to the study.
  - **cnt_by_consent_and_sample_use** *(array)*: Sample counts categorized by consent and usage.
  - **cnt_ea_samples** *(object)*: Counts related to Exchange Area (EA) samples.
  - **cnt_samples** *(object)*: General counts related to samples.
  - **cnt_seq_samples** *(object)*: Counts related to sequencing samples.
  - **cnt_seq_subjects** *(object)*: Counts related to sequencing subjects.
  - **cnt_subjects** *(object)*: General subject counts.
  - **prev_diff** *(object)*: Differences between current and previous versions for samples and subjects.
  - **run_status** *(object)*: Sequencing run status counts.
  - **studies_with_overlapping_subjects** *(array)*: Other studies sharing subjects with the current study.

- **subjects** *(array)*: Data on subjects in the study.
  - **dbgap_subject_id** *(integer)*: dbGaP subject identifier.
  - **sex** *(string)*: Gender of the subject.
  - **submitted_subject_id** *(string)*: Submitted subject identifier.
  - **type** *(string)*: Type of subject (`"regular"`, `"technical"`, `"control"`).
  - **samples** *(array)*: Sample data for the subject.
  - **consent_group** *(object)*: Consent group information.
  - **aliases** *(array)*: Alternative identifiers for the subject.

## Key Definitions

- **def_accession_version**: Structure for accession and versioning.
- **def_consent_group**: Details about consent groups.
- **def_sample_data**: Information about individual samples.
- **def_seq_data**: Deprecated summary of sequence data.
- **def_seq_run_data**: Data from sequencing runs.
- **def_sub_seq_data**: Information about submitted sequence data.
- **def_subject_data**: Data structure for subject information.
- **def_diff**: Differences in subject/sample counts between versions.

## Requirements

- Fields marked as **required** must be present in the JSON data to be valid against this schema.
- URI fields must adhere to proper URI formatting.

## Usage

This schema is used for validating and structuring JSON data for a single dbGaP study, supporting detailed metadata about studies, subjects, samples, and sequencing data.

