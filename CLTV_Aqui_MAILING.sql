USE MIS


SELECT * INTO #Mailing FROM PC_Claro_Aquisicao
WHERE [DT_INICIO_VIGENCIA] = '05/07/2020'

SELECT TELEFONE
		,COUNT(1) AS TENTATIVAS
		,SUM(CASE WHEN RESUL_DISC = 'ATENDIMENTO RAMAL' THEN 1 END) AS ATENDIDA
		,SUM(CASE WHEN ETAPA_ATEND = 'TRANSF_PA' THEN 1 END) AS TRANSFERIDAS
		,SUM(CASE WHEN ETAPA_ATEND = 'AGENDAMENTO' THEN 1 END) AS AGENDAMENTO
	INTO #DISCAGENS
	FROM PC_Discagem_Expert_Ativo
	WHERE MONTH(DATA) = 7
	GROUP BY TELEFONE

SELECT DISTINCT [TELEFONE DO ATENDIMENTO]
		INTO #VENDAS FROM PC_Vendas_claro
	WHERE [TIPO DE STATUS DA OFERTA] = 'ACEITE'
	
SELECT	'JULHO' AS SAFRA
		,OPERADORA
		,REGIONAL_1
		,LEFT(A.TELEFONE,2) AS DDD
		,COUNT(DISTINCT A.TELEFONE) AS TOTAL
		,COUNT(DISTINCT CASE WHEN C.TELEFONE IS NULL THEN A.TELEFONE END) AS VIRGEM
		,SUM(TENTATIVAS) AS TENTATIVAS
		,COUNT(DISTINCT CASE WHEN C.TELEFONE IS NOT NULL THEN A.TELEFONE END) AS DISCADO
		,SUM(ATENDIDA) AS ATENDIDAS
		,SUM(TRANSFERIDAS) AS TRANSFERIDAS
		,SUM(AGENDAMENTO) AS AGENDAMENTOS
		,COUNT(DISTINCT CASE WHEN D.[TELEFONE DO ATENDIMENTO] IS NOT NULL THEN A.TELEFONE END) AS VENDAS
FROM #MAILING AS A
LEFT JOIN
PC_Depara_Regional AS B
ON LEFT(A.TELEFONE,2) = B.DDD
LEFT JOIN
#DISCAGENS  AS C
ON A.TELEFONE = C.TELEFONE
LEFT JOIN
#VENDAS AS D
ON A.TELEFONE = D.[TELEFONE DO ATENDIMENTO]
GROUP BY OPERADORA
		,REGIONAL_1
		,LEFT(A.TELEFONE,2)

DROP TABLE #MAILING
DROP TABLE #DISCAGENS
DROP TABLE #VENDAS