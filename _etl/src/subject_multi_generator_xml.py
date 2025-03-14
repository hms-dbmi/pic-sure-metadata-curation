import requests
import xml.etree.ElementTree as ET
from datetime import datetime
import os

# examine this against the multi gen sstr should use same return object than do what it needs
def generate_study_xml(study_id, output_dir="./output"):

    summary_url = f"https://www.ncbi.nlm.nih.gov/gap/sstr/api/v1/study/{study_id}/summary"

    response = requests.get(summary_url)
    response.raise_for_status()  # Ensure request was successful
    data = response.json()

    study_info = data.get("study", {})
    study_accver = study_info.get("accver", {})
    consent_groups = study_info.get("consent_groups", [])

    participant_set = f"p{study_accver.get('participant_set', 1)}"

    # XML root
    root = ET.Element(
        "data_table",
        {
            "id": "subjects.v1",
            "study_id": study_id,
            "participant_set": participant_set,
            "date_created": datetime.now().strftime("%a %b %d %H:%M:%S %Y"),
        },
    )

    # Description
    description = ET.SubElement(root, "description")
    description.text = "The subject consent data table includes subject IDs and consent group information."

    # Subject ID variable
    subject_id_var = ET.SubElement(root, "variable", {"id": "dbgap_subject_id"})
    ET.SubElement(subject_id_var, "name").text = "dbgap_subject_id"
    ET.SubElement(subject_id_var, "description").text = "dbGap Subject ID"
    ET.SubElement(subject_id_var, "type").text = "String"

    # Submitted Subject ID variable
    subject_id_var = ET.SubElement(root, "variable", {"id": "submitted_subject_id"})
    ET.SubElement(subject_id_var, "name").text = "submitted_subject_id"
    ET.SubElement(subject_id_var, "description").text = "Submitted Subject ID"
    ET.SubElement(subject_id_var, "type").text = "String"

    # Consent variable
    consent_var = ET.SubElement(root, "variable", {"id": "consent_code"})
    ET.SubElement(consent_var, "name").text = "consent_code"
    ET.SubElement(consent_var, "description").text = "Consent group as determined by DAC"
    ET.SubElement(consent_var, "type").text = "encoded value"

    # Populate consent values dynamically
    for group in consent_groups:
        value = ET.SubElement(consent_var, "value", {"code": str(group["code"])})
        value.text = f'{group["code"]} = {group["name"]} ({group["short_name"]})'

    # Convert to XML string
    xml_str = '<?xml version="1.0"?>\n<?xml-stylesheet type="text/xsl" href="./datadict_v1.xsl"?>\n'
    xml_str += ET.tostring(root, encoding="utf-8").decode()

    # Ensure output directory exists
    os.makedirs(output_dir, exist_ok=True)

    # Save to a file
    xml_filename = os.path.join(output_dir, f"{study_id}.{participant_set}.Subject.MULTI.data_dict.xml")
    with open(xml_filename, "w", encoding="utf-8") as xml_file:
        xml_file.write(xml_str)

    print(f"XML file '{xml_filename}' has been generated successfully.")

def main(study_id, output_dir='./output'):
    generate_study_xml(study_id, output_dir)

if __name__ == "__main__":
    main()