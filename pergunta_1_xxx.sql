-------------------------------------------------------------------
-- 1. Quantos pedidos foram realizados anualmente entre 2014 e 2017? 
-- E quantos destes foram realizados pelo cliente "AA-10375"?
-------------------------------------------------------------------

declare @ano_ini as date
declare @ano_fim as date
declare @customer as nvarchar(255)
set @customer = 'AA-10375' -- if necessary, change specified customer here

set @ano_ini = '2014' -- if necessary you change year range here.
set @ano_fim = '2017' -- and here

select 
	year(order_date) as year
	,count(distinct order_id) as orders
	,sum( case 
			when customer_id = @customer then 1 
			else 0 end) as specified_customer
from 
	[shopee].[dbo].[raw_data]
where
	year(order_date) between year(@ano_ini) and year(@ano_fim)
group by
	year(order_date)
order by
	year(order_date)

