--CALCULO POR HORA DE DISCAGENS x ANUNCIADORA
--PLANEJAMENTO CLARO
--17/07/2020

SELECT
DATEPART(hour, CALLSTART) AS HORA
,SUM(CASE WHEN DISPOSITIONID = 3 THEN 1 ELSE 0 END) AS ANUNCIADORA
,COUNT(*) AS TOTAL
,CAST(COUNT(CASE WHEN DISPOSITIONID = 3 THEN 1 ELSE 0 END))AS FLOAT)/
--COUNT(*))AS ANUNCIADORA
from [10.0.1.239].exportdata.dbo.calldata WITH(NOLOCK)
WHERE CallStart BETWEEN '2020-17-07 09:00:00' and '2020-17-07 23:00' 
GROUP BY DATEPART(hour, CALLSTART)