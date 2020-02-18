alter table users add ForumUserID int CONSTRAINT [DF_Users_ForumUserID] default(0) not null


alter table users add ForumAccessLimit  varchar(1) 
	CONSTRAINT [DF_Users_ForumAccessLimit] default('N') not null 
	CONSTRAINT [CK_Users_ForumAccessLimit] check (ForumAccessLimit in ('N','R','B'))

