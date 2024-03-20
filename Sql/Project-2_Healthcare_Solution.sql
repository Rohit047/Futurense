
--     	                      			PROJECT 2 HEALTHCARE 

-- Problem Statement 1 Solution
SELECT d.diseaseName, COUNT(DISTINCT pe.addressID) AS household_count
FROM Treatment t
JOIN Disease d ON t.diseaseID = d.diseaseID
JOIN Patient p ON t.patientID = p.patientID
JOIN Person pe ON p.patientID = pe.personID
GROUP BY d.diseaseName
HAVING COUNT(DISTINCT pe.addressID) > 1;


-- Problem Statement 2 Solution

SELECT a.city, d.diseaseName, COUNT(t.treatmentID) AS treatment_count
FROM Address a
JOIN Treatment t ON t.patientID IN (
    SELECT p.personID
    FROM Person p
    WHERE p.addressID = a.addressID
)
JOIN Disease d ON t.diseaseID = d.diseaseID
WHERE a.state = 'AL'
GROUP BY a.city, d.diseaseName
ORDER BY treatment_count DESC;


-- Problem Statement 3 Solution

SELECT d.diseaseName,
    (SELECT ip.planName
     FROM InsurancePlan ip
     JOIN Claim c ON ip.uin = c.uin
     JOIN Treatment t ON c.claimID = t.claimID
     JOIN Disease d2 ON t.diseaseID = d2.diseaseID
     WHERE d2.diseaseID = d.diseaseID
     GROUP BY ip.planName
     ORDER BY COUNT(c.claimID) DESC
     LIMIT 1) AS max_claimed_plan,
    (SELECT ip.planName
     FROM InsurancePlan ip
     JOIN Claim c ON ip.uin = c.uin
     JOIN Treatment t ON c.claimID = t.claimID
     JOIN Disease d2 ON t.diseaseID = d2.diseaseID
     WHERE d2.diseaseID = d.diseaseID
     GROUP BY ip.planName
     ORDER BY COUNT(c.claimID) ASC
     LIMIT 1) AS min_claimed_plan
FROM Disease d;


-- Problem Statement 4 Solution
SELECT d.diseaseName, COUNT(DISTINCT pe.addressID) AS household_count
FROM Treatment t
JOIN Disease d ON t.diseaseID = d.diseaseID
JOIN Patient p ON t.patientID = p.patientID
JOIN Person pe ON p.patientID = pe.personID
GROUP BY d.diseaseName
HAVING COUNT(DISTINCT pe.addressID) > 1;
    
-- Problem Statement 5 Solution    
SELECT a.state, COUNT(DISTINCT t.treatmentID) AS treatment_count, COUNT(DISTINCT c.claimID) AS claim_count
FROM Address a
JOIN Person p ON a.addressID = p.addressID
JOIN Patient pa ON p.personID = pa.patientID
JOIN Treatment t ON pa.patientID = t.patientID
LEFT JOIN Claim c ON t.claimID = c.claimID
WHERE t.date BETWEEN '2021-04-01' AND '2022-03-31'
GROUP BY a.state;