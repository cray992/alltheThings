/* This table maps what EditionSets are allowed/possible by PartnerID */
-- Partner => EditionSetsAllowed
-- 1.) Kareo => 'Kareo Origional', 'Kareo', 'Trial', 'Kareo Flex'
-- 2.) Quest => 'Quest'
-- 3.) Practice Fusion => 'Kareo Partners', 'Partner Flex'
-- 4.) WebPT => 'Kareo Partners', 'Partner Flex'
-- 5.) Modernizing Medicine => 'Kareo Partners', 'Partner Flex'
-- 6.) nextEMR  => 'Kareo Partners', 'Partner Flex'
-- 7.) MD-IT => 'Kareo Partners', 'Partner Flex'
-- 8.) MIE => 'Kareo Partners', 'Partner Flex'
-- 9.) Kareo RCM => 'Kareo Origional', 'Kareo', 'Trial', 'Kareo Flex'
--10.) BackChart => 'Kareo Partners', 'Partner Flex'


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EditionSetPartner]') AND type in (N'U'))
BEGIN
	DROP TABLE EditionSetPartner
END

CREATE TABLE [dbo].[EditionSetPartner](
	[EditionSetPartnerID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[PartnerID] [int] NOT NULL,
	[EditionSetID] [int] NOT NULL,
) ON [PRIMARY]

GO

-- Partners
DECLARE @Kareo_PartnerID INT
DECLARE @Quest_PartnerID INT
DECLARE @WebPT_PartnerID INT
DECLARE @PF_PartnerID INT
DECLARE @ModMedicine_PartnerID INT
DECLARE @nextEMR_PartnerID INT
DECLARE @MDIT_PartnerID INT
DECLARE @MIE_PartnerID INT
DECLARE @KareoRCM_PartnerID INT
DECLARE @BackChart_PartnerID INT

-- Edition Sets
DECLARE @KareoOrig_EditionSet INT
DECLARE @Quest_EditionSet INT
DECLARE @KareoPartners_EditionSet INT
DECLARE @Kareo_EditionSet INT
DECLARE @Trial_EditionSet INT
DECLARE @KareoFlex_EditionSet INT
DECLARE @PartnerFlex_EditionSet INT


SET @Kareo_PartnerID = 			(SELECT PartnerID FROM Partner WHERE Name = 'Kareo')
SET @Quest_PartnerID = 			(SELECT PartnerID FROM Partner WHERE Name = 'Quest')
SET @WebPT_PartnerID = 			(SELECT PartnerID FROM Partner WHERE Name = 'WebPT')
SET @PF_PartnerID = 			(SELECT PartnerID FROM Partner WHERE Name = 'Practice Fusion')
SET @ModMedicine_PartnerID = 	(SELECT PartnerID FROM Partner WHERE Name = 'Modernizing Medicine')
SET @nextEMR_PartnerID = 		(SELECT PartnerID FROM Partner WHERE Name = 'nextEMR')
SET @MDIT_PartnerID = 			(SELECT PartnerID FROM Partner WHERE Name = 'MD-IT')
SET @MIE_PartnerID = 			(SELECT PartnerID FROM Partner WHERE Name = 'MIE')
SET @KareoRCM_PartnerID = 		(SELECT PartnerID FROM Partner WHERE Name = 'Kareo RCM')
SET @BackChart_PartnerID = 		(SELECT PartnerID FROM Partner WHERE Name = 'BackChart')

SET @KareoOrig_EditionSet =		(SELECT EditionSetID FROM EditionSet WHERE Description = 'Kareo Original')
SET @Quest_EditionSet =			(SELECT EditionSetID FROM EditionSet WHERE Description = 'Quest')
SET @KareoPartners_EditionSet =	(SELECT EditionSetID FROM EditionSet WHERE Description = 'Kareo Partners')
SET @Kareo_EditionSet =			(SELECT EditionSetID FROM EditionSet WHERE Description = 'Kareo')
SET @Trial_EditionSet =			(SELECT EditionSetID FROM EditionSet WHERE Description = 'Trial')
SET @KareoFlex_EditionSet =		(SELECT EditionSetID FROM EditionSet WHERE Description = 'Kareo Flex')
SET @PartnerFlex_EditionSet =	(SELECT EditionSetID FROM EditionSet WHERE Description = 'Partner Flex')

-----------------------------------------------------------------
	-- 1.) Kareo => 'Kareo Origional', 'Kareo', 'Trial', 'Kareo Flex'
