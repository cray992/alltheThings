-- Extend Box19 field so it matches to what is Encounter.Box19
alter table EncounterHistory alter column Box19 varchar(51) null
go