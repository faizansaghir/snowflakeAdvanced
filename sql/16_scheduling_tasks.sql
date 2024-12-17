CREATE OR REPLACE TRANSIENT DATABASE TASK_DB;

// Prepare table
CREATE OR REPLACE TABLE CUSTOMERS (
    CUSTOMER_ID INT AUTOINCREMENT START = 1 INCREMENT =1,
    FIRST_NAME VARCHAR(40) DEFAULT 'JENNIFER' ,
    CREATE_DATE DATE);


// Create task
CREATE OR REPLACE TASK CUSTOMER_INSERT
    WAREHOUSE = COMPUTE_WH
    SCHEDULE = '1 MINUTE'
    AS
    INSERT INTO CUSTOMERS(CREATE_DATE) VALUES(CURRENT_TIMESTAMP);


SHOW TASKS;

// Task starting and suspending
ALTER TASK CUSTOMER_INSERT RESUME;

SHOW TASKS;

SELECT * FROM CUSTOMERS;



ALTER TASK CUSTOMER_INSERT SUSPEND;

-- We can use CRON also

CREATE OR REPLACE TASK CUSTOMER_INSERT
    WAREHOUSE = COMPUTE_WH
    SCHEDULE = '60 MINUTE'
    AS
    INSERT INTO CUSTOMERS(CREATE_DATE) VALUES(CURRENT_TIMESTAMP);




CREATE OR REPLACE TASK CUSTOMER_INSERT
    WAREHOUSE = COMPUTE_WH
    SCHEDULE = 'USING CRON 0 7,10 * * 5L UTC'
    AS
    INSERT INTO CUSTOMERS(CREATE_DATE) VALUES(CURRENT_TIMESTAMP);


# __________ minute (0-59)
# | ________ hour (0-23)
# | | ______ day of month (1-31, or L)
# | | | ____ month (1-12, JAN-DEC)
# | | | | __ day of week (0-6, SUN-SAT, or L)
# | | | | |
# | | | | |
# * * * * *

-- * means wildcard, any value at that place will satisfy
-- eg: * 8 * * * -> "1 8 0 0 0", "10 8 1 2 0" etc will satisfy this


// Every minute
SCHEDULE = 'USING CRON * * * * * UTC';


// Every day at 6am UTC timezone
SCHEDULE = 'USING CRON 0 6 * * * UTC';

// Every hour starting at 9 AM and ending at 5 PM on Sundays
SCHEDULE = 'USING CRON 0 9-17 * * SUN America/Los_Angeles';


CREATE OR REPLACE TASK CUSTOMER_INSERT
    WAREHOUSE = COMPUTE_WH
    SCHEDULE = 'USING CRON 0 9,17 * * * UTC'
    AS
    INSERT INTO CUSTOMERS(CREATE_DATE) VALUES(CURRENT_TIMESTAMP);

-- If we do not specify WAREHOUSE parameter, we will be switching to SERVERLESS task

