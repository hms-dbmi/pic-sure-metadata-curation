library(jsonlite)


babyhug_json <- "~/Documents/pic-sure-metadata-curation/babyhug/output/babyhug_metadata.json"

babyhug_df <- as.data.frame(fromJSON(babyhug_json))

babyhug_df$form_group[[1]]$form[[1]]$variable_group[[1]]$variable[[1]]$variable_name[2]

length(babyhug_df$form_group[[1]]$form[[1]]$variable_group[[1]]$variable[[1]]$variable_name)


for (form_group_i in 1:3) {
  #print(paste("Form Group : ",form_group_i))
  
  form_length <- length(babyhug_df$form_group[[1]]$form[[form_group_i]]$form_name)
  
  for(form_i in 1:form_length){
    #print(paste("Form : ",form_i))
    vars_length <- length(babyhug_df$form_group[[1]]$form[[form_group_i]]$variable_group[[form_i]]$variable[[1]]$variable_name)
    
    for(var_i in 1:vars_length){
      if(babyhug_df$form_group[[1]]$form[[form_group_i]]$variable_group[[form_i]]$variable[[1]]$variable_name[var_i] == "" 
         & babyhug_df$form_group[[1]]$form[[form_group_i]]$variable_group[[form_i]]$variable[[1]]$variable_type[var_i] != "data missing"){
        
        # Id Variable
        #if(babyhug_df$form_group[[1]]$form[[form_group_i]]$variable_group[[form_i]]$variable[[1]]$variable_id[var_i] != "ID"){
        
        #} 
        if(is.null(babyhug_df$form_group[[1]]$form[[form_group_i]]$variable_group[[form_i]]$variable[[1]]$variable_metadata[[var_i]]$variable_label_from_data_dictionary)){
        
        #print(paste("Form Group :" , form_group_i, "Form : ", form_i, "Var : ", var_i))
        #print(babyhug_df$form_group[[1]]$form[[form_group_i]]$variable_group[[form_i]]$variable[[1]]$variable_metadata[[var_i]]$variable_label_from_data_dictionary)
        
          babyhug_df$form_group[[1]]$form[[form_group_i]]$variable_group[[form_i]]$variable[[1]]$variable_name[var_i] <- babyhug_df$form_group[[1]]$form[[form_group_i]]$variable_group[[form_i]]$variable[[1]]$variable_id[var_i]
          
          } else{
            #print(paste("Form Group :" , form_group_i, "Form : ", form_i, "Var : ", var_i))
            #print(babyhug_df$form_group[[1]]$form[[form_group_i]]$variable_group[[form_i]]$variable[[1]]$variable_metadata[[var_i]]$variable_label_from_data_dictionary)
            
            babyhug_df$form_group[[1]]$form[[form_group_i]]$variable_group[[form_i]]$variable[[1]]$variable_name[var_i] <- babyhug_df$form_group[[1]]$form[[form_group_i]]$variable_group[[form_i]]$variable[[1]]$variable_metadata[[var_i]]$variable_label_from_data_dictionary
        }
          
        
      }
    }
    
  } 
}

