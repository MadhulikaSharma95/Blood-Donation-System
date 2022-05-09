DELETE FROM Donor;
DELETE FROM Hospital;
DELETE FROM NGO;
DELETE FROM BloodBank;
DELETE FROM Inventory;
DELETE FROM Recipient;
DELETE FROM Request;

INSERT INTO Donor(donor_id,d_name,age,blood_group,address,contact_number)  VALUES ('d2311', 'neville', 23, 'O+ve', '3455 Transit Rd', '7168901100');
INSERT INTO Donor(donor_id,d_name,age,blood_group,address,contact_number)  VALUES ('d2421', 'dean', 28, 'B+ve', '4788 Main St', '7165661778');

INSERT INTO Hospital(hospital_id,h_name,Address) VALUES ('msc123', 'Memorial Service Center', '1232 Millersport Rd');
INSERT INTO Hospital(hospital_id,h_name,Address) VALUES ('bis23', 'Beth Israel Hospital', '1023 Red Turn St');

INSERT INTO NGO(ngo_id ,n_name, address) VALUES ('cfg33', 'Center For Good', '1983 Downtown Blvd');
INSERT INTO NGO(ngo_id ,n_name, address) VALUES ('gw239', 'Good Things in the World', '19 Cambridge Ave');

INSERT INTO BloodBank(bloodBankID, b_name ,Address, contact_number) VALUES ('ny981', 'Sheridan Blood Bank', '981 Sheridan Blvd', '7165567711');
INSERT INTO BloodBank(bloodBankID, b_name ,Address, contact_number) VALUES ('nw726', 'New Hope Blood Bank', '7661 Elm St', '4048899112');

INSERT INTO Inventory(bloodBankID, blood_group , units_available) VALUES ('ny981', 'O+ve', 16);
INSERT INTO Inventory(bloodBankID, blood_group , units_available) VALUES ('ny981', 'A+ve', 25);

INSERT INTO Recipient(recipient_id, r_name, age, blood_group, location_received_ngo, location_received_hospital, contact_number)  VALUES ('rc4053', 'ronald', 24, 'B+ve', NULL, 'msc123', '7168901100');
INSERT INTO Recipient(recipient_id, r_name, age, blood_group, location_received_ngo, location_received_hospital, contact_number)  VALUES ('rc2418', 'luna', 24, 'AB+ve', 'gw239', NULL ,'4041123355');

INSERT INTO Request(request_id,patient_id,donor_id,location_obtained,blood_group,waitlist,completed)  VALUES ('rq871', 'rc4053', 'd2421', 'ny981', 'B+ve', NULL, TRUE);
INSERT INTO Request(request_id,patient_id,donor_id,location_obtained,blood_group,waitlist,completed)  VALUES ('rq2905', 'rc2418', 'd2311', 'nw726', 'AB+ve', 2, FALSE );


SELECT * FROM Donor;
SELECT * FROM Hospital;
SELECT * FROM NGO;
SELECT * FROM BloodBank;
SELECT * FROM Inventory;
SELECT * FROM Recipient;
SELECT * FROM Request;
