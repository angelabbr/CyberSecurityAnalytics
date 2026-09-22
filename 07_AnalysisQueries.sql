USE CyberSecurityAnalytics
GO

/* 1 - BASIC QUERIES */

-- Query 1: How many employees does the company have?

SELECT
	COUNT(EmployeeID) AS TotalEmployees
FROM Employees;

-- Query 2: How many devices are registered in the company?

SELECT
	COUNT(DeviceID) AS TotalDevicesRegistered
FROM Devices;

-- Query 3: How many security incidents have been reported?

SELECT
	COUNT(IncidentID) AS TotalIncidentsReported
FROM Incidents;

-- Query 4: How many vulnerabilities have been detected?

SELECT
	COUNT(VulnerabilityID) AS TotalVulnerabilitiesDetected
FROM Vulnerabilities;


/* 2 - AGGREGATION */

-- Query 5: How many employees work in each department?

SELECT
	d.DepartmentName,
	COUNT(e.EmployeeID) AS TotalEmployees
FROM Departments AS d
LEFT JOIN Employees AS e
	ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName;

-- Query 6: How many devices exist for each device type?

SELECT
	DeviceType,
	COUNT(DeviceID) AS TotalDevices
FROM Devices
GROUP BY DeviceType;

-- Query 7: Which operating system is the most commonly used?

SELECT TOP (1) WITH TIES
	OperatingSystem,
	COUNT(DeviceID) AS TotalDevices
FROM Devices
GROUP BY OperatingSystem
ORDER BY TotalDevices DESC;

-- Query 8: Which incident type occurs most frequently?

SELECT TOP (1) WITH TIES
	IncidentType,
	COUNT(IncidentID) AS TotalIncidents
FROM Incidents
GROUP BY IncidentType
ORDER BY TotalIncidents DESC;

-- Query 9: How many incidents are currently open?

SELECT
	COUNT(IncidentID) AS TotalOpenIncidents
FROM Incidents
WHERE Status = 'Open';

-- Query 10: Which department has experienced the highest number of security incidents?

SELECT TOP (1) WITH TIES
	d.DepartmentName,
	COUNT(i.IncidentID) AS TotalIncidents
FROM Incidents AS i
INNER JOIN Employees AS e
	ON i.EmployeeID = e.EmployeeID
INNER JOIN Departments AS d
	ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName
ORDER BY TotalIncidents DESC;

/* 3 - JOINS & MULTI-TABLE ANALYSIS */

-- Query 11: Which employees have been assigned more than one device?

SELECT
	d.EmployeeID,
	e.FirstName,
	e.LastName,
	COUNT(d.DeviceID) AS TotalDevices
FROM Devices AS d
INNER JOIN Employees AS e
	ON d.EmployeeID = e.EmployeeID
GROUP BY 
	d.EmployeeID,
	e.FirstName,
	e.LastName
HAVING COUNT(d.DeviceID) > 1
ORDER BY TotalDevices DESC;

-- Query 12: Which department has the highest number of critical incidents?

SELECT TOP (1) WITH TIES
	d.DepartmentName,
	COUNT(i.IncidentID) AS CriticalIncidents
FROM Incidents AS i
INNER JOIN Employees AS e
	ON i.EmployeeID = e.EmployeeID
INNER JOIN Departments AS d
	ON e.DepartmentID = d.DepartmentID
WHERE i.Severity = 'Critical'
GROUP BY d.DepartmentName
ORDER BY CriticalIncidents DESC;

-- Query 13: What is the average number of security incidents per device in each department?

/* Devices per department */

WITH DevicesPerDepartment AS (
	SELECT
		d.DepartmentID,
		d.DepartmentName,
		COUNT(dev.DeviceID) AS TotalDevices
	FROM Departments AS d
	INNER JOIN Employees AS e
		ON d.DepartmentID = e.DepartmentID
	INNER JOIN Devices AS dev
		ON e.EmployeeID = dev.EmployeeID
	GROUP BY
		d.DepartmentID,
		d.DepartmentName
),

/* Incidents Per Department */

IncidentsPerDepartment AS (
	SELECT
		d.DepartmentID,
		d.DepartmentName,
		COUNT(i.IncidentID) AS TotalIncidents
	FROM Departments AS d
	INNER JOIN Employees AS e
		ON d.DepartmentID = e.DepartmentID
	INNER JOIN Incidents AS i
		ON e.EmployeeID = i.EmployeeID
	GROUP BY
		d.DepartmentID,
		d.DepartmentName
)

SELECT
	dpd.DepartmentName,
	dpd.TotalDevices,
	ipd.TotalIncidents,
	CAST(ipd.TotalIncidents * 1.0 / dpd.TotalDevices AS DECIMAL(10,2)) AS AvgIncidentsPerDevice
FROM DevicesPerDepartment AS dpd
INNER JOIN IncidentsPerDepartment AS ipd
	ON dpd.DepartmentID = ipd.DepartmentID
ORDER BY AvgIncidentsPerDevice DESC;

-- Query 14: Which operating system has the highest number of detected vulnerabilities?

SELECT TOP (1) WITH TIES
	d.OperatingSystem,
	COUNT(v.VulnerabilityID) AS TotalVulnerabilities
FROM Devices AS d
INNER JOIN Vulnerabilities AS v
	ON d.DeviceID = v.DeviceID
GROUP BY d.OperatingSystem
ORDER BY TotalVulnerabilities DESC;

-- Query 15: Which employees have devices with critical vulnerabilities that are still pending?

SELECT
	e.FirstName,
	e.LastName,
	d.DeviceID,
	d.DeviceType,
	v.VulnerabilityType,
	v.DetectedDate
