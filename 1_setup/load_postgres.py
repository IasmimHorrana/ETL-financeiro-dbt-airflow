import psycopg2
import pandas as pd
from dotenv import load_dotenv
import os
from psycopg2.extras import execute_values

# Carregar variáveis de ambiente
load_dotenv()

DB_HOST = os.getenv("DB_HOST")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DBT_USER")
DB_PASS = os.getenv("DBT_PASSWORD")
DB_PORT = os.getenv("DB_PORT")

# Ler o CSV gerado pelo main.py
df = pd.read_csv("brapi_quotes.csv")

# Conectar ao Postgres
conn = psycopg2.connect(
    host=DB_HOST,
    dbname=DB_NAME,
    user=DB_USER,
    password=DB_PASS,
    port=DB_PORT
)
cur = conn.cursor()

# Criar schema se não existir
cur.execute("CREATE SCHEMA IF NOT EXISTS brapi_raw;")

# Criar a tabela dentro do schema
cur.execute("""
    CREATE TABLE IF NOT EXISTS brapi_raw.cotacoes (
        symbol TEXT,
        shortName TEXT,
        regularMarketPrice NUMERIC,
        regularMarketOpen NUMERIC,
        regularMarketPreviousClose NUMERIC,
        regularMarketDayHigh NUMERIC,
        regularMarketDayLow NUMERIC,
        regularMarketVolume NUMERIC,  -- Mudei para NUMERIC
        regularMarketChange NUMERIC,
        regularMarketChangePercent NUMERIC,
        regularMarketTime TIMESTAMP,
        data_coleta TIMESTAMP,
        marketCap NUMERIC,  -- Mudei para NUMERIC
        priceEarnings NUMERIC,
        earningsPerShare NUMERIC
    );
""")
conn.commit()

# Converter o DataFrame para uma lista de tuplas para inserção em massa
data_to_insert = [tuple(row) for row in df.itertuples(index=False)]

# Inserir os dados em massa
insert_query = """
    INSERT INTO brapi_raw.cotacoes (
        symbol, shortName, regularMarketPrice, regularMarketOpen,
        regularMarketPreviousClose, regularMarketDayHigh, regularMarketDayLow,
        regularMarketVolume, regularMarketChange, regularMarketChangePercent,
        regularMarketTime, data_coleta, marketCap, priceEarnings, earningsPerShare
    )
    VALUES %s
"""
execute_values(cur, insert_query, data_to_insert)
conn.commit()
cur.close()
conn.close()

print("Dados inseridos no Postgres com sucesso no schema brapi_raw!")