--Variable Tables

declare @ApptTypeTimes TABLE (
   ApptType VARCHAR(128) null,
   TimeFrame INT null,
   AppointmentType VARCHAR(256) null
);

insert into @ApptTypeTimes 
(ApptType,TimeFrame,AppointmentType) values 
('Sick',10,'Sick Appt'),
('Well Child OK',20,'Well Exam-20'),
('Labs Only',10,'Labs Only'),
('Shots Only',5, 'Shots Only'),
('New Patient',20,'New Patient Visit'),
('Recheck',10,'Sick Appt'),
('WCC30',30,'Well Exam-30'),
('Flu Shot/Mist',10,'Shots Only'),
('20-Med Check',20,'Med Check'),
('Conference General',20,'General Conference-20'),
('Sports Physical',20,'Well Exam-20'),
('Prenatal',30,'Prenatal'),
('ADHD/ADD Conference',30,'ADHD Conference'),
('ANY 10,',10,'No appointment reason required'),
('Well Child CK',20,'Well Exam-20');

select * from @ApptTypeTimes ATT
