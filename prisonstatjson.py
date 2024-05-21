from flask import Flask, jsonify
import os
import pandas as pd

app = Flask(__name__)
csv_directory = os.getcwd()  # Directory where the CSV files are located

# Endpoint to get the content of all CSV files
@app.route('/csv-files', methods=['GET'])
def get_all_csv_files():
    csv_files = [file for file in os.listdir(csv_directory) if file.endswith('.csv')]
    all_data = {}
    
    for csv_file in csv_files:
        try:
            file_path = os.path.join(csv_directory, csv_file)
            df = pd.read_csv(file_path)
            data = df.to_dict(orient='records')
            all_data[csv_file] = data
        except Exception as e:
            all_data[csv_file] = {"error": str(e)}
    
    return jsonify(all_data), 200

if __name__ == '__main__':
    app.run(debug=True)
    