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

