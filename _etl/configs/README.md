
# Metadata Schema Documentation

This document explains the structure and purpose of the `metadata.schema.json` file.

## Overview

The schema defines the structure for an array of studies, where each study includes detailed information about its forms, variables, and hierarchical data.

## Schema Structure

### Top-Level Properties

- **study_name** *(string, required)*: Full name of the study.
- **study** *(string)*: Short identifier for the study.
- **study_phs_number** *(string, required)*: Public Health Service (PHS) number for the study.
- **study_url** *(string, URI)*: URL linking to the study details.
- **form_group** *(array, required)*: List of form groups associated with the study.

### `form_group` Object

- **form_group** *(string, required)*: Name or category of the form group.
- **form** *(array, required)*: List of forms within the group.

### `form` Object

- **form** *(string, required)*: Name of the form.
- **form_description** *(string)*: Description of the form.
- **form_name** *(string)*: Alternate or display name of the form.
- **variable_group** *(array, required)*: Groups of variables associated with the form.

### `variable_group` Object

- **variable_group_name** *(string)*: Name of the variable group.
- **variable_group_description** *(string)*: Description of the variable group.
- **variable** *(array, required)*: List of variables within the group.

### `variable` Object

- **variable_id** *(string, required)*: Unique identifier for the variable.
- **variable_name** *(string, required)*: Descriptive name of the variable.
- **variable_type** *(string)*: Data type of the variable. Must be one of: `"num"`, `"string"`, `"boolean"`, `"date"`.
- **variable_description** *(string|null)*: Description of what the variable represents.
- **data_hierarchy** *(string, required)*: Hierarchical representation of the variable within the dataset.
- **drs_uri** *(array)*: List of Data Retrieval System (DRS) URIs for accessing the variable.
- **derived_variable_level_data** *(array)*: Derived data associated with the variable.

## Requirements

- Fields marked as **required** must be present in the JSON data to be valid against this schema.
- URI fields must adhere to proper URI formatting.

## Usage

This schema can be used to validate metadata JSON documents for studies and their associated forms and variables.