FROM Employees AS e
INNER JOIN Devices AS d
	ON e.EmployeeID = d.EmployeeID
INNER JOIN Vulnerabilities AS v
	ON d.DeviceID = v.DeviceID
WHERE
	v.RiskLevel = 'Critical' AND v.PatchStatus = 'Pending'
ORDER BY v.DetectedDate ASC;

/* 4 - ADVANCED FILTERING & CALCULATIONS */

-- Query 16: How should incidents be categorized based on their resolution time?

WITH ResolutionTimes AS (
	SELECT
		IncidentID,
		EmployeeID,
		Severity,
		ReportedDate,
		ResolvedDate,
		DATEDIFF(DAY, ReportedDate, ResolvedDate) AS ResolutionDays
	FROM Incidents
	WHERE Status = 'Closed'
)
SELECT
	IncidentID,
	EmployeeID,
	Severity,
	ReportedDate,
	ResolvedDate,
	ResolutionDays,
CASE
	WHEN ResolutionDays <= 3 THEN '0-3 Days'
	WHEN ResolutionDays <= 7 THEN '4-7 Days'
	WHEN ResolutionDays <= 14 THEN '8-14 Days'
	ELSE '15+ Days'
END AS ResolutionCategory
FROM ResolutionTimes
ORDER BY ResolutionDays;

-- Query 17: What percentage of vulnerabilities have been patched for each risk level?

WITH PatchSummary AS (
	SELECT
		RiskLevel,
		COUNT(VulnerabilityID) AS TotalVulnerabilities,
		SUM(
			CASE
				WHEN PatchStatus = 'Patched' THEN 1
				ELSE 0
			END
			) AS PatchedVulnerabilities
	FROM Vulnerabilities
	GROUP BY RiskLevel
)

SELECT
	RiskLevel,
	TotalVulnerabilities,
	PatchedVulnerabilities,
	CAST(
		PatchedVulnerabilities * 100.0 / TotalVulnerabilities
		AS DECIMAL(10,2)
	) AS PatchRatePercent
FROM PatchSummary
ORDER BY PatchRatePercent DESC;

/* 5 - ADVANCED ANALYSIS & WINDOW FUNCTIONS */

--  Query 18: How does each department's vulnerability patch rate compare with the company-wide patch rate?

WITH PatchRatePerDepartment AS (
	SELECT
		d.DepartmentName,
		COUNT(v.VulnerabilityID) AS TotalVulnerabilities,
		SUM(
			CASE
				WHEN v.PatchStatus = 'Patched' THEN 1
				ELSE 0
			END
		) AS PatchedVulnerabilities
	FROM Departments AS d
	LEFT JOIN Employees AS e
		ON d.DepartmentID = e.DepartmentID
	LEFT JOIN Devices AS dv
		ON e.EmployeeID = dv.EmployeeID
	LEFT JOIN Vulnerabilities AS v
		ON dv.DeviceID = v.DeviceID
	GROUP BY
		d.DepartmentName
)

SELECT
	DepartmentName,
	TotalVulnerabilities,
	PatchedVulnerabilities,
	DepartmentPatchRate,
	CompanyPatchRate,
	DepartmentPatchRate - CompanyPatchRate AS DifferenceFromCompanyRate
FROM (
	SELECT
		DepartmentName,
		TotalVulnerabilities,
		PatchedVulnerabilities,
		CAST(
			PatchedVulnerabilities * 100.0 / TotalVulnerabilities
			AS DECIMAL(10,2)
		) AS DepartmentPatchRate,
		CAST(
			SUM(PatchedVulnerabilities) OVER() * 100.0 /
			SUM(TotalVulnerabilities) OVER()
			AS DECIMAL (10,2)
		) AS CompanyPatchRate
	FROM PatchRatePerDepartment
) AS PatchRates
ORDER BY DifferenceFromCompanyRate DESC;

-- Query 19: How do departments rank based on the number of detected vulnerabilities?

WITH VulnerabilitiesByDepartment AS (
	SELECT
		d.DepartmentName,
		COUNT(v.VulnerabilityID) AS TotalVulnerabilities
	FROM Departments AS d
	INNER JOIN Employees AS e
		ON d.DepartmentID = e.DepartmentID
	INNER JOIN Devices AS dv
		ON e.EmployeeID = dv.EmployeeID
	INNER JOIN Vulnerabilities AS v
		ON dv.DeviceID = v.DeviceID
	GROUP BY d.DepartmentName
)

SELECT
	DepartmentName,
	TotalVulnerabilities,
	RANK() OVER(ORDER BY TotalVulnerabilities DESC) AS VulnerabilityRank
FROM VulnerabilitiesByDepartment
ORDER BY VulnerabilityRank;

-- Query 20: How has the number of reported security incidents changed over time compared with the previous month?

WITH IncidentsPerMonth AS (
	SELECT
		YEAR(ReportedDate) AS Year,
		MONTH(ReportedDate) AS MonthNumber,
		DATENAME(Month, ReportedDate) AS Month,
		COUNT(IncidentID) AS TotalIncidents
	FROM Incidents
	GROUP BY
		YEAR(ReportedDate),
		MONTH(ReportedDate),
		DATENAME(Month, ReportedDate)
)

SELECT
	Year,
	Month,
	TotalIncidents,
	LAG(TotalIncidents) OVER(ORDER BY Year, MonthNumber) AS PreviousMonth,
	TotalIncidents - LAG(TotalIncidents) OVER(ORDER BY Year, MonthNumber) AS IncidentChange
FROM IncidentsPerMonth
ORDER BY Year, MonthNumber;