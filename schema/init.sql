-- SQL schema for full MSSQL Bank System (30 tables)
-- Created for Microsoft SQL Server (MSSIS compatible)

-- 1. Customers
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100),
    DOB DATE,
    Email NVARCHAR(150),
    PhoneNumber NVARCHAR(20),
    Address NVARCHAR(255),
    NationalID NVARCHAR(50),
    TaxID NVARCHAR(50),
    EmploymentStatus NVARCHAR(50),
    AnnualIncome DECIMAL(18,2),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE()
);

-- 2. Branches
CREATE TABLE Branches (
    BranchID INT PRIMARY KEY IDENTITY(1,1),
    BranchName NVARCHAR(100),
    Address NVARCHAR(255),
    City NVARCHAR(100),
    State NVARCHAR(100),
    Country NVARCHAR(100),
    ManagerID INT,  -- FK to Employees, defined later
    ContactNumber NVARCHAR(20)
);

-- 3. Employees
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    BranchID INT FOREIGN KEY REFERENCES Branches(BranchID),
    FullName NVARCHAR(100),
    Position NVARCHAR(50),
    Department NVARCHAR(100),
    Salary DECIMAL(18,2),
    HireDate DATE,
    Status NVARCHAR(20)
);

-- Update Branches now that Employees exists
ALTER TABLE Branches ADD CONSTRAINT FK_Branches_Manager FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID);

-- 4. Accounts
CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    AccountType NVARCHAR(50),
    Balance DECIMAL(18,2),
    Currency NVARCHAR(10),
    Status NVARCHAR(20),
    BranchID INT FOREIGN KEY REFERENCES Branches(BranchID),
    CreatedDate DATE
);

-- 5. Transactions
CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY IDENTITY(1,1),
    AccountID INT FOREIGN KEY REFERENCES Accounts(AccountID),
    TransactionType NVARCHAR(50),
    Amount DECIMAL(18,2),
    Currency NVARCHAR(10),
    Date DATETIME,
    Status NVARCHAR(20),
    ReferenceNo NVARCHAR(100)
);

-- 6. CreditCards
CREATE TABLE CreditCards (
    CardID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    CardNumber NVARCHAR(20),
    CardType NVARCHAR(20),
    CVV NVARCHAR(10),
    ExpiryDate DATE,
    Limit DECIMAL(18,2),
    Status NVARCHAR(20)
);

-- 7. CreditCardTransactions
CREATE TABLE CreditCardTransactions (
    TransactionID INT PRIMARY KEY IDENTITY(1,1),
    CardID INT FOREIGN KEY REFERENCES CreditCards(CardID),
    Merchant NVARCHAR(100),
    Amount DECIMAL(18,2),
    Currency NVARCHAR(10),
    Date DATETIME,
    Status NVARCHAR(20)
);

-- 8. OnlineBankingUsers
CREATE TABLE OnlineBankingUsers (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    Username NVARCHAR(100),
    PasswordHash NVARCHAR(255),
    LastLogin DATETIME
);

-- 9. BillPayments
CREATE TABLE BillPayments (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    BillerName NVARCHAR(100),
    Amount DECIMAL(18,2),
    Date DATETIME,
    Status NVARCHAR(20)
);

-- 10. MobileBankingTransactions
CREATE TABLE MobileBankingTransactions (
    TransactionID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    DeviceID NVARCHAR(100),
    AppVersion NVARCHAR(50),
    TransactionType NVARCHAR(50),
    Amount DECIMAL(18,2),
    Date DATETIME
);

-- 11. Loans
CREATE TABLE Loans (
    LoanID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    LoanType NVARCHAR(50),
    Amount DECIMAL(18,2),
    InterestRate FLOAT,
    StartDate DATE,
    EndDate DATE,
    Status NVARCHAR(20)
);

-- 12. LoanPayments
CREATE TABLE LoanPayments (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),
    LoanID INT FOREIGN KEY REFERENCES Loans(LoanID),
    AmountPaid DECIMAL(18,2),
    PaymentDate DATE,
    RemainingBalance DECIMAL(18,2)
);

