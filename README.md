# Blood-Donation-System
========================

We used python scripts to create large data records and insert values to the tables. We also used python modules such as Flask to 
establish connection to the UI.
The description of each file section submitted are given here.

Queries contains create, insert and dml query sqls
---------------------------------------------------
--create.sql : This file consists of the DDL queries to create relations and constraints.
 
--insert.sql : This file consists of sample insert queries to test the created relations.

--query.sql : Consists of all queries executed to test the database and the query optimization techniques used.

source contains fake data generation and insertion
----------------------------------------------------
--data_generation.ipynb : this python notebook has the code and sources to the dataset collected. Real-world hospital details and
 NGO names were colelcted from the sources specified. Valid addresses and phone numbers were generated using Barnum and Faker modules.
 The foreign key constraints were satisfied by sampling already inserted data. Equal or probability wise sampling is done to ensure 
 uniform distribution. All these generations dataframes are saved as CSV files to be read later

 --data_insertion.ipynb : The CSV files generated were read via Pandas and inserted to the relations created in PostgreSQL DB.

dataset
-------
 -- CSV Files : The data files obtained by random generation.

Web UI
-------
 --UI directory : consists of the files for the UI.
    --main.py : main python file where the database connection, UI functionalities etc are mentioned.
    --static/css/style.css : consists of the style commands for the UI.
    --static/js/my_script.js : consists of the scripts to ensure interactions between the UI and the backend db.
    --templates/index.html : base HTML file with the basic elements described.
