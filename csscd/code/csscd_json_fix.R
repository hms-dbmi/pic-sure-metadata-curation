library(jsonlite)
library(tidyr)
library(tidyverse)
library(jsonlite)

csscd_json <- "~/Documents/pic-sure-metadata-curation/csscd/output/csscd_metadata.json"

csscd_df <- as.data.frame(fromJSON(csscd_json))

wide_df <- unnest(csscd_df, form_group)

wide_df <- unnest(wide_df,form)

wide_df <- unnest(wide_df, variable)


#### var level

final_df <- data.frame(wide_df %>%
                         select(form_name,form_description, data_file_name, form_group_name, form_group_description) %>%
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
                         select(form_name,form_description, data_file_name, form_group_name, form_group_description) %>%
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

final_form_df <- data.frame(final_df2 %>%
                          select(form_group_name, form_group_description) %>%
                          unique())

rownames(final_form_df) <- NULL

for (ind in c(1:nrow(final_form_df))) {
  form_df <- final_df2 %>%
    filter(form_group_name == final_form_df[ind, "form_group_name"]) %>%
    select(form_name, form_description, data_file_name, variable_group)
  form_df <- data.frame(form_df)
  final_form_df[ind, "form"][[1]] <- list(form_df)
}


############# Study Level
complete_df <- data.frame('study_name' = 'Cooperative Study of Sickle Cell Disease (CSSCD)',
                       'study' = 'CSSCD',
                       'study_phs_number' = 'phs002362',
                       'study_url' = 'https://www.ncbi.nlm.nih.gov/projects/gap/cgi-bin/study.cgi?study_id=phs002362.v1.p1')

complete_df$form_group <- list(final_form_df)



######## To json
my_json <- toJSON(complete_df, pretty=FALSE)

json_string <- as.character(my_json) # Convert to character/string
fileConn <- file("~/Documents/fixed_csscd_metadata.json")
writeLines(json_string, fileConn)
close(fileConn)



