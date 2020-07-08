BACKUP DATABASE Chest35 
 TO DISK = 'D:\BACKUP\TEMP_Work\Chest35_test.bak'
   WITH FORMAT, COPY_ONLY ;
GO

drop database Chest35_test;
go

RESTORE DATABASE Chest35_test FROM DISK = 'D:\BACKUP\TEMP_Work\Chest35_test.bak'
WITH MOVE 'Chest35_dat' TO 'E:\MSSQL\DATA\Chest35_Data_test.mdf' 
    ,MOVE 'Chest35_Log' TO 'E:\MSSQL\DATA\Chest35_Log_test.ldf'
    , RESTRICTED_USER
go

select * from master.sys.all_objects
EXEC  master.sys.sp_databases

exec sp_helptext sp_databases

    select
        DATABASE_NAME   = db_name(s_mf.database_id),
        DATABASE_SIZE   = convert(int,
                                    case -- more than 2TB(maxint) worth of pages (by 8K each) can not fit an int...
                                    when convert(bigint, sum(s_mf.size)) >= 268435456
                                    then null
                                    else sum(s_mf.size)*8 -- Convert from 8192 byte pages to Kb
                                    end),
        REMARKS         = convert(varchar(254),null)
    from
        sys.master_files s_mf
   -- where
    ---    s_mf.state = 0 and -- ONLINE
    --    has_dbaccess(db_name(s_mf.database_id)) = 1 -- Only look at databases to which we have access
    group by s_mf.database_id
    order by 1
    
 select * from    sys.master_files where type = 0