USE DEMO_DB;
    USE ROLE ACCOUNTADMIN;

    -- Prepare table --
    create or replace table customers(
      id number,
      full_name varchar,
      email varchar,
      phone varchar,
      spent number,
      create_date DATE DEFAULT CURRENT_DATE);


    -- insert values in table --
    insert into customers (id, full_name, email,phone,spent)
    values
      (1,'Lewiss MacDwyer','lmacdwyer0@un.org','262-665-9168',140),
      (2,'Ty Pettingall','tpettingall1@mayoclinic.com','734-987-7120',254),
      (3,'Marlee Spadazzi','mspadazzi2@txnews.com','867-946-3659',120),
      (4,'Heywood Tearney','htearney3@patch.com','563-853-8192',1230),
      (5,'Odilia Seti','oseti4@globo.com','730-451-8637',143),
      (6,'Meggie Washtell','mwashtell5@rediff.com','568-896-6138',600);


CREATE OR REPLACE ROLE ANALYST_MASKED;
CREATE OR REPLACE ROLE ANALYST_FULL;

GRANT SELECT ON TABLE DEMO_DB.PUBLIC.CUSTOMERS TO ROLE ANALYST_MASKED;
GRANT SELECT ON TABLE DEMO_DB.PUBLIC.CUSTOMERS TO ROLE ANALYST_FULL;

GRANT USAGE ON SCHEMA DEMO_DB.PUBLIC TO ROLE ANALYST_MASKED;
GRANT USAGE ON SCHEMA DEMO_DB.PUBLIC TO ROLE ANALYST_FULL;

GRANT USAGE ON DATABASE DEMO_DB TO ROLE ANALYST_MASKED;
GRANT USAGE ON DATABASE DEMO_DB TO ROLE ANALYST_FULL;

GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE ANALYST_MASKED;
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE ANALYST_FULL;

GRANT ROLE ANALYST_FULL TO USER FAIZAN;
GRANT ROLE ANALYST_MASKED TO USER FAIZAN;

CREATE OR REPLACE MASKING POLICY name AS
    (val varchar) returns varchar ->
        CASE WHEN current_role()='ANALYST_MASKED' THEN '***'
        ELSE val
        END
;

ALTER TABLE DEMO_DB.PUBLIC.CUSTOMERS MODIFY COLUMN full_name
SET MASKING POLICY name;

SELECT * FROM DEMO_DB.PUBLIC.CUSTOMERS;

USE ROLE ANALYST_FULL;
SELECT * FROM DEMO_DB.PUBLIC.CUSTOMERS;

USE ROLE ANALYST_MASKED;
SELECT * FROM DEMO_DB.PUBLIC.CUSTOMERS;