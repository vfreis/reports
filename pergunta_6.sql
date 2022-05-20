-------------------------------------------------------------------
--6. Qual foi o GMV cumulativo de 02-Jan-2017 à 08-Jan-2017?
-------------------------------------------------------------------

use shopee

declare @date_ini as date
declare @date_fim as date

set @date_ini = '2017-01-02' -- if necessary you change year range here.
set @date_fim = '2017-01-08' -- and here


DROP TABLE IF EXISTS #temp_shopee_6

SELECT 
	  left(order_date, 11) as order_date
	  ,case 
		when datepart(DW, order_date) = 1 then 'Sunday'
		when datepart(DW, order_date) = 2 then 'Monday'
		when datepart(DW, order_date) = 3 then 'Tuesday'
		when datepart(DW, order_date) = 4 then 'Wednesday'
		when datepart(DW, order_date) = 5 then 'Thursday'
		when datepart(DW, order_date) = 6 then 'Friday'
		when datepart(DW, order_date) = 7 then 'Saturday' end as 'dw'
	,sum(gmv) as gmv
into 
	#temp_shopee_6
FROM 
	[shopee].[dbo].[raw_data]
WHERE
	order_date between @date_ini and @date_fim
group by
	order_date, gmv
order by 
	left(order_date, 11) asc
-------------------------------------------------------------------
-------------------------------------------------------------------

DROP TABLE IF EXISTS #temp_shopee_6_b

SELECT
	order_date
	,dw
	,sum(gmv) as gmv
into
	#temp_shopee_6_b
from
	#temp_shopee_6
group by
	order_date, dw

-------------------------------------------------------------------
-------------------------------------------------------------------

SELECT 
	order_date
	,dw
	,format(sum(gmv) over (order by order_date asc rows between unbounded preceding and current row)
		, 'C', 'pt-br') as acumulado
FROM
	#temp_shopee_6_b
