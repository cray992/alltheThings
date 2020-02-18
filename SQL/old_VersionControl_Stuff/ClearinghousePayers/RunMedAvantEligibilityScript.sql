:setvar server "kprod-db03.kareoprod.ent"
:setvar db "ClearinghousePayers"
:setvar fileToRun "D:\ClearinghousePayers\SQL\Set Medavant Eligibility URLs.sql"

:connect $(server) -U dev -P NEVER!
use $(db)
:r $(fileToRun)
go
