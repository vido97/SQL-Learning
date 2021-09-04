--Intermediate SQL--

					-- UNION (to get data to same colunm as left table)--
create table tblperson2(ID int, Name nvarchar(20), email  nvarchar(20))
insert into tblperson2 values (15, 'Jack', 'Jack@gmail.com',1,22,'HCM','Male',3000,2,9)
insert into tblperson2 values (16, 'Rose', 'Rose@gmail.com',2,23,'HCM','Female',3500,2,9)
insert into tblperson2 values (12, 'Riku', 'r@rgmail.com',1,28,'Helsinki','male',2900,2,6)

update tblperson2
set email='r@r.com' where ID =12

	-- Remove a row in table
Delete from tblperson2 where ID=12

	-- When using full outer join, create new colunms
select * from tblperson
full outer join tblperson2
on tblperson.ID = tblperson2.ID

	-- Using union (duplicated row is removed automatically , row 12):
select * from tblperson
union 
select * from tblperson2

	--Using union all (duplicated row is shown)
select * from tblperson
union all 
select * from tblperson2
order by ID

									--CASE STATEMENT--
--The CASE statement goes through conditions and returns a value when the first condition is met. 
--So, once a condition is true, it will stop reading and return the result. 
--If no conditions are true, it returns the value in the ELSE clause.
SELECT name, departmentname, salary,
CASE
	when departmentname='IT' then salary+(salary*.10)
	when departmentname = 'payroll' then salary+(salary*.05)
	else salary +(salary*.01)
END as AfterRaise
from tblperson
		join tblDepartment --join/right join etc.
		on tblperson.departmentid = tbldepartment.id


									-- ALIAS--
select name + ' ' + departmentname as PersonSummary
from tblperson
		join tblDepartment --join/right join etc.
		on tblperson.departmentid = tbldepartment.id

select a.ID,a.name,b.gender,c.departmentname,c.departmenthead,
d.name as Managername
from tblperson a

	left join tblgender b
	on a.GenderID=b.ID

	left join tbldepartment c
	on a.departmentID=c.ID

	left join tblperson d
	on a.managerID=d.ID

							---PARTITION BY---
-- with group by
select DepartmentName,count(name) as Depatment_EmpolyeeAmount from tblperson a
left join tblDepartment b
on a.departmentID=b.ID
group by departmentname

--with partition by (show the group by result on each table row)
select name, gender, salary, DepartmentName,
count(name) OVER (partition by departmentname)  as Depatment_EmpolyeeAmount 
from tblperson a
left join tblDepartment b
on a.departmentID=b.ID
