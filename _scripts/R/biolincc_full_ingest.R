#library(jsonlite)
library(tidyverse)
#install.packages("readxl")
library(readxl)
library(dplyr)
library(stringr)
library(jsonlite)
#install.packages("sas7bdat")
library(sas7bdat)
library(haven)
library(XML)
library(tidyverse)
library(httr)

setwd("~/studies/avl-73-bdc-etl/development_biolincc/code")

study_list <- read_tsv("./study_list.tsv", show_col_types = F)

print("Making directories")

for (study in study_list$ps_abv) {
  if(!(dir.exists(paste0("../../",tolower(study))))){
    dir.create(paste0("../../",tolower(study)))
    dir.create(paste0("../../",tolower(study),"/decoded_data"))
    dir.create(paste0("../../",tolower(study),"/rawData"))
  }
}


print("Building dictionary")
for (study_i in (1:length(study_list$phs))) {
  
  print(study_list$ps_abv[study_i])
  problems(read_sas(paste0("../rawData/ensemble_",study_list$dmc_abv[study_i],"_",study_list$consent[study_i],"_dataset.sas7bdat")))
  problems(read_sas(paste0("../rawData/clones_",study_list$dmc_abv[study_i],"_",study_list$consent[study_i],"_schema.sas7bdat")))
  
  dataset_sas_df <- read_sas(paste0("../rawData/ensemble_",study_list$dmc_abv[study_i],"_",study_list$consent[study_i],"_dataset.sas7bdat"))
  print(dataset_sas_df)
  schema_df <- read_sas(paste0("../rawData/clones_",study_list$dmc_abv[study_i],"_",study_list$consent[study_i],"_schema.sas7bdat"))
  
  write.csv(dataset_sas_df,paste0("../../",tolower(study_list$ps_abv[study_i]),"/rawData/ensemble_",study_list$dmc_abv[study_i],"_",study_list$consent[study_i],"_dataset.csv"),row.names = F)
  write.csv(schema_df,paste0("../../",tolower(study_list$ps_abv[study_i]),"/rawData/clones_",study_list$dmc_abv[study_i],"_",study_list$consent[study_i],"_schema.csv"),row.names = F)
  
  # Updated regex for file matching.
  # ^ denotes the start of the string
  # $ denotes the end of the string
  # .* allows any characters before and after the phs value
  # wrapping the string in \b ensures we don't match sub strings.
  manifest_paths <- list.files(path = "../rawData/",pattern = paste0("^.*\\b", study_list$phs[study_i], "\\b.*$"))
  
  for( manifest_i in 1:length(manifest_paths)){
    path <- manifest_paths[manifest_i]
    print(path)
  }

  regex <- paste0("^.*\\b", study_list$phs[study_i], "\\b.*\\b",
                  study_list$consent[study_i], "\\b.*$")
  
  manifest_paths <- list.files(path = "../rawData/",pattern = regex)
  
  if (length(manifest_paths) != 1) {
    message("Expecting 1 manifest file: ", length(manifest_paths))
    break
  }
  
  manifest_path = manifest_paths[[1]]
  
  manifest <- read_tsv(paste0("../rawData/",manifest_path), show_col_types = F)

  expected_file_name <- paste0("ensemble_", study_list$dmc_abv[study_i], "_", study_list$consent[study_i], "_dataset.sas7bdat")
  matching_file_name <- manifest$file_name[str_ends(manifest$file_name, expected_file_name)]

  drs_path <- as.character(manifest$ga4gh_drs_uri[which(str_detect(manifest$file_name, expected_file_name))])
  
  dictionary_df <- data.frame(varname = schema_df$Variable, vardesc = schema_df$Label, type="num",decoding="",units="",table="", drs_uri=drs_path)
  
  # If Description not provided, replace with ID
  for (vari in c(1:length(dictionary_df$varname))) {
    if(str_length(dictionary_df$vardesc[vari])<2){
      #print(dictionary_df$varname[vari])
      dictionary_df$vardesc[vari] <- dictionary_df$varname[vari]
    }
  }
  
  dict_file_name = paste0("DataDictionary.",study_list$consent[study_i] ,".csv")
  
  write_path = file.path("..", "..", tolower(study_list$ps_abv[study_i]), "rawData", dict_file_name)
  
  write.csv(
    dictionary_df,
    write_path,
    row.names = FALSE
  )
  # no consent write
  write.csv(dictionary_df,paste0("../../",tolower(study_list$ps_abv[study_i]),"/rawData/DataDictionary.csv"),row.names = F)
}





print("Decoding and metadata json")

