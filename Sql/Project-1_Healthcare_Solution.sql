-- Active: 1708321218797@@127.0.0.1@3306@healthcare
--Problem Statement 1:  Jimmy, from the healthcare department, has requested a report that shows how the number of treatments each age category of patients has gone through in the year 2022. 
--The age category is as follows, Children (00-14 years), Youth (15-24 years), Adults (25-64 years), and Seniors (65 years and over).
--Assist Jimmy in generating the report. 

SELECT
    CASE
        WHEN FLOOR(DATEDIFF(CURRENT_DATE, p.dob) / 365.25) BETWEEN 0 AND 14 THEN 'Children (00-14 years)'
        WHEN FLOOR(DATEDIFF(CURRENT_DATE, p.dob) / 365.25) BETWEEN 15 AND 24 THEN 'Youth (15-24 years)'
        WHEN FLOOR(DATEDIFF(CURRENT_DATE, p.dob) / 365.25) BETWEEN 25 AND 64 THEN 'Adults (25-64 years)'
        ELSE 'Seniors (65 years and over)'
    END AS AgeCategory,
    COUNT(DISTINCT t.treatmentID) AS NumberOfTreatments
FROM
    Patient p
JOIN
    Treatment t ON p.patientID = t.patientID
WHERE
    YEAR(t.date) = 2022
GROUP BY
    AgeCategory;

--Problem Statement 2:  Jimmy, from the healthcare department, wants to know which disease is infecting people of which gender more often.
--Assist Jimmy with this purpose by generating a report that shows for each disease the male-to-female ratio. Sort the data in a way that is helpful for Jimmy.
SELECT
    d.diseaseName AS Disease,
    SUM(CASE WHEN pe.gender = 'Male' THEN 1 ELSE 0 END) AS MaleCount,
    SUM(CASE WHEN pe.gender = 'Female' THEN 1 ELSE 0 END) AS FemaleCount,
    CASE
        WHEN SUM(CASE WHEN pe.gender = 'Female' THEN 1 ELSE 0 END) = 0 THEN 'Male Only'
        WHEN SUM(CASE WHEN pe.gender = 'Male' THEN 1 ELSE 0 END) = 0 THEN 'Female Only'
        ELSE CAST(SUM(CASE WHEN pe.gender = 'Male' THEN 1 ELSE 0 END) AS FLOAT) / 
             CAST(SUM(CASE WHEN pe.gender = 'Female' THEN 1 ELSE 0 END) AS FLOAT)
    END AS MaleToFemaleRatio
FROM
    Disease d
JOIN
    Treatment t ON d.diseaseID = t.diseaseID
JOIN
    Patient pa ON t.patientID = pa.patientID
JOIN
    Person pe ON pe.personID = pe.personID
GROUP BY
    d.diseaseName
ORDER BY
    MaleToFemaleRatio DESC;
--Problem Statement 3: Jacob, from insurance management, has noticed that insurance claims are not made for all the treatments. He also wants to figure out if the gender of the patient has any impact on the insurance claim. Assist Jacob in this situation by generating a report that finds for each gender the number of treatments, number of claims, and treatment-to-claim ratio. And notice if there is a significant difference between the treatment-to-claim ratio of male and female patients.

SELECT
    pe.gender AS Gender,
    COUNT(DISTINCT t.treatmentID) AS NumTreatments,
    COUNT(DISTINCT c.claimID) AS NumClaims,
    CASE
        WHEN COUNT(DISTINCT c.claimID) = 0 THEN NULL
        ELSE CAST(COUNT(DISTINCT t.treatmentID) AS FLOAT) / COUNT(DISTINCT c.claimID)
    END AS TreatmentToClaimRatio
FROM
    Treatment t
JOIN
    Patient pa ON t.patientID = pa.patientID
JOIN
    Person pe ON pe.personID = pe.personID
LEFT JOIN
    Claim c ON t.claimID = c.claimID
GROUP BY
    pe.gender
ORDER BY
    Gender;

