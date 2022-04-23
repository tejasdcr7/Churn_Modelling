use churn_Modelling

select * from Churn_Modelling

create function cust_Details(@CustomerId int,
@IsActiveMember int
)
returns table 
as 
return 
select Surname,Gender,Age from Churn_Modelling where CustomerId=@CustomerId and IsActiveMember=@IsActiveMember;

select * from cust_Details(15634602,1)



create function Active_Details(@CustomerId int,
@IsActiveMember int
)
returns table 
as 
RETURN
if @IsActiveMember=1
begin
select Surname,Gender,Age from Churn_Modelling where CustomerId=@CustomerId and IsActiveMember=@IsActiveMember;
END
ELSE 
BEGIN 
 PRINT 'PLEASE ACTIVATE THE CUSTOMER'
 END
 END

select * from Active_Details(15634602,1)





/*create  FUNCTION MultistatementCust(@CustomerId int)
	RETURNS @Churn_Modellingnew TABLE (
	    @CustomerId int ,
		Surname VARCHAR(20),
	    Gender VARCHAR(20),
		Age Varchar(30)
	)
	AS
	BEGIN

 
	 SELECT @CustomerId from Churn_Modelling where CustomerId=@CustomerId
	 SELECT @Surname from Churn_Modelling where Surname=@Surname
			@CustomerId
			@Surname
		FROM
			dbo.Churn_Modelling where CustomerId=@CustomerId;
		RETURN;
	END;*/

	
select * from Churn_Modelling



alter function getDetails()
returns @Table Table (
	    CustomerId int ,
		Surname VARCHAR(50),
	    Gender VARCHAR(20),
		Age Varchar(30),
		CreditScore int
	)
	as
	begin
	insert into @Table select CustomerId, Surname,Gender,Age,CreditScore from Churn_Modelling
	return
	end

	select * from dbo.getDetails()


ALTER function multi_getDetails(@CustomerId int)
returns @Table1 Table (
		Surname VARCHAR(50),
	    Gender VARCHAR(20),
		Age Varchar(30)
	)
	as
	begin
	declare @Active int;
	declare @pr varchar(70)
	Select @Active= (SELECT IsActiveMember from Churn_Modelling where CustomerId=@CustomerId);
	IF @Active=1
	insert into @Table1 select  Surname,Gender,Age from Churn_Modelling WHERE CustomerId=@CustomerId and IsActiveMember= 1
	ELSE 
	begin
    set @pr='PLEASE ACTIVE THE CUSTOMER'
	end
	return
	end

	select * from dbo.multi_getDetails(15574012)

	15574012
	15592531


--------------------------SP--------------------------------------

create procedure sp_CreditScore_Range
As 
Begin try
select * from Churn_Modelling where CreditScore < 400
end try
Begin catch
SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() AS ErrorMessage;
END CATCH  

exec sp_CreditScore_Range




create procedure sp_basicDetails
@CustomerId int,
@IsActiveMember int
As
--Select @IsActiveMember = IsActiveMember from Churn_Modelling
Begin 
If @IsActiveMember=1
 select CustomerId, Surname,Gender,Age from Churn_Modelling
ELSE
Begin 
PRINT 'PLEASE ACTIVE THE CUSTOMER'
END
END

exec sp_basicDetails 15574012,1



-------------------------------------Cursor------------------------

Declare @Surname varchar(80),
@CreditScore int,
@Geography varchar(50),
@Age int,
@Balance money


Declare Customer_Cursor Cursor for Select Surname,CreditScore,Geography,Age,Balance from Churn_Modelling

open Customer_Cursor;

Fetch Next From Customer_Cursor INTO @Surname,@CreditScore,@Geography,@Age,@Balance

WHILE @@FETCH_STATUS=0
Begin

print concat('Surname:',@Surname);
print concat('CreditScore:',@CreditScore);
print concat('Geogeaphy:',@Geography);
print concat('Age:',@Age);
print concat('Balance:',@Balance);

Print'==================================================='
Fetch Next From Customer_Cursor INTO @Surname,@CreditScore,@Geography,@Age,@Balance
END

Close Customer_Cursor;
Deallocate Customer_Cursor;


--------------------------trigger----------------------------------------------------

Create trigger Trgrestricttable
on Database 
for DDL_TABLE_EVENTS
AS
begin
print'You Cannot create alter drop Table'
Rollback Transaction
end
go

create table demo(
demo_id int 
)



Drop Trigger if exists Trgrestricttable ON DATABASE;


--------------------------------
set nocount on 
declare @DBCount int 
declare @i int =0 
declare @DBName varchar(200) 
declare @SQLCommand nvarchar(max) 
create table #Databases (name varchar(200)) 
insert into #Databases select name from sys.databases where database_id>4  
set @DBCount=(select count(1) from #Databases) 
WHILE (@DBCount>@i) 
Begin 
set @DBName=(select top 1 name from #Databases) 
set @SQLCommand = 'Backup database [' +@DBName+'] to disk =''D:\Backup\' + @DBName +'.bak''' 
Print @SQLCommand 
delete from #Databases where name=@DBName 
set @I=@i + 1 
End 



create procedure getDBStatus 
@DatabaseID int  
as 
begin 
declare @DBStatus varchar(20) 
set @DBStatus=(select state_desc from sys.databases where database_id=@DatabaseID) 
if @DBStatus='ONLINE' 
Print ' Database is ONLINE' 
else 
Print 'Database is in ERROR state.' 
End

exec getDBStatus 


---------------view----------------
create view Cust_View
as
SELECT
    Surname,Balance ,Geography
FROM
    Churn_Modelling

SELECT * FROM Cust_View







SELECT
   *
FROM
    Churn_Modelling
WHERE 
CustomerId IN(Select CustomerId from Churn_Modelling where age <30)


--GROUP BY
    --IsActiveMember
--order by Geography


Select CustomerId
--,Balance,Geography
from Churn_Modelling
GROUP BY Gender

-------------------subquery-----------------
SELECT
    Surname,Balance,EstimatedSalary,Geography from Churn_Modelling
	where Balance < (Select Avg(cast(EstimatedSalary as decimal)) From Churn_Modelling)



	-----------------------------------

Select CustomerId,Surname,EstimatedSalary from Churn_Modelling 
Where CustomerId in (Select CustomerId from Churn_Modelling where cast(EstimatedSalary as decimal)  >100000) 



alter function GetTotaldata1(@CustomerID int)
RETURNS decimal
As
BEGIN
Declare @result decimal
select @result= sum(CAST(EstimatedSalary as decimal)) from Churn_Modelling as gross where CustomerId=@CustomerID and Geography='france' group by Geography

RETURN @result
END

select *, dbo.GetTotaldata1(15634602) 



alter function GetTotaldatabygender(@Geo varchar(50),@Gender varchar(50))
RETURNS decimal
As
BEGIN
Declare @result decimal
select @result= sum(CAST(EstimatedSalary as decimal)) from Churn_Modelling where  Geography=@Geo group by Gender

RETURN @result
END

select *, dbo.GetTotaldatabygender('france','male') from Churn_Modelling