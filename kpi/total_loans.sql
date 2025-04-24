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