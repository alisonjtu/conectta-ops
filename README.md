# ConecttaOps - Dashboard de Manutenção (Garagem 2)

## Arquitetura
- **ERP:** Oracle Globus (Leitura).
- **ETL e Orquestração:** n8n (Queries via `oracledb`, escrita via PostgreSQL).
- **Base de Dados Local:** PostgreSQL 16 (Tabelas otimizadas para leitura rápida).
- **Frontend:** HTML5, TailwindCSS, Vanilla JS (Servido via Nginx).

## Tabelas no PostgreSQL (Atuais)
- `man_revisoes`: Controlo dos 97 autocarros ativos da Garagem 2 (codigo_veiculo, prefixo, planos e km).