-----------------------------------------------------------------
INSERT INTO dbo.EditionSetPartner
        ( PartnerID, EditionSetID )
VALUES  ( @Kareo_PartnerID, -- PartnerID - int
          @KareoOrig_EditionSet  -- EditionSetID - int
          )
	  
INSERT INTO dbo.EditionSetPartner
        ( PartnerID, EditionSetID )
VALUES  ( @Kareo_PartnerID, -- PartnerID - int
          @Kareo_EditionSet  -- EditionSetID - int
          )
		  
INSERT INTO dbo.EditionSetPartner
        ( PartnerID, EditionSetID )
VALUES  ( @Kareo_PartnerID, -- PartnerID - int
          @KareoFlex_EditionSet  -- EditionSetID - int
          )
		  
INSERT INTO dbo.EditionSetPartner
        ( PartnerID, EditionSetID )
VALUES  ( @Kareo_PartnerID, -- PartnerID - int
          @Trial_EditionSet  -- EditionSetID - int
          )
-----------------------------------------------------------------
-- 2.) Quest => 'Quest'
-----------------------------------------------------------------
INSERT INTO dbo.EditionSetPartner
        ( PartnerID, EditionSetID )
VALUES  ( @Quest_PartnerID, -- PartnerID - int
          @Quest_EditionSet  -- EditionSetID - int
          )
		  
-----------------------------------------------------------------
-- 3.) Practice Fusion => 'Kareo Partners', 'Partner Flex'
-----------------------------------------------------------------
INSERT INTO dbo.EditionSetPartner
        ( PartnerID, EditionSetID )
VALUES  ( @PF_PartnerID, -- PartnerID - int
          @KareoPartners_EditionSet  -- EditionSetID - int
          )
		  
INSERT INTO dbo.EditionSetPartner
        ( PartnerID, EditionSetID )
VALUES  ( @PF_PartnerID, -- PartnerID - int
          @PartnerFlex_EditionSet  -- EditionSetID - int
          )
		  
INSERT INTO dbo.EditionSetPartner
        ( PartnerID, EditionSetID )
VALUES  ( @PF_PartnerID, -- PartnerID - int
          @KareoOrig_EditionSet  -- EditionSetID - int
          )
-----------------------------------------------------------------
-- 4.) WebPT => 'Kareo Partners', 'Partner Flex'
-----------------------------------------------------------------
INSERT INTO dbo.EditionSetPartner
        ( PartnerID, EditionSetID )
VALUES  ( @WebPT_PartnerID, -- PartnerID - int
          @KareoPartners_EditionSet  -- EditionSetID - int
          )
		  
INSERT INTO dbo.EditionSetPartner
        ( PartnerID, EditionSetID )
VALUES  ( @WebPT_PartnerID, -- PartnerID - int
          @PartnerFlex_EditionSet  -- EditionSetID - int
          )

INSERT INTO dbo.EditionSetPartner
        ( PartnerID, EditionSetID )
VALUES  ( @WebPT_PartnerID, -- PartnerID - int
          @KareoOrig_EditionSet  -- EditionSetID - int
          )
-----------------------------------------------------------------
-- 5.) Modernizing Medicine => 'Kareo Partners', 'Partner Flex'
-----------------------------------------------------------------
INSERT INTO dbo.EditionSetPartner
        ( PartnerID, EditionSetID )
VALUES  ( @ModMedicine_PartnerID, -- PartnerID - int
          @KareoPartners_EditionSet  -- EditionSetID - int
          )
		  
INSERT INTO dbo.EditionSetPartner
        ( PartnerID, EditionSetID )
VALUES  ( @ModMedicine_PartnerID, -- PartnerID - int
          @PartnerFlex_EditionSet  -- EditionSetID - int
          )
		  
INSERT INTO dbo.EditionSetPartner
        ( PartnerID, EditionSetID )
VALUES  ( @ModMedicine_PartnerID, -- PartnerID - int
          @KareoOrig_EditionSet  -- EditionSetID - int
          )
-----------------------------------------------------------------
-- 6.) nextEMR  => 'Kareo Partners', 'Partner Flex'
-----------------------------------------------------------------
INSERT INTO dbo.EditionSetPartner
        ( PartnerID, EditionSetID )
