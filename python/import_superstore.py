import csv
from datetime import datetime
import mysql.connector
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent.parent
csv_file = PROJECT_ROOT / "data" / "superstore.csv"

connection = mysql.connector.connect(
    host="localhost",
    port=3306,
    user="root",
    password=input("Enter your MySQL root password: "),
    database="ecommerce_analytics"
)

cursor = connection.cursor()

columns = [
    "row_id", "order_id", "order_date", "ship_date",
    "ship_mode", "customer_id", "customer_name", "segment",
    "country_region", "city", "state_province", "postal_code",
    "region", "product_id", "category", "sub_category",
    "product_name", "sales", "quantity", "discount", "profit"
]

column_sql = """
`row_id` INT,
`order_id` VARCHAR(30),
`order_date` DATE,
`ship_date` DATE,
`ship_mode` VARCHAR(30),
`customer_id` VARCHAR(30),
`customer_name` VARCHAR(100),
`segment` VARCHAR(30),
`country_region` VARCHAR(60),
`city` VARCHAR(100),
`state_province` VARCHAR(100),
`postal_code` VARCHAR(20),
`region` VARCHAR(30),
`product_id` VARCHAR(30),
`category` VARCHAR(50),
`sub_category` VARCHAR(50),
`product_name` TEXT,
`sales` DECIMAL(12,2),
`quantity` INT,
`discount` DECIMAL(6,4),
`profit` DECIMAL(12,2)
"""

cursor.execute("""
CREATE TABLE IF NOT EXISTS superstore (
""" + column_sql + ")")

insert_sql = (
    "INSERT INTO superstore (" +
    ", ".join(f"`{c}`" for c in columns) +
    ") VALUES (" + ", ".join(["%s"] * len(columns)) + ")"
)

with open(csv_file, "r", encoding="utf-8-sig", newline="") as file:
    reader = csv.DictReader(file)
    batch = []

    for row in reader:
        values = [row[original] for original in reader.fieldnames]

        values[2] = datetime.strptime(
            values[2], "%d-%m-%Y"
        ).date()
        values[3] = datetime.strptime(
            values[3], "%d-%m-%Y"
        ).date()

        values[11] = values[11] or None
        values[17] = float(values[17])
        values[18] = int(values[18])
        values[19] = float(values[19])
        values[20] = float(values[20])

        batch.append(tuple(values))

        if len(batch) >= 500:
            cursor.executemany(insert_sql, batch)
            connection.commit()
            batch.clear()

    if batch:
        cursor.executemany(insert_sql, batch)
        connection.commit()

cursor.execute("SELECT COUNT(*) FROM superstore")
print("Rows imported:", cursor.fetchone()[0])

cursor.close()
connection.close()
print("Import complete!")