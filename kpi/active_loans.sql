
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