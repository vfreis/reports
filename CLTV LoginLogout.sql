set nocount on; 

select distinct agentid
		,dispositionid
		,WrapEnd into #Tentativas 
from [10.0.1.239].exportdata.dbo.calldata with(nolock) 
where campaignid IN (13,68,70,71,72,10,47,48,127,167) and WrapEnd between convert(varchar, getdate() - 3, 102) 
		and convert(varchar, getdate() + 1,102) and agentid <> 0 AND AGENTID IS NOT NULL 
		

select agentid
		,data
		,login
		,logout into #Login_Logout 
from [10.0.1.239].exportdata.dbo.AgentLoginData with(nolock) 
where data between convert(varchar, getdate() - 3, 102) and convert(varchar, getdate() + 1, 102) 


select distinct agentid
				,agentstatus
				,reason
				,startstate
				,endstate 
				,CASE WHEN campaignid IN (13, 68,70,71,72) then 'Claro Migracao' 
						WHEN campaignid IN (10,47,48,127,167) then 'Claro Aquisicao' END AS operacao 
	into #Tempos from [10.0.1.239].exportdata.dbo.agentstaterawdata with(nolock) 
where campaignid IN (13,68,70,71,72,10,47,48,127,167) and startstate between convert(varchar, getdate() - 3, 102) 
and convert(varchar, getdate() + 1, 102) 
		
SELECT A.DATA 
		,C.operacao 
		,A.USERNAME 
		,A.LOGIN 
		,A.ATENDIDAS 
		,B.[PRIMEIRO LOGIN] 
		,B.[ÚLTIMO LOGOUT] 
		,B.[TEMPO OFFLINE] 
		,A.VENDA 
		,B.[TEMPO LOGADO] 
		,C.[TEMPO PAUSA] 
		,C.[TEMPO DE CONVERSAÇÃO] 
		,CONVERT(CHAR(8), DATEADD(SECOND,C.[TEMPO DE TABULAÇÃO],0),108) AS [TEMPO DE TABULAÇÃO] 
		,CONVERT(CHAR(8), DATEADD(SECOND,C.[TEMPO DE TABULAÇÃO] / A.ATENDIDAS,0),108) AS TP_MEDIO_TAB 
		,CONVERT(CHAR(8),DATEADD(SECOND,C.[TEMPO MÉDIO OCIOSO] / A.ATENDIDAS,0),108) AS TP_MEDIO_OCIOSO 
	FROM (SELECT CONVERT(VARCHAR, a.WrapEnd , 103) as DATA 
					,b.agentid 
					,b.username 
					,b.LOGIN 
					,COUNT(*) as ATENDIDAS 
					,SUM(CASE WHEN dispositionid IN (392,435) THEN 1 ELSE 0 END) AS VENDA 
			FROM #Tentativas as a 
			inner join [10.0.1.239].exportdata.dbo.configusers as b 
			ON a.agentid = b.agentid 
				GROUP BY CONVERT(VARCHAR, a.WrapEnd , 103) 
						,b.agentid 
						,b.UserName 
						,b.LOGIN) as a 
	INNER JOIN (SELECT CONVERT(VARCHAR, a.data, 103) AS DATA 
						,b.agentid 
						,CONVERT(VARCHAR, MIN(a.login),108) AS [PRIMEIRO LOGIN] 
						,CONVERT(VARCHAR, MAX(a.logout),108) AS [ÚLTIMO LOGOUT] 
						,CONVERT(CHAR(8),DATEADD(SECOND,DATEDIFF(SS, MIN(a.login), MAX(a.logout)) - SUM(DATEDIFF(SS, a.login, a.logout)),0),108) AS [TEMPO OFFLINE] 
						,CONVERT(CHAR(8),DATEADD(SECOND,SUM(DATEDIFF(SS, a.login, a.logout)),0),108) AS [TEMPO LOGADO] 
						FROM [10.0.1.239].exportdata.dbo.AgentLoginData as  a 
						inner join [10.0.1.239].exportdata.dbo.configusers as b 
						ON a.agentid = b.agentid 
						GROUP BY CONVERT(VARCHAR, a.data, 103) ,b.agentid) as b 
						ON a.agentid = b.agentid and a.data = b.data INNER JOIN (SELECT CONVERT(VARCHAR, a.startstate, 103) as DATA 
						,a.agentid              ,CONVERT(CHAR(8),DATEADD(SECOND,SUM(CASE WHEN a.AgentStatus = 4 then DATEDIFF(ss, a.startstate, a.endstate) else 0 end),0),108) as [TEMPO PAUSA] 
						,CONVERT(CHAR(8),DATEADD(SECOND,SUM(CASE WHEN a.AgentStatus =  2 then DATEDIFF(ss, a.startstate, a.endstate) else 0 end),0),108) as [TEMPO DE CONVERSAÇÃO] 
						,CONVERT(FLOAT,SUM(CASE WHEN a.AgentStatus = 3 then DATEDIFF(ss, a.startstate, a.endstate) else 0 end)) as [TEMPO DE TABULAÇÃO] 
						,CONVERT(FLOAT,SUM(CASE WHEN a.AgentStatus = 1 then DATEDIFF(ss, a.startstate, a.endstate) else 0 end)) as [TEMPO MÉDIO OCIOSO] 
						,a.operacao FROM #tempos as a INNER JOIN [10.0.1.239].exportdata.dbo.configusers as b ON a.agentid = b.agentid 
						GROUP BY  CONVERT(VARCHAR, a.startstate, 103) ,a.agentid, a.operacao) as c 
						ON b.agentid = c.agentid and b.data = c.data