"""
This script processes all SAS (.sas7bdat) files in a specified directory and extracts metadata.
It collects the first column's encoded and decoded values, checks for missing labels, and
saves the extracted information into a structured JSON report.

Just collecting the first column for now.  Would best to be given the expected id to use and validated that
it exists in the telemetry report.  Seems like a critical step for data integrity before we even touch this data.
"""

import os
import glob
import json
import pyreadstat

# Constants
DEFAULT_INPUT_DIR = "./input"
DEFAULT_OUTPUT_FILE = "./output/sas_metadata.json"
ENCODING = "utf-8"
MAX_SAMPLE_VALUES = 20

def process_sas_file(sas_file_path):
    """
    Extracts metadata from a SAS file including encoded and decoded values of the first column.

    Args:
        sas_file_path (str): Path to the SAS file.

    Returns:
        dict: A metadata report containing:
            - filename
            - first column name
            - first column encoded label
            - first column decoded label
            - first 20 encoded and decoded values
            - presence of variable labels and column mappings
    """
    try:
        # Read SAS file with metadata
        df, meta = pyreadstat.read_sas7bdat(sas_file_path)

        report = {
            "file": sas_file_path,
            "first_column": None,
            "first_column_encoded_label": None,
            "first_column_decoded_label": None,
            "encoded_values": [],
            "decoded_values": [],
            "missing_variable_labels": [],
            "empty_variable_label_mappings": False,
            "empty_column_label_mappings": False
        }

        if df.empty:
            print(f"Warning: File {sas_file_path} is empty.")
            return report

        # Check for metadata presence
        report["empty_variable_label_mappings"] = not bool(meta.variable_value_labels)
        report["empty_column_label_mappings"] = not bool(meta.column_names_to_labels)

        # Extract the first column and its values
        first_col = df.columns[0]
        report["first_column"] = first_col

        # Get encoded and decoded labels
        report["first_column_encoded_label"] = meta.column_names_to_labels.get(first_col, first_col)
        report["first_column_decoded_label"] = meta.variable_value_labels.get(first_col, {}).get(first_col, first_col)

        # Get first 100 encoded and decoded values
        encoded_values = df[first_col].astype(str).head(MAX_SAMPLE_VALUES).tolist()
        decoded_map = meta.variable_value_labels.get(first_col, {})
        decoded_values = [decoded_map.get(val, val) for val in encoded_values]

        report["encoded_values"] = encoded_values
        report["decoded_values"] = decoded_values

        return report

    except FileNotFoundError:
        print(f"Error: File {sas_file_path} not found.")
        return {"file": sas_file_path, "error": "File not found"}
    except Exception as e:
        print(f"Error processing file {sas_file_path}: {e}")
        return {"file": sas_file_path, "error": str(e)}

def process_all_sas_files(input_dir, output_file):
    """
    Processes all SAS files in the specified directory and writes metadata reports to JSON.

    Args:
        input_dir (str): Directory containing SAS files.
        output_file (str): Path to the output JSON file.
    """
    # Find all SAS files in the input directory
    sas_files = glob.glob(os.path.join(input_dir, "*.sas7bdat"))

    if not sas_files:
        print(f"No SAS files found in directory: {input_dir}")
        return

    # Process each SAS file and collect metadata
    reports = [process_sas_file(sas_file) for sas_file in sas_files]

    # Save all reports to a JSON file
    os.makedirs(os.path.dirname(output_file), exist_ok=True)
    with open(output_file, "w", encoding=ENCODING) as f:
        json.dump(reports, f, indent=4)

    print(f"Metadata report successfully saved to {output_file}")

def main(input_dir=DEFAULT_INPUT_DIR, output_file=DEFAULT_OUTPUT_FILE):
    """
    Main function to process SAS files and generate metadata reports.

    Args:
        input_dir (str, optional): Directory containing SAS files. Defaults to DEFAULT_INPUT_DIR.
        output_file (str, optional): Output JSON file path. Defaults to DEFAULT_OUTPUT_FILE.
    """
    process_all_sas_files(input_dir, output_file)

if __name__ == "__main__":
    main()