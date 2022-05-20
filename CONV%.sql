SELECT
c.name
,COUNT(*) AS TOTAL_CHAMADA
,SUM(CASE WHEN DISPOSITIONID = 392 THEN 1 ELSE 0 END) AS VENDAS
,(SUM(CASE WHEN DISPOSITIONID = 392 THEN 1 ELSE 0 END) / COUNT(*)) AS CONV
from [10.0.1.239].exportdata.dbo.calldata a
 
inner join

[10.0.1.239].exportdata.dbo.configagent c

on 

a.agentid = c.agentid

where a.campaignid in (65,67, 93, 94)

and a.callstart between '2020-04-14 00:00:00' and '2020-04-14 23:00'
GROUP BY c.name