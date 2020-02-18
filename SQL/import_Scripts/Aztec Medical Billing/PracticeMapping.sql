use superbill_0622_prod
select * from Practice


--create table dbo.IMPPracticeMapping(PracticeID int not null, OldPracticeID char(3) not null)
GO

delete IMPPracticeMapping
insert into IMPPracticeMapping (PracticeID, OldPracticeID) values (2, '171')
insert into IMPPracticeMapping (PracticeID, OldPracticeID) values (3, '430')
insert into IMPPracticeMapping (PracticeID, OldPracticeID) values (4, '309')
insert into IMPPracticeMapping (PracticeID, OldPracticeID) values (5, '046')
insert into IMPPracticeMapping (PracticeID, OldPracticeID) values (6, '050')
insert into IMPPracticeMapping (PracticeID, OldPracticeID) values (7, '061')
insert into IMPPracticeMapping (PracticeID, OldPracticeID) values (8, '073')
insert into IMPPracticeMapping (PracticeID, OldPracticeID) values (10,'196')
insert into IMPPracticeMapping (PracticeID, OldPracticeID) values (11,'220')
insert into IMPPracticeMapping (PracticeID, OldPracticeID) values (12,'231')
insert into IMPPracticeMapping (PracticeID, OldPracticeID) values (13,'249')
insert into IMPPracticeMapping (PracticeID, OldPracticeID) values (14,'251')
insert into IMPPracticeMapping (PracticeID, OldPracticeID) values (15,'285')
insert into IMPPracticeMapping (PracticeID, OldPracticeID) values (16,'286')
insert into IMPPracticeMapping (PracticeID, OldPracticeID) values (18,'359')
insert into IMPPracticeMapping (PracticeID, OldPracticeID) values (19,'376')
insert into IMPPracticeMapping (PracticeID, OldPracticeID) values (20,'441')
insert into IMPPracticeMapping (PracticeID, OldPracticeID) values (21,'140')
insert into IMPPracticeMapping (PracticeID, OldPracticeID) values (22,'444')
insert into IMPPracticeMapping (PracticeID, OldPracticeID) values (23,'446')
insert into IMPPracticeMapping (PracticeID, OldPracticeID) values (24,'077')
insert into IMPPracticeMapping (PracticeID, OldPracticeID) values (25,'P21')
insert into IMPPracticeMapping (PracticeID, OldPracticeID) values (26,'247')

select * from IMPPracticeMapping