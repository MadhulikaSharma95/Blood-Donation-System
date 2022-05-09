from flask import Flask, render_template, request, jsonify, json
from markupsafe import escape
import numpy as np
import pandas as pd
import sqlalchemy
from urllib.parse import quote


app = Flask(__name__)
DB_NAME = "blood_bank_project"
URL = "localhost"
PORT = "5432"
PWD = quote('alohoomora')
DB_ENGINE = sqlalchemy.create_engine("postgresql://postgres:alohomora@localhost:5432/blood_bank_project")

@app.route('/<name>')
def gen(name):
    return f"hello {escape(name)}"

@app.route('/api/search_query', methods=["POST", "GET"])
def search_query():
    # print(type(request.args.to_dict()))
    # print(request.data.decode())
    # data = json.loads(request.data)
    # data = request.args.to_dict()
    data = request.form.to_dict()
    query = data['query']
    # print(query)
    results = {}
    results['len'] = 0
    results['data'] = []
    results['columns'] = []
    try:
        query_outcome = pd.read_sql_query(query, con=DB_ENGINE)
        print(query_outcome.shape)
        # query_outcome = pd.read_excel('data.xlsx')
        # query_outcome = []
        if len(query_outcome) == 0:
            return jsonify(results)
        else:
            results['len'] = len(query_outcome)
            results['columns'] = query_outcome.columns.tolist()
            for col in query_outcome.columns:
                if query_outcome[col].dtype != 'O':
                    query_outcome[col] = query_outcome[col].astype('str', errors='ignore')
            for i in range(len(query_outcome)):
                results['data'].append(query_outcome.iloc[i].tolist())
    except Exception:
        print(Exception)

    # request.data.decode()
    # print(results)
    return jsonify(results)

@app.route('/')
def main():
    return render_template('index.html')



# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    app.run(debug=True)
