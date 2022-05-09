-- Patient details who are top in waitlist requesting blood in California State/
DROP VIEW IF EXISTS patient_dtls;
CREATE VIEW patient_dtls 
		AS SELECT rq.waitlist,rq.request_id,rq.patient_id,rq.blood_group,rc.r_name,rc.age,rc.contact_number,
		rc.location_received_ngo,rc.location_received_hospital 
		FROM Request rq INNER JOIN Recipient rc 
		ON rc.recipient_id = rq.patient_id WHERE completed = 'false' AND waitlist = 1;
		
(SELECT pd.patient_id, pd.r_name AS patient_name, pd.age, pd.contact_number, 
 		pd.blood_group, n.n_name AS org_name, n.address AS org_address 
 		FROM patient_dtls pd INNER JOIN NGO n ON n.ngo_id = pd.location_received_ngo WHERE address LIKE '%CA%') 
	UNION
(SELECT pd1.patient_id, pd1.r_name AS patient_name, pd1.age, pd1.contact_number,
 		pd1.blood_group, h.h_name AS org_name, h.address AS org_address 
 		FROM patient_dtls pd1 INNER JOIN Hospital h ON h.hospital_id = pd1.location_received_hospital WHERE address LIKE '%CA%');
		
-----==============================================================================================================================================================================================================================================================
-- fetch contact info for all the donors who have donated in the past for the blood bank that have no units available currently to reach out to them for blood donation/
-- this select query now takes 69 msec
SELECT d1.donor_id, d1.d_name AS donor_name, d1.blood_group, d1.contact_number AS donor_contact, 
	   bb1.b_name AS blood_bank_name, bb1.address AS blood_bank_address, bb1.contact_number AS blood_bank_contact 
	   FROM donor d1 INNER JOIN request r1 ON d1.donor_id = r1.donor_id INNER JOIN bloodbank bb1 ON bb1.bloodbankid = r1.location_obtained 
	   WHERE d1.donor_id IN (SELECT donor_id FROM bloodbank bb INNER JOIN 
							 inventory i ON bb.bloodbankid = i.bloodbankid AND i.units_available=0 INNER JOIN 
							 request r ON r.location_obtained = bb.bloodbankid WHERE completed = 'true' AND i.blood_group = r.blood_group);
							 
-----==============================================================================================================================================================================================================================================================

-- find donors in the same city where blood is requested/
WITH recipient_list AS (SELECT * FROM recipient r INNER JOIN NGO n ON r.location_received_ngo = n.ngo_id WHERE address LIKE '%FL%'
UNION SELECT * FROM recipient r INNER JOIN hospital h ON r.location_received_hospital = h.hospital_id WHERE address LIKE '%FL%')
SELECT * FROM Donor d WHERE d.address LIKE '%FL%' AND blood_group IN (SELECT rl.blood_group FROM recipient_list rl) ORDER BY blood_group;

-----==============================================================================================================================================================================================================================================================
-- /delete donors who have registered for donation but have not donated yet and now are 65 and older/
DELETE FROM donor WHERE donor_id IN
		(SELECT * FROM donor WHERE donor_id NOT IN (SELECT donor_id FROM request WHERE completed = 'true') AND age>= 65 )
-----==============================================================================================================================================================================================================================================================
-- This trigger will allow to insert and update donors with age more than 18, else will raise an error/
DROP FUNCTION IF EXISTS donor_age_verification();
DROP TRIGGER IF EXISTS verify_age ON donor;
CREATE FUNCTION donor_age_verification()
RETURNS TRIGGER AS $BODY$
BEGIN
IF NEW.age > 18 THEN
    RETURN NEW;
ELSE
	RAISE EXCEPTION 'Age must be greater than 18 to donate blood';
END IF;
END;
$BODY$
LANGUAGE 'plpgsql';
CREATE TRIGGER verify_age BEFORE INSERT OR UPDATE ON donor 
FOR EACH ROW EXECUTE PROCEDURE donor_age_verification();

INSERT INTO Donor(donor_id,d_name,age,blood_group,address,contact_number)  
	VALUES ('d3301', 'neville', 16, 'O+ve', '3455 Transit Rd', '7168901100');
-----==============================================================================================================================================================================================================================================================

-- /Total Blood units available in zipcode 94611 group by Blood Group/
SELECT blood_group, SUM(units_available) AS units_available 
	FROM inventory i INNER JOIN bloodbank bb ON i.bloodbankid = bb.bloodbankid WHERE address LIKE '%94611%' GROUP BY blood_group ;
	
