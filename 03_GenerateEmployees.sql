USE CyberSecurityAnalytics;
GO

WITH FirstNames AS (
    SELECT *
    FROM (VALUES
        (1, 'Emma'), (2, 'Liam'), (3, 'Sofia'), (4, 'Noah'), (5, 'Olivia'),
        (6, 'Lucas'), (7, 'Maya'), (8, 'Ethan'), (9, 'Aisha'), (10, 'Gabriel'),
        (11, 'Chloe'), (12, 'Mateo'), (13, 'Isabella'), (14, 'Daniel'), (15, 'Amelia'),
        (16, 'Leo'), (17, 'Priya'), (18, 'Hugo'), (19, 'Julia'), (20, 'Adam'),
        (21, 'Camille'), (22, 'Benjamin'), (23, 'Nora'), (24, 'Samuel'), (25, 'Elena'),
        (26, 'Jacob'), (27, 'Maria'), (28, 'Felix'), (29, 'Victoria'), (30, 'Nathan'),
        (31, 'Grace'), (32, 'Ryan'), (33, 'Ines'), (34, 'David'), (35, 'Yasmine'),
        (36, 'Oliver'), (37, 'Alice'), (38, 'Emily'), (39, 'Sebastian'), (40, 'Henry'),
        (41, 'Charlotte'), (42, 'James'), (43, 'Ana'), (44, 'Sarah'), (45, 'William'),
        (46, 'Lea'), (47, 'Alexander'), (48, 'Thomas'), (49, 'Clara'), (50, 'Michael'),
        (51, 'Zoe'), (52, 'Owen'), (53, 'Mia'), (54, 'Aaron'), (55, 'Leah'),
        (56, 'Harvey'), (57, 'Eleanor'), (58, 'Jasmine'), (59, 'Harrison'), (60, 'Phoebe'),
        (61, 'Alice'), (62, 'Freya'), (63, 'Edward'), (64, 'Louis'), (65, 'Erin'),
        (66, 'Oscar'), (67, 'Isaac'), (68, 'Laura'), (69, 'Mason'), (70, 'Ava'),
        (71, 'Scarlett'), (72, 'Rosie'), (73, 'Andrew'), (74, 'Madison'), (75, 'Joel'),
        (76, 'John'), (77, 'Leon'), (78, 'Natasha'), (79, 'Sean'), (80, 'Victoria'),
        (81, 'Eve'), (82, 'Eva'), (83, 'Sebastian'), (84, 'Patrick'), (85, 'Melissa'),
        (86, 'Theo'), (87, 'Samantha'), (88, 'Faith'), (89, 'Nicholas'), (90, 'Maya'),
        (91, 'Jennifer'), (92, 'Peter'), (93, 'Anthony'), (94, 'Julia'), (95, 'Natalie'),
        (96, 'Aisha'), (97, 'Naomi'), (98, 'Sofia'), (99, 'Marcus'), (100, 'Ibrahim'),
        (101, 'Stephanie'), (102, 'Ali'), (103, 'Maryam'), (104, 'Rose'), (105, 'Christian'),
        (106, 'Lara'), (107, 'Hamza'), (108, 'Florence'), (109, 'Paul'), (110, 'Finn'),
        (111, 'Fatima'), (112, 'Natalia'), (113, 'Ahmed'), (114, 'Catherine'), (115, 'Richard'),
        (116, 'Gabriella'), (117, 'Evelyn'), (118, 'Anya'), (119, 'Zain'), (120, 'Kevin'),
        (121, 'Heidi'), (122, 'Sasha'), (123, 'Hassan'), (124, 'Levi'), (125, 'Tristan'),
        (126, 'Eliza'), (127, 'Felix'), (128, 'Ciara'), (129, 'Abby'), (130, 'Hope'),
        (131, 'Yusuf'), (132, 'Heather'), (133, 'India'), (134, 'Abdullah'), (135, 'Ayesha'),
        (136, 'Esther'), (137, 'Amina'), (138, 'Nadia'), (139, 'Mariam'), (140, 'Omar'),
        (141, 'Elijah'), (142, 'Adrian'), (143, 'Cara'), (144, 'Elena'), (145, 'Claudia'),
        (146, 'Theodore'), (147, 'Justin'), (148, 'Leila'), (149, 'Tara'), (150, 'Bilal')
    ) AS f(FirstNameID, FirstName)
),

