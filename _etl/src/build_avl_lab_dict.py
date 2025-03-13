import os
import json
import pandas as pd
from jsonschema import validate, ValidationError
import pyreadstat
import glob
import requests

def load_json_schema(schema_path):
    with open(schema_path, "r") as f:
        return json.load(f)

def get_sstr_summary(study_id):

    # API endpoint
    summary_url = f"https://www.ncbi.nlm.nih.gov/gap/sstr/api/v1/study/{study_id}/summary"

    # Fetch the API response
    response = requests.get(summary_url)
    response.raise_for_status()  # Ensure request was successful

    data = response.json()
    if data.get('study', {}).get('accver', {}).get('accession'):
        return data
    else:
        raise ValueError("Accession key is missing in the response JSON.")

def validate_metadata(metadata, schema):
    """Validate metadata against the schema and provide detailed error messages."""
    try:
        validate(instance=metadata, schema=schema)
        print("Metadata JSON is valid.")
        return True
    except ValidationError as e:
        print("\nMetadata JSON validation failed!")
        print(f"Error Message: {e.message}")
        print(f"Failed at: {list(e.path)}" if e.path else "Failed at the root level")
        print(f"Schema rule violated: {e.schema_path}")
        print(f"Invalid value: {e.instance}")
        return False

def build_metadata_json(study_id, abv_name, alt_name, output_dir, input_dir, schema_path):
    """Generate metadata JSON based on study list and validate it against a schema."""
    schema = load_json_schema(schema_path)

    manifest_pattern = f"{input_dir}/*{study_id.split('.')[0]}*manifest*.tsv"
    dataset_pattern = f"{input_dir}/ensemble_*{abv_name}*_dataset.sas7bdat"

    manifest_files = glob.glob(manifest_pattern)
    dataset_files = glob.glob(dataset_pattern)

    if not manifest_files:
        print(f"No manifest file found for {study_id}. Skipping metadata generation.")

    manifest_file = manifest_files[0]  # Assuming only one manifest file per phs
    manifest_df = pd.read_csv(manifest_file, sep='\t')

    manifest_df['filename'] = manifest_df['s3_path'].apply(lambda x: os.path.basename(x))
    rawdata_files = {os.path.basename(f): f for f in glob.glob(f'{input_dir}*')}

    matched_manifest = manifest_df[manifest_df['filename'].isin(rawdata_files.keys())]

    drs_uris=matched_manifest['ga4gh_drs_uri'].tolist()

    _, meta = pyreadstat.read_sas7bdat(
       dataset_files[0],
        metadataonly=True
    )

    column_names_to_labels = meta.column_names_to_labels

    data = get_sstr_summary(study_id)

    not_used = data.get('study', {}).get('repository', {})
    study = data.get('study', {}).get('handle', {})
    admin_ic = data.get('study', {}).get('admin_ic', {})
    study_status = data.get('study').get('study_status')
    full_name = data.get('study', {}).get('name', {})
    study_phs_number = data.get('study', {}).get('accver', {}).get('accession', {})

    variables = [
        {
            "variable_id": var_id,
            "variable_name": var_id,
            "variable_type": "num",
            "variable_description": var_label,
            "data_hierarchy": "\\" + study_phs_number + "\\" + var_id + "\\",
            "drs_uri": drs_uris
        }
        for var_id, var_label in column_names_to_labels.items()
    ]
    complete_data = [{
        "study_name": full_name,
        "study": study,
        "study_phs_number": study_phs_number,
        "study_url": f"https://www.ncbi.nlm.nih.gov/projects/gap/cgi-bin/study.cgi?study_id={study_phs_number}",
        "sstr_url": f"https://www.ncbi.nlm.nih.gov/gap/sstr/api/v1/study/{study_phs_number}/summary",
        "form_group": [{
            "form_group": "General",
            "form": [{
                "form": "All Variables",
                "form_description": "N/A",
                "form_name": "All Variables",
                "variable_group": [{
                    "variable_group_name": "NA",
                    "variable_group_description": "N/A",
                    "variable": variables
                }]
            }]
        }]
    }]

    output_filepath = os.path.join(output_dir, f"{alt_name}_metadata.json")
    os.makedirs(os.path.dirname(output_filepath), exist_ok=True)

    with open(output_filepath, "w") as f:
        json.dump(complete_data, f, indent=2)

    if not validate_metadata(complete_data, schema):
        print(f"Skipping metadata generation for {study_id} due to validation failure.")


    print(f"Metadata JSON created and validated for {study_id}: {output_filepath}")

def main(study_id, abv_name, alt_name, output_dir='./output/', input_dir='./input/', schema_path="./configs/metadata.schema.json"):
    build_metadata_json(study_id, abv_name, alt_name, output_dir, input_dir, schema_path)

if __name__ == "__main__":
    main()
