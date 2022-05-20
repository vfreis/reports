USE MIS

SELECT 
		MAILINGNAME
		,COUNT(DISTINCT PHONENUMBER) AS TRABALHADO
		,COUNT(1) AS TENTATIVAS
		,COUNT(DISTINCT CASE WHEN AGENTNAME IS NOT NULL THEN PHONENUMBER END) AS ALO
		,COUNT(DISTINCT CASE WHEN DISPOSITIONID IN (109,113,111,114,117,110,112,115,132) THEN PHONENUMBER END) AS EFETIVO
	FROM PC_TENTATIVAS_AQUISICAO
	WHERE MONTH(CALLSTART) = 8 AND CAMPAIGNID = 164
	GROUP BY MAILINGNAME