Select sum(cast([Job Satisfaction] as decimal(10,2))) from DEPRESION
group by [Job Satisfaction]


ALTER TABLE DEPRESION
ALTER COLUMN [Job satisfaction] decimal

select distinct([Job Satisfaction]), count([Job Satisfaction]) from DEPRESION
group by [Job Satisfaction]

select * from DEPRESION
where [Job Satisfaction] = 0

select distinct([Gender]), count([Gender]) from DEPRESION
group by [Gender]

select distinct([Job Satisfaction]), count([Job Satisfaction]) from DEPRESION
group by [Job Satisfaction]



SELECT depression 
, case when Depression = '0' then 'No'
		when Depression = '1' then 'Yes'
		else Depression
		end
from DEPRESION

update DEPRESION
set Depression = case when Depression = '0' then 'No'
		when Depression = '1' then 'Yes'
		else Depression
		end

select * from DEPRESION

ALTER TABLE DEPRESION
ALTER COLUMN [Academic Pressure] decimal

ALTER TABLE DEPRESION
ALTER COLUMN [Work Pressure] decimal

ALTER TABLE DEPRESION
ALTER COLUMN [CGPA] decimal(10,2)

ALTER TABLE DEPRESION
ALTER COLUMN [AGE] decimal(10,2)

ALTER TABLE DEPRESION
ALTER COLUMN [Work Study Hours] decimal(10,2)



EXEC sp_help 'DEPRESION'


select distinct([Financial Stress]), count([Financial Stress]) from DEPRESION

group by [Financial Stress]

SELECT * FROM DEPRESION
WHERE [Financial Stress] =0

UPDATE DEPRESION
set [Financial Stress] = case when [Financial Stress] like '' Then '0'
else [Financial Stress]
end


ALTER TABLE DEPRESION
ALTER COLUMN [Financial Stress] decimal(10,2)


SELECT avg([Financial Stress]) from DEPRESION

group by [Financial Stress]

UPDATE DEPRESION
SET [Financial Stress] = (SELECT AVG([Financial Stress]) FROM DEPRESION )
WHERE [Financial Stress] = 0

Select avg([Financial Stress]) from DEPRESION
where [Financial Stress] = 0


SELECT count(*) FROM DEPRESION
where Depression = 'yes'

SELECT distinct([Dietary Habits]), count(*) from DEPRESION
group by [Dietary Habits]


Select * from DEPRESION
where [Dietary Habits] like 'Others'




alter table DEPRESION
ADD Financial_state nvarchar(255)


UPDATE DEPRESION
SET Financial_state = case when [Financial Stress] = 1 or [Financial Stress] = 2 then 'Bajo'
when [Financial Stress] = 3 or [Financial Stress] = 4 then 'Intermedio'
when [Financial Stress] = 5 then 'Alto'
end

select [Financial Stress], financial_state from DEPRESION

select * from DEPRESION


alter table DEPRESION
ADD study_state nvarchar(255)


ALTER TABLE DEPRESION
ALTER COLUMN [Study Satisfaction] decimal(10,2)


UPDATE DEPRESION
SET study_state = case when [Study Satisfaction] = 1 or [Study Satisfaction] = 2 then 'Bajo'
when [Study Satisfaction] = 3 or [Study Satisfaction] = 4 then 'Intermedio'
when [Study Satisfaction] = 5 then 'Alto'
end

select study_state, [Study Satisfaction] from DEPRESION

select * from DEPRESION

alter table DEPRESION
ADD work_state nvarchar(255)



select distinct([Work Pressure]), count([Work Pressure]) from DEPRESION
group by [Work Pressure]

alter table Depresion
drop column [Work Pressure]

alter table Depresion
drop column [Job Satisfaction]

alter table Depresion
drop column work_state

select distinct([Academic Pressure]), count([Academic Pressure]) from DEPRESION
group by [Academic Pressure]

alter table DEPRESION
ADD academic_state nvarchar(255)

UPDATE DEPRESION
SET academic_state = case when [Academic Pressure] = 1 or [Academic Pressure] = 2 or [Academic Pressure]= 0 then 'Bajo'
when [Academic Pressure] = 3 or [Academic Pressure] = 4 then 'Intermedio'
when [Academic Pressure] = 5 then 'Alto'
end

Select Gender, Age, City, Profession, [Sleep Duration], [Dietary Habits], [Work Study Hours], Depression, Financial_state, study_state, academic_state, [Have you ever had suicidal thoughts ?] 
from DEPRESION

select distinct(profession), count(profession) from DEPRESION
group by Profession