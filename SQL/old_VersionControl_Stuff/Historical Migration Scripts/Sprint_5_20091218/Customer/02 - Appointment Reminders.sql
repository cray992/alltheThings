-- email appintment reminders

alter table Appointment add SendAppointmentReminder bit default 0
GO

alter table Practice add AppointmentRemindersEnabled bit default 0
GO

alter table Practice add AppointmentRemindersDefault bit default 0
GO

alter table Practice add AppointmentRemindersCCList varchar(7000)
GO

update Practice set AppointmentRemindersEnabled=0, AppointmentRemindersDefault=0
update Appointment set SendAppointmentReminder = 0

alter table Practice alter column AppointmentRemindersEnabled bit not null 
GO

/*
	ALTER TABLE dbo.ServiceLocation  DROP  CONSTRAINT FK_ServiceLocation_TimeZone
	ALTER TABLE dbo.ServiceLocation DROP COLUMN TimeZoneID
	ALTER TABLE dbo.AppointmentReminderSent  DROP  CONSTRAINT FK_AppointmentReminderSent_Appointment

	drop table dbo.TimeZone
	drop table dbo.AppointmentReminderSent
*/
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'AppointmentReminderSent')
BEGIN
	CREATE TABLE dbo.AppointmentReminderSent(
		AppointmentReminderSentID int not null identity(1, 1),
		AppointmentID int not null,
		StartDate datetime not null,

		CreatedDate datetime not null,
		Timestamp timestamp not null
	)

	ALTER TABLE dbo.AppointmentReminderSent
	ADD CONSTRAINT PK_AppointmentReminderSentID PRIMARY KEY CLUSTERED ( AppointmentReminderSentID ASC )

	ALTER TABLE dbo.AppointmentReminderSent
	ADD CONSTRAINT DF_AppointmentReminderSent_CreatedDate  DEFAULT (getdate()) FOR CreatedDate
	
	ALTER TABLE dbo.AppointmentReminderSent WITH CHECK ADD  CONSTRAINT FK_AppointmentReminderSent_Appointment FOREIGN KEY(AppointmentID)
	REFERENCES dbo.Appointment (AppointmentID)
