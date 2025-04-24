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

