# --------------- RELATÓRIO HORA A HORA ------------------

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
## BUSCAR BASE DE DISCAGENS DO DIA REFERENTE
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS BASE_DISCADA;
CREATE TEMPORARY TABLE BASE_DISCADA
SELECT
instanteocorrencia AS 'DATA'
, ddddiscado AS DDD
, fonediscado AS TEL
, CODRESULTADODISCAGEM
, CASE WHEN numeroramal = 5008 THEN 'Acao_Simpl'
WHEN NUMERORAMAL = 5000 THEN 'Aquisicao'
ELSE 'ERR' END AS 'PRODUTO'
, LEFT(CALLID,INSTR(CALLID, '@')) AS CALLID
FROM resultadosdiscagem_actionline
WHERE instanteocorrencia >= '2020-07-07 16:00:00'
;
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
## CRIANDO INDEX PARA MELHORAR A QUERY
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE INDEX BASE_DISCADA_IDX ON BASE_DISCADA (CODRESULTADODISCAGEM)
;
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
## CRUZANDO COM A ST FIM PARA IDENTIFICAR O RESULTADO DO CÓDIGO DE DISCAGEM
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS BASE_DISCADA_TRAD;
CREATE TEMPORARY TABLE BASE_DISCADA_TRAD
SELECT
DATA
, DDD
, TEL
, CASE WHEN st.STF_DESC IS NULL THEN 'ANUNCIADORA' ELSE st.STF_DESC END 'RESULTADO'
, PRODUTO
, CALLID
FROM BASE_DISCADA A
LEFT JOIN st_fim st ON A.codresultadodiscagem=st.CODIGO_GENNEX
;
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
## DROP DE TABELA QUE NÃO SERÁ MAIS UTILIZADA
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE INDEX BASE_DISCADA_TRAD_IDX ON BASE_DISCADA_TRAD (CALLID);
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
## CRIANDO INDEX E CRUZANDO BASES PARA IDENTIFICAÇÃO DE FINALIZACAO NO AGV
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS BASE_FINAL;
CREATE TEMPORARY TABLE BASE_FINAL
SELECT
bd.DATA
, CONCAT(bd.ddd,bd.tel) AS TELEFONE
, bd.RESULTADO
, CASE WHEN B.hangupcausecodefim = 50 THEN 'TRANSF_PA'
WHEN B.hangupcausecodefim = 60 THEN 'DESCONHECE'
WHEN B.hangupcausecodefim = 61 THEN 'N_ACEITA_OUVIR_OP'
WHEN B.trilhafim = 1 AND B.motivofimapp = 'cliente desligou' THEN 'DESL_ETAPA_1'
WHEN B.trilhafim = 2 AND B.motivofimapp = 'cliente desligou' THEN 'DESL_ETAPA_2'
WHEN B.trilhafim IN (3,4) AND B.motivofimapp = 'cliente desligou' THEN 'DESL_ETAPA_3'
ELSE NULL END AS 'ETAPA_ATEND'
, PRODUTO
FROM BASE_DISCADA_TRAD bd
left join contatosgenbot_2020_07 B ON bd.callid = B.callid AND B.instante >= '2020-07-07 16:00:00'
;

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
## RESULTDO HORA DE AQUIIÇÃO
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
DATE_FORMAT(DATA, "%H") AS horario
, COUNT(*) AS QTDD
, SUM(CASE WHEN RESULTADO = 'ATENDIMENTO RAMAL' THEN 1 ELSE 0 END) AS 'atend_AGV'
, '' AS 'Conect'
, SUM(CASE WHEN ETAPA_ATEND =   'TRANSF_PA' THEN 1 ELSE 0 END) AS 'transferidas'
, '' AS 'Taxa_Trans'
, SUM(CASE WHEN ETAPA_ATEND IN ('DESL_ETAPA_1','DESL_ETAPA_2','DESL_ETAPA_3') THEN 1 ELSE 0 END) AS 'Desligamentos'
, '' AS '%_desl'
, SUM(CASE WHEN ETAPA_ATEND =   'DESCONHECE' THEN 1 ELSE 0 END) AS 'DESCONHECE'
, '' AS '%_desc'
, SUM(CASE WHEN ETAPA_ATEND =   'N_ACEITA_OUVIR_OP' THEN 1 ELSE 0 END) AS 'Desl_NAceita'
, '' AS '%_N_Aceia'
FROM BASE_FINAL WHERE PRODUTO = 'Aquisicao'
GROUP BY 1
;
 	#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
## RESULTDO HORA DE AÇÃO SIMPLIFICADA
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
DATE_FORMAT(DATA, "%H") AS horario
, COUNT(*) AS QTDD
, SUM(CASE WHEN RESULTADO = 'ATENDIMENTO RAMAL' THEN 1 ELSE 0 END) AS 'atend_AGV'
, '' AS 'Conect'
, SUM(CASE WHEN ETAPA_ATEND =   'TRANSF_PA' THEN 1 ELSE 0 END) AS 'transferidas'
, '' AS 'Taxa_Trans'
, SUM(CASE WHEN ETAPA_ATEND IN ('DESL_ETAPA_1','DESL_ETAPA_2','DESL_ETAPA_3') THEN 1 ELSE 0 END) AS 'Desligamentos'
, '' AS '%_desl'
, SUM(CASE WHEN ETAPA_ATEND =   'DESCONHECE' THEN 1 ELSE 0 END) AS 'DESCONHECE'
, '' AS '%_desc'
, SUM(CASE WHEN ETAPA_ATEND =   'N_ACEITA_OUVIR_OP' THEN 1 ELSE 0 END) AS 'Desl_NAceita'
, '' AS '%_N_Aceia'

FROM BASE_FINAL WHERE PRODUTO = 'Acao_Simpl'
GROUP BY 1
;
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
## RESULTDO HORA ANALITICO
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT
DATE_FORMAT(DATA, "%H") AS horario
, TELEFONE
, CASE WHEN RESULTADO = 'ATENDIMENTO RAMAL' THEN 1 ELSE 0 END AS 'atend_AGV'
, CASE WHEN ETAPA_ATEND =   'TRANSF_PA' THEN 1 ELSE 0 END AS 'transferidas'
, CASE WHEN ETAPA_ATEND IN ('DESL_ETAPA_1','DESL_ETAPA_2','DESL_ETAPA_3') THEN 1 ELSE 0 END AS 'Desligamentos'
, CASE WHEN ETAPA_ATEND =   'DESCONHECE' THEN 1 ELSE 0 END AS 'DESCONHECE'
, CASE WHEN ETAPA_ATEND =   'N_ACEITA_OUVIR_OP' THEN 1 ELSE 0 END AS 'Desl_NAceita'
FROM BASE_FINAL



