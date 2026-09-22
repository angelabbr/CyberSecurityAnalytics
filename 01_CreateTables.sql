USE CyberSecurityAnalytics
GO

-- DEPARTMENTS

CREATE TABLE Departments (
	DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
	DepartmentName VARCHAR(50) NOT NULL
);
GO

-- EMPLOYEES

CREATE TABLE Employees (
	EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	Email VARCHAR(100) NOT NULL UNIQUE,
	PhoneNumber VARCHAR(20),
	DepartmentID INT NOT NULL,
	JobTitle VARCHAR(100)NOT NULL,
	HireDate DATE NOT NULL,

	FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);
GO

-- DEVICES

CREATE TABLE Devices (
	DeviceID INT IDENTITY(1,1) PRIMARY KEY,
	EmployeeID INT NOT NULL,
	DeviceType VARCHAR(20) NOT NULL,
	OperatingSystem VARCHAR(30) NOT NULL,
	AssignedDate DATE NOT NULL,
	DeviceStatus VARCHAR (20) NOT NULL,

	FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);
GO

-- INCIDENTS

CREATE TABLE Incidents (
    IncidentID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT NOT NULL,
    DeviceID INT NOT NULL,
    IncidentType VARCHAR(50) NOT NULL,
    Severity VARCHAR(20) NOT NULL,
    Status VARCHAR(20) NOT NULL,
    ReportedDate DATE NOT NULL,
    ResolvedDate DATE NULL,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (DeviceID) REFERENCES Devices(DeviceID)
);
GO

-- VULNERABILITIES

CREATE TABLE Vulnerabilities (
	VulnerabilityID INT IDENTITY(1,1) PRIMARY KEY,
	DeviceID INT NOT NULL,
	VulnerabilityType VARCHAR(100) NOT NULL,
	RiskLevel VARCHAR(20) NOT NULL,
	DetectedDate DATE NOT NULL,
	PatchedDate DATE,
	PatchStatus VARCHAR(20) NOT NULL,
	FOREIGN KEY (DeviceID) REFERENCES Devices(DeviceID)
);
GO