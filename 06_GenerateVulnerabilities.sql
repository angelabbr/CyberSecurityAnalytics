USE CyberSecurityAnalytics;
GO

WITH Numbers AS (
    SELECT TOP (300)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects a
    CROSS JOIN sys.all_objects b
),

BaseVulnerabilities AS (
    SELECT
        n,
        ((n * 43 - 1) % (SELECT COUNT(*) FROM Devices)) + 1 AS DeviceID
    FROM Numbers
),

VulnerabilityDetails AS (
    SELECT
        n,
        DeviceID,

        CASE
            WHEN n % 100 < 25 THEN 'Missing Security Patch'
            WHEN n % 100 < 45 THEN 'Outdated Software'
            WHEN n % 100 < 58 THEN 'Misconfiguration'
            WHEN n % 100 < 68 THEN 'Weak Encryption'
            WHEN n % 100 < 77 THEN 'Outdated Antivirus'
            WHEN n % 100 < 85 THEN 'Exposed Service'
            WHEN n % 100 < 91 THEN 'Privilege Misconfiguration'
            WHEN n % 100 < 96 THEN 'Vulnerable Application'
            WHEN n % 100 < 99 THEN 'Default Credentials'
            ELSE 'Unsupported Operating System'
        END AS VulnerabilityType
    FROM BaseVulnerabilities
),



VulnerabilityRisk AS (
    SELECT
        n,
        DeviceID,
        VulnerabilityType,

        CASE
            WHEN VulnerabilityType = 'Default Credentials' THEN
                CASE
                    WHEN n % 3 = 0 THEN 'High'
                    ELSE 'Critical'
                END

            WHEN VulnerabilityType = 'Unsupported Operating System' THEN
                CASE
                    WHEN n % 4 = 0 THEN 'High'
                    ELSE 'Critical'
                END

            WHEN VulnerabilityType = 'Weak Encryption' THEN
                CASE
                    WHEN n % 3 = 0 THEN 'Medium'
                    ELSE 'High'
                END

            WHEN VulnerabilityType = 'Privilege Misconfiguration' THEN
                CASE
                    WHEN n % 4 = 0 THEN 'Medium'
                    WHEN n % 4 = 1 THEN 'High'
                    ELSE 'Critical'
                END

            WHEN VulnerabilityType = 'Exposed Service' THEN
                CASE
                    WHEN n % 3 = 0 THEN 'Medium'
                    ELSE 'High'
                END

            WHEN VulnerabilityType = 'Missing Security Patch' THEN
                CASE
                    WHEN n % 4 = 0 THEN 'Low'
                    WHEN n % 4 = 1 THEN 'Medium'
                    ELSE 'High'
                END

            WHEN VulnerabilityType = 'Vulnerable Application' THEN
                CASE
                    WHEN n % 4 = 0 THEN 'Medium'
                    WHEN n % 4 = 1 THEN 'High'
                    ELSE 'Critical'
                END

            WHEN VulnerabilityType = 'Outdated Antivirus' THEN
                CASE
                    WHEN n % 3 = 0 THEN 'Low'
                    ELSE 'Medium'
                END

            WHEN VulnerabilityType = 'Outdated Software' THEN
                CASE
                    WHEN n % 3 = 0 THEN 'Low'
                    WHEN n % 3 = 1 THEN 'Medium'
                    ELSE 'High'
                END

            ELSE
                CASE
                    WHEN n % 3 = 0 THEN 'Low'
                    WHEN n % 3 = 1 THEN 'Medium'
                    ELSE 'High'
                END
        END AS RiskLevel
    FROM VulnerabilityDetails
),



VulnerabilityDates AS (
    SELECT
        n,
        DeviceID,
        VulnerabilityType,
        RiskLevel,

        DATEADD(
            DAY,
            -((n * 29) % 540),
            CAST(GETDATE() AS DATE)
        ) AS DetectedDate

    FROM VulnerabilityRisk
),


VulnerabilityStatus AS (
    SELECT
        n,
        DeviceID,
        VulnerabilityType,
        RiskLevel,
        DetectedDate,

        CASE
            WHEN RiskLevel = 'Critical' THEN
                CASE
                    WHEN n % 10 < 7 THEN 'Patched'
                    ELSE 'Pending'
                END

            WHEN RiskLevel = 'High' THEN
                CASE
                    WHEN n % 10 < 8 THEN 'Patched'
                    ELSE 'Pending'
                END

            WHEN RiskLevel = 'Medium' THEN
                CASE
                    WHEN n % 10 < 9 THEN 'Patched'
                    ELSE 'Pending'
                END

            ELSE
                CASE
                    WHEN n % 10 < 8 THEN 'Patched'
                    ELSE 'Pending'
                END

        END AS PatchStatus
    FROM VulnerabilityDates
),


FinalVulnerabilities AS (
    SELECT
        n,
        DeviceID,
        VulnerabilityType,
        RiskLevel,
        DetectedDate,
        PatchStatus,

        CASE
            WHEN PatchStatus = 'Patched' THEN
                DATEADD(
                    DAY,
                    ((n * 5) % 21) + 1,
                    DetectedDate
                )
            ELSE NULL
        END AS PatchedDate
    FROM VulnerabilityStatus
)

-- INSERT

INSERT INTO Vulnerabilities (
    DeviceID,
    VulnerabilityType,
    RiskLevel,
    DetectedDate,
    PatchedDate,
    PatchStatus
)
SELECT
    DeviceID,
    VulnerabilityType,
    RiskLevel,
    DetectedDate,
    PatchedDate,
    PatchStatus
FROM FinalVulnerabilities;
GO
