USE CyberSecurityAnalytics;
GO

-- LAPTOPS

INSERT INTO Devices (
    EmployeeID,
    DeviceType,
    OperatingSystem,
    AssignedDate,
    DeviceStatus
)
SELECT
    EmployeeID,
    'Laptop',
    'Windows 11 Pro',
  
  DATEADD(
        DAY,
        -((EmployeeID * 13) % 900),
        CAST(GETDATE() AS DATE)
    ),
   
   'Active'
FROM Employees;
GO

-- PHONES

INSERT INTO Devices (
    EmployeeID,
    DeviceType,
    OperatingSystem,
    AssignedDate,
    DeviceStatus
)
SELECT
    EmployeeID,
    'Mobile',
    CASE
        WHEN EmployeeID % 10 < 7 THEN 'iOS'
        ELSE 'Android'
    END,
    
    DATEADD(
        DAY,
        -((EmployeeID * 17) % 700),
        CAST(GETDATE() AS DATE)
    ),
   
   CASE
        WHEN EmployeeID % 50 = 0 THEN 'Lost'
        WHEN EmployeeID % 25 = 0 THEN 'Retired'
        ELSE 'Active'
    END

FROM Employees;
GO

-- TABLETS

INSERT INTO Devices (
    EmployeeID,
    DeviceType,
    OperatingSystem,
    AssignedDate,
    DeviceStatus
)
SELECT
    EmployeeID,
    'Tablet',
    'iPadOS',

    DATEADD(
        DAY,
        -((EmployeeID * 19) % 600),
        CAST(GETDATE() AS DATE)
    ),

    'Active'

FROM Employees

WHERE JobTitle IN (
    'Audit Manager',
    'Tax Manager',
    'Consulting Manager',
    'Cybersecurity Manager',
    'Strategy Manager'
)

OR (
    JobTitle IN (
        'Senior Consultant',
        'Senior Cybersecurity Consultant',
        'Senior Strategy Consultant'
    )
    AND EmployeeID % 2 = 0
);
GO