LastNames AS (
    SELECT *
    FROM (VALUES
        (1, 'Wilson'), (2, 'Thompson'), (3, 'Martinez'), (4, 'Anderson'), (5, 'Martin'),
        (6, 'Bernard'), (7, 'Patel'), (8, 'Clark'), (9, 'Roy'), (10, 'Kim'),
        (11, 'Taylor'), (12, 'Garcia'), (13, 'Nguyen'), (14, 'Johnson'), (15, 'Gagnon'),
        (16, 'Lee'), (17, 'Rossi'), (18, 'White'), (19, 'Haddad'), (20, 'Tremblay'),
        (21, 'Moore'), (22, 'Harris'), (23, 'Silva'), (24, 'Lewis'), (25, 'Bouchard'),
        (26, 'Walker'), (27, 'Popescu'), (28, 'Hall'), (29, 'Khan'), (30, 'Lavoie'),
        (31, 'Chen'), (32, 'Scott'), (33, 'Fernandez'), (34, 'Young'), (35, 'Robinson'),
        (36, 'Dubois'), (37, 'Sharma'), (38, 'King'), (39, 'Moreau'), (40, 'Baker'),
        (41, 'Costa'), (42, 'Campbell'), (43, 'Evans'), (44, 'Morgan'), (45, 'Laurent'),
        (46, 'Davis'), (47, 'Muller'), (48, 'Santos'), (49, 'Mitchell'), (50, 'Brown'),
        (51, 'Miller'), (52, 'Jones'), (53, 'Williams'), (54, 'Lopez'), (55, 'Gomez'),
        (56, 'Perez'), (57, 'Sanchez'), (58, 'Romano'), (59, 'Ricci'), (60, 'Conti'),
        (61, 'Fischer'), (62, 'Schmidt'), (63, 'Weber'), (64, 'Becker'), (65, 'Hoffmann'),
        (66, 'Lefevre'), (67, 'Girard'), (68, 'Fontaine'), (69, 'Mercier'), (70, 'Renaud'),
        (71, 'Cohen'), (72, 'Levy'), (73, 'Azoulay'), (74, 'Benali'), (75, 'Mansour'),
        (76, 'Rahman'), (77, 'Ahmed'), (78, 'Ali'), (79, 'Farouk'), (80, 'Salem'),
        (81, 'Singh'), (82, 'Kaur'), (83, 'Mehta'), (84, 'Kapoor'), (85, 'Malhotra'),
        (86, 'Desai'), (87, 'Gupta'), (88, 'Rao'), (89, 'Nair'), (90, 'Chopra'),
        (91, 'Wang'), (92, 'Li'), (93, 'Zhang'), (94, 'Liu'), (95, 'Chen'),
        (96, 'Huang'), (97, 'Lin'), (98, 'Wu'), (99, 'Xu'), (100, 'Zhou'),
        (101, 'Park'), (102, 'Choi'), (103, 'Kang'), (104, 'Yoon'), (105, 'Han'),
        (106, 'Tanaka'), (107, 'Sato'), (108, 'Suzuki'), (109, 'Nakamura'), (110, 'Ito'),
        (111, 'Kowalski'), (112, 'Nowak'), (113, 'Wisniewski'), (114, 'Wojcik'), (115, 'Mazur'),
        (116, 'Novak'), (117, 'Horvat'), (118, 'Petrovic'), (119, 'Jovanovic'), (120, 'Nikolic'),
        (121, 'Ivanov'), (122, 'Petrov'), (123, 'Smirnov'), (124, 'Volkov'), (125, 'Popov'),
        (126, 'Costa'), (127, 'Pereira'), (128, 'Sousa'), (129, 'Carvalho'), (130, 'Ferreira'),
        (131, 'Rodriguez'), (132, 'Ramirez'), (133, 'Castillo'), (134, 'Torres'), (135, 'Morales'),
        (136, 'Reyes'), (137, 'Flores'), (138, 'Cruz'), (139, 'Vega'), (140, 'Navarro'),
        (141, 'Murphy'), (142, 'Kelly'), (143, 'O''Connor'), (144, 'Walsh'), (145, 'Doyle'),
        (146, 'MacDonald'), (147, 'Fraser'), (148, 'Stewart'), (149, 'Murray'), (150, 'Sinclair')
    ) AS l(LastNameID, LastName)
),



