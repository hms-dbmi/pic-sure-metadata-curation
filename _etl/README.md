
# PIC-SURE Metadata Curation ETL Project

This ETL (Extract, Transform, Load) project is designed to process metadata for multiple studies by converting SAS files to CSV, generating metadata, and creating subject multi and XML files.

---

## 📂 Project Structure

```
_etl
├── README.md
├── configs
│   ├── README.md
│   ├── README_dbGaP.md
│   ├── dbgap_study.v1.schema.json
│   └── metadata.schema.json
├── input
├── main.py
├── output
└── src
    ├── __init__.py
    ├── __pycache__
    │   ├── __init__.cpython-313.pyc
    │   ├── sas_2_csv.cpython-313.pyc
    │   ├── subject_multi_generator.cpython-313.pyc
    │   └── subject_multi_generator_xml.cpython-313.pyc
    ├── build_avl_lab_dict.py
    ├── no-concurrency.py
    ├── sas_2_csv.py
    ├── sstr_api.py
    ├── subject_multi_generator.py
    └── subject_multi_generator_xml.py

```

---

## ⚙️ Prerequisites

- Python 3.x
- Install required dependencies:

```bash
pip install -r requirements.txt
```

---

## 🚀 How to Run

1. Place your input SAS files into the `input/` directory.
2. Execute the main ETL process:

```bash
python main.py
```

This will:
- Convert SAS files to CSV.
- Generate metadata based on the input data.
- Create subject multi files.
- Generate corresponding XML files.

---

## 🛠️ Configuration

- The `configs/metadata.schema.json` defines the schema for validating metadata.
- Modify the `studies` list in `main.py` to process specific studies.

---

## 📂 Output

- Processed files will be saved in the `output/` directory, organized by study.

---

## 📝 Notes

- Ensure input files follow the expected format.
- Update the schema in `configs/metadata.schema.json` if necessary for validation purposes.

---

## 🤝 Contributing

1. Fork the repository.
2. Create a new branch.
3. Make your changes.
4. Submit a pull request.

---

## 📄 License

Specify your license here.
