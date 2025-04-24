from faker import Faker
import pyodbc
import random
from datetime import datetime, timedelta

fake = Faker()

conn = pyodbc.connect(
    'DRIVER={ODBC Driver 17 for SQL Server};'
    'SERVER=localhost;'
    'DATABASE=banking-system;'
    'UID=sa;'
    'PWD=Akramjon12'
)

cursor = conn.cursor()
# Ulanish muvaffaqiyatli bo'lsa, bu xabarni chiqaradi

print("Ulanish muvaffaqiyatli bo'ldi!")

# 1. Customers

for _ in range(1001):
    cleaned_phone_number = '+1-240-612-9713x1619'
    cursor.execute("""
        INSERT INTO Customers (FullName, DOB, Email, PhoneNumber, Address, NationalID, TaxID, EmploymentStatus, AnnualIncome)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    """, fake.name(), fake.date_of_birth(minimum_age=18, maximum_age=75), fake.email(), cleaned_phone_number,
       fake.address().replace('\n', ', '), fake.ssn(), fake.uuid4(), random.choice(['Employed', 'Unemployed', 'Self-Employed']),
       round(random.uniform(5000, 150000), 2))

# 2. Branches
for _ in range(10):
    cleaned_phone_number = '+1-240-612-9713x1622'
    cursor.execute("""
        INSERT INTO Branches (BranchName, Address, City, State, Country, ContactNumber)
        VALUES (?, ?, ?, ?, ?, ?)
    """, fake.company(), fake.address().replace('\n', ', '), fake.city(), fake.state(), fake.country(), cleaned_phone_number)

# Agar BranchID mavjud bo'lmasa, uni qo'shish
cursor.execute("INSERT INTO Branches (BranchID, BranchName) VALUES (?, ?)", branch_id, 'New Branch')
conn.commit()

# Keyin, `Employees` jadvaliga INSERT qilish
cursor.execute("INSERT INTO Employees (BranchID, Name, PhoneNumber) VALUES (?, ?, ?)", branch_id, 'John Doe', '123-456-7890')
conn.commit()




# 3. Employees
for _ in range(100):
    cursor.execute("""
        INSERT INTO Employees (BranchID, FullName, Position, Department, Salary, HireDate, Status)
        VALUES (?, ?, ?, ?, ?, ?, ?)
    """, random.randint(1, 10), fake.name(), fake.job(), fake.bs(), round(random.uniform(20000, 80000), 2),
       fake.date_between(start_date='-10y', end_date='today'), random.choice(['Active', 'Inactive']))

# 4. Accounts
for _ in range(1000):
    cursor.execute("""
        INSERT INTO Accounts (CustomerID, AccountType, Balance, Currency, Status, BranchID, CreatedDate)
        VALUES (?, ?, ?, ?, ?, ?, ?)
    """, random.randint(1, 1000), random.choice(['Checking', 'Savings']), round(random.uniform(100, 100000), 2),
       'USD', random.choice(['Active', 'Closed']), random.randint(1, 10), fake.date_this_decade())

# 5. Transactions
for _ in range(5000):
    cursor.execute("""
        INSERT INTO Transactions (AccountID, TransactionType, Amount, Currency, Date, Status, ReferenceNo)
        VALUES (?, ?, ?, ?, ?, ?, ?)
    """, random.randint(1, 1000), random.choice(['Deposit', 'Withdrawal', 'Transfer']),
       round(random.uniform(10, 5000), 2), 'USD', fake.date_time_this_year(), random.choice(['Completed', 'Failed']), fake.uuid4())

# 6. CreditCards
for _ in range(500):
    cursor.execute("""
        INSERT INTO CreditCards (CustomerID, CardNumber, CardType, CVV, ExpiryDate, Limit, Status)
        VALUES (?, ?, ?, ?, ?, ?, ?)
    """, random.randint(1, 1000), fake.credit_card_number(), random.choice(['Visa', 'MasterCard']),
       fake.credit_card_security_code(), fake.date_between(start_date='today', end_date='+4y'),
       round(random.uniform(1000, 20000), 2), random.choice(['Active', 'Blocked']))

# 7. CreditCardTransactions
for _ in range(1000):
    cursor.execute("""
        INSERT INTO CreditCardTransactions (CardID, Merchant, Amount, Currency, Date, Status)
        VALUES (?, ?, ?, ?, ?, ?)
    """, random.randint(1, 500), fake.company(), round(random.uniform(5, 2000), 2), 'USD',
       fake.date_time_this_year(), random.choice(['Approved', 'Declined']))

