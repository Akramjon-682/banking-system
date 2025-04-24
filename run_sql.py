import pyodbc
import pandas as pd

# Bazaga ulanish
conn = pyodbc.connect(
    'DRIVER={ODBC Driver 17 for SQL Server};'
    'SERVER=localhost;'
    'DATABASE=banking-system;'
    'UID=sa;'
    'PWD=Akramjon12'
)

cursor = conn.cursor()
print("✅ Bazaga ulanish muvaffaqiyatli")

# # init.sql orqali jadvallarni yaratish
# with open("schema/init.sql", "r", encoding="utf-8-sig") as file:
#     init_script = file.read()

# for query in init_script.split(";"):
#     if query.strip():
#         cursor.execute(query)
#         conn.commit()

# print("✅ Barcha jadval va ma'lumotlar yaratildi")

# KPI faylni o‘qib DataFrame chiqarish
with open("kpi/active_loans.sql", "r", encoding="utf-8-sig") as file:
    kpi_query = file.read()

df = pd.read_sql(kpi_query, conn)
print("✅ KPI so‘rovi bajarildi. Natija:")
print(df.head())

# Ulanishni yopish
conn.close()
