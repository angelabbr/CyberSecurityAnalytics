USE CyberSecurityAnalytics
GO

-- Insert company departments

INSERT INTO Departments (DepartmentName)
VALUES
('Audit & Assurance'),
('Tax & Legal'),
('Consulting'),
('Risk, Regulatory & Foresinc'),
('Strategy & Transactions');
GO

-- Verify inserted departments

SELECT *
FROM Departments;