Numbers AS (
    SELECT TOP (270)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects a
    CROSS JOIN sys.all_objects b
),



EmployeeNames AS (
    SELECT
    n,
  
  (
    SELECT FirstName
    FROM FirstNames
    WHERE FirstNameID = ((n - 1) % 150) + 1
    ) AS FirstName,

    (
    SELECT LastName
    FROM LastNames
    WHERE LastNameID =
                (
                    ((n - 1) % 150)
                    + (((n - 1) / 150) * 37)
                ) % 150 + 1
    ) AS LastName
    FROM Numbers
),



EmployeeData AS (
    SELECT
        n,
        FirstName,
        LastName,
        
        CASE
            WHEN n <= 60 THEN 1
            WHEN n <= 105 THEN 2
            WHEN n <= 190 THEN 3
            WHEN n <= 240 THEN 4
            ELSE 5
        END AS DepartmentID

    FROM EmployeeNames
),



FinalEmployees AS (
    SELECT
        n,
        FirstName,
        LastName,
        LOWER(
    FirstName + '.' + LastName +
    '@northbridge.com') AS Email,

    '+1 514 555 ' + RIGHT('0000' + CAST(1000 + n AS VARCHAR(4)), 4) AS PhoneNumber,


DepartmentID,
    CASE

-- Audit & Assurance (1 - 60)

WHEN DepartmentID = 1 THEN
CASE
    WHEN n <= 20 THEN 'Audit Analyst'
    WHEN n <= 44 THEN 'Audit Associate'
    WHEN n <= 56 THEN 'Senior Audit Associate'
    ELSE 'Audit Manager'
END

-- Tax & Legal (61 - 105)
          
WHEN DepartmentID = 2 THEN
CASE
    WHEN n <= 75 THEN 'Tax Analyst'
    WHEN n <= 90 THEN 'Tax Consultant'
    WHEN n <= 100 THEN 'Senior Tax Consultant'
    ELSE 'Tax Manager'
END

-- Consulting (106 - 190)
       
WHEN DepartmentID = 3 THEN
CASE
    WHEN n <= 135 THEN 'Business Analyst'
    WHEN n <= 155 THEN 'Consultant'
    WHEN n <= 180 THEN 'Senior Consultant'
    ELSE 'Consulting Manager'
END

-- Risk, Regulatory & Forensic (191 - 240)
        
WHEN DepartmentID = 4 THEN
CASE
    WHEN n <= 208 THEN 'Cyber Risk Analyst'
    WHEN n <= 223 THEN 'Cybersecurity Consultant'
    WHEN n <= 237 THEN 'Senior Cybersecurity Consultant'
    ELSE 'Cybersecurity Manager'
END

-- Strategy & Transactions (241 - 270)

ELSE
CASE
    WHEN n <= 252 THEN 'Strategy Analyst'
    WHEN n <= 262 THEN 'Strategy Consultant'
    WHEN n <= 267 THEN 'Senior Strategy Consultant'
    ELSE 'Strategy Manager'
END

END AS JobTitle,

      
DATEADD(DAY,
    -((n * 37) % 2920),
    CAST(GETDATE() AS DATE)
    ) AS HireDate
FROM EmployeeData
)


INSERT INTO Employees (
    FirstName,
    LastName,
    Email,
    PhoneNumber,
    DepartmentID,
    JobTitle,
    HireDate
)

SELECT
    FirstName,
    LastName,
    Email,
    PhoneNumber,
    DepartmentID,
    JobTitle,
    HireDate
FROM FinalEmployees;
GO