# 8. OnlineBankingUsers
for _ in range(800):
    cursor.execute("""
        INSERT INTO OnlineBankingUsers (CustomerID, Username, PasswordHash, LastLogin)
        VALUES (?, ?, ?, ?)
    """, random.randint(1, 1000), fake.user_name(), fake.sha256(), fake.date_time_this_year())

# 9. BillPayments
for _ in range(1000):
    cursor.execute("""
        INSERT INTO BillPayments (CustomerID, BillerName, Amount, Date, Status)
        VALUES (?, ?, ?, ?, ?)
    """, random.randint(1, 1000), fake.company(), round(random.uniform(20, 300), 2),
       fake.date_time_this_year(), random.choice(['Paid', 'Failed']))

# 10. MobileBankingTransactions
for _ in range(1000):
    cursor.execute("""
        INSERT INTO MobileBankingTransactions (CustomerID, DeviceID, AppVersion, TransactionType, Amount, Date)
        VALUES (?, ?, ?, ?, ?, ?)
    """, random.randint(1, 1000), fake.uuid4(), f"{random.randint(1, 5)}.{random.randint(0, 9)}",
       random.choice(['Transfer', 'TopUp', 'Bill']), round(random.uniform(10, 500), 2), fake.date_time_this_year())

# 11. Loans
for _ in range(500):
    start = fake.date_between(start_date='-5y', end_date='-1y')
    end = start + timedelta(days=random.randint(180, 1825))
    cursor.execute("""
        INSERT INTO Loans (CustomerID, LoanType, Amount, InterestRate, StartDate, EndDate, Status)
        VALUES (?, ?, ?, ?, ?, ?, ?)
    """, random.randint(1, 1000), random.choice(['Home', 'Auto', 'Personal']),
       round(random.uniform(5000, 100000), 2), round(random.uniform(1.5, 8.5), 2),
       start, end, random.choice(['Active', 'Closed']))

# 12. LoanPayments
for _ in range(1000):
    loan_id = random.randint(1, 500)
    amount = round(random.uniform(100, 3000), 2)
    cursor.execute("""
        INSERT INTO LoanPayments (LoanID, AmountPaid, PaymentDate, RemainingBalance)
        VALUES (?, ?, ?, ?)
    """, loan_id, amount, fake.date_this_year(), round(random.uniform(0, 50000), 2))

# 13. CreditScores
for cust_id in range(1, 1001):
    cursor.execute("""
        INSERT INTO CreditScores (CustomerID, CreditScore, UpdatedAt)
        VALUES (?, ?, ?)
    """, cust_id, random.randint(300, 850), fake.date_time_this_year())

# 14. DebtCollection
for _ in range(100):
    cursor.execute("""
        INSERT INTO DebtCollection (CustomerID, AmountDue, DueDate, CollectorAssigned)
        VALUES (?, ?, ?, ?)
    """, random.randint(1, 1000), round(random.uniform(100, 10000), 2), fake.future_date(), fake.name())

# 15. KYC
for _ in range(1000):
    cursor.execute("""
        INSERT INTO KYC (CustomerID, DocumentType, DocumentNumber, VerifiedBy)
        VALUES (?, ?, ?, ?)
    """, _, random.choice(['Passport', 'ID Card', 'Driver License']), fake.uuid4(), fake.name())

# 16. Notifications
for _ in range(2000):
    cursor.execute("""
        INSERT INTO Notifications (CustomerID, NotificationType, Message, Date, ReadStatus)
        VALUES (?, ?, ?, ?, ?)
    """, random.randint(1, 1000), random.choice(['Transaction', 'Security', 'Promotion']),
       fake.sentence(nb_words=6), fake.date_time_this_year(), random.choice(['Read', 'Unread']))

# 17. CustomerFeedback
for _ in range(500):
    cursor.execute("""
        INSERT INTO CustomerFeedback (CustomerID, Rating, FeedbackText, Date)
        VALUES (?, ?, ?, ?)
    """, random.randint(1, 1000), random.randint(1, 5), fake.paragraph(nb_sentences=2), fake.date_time_this_year())

# 18. AccountLimits
for acc_id in range(1, 1001):
    cursor.execute("""
        INSERT INTO AccountLimits (AccountID, DailyLimit, MonthlyLimit)
        VALUES (?, ?, ?)
    """, acc_id, round(random.uniform(1000, 10000), 2), round(random.uniform(10000, 100000), 2))

