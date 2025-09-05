{{
    config(
        materialized = 'table',
        unique_key = 'sk_ticker',
        tags = ['intermediate', 'dimension']
    )
}}

WITH cotacoes AS (
    SELECT * FROM {{ ref('stg_cotacoes') }}
)

SELECT
    -- Chave substituta (surrogate key)
    {{ dbt_utils.generate_surrogate_key(['ticker']) }} as sk_ticker,

    -- Chave
    ticker,
    
    -- Informações da empresa
    nome_empresa,
    
    -- Metadados
    current_timestamp as dbt_updated_at,
    '{{ run_started_at }}' as dbt_loaded_at

FROM cotacoes

GROUP BY ticker, nome_empresa