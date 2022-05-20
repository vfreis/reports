-------------------------------------------------------------------
-- 1. Quantos pedidos foram realizados anualmente entre 2014 e 2017? 
-- E quantos destes foram realizados pelo cliente "AA-10375"?
-------------------------------------------------------------------

use shopee

declare @ano_ini as date
declare @ano_fim as date
declare @customer as nvarchar(255)
set @customer = 'AA-10375' -- if necessary, change specified customer here

set @ano_ini = '2014' -- if necessary you change year range here.
set @ano_fim = '2017' -- and here


DROP TABLE IF EXISTS #temp_shopee_1

SELECT 
	  [order_id] as [order_id]
      ,[order_date] as [order_date]
      ,[customer_id] as [customer_id]
	  ,case 
			when customer_id = @customer then (order_id + customer_id)
			else NULL end as specified_customer  
INTO 
	#temp_shopee_1
FROM 
	[shopee].[dbo].[raw_data]
WHERE
	year(order_date) between year(@ano_ini) and year(@ano_fim)

-------------------------------------------------------------------
-------------------------------------------------------------------

select 
	year(order_date) as year
	,count(distinct order_id) as orders
	,count(distinct specified_customer) as specified_customer
FROM 
	#temp_shopee_1
group by
	year(order_date)
order by
	year(order_date)