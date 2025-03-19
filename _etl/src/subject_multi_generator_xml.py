"""
This script generates XML data dictionary files for a given study by fetching
study summary information from the NCBI API. The XML output is structured
according to a predefined schema with participant and consent information.
"""

import requests
import xml.etree.ElementTree as ET
from datetime import datetime
import os

# Constants for API configuration and output formatting
API_BASE_URL = "https://www.ncbi.nlm.nih.gov/gap/sstr/api/v1/study"
XML_STYLESHEET = "./datadict_v1.xsl"
DEFAULT_OUTPUT_DIR = "./output"
XML_ENCODING = "utf-8"
REQUEST_TIMEOUT = 30  # seconds
DATE_FORMAT = "%a %b %d %H:%M:%S %Y"
FILENAME_TEMPLATE = "{study_id}.{participant_set}.pht1.Subject.MULTI.data_dict.xml"

def sanitize_filename_component(value):
    """
    Sanitize a string to be safe for filenames by allowing only alphanumeric characters, hyphens, underscores, and periods.

    Args:
        value (str): The input string to sanitize.

    Returns:
        str: The sanitized string safe for filenames.
    """
    return "".join(c for c in value if c.isalnum() or c in ('-', '_', '.')).rstrip()

def generate_filename(study_id, participant_set, output_dir):
    """
    Generate a consistent and sanitized filename based on study ID and participant set.

    Args:
        study_id (str): The study identifier.
        participant_set (str): The participant set identifier.
        output_dir (str): The directory where the output file will be saved.

    Returns:
        str: The full path of the generated filename.
    """
    safe_study_id = sanitize_filename_component(study_id)
    safe_participant_set = sanitize_filename_component(participant_set)
    filename = FILENAME_TEMPLATE.format(
        study_id=safe_study_id,
        participant_set=safe_participant_set
    )
    return os.path.join(output_dir, filename)

def generate_study_xml(study_id, output_dir=DEFAULT_OUTPUT_DIR):
    """
    Generate an XML data dictionary for the specified study.

    Args:
        study_id (str): The study identifier.
        output_dir (str): The directory where the XML file will be saved.

    Raises:
        requests.RequestException: If the API request fails.
    """
    summary_url = f"{API_BASE_URL}/{study_id}/summary"

    # Fetch the study summary from the API
    response = requests.get(summary_url, timeout=REQUEST_TIMEOUT)
    response.raise_for_status()
    data = response.json()

    study_info = data.get("study", {})
    study_accver = study_info.get("accver", {})
    consent_groups = study_info.get("consent_groups", [])

    # Determine the participant set identifier
    participant_set = f"p{study_accver.get('participant_set', 1)}"

    # Create the root XML element
    root = ET.Element(
        "data_table",
        {
            "id": "subjects.v1",
            "study_id": study_id,
            "participant_set": participant_set,
            "date_created": datetime.now().strftime(DATE_FORMAT),
        },
    )

    # Add a description to the XML
    description = ET.SubElement(root, "description")
    description.text = "The subject consent data table includes subject IDs and consent group information."

    # Define variables to be included in the XML
    variables = [
        {"id": "dbgap_subject_id", "name": "dbgap_subject_id", "description": "dbGap Subject ID", "type": "String"},
        {"id": "submitted_subject_id", "name": "submitted_subject_id", "description": "Submitted Subject ID", "type": "String"},
        {"id": "consent_code", "name": "consent_code", "description": "Consent group as determined by DAC", "type": "encoded value"},
    ]

    # Populate variables in the XML structure
    for var in variables:
        var_element = ET.SubElement(root, "variable", {"id": var["id"]})
        ET.SubElement(var_element, "name").text = var["name"]
        ET.SubElement(var_element, "description").text = var["description"]
        ET.SubElement(var_element, "type").text = var["type"]

    # Add consent group values
    consent_var = root.find("./variable[@id='consent_code']")
    for group in consent_groups:
        value = ET.SubElement(consent_var, "value", {"code": str(group["code"])})
        value.text = f'{group["name"]} ({group["short_name"]})'

    # Convert the XML tree to a string with an XML declaration and stylesheet
    xml_str = f'<?xml version="1.0"?>\n<?xml-stylesheet type="text/xsl" href="{XML_STYLESHEET}"?>\n'
    xml_str += ET.tostring(root, encoding=XML_ENCODING).decode()

    # Ensure the output directory exists and write the XML file
    os.makedirs(output_dir, exist_ok=True)
    xml_filename = generate_filename(study_id, participant_set, output_dir)

    with open(xml_filename, "w", encoding=XML_ENCODING) as xml_file:
        xml_file.write(xml_str)

    print(f"XML file '{xml_filename}' has been generated successfully.")

def main(study_id, output_dir=DEFAULT_OUTPUT_DIR):
    """
    Main entry point for generating the study XML.

    Args:
        study_id (str): The study identifier.
        output_dir (str): The directory where the XML file will be saved.
    """
    generate_study_xml(study_id, output_dir)

if __name__ == "__main__":
    import sys

    if len(sys.argv) < 2 or len(sys.argv) > 3:
        print("Usage: python subject_multi_generator_xml.py <study_id> [<output_dir>]")
        sys.exit(1)

    study_id = sys.argv[1]
    output_dir = sys.argv[2] if len(sys.argv) == 3 else DEFAULT_OUTPUT_DIR
    main(study_id, output_dir) 
