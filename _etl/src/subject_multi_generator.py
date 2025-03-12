import requests
import csv
import json
from collections import defaultdict
from concurrent.futures import ThreadPoolExecutor, as_completed
import math
import time

def get_sstr_summary(study_id):
    summary_url = f"https://www.ncbi.nlm.nih.gov/gap/sstr/api/v1/study/{study_id}/summary"

    response = requests.get(summary_url)
    response.raise_for_status()  # Ensure request was successful
    return response.json()

def fetch_study_data(study_id, output_dir):
    # Base URL of the API endpoint
    base_url = f'https://www.ncbi.nlm.nih.gov/gap/sstr/api/v1/study/{study_id}/subjects'
    summary_data = get_sstr_summary(study_id)
    expected_pat_cnt = summary_data.get('study_stats').get('cnt_subjects').get('loaded')

    # Parameters for pagination
    page_size = 50
    max_pages = math.ceil( (expected_pat_cnt + page_size) / page_size)
    print(f'Processing Pages: {max_pages}')# Set an upper limit to avoid infinite requests (adjust based on API limits)
    concurrent_requests = 3  # Number of parallel requests# Number of parallel requests
    all_data = []
    summary = {
        "total_subjects": 0,
        "total_samples": 0,
        "subjects_with_samples": 0,
        "subjects_without_samples": 0,
        "consent_code_counts": defaultdict(int),
        "phs_counts": defaultdict(int),
    }

    # Function to fetch a single page of data
    def fetch_page(page):
        url = f'{base_url}?page={page}&page_size={page_size}'
        retries = 3
        backoff_factor = 2

        for attempt in range(retries):
            try:
                response = requests.get(url, headers={'accept': 'application/json'})
                if response.status_code == 200:
                    data = response.json()
                    return data.get('subjects', [])
                else:
                    print(f'Failed to retrieve data for page {page}: {response.status_code}')
                    if attempt < retries - 1:
                        sleep_time = backoff_factor ** attempt
                        print(f'Retrying page {page} in {sleep_time} seconds...')
                        time.sleep(sleep_time)
            except requests.RequestException as e:
                print(f'Error fetching page {page}: {e}')
                if attempt < retries - 1:
                    sleep_time = backoff_factor ** attempt
                    print(f'Retrying page {page} in {sleep_time} seconds...')
                    time.sleep(sleep_time)

        print(f'Failed to retrieve data for page {page} after {retries} attempts.')
        return None

    # Function to process subjects from a page
    def process_subjects(subjects):
        local_data = []
        local_summary = {
            "total_subjects": 0,
            "total_samples": 0,
            "subjects_with_samples": 0,
            "subjects_without_samples": 0,
            "consent_code_counts": defaultdict(int),
            "phs_counts": defaultdict(int),
        }

        for subject in subjects:
            local_summary["total_subjects"] += 1
            local_summary["consent_code_counts"][subject.get('consent_code', 'Unknown')] += 1
            local_summary["phs_counts"][subject.get('phs', 'Unknown')] += 1

            subject_entry = {
                'dbgap_subject_id': subject.get('dbgap_subject_id'),
                'submitted_subject_id': subject.get('submitted_subject_id'),
                'consent_code': subject.get('consent_code'),
                'consent_abbreviation': subject.get('consent_abbreviation'),
                'has_image': subject.get('has_image'),
                'case_control': subject.get('case_control'),
                'phs': subject.get('phs'),
                'study_key': subject.get('study_key'),
            }

            if 'samples' in subject and subject['samples']:
                local_summary["subjects_with_samples"] += 1
                for sample in subject['samples']:
                    local_summary["total_samples"] += 1
                    sample_entry = {
                        **subject_entry,  # Include subject details
                        'dbgap_sample_id': sample.get('dbgap_sample_id'),
                        'submitted_sample_id': sample.get('submitted_sample_id'),
                        'biosample_id': sample.get('biosample_id'),
                        'sra_sample_id': sample.get('sra_sample_id'),
                    }
                    local_data.append(sample_entry)
            else:
                local_summary["subjects_without_samples"] += 1
                local_data.append({**subject_entry, 'dbgap_sample_id': None, 'submitted_sample_id': None, 'biosample_id': None, 'sra_sample_id': None})

        return local_data, local_summary

    # Run API requests in parallel
    with ThreadPoolExecutor(max_workers=concurrent_requests) as executor:
        future_to_page = {executor.submit(fetch_page, page): page for page in range(1, max_pages + 1)}

        for future in as_completed(future_to_page):
            page = future_to_page[future]
            try:
                subjects = future.result()
                if subjects:
                    processed_data, processed_summary = process_subjects(subjects)
                    all_data.extend(processed_data)

                    # Aggregate summary statistics
                    summary["total_subjects"] += processed_summary["total_subjects"]
                    summary["total_samples"] += processed_summary["total_samples"]
                    summary["subjects_with_samples"] += processed_summary["subjects_with_samples"]
                    summary["subjects_without_samples"] += processed_summary["subjects_without_samples"]

                    for key, value in processed_summary["consent_code_counts"].items():
                        summary["consent_code_counts"][key] += value
                    for key, value in processed_summary["phs_counts"].items():
                        summary["phs_counts"][key] += value

                print(f"Page {page} processed.")
            except Exception as e:
                print(f"Error processing page {page}: {e}")

    # Define the exact column order
    column_order = [
        'dbgap_subject_id', 'submitted_subject_id', 'consent_code', 'consent_abbreviation',
        'has_image', 'case_control', 'dbgap_sample_id', 'submitted_sample_id',
        'biosample_id', 'sra_sample_id', 'phs', 'study_key'
    ]

    # subject multi writer
    if all_data:
        filename = f'{output_dir}/{study_id}.Subject.MULTI.tsv'
        with open(filename, 'w', newline='', encoding='utf-8') as output_file:
            dict_writer = csv.DictWriter(output_file, fieldnames=column_order, delimiter='\t')
            dict_writer.writeheader()
            dict_writer.writerows(all_data)
        print(f'Data successfully written to {filename}')
    else:
        print('No data to write.')

    # Convert defaultdicts to normal dicts for JSON serialization
    summary["consent_code_counts"] = dict(summary["consent_code_counts"])
    summary["phs_counts"] = dict(summary["phs_counts"])

    # Save summary report as JSON
    summary_filename = f"{output_dir}/{study_id}_file_summary_report.json"
    summary_json = json.dumps(summary, indent=4)
    with open(summary_filename, "w", encoding="utf-8") as summary_file:
        summary_file.write(summary_json)

        # Print summary JSON
        print("\nSummary Report (JSON Format):")
        print(summary_json)

def main(study_id, output_dir='./output'):
    fetch_study_data(study_id, output_dir)

if __name__ == "__main__":
    import sys

    if len(sys.argv) < 2 or len(sys.argv) > 3:
        print("Usage: python subject_multi_generator.py <study_id> [<output_dir>]")
        sys.exit(1)

    study_id = sys.argv[1]
    output_dir = sys.argv[2] if len(sys.argv) == 3 else './output'
    main(study_id, output_dir) 
