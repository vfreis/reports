SELECT

Mailing
,COUNT(DISTINCT [COD ATENDIMENTO]) AS ALO
,COUNT(DISTINCT (CASE WHEN [STATUS DO ATENDIMENTO] = 'VENDA' THEN TELEFONE_1 END)) AS VENDAS
,CAST(COUNT(DISTINCT (CASE WHEN [STATUS DO ATENDIMENTO] = 'VENDA' THEN [COD ATENDIMENTO] END))AS FLOAT)/
COUNT(DISTINCT [COD ATENDIMENTO])AS CONVERS?O

FROM [SVSPODB01].[DBM_BASE].[dbo].[TB_HISTORICO_HMB_CLARO_MIGRACAO]
WHERE DATA_HORA_INICIO_ATENDIMENTO BETWEEN '2020-20-07 09:00:00' and '2020-20-07 23:00' 
GROUP BY Mailing
ORDER BY CAST(COUNT(DISTINCT (CASE WHEN [STATUS DO ATENDIMENTO] = 'VENDA' THEN [COD ATENDIMENTO] END))AS FLOAT)/
COUNT(DISTINCT [COD ATENDIMENTO]) desc