--Problem Statement 4: The Healthcare department wants a report about the inventory of pharmacies. Generate a report on their behalf that shows how many units of medicine each pharmacy has in their inventory, the total maximum retail price of those medicines, and the total price of all the medicines after discount. 
--Note: discount field in keep signifies the percentage of discount on the maximum price.
SELECT
    ph.pharmacyName AS PharmacyName,
    SUM(k.quantity) AS TotalQuantity,
    SUM(m.maxPrice * k.quantity) AS TotalMaxRetailPrice,
    SUM(m.maxPrice * (1 - k.discount / 100) * k.quantity) AS TotalPriceAfterDiscount
FROM
    Pharmacy ph
JOIN
    Keep k ON ph.pharmacyID = k.pharmacyID
JOIN
    Medicine m ON k.medicineID = m.medicineID
GROUP BY
    ph.pharmacyName;

--Problem Statement 5:  The healthcare department suspects that some pharmacies prescribe more medicines than others in a single prescription, for them, generate a report that finds for each pharmacy the maximum, minimum and average number of medicines prescribed in their prescriptions. 
SELECT
    ph.pharmacyName AS PharmacyName,
    MAX(prescription_medicines.num_medicines) AS MaxMedicines,
    MIN(prescription_medicines.num_medicines) AS MinMedicines,
    AVG(prescription_medicines.num_medicines) AS AvgMedicines
FROM
    Pharmacy ph
LEFT JOIN (
    SELECT
        pr.pharmacyID,
        pr.prescriptionID,
        COUNT(*) AS num_medicines
    FROM
        Prescription pr
    JOIN
        Contain c ON pr.prescriptionID = c.prescriptionID
    GROUP BY
        pr.pharmacyID, pr.prescriptionID
) AS prescription_medicines ON ph.pharmacyID = prescription_medicines.pharmacyID
GROUP BY
    ph.pharmacyName;

--Problemstatement-2
--Problem Statement 1: A company needs to set up 3 new pharmacies, they have come up with an idea that the pharmacy can be set up in cities where the pharmacy-to-prescription ratio is the lowest and the number of prescriptions should exceed 100. Assist the company to identify those cities where the pharmacy can be set up.
SELECT
    a.city AS City,
    COUNT(DISTINCT ph.pharmacyID) AS NumPharmacies,
    COUNT(DISTINCT pr.prescriptionID) AS NumPrescriptions,
    COUNT(DISTINCT pr.prescriptionID) / COUNT(DISTINCT ph.pharmacyID) AS PharmacyToPrescriptionRatio
FROM
    Pharmacy ph
JOIN
    Prescription pr ON ph.pharmacyID = pr.pharmacyID
JOIN
    Address a ON ph.addressID = a.addressID
GROUP BY
    a.city
HAVING
    NumPrescriptions > 100
ORDER BY
    PharmacyToPrescriptionRatio;

--Problem Statement 2: The State of Alabama (AL) is trying to manage its healthcare resources more efficiently. For each city in their state, they need to identify the disease for which the maximum number of patients have gone for treatment. Assist the state for this purpose.
--Note: The state of Alabama is represented as AL in Address Table.

SELECT
    a.city AS City,
    d.diseaseName AS MostCommonDisease,
    COUNT(*) AS NumPatients
FROM
    Patient pt
JOIN
    Person p ON p.personID = p.personID
JOIN
    Address a ON p.addressID = a.addressID
JOIN
    Treatment t ON pt.patientID = t.patientID
JOIN
    Disease d ON t.diseaseID = d.diseaseID
WHERE
    a.state = 'AL'
GROUP BY
    a.city, d.diseaseName
HAVING
    COUNT(*) = (
        SELECT
            COUNT(*)
        FROM
            Patient pt2
        JOIN
            Person p2 ON p2.personID = p2.personID
        JOIN
            Address a2 ON p2.addressID = a2.addressID
        JOIN
            Treatment t2 ON pt2.patientID = t2.patientID
        JOIN
            Disease d2 ON t2.diseaseID = d2.diseaseID
        WHERE
            a2.state = 'AL'
        AND
            a.city = a2.city
        GROUP BY
            a2.city
        ORDER BY
            COUNT(*) DESC
        LIMIT 1
    );