-----==============================================================================================================================================================================================================================================================
-- /picks up the oldest request id pending and assigns the existing donor with same blood group updating the status as completed and waitlist as 0/
UPDATE request SET donor_id =(SELECT donor_id FROM donor WHERE blood_group IN
							 (SELECT blood_group FROM request WHERE request_id  = 
							 (SELECT request_id FROM request WHERE waitlist = 1 ORDER BY request_id ASC LIMIT 1))
							  AND donor_id NOT IN (SELECT donor_id FROM request WHERE donor_id IS NOT null) ORDER BY donor_id LIMIT 1),
				   waitlist = 0, 
				   completed = 'true'
				WHERE request_id  = (SELECT request_id FROM request WHERE waitlist = 1 ORDER BY request_id ASC LIMIT 1)
-----==============================================================================================================================================================================================================================================================
/*active donors who have donated outside their state for the blood banks in Florida*/
SELECT bb.b_name AS blood_bank_name, 
	   bb.address AS blood_bank_address, 
	   d.d_name AS donor_name, 
	   d.age, 
	   d.address AS donor_address, 
	   d.contact_number 
	   FROM donor d INNER JOIN
	   request r ON r.donor_id = d.donor_id INNER JOIN 
	   bloodbank bb ON bb.bloodbankid = r.location_obtained AND bb.address LIKE '%FL%' AND d.address <> '%FL%';
-----==============================================================================================================================================================================================================================================================
/*top 10 blood blanks and their stock of rare blood group 'AB-' in Kentucky */
SELECT bb.b_name AS blood_bank_name,bb.address, bb.contact_number, SUM(units_available) AS units_available 
FROM bloodbank bb INNER JOIN inventory i ON bb.bloodbankid = i.bloodbankid AND blood_group = 'AB-' AND address LIKE '%KY%'
GROUP BY bb.b_name, bb.address, bb.contact_number ORDER BY units_available DESC LIMIT 10;
-----==============================================================================================================================================================================================================================================================
--query optimization on selecting donors using blood group as as index this select query now takes 38 msec
CREATE INDEX IF NOT EXISTS blood_group_donor ON donor (blood_group);
SELECT d1.donor_id, d1.d_name AS donor_name, d1.blood_group, d1.contact_number AS donor_contact, 
	   bb1.b_name AS blood_bank_name, bb1.address AS blood_bank_address, bb1.contact_number AS blood_bank_contact 
	   FROM donor d1 INNER JOIN request r1 ON d1.donor_id = r1.donor_id INNER JOIN bloodbank bb1 ON bb1.bloodbankid = r1.location_obtained 
	   WHERE d1.donor_id IN (SELECT donor_id FROM bloodbank bb INNER JOIN 
							 inventory i ON bb.bloodbankid = i.bloodbankid AND i.units_available=0 INNER JOIN 
							 request r ON r.location_obtained = bb.bloodbankid WHERE completed = 'true' AND i.blood_group = r.blood_group);
EXPLAIN ANALYSE SELECT d1.donor_id, d1.d_name AS donor_name, d1.blood_group, d1.contact_number AS donor_contact, 
	   bb1.b_name AS blood_bank_name, bb1.address AS blood_bank_address, bb1.contact_number AS blood_bank_contact 
	   FROM donor d1 INNER JOIN request r1 ON d1.donor_id = r1.donor_id INNER JOIN bloodbank bb1 ON bb1.bloodbankid = r1.location_obtained 
	   WHERE d1.donor_id IN (SELECT donor_id FROM bloodbank bb INNER JOIN 
							 inventory i ON bb.bloodbankid = i.bloodbankid AND i.units_available=0 INNER JOIN 
							 request r ON r.location_obtained = bb.bloodbankid WHERE completed = 'true' AND i.blood_group = r.blood_group);
-----==============================================================================================================================================================================================================================================================
-- query optimization on the selection query
DROP VIEW IF EXISTS ky_bloodbanks;
CREATE VIEW ky_bloodbanks 
	AS SELECT bloodbankid, b_name, address, contact_number FROM bloodbank WHERE address LIKE '%KY%';
SELECT ky_bloodbanks.b_name, ky_bloodbanks.address, ky_bloodbanks.contact_number, SUM(inventory.units_available) AS units_available
		 FROM ky_bloodbanks INNER JOIN inventory on ky_bloodbanks.bloodbankid = inventory.bloodbankid WHERE blood_group = 'AB-'
		 GROUP BY ky_bloodbanks.b_name, ky_bloodbanks.address, ky_bloodbanks.contact_number ORDER BY units_available DESC LIMIT 10;

-----==============================================================================================================================================================================================================================================================