-- 13. CreditScores
CREATE TABLE CreditScores (
    CustomerID INT PRIMARY KEY,
    CreditScore INT,
    UpdatedAt DATETIME,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- 14. DebtCollection
CREATE TABLE DebtCollection (
    DebtID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    AmountDue DECIMAL(18,2),
    DueDate DATE,
    CollectorAssigned NVARCHAR(100)
);

-- 15. KYC
CREATE TABLE KYC (
    KYCID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    DocumentType NVARCHAR(50),
    DocumentNumber NVARCHAR(100),
    VerifiedBy NVARCHAR(100)
);

-- 16. FraudDetection
CREATE TABLE FraudDetection (
    FraudID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    TransactionID INT,
    RiskLevel NVARCHAR(20),
    ReportedDate DATE
);

-- 17. AMLCases
CREATE TABLE AMLCases (
    CaseID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    CaseType NVARCHAR(50),
    Status NVARCHAR(20),
    InvestigatorID INT
);

-- 18. RegulatoryReports
CREATE TABLE RegulatoryReports (
    ReportID INT PRIMARY KEY IDENTITY(1,1),
    ReportType NVARCHAR(100),
    SubmissionDate DATE
);

-- 19. Departments
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY IDENTITY(1,1),
    DepartmentName NVARCHAR(100),
    ManagerID INT
);

-- 20. Salaries
CREATE TABLE Salaries (
    SalaryID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT FOREIGN KEY REFERENCES Employees(EmployeeID),
    BaseSalary DECIMAL(18,2),
    Bonus DECIMAL(18,2),
    Deductions DECIMAL(18,2),
    PaymentDate DATE
);

-- 21. EmployeeAttendance
CREATE TABLE EmployeeAttendance (
    AttendanceID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT FOREIGN KEY REFERENCES Employees(EmployeeID),
    CheckInTime DATETIME,
    CheckOutTime DATETIME,
    TotalHours FLOAT
);

-- 22. Investments
CREATE TABLE Investments (
    InvestmentID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    InvestmentType NVARCHAR(50),
    Amount DECIMAL(18,2),
    ROI FLOAT,
    MaturityDate DATE
);

-- 23. StockTradingAccounts
CREATE TABLE StockTradingAccounts (
    AccountID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    BrokerageFirm NVARCHAR(100),
    TotalInvested DECIMAL(18,2),
    CurrentValue DECIMAL(18,2)
);

-- 24. ForeignExchange
CREATE TABLE ForeignExchange (
    FXID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    CurrencyPair NVARCHAR(20),
    ExchangeRate FLOAT,
    AmountExchanged DECIMAL(18,2)
);

-- 25. InsurancePolicies
CREATE TABLE InsurancePolicies (
    PolicyID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    InsuranceType NVARCHAR(50),
    PremiumAmount DECIMAL(18,2),
    CoverageAmount DECIMAL(18,2)
);

-- 26. Claims
CREATE TABLE Claims (
    ClaimID INT PRIMARY KEY IDENTITY(1,1),
    PolicyID INT FOREIGN KEY REFERENCES InsurancePolicies(PolicyID),
    ClaimAmount DECIMAL(18,2),
    Status NVARCHAR(20),
    FiledDate DATE
);

-- 27. UserAccessLogs
CREATE TABLE UserAccessLogs (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT FOREIGN KEY REFERENCES OnlineBankingUsers(UserID),
    ActionType NVARCHAR(100),
    Timestamp DATETIME
);

-- 28. CyberSecurityIncidents
CREATE TABLE CyberSecurityIncidents (
    IncidentID INT PRIMARY KEY IDENTITY(1,1),
    AffectedSystem NVARCHAR(100),
    ReportedDate DATE,
    ResolutionStatus NVARCHAR(50)
);

-- 29. Merchants
CREATE TABLE Merchants (
    MerchantID INT PRIMARY KEY IDENTITY(1,1),
    MerchantName NVARCHAR(100),
    Industry NVARCHAR(100),
    Location NVARCHAR(255),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID)
);

-- 30. MerchantTransactions
CREATE TABLE MerchantTransactions (
    TransactionID INT PRIM ARY KEY IDENTITY(1,1),
    MerchantID INT FOREIGN KEY REFERENCES Merchants(MerchantID),
    Amount DECIMAL(18,2),
    PaymentMethod NVARCHAR(50),
    Date DATETIME
);

-- ✅ End of schema
ALTER LOGIN sa WITH PASSWORD = 'Akramjon12';
ALTER LOGIN sa ENABLE;


select * from Transactions









-- 1. 🥇 Top 3 Customers with the Highest Total Balance Across All Accounts
SELECT TOP 3 
    c.CustomerID,
    c.FullName,
    SUM(a.Balance) AS TotalBalance
FROM 
    Customers c
JOIN 
    Accounts a ON c.CustomerID = a.CustomerID
GROUP BY 
    c.CustomerID, c.FullName
ORDER BY 
    TotalBalance DESC;

-- 2. 💳 Customers Who Have More Than One Active Loan
SELECT 
    c.CustomerID,
    c.FullName,
    COUNT(l.LoanID) AS ActiveLoanCount
FROM 
    Customers c