# 19. CurrencyExchangeRates
currencies = ['USD', 'EUR', 'GBP', 'JPY', 'CNY']
for _ in range(300):
    from_curr, to_curr = random.sample(currencies, 2)
    rate = round(random.uniform(0.5, 1.5), 4)
    cursor.execute("""
        INSERT INTO CurrencyExchangeRates (FromCurrency, ToCurrency, Rate, Date)
        VALUES (?, ?, ?, ?)
    """, from_curr, to_curr, rate, fake.date_this_year())

# 20. FraudAlerts
for _ in range(100):
    cursor.execute("""
        INSERT INTO FraudAlerts (CustomerID, AlertType, Description, Date, Resolved)
        VALUES (?, ?, ?, ?, ?)
    """, random.randint(1, 1000), random.choice(['Unusual Login', 'High Transaction', 'Multiple Cards']),
       fake.text(max_nb_chars=100), fake.date_time_this_year(), random.choice(['Yes', 'No']))

# 21. InvestmentAccounts
for _ in range(200):
    cursor.execute("""
        INSERT INTO InvestmentAccounts (CustomerID, AccountName, Balance, Currency, Status)
        VALUES (?, ?, ?, ?, ?)
    """, random.randint(1, 1000), fake.word().capitalize() + " Fund",
       round(random.uniform(1000, 100000), 2), 'USD', random.choice(['Active', 'Closed']))

# 22. Securities
for _ in range(500):
    cursor.execute("""
        INSERT INTO Securities (SecurityName, SecurityType, Price, Market)
        VALUES (?, ?, ?, ?)
    """, fake.company() + " Corp", random.choice(['Stock', 'Bond', 'ETF']),
       round(random.uniform(10, 1000), 2), random.choice(['NYSE', 'NASDAQ', 'LSE']))

# 23. SecurityHoldings
for _ in range(1000):
    cursor.execute("""
        INSERT INTO SecurityHoldings (InvestmentAccountID, SecurityID, Quantity)
        VALUES (?, ?, ?)
    """, random.randint(1, 200), random.randint(1, 500), round(random.uniform(1, 100), 2))

# 24. Insurance
for _ in range(300):
    cursor.execute("""
        INSERT INTO Insurance (CustomerID, PolicyNumber, InsuranceType, CoverageAmount, Status)
        VALUES (?, ?, ?, ?, ?)
    """, random.randint(1, 1000), fake.uuid4(), random.choice(['Life', 'Health', 'Car']),
       round(random.uniform(10000, 100000), 2), random.choice(['Active', 'Expired']))

# 25. InsuranceClaims
for _ in range(150):
    cursor.execute("""
        INSERT INTO InsuranceClaims (InsuranceID, ClaimAmount, ClaimDate, Status)
        VALUES (?, ?, ?, ?)
    """, random.randint(1, 300), round(random.uniform(1000, 50000), 2),
       fake.date_between(start_date='-2y', end_date='today'), random.choice(['Approved', 'Rejected', 'Pending']))

# 26. Rewards
for _ in range(800):
    cursor.execute("""
        INSERT INTO Rewards (CustomerID, Points, LastUpdated)
        VALUES (?, ?, ?)
    """, random.randint(1, 1000), random.randint(100, 10000), fake.date_time_this_year())

# 27. RewardRedemptions
for _ in range(400):
    cursor.execute("""
        INSERT INTO RewardRedemptions (RewardID, Item, PointsUsed, RedemptionDate)
        VALUES (?, ?, ?, ?)
    """, random.randint(1, 800), random.choice(['Gift Card', 'Cashback', 'Air Miles']),
       random.randint(100, 1000), fake.date_time_this_year())

# 28. PartnerMerchants
for _ in range(100):
    cursor.execute("""
        INSERT INTO PartnerMerchants (MerchantName, Industry, ContactInfo)
        VALUES (?, ?, ?)
    """, fake.company(), random.choice(['Retail', 'Travel', 'Tech', 'Food']),
       fake.phone_number() + " / " + fake.email())

# 29. MerchantOffers
for _ in range(300):
    cursor.execute("""
        INSERT INTO MerchantOffers (MerchantID, OfferDetails, ValidTill)
        VALUES (?, ?, ?)
    """, random.randint(1, 100), fake.sentence(nb_words=6), fake.date_between(start_date='today', end_date='+180d'))

# 30. AuditLogs
for _ in range(500):
    cursor.execute("""
        INSERT INTO AuditLogs (EmployeeID, Action, Timestamp, IPAddress)
        VALUES (?, ?, ?, ?)
    """, random.randint(1, 100), random.choice(['Created Account', 'Approved Loan', 'Updated Info']),
       fake.date_time_this_year(), fake.ipv4())

# Save and close connection
conn.commit()
conn.close()


