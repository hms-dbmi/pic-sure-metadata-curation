library(jsonlite)
library(tidyr)
library(tidyverse)
library(jsonlite)

hct_json <- "~/Documents/pic-sure-metadata-curation/hct_for_scd/output/OLD_hct_for_scd_metadata.json"

hct_df <- as.data.frame(fromJSON(hct_json))

##### Converting Var ids to uppercase
wide_df <- unnest(unnest(unnest(unnest(hct_df,form_group),form),variable_group),variable)

wide_df <- wide_df %>% mutate(variable_id = toupper(variable_id))

##############
wide_df <- unnest(hct_df, form)

wide_df <- unnest(wide_df, variable)


#### var level

final_df <- data.frame(wide_df %>%
                         select(form_name,form_description, data_file_name, form_id) %>%
                         unique())
final_df$variable_group_name <- "All variables"
final_df$variable_group_description <- "All variables within the form"
rownames(final_df) <- NULL

for (ind in c(1:nrow(final_df))) {
  var_df <- wide_df %>%
    filter(form_name == final_df[ind, "form_name"]) %>%
    select(variable_id, variable_name, variable_type, variable_metadata)
  var_df <- data.frame(var_df)
  final_df[ind, "variable"][[1]] <- list(var_df)
}

######## Variable Group

final_df2 <- data.frame(final_df %>%
                         select(form_name,form_description, data_file_name, form_id) %>%
                         unique())

rownames(final_df2) <- NULL


for (ind in c(1:nrow(final_df2))) {
  varg_df <- final_df %>%
    filter(form_name == final_df2[ind, "form_name"]) %>%
    select(variable_group_name, variable_group_description, variable)
  varg_df <- data.frame(varg_df)
  final_df2[ind, "variable_group"][[1]] <- list(varg_df)
}

###### Form Level

final_form_df <- data.frame(form_group_name= "All forms",
                            form_group_description= "All forms within the study")


rownames(final_form_df) <- NULL


final_form_df$form <- list(final_df2)


############# Study Level
study_df <- data.frame('study' = 'HCT for SCD', 
                       'study_name' = 'Hematopoietic Cell Transplant for Sickle Cell Disease',
                       'study_phs_number' = 'phs002385', 
                       'study_url' = 'https://www.ncbi.nlm.nih.gov/projects/gap/cgi-bin/study.cgi?study_id=phs002385.v1.p1')

study_df[1, 'form_group'][[1]] <- list(final_form_df)



######## To json
my_json <- toJSON(study_df, pretty=FALSE)

json_string <- as.character(my_json) # Convert to character/string
fileConn <- file("../output/hct_for_scd_metadata.json")
writeLines(json_string, fileConn)
close(fileConn)



