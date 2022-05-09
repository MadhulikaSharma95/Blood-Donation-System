DROP TABLE IF EXISTS Donor CASCADE;
DROP TABLE IF EXISTS Recipient CASCADE;
DROP TABLE IF EXISTS Request CASCADE;
DROP TABLE IF EXISTS Hospital CASCADE; 
DROP TABLE IF EXISTS NGO CASCADE;
DROP TABLE IF EXISTS BloodBank CASCADE;
DROP TABLE IF EXISTS Inventory CASCADE;

CREATE TABLE donor(donor_id VARCHAR(15) PRIMARY KEY,
			d_name VARCHAR(100),
			age INTEGER,
			blood_group VARCHAR(5),
			address VARCHAR(100),
			contact_number VARCHAR(100));

CREATE TABLE hospital(hospital_id VARCHAR(15) PRIMARY KEY,
		                h_name VARCHAR(100),
		                address VARCHAR(100));

CREATE TABLE ngo(ngo_id VARCHAR(15) PRIMARY KEY,
		           n_name VARCHAR(100),
		           address VARCHAR(100));

CREATE TABLE bloodbank(bloodbankid VARCHAR(15) PRIMARY KEY,
			       b_name VARCHAR(100),
      			   address VARCHAR(100),
			       contact_number VARCHAR(100));

CREATE TABLE inventory(bloodbankid VARCHAR(15),
			    blood_group VARCHAR(100),
			    units_available INTEGER,
			    PRIMARY KEY(bloodbankid, blood_group));

CREATE TABLE recipient(recipient_id VARCHAR(15) PRIMARY KEY,
			     	   r_name VARCHAR(100),
			     	   age INTEGER,
			     	   blood_group VARCHAR(5),
			     	   location_received_ngo VARCHAR(15),
					   location_received_hospital VARCHAR(15),
			     	   contact_number VARCHAR(100),
			     	   CONSTRAINT fk_loc_hosp FOREIGN KEY (location_received_hospital) REFERENCES hospital(hospital_id) ON DELETE CASCADE,
			     	   CONSTRAINT fk_loc_ngo FOREIGN KEY (location_received_ngo) REFERENCES ngo(ngo_id) ON DELETE CASCADE);

CREATE TABLE request(request_id VARCHAR(15) PRIMARY KEY,
			   patient_id VARCHAR(15),
			   donor_id VARCHAR(15),
			   location_obtained VARCHAR(15),
			   blood_group VARCHAR(5),
			   waitlist INTEGER,
			   completed BOOLEAN,
			   CONSTRAINT fk_loc FOREIGN KEY (location_obtained) REFERENCES bloodbank(bloodbankid) ON DELETE CASCADE,
			   CONSTRAINT fk_pat FOREIGN KEY (patient_id) REFERENCES recipient(recipient_id) ON DELETE CASCADE,
			   CONSTRAINT fk_don FOREIGN KEY (donor_id) REFERENCES donor(donor_id) ON DELETE CASCADE);

