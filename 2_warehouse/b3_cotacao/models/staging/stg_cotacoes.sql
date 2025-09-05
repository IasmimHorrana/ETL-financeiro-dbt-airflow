{{
  config(
    materialized = 'view',
    tags = ['staging', 'brapi', 'cotacoes']
  )
}}

WITH source AS (
  SELECT * FROM {{ source('brapi_raw', 'cotacoes') }}
),

string_cleaning AS (
  SELECT
    -- Remove sufixos e espaços extras do nome da empresa
    TRIM(REGEXP_REPLACE(shortName, 'PN|ON|NM|EDJ|DR2|N1|PN|ON|N2|SA|EJ', '', 'gi')) AS nome_empresa_limpo,
    *
  FROM source
),

renomeado_e_tipado AS (
  SELECT
    -- Chave
    symbol AS ticker,
    
    -- Informações da empresa
    nome_empresa_limpo AS nome_empresa, 

    -- Métricas de Preço
    CAST(regularMarketPrice AS {{ dbt.type_float() }}) AS preco_atual,
    CAST(regularMarketOpen AS {{ dbt.type_float() }}) AS preco_abertura,
    CAST(regularMarketPreviousClose AS {{ dbt.type_float() }}) AS preco_fechamento_anterior,
    CAST(regularMarketDayHigh AS {{ dbt.type_float() }}) AS preco_maximo_dia,
    CAST(regularMarketDayLow AS {{ dbt.type_float() }}) AS preco_minimo_dia,
    
    -- Métricas de Volume e Variação
    CAST(regularMarketVolume AS {{ dbt.type_float() }}) AS volume_negociado_dia,
    CAST(regularMarketChange AS {{ dbt.type_float() }}) AS variacao_diaria_valor,
    CAST(regularMarketChangePercent AS {{ dbt.type_float() }}) AS variacao_diaria_percentual,
    
    -- Métricas de Mercado
    CAST(marketCap AS {{ dbt.type_float() }}) AS valor_de_mercado,
    CAST(priceEarnings AS {{ dbt.type_float() }}) AS preco_lucro,
    CAST(earningsPerShare AS {{ dbt.type_float() }}) AS lucro_por_acao,

    -- Informações de Data e Coleta
    CAST(regularMarketTime AS {{ dbt.type_timestamp() }}) AS horario_cotacao,
    CAST(data_coleta AS {{ dbt.type_timestamp() }}) AS data_coleta_etl
  
  FROM string_cleaning 
)

SELECT * FROM renomeado_e_tipado