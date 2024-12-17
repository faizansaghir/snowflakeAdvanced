USE TASK_DB;

SHOW TASKS;

SELECT * FROM CUSTOMERS;

// Prepare a second table
CREATE OR REPLACE TABLE CUSTOMERS2 (
    CUSTOMER_ID INT,
    FIRST_NAME VARCHAR(40),
    CREATE_DATE DATE);


// Suspend parent task
// **NOTE: Before modifying anything in the tree of tasks the root task needs to be suspended**

ALTER TASK CUSTOMER_INSERT SUSPEND;

// Create a child task
CREATE OR REPLACE TASK CUSTOMER_INSERT2
    WAREHOUSE = COMPUTE_WH
    AFTER CUSTOMER_INSERT
    AS
    INSERT INTO CUSTOMERS2 SELECT * FROM CUSTOMERS;


// Prepare a third table
CREATE OR REPLACE TABLE CUSTOMERS3 (
    CUSTOMER_ID INT,
    FIRST_NAME VARCHAR(40),
    CREATE_DATE DATE,
    INSERT_DATE DATE DEFAULT DATE(CURRENT_TIMESTAMP));


// Create a child task
CREATE OR REPLACE TASK CUSTOMER_INSERT3
    WAREHOUSE = COMPUTE_WH
    AFTER CUSTOMER_INSERT2
    AS
    INSERT INTO CUSTOMERS3 (CUSTOMER_ID,FIRST_NAME,CREATE_DATE) SELECT * FROM CUSTOMERS2;


SHOW TASKS;

ALTER TASK CUSTOMER_INSERT
SET SCHEDULE = '1 MINUTE';

// Resume tasks (first resume child tasks)
ALTER TASK CUSTOMER_INSERT3 RESUME;

SHOW TASKS;

ALTER TASK CUSTOMER_INSERT3 SUSPEND;

SHOW TASKS;

// Resume tasks (then resume root task)
ALTER TASK CUSTOMER_INSERT RESUME;

SHOW TASKS;

ALTER TASK CUSTOMER_INSERT SUSPEND;

SHOW TASKS;

// Recursively resumes a specified task and all its dependent tasks
SELECT SYSTEM$TASK_DEPENDENTS_ENABLE( 'CUSTOMER_INSERT' );

SHOW TASKS;


SELECT * FROM CUSTOMERS2;

SELECT * FROM CUSTOMERS3;

// Suspend tasks again(root tasks need to be suspended first)
ALTER TASK CUSTOMER_INSERT SUSPEND;
ALTER TASK CUSTOMER_INSERT2 SUSPEND;
ALTER TASK CUSTOMER_INSERT3 SUSPEND;


DROP TASK CUSTOMER_INSERT;
DROP TASK CUSTOMER_INSERT2;
DROP TASK CUSTOMER_INSERT3;

SHOW TASKS;

// Create a stored procedure
USE TASK_DB;

SELECT * FROM CUSTOMERS;



CREATE OR REPLACE PROCEDURE CUSTOMERS_INSERT_PROCEDURE (CREATE_DATE varchar)
    RETURNS STRING NOT NULL
    LANGUAGE JAVASCRIPT
    AS
        $$
        var sql_command = 'INSERT INTO CUSTOMERS(CREATE_DATE) VALUES(:1);'
        snowflake.execute(
            {
            sqlText: sql_command,
            binds: [CREATE_DATE]
            });
        return "Successfully executed.";
        $$;



CREATE OR REPLACE TASK CUSTOMER_TAKS_PROCEDURE
WAREHOUSE = COMPUTE_WH
SCHEDULE = '1 MINUTE'
-- WHEN 1=2
AS CALL  CUSTOMERS_INSERT_PROCEDURE (CURRENT_TIMESTAMP);


SHOW TASKS;

ALTER TASK CUSTOMER_TAKS_PROCEDURE RESUME;

SHOW TASKS;

// Use the table function "TASK_HISTORY()"
select *
  from table(information_schema.task_history())
  order by scheduled_time desc;

select *
from table(information_schema.task_history(
    scheduled_time_range_start=>dateadd('hour',-4,current_timestamp()),
    result_limit => 5,
    task_name=>'CUSTOMER_TAKS_PROCEDURE'));

// See results for a given time period
select *
  from table(information_schema.task_history(
    scheduled_time_range_start=>to_timestamp_ltz('2021-04-22 11:28:32.776 -0700'),
    scheduled_time_range_end=>to_timestamp_ltz('2021-04-22 11:35:32.776 -0700')));

SELECT TO_TIMESTAMP_LTZ(CURRENT_TIMESTAMP)

SELECT * FROM CUSTOMERS;

ALTER TASK CUSTOMER_TAKS_PROCEDURE SUSPEND;

SHOW TASKS;