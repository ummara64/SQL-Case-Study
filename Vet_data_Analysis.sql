use sql_assign_02;

select * from petowners;
select * from pets;
select * from proceduresdetails;
select * from procedureshistory;

-- 1. List the names of all pet owners along with the names of their pets.

SELECT 
    CONCAT(po.name, ' ', po.surname) AS Owner_name,
    p.name AS Pet_name
FROM
    petowners AS po
        JOIN
    pets AS p ON po.ownerid = p.ownerid;
    
-- 2. List all pets and their owner names, including pets that don't have recorded owners.

SELECT 
    p.name AS Pet_name,
    CONCAT(po.name, ' ', po.surname) AS Owner_name
FROM
    petowners AS po
        RIGHT JOIN
    pets AS p ON po.ownerid = p.ownerid;

-- 3. Combine the information of pets and their owners, including those pets without owners and owners without pets.
-- Hint: We cannot use Full join in mysql. We will use Left Join + union + Right Join.

SELECT 
    p.name AS Pet_name,
    CONCAT(po.name, ' ', po.surname) AS Owner_name
FROM
    pets AS p
        LEFT JOIN
    petowners AS po ON po.ownerid = p.ownerid 
UNION SELECT 
    p.name AS Pet_name,
    CONCAT(po.name, ' ', po.surname) AS Owner_name
FROM
    pets AS p
        RIGHT JOIN
    petowners AS po ON po.ownerid = p.ownerid;


-- 4. List all pet owners and the number of dogs they own.

SELECT 
    CONCAT(po.name, ' ', po.surname) AS Owner_name,
    COUNT(p.ownerid) AS number_of_dogs_own
FROM
    petowners AS po
        LEFT JOIN
    pets AS p ON po.ownerid = p.ownerid
GROUP BY owner_name;

-- 5. Identify pets that have not had any procedures.

SELECT 
    p.petid as Pet_ID, p.name as Pet_name
FROM
    pets AS p
        LEFT JOIN
    procedureshistory AS ph ON p.petid = ph.petid
WHERE
    ph.petid IS NULL;

-- 6. Find the name of the oldest pet.

SELECT 
    p.Name AS Oldest_Pet
FROM
    pets AS p
WHERE
    age = (SELECT 
            MAX(age)
        FROM
            pets);

-- 7. Find the details of procedures performed on 'Cuddles'.
SELECT 
    pd.ProcedureType AS Procedure_Type,
    pd.ProcedureSubCode AS Procedure_sub_code,
    pd.Description,
    pd.Price
FROM
    proceduresdetails AS pd
        INNER JOIN
    procedureshistory AS ph ON pd.proceduresubcode = ph.proceduresubcode
        LEFT JOIN
    pets AS p ON ph.petid = p.petid
WHERE
    name = 'cuddles';
    
-- 8. List the pets who have undergone a procedure called 'VACCINATIONS'.

SELECT 
    p.name AS Pets, ph.proceduretype AS Procedure_type
FROM
    pets AS p
        INNER JOIN
    procedureshistory AS ph ON ph.petid = p.petid
WHERE
    proceduretype = 'VACCINATIONS';
    
-- 9. Count the number of pets of each kind.

SELECT 
    kind as Pet_Kind, COUNT(Kind) AS Count
FROM
    pets
GROUP BY kind;

-- 10. Group pets by their kind and gender and count the number of pets in each group.

SELECT 
    kind AS Pet_Kind, gender AS Gender, COUNT(gender) AS Count
FROM
    pets
GROUP BY kind , gender;

-- 11. Show the average age of pets for each kind, but only for kinds that have more than 5 pets.
SELECT 
    kind AS Pet_Kind, ROUND(AVG(age), 1) AS Avg_age
FROM
    pets
GROUP BY kind
HAVING COUNT(kind) > 5;

-- 12. Find the types of procedures that have an average cost greater than $50.

SELECT 
    proceduretype AS Types_of_procedures
FROM
    proceduresdetails
GROUP BY proceduretype
HAVING ROUND(AVG(price)) > 50;

-- 13. Classify pets as 'Young', 'Adult', or 'Senior' based on their age. 
-- Age less then 3 Young, Age between 3and 8 Adult, else Senior.

SELECT 
    *,
    CASE
        WHEN age < 3 THEN 'Young'
        WHEN age >= 3 AND age <= 8 THEN 'Adult'
        ELSE 'Senior'
    END AS Pets_AgeBased_Classification
FROM
    pets;
    
-- 14. Show the gender of pets with a custom label ('Boy' for male, 'Girl' for female).
SELECT 
    *,
    CASE
        WHEN gender = 'male' THEN 'Boy'
        WHEN gender = 'Female' THEN 'Girl'
        ELSE 'Gender Not known'
    END AS Custom_label
FROM
    pets;
    
-- 15. For each pet, display the pet's name, the number of procedures they've had,
-- and a status label: 'Regular' for pets with 1 to 3 procedures, 'Frequent' for 4 to 7 procedures, and 'Super User' for more than 7 procedures.

SELECT 
    p.name,
    COUNT(ph.proceduretype) AS No_of_procedures,
    CASE
        WHEN
            COUNT(ph.proceduretype) >= 1
                AND COUNT(ph.proceduretype) <= 3
        THEN
            'Regular'
        WHEN
            COUNT(ph.proceduretype) >= 4
                AND COUNT(ph.proceduretype) <= 7
        THEN
            'Fequent'
        WHEN COUNT(ph.proceduretype) >= 7 THEN 'Super User'
        ELSE 'No procedures taken'
    END AS Status_label
FROM
    pets AS p
        LEFT JOIN
    procedureshistory ph ON p.petid = ph.petid
GROUP BY p.name;