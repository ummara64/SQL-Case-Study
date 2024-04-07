use practice;

/*
Create a table called  employees with the following columns and datatypes:

ID - INT autoincrement
last_name - VARCHAR of size 50 should not be null
first_name - VARCHAR of size 50 should not be null
age - INT
job_title - VARCHAR of size 100
date_of_birth - DATE
phone_number - INT
insurance_id - VARCHAR of size 15

SET ID AS PRIMARY KEY DURING TABLE CREATION

*/

CREATE TABLE employees (
    ID INT AUTO_INCREMENT primary key ,
    last_name VARCHAR(50),
    first_name VARCHAR(50) not null,
    age INT,
    job_title VARCHAR(100),
    date_of_birth DATE,
    phone_number INT,
    insurance_id VARCHAR(15)
);



/*
Add the following data to this table in a SINGLE query:

Smith | John | 32 | Manager | 1989-05-12 | 5551234567 | INS736 |
Johnson | Sarah | 28 | Analyst | 1993-09-20 | 5559876543 | INS832 |
Davis | David | 45 | HR | 1976-02-03 | 5550555995 | INS007 |
Brown | Emily | 37 | Lawyer | 1984-11-15 | 5551112022 | INS035 |
Wilson | Michael | 41 | Accountant | 1980-07-28 | 5554403003 | INS943 |
Anderson | Lisa | 22 | Intern | 1999-03-10 | 5556667777 | INS332 |
Thompson | Alex | 29 | Sales Representative| 5552120111 | 555-888-9999 | INS433 |

*/

insert into employees(last_name,
	first_name,
    age,
    job_title,
    date_of_birth,
    phone_number,
    insurance_id) 
values ("Smith", "John", 32, "Manager", "1989-05-12", 5551234567, "INS736"),
("Johnson", "Sarah", 28, "Analyst", "1993-09-20", 5559876543, "INS832"),
("Davis", "David", 45, "HR", "1976-02-03", 5550555995, "INS007"),
("Brown", "Emily", 37, "Lawyer", "1984-11-15", 5551112022, "INS035"),
("Wilson", "Michael", 41, "Accountant", "1980-07-28", 5554403003, "INS943"),
("Anderson", "Lisa", 22, "Intern", "1999-03-10", 5556667777, "INS332"),
("Thompson", "Alex", 29, "Sales Representative", "1992-06-24",  555-888-9999, "INS433");

-- While inserting the above data, you might get error because of Phone number column.
-- As phone_number is INT right now. Change the datatype of phone_number to make them strings of FIXED LENGTH of 10 characters.
-- Do some research on which datatype you need to use for this.

alter table employees change phone_number phone_number varchar(10);

-- Explore unique job titles
select distinct job_title from employees;

-- Name the top three youngest employees
select first_name, last_name, date_of_birth from employees order by date_of_birth desc limit 3;


-- Update date of birth for Alex Thompson as it is 1992-06-24
set sql_safe_updates = 0;
update employees set date_of_birth =  "1992-06-24" where first_name = "Alex" and last_name = "Thompson";


-- Delete the data of employees with age greater than 30
delete from employees where age > 30;

-- Concatenating First name and Last name:
select concat(first_name," ",last_name) as Name from employees;


/*-- Create a table called employee_insurance with the following columns and datatypes:

insurance_id VARCHAR of size 15
insurance_info VARCHAR of size 100

Make insurance_id the primary key of this table
							
*/

CREATE TABLE employee_insurance (
    insurance_id VARCHAR(15) PRIMARY KEY,
    insurance_info VARCHAR(100)
);



/*
Insert the following values into employee_insurance:

"INS736", "unavailable"
"INS832", "unavailable"
"INS007", "unavailable"
"INS035", "unavailable"
"INS943", "unavailable"
"INS332", "unavailable"
"INS433", "unavailable"

*/
insert into employee_insurance(insurance_id, insurance_info)
values( "INS736", "unavailable"),
("INS832", "unavailable"),
("INS007", "unavailable"),
("INS035", "unavailable"),
("INS943", "unavailable"),
("INS332", "unavailable"),
("INS433", "unavailable");

select * from employee_insurance;

-- Add a column called email to the employees table. Remember to set an appropriate datatype
alter table employees add email varchar(20);

-- Add the value "unavailable" for all records in email in a SINGLE query
update employees
set email = "unavailable";

select * from employees;
