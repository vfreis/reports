-------------------------------------------------------------------
--3. Qual foi a cidade com o maior número de produtos distintos vendidos 
--em entre Janeiro e Março de 2016?(A) E quais foram os cinco produtos mais vendidos 
--para ela no mesmo período? (B)
-------------------------------------------------------------------

declare @ano_ini as date
declare @ano_fim as date

set @ano_ini = '2016-01-01' -- if necessary you change year range here.
set @ano_fim = '2016-03-31' -- and here


DROP TABLE IF EXISTS #temp_shopee_3

SELECT 
	city
	,order_date
	,product_id
	,product_name
	,units as units
INTO 
	#temp_shopee_3 
FROM 
	[shopee].[dbo].[raw_data] raw

WHERE
	order_date between @ano_ini and @ano_fim

-------------------------------------------------------------------
-- (A)
-------------------------------------------------------------------

SELECT TOP 1
	city
	,count(distinct product_id) distinct_products
from
	#temp_shopee_3
group by 
	city
order by count(distinct product_id) desc 

-------------------------------------------------------------------
--(B)
-------------------------------------------------------------------

SELECT TOP 5
	city
	,product_name
	,sum(units) as total
FROM
	#temp_shopee_3
WHERE
	city = (SELECT TOP 1
		city
		from
			#temp_shopee_3
		group by 
			city
		order by 
			count(distinct product_id) desc )
group by 
	city, product_name
order by
	sum(units) desc
	

