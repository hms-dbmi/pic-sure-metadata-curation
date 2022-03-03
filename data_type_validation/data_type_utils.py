# Do imports 
import glob
import pandas as pd
import numpy as np

# Define functions
def identify_var_types(file_path):
    '''Takes input file path with decoded data. 
    Returns a dataframe with variable name, type, and file information.'''
    decoded_files = glob.glob(file_path)
    decoded_files = decoded_files[0:3]
    if len(decoded_files) < 1:
        print("No files found, please check input directory.")
        return('')
    for file in decoded_files:
        decoded_df = pd.read_csv(file)
        stripped_file_name = file.split('/')[-1]
        if file == decoded_files[0]:
            res = decoded_df.dtypes.to_frame('raw_type').reset_index().astype("string")
            res['picsure_type'] = np.where(res['raw_type'] == 'object', 'categorical', 'continuous')
            res['file'] = stripped_file_name
            #res.columns[0] = 'NAME'
        else:
            other_res = decoded_df.dtypes.to_frame('raw_type').reset_index().astype("string")
            other_res['picsure_type'] = np.where(other_res['raw_type'] == 'object', 'categorical', 'continuous')
            other_res['file'] = stripped_file_name
            #other_res.columns[0] = 'NAME'
            res = res.append(other_res)
    res = res.rename(columns={'index':'varname'}).reset_index()
    return(res)


def check_against_sas(sas_file, picsure_type_df):
    '''Takes file path of SAS file to check variables.
    Output is comparison df.'''
    sas_df = pd.read_csv(sas_file)
    sas_df.loc[sas_df["TYPE"] == 1, "TYPE"] = 'categorical'
    sas_df.loc[sas_df["TYPE"] == 2, "TYPE"] = 'continuous'
    sas_df = sas_df[['LIBNAME', 'MEMNAME', 'NAME', 'TYPE', 'LABEL', 'FORMAT']]
    full = pd.merge(picsure_type_df, sas_df, how = 'left', left_on=['varname', 'df'], right_on=['NAME', 'MEMNAME'])
    full['type_match'] = full['picsure_type'] == full['TYPE']
    full = full[['varname', 'raw_type', 'picsure_type', 'file', 'df', 'MEMNAME', 'NAME', 'TYPE', 'LABEL', 'type_match', 'FORMAT']]
    return(full)

def parse_data(comparison_df, directory, file_info):
    file_name = directory+file_info['file'][0]
    pandas_type = file_info['picsure_type'][0]
    sas_type = file_info['TYPE'][0]
    varname = file_info['varname'][0]
    print("Information for variable", varname)
    print("\tpandas type:", pandas_type)
    print("\tSAS type:", sas_type)
    df = pd.read_csv(file_name)
    print("Values in decoded data:")
    print(df[varname].unique())

def check_data(comparison_df, directory, varname=None):
    '''Allows for manual check of the decoded data.'''
    if varname is not None:
        file_info = comparison_df.loc[comparison_df['varname'] == varname].reset_index()
        #print(file_info)
        parse_data(comparison_df, directory, file_info)
    else:
        mismatch = comparison_df[comparison_df['type_match'] == False].reset_index()
        inds = list(np.random.choice(mismatch.shape[0], 5, replace=False))
        #print(inds)
        for ind in inds:
            print("\n", comparison_df['varname'][ind])
            file_info = comparison_df.iloc[[ind]].reset_index()
            #print(file_info)
            parse_data(comparison_df, directory, file_info)