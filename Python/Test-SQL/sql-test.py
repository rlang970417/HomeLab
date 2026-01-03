#!/usr/bin/env python3
import pyodbc
import json

# Connection Settings : Target Database
with open('cfg.json') as config_file:
  data = json.load(config_file)

tgtSrv = data['database']['server']
tgtInst= data['database']['sid']
tgtPort= data['database']['port']
tgtDb  = data['database']['schema']
tgtUsr = data['database']['user']
tgtPas = data['database']['pass']

config_file.close()

# Make the DB Connection

# SQL Server 2012
#connectionString = 'DRIVER={SQL Server Native Client 11.0};SERVER='+tgtSrv+';DATABASE=master;Trusted_Connection=yes'    


# SQL Server 2019 or Greater
connectionString = (
    f"DRIVER={{ODBC Driver 18 for SQL Server}};"
    f"SERVER={tgtSrv};"
    f"DATABASE={tgtDb};"
    f"UID={tgtUsr};"
    f"PWD={tgtPas};"
    f"TrustServerCertificate=yes;"
)


conn = pyodbc.connect(connectionString, autocommit=True)

# Prepared SQL Statement
pStmt = """IF DB_ID('JUNK01') IS NOT NULL DROP DATABASE JUNK01; CREATE DATABASE JUNK01"""

cur = conn.cursor()
cur.execute(pStmt)

cur.close()
conn.close()

#
# New Database Test
#
newDb = "JUNK01"
# Make the DB Connection

# SQL Server 2012
#connectionString = 'DRIVER={SQL Server Native Client 11.0};SERVER='+tgtSrv+';DATABASE=master;Trusted_Connection=yes'    


# SQL Server 2019 or Greater
connectionString = (
    f"DRIVER={{ODBC Driver 18 for SQL Server}};"
    f"SERVER={tgtSrv};"
    f"DATABASE={tgtDb};"
    f"UID={tgtUsr};"
    f"PWD={tgtPas};"
    f"TrustServerCertificate=yes;"
)


conn = pyodbc.connect(connectionString, autocommit=True)

# Prepared SQL Statement
pStmt2 = """CREATE TABLE [JUNK01].[dbo].[Persons](fName varchar(15),lName varchar(30),person_desc varchar(1024))"""
pStmt3 = """INSERT [JUNK01].[dbo].[Persons] ([fName], [lName], [person_desc]) VALUES ('Michelle', 'Davison', 'A Classy lady')"""

cur = conn.cursor()
cur.execute(pStmt2)
cur.execute(pStmt3)
conn.commit()

cur.close()
conn.close()