## Análise de Tickets de Suporte Help Desk 2024

Projeto de análise de dados com foco em **eficiência operacional** e **melhoria contínua** no atendimento técnico. Utiliza SQL (MySQL) para explorar um dataset de 200 chamados de suporte registrados ao longo de 2024, identificando padrões, gargalos e oportunidades de melhoria no processo de atendimento.


## Objetivo

Simular o trabalho de um analista de suporte e implementação que precisa responder perguntas de negócio a partir dos dados de atendimento:

- Quais tipos de chamado geram mais retrabalho?
- Quais clientes e segmentos têm pior satisfação?
- O time está cumprindo o SLA por prioridade?
- Como está a performance individual dos analistas?
- Qual é a tendência mensal de volume de chamados?



## Estrutura do Projeto

```
analise-tickets-suporte/
├── tickets.csv              # Dataset com 200 registros de chamados
├── analise_tickets.sql      # Queries de análise organizadas por tema
├── dashboard_tickets.pbix   # Dashboard Power BI (visualizações)
└── README.md                # Documentação do projeto
```

---

## Dicionário de Dados

| Coluna | Tipo | Descrição |
|---|---|---|
| `id_ticket` | VARCHAR | Identificador único do chamado |
| `data_abertura` | DATE | Data de abertura do ticket |
| `data_fechamento` | DATE | Data de encerramento do ticket |
| `cliente` | VARCHAR | Nome do cliente |
| `segmento` | VARCHAR | Segmento de mercado do cliente |
| `sistema` | VARCHAR | Sistema relacionado ao chamado (ERP, CRM, PDV) |
| `tipo_chamado` | VARCHAR | Categoria: Dúvida de uso, Erro no sistema, Falha de integração, Configuração |
| `prioridade` | VARCHAR | Nível: Baixa, Média, Alta, Crítica |
| `status` | VARCHAR | Situação atual do ticket |
| `analista` | VARCHAR | Analista responsável pelo atendimento |
| `tempo_resolucao_horas` | INT | Tempo total para resolução (em horas) |
| `satisfacao_cliente` | INT | Nota do cliente de 1 a 5 |
| `reaberto` | VARCHAR | Indica se o ticket foi reaberto (Sim/Não) |

---

##  Análises Realizadas

### 1. Visão Geral
- Total de tickets e distribuição por status

### 2. Tipo de Chamado e Prioridade
- Volume por tipo com tempo médio de resolução e satisfação
- Comparação de SLA entre níveis de prioridade

### 3. Cumprimento de SLA
Critérios definidos:
| Prioridade | SLA definido |
|---|---|
| Crítica | ≤ 48 horas |
| Alta | ≤ 72 horas |
| Média | ≤ 120 horas |
| Baixa | Sem restrição |

### 4. Reincidência e Qualidade
- Taxa de reabertura geral e por tipo de chamado
- Correlação entre reabertura e satisfação do cliente

### 5. Performance dos Analistas
- Volume atendido, tempo médio e satisfação por analista

### 6. Segmento e Clientes
- Segmentos com maior volume de chamados críticos
- Clientes com satisfação abaixo da meta (< 4)

### 7. Tendência Mensal
- Evolução do volume, tempo e satisfação ao longo dos meses

---

## Dashboard Power BI

O dashboard foi construído com base nas queries SQL e apresenta:

- **KPIs principais**: total de tickets, taxa de SLA, satisfação média e taxa de reabertura
- **Gráfico de barras**: volume por tipo de chamado
- **Gráfico de linhas**: tendência mensal de chamados
- **Tabela de analistas**: performance individual comparada
- **Mapa de calor**: segmento × prioridade

---

## Tecnologias Utilizadas

![MySQL](https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white)
![Power BI](https://img.shields.io/badge/PowerBI-F2C811?style=for-the-badge&logo=Power%20BI&logoColor=black)
![CSV](https://img.shields.io/badge/CSV-Data-green?style=for-the-badge)

---

##  Principais Insights

- **Falhas de integração** têm o maior tempo médio de resolução e a maior taxa de reabertura — ponto crítico para treinamento da equipe
- **Chamados críticos** da Construtora Beta e TechParts Ltda concentram os maiores desvios de SLA
- Tickets **reabertos** têm satisfação média significativamente menor, reforçando a importância da resolução na primeira chamada (FCR)
- A **tendência mensal** mostra aumento de volume no 2º semestre, sugerindo sazonalidade no suporte

---

##  Autora

**Juliana** | Estudante de Análise e Desenvolvimento de Sistemas — UNDB  
[LinkedIn](#) • [GitHub](#)
