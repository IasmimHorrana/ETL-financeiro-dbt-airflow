WITH source AS (
  SELECT * FROM {{ source('brapi_raw', 'cotacoes') }}
),

renomeado_e_tipado AS (

  SELECT
      -- Chave
      symbol AS ticker,
      
      -- Informações da empresa
      shortName AS nome_curto_empresa,

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
      regularMarketTime AS horario_cotacao,
      data_coleta AS data_coleta_etl

  FROM source

)

SELECT * FROM renomeado_e_tipado

