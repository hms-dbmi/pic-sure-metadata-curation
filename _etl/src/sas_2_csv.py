import os
import glob
import pyreadstat
import json

def convert_sas_to_csv(sas_file_path, csv_file_path, decode_labels=True):
    if not os.path.exists(sas_file_path):
        print(f"File not found: {sas_file_path}")
        return

    # Read SAS file with metadata
    df, meta = pyreadstat.read_sas7bdat(sas_file_path)

    report = {
        "file": sas_file_path,
        "missing_variable_labels": [],
        "empty_variable_label_mappings": False,
        "empty_column_label_mappings": False
    }

    # Check if value labels exist
    if not meta.variable_value_labels:
        report["empty_variable_label_mappings"] = True

    # Check if value labels exist
    if not meta.column_names_to_labels:
        report["empty_column_label_mappings"] = True

    if decode_labels:
        new_column_names = {
            col: meta.column_names_to_labels[col]
            for col in meta.column_names if col in meta.column_names_to_labels and meta.column_names_to_labels[col]
        }
        df.rename(columns=new_column_names, inplace=True)

        # Decode variable value labels
        for col, value_labels in meta.variable_value_labels.items():
            if col in df.columns:
                original_values = df[col].unique().tolist()
                df[col] = df[col].map(value_labels).fillna(df[col])
                unmapped_values = [val for val in original_values if val not in value_labels]
                if unmapped_values:
                    report["missing_variable_labels"].append({
                        "column": col,
                        "unmapped_values": unmapped_values
                    })

    # Save as CSV
    df.to_csv(csv_file_path, index=False)
    print(f"Converted: {sas_file_path} → {csv_file_path} (Decoded: {decode_labels})")

    # Save report to JSON
    report_file = os.path.join(os.path.dirname(csv_file_path), "conversion_report.json")
    with open(report_file, "a") as f:
        json.dump(report, f)
        f.write("\n")

def convert_all_sas_files(raw_data_dir, output_dir, decode_labels=True):
    # Ensure output directory exists
    os.makedirs(output_dir, exist_ok=True)

    # Find all SAS files in rawData
    sas_files = glob.glob(os.path.join(raw_data_dir, "*.sas7bdat"))

    # Convert each SAS file to CSV
    for sas_file in sas_files:
        csv_file = os.path.join(output_dir, os.path.basename(sas_file).replace(".sas7bdat", ".csv"))
        convert_sas_to_csv(sas_file, csv_file, decode_labels)

def main(input_dir = "./input", output_dir = "./output"):
    convert_all_sas_files(input_dir, output_dir)

if __name__ == "__main__":
    main()