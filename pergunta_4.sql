-------------------------------------------------------------------
-- 4. Qual era a distribuição (%) de gênero da 
-- base de total de clientes em Novembro de 2017? 
-------------------------------------------------------------------
declare @data_ini as date
declare @data_fim as date

set @data_ini = '2017-11-01' -- if necessary you change date range here.
set @data_fim = '2017-11-30' 

DROP TABLE IF EXISTS #temp_shopee_4

SELECT 
	datename(month, raw.order_date) as month
	,raw.order_id
	,raw.gender as id_g
	,case when gender.gender is null then 'not declared' else gender.gender end as gender_1
INTO 
	#temp_shopee_4 	
FROM 
	[shopee].[dbo].[raw_data] raw
FULL OUTER JOIN
	[dbo].[dim_gender] gender
ON
	raw.gender = gender.gender_id

WHERE
	raw.order_date between @data_ini and @data_fim

-------------------------------------------------------------------
-------------------------------------------------------------------

select
	gender_1 as gender
	,replace(cast((convert(float, count(distinct order_id)) / convert(float, 
		(select count(distinct order_id) from #temp_shopee_4))
		* 100) as decimal (10, 2)), '.', ',') + '%' as percentage
from 
	#temp_shopee_4
group by
	gender_1
order by
	replace(cast((convert(float, count(distinct order_id)) / convert(float, (select count(distinct order_id) from #temp_shopee_4))
	* 100) as decimal (10, 2)), '.', ',') desc