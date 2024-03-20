/* -- The pharmacy which have prescribed hospital-exclusive medicines in the years 2021 and 2022 in decsending order.
*/
SELECT
    pharmacyName,
    COUNT(*) AS total_prescriptions
FROM
    pharmacy
JOIN
    keep ON keep.pharmacyID = pharmacy.pharmacyID
JOIN
	medicine ON medicine.medicineID = keep.medicineID
JOIN
	prescription ON prescription.pharmacyID = pharmacy.pharmacyID
JOIN
	treatment ON treatment.treatmentID = prescription.treatmentID
WHERE
    medicine.hospitalExclusive = 'S' -- Assuming there's a field indicating exclusivity
    AND YEAR(treatment.date) IN (2021, 2022)
GROUP BY
    pharmacyName
ORDER BY
    total_prescriptions DESC;
    
/* the report shows each insurance plan, the company that issues the plan, and the number of treatments the plan was claimed for.
 */
 
SELECT
    ip.planName,
    ic.companyName,
    COUNT(t.claimID) AS num_claims
FROM
    insuranceplan ip
JOIN
    insurancecompany ic ON ip.companyID = ic.companyID
JOIN
	claim c on ip.uin = c.uin
JOIN
    treatment t ON t.claimID = c.claimID
GROUP BY
    ip.planName, ic.companyName
ORDER BY
    num_claims DESC;
    
    
/*The report that shows each insurance company's name with their most and least claimed insurance plans.
*/
SELECT
    ic.companyName,
    MAX(ip.planName) AS most_claimed_plan,
    MIN(ip.planName) AS least_claimed_plan
FROM
    insurancecompany ic
JOIN
    insuranceplan ip ON ic.companyID = ip.companyID
LEFT JOIN
    treatment t ON ip.uin = t.claimID
GROUP BY
    ic.companyName;
    
/*
The report shows the state name, 
number of registered people in the state, 
number of registered patients in the state, 
and the people-to-patient ratio. sort the data by people-to-patient ratio. 
*/
SELECT
    a.state,
    COUNT(DISTINCT p.personID) AS num_registered_people,
    COUNT(DISTINCT pt.patientID) AS num_registered_patients,
    COUNT(DISTINCT p.personID) / COUNT(DISTINCT pt.patientID) AS people_to_patient_ratio
FROM
    address a
JOIN
    person p ON a.addressID = p.addressID
JOIN
    patient pt ON pt.patientID = p.personID
GROUP BY
    a.state
ORDER BY
    people_to_patient_ratio;

/*
The report that lists the total quantity of medicine each pharmacy in his state has 
prescribed that falls under Tax criteria I for treatments that took place in 2021. 
Assist Jhonny in generating the report.
*/
SELECT
    ph.pharmacyName,
    SUM(k.quantity) AS total_quantity
FROM
    prescription p
JOIN
    pharmacy ph ON p.pharmacyID = ph.pharmacyID
JOIN
    treatment t ON p.treatmentID = t.treatmentID
JOIN
    contain c ON p.prescriptionID = c.prescriptionID
JOIN
    keep k ON p.pharmacyID = k.pharmacyID AND c.medicineID = k.medicineID
JOIN
    medicine m ON c.medicineID = m.medicineID
WHERE
    m.taxCriteria = 'I'
    AND t.date LIKE '2021%'
    AND ph.addressID IN (SELECT addressID FROM address WHERE state = 'AZ')
GROUP BY
    ph.pharmacyName;