-- FB 2383 - expanding SubmitterNumber to 10 from 7 for SF 190894
ALTER TABLE dbo.ClaimSettings
ALTER COLUMN SubmitterNumber VARCHAR(10)

