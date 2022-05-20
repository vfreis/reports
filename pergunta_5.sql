-------------------------------------------------------------------
--5. Qual foi o share de GMV de cada sub-categoria de produto (L2) 
-- dentro de cada categoria (L1) no ano de 2016?
-------------------------------------------------------------------

use shopee

declare @ano_ini as date
declare @ano_fim as date

set @ano_ini = '2016' -- if necessary you change year range here.
set @ano_fim = '2016' -- and here

DROP TABLE IF EXISTS #temp_shopee_5

SELECT 
	  year(raw.order_date) as year
	  ,gmv
	  ,category.category_L1
	  ,category_L2
INTO 
	#temp_shopee_5 
FROM 
	[shopee].[dbo].[raw_data] raw
JOIN 
	dim_category category
on
	raw.category = category.category_id	
WHERE
	year(order_date) between year(@ano_ini) and year(@ano_fim)

--SELECT * FROM #temp_shopee_5

-------------------------------------------------------------------
-------------------------------------------------------------------
DROP TABLE IF EXISTS #temp_shopee_5_b

SELECT 
	category_L1
	,category_L2
	,sum(gmv) as total_l2
INTO
	#temp_shopee_5_b
FROM 
	#temp_shopee_5
group by 
	category_L1, category_L2
order by
	category_L1

--SELECT * from #temp_shopee_5_b
-------------------------------------------------------------------
-------------------------------------------------------------------
DROP TABLE IF EXISTS #temp_shopee_5_c

SELECT 
	category_l1
	,sum(gmv) 'total_l1'
into
	#temp_shopee_5_c
from 
	#temp_shopee_5
group by 
	category_L1

--SELECT * FROM #temp_shopee_5_c
-------------------------------------------------------------------
-------------------------------------------------------------------
DROP TABLE IF EXISTS #temp_shopee_5_totais

SELECT 
	l2.category_L1
	,l2.category_L2
	,l1.total_l1
	,l2.total_l2
INTO
	#temp_shopee_5_totais
FROM
	#temp_shopee_5_b l2
JOIN 
	#temp_shopee_5_c l1
ON
	l2.category_L1 = l1.category_L1
-------------------------------------------------------------------
-------------------------------------------------------------------
SELECT 
	category_L1
	,category_L2
	,replace(cast((total_l2 / total_l1 * 100) as decimal(10,2)), '.', ',') + '%' as '%%%'
	
FROM 
	#temp_shopee_5_totais
ORDER BY
 category_L1, (total_l2 / total_l1 * 100) desc
	