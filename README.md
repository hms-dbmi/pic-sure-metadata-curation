# pic-sure-metadata-curation GitHub repository

This repository contains files used to curate the metadata associated with BioLINCC studies for search in BioData Catalyst Powered by PIC-SURE. The final output of this process is a JSON file containing information about the study, forms, and variables. The table below describes the general format of these JSON files.

| Level                                                                    | Info                         | Name in JSON                        | Info in JSON                                                                                                                                                                              |
|--------------------------------------------------------------------------|------------------------------|-------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Study-level                                                              | Study abbreviation           | study                               | Abbreviation of the study                                                                                                                                                                 |
|                                                                          | Study name                   | study_name                          | Full name of the study                                                                                                                                                                    |
|                                                                          | Study phs number             | study_phs_number                    | PHS number of the study                                                                                                                                                                   |
|                                                                          | Study description or link    | study_description                   | For BioLINCC, this will be a link to the main dbGaP page of the study                                                                                                                     |
|                                                                          | Study metadata               | study_metadata                      | Any additional information to include at the study level                                                                                                                                  |
| Form group level. Note: this level will not be applicable to all studies | Form group-level name        | form_group                          | Name of the following level of JSON                                                                                                                                                       |
|                                                                          | Group name of forms          | form_group_name                     | Name of the form group                                                                                                                                                                    |
|                                                                          | Form group description       | form_group_description              | Description association with the form group                                                                                                                                               |
|                                                                          | Form group metadata          | form_group_metadata                 | Any additional information to include at the form group level                                                                                                                             |
| Form-level                                                               | Form-level name              | form                                | Name of the following level of JSON                                                                                                                                                       |
|                                                                          | Form name                    | form_name                           | Name/number of the form                                                                                                                                                                   |
|                                                                          | Form description             | form_description                    | Description of the form                                                                                                                                                                   |
|                                                                          | Data file name               | data_file_name                      | Name of the file corresponding to the data in SAS or otherwise (from MEMNAME column)                                                                                                      |
|                                                                          | Form/file metadata           | form_metadata                       | Any additional information to include at the form level                                                                                                                                   |
| Variable group. Note: This level will not be applicable to all studies   | Variable group-level name    | variable_group                      | Name of the following level of JSON                                                                                                                                                       |
|                                                                          | Variable group name          | variable_group_name                 | Name of the variable group                                                                                                                                                                |
|                                                                          | Variable group description   | variable_group_description          | Description of the variable group                                                                                                                                                         |
|                                                                          | Variable group metadata      | variable_group_metadata             | Any additional information to include at the variable group level                                                                                                                         |
| Variable-level                                                           | Variable level name          | variable                            | Name of the following level of JSON                                                                                                                                                       |
|                                                                          | Variable id                  | variable_id                         | Encoded name of the variable found in the data                                                                                                                                            |
|                                                                          | Variable name                | variable_name                       | Decoded name of the variable. If multiple decoded names found, select one. (For example: in REDCORAL, if SAS decoded name is present, use SAS decoded name, else use datadictionary name) |
|                                                                          | Type of variable             | variable_type                       | Categorical, continuous, or unknown. Transformed from SAS output                                                                                                                          |
| Variable-level metadata                                                  | Variable level metadata name | variable_metadata                   | Name of following level of JSON                                                                                                                                                           |
|                                                                          | Data dictionary label        | variable_label_from_data_dictionary | Decoded name of the variable found in data dictionary or other documentation                                                                                                              |
|                                                                          | Data file label              | variable_label_from_data_file       | Decoded name of the variable found in the SAS files                                                                                                                                       |
|                                                                          | Variable description         | variable_description                | Description about the variable                                                                                                                                                            |


For example, the JSON file could look like this:
[{
  "study":"STUDY ONE",
  "study_name":"Full Name of Study One (STUDY ONE)",
  "phs_number":"phs000000",
  "study_description":"link_to_dbGaP_study_one",
  "study_metadata":[{
    "some..":"information…"
  }],
  "form_group":[{
  	"form_group_name":"Group one of forms",
    "form_group_description":"Description about group one of forms from STUDY   ONE",
    "form_group_metadata":[{
      "some..":"information.."
    }],
    "form":[{
      "form_name":"Form 1",
      "form_description":"Description of Form 1 from group one of forms of STUDY   ONE",
      "data_file_name":"name_of_corresponding_data_file",
      "form_metadata":[{
        "some..":"information.."
      }],
      "variable_group":[{
        "variable_group_name":"Variable group 1",
        "variable_group_description":"Description of variable group 1 from Form   1 of form group one",
        "variable_group_metadata":[{
          "some":"information"
        }],
        "variable":[{
          "variable_id":"variable_one",
          "variable_name":"Variable One",
          "var_type":"categorical/continuous",
          "variable_metadata":[{
            "variable_label_from_data_dictionary":"Variable number One",
            "variable_label_from_data_file":"Variable One",
            "variable_description":"Description of variable one",
            "some":"information"
          }]
        }]
      }]
    }]
  }]
}]
