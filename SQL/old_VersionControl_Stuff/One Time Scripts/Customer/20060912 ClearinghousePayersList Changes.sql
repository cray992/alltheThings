ALTER TABLE dbo.ClearinghousePayersList

      ALTER COLUMN StateSpecific varchar(256)         -- expanding from 16, not enough for GatewayEDI list of states

GO
