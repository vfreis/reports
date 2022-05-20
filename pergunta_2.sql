-------------------------------------------------------------------
-- 2. Qual foi o ticket médio e média de unidades vendidas
-- para cada categoria de produto (L1) no ano de 2015?
-------------------------------------------------------------------

use shopee

declare @ano_ini as date
declare @ano_fim as date


set @ano_ini = '2015' -- if necessary you change year range here.
set @ano_fim = '2015' -- and here


DROP TABLE IF EXISTS #temp_shopee_2

SELECT 
	  raw.category
	  ,year(raw.order_date) as year
	  ,gmv
	  ,raw.units
	  ,category.category_L1
INTO 
	#temp_shopee_2 
FROM 
	[shopee].[dbo].[raw_data] raw
JOIN 
	dim_category category
on
	raw.category = category.category_id	
WHERE
	year(order_date) between year(@ano_ini) and year(@ano_fim)

-------------------------------------------------------------------
-------------------------------------------------------------------

select 
	category_L1
	,format(sum(gmv) / sum(units), 'C', 'pt-br') average_ticket
	,round(avg(units), 2) average_units

from 
	#temp_shopee_2
group by 
	category_L1
