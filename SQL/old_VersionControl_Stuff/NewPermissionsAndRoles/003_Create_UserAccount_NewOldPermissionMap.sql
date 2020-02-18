/**************************************************/
/*Create Table UserAccount_NewOldPermissionMap    */
/**************************************************/
USE [Superbill_Shared]
GO

/****** Object:  Table [dbo].[UserAccount_NewOldPermissionMap]    Script Date: 06/27/2012 11:38:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[UserAccount_NewOldPermissionMap]') AND name = N'IX_UserAccount_NewOldPermissionMap_NewPermissionID')
DROP INDEX [IX_UserAccount_NewOldPermissionMap_NewPermissionID] ON [dbo].[UserAccount_NewOldPermissionMap] WITH ( ONLINE = OFF )
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[UserAccount_NewOldPermissionMap]') AND name = N'IX_UserAccount_NewOldPermissionMap_OldPermissionID')
DROP INDEX [IX_UserAccount_NewOldPermissionMap_OldPermissionID] ON [dbo].[UserAccount_NewOldPermissionMap] WITH ( ONLINE = OFF )
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserAccount_NewOldPermissionMap_Permissions]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserAccount_NewOldPermissionMap]'))
ALTER TABLE [dbo].[UserAccount_NewOldPermissionMap] DROP CONSTRAINT [FK_UserAccount_NewOldPermissionMap_Permissions]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserAccount_NewOldPermissionMap_UserAccount_Permissions]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserAccount_NewOldPermissionMap]'))
ALTER TABLE [dbo].[UserAccount_NewOldPermissionMap] DROP CONSTRAINT [FK_UserAccount_NewOldPermissionMap_UserAccount_Permissions]
GO

USE [Superbill_Shared]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserAccount_NewOldPermissionMap]') AND type in (N'U'))
DROP TABLE [dbo].[UserAccount_NewOldPermissionMap]
GO


CREATE TABLE [dbo].[UserAccount_NewOldPermissionMap](
	[Id] [int] IDENTITY (1,1) NOT NULL,
	[NewPermissionID] [int] NOT NULL,
	[OldPermissionID] [int] NOT NULL,
 CONSTRAINT [PK_UserAccount_NewOldPermissionMap_Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[UserAccount_NewOldPermissionMap]  WITH CHECK ADD  CONSTRAINT [FK_UserAccount_NewOldPermissionMap_Permissions] FOREIGN KEY([OldPermissionID])
REFERENCES [dbo].[Permissions] ([PermissionID])
GO

ALTER TABLE [dbo].[UserAccount_NewOldPermissionMap] CHECK CONSTRAINT [FK_UserAccount_NewOldPermissionMap_Permissions]
GO

ALTER TABLE [dbo].[UserAccount_NewOldPermissionMap]  WITH CHECK ADD  CONSTRAINT [FK_UserAccount_NewOldPermissionMap_UserAccount_Permissions] FOREIGN KEY([NewPermissionID])
REFERENCES [dbo].[UserAccount_Permissions] ([PermissionID])
GO

ALTER TABLE [dbo].[UserAccount_NewOldPermissionMap] CHECK CONSTRAINT [FK_UserAccount_NewOldPermissionMap_UserAccount_Permissions]
GO

/****** Object:  Index [IX_UserAccount_NewOldPermissionMap_NewPermissionID]    Script Date: 06/27/2012 11:53:32 ******/
CREATE NONCLUSTERED INDEX [IX_UserAccount_NewOldPermissionMap_NewPermissionID] ON [dbo].[UserAccount_NewOldPermissionMap] 
(
	[NewPermissionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

ALTER TABLE [dbo].[UserAccount_NewOldPermissionMap] ADD  CONSTRAINT [IX_UserAccount_NewOldPermissionMap_OldPermissionID] UNIQUE NONCLUSTERED 
(
	[OldPermissionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (1,369);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (2,370);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (3,162);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (4,161);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (5,463);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (6,407);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (7,343);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (7,344);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (7,345);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (7,346);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (7,348);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (7,349);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (7,453);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (7,454);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (7,484);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (8,455);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (9,456);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (10,563);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (11,533);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (12,119);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (12,128);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (12,133);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (12,412);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (12,441);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (13,123);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (13,131);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (13,136);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (13,415);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (14,121);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (14,130);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (14,135);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (14,137);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (14,414);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (15,118);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (15,120);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (15,122);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (15,124);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (15,125);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (15,126);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (15,127);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (15,129);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (15,132);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (15,134);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (15,303);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (15,411);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (15,413);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (15,416);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (15,417);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (16,581);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (17,380);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (18,383);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (19,382);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (20,379);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (20,381);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (21,458);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (22,537);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (23,457);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (24,566);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (25,218);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (25,220);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (25,224);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (26,223);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (26,485);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (27,217);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (27,222);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (27,227);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (28,219);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (28,221);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (28,225);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (29,240);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (30,238);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (30,239);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (30,520);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (31,267);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (31,272);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (31,277);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (31,282);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (31,469);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (32,270);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (32,275);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (32,280);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (32,285);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (32,473);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (33,269);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (33,274);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (33,279);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (33,284);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (33,406);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (33,470);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (34,266);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (34,268);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (34,271);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (34,273);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (34,276);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (34,278);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (34,281);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (34,283);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (34,471);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (34,472);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (35,334);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (36,462);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (37,492);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (38,491);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (39,196);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (39,353);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (40,199);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (40,352);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (41,198);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (41,351);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (42,195);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (42,197);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (42,354);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (42,355);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (43,287);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (44,290);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (45,289);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (46,286);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (46,288);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (47,500);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (48,499);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (49,368);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (50,564);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (51,460);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (52,459);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (53,521);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (53,522);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (53,524);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (53,525);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (53,526);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (53,528);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (53,529);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (53,530);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (53,531);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (53,532);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (53,541);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (53,542);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (53,553);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (53,554);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (53,578);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (53,579);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (54,556);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (55,426);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (56,427);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (57,144);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (57,146);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (57,305);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (57,557);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (58,139);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (58,145);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (58,211);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (59,143);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (60,141);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (60,442);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (61,138);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (61,140);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (61,142);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (61,210);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (61,212);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (61,336);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (62,435);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (62,438);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (63,373);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (64,432);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (65,580);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (66,538);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (67,503);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (68,502);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (69,261);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (69,308);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (69,357);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (69,446);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (70,264);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (70,265);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (70,360);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (70,361);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (70,443);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (71,263);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (71,306);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (71,309);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (71,359);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (71,444);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (72,260);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (72,262);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (72,307);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (72,356);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (72,358);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (72,445);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (72,447);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (72,450);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (72,451);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (72,452);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (73,465);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (74,449);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (75,519);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (76,157);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (77,154);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (78,155);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (79,436);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (79,437);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (80,342);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (81,247);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (81,248);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (81,249);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (81,250);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (81,251);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (81,252);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (81,253);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (81,254);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (81,255);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (81,256);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (81,257);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (81,258);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (81,259);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (81,474);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (81,475);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (81,476);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (81,477);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (81,478);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (82,408);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (83,534);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (84,536);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (85,304);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (86,113);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (86,375);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (86,385);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (86,391);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (86,486);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (86,558);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (87,117);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (87,378);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (87,389);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (87,395);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (87,561);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (88,115);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (88,377);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (88,387);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (88,393);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (88,560);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (89,112);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (89,114);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (89,185);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (89,188);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (89,374);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (89,376);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (89,384);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (89,386);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (89,388);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (89,390);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (89,392);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (89,394);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (89,424);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (89,425);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (89,466);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (89,467);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (89,468);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (89,488);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (89,489);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (89,509);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (89,559);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (89,562);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (90,372);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (91,371);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (92,494);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (93,493);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (94,410);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (95,516);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (96,495);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (97,350);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (98,168);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (99,167);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (100,166);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (101,423);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (102,226);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (103,215);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (104,216);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (105,165);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (106,164);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (107,439);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (108,430);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (109,160);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (110,464);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (111,567);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (112,229);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (112,419);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (113,232);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (113,422);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (114,231);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (114,421);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (115,228);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (115,230);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (115,418);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (115,420);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (116,234);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (117,237);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (118,236);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (119,233);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (119,235);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (120,440);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (121,429);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (122,159);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (123,158);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (124,181);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (124,243);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (124,512);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (125,186);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (125,191);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (125,403);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (125,479);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (126,189);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (126,194);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (126,214);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (126,405);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (126,483);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (126,490);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (126,577);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (127,187);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (127,193);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (127,213);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (127,245);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (127,302);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (127,402);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (127,480);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (127,487);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (128,190);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (128,192);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (128,242);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (128,244);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (128,401);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (128,404);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (128,481);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (128,482);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (129,397);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (130,400);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (131,399);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (132,396);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (132,398);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (133,335);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (134,428);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (135,163);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (136,539);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (137,183);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (138,180);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (138,182);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (138,433);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (139,206);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (140,209);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (141,208);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (142,205);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (142,207);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (142,434);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (143,170);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (144,169);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (145,448);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (146,171);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (147,431);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (148,111);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (149,535);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (150,504);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (151,508);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (152,505);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (153,506);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (153,507);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (154,550);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (154,555);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (155,551);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (156,549);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (157,548);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (157,552);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (158,501);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (159,409);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (160,515);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (161,540);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (162,461);
INSERT INTO [UserAccount_NewOldPermissionMap] ([NewPermissionID] ,[OldPermissionID])  VALUES (163,153);

GO