JOIN 
    Loans l ON c.CustomerID = l.CustomerID
WHERE 
    l.Status = 'Active'
GROUP BY 
    c.CustomerID, c.FullName
HAVING 
    COUNT(l.LoanID) > 1;

-- 3. 🚨 Transactions That Were Flagged as Fraudulent
SELECT 
    f.FraudID,
    c.CustomerID,
    c.FullName,
    t.TransactionID,
    t.Amount,
    t.[Date],       -- "Date" kalit so'z, [] bilan olingan
    f.RiskLevel
FROM 
    FraudDetection AS f
INNER JOIN 
    Customers AS c ON f.CustomerID = c.CustomerID
INNER JOIN 
    Transactions AS t ON f.TransactionID = t.TransactionID
WHERE 
    f.RiskLevel = 'High'
ORDER BY 
    t.[Date] DESC;



select * from FraudDetection
select * from Customers
select * from Transactions

-- 4. 🏢 Total Loan Amount Issued Per Branch
SELECT 
    br.BranchID,
    br.BranchName,
    SUM(l.Amount) AS TotalLoanAmount
FROM 
    Loans l
JOIN 
    Customers c ON l.CustomerID = c.CustomerID
JOIN 
    Accounts a ON c.CustomerID = a.CustomerID
JOIN 
    Branches br ON a.BranchID = br.BranchID
GROUP BY 
    br.BranchID, br.BranchName;

-- 5. 💰 Customers who made multiple large transactions (above $100) within a short time frame (less than 1 hour apart)
WITH LargeTransactions AS (
    SELECT 
        t.TransactionID,
        t.AccountID,
        t.Amount,
        t.Date,
        ROW_NUMBER() OVER (PARTITION BY t.AccountID ORDER BY t.Date) AS rn
    FROM 
        Transactions t
    WHERE 
        t.Amount > 100
),-- select * from Transactions
TransactionPairs AS (
    SELECT 
        a.TransactionID AS Transaction1,
        b.TransactionID AS Transaction2,
        a.AccountID,
        DATEDIFF(MINUTE, a.Date, b.Date) AS TimeDiff
    FROM 
        LargeTransactions a
    JOIN 
        LargeTransactions b ON a.AccountID = b.AccountID AND a.rn + 1 = b.rn
    WHERE 
        DATEDIFF(MINUTE, a.Date, b.Date) <= 60
)
SELECT DISTINCT 
    c.CustomerID,
    c.FullName,
    tp.AccountID
FROM 
    TransactionPairs tp
JOIN 
    Accounts a ON tp.AccountID = a.AccountID
JOIN 
    Customers c ON a.CustomerID = c.CustomerID;

-- 6. 🌍 Customers who have made transactions from different countries within 10 minutes (potential fraud case)
WITH TransWithCountry AS (
    SELECT 
        t.TransactionID,
        t.AccountID,
        t.Date,
        t.Amount,
        b.City AS TransactionCity,
        b.Country AS TransactionCountry,
        ROW_NUMBER() OVER (PARTITION BY t.AccountID ORDER BY t.Date) AS rn
    FROM 
        Transactions t
    JOIN 
        Accounts a ON t.AccountID = a.AccountID
    JOIN 
        Branches b ON a.BranchID = b.BranchID
), --select * from Transactions
CountryChange AS (
SELECT DISTINCT
    c.CustomerID,
    c.FullName,
    t1.AccountID,
    b1.Country AS Country1,
    b2.Country AS Country2,
    DATEDIFF(MINUTE, t1.[Date], t2.[Date]) AS TimeDifference
FROM 
    Transactions t1
JOIN 
    Transactions t2 ON t1.AccountID = t2.AccountID 
                   AND t1.TransactionID < t2.TransactionID
                   AND ABS(DATEDIFF(MINUTE, t1.[Date], t2.[Date])) <= 100000
	  JOIN 
			Accounts a1 ON t1.AccountID = a1.AccountID
		JOIN 
			Accounts a2 ON t2.AccountID = a2.AccountID
		JOIN 
			Customers c ON a1.CustomerID = c.CustomerID
		JOIN 
			Branches b1 ON a1.BranchID = b1.BranchID
		JOIN 
			Branches b2 ON a2.BranchID = b2.BranchID
		WHERE 
			b1.Country <> b2.Country
)
SELECT DISTINCT 
    c.CustomerID,
    c.FullName,
    cc.AccountID,
    cc.Country1,
    cc.Country2,
    cc.TimeDifference
FROM 
    CountryChange cc
JOIN 
    Accounts a ON cc.AccountID = a.AccountID
JOIN 
    Customers c ON a.CustomerID = c.CustomerID;


