import requests
import pandas as pd
from datetime import datetime
from dotenv import load_dotenv
import os

load_dotenv()
token = os.getenv("BRAPI_TOKEN")

ativos = ['PETR4', 'VALE3', 'ITUB4', 'BBDC4', 'WEGE3', 
          'MGLU3', 'ABEV3', 'JBSS32', 'BBAS3', 'BOVA11']

dataframes = []

headers = {"Authorization": f"Bearer {token}"}

for ativo in ativos:
    url = f"https://brapi.dev/api/quote/{ativo}"
    r = requests.get(url, headers=headers)
    data = r.json()

    if "results" in data:
        df_temp = pd.DataFrame(data["results"])
        df_temp['data_coleta'] = datetime.now()
        dataframes.append(df_temp)
    else:
        print(f"Erro no ativo {ativo}: {data}")

# # Concatenar todos os DataFrames
df_final = pd.concat(dataframes, ignore_index=True)

# Prevenir erros de colunas ausentes
campos_desejados = [
    "symbol",
    "shortName",
    "regularMarketPrice",
    "regularMarketOpen",
    "regularMarketPreviousClose",
    "regularMarketDayHigh",
    "regularMarketDayLow",
    "regularMarketVolume",
    "regularMarketChange",
    "regularMarketChangePercent",
    "regularMarketTime",
    "data_coleta",
    "marketCap",
    "priceEarnings",
    "earningsPerShare"
]

colunas_existentes = [c for c in campos_desejados if c in df_final.columns]

# Normalizar o timestamp porque "regularMarketTime" vem em string ISO
if 'regularMarketTime' in df_final.columns:
    df_final['regularMarketTime'] = pd.to_datetime(df_final['regularMarketTime'])
df_final['data_coleta'] = pd.to_datetime(df_final['data_coleta'])

df_final[colunas_existentes].to_csv("brapi_quotes.csv", index=False, encoding="utf-8-sig")