END
--------------------------------------------------------------------------------------------------------------
-- TimeZone table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'TimeZone')
BEGIN
	CREATE TABLE dbo.TimeZone(
		TimeZoneID int not null identity(1, 1),
		Name VARCHAR(64) not null,
		Description VARCHAR(1024) not null,
		StandardTimeUTCOffsetHours int not null,
		StandardTimeUTCOffsetMinutes int not null,
		DaylightSavingTimeUTCOffsetHours int not null, 
		DaylightSavingTimeUTCOffsetMinutes int not null, 
		ObservesDaylightSavingTime bit not null, 
		KareoServerTimeZone bit not null, 
		Sort int not null,

		CreatedDate datetime not null,
		Timestamp timestamp not null
	)

	ALTER TABLE dbo.TimeZone
	ADD CONSTRAINT PK_TimeZoneID PRIMARY KEY CLUSTERED ( TimeZoneID ASC )

	ALTER TABLE dbo.TimeZone
	ADD CONSTRAINT DF_TimeZone_CreatedDate  DEFAULT (getdate()) FOR CreatedDate

	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Dateline Time', '(GMT-12:00) International Date Line West', -12, 0, -12, 0, 0, 1, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Samoa Time', '(GMT-11:00) Midway Island, Samoa', -11, 0, -11, 0, 0, 2, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Hawaiian Time', '(GMT-10:00) Hawaii', -10, 0, -10, 0, 0, 3, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Alaskan Time', '(GMT-09:00) Alaska', -9, 0, -8, 0, 1, 4, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Pacific Time', '(GMT-08:00) Pacific Time (US & Canada)', -8, 0, -7, 0, 1, 5, 1)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Pacific Standard Time (Mexico)', '(GMT-08:00) Tijuana, Baja California', -8, 0, -7, 0, 1, 6, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Arizona Time', '(GMT-07:00) Arizona', -7, 0, -7, 0, 0, 7, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Mountain Standard Time (Mexico)', '(GMT-07:00) Chihuahua, La Paz, Mazatlan', -7, 0, -6, 0, 1, 8, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Mountain Time', '(GMT-07:00) Mountain Time (US & Canada)', -7, 0, -6, 0, 1, 9, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Central America Time', '(GMT-06:00) Central America', -6, 0, -6, 0, 0, 10, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Central Time', '(GMT-06:00) Central Time (US & Canada)', -6, 0, -5, 0, 1, 11, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Central Standard Time (Mexico)', '(GMT-06:00) Guadalajara, Mexico City, Monterrey', -6, 0, -5, 0, 1, 12, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Canada Central Time', '(GMT-06:00) Saskatchewan', -6, 0, -6, 0, 0, 13, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('SA Pacific Time', '(GMT-05:00) Bogota, Lima, Quito', -5, 0, -5, 0, 0, 14, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Eastern Time', '(GMT-05:00) Eastern Time (US & Canada)', -5, 0, -4, 0, 1, 15, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Indiana Time', '(GMT-05:00) Indiana (East)', -5, 0, -5, 0, 0, 16, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Paraguay Time', '(GMT-04:00) Asuncion', -4, 0, -3, 0, 1, 17, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Atlantic Time', '(GMT-04:00) Atlantic Time (Canada)', -4, 0, -3, 0, 1, 18, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('SA Western Time', '(GMT-04:00) Georgetown, La Paz, San Juan', -4, 0, -4, 0, 0, 19, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Central Brazilian Time', '(GMT-04:00) Manaus', -4, 0, -3, 0, 1, 20, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Pacific SA Time', '(GMT-04:00) Santiago', -4, 0, -3, 0, 1, 21, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Venezuela Time', '(GMT-04:30) Caracas', -4, 30, -4, 30, 0, 22, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('E. South America Time', '(GMT-03:00) Brasilia', -3, 0, -2, 0, 1, 23, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Argentina Time', '(GMT-03:00) Buenos Aires', -3, 0, -2, 0, 1, 24, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('SA Eastern Time', '(GMT-03:00) Cayenne', -3, 0, -3, 0, 0, 25, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Greenland Time', '(GMT-03:00) Greenland', -3, 0, -2, 0, 1, 26, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Montevideo Time', '(GMT-03:00) Montevideo', -3, 0, -2, 0, 1, 27, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Newfoundland Time', '(GMT-03:30) Newfoundland', -3, 30, -2, 30, 1, 28, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Mid-Atlantic Time', '(GMT-02:00) Mid-Atlantic', -2, 0, -1, 0, 1, 29, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Azores Time', '(GMT-01:00) Azores', -1, 0, 0, 0, 1, 30, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Cape Verde Time', '(GMT-01:00) Cape Verde Is.', -1, 0, -1, 0, 0, 31, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Morocco Time', '(GMT) Casablanca', 0, 0, 1, 0, 1, 32, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('UTC', '(GMT) Coordinated Universal Time', 0, 0, 0, 0, 0, 33, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('GMT Time', '(GMT) Greenwich Mean Time : Dublin, Edinburgh, Lisbon, London', 0, 0, 1, 0, 1, 34, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Greenwich Time', '(GMT) Monrovia, Reykjavik', 0, 0, 0, 0, 0, 35, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('W. Europe Time', '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna', 1, 0, 2, 0, 1, 36, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Central Europe Time', '(GMT+01:00) Belgrade, Bratislava, Budapest, Ljubljana, Prague', 1, 0, 2, 0, 1, 37, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Romance Time', '(GMT+01:00) Brussels, Copenhagen, Madrid, Paris', 1, 0, 2, 0, 1, 38, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Central European Time', '(GMT+01:00) Sarajevo, Skopje, Warsaw, Zagreb', 1, 0, 2, 0, 1, 39, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('W. Central Africa Time', '(GMT+01:00) West Central Africa', 1, 0, 1, 0, 0, 40, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Jordan Time', '(GMT+02:00) Amman', 2, 0, 3, 0, 1, 41, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('GTB Time', '(GMT+02:00) Athens, Bucharest, Istanbul', 2, 0, 3, 0, 1, 42, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Middle East Time', '(GMT+02:00) Beirut', 2, 0, 3, 0, 1, 43, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Egypt Time', '(GMT+02:00) Cairo', 2, 0, 3, 0, 1, 44, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('South Africa Time', '(GMT+02:00) Harare, Pretoria', 2, 0, 2, 0, 0, 45, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('FLE Time', '(GMT+02:00) Helsinki, Kyiv, Riga, Sofia, Tallinn, Vilnius', 2, 0, 3, 0, 1, 46, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Israel Time', '(GMT+02:00) Jerusalem', 2, 0, 3, 0, 1, 47, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('E. Europe Time', '(GMT+02:00) Minsk', 2, 0, 3, 0, 1, 48, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Namibia Time', '(GMT+02:00) Windhoek', 2, 0, 3, 0, 1, 49, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Arabic Time', '(GMT+03:00) Baghdad', 3, 0, 4, 0, 1, 50, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Arab Time', '(GMT+03:00) Kuwait, Riyadh', 3, 0, 3, 0, 0, 51, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Russian Time', '(GMT+03:00) Moscow, St. Petersburg, Volgograd', 3, 0, 4, 0, 1, 52, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('E. Africa Time', '(GMT+03:00) Nairobi', 3, 0, 3, 0, 0, 53, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Iran Time', '(GMT+03:30) Tehran', 3, 30, 4, 30, 1, 54, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Arabian Time', '(GMT+04:00) Abu Dhabi, Muscat', 4, 0, 4, 0, 0, 55, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Azerbaijan Time', '(GMT+04:00) Baku', 4, 0, 5, 0, 1, 56, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Mauritius Time', '(GMT+04:00) Port Louis', 4, 0, 5, 0, 1, 57, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Georgian Time', '(GMT+04:00) Tbilisi', 4, 0, 4, 0, 0, 58, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Caucasus Time', '(GMT+04:00) Yerevan', 4, 0, 5, 0, 1, 59, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Afghanistan Time', '(GMT+04:30) Kabul', 4, 30, 4, 30, 0, 60, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Ekaterinburg Time', '(GMT+05:00) Ekaterinburg', 5, 0, 6, 0, 1, 61, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Pakistan Time', '(GMT+05:00) Islamabad, Karachi', 5, 0, 6, 0, 1, 62, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('West Asia Time', '(GMT+05:00) Tashkent', 5, 0, 5, 0, 0, 63, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('India Time', '(GMT+05:30) Chennai, Kolkata, Mumbai, New Delhi', 5, 30, 5, 30, 0, 64, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Sri Lanka Time', '(GMT+05:30) Sri Jayawardenepura', 5, 30, 5, 30, 0, 65, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Nepal Time', '(GMT+05:45) Kathmandu', 5, 45, 5, 45, 0, 66, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Central Asia Time', '(GMT+06:00) Astana, Dhaka', 6, 0, 6, 0, 0, 67, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('N. Central Asia Time', '(GMT+06:00) Novosibirsk', 6, 0, 7, 0, 1, 68, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Myanmar Time', '(GMT+06:30) Yangon (Rangoon)', 6, 30, 6, 30, 0, 69, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('SE Asia Time', '(GMT+07:00) Bangkok, Hanoi, Jakarta', 7, 0, 7, 0, 0, 70, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('North Asia Time', '(GMT+07:00) Krasnoyarsk', 7, 0, 8, 0, 1, 71, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('China Time', '(GMT+08:00) Beijing, Chongqing, Hong Kong, Urumqi', 8, 0, 8, 0, 0, 72, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('North Asia East Time', '(GMT+08:00) Irkutsk', 8, 0, 9, 0, 1, 73, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Singapore Time', '(GMT+08:00) Kuala Lumpur, Singapore', 8, 0, 8, 0, 0, 74, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('W. Australia Time', '(GMT+08:00) Perth', 8, 0, 9, 0, 1, 75, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Taipei Time', '(GMT+08:00) Taipei', 8, 0, 8, 0, 0, 76, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Ulaanbaatar Time', '(GMT+08:00) Ulaanbaatar', 8, 0, 8, 0, 0, 77, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Tokyo Time', '(GMT+09:00) Osaka, Sapporo, Tokyo', 9, 0, 9, 0, 0, 78, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Korea Time', '(GMT+09:00) Seoul', 9, 0, 9, 0, 0, 79, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Yakutsk Time', '(GMT+09:00) Yakutsk', 9, 0, 10, 0, 1, 80, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Cen. Australia Time', '(GMT+09:30) Adelaide', 9, 30, 10, 30, 1, 81, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('AUS Central Time', '(GMT+09:30) Darwin', 9, 30, 9, 30, 0, 82, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('E. Australia Time', '(GMT+10:00) Brisbane', 10, 0, 10, 0, 0, 83, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('AUS Eastern Time', '(GMT+10:00) Canberra, Melbourne, Sydney', 10, 0, 11, 0, 1, 84, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('West Pacific Time', '(GMT+10:00) Guam, Port Moresby', 10, 0, 10, 0, 0, 85, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Tasmania Time', '(GMT+10:00) Hobart', 10, 0, 11, 0, 1, 86, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Vladivostok Time', '(GMT+10:00) Vladivostok', 10, 0, 11, 0, 1, 87, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Central Pacific Time', '(GMT+11:00) Magadan, Solomon Is., New Caledonia', 11, 0, 11, 0, 0, 88, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('New Zealand Time', '(GMT+12:00) Auckland, Wellington', 12, 0, 13, 0, 1, 89, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Fiji Time', '(GMT+12:00) Fiji, Marshall Is.', 12, 0, 12, 0, 0, 90, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Kamchatka Time', '(GMT+12:00) Petropavlovsk-Kamchatsky', 12, 0, 13, 0, 1, 91, 0)
	INSERT INTO TimeZone (Name, Description, StandardTimeUTCOffsetHours, StandardTimeUTCOffsetMinutes, DaylightSavingTimeUTCOffsetHours, DaylightSavingTimeUTCOffsetMinutes, ObservesDaylightSavingTime, Sort, KareoServerTimeZone) VALUES ('Tonga Time', '(GMT+13:00) Nuku''alofa', 13, 0, 13, 0, 0, 92, 0)
END

--------------------------------------------------------------------------------------------------------------
-- ServiceLocation table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ServiceLocation' AND COLUMN_NAME = 'TimezoneID')
BEGIN
	ALTER TABLE dbo.ServiceLocation ADD TimeZoneID int null

	ALTER TABLE dbo.ServiceLocation  WITH CHECK ADD  CONSTRAINT FK_ServiceLocation_TimeZone FOREIGN KEY(TimeZoneID)
	REFERENCES dbo.TimeZone (TimeZoneID)
END