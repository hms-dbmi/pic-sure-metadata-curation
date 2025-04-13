import os
import glob
import pyreadstat
import json
import requests
import math
from concurrent.futures import ThreadPoolExecutor, as_completed

def get_sstr_summary(study_id):
    summary_url = f"https://www.ncbi.nlm.nih.gov/gap/sstr/api/v1/study/{study_id}/summary"
    response = requests.get(summary_url)
    response.raise_for_status()
    return response.json()

def dbgap_source_id_dict(study_id):
    summary_data = get_sstr_summary(study_id)
    total_subjects = summary_data.get('study_stats', {}).get('cnt_subjects', {}).get('loaded', 0)
    page_size = 20
    total_pages = math.ceil(total_subjects / page_size)
    base_url = f'https://www.ncbi.nlm.nih.gov/gap/sstr/api/v1/study/{study_id}/subjects'
    subject_dict = {}

    def fetch_page(page):
        url = f'{base_url}?page={page}&page_size={page_size}'
        response = requests.get(url, headers={'accept': 'application/json'})
        response.raise_for_status()
        data = response.json()
        return data.get('subjects', [])

    with ThreadPoolExecutor(max_workers=3) as executor:
        future_to_page = {executor.submit(fetch_page, page): page for page in range(1, total_pages + 1)}
        for future in as_completed(future_to_page):
            subjects = future.result()
            for subject in subjects:
                submitted_id = subject.get('submitted_subject_id')
                dbgap_id = subject.get('dbgap_subject_id')
                if submitted_id and dbgap_id:
                    subject_dict[submitted_id] = dbgap_id

    return subject_dict


def convert_sas_to_csv(study_id, sas_file_path, csv_file_path, decode_labels=False, decode_value_labels=True):
    if not os.path.exists(sas_file_path):
        print(f"File not found: {sas_file_path}")
        return

    df, meta = pyreadstat.read_sas7bdat(sas_file_path)

    dbgap_subject_ids = dbgap_source_id_dict(study_id)

    # Identify the original first column
    first_column = df.columns[0]

    # Perform lookup and filter out missing values
    df.insert(0, "dbgap_subject_id", df[first_column].str.strip().map(dbgap_subject_ids))
    missing_values = df[df["dbgap_subject_id"].isna()][first_column].tolist()

    # Remove rows where lookup failed
    df = df.dropna(subset=["dbgap_subject_id"])

    # Generate missing values report
    missing_report = {
        "file": sas_file_path,
        "missing_count": len(missing_values),
        "missing_values": missing_values,
    }

    report_file = os.path.join(os.path.dirname(csv_file_path), f"{study_id}_missing_values_report.json")
    with open(report_file, "a") as f:
        json.dump(missing_report, f, indent=4)
        f.write("\n")

    report = {
        "file": sas_file_path,
        "missing_variable_labels": [],
        "empty_variable_label_mappings": False,
        "empty_column_label_mappings": False
    }

    if not meta.variable_value_labels:
        report["empty_variable_label_mappings"] = True

    if not meta.column_names_to_labels:
        report["empty_column_label_mappings"] = True

    if decode_labels:
        new_column_names = {
            col: meta.column_names_to_labels[col]
            for col in meta.column_names if col in meta.column_names_to_labels and meta.column_names_to_labels[col]
        }
        df.rename(columns=new_column_names, inplace=True)

    if decode_value_labels:    # Decode variable value labels
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

    df.to_csv(csv_file_path, index=False)
    print(f"Converted: {sas_file_path} → {csv_file_path} (Decoded: {decode_labels}, Filtered Missing: {len(missing_values)})")

    report_file = os.path.join(os.path.dirname(csv_file_path), "conversion_report.json")
    with open(report_file, "a") as f:
        json.dump(report, f)
        f.write("\n")

def convert_all_sas_files(study_id, name, raw_data_dir, output_dir, decode_labels=True):
    os.makedirs(output_dir, exist_ok=True)

    pattern = os.path.join(raw_data_dir, f"ensemble*{name}*.sas7bdat")
    sas_files = glob.glob(pattern)

    for sas_file in sas_files:
        csv_file = os.path.join(output_dir, os.path.basename(sas_file).replace(".sas7bdat", ".csv"))
        convert_sas_to_csv(study_id, sas_file, csv_file, decode_labels)

def main(study_id, name, input_dir = "./input", output_dir = "./output"):
    convert_all_sas_files(study_id, name, input_dir, output_dir)

if __name__ == "__main__":
    main()