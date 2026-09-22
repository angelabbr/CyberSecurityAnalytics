USE CyberSecurityAnalytics;
GO

WITH Numbers AS (
    SELECT TOP (200)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects a
    CROSS JOIN sys.all_objects b
),

BaseIncidents AS (
    SELECT
        n,
        ((n * 47 - 1) % 270) + 1 AS EmployeeID
    FROM Numbers
),

-- INCIDENT DETAILS

IncidentDetails AS (
    SELECT
        n,
        EmployeeID,

        CASE
            WHEN n % 100 < 30 THEN 'Phishing Email'
            WHEN n % 100 < 50 THEN 'Malware Infection'
            WHEN n % 100 < 65 THEN 'Unauthorized Access'
            WHEN n % 100 < 75 THEN 'Lost Device'
            WHEN n % 100 < 83 THEN 'Suspicious Network Activity'
            WHEN n % 100 < 90 THEN 'Antivirus Detection'
            WHEN n % 100 < 94 THEN 'Account Compromise'
            WHEN n % 100 < 97 THEN 'Unauthorized File Transfer'
            WHEN n % 100 < 99 THEN 'Data Leakage'
            ELSE 'Ransomware'
        END AS IncidentType

    FROM BaseIncidents
),

-- INCIDENT DEVICES

IncidentDevices AS (
    SELECT
        i.n,
        i.EmployeeID,
        d.DeviceID,
        i.IncidentType

    FROM IncidentDetails i

    CROSS APPLY (
        SELECT TOP (1)
            DeviceID

        FROM Devices d

        WHERE d.EmployeeID = i.EmployeeID

          AND (
                i.IncidentType <> 'Lost Device'
                OR d.DeviceType IN ('Mobile', 'Tablet')
              )

        ORDER BY
            ((d.DeviceID * 31 + i.n * 17) % 997)

    ) d
),

-- INCIDENT SEVERITY 

IncidentSeverity AS (
    SELECT
        n,
        EmployeeID,
        DeviceID,
        IncidentType,

        CASE

            WHEN IncidentType = 'Ransomware' THEN
                CASE
                    WHEN n % 4 = 0 THEN 'High'
                    ELSE 'Critical'
                END

            WHEN IncidentType = 'Data Leakage' THEN
                CASE
                    WHEN n % 3 = 0 THEN 'Critical'
                    ELSE 'High'
                END

            WHEN IncidentType = 'Account Compromise' THEN
                CASE
                    WHEN n % 4 = 0 THEN 'Medium'
                    WHEN n % 4 = 1 THEN 'High'
                    ELSE 'Critical'
                END

            WHEN IncidentType = 'Unauthorized File Transfer' THEN
                CASE
                    WHEN n % 3 = 0 THEN 'Medium'
                    ELSE 'High'
                END

            WHEN IncidentType = 'Unauthorized Access' THEN
                CASE
                    WHEN n % 4 = 0 THEN 'Low'
                    WHEN n % 4 = 1 THEN 'Medium'
                    ELSE 'High'
                END

            WHEN IncidentType = 'Malware Infection' THEN
                CASE
                    WHEN n % 4 = 0 THEN 'Medium'
                    WHEN n % 4 = 1 THEN 'High'
                    WHEN n % 4 = 2 THEN 'High'
                    ELSE 'Critical'
                END

            WHEN IncidentType = 'Lost Device' THEN
                CASE
                    WHEN n % 3 = 0 THEN 'Low'
                    WHEN n % 3 = 1 THEN 'Medium'
                    ELSE 'High'
                END

            WHEN IncidentType = 'Suspicious Network Activity' THEN
                CASE
                    WHEN n % 3 = 0 THEN 'Low'
                    WHEN n % 3 = 1 THEN 'Medium'
                    ELSE 'High'
                END

            WHEN IncidentType = 'Antivirus Detection' THEN
                CASE
                    WHEN n % 4 = 0 THEN 'Low'
                    ELSE 'Medium'
                END

            ELSE
                CASE
                    WHEN n % 3 = 0 THEN 'Low'
                    WHEN n % 3 = 1 THEN 'Medium'
                    ELSE 'High'
                END

        END AS Severity
    FROM IncidentDevices
),

-- INCIDENT DATES

IncidentDates AS (
    SELECT
        n,
        EmployeeID,
        DeviceID,
        IncidentType,
        Severity,

        DATEADD(
            DAY,
            -((n * 23) % 730),
            CAST(GETDATE() AS DATE)
        ) AS ReportedDate
    FROM IncidentSeverity
),

-- STATUS AND RESOLVED DATES

IncidentStatus AS (
    SELECT
        n,
        EmployeeID,
        DeviceID,
        IncidentType,
        Severity,
        ReportedDate,

        CASE

            WHEN Severity = 'Critical' THEN
                CASE
                    WHEN n % 10 < 2 THEN 'Closed'
                    WHEN n % 10 < 7 THEN 'In Progress'
                    ELSE 'Open'
                END

            WHEN Severity = 'High' THEN
                CASE
                    WHEN n % 10 < 5 THEN 'Closed'
                    WHEN n % 10 < 8 THEN 'In Progress'
                    ELSE 'Open'
                END

            WHEN Severity = 'Medium' THEN
                CASE
                    WHEN n % 10 < 8 THEN 'Closed'
                    WHEN n % 10 < 9 THEN 'In Progress'
                    ELSE 'Open'
                END

            ELSE
                CASE
                    WHEN n % 10 < 9 THEN 'Closed'
                    ELSE 'Open'
                END
        END AS Status
    FROM IncidentDates
),


FinalIncidents AS (
    SELECT
        n,
        EmployeeID,
        DeviceID,
        IncidentType,
        Severity,
        Status,
        ReportedDate,

        CASE
            WHEN Status = 'Closed' THEN
                DATEADD(
                    DAY,
                    ((n * 7) % 30) + 1,
                    ReportedDate
                )
            ELSE NULL
        END AS ResolvedDate
    FROM IncidentStatus
)

-- INSERT

INSERT INTO Incidents (
    EmployeeID,
    DeviceID,
    IncidentType,
    Severity,
    Status,
    ReportedDate,
    ResolvedDate
)
SELECT
    EmployeeID,
    DeviceID,
    IncidentType,
    Severity,
    Status,
    ReportedDate,
    ResolvedDate
FROM FinalIncidents;
GO