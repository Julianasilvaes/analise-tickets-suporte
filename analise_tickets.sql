-- =============================================================
-- PROJETO: Análise de Tickets de Suporte - Help Desk 2024
-- Ferramenta: MySQL
-- Descrição: Análise exploratória de chamados para identificar
--            gargalos, padrões e oportunidades de melhoria
--            operacional no atendimento técnico.
-- =============================================================


-- =============================================================
-- 1. CRIAÇÃO DA TABELA
-- =============================================================

CREATE TABLE tickets (
    id_ticket        VARCHAR(10)  PRIMARY KEY,
    data_abertura    DATE         NOT NULL,
    data_fechamento  DATE,
    cliente          VARCHAR(100) NOT NULL,
    segmento         VARCHAR(50)  NOT NULL,
    sistema          VARCHAR(50)  NOT NULL,
    tipo_chamado     VARCHAR(50)  NOT NULL,
    prioridade       VARCHAR(20)  NOT NULL,
    status           VARCHAR(20)  NOT NULL,
    analista         VARCHAR(50)  NOT NULL,
    tempo_resolucao_horas INT,
    satisfacao_cliente    INT,
    reaberto         VARCHAR(3)   NOT NULL
);


-- =============================================================
-- 2. VISÃO GERAL DO DATASET
-- =============================================================

-- Total de tickets registrados
SELECT COUNT(*) AS total_tickets FROM tickets;

-- Distribuição por status
SELECT 
    status,
    COUNT(*) AS quantidade,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM tickets), 1) AS percentual
FROM tickets
GROUP BY status
ORDER BY quantidade DESC;


-- =============================================================
-- 3. ANÁLISE POR TIPO DE CHAMADO E PRIORIDADE
-- =============================================================

-- Volume de tickets por tipo
SELECT 
    tipo_chamado,
    COUNT(*) AS total,
    ROUND(AVG(tempo_resolucao_horas), 1) AS media_horas_resolucao,
    ROUND(AVG(satisfacao_cliente), 2) AS media_satisfacao
FROM tickets
GROUP BY tipo_chamado
ORDER BY total DESC;

-- Tickets por prioridade com tempo médio de resolução
SELECT 
    prioridade,
    COUNT(*) AS total,
    ROUND(AVG(tempo_resolucao_horas), 1) AS media_horas,
    MIN(tempo_resolucao_horas) AS menor_tempo,
    MAX(tempo_resolucao_horas) AS maior_tempo
FROM tickets
GROUP BY prioridade
ORDER BY 
    FIELD(prioridade, 'Crítica', 'Alta', 'Média', 'Baixa');


-- =============================================================
-- 4. ANÁLISE DE SLA E EFICIÊNCIA OPERACIONAL
-- =============================================================

-- Tickets críticos que ultrapassaram 48h de resolução (fora do SLA)
SELECT 
    id_ticket,
    cliente,
    sistema,
    tipo_chamado,
    tempo_resolucao_horas,
    satisfacao_cliente
FROM tickets
WHERE prioridade = 'Crítica'
  AND tempo_resolucao_horas > 48
ORDER BY tempo_resolucao_horas DESC;

-- Taxa de cumprimento de SLA por prioridade
-- (Crítica: ≤48h | Alta: ≤72h | Média: ≤120h | Baixa: qualquer)
SELECT 
    prioridade,
    COUNT(*) AS total,
    SUM(CASE 
        WHEN prioridade = 'Crítica' AND tempo_resolucao_horas <= 48 THEN 1
        WHEN prioridade = 'Alta'    AND tempo_resolucao_horas <= 72 THEN 1
        WHEN prioridade = 'Média'   AND tempo_resolucao_horas <= 120 THEN 1
        WHEN prioridade = 'Baixa'   THEN 1
        ELSE 0
    END) AS dentro_sla,
    ROUND(SUM(CASE 
        WHEN prioridade = 'Crítica' AND tempo_resolucao_horas <= 48 THEN 1
        WHEN prioridade = 'Alta'    AND tempo_resolucao_horas <= 72 THEN 1
        WHEN prioridade = 'Média'   AND tempo_resolucao_horas <= 120 THEN 1
        WHEN prioridade = 'Baixa'   THEN 1
        ELSE 0
    END) * 100.0 / COUNT(*), 1) AS taxa_sla_pct
FROM tickets
GROUP BY prioridade
ORDER BY FIELD(prioridade, 'Crítica', 'Alta', 'Média', 'Baixa');


-- =============================================================
-- 5. ANÁLISE DE REINCIDÊNCIA
-- =============================================================

-- Taxa geral de reabertura
SELECT 
    COUNT(*) AS total_tickets,
    SUM(CASE WHEN reaberto = 'Sim' THEN 1 ELSE 0 END) AS reabertos,
    ROUND(SUM(CASE WHEN reaberto = 'Sim' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS taxa_reabertura_pct
FROM tickets;

-- Tipos de chamado com maior taxa de reabertura
SELECT 
    tipo_chamado,
    COUNT(*) AS total,
    SUM(CASE WHEN reaberto = 'Sim' THEN 1 ELSE 0 END) AS reabertos,
    ROUND(SUM(CASE WHEN reaberto = 'Sim' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS taxa_pct
FROM tickets
GROUP BY tipo_chamado
ORDER BY taxa_pct DESC;


-- =============================================================
-- 6. ANÁLISE POR ANALISTA
-- =============================================================

-- Performance individual: volume, tempo médio e satisfação
SELECT 
    analista,
    COUNT(*) AS total_atendidos,
    ROUND(AVG(tempo_resolucao_horas), 1) AS media_horas,
    ROUND(AVG(satisfacao_cliente), 2) AS media_satisfacao,
    SUM(CASE WHEN reaberto = 'Sim' THEN 1 ELSE 0 END) AS tickets_reabertos
FROM tickets
GROUP BY analista
ORDER BY media_satisfacao DESC;


-- =============================================================
-- 7. ANÁLISE POR SEGMENTO E SISTEMA
-- =============================================================

-- Segmentos com maior volume de chamados críticos
SELECT 
    segmento,
    sistema,
    COUNT(*) AS total_chamados,
    SUM(CASE WHEN prioridade = 'Crítica' THEN 1 ELSE 0 END) AS criticos,
    ROUND(AVG(satisfacao_cliente), 2) AS media_satisfacao
FROM tickets
GROUP BY segmento, sistema
ORDER BY criticos DESC, total_chamados DESC;

-- Clientes com pior satisfação média (abaixo de 4)
SELECT 
    cliente,
    segmento,
    COUNT(*) AS total_tickets,
    ROUND(AVG(satisfacao_cliente), 2) AS media_satisfacao,
    SUM(CASE WHEN reaberto = 'Sim' THEN 1 ELSE 0 END) AS reabertos
FROM tickets
GROUP BY cliente, segmento
HAVING AVG(satisfacao_cliente) < 4
ORDER BY media_satisfacao ASC;


-- =============================================================
-- 8. TENDÊNCIA MENSAL DE CHAMADOS
-- =============================================================

-- Volume e tempo médio de resolução por mês
SELECT 
    DATE_FORMAT(data_abertura, '%Y-%m') AS mes,
    COUNT(*) AS total_tickets,
    ROUND(AVG(tempo_resolucao_horas), 1) AS media_horas_resolucao,
    ROUND(AVG(satisfacao_cliente), 2) AS media_satisfacao,
    SUM(CASE WHEN reaberto = 'Sim' THEN 1 ELSE 0 END) AS reabertos
FROM tickets
GROUP BY mes
ORDER BY mes;


-- =============================================================
-- 9. INSIGHTS PARA MELHORIA CONTÍNUA
-- =============================================================

-- Top 5 clientes com maior volume de chamados
SELECT 
    cliente,
    segmento,
    COUNT(*) AS total_tickets,
    ROUND(AVG(tempo_resolucao_horas), 1) AS media_horas,
    ROUND(AVG(satisfacao_cliente), 2) AS satisfacao_media
FROM tickets
GROUP BY cliente, segmento
ORDER BY total_tickets DESC
LIMIT 5;

-- Correlação entre reabertura e satisfação
SELECT 
    reaberto,
    COUNT(*) AS total,
    ROUND(AVG(satisfacao_cliente), 2) AS media_satisfacao,
    ROUND(AVG(tempo_resolucao_horas), 1) AS media_horas
FROM tickets
GROUP BY reaberto;
