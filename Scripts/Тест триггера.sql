use Test;
go

create table dbo._tmp_Test(id int identity(1,1), name varchar(10));
go

insert into _tmp_Test(name)
values('A')
,('B')
,('C')
,('D')
,('E')
,('F')
go

create TRIGGER tr_test_upd ON dbo._tmp_Test
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN
declare @name varchar(10), @count_d int, @count_i int;

select @count_d = COUNT(*) from deleted;
select @count_i = COUNT(*) from inserted;

select @name = CAST(@count_d as varchar(4))+ '/' + CAST(@count_i as varchar(4))
print @name;
end;

go

update _tmp_Test set name = name + '01';
go
/*обновляются 6 строк*/

alter TRIGGER tr_test_upd ON dbo._tmp_Test
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN
declare @name varchar(10), @count_d int, @count_i int;

--select @count_d = COUNT(*) from deleted;
--select @count_i = COUNT(*) from inserted;

select @name = name from deleted;
print @name;
select @name = name from inserted;
print @name;

end;
go

update _tmp_Test set name = name + '02';
go
/*обновляются 6 строк. в переменную попадает только одна (первая)*/

drop table _tmp_Test;
go