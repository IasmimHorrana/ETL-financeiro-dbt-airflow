## Projeto de ETL Financeiro com dbt + airflow

Este projeto tem como objetivo construir um pipeline de ETL para coletar dados financeiros da [API Brapi](https://brapi.dev/), armazená-los em um banco de dados PostgreSQL e, em seguida, transformá-los usando a ferramenta dbt para análise.

## Etapas do Projeto

### 1. Extração e Carga (Setup)

Nesta fase inicial, o foco é na coleta de dados e na preparação do ambiente.

* **Extração da API Brapi:** O script `main.py` faz requisições à API para obter cotações de um conjunto predefinido de ativos e os salva em um arquivo CSV.

* **Ambiente de Banco de Dados:** O arquivo `docker-compose.yaml` define e orquestra os serviços do banco de dados, incluindo uma instância do **PostgreSQL** e uma ferramenta de gerenciamento como o **PGAdmin**. Isso permite que o ambiente seja configurado de forma isolada, facilitando a portabilidade e a replicação.

* **Carregamento no PostgreSQL:** O script `load_postgres.py` se conecta ao banco de dados PostgreSQL e carrega os dados do arquivo CSV para a tabela `cotacoes`, dentro do schema `brapi_raw`. Essa etapa garante que os dados brutos estejam prontos para a próxima fase.

### 2. Modelagem (dbt)

Esta etapa se concentra na transformação dos dados brutos em modelos prontos para análise.

* **Inicialização do dbt:** O comando `dbt init` é usado para configurar a estrutura de um projeto dbt. Ele cria os diretórios e arquivos necessários para que os modelos de transformação de dados possam ser desenvolvidos. O dbt se conectará ao banco de dados PostgreSQL para ler os dados do schema `brapi_raw` e criar novas tabelas e visões para o data warehouse.

### 3. Orquestração (Airflow)

Esta etapa, a ser implementada futuramente, tem como objetivo automatizar o fluxo de trabalho.

* **Automação do Pipeline:** O **Apache Airflow** será usado para agendar e monitorar a execução das etapas de extração, carregamento e transformação de dados, garantindo que o pipeline seja executado de forma consistente e em horários predefinidos.

## (⌛ Projeto em andamento ... )