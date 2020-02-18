sp_addlinkedsrvlogin kdb04 , 'false' , 'dev' , 'dev' , 'password'

sp_droplinkedsrvlogin kdb04 , Null


sp_droplinkedsrvlogin [kdev-db01] , 'dev'
sp_dropremotelogin [kdev-db01] , 'dev' , 'dev'


-- kdev-db01 :- 10.23.40.102
-- kprod-db06 :- 10.23.20.107
sp_addlinkedserver [10.23.20.102] , N'SQL Server'
sp_addlinkedsrvlogin [10.23.20.102] , 'false' , 'dev' , 'dev'

sp_droplinkedsrvlogin [10.23.20.107] , Null
sp_dropserver [10.23.20.107]

select * from [10.23.40.102].medmascarden.dbo.patient


-- Correnct Syntax.
sp_addlinkedserver [10.23.20.107] , N'SQL Server'
sp_addlinkedsrvlogin [10.23.20.107] , 'false' , Null , 'dev' , 'password'

sp_droplinkedsrvlogin [10.23.20.107] , Null
sp_dropserver [10.23.20.107]

