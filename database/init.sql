-- ==============================================================================
-- PROJETO: ConecttaOps (MVP)
-- ARQUIVO: database/init.sql
-- DESCRIÇÃO: Script DDL Otimizado para Carga Real do ERP (Oracle Globus)
-- ==============================================================================

-- 1. Criação da tabela de Cache das Ordens de Serviço (OS)
CREATE TABLE IF NOT EXISTS os_hoje_cache (
    id_os VARCHAR(50) PRIMARY KEY,           -- Ex: Número da OS no Globus
    numero_veiculo VARCHAR(20) NOT NULL,     -- Prefixo do carro
    data_abertura TIMESTAMP NOT NULL,        -- Data real da abertura no ERP
    tipo_manutencao VARCHAR(50) NOT NULL,    -- Preventiva, Corretiva, Preditiva, etc.
    descricao_defeito TEXT,                  -- Descrição detalhada do motorista/mecânico
    status_os VARCHAR(50) NOT NULL,          -- Aberta, Em Andamento, Concluída, etc.
    nivel_criticidade VARCHAR(20) NOT NULL,  -- Alta, Média, Baixa (Mapeado no n8n)
    garagem VARCHAR(100) NOT NULL,           -- Filial/Garagem
    ultima_atualizacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Removi as constraints rígidas (CHECK) para evitar que a sincronização falhe 
    -- caso o ERP crie um novo tipo de manutenção ou status no futuro. 
    -- A validação grossa deve ser tratada no workflow do n8n (ETL).
    
    -- Campos adicionais de controle de integração (Boas Práticas de Engenharia de Dados)
    origem_sistema VARCHAR(50) DEFAULT 'ERP_GLOBUS',
    data_sincronizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Índices de Performance (Cruciais para o Dashboard Real)
-- Como o painel filtra os dados por estes campos, os índices evitam "Full Table Scans"
CREATE INDEX IF NOT EXISTS idx_os_status ON os_hoje_cache(status_os);
CREATE INDEX IF NOT EXISTS idx_os_criticidade ON os_hoje_cache(nivel_criticidade);
CREATE INDEX IF NOT EXISTS idx_os_garagem ON os_hoje_cache(garagem);
CREATE INDEX IF NOT EXISTS idx_os_data_abertura ON os_hoje_cache(data_abertura);

-- 3. Trigger de Atualização Automática de Timestamp
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
   NEW.ultima_atualizacao = NOW();
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_os_hoje_cache
BEFORE UPDATE ON os_hoje_cache
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();