for (study_i in c(1:length(study_list$ps_abv))) {
  # Fill out inputs for the study
  
  phs = study_list$phs[study_i]
  v = 1
  p = 1
  # Define variables
  shortname = study_list$ps_abv[study_i]
  fullname = study_list$ful_name[study_i]
  consent = study_list$consent[study_i]
  
  dd_filepath = paste0("../../",tolower(study_list$ps_abv[study_i]),"/rawData/DataDictionary.c1.csv")
  data_files_list = paste0("../../",tolower(study_list$ps_abv[study_i]),"/rawData/ensemble_",study_list$dmc_abv[study_i],"_",study_list$consent[study_i],"_dataset.csv")
  consents_list = study_list$consent_list[study_i]
  focus = study_list$focus[study_i]
  design = study_list$design[study_i]
  #assosciated_studies = ' '
  #additional_info = ' '
  #harmonized = 'Not harmonized'
  #study_type = 'BioLINCC'
  #gen3_project_name = ''
  #new_up = "New Study"
  #s3_folder = ""
  #synthetic = "Synthetic"
  
  print(shortname)
  print("Prelim dataframe")
  
  dd_raw <- read_csv(dd_filepath, show_col_types = F)
  
  
  renamed_df <-  data.frame(
    form_group="N/A",
    form="All Variables",
    form_name= "All Variables",
    form_description= "N/A",
    variable_id=toupper(dd_raw$varname),
    variable_type=dd_raw$type,
    variable_group_name='NA',
    variable_group_description="N/A",
    variable_description=dd_raw$vardesc,
    variable_name=dd_raw$vardesc,
    drs_uri=dd_raw$drs_uri
  )
  
  
  ###### Metadata json File
  
  print("Building Metadata json")
  
  # Heirarchy tree
  trees_vector <- vector(mode = "character",length = length(renamed_df$variable_id))
  
  for (i in c(1:length(renamed_df$variable_id))) {
    study <- shortname
    
    form <- str_replace_all(renamed_df$form[i],"/","-")
    
    variable <- str_replace_all(renamed_df$variable_name[i],"/","-")
    
    tree <- paste0(study, "/",form, "/",variable)
    
    trees_vector[i] <- tree
  }  
  
  full_df <- cbind(renamed_df, trees_vector)
  names(full_df)[names(full_df) == 'trees_vector'] <- 'data_hierarchy'
  
  
  # DRS information level
  drs_info_df <- data.frame(
    full_df %>%
      select(
        form_group,
        form,
        form_description,
        form_name,
        variable_group_name,
        variable_group_description,
        variable_id,
        variable_name,
        variable_type,
        data_hierarchy,
        variable_description
      ) %>%
      unique()
  )
  rownames(drs_info_df) <- NULL
  
  
  
  for (ind in c(1:nrow(drs_info_df))) {
    temp_df <- data.frame(full_df[ind,] %>% #$variable_description
                            select(
                              drs_uri
                            )
    )
    
    temp_df<-temp_df %>% mutate_all(na_if,"")
    
    drs_info_df[ind, "drs_uri"][[1]] <- list(temp_df)
  }
  
  
  
  # Var information level
  variable_info_df <- data.frame(
    full_df %>%
      select(
        form_group,
        form,
        form_description,
        form_name,
        variable_group_name,
        variable_group_description,
        variable_id,
        variable_name,
        variable_type,
        data_hierarchy,
        variable_description,
        drs_uri
      ) %>%
      unique()
  )
  rownames(variable_info_df) <- NULL
  
  
  
  for (ind in c(1:nrow(variable_info_df))) {
    temp_df <- data.frame(full_df[ind,] %>% #$variable_description
                            select(
                            )
    )
    
    temp_df<-temp_df %>% mutate_all(na_if,"")
    
    variable_info_df[ind, "derived_variable_level_data"][[1]] <- list(temp_df)
  }
  
  
  # Var level
  variable_df <- data.frame(
    variable_info_df %>%
      select(
        form_group,
        form,
        form_description,
        form_name,
        variable_group_name,
        variable_group_description
      ) %>%
      unique()
  )
  rownames(variable_df) <- NULL
  
  
  for (ind in c(1:nrow(variable_df))) {
    temp_df <- variable_info_df %>%
      filter(form == variable_df[ind, "form"], variable_group_name == variable_df[ind, "variable_group_name"]) %>%
      select(variable_id, 
             variable_name, 
             variable_type,
             variable_description,
             data_hierarchy,
             drs_uri,
             derived_variable_level_data)
    variable_df[ind, "variable"][[1]] <- list(temp_df)
  }
  
  # Var group level
  variable_group_df <- data.frame(variable_df %>%
                                    select(form_group, form, form_name, form_description) %>%
                                    unique())
  rownames(variable_group_df) <- NULL
  
  
  for (ind in c(1:nrow(variable_group_df))) {
    temp_df <- variable_df %>%
      filter(form == variable_group_df[ind, "form"]) %>%
      select(variable_group_name, variable_group_description, variable)
    variable_group_df[ind, "variable_group"][[1]] <- list(temp_df)
  }
  
  # Form level
  form_df <- data.frame(variable_group_df %>%
                          select(form_group) %>%
                          unique())
  rownames(form_df) <- NULL
  
  
  for (ind in c(1:nrow(form_df))) {
    temp_df <- variable_group_df %>%
      #filter(form_group == variable_df[ind, "form_group"]) %>%
      select(form,form_description,form_name, variable_group)
    form_df[ind, "form"][[1]] <- list(temp_df)
  }
  
  # Study level
  complete_df <- data.frame('study_name' = fullname,
                            'study' = shortname,
                            'study_phs_number' = phs,
                            'consent' = consent,
                            'study_url' = paste0("https://www.ncbi.nlm.nih.gov/projects/gap/cgi-bin/study.cgi?study_id=",phs,".v",v,".p",p))
  
  complete_df$form_group <- list(form_df)
  

  
  ### refactoring file outs  
  no_consent_path <-file.path("..", "..", tolower(shortname), "decoded_data", paste0(tolower(shortname), "_metadata.json"))
  source_path <- file.path("..", "..", tolower(shortname), "decoded_data", paste0(tolower(shortname), "_metadata.", consent ,".json"))
  
  destination_dir <- file.path("..", "decodedData", tolower(shortname), "output")
  
  destination_path_no_consent <- file.path(destination_dir, paste0(tolower(shortname), "_metadata.json"))
  destination_path <- file.path(destination_dir, paste0(tolower(shortname), "_metadata.", consent ,".json"))
  
  # Convert the complete_df data frame to a compact JSON string
  json_string <- as.character(toJSON(complete_df, pretty = FALSE))
  
  # gsub still?
  # json_string <- gsub("field_note", "Field Note", json_string)
  
  # Write the JSON string directly to the source file
  writeLines(json_string, con = source_path)
  writeLines(json_string, con = no_consent_path)
  
  if (!dir.exists(destination_dir)) {
    dir.create(destination_dir, recursive = TRUE)
  }
  
  file.copy(from = source_path, to = destination_path, overwrite = TRUE)
  file.copy(from = no_consent_path, to = destination_path, overwrite = TRUE)
  
  
  ###### Dataset Building
  
  print("Building dataset")
  
  #coding_df <- dd_raw[which(dd_raw$type=="encoded value"),]
  
  #coding_df$varname <- toupper(coding_df$varname)
  
  for (filepath in data_files_list) {
    decoded_df <- read.csv(filepath)
    
    names(decoded_df) <- toupper(names(decoded_df))
    
    # tm = telemtry rp = report
    tm_rp <- read_delim(file = paste0("../rawData/sstr/",phs,".v",v,".p",p,".txt") ,delim = "\t", show_col_types = F)
    
    tm_trim <- tm_rp[,c(7,1,3)]
    
    #names(tm_trim) <- tolower(names(tm_trim))
    
    names(tm_trim) <- c("c1","c2","c3")
    
    
    data_df <- decoded_df
    
    subj_id <- names(data_df)[1]
    
    #print(subj_id)
    
    data_df$DBGAP_SUBJECT_ID <- ""
    
    new_data_df <- data_df %>%
      select(DBGAP_SUBJECT_ID, everything())
 
    if(TRUE%in%(new_data_df[[subj_id]]%in%tm_trim$c2)){
      for (merge_i in c(1:length(new_data_df[[subj_id]]))) {
        if(new_data_df[[subj_id]][merge_i]%in%tm_trim$c2){
          new_data_df$DBGAP_SUBJECT_ID[merge_i] = tm_trim$c1[which(tm_trim$c2==new_data_df[[subj_id]][merge_i])]
        }else{
          print(paste0("Omitting subject ", new_data_df[[subj_id]][merge_i], " , no consent information provided"))
        }
      }
      
      new_data_df <- new_data_df[which(new_data_df$DBGAP_SUBJECT_ID!=""),]
      
      new_data_df[] <- lapply(new_data_df, as.character)
      new_data_df[is.na(new_data_df)] = ""
      write.csv(new_data_df,paste0("../../",tolower(shortname),"/decoded_data/",phs,".decoded_ensemble_dataset.csv"),row.names = F)
      
      ### Subj Multi file
      
      print("Build subject Multi")
      
      
      header_df <- data.frame("c1"=c(paste0("# Study accession: ",phs,".v",v,".p",p),
                                     "# Table accession: subjects",
                                     "# Consent group: All",
                                     paste0("# Citation instructions: The study accession (",phs,".v",v,".p",p,") is used to cite the study and its data tables and documents. The data in this file should be cited using the accession subjects.v",v,".p",p),
                                     "# To cite columns of data within this file, please use the variable (phv#) accessions below:",
                                     "#",
                                     "# 1) the table name and the variable (phv#) accessions below; or",
                                     paste0("# 2) you may cite a variable as id.v",v,".p",p),
                                     "##",
                                     "dbGaP_Subject_ID"
      ), "c2"=c("","","","","","","","","subject_id",subj_id), "c3"=c("","","","","","","","","consent","CONSENT"))
      
      sm_df <- rbind(header_df,tm_trim)
      
      
      print("Writing decoded data")
      write.table(sm_df, file=paste0('../../',tolower(shortname),'/decoded_data/',phs,'.v',v,'.subjects.p',p,'.',shortname,'.Subject.MULTI.txt'), quote=FALSE, sep='\t', col.names = F, row.names = F)
      print("Writing raw data")
       write.table(sm_df, file=paste0('../../',tolower(shortname),'/rawData/',phs,'.v',v,'.subjects.p',p,'.',shortname,'.Subject.MULTI.txt'), quote=FALSE, sep='\t', col.names = F, row.names = F)
      
      ### XML File
       
      ### refactor 
       print("Build XML file")
       
       # Create XML document and root node
       doc <- newXMLDoc()
       root <- newXMLNode("data_table", 
                          attrs = c(
                            id = paste0("subjects.v", v), 
                            study_id = paste0("phs002988.v", v), 
                            participant_set = paste0("p", p), 
                            date_created = date()
                          ), 
                          doc = doc)
       
       # Add description node
       descNode <- newXMLNode("description", 
                              "The subject consent data table includes subject IDs and consent group information.", 
                              parent = root)
       
       # Create subject_id variable node
       var1Node <- newXMLNode("variable", attrs = c(id = "subject_id"), parent = root)
       nm1Node  <- newXMLNode("name", subj_id, parent = var1Node)
       desc1Node<- newXMLNode("description", "Subject ID", parent = var1Node)
       ty1Node  <- newXMLNode("type", "String", parent = var1Node)
       
       # Create consent variable node
       var2Node <- newXMLNode("variable", attrs = c(id = "consent"), parent = root)
       nm2Node  <- newXMLNode("name", "CONSENT", parent = var2Node)
       desc2Node<- newXMLNode("description", "Consent group as determined by DAC", parent = var2Node)
       ty2Node  <- newXMLNode("type", "encoded value", parent = var2Node)
       
       # Loop through the consents list and add each as a value node
       for (consent_i in seq_along(consents_list)) {
         cval <- newXMLNode("value", 
                            consents_list[consent_i], 
                            attrs = c(code = consent_i), 
                            parent = var2Node)
       }
       
       # Define directory paths for output
       decoded_dir <- file.path("..", "..", tolower(shortname), "decoded_data")
       rawdata_dir <- file.path("..", "..", tolower(shortname), "rawData")
       
       # Create directories if they do not exist
       if (!dir.exists(decoded_dir)) {
         dir.create(decoded_dir, recursive = TRUE)
       }
       
       if (!dir.exists(rawdata_dir)) {
         dir.create(rawdata_dir, recursive = TRUE)
       }
       
       # Construct the file name
       file_name <- paste0(phs, ".v", v, ".subjects.p", p, ".", shortname, ".Subject.data_dict.xml")
       
       # Define full file paths
       decoded_file <- file.path(decoded_dir, file_name)
       rawdata_file <- file.path(rawdata_dir, file_name)
       
       # XML stylesheet prefix
       prefix_str <- '<?xml-stylesheet type="text/xsl" href="./datadict_v1.xsl"?>'
       
       # Save the XML document to the specified files
       saveXML(doc, file = decoded_file, prefix = prefix_str)
       saveXML(doc, file = rawdata_file, prefix = prefix_str)       
       ###
    }else{
      print("Study subject ID does not match dbgap telemetry report")
      write.csv(decoded_df,paste0("../../",tolower(shortname),"/decoded_data/",phs,".decoded_ensemble_dataset.csv"),row.names = F)
    }
  }
  
}







