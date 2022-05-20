SELECT
a.agentid
,COUNT(*) AS TOTAL_CHAMADA
,SUM(CASE WHEN DISPOSITIONID = 392 THEN 1 ELSE 0 END) AS VENDAS

from [10.0.1.239].exportdata.dbo.calldata a

where a.campaignid in (65,67, 93, 94)

and a.callstart between '2020-04-15 00:00:00' and '2020-04-15 23:00'
GROUP BY a.agentid
ORDER BY VENDAS desc