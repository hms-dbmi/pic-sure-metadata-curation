import json

import requests

def get_sstr_summary(study_id):
    summary_url = f"https://www.ncbi.nlm.nih.gov/gap/sstr/api/v1/study/{study_id}/summary"

    response = requests.get(summary_url)
    response.raise_for_status()  # Ensure request was successful
    return response.json()

def fetch_study_data(study_id):
    # Base URL of the API endpoint
    base_url = f'https://www.ncbi.nlm.nih.gov/gap/sstr/api/v1/study/{study_id}/subjects'

    response = requests.get(base_url)
    response.raise_for_status()  # Ensure request was successful
    return response.json()

study_id='phs000294'
#data=get_sstr_summary('phs000294')
data=fetch_study_data(study_id)
print(json.dumps(data,indent=4))