VALUES  ( @nextEMR_PartnerID, -- PartnerID - int
          @KareoPartners_EditionSet  -- EditionSetID - int
          )
		  
INSERT INTO dbo.EditionSetPartner
        ( PartnerID, EditionSetID )
VALUES  ( @nextEMR_PartnerID, -- PartnerID - int
          @PartnerFlex_EditionSet  -- EditionSetID - int
          )

INSERT INTO dbo.EditionSetPartner
        ( PartnerID, EditionSetID )
VALUES  ( @nextEMR_PartnerID, -- PartnerID - int
          @KareoOrig_EditionSet  -- EditionSetID - int
          )
		  
-----------------------------------------------------------------
-- 7.) MD-IT => 'Kareo Partners', 'Partner Flex'
-----------------------------------------------------------------
INSERT INTO dbo.EditionSetPartner
        ( PartnerID, EditionSetID )
VALUES  ( @MDIT_PartnerID, -- PartnerID - int
          @KareoPartners_EditionSet  -- EditionSetID - int
          )

INSERT INTO dbo.EditionSetPartner
        ( PartnerID, EditionSetID )
VALUES  ( @MDIT_PartnerID, -- PartnerID - int
          @PartnerFlex_EditionSet  -- EditionSetID - int
          )

INSERT INTO dbo.EditionSetPartner
        ( PartnerID, EditionSetID )
VALUES  ( @MDIT_PartnerID, -- PartnerID - int
          @KareoOrig_EditionSet  -- EditionSetID - int
          )
-----------------------------------------------------------------
-- 8.) MIE => 'Kareo Partners', 'Partner Flex'
-----------------------------------------------------------------
INSERT INTO dbo.EditionSetPartner
        ( PartnerID, EditionSetID )
VALUES  ( @MIE_PartnerID, -- PartnerID - int
          @KareoPartners_EditionSet  -- EditionSetID - int
          )
		  
INSERT INTO dbo.EditionSetPartner
        ( PartnerID, EditionSetID )
VALUES  ( @MIE_PartnerID, -- PartnerID - int
          @PartnerFlex_EditionSet  -- EditionSetID - int
          )

INSERT INTO dbo.EditionSetPartner
        ( PartnerID, EditionSetID )
VALUES  ( @MIE_PartnerID, -- PartnerID - int
          @KareoOrig_EditionSet  -- EditionSetID - int
          )
-----------------------------------------------------------------
-- 9.) Kareo RCM => 'Kareo Origional', 'Kareo', 'Trial', 'Kareo Flex'
-----------------------------------------------------------------
INSERT INTO dbo.EditionSetPartner
        ( PartnerID, EditionSetID )
VALUES  ( @KareoRCM_PartnerID, -- PartnerID - int
          @KareoOrig_EditionSet  -- EditionSetID - int
          )
	  
INSERT INTO dbo.EditionSetPartner
        ( PartnerID, EditionSetID )
VALUES  ( @KareoRCM_PartnerID, -- PartnerID - int
          @Kareo_EditionSet  -- EditionSetID - int
          )
		  
INSERT INTO dbo.EditionSetPartner
        ( PartnerID, EditionSetID )
VALUES  ( @KareoRCM_PartnerID, -- PartnerID - int
          @KareoFlex_EditionSet  -- EditionSetID - int
          )
		  
INSERT INTO dbo.EditionSetPartner
        ( PartnerID, EditionSetID )
VALUES  ( @KareoRCM_PartnerID, -- PartnerID - int
          @Trial_EditionSet  -- EditionSetID - int
          )
		  
-----------------------------------------------------------------
--10.) BackChart => 'Kareo Partners', 'Partner Flex'
-----------------------------------------------------------------
INSERT INTO dbo.EditionSetPartner
        ( PartnerID, EditionSetID )
VALUES  ( @BackChart_PartnerID, -- PartnerID - int
          @KareoPartners_EditionSet  -- EditionSetID - int
          )
		  
INSERT INTO dbo.EditionSetPartner
        ( PartnerID, EditionSetID )
VALUES  ( @BackChart_PartnerID, -- PartnerID - int
          @PartnerFlex_EditionSet  -- EditionSetID - int
          )
		  
INSERT INTO dbo.EditionSetPartner
        ( PartnerID, EditionSetID )
VALUES  ( @BackChart_PartnerID, -- PartnerID - int
          @KareoOrig_EditionSet  -- EditionSetID - int
          )