USE CyberSecurityAnalytics;
GO

CREATE PROCEDURE GetDepartmentData
	@DepartmentName VARCHAR(50)
AS
BEGIN
	SELECT
		d.DepartmentName,
		d.DepartmentID,
		COUNT(DISTINCT e.EmployeeID) AS TotalEmployees,
		COUNT(DISTINCT dv.DeviceID) AS TotalDevices,
		COUNT(DISTINCT i.IncidentID) AS TotalIncidents,
		COUNT(DISTINCT
			CASE
				WHEN i.Severity = 'Critical' THEN i.IncidentID
			END
		) AS CriticalIncidents,
		COUNT(DISTINCT
			CASE
				WHEN i.Status = 'Open' THEN i.IncidentID
			END
		) AS OpenIncidents,
		COUNT(DISTINCT v.VulnerabilityID) AS TotalVulnerabilities,
		COUNT(DISTINCT
			CASE
				WHEN v.RiskLevel = 'Critical' THEN v.VulnerabilityID
			END
		) AS CriticalVulnerabilities,
		COUNT(DISTINCT
			CASE
				WHEN v.PatchStatus = 'Pending' THEN v.VulnerabilityID
			END
		) AS PendingVulnerabilities,
		CAST(
			COUNT(DISTINCT
				CASE
					WHEN v.PatchStatus = 'Patched' THEN v.VulnerabilityID
				END
			) * 100.0 /
			NULLIF(COUNT(DISTINCT v.VulnerabilityID), 0)
			AS DECIMAL(10,2)
		) AS PatchRatePercent
	FROM Departments AS d
	INNER JOIN Employees AS e
		ON d.DepartmentID = e.DepartmentID
	LEFT JOIN Devices AS dv
		ON e.EmployeeID = dv.EmployeeID
	LEFT JOIN Incidents AS i
		ON dv.DeviceID = i.DeviceID
	LEFT JOIN Vulnerabilities AS v
		ON dv.DeviceID = v.DeviceID
	WHERE d.DepartmentName = @DepartmentName
	GROUP BY
		d.DepartmentName,
		d.DepartmentID;
END;
GO

-- EXECUTIONS

EXEC GetDepartmentData
	@DepartmentName = 'Audit & Assurance';

EXEC GetDepartmentData
	@DepartmentName = 'Tax & Legal';

EXEC GetDepartmentData
	@DepartmentName = 'Consulting';

EXEC GetDepartmentData
	@DepartmentName = 'Risk, Regulatory & Forensic';

EXEC GetDepartmentData
	@DepartmentName = 'Strategy & Transactions';
