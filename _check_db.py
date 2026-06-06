import sqlite3, os
os.chdir(r'C:\Users\31419\WorkBuddy\2026-05-30-task-20\backend')
conn = sqlite3.connect('erp.db')
cur = conn.cursor()

with open(r'C:\Users\31419\WorkBuddy\2026-05-30-task-20\_db_result.txt', 'w', encoding='utf-8') as f:
    cur.execute("SELECT name FROM sqlite_master WHERE type='table'")
    tables = [r[0] for r in cur.fetchall()]
    f.write(f"Tables: {tables}\n\n")

    cur.execute("SELECT id, code, name FROM products")
    rows = cur.fetchall()
    f.write(f"Products: {rows}\n\n")

    cur.execute("SELECT p.code, COALESCE(i.quantity, 0) FROM products p LEFT JOIN inventory i ON i.product_id=p.id")
    rows2 = cur.fetchall()
    f.write(f"Products+Stock: {rows2}\n")

    conn.close()
    f.write("\nDone.\n")
