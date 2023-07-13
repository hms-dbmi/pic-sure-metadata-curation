library(jsonlite)
library(tidyr)
library(tidyverse)
library(jsonlite)

hct_json <- "~/Documents/pic-sure-metadata-curation/hct_for_scd/output/OLD_hct_for_scd_metadata.json"

hct_df <- as.data.frame(fromJSON(hct_json))

form_info_df <- read_csv("~/Documents/pic-sure-metadata-curation/hct_for_scd/intermediates/manually_curated_df.csv")

##### Converting Var ids to uppercase
wide_df <- unnest(unnest(unnest(unnest(hct_df,form_group),form),variable_group),variable)

wide_df <- wide_df %>% mutate(variable_id = toupper(variable_id))

##############
#wide_df <- unnest(hct_df, form)

#wide_df <- unnest(wide_df, variable)

wide_df <- unnest(wide_df, variable_metadata)


### Renaming fields

wide_df <- data.frame(lapply(wide_df, function(x) {
  gsub("Form Unknown", "Form Name Not Provided", x)    
}))


names(wide_df)[names(wide_df) == 'variable_was_computed'] <- '\"Computed Variable?\"'
names(wide_df)[names(wide_df) == 'variable_hct_status'] <- '\"HCT status\"'
names(wide_df)[names(wide_df) == 'variable_question_number_inform'] <- '\"CIBMTR Form number; (question numbers)\"'



# Fixing Form number variable

for (i in c(1:length(wide_df$variable_id))) {
  form_df_index <- match(tolower(wide_df$variable_id[i]),form_info_df$variable_id)
  wide_df$`"CIBMTR Form number; (question numbers)"`[i] <- form_info_df$form_id[form_df_index]
  
  #print(wide_df$variable_id[i])
  #print(form_info_df$form_id[form_df_index])
}  

### Add Hierarchy Tree

trees_vector <- vector(mode = "character",length = length(wide_df$variable_id))

for (i in c(1:length(wide_df$variable_id))) {
  study <- wide_df$study[i]
  #form_group <- 
  form <- wide_df$form_name[i]
  #variable_group <- 
  variable <- wide_df$variable_name[i]
  
  ## remove slashes "/" from variables included in the hierarchy
  
  tree <- paste0(wide_df$study[i], "/",wide_df$form_name[i], "/",wide_df$variable_name[i])
  trees_vector[i] <- tree
}  


full_df <- cbind(wide_df, trees_vector)
names(full_df)[names(full_df) == 'trees_vector'] <- 'hierarchy'

names(full_df)[names(full_df) == 'form_group_name'] <- 'form_group'


saveRDS(full_df,"~/Documents/pic-sure-metadata-curation/hct_for_scd/intermediates/full_df.rds")

