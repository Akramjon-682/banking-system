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