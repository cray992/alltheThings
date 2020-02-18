IF NOT EXISTS(SELECT ProcedureModifierCode FROM dbo.ProcedureModifier AS PM WHERE ProcedureModifierCode='CH')

BEGIN 
INSERT INTO dbo.ProcedureModifier
        ( ProcedureModifierCode ,
          ModifierName ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          KareoLastModifiedDate
        )


VALUES('CH','0 percent impaired, limited or restricted',GETDATE(),40936,GETDATE(),40936, GETDATE())
END

IF NOT EXISTS(SELECT ProcedureModifierCode FROM dbo.ProcedureModifier AS PM WHERE ProcedureModifierCode='CI')

BEGIN 
INSERT INTO dbo.ProcedureModifier
        ( ProcedureModifierCode ,
          ModifierName ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          KareoLastModifiedDate
        )

VALUES('CI','At least 1 percent but less than 20 percent impaired, limited or restricted',GETDATE(),40936,GETDATE(),40936, GETDATE())
END
IF NOT EXISTS(SELECT ProcedureModifierCode FROM dbo.ProcedureModifier AS PM WHERE ProcedureModifierCode='CJ')

BEGIN 
INSERT INTO dbo.ProcedureModifier
        ( ProcedureModifierCode ,
          ModifierName ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          KareoLastModifiedDate
        )

VALUES('CJ','At least 20 percent but less than 40 percent impaired, limited or restricted',GETDATE(),40936,GETDATE(),40936, GETDATE())
END
IF NOT EXISTS(SELECT ProcedureModifierCode FROM dbo.ProcedureModifier AS PM WHERE ProcedureModifierCode='CK')

BEGIN 
INSERT INTO dbo.ProcedureModifier
        ( ProcedureModifierCode ,
          ModifierName ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          KareoLastModifiedDate
        )

VALUES('CK', 'At least 40 percent but less than 60 percent impaired, limited or restricted',GETDATE(),40936,GETDATE(),40936, GETDATE())
END
IF NOT EXISTS(SELECT ProcedureModifierCode FROM dbo.ProcedureModifier AS PM WHERE ProcedureModifierCode='CL')

BEGIN 
INSERT INTO dbo.ProcedureModifier
        ( ProcedureModifierCode ,
          ModifierName ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          KareoLastModifiedDate
        )

VALUES('CL','At least 60 percent but less than 80 percent impaired, limited or restricted',GETDATE(),40936,GETDATE(),40936, GETDATE())
END

IF NOT EXISTS(SELECT ProcedureModifierCode FROM dbo.ProcedureModifier AS PM WHERE ProcedureModifierCode='CM')

BEGIN 
INSERT INTO dbo.ProcedureModifier
        ( ProcedureModifierCode ,
          ModifierName ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          KareoLastModifiedDate
        )

VALUES('CM','At least 80 percent but less than 100 percent impaired, limited or restricted',GETDATE(),40936,GETDATE(),40936, GETDATE())
END

IF NOT EXISTS(SELECT ProcedureModifierCode FROM dbo.ProcedureModifier AS PM WHERE ProcedureModifierCode='CN')

BEGIN 
INSERT INTO dbo.ProcedureModifier
        ( ProcedureModifierCode ,
          ModifierName ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          KareoLastModifiedDate
        )

VALUES('CN','100 percent impaired, limited or restricted',GETDATE(),40936,GETDATE(),40936, GETDATE())
END