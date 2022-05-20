select 	
a.customerid,
a.mailingname,
a.callid,
a.dispositionid,
b.description,
a.agentid,
c.name,
CONVERT(VARCHAR,a.callstart, 103 )+' '+CONVERT(VARCHAR,a.callstart, 108 ) AS 'Inicio Atendimento',
CONVERT(VARCHAR,a.callend, 103 )+' '+CONVERT(VARCHAR,a.callend, 108 ) AS 'FIM Atendimento',
a.phonenumber

 from [10.0.1.239].exportdata.dbo.calldata a

inner join

[10.0.1.239].exportdata.dbo.configdisposition b

on
a.dispositionid = b.dispositionid

inner join

[10.0.1.239].exportdata.dbo.configagent c
on 

a.agentid = c.agentid
where a.campaignid in (10, 15, 28, 48, 68, 70, 71, 72, 164)
and a.callstart between '2020-05-05 00:00:00' and '2020-05-05 23:00'
