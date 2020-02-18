If OBJECT_ID ('usp_columns', 'P') Is Not Null
Begin
    Drop Procedure usp_columns
    Print 'usp_columns SP dropped...'
End
Go

Create Procedure usp_columns
( @TableName    Varchar(50) = Null )
As
    If IsNull( @TableName , '' ) = ''
    Begin
        RaisError( 'TableName parameter missing.' , 11 , -1 )
        Return -1
    End

    Select Object_Name( A.object_id ) As TableName
            , A.Column_ID
            , A.[Name] As ColumnName
            , B.Name As DataType
            , A.Max_Length As ColumnWidth
            , A.Precision
            , A.Scale
            , Case
              When A.Is_Identity = 1 Then 'Yes'
              Else ''
              End As IdentityColumn
            ,  Case
                When A.Is_Nullable = 1 Then 'Yes'
                When A.Is_Nullable = 0 Then 'No'
                End As Nullable
            , Case
                When D.Parent_Column_ID Is Not Null Then D.Definition
                Else ''
              End As DefaultConstraint
            , Case
                When C.Parent_Column_ID Is Not Null Then 'Yes'
                Else ''
              End As ForeignKey
            , IsNull( object_name( C.referenced_object_id ) , '' ) As ForeignKeyTable
        From sys.columns A
                Inner Join sys.types B On A.system_type_id = B.system_type_id
                Left Outer Join sys.foreign_key_columns C On C.Parent_Object_ID = A.Object_ID And A.Column_ID = C.Parent_Column_ID
                Left Outer Join sys.default_constraints D On D.Parent_Object_ID = A.Object_ID And D.Parent_Column_ID = A.Column_ID
        Where Object_Name( A.object_id ) = @TableName
                And B.Name <> 'sysname'
        Order By A.Column_ID
Go

If OBJECT_ID ('usp_columns', 'P') Is Not Null
    Print 'usp_columns SP created...'
Go
