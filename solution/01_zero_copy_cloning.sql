USE DATABASE DEMO_DB;
USE WAREHOUSE COMPUTE_WH;

CREATE OR REPLACE TABLE DEMO_DB.PUBLIC.SUPPLIER
AS
SELECT * FROM "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."SUPPLIER";

SELECT * FROM DEMO_DB.PUBLIC.SUPPLIER;

CREATE OR REPLACE TABLE DEMO_DB.PUBLIC.SUPPLIER_CLONE
CLONE DEMO_DB.PUBLIC.SUPPLIER;

SELECT * FROM DEMO_DB.PUBLIC.SUPPLIER_CLONE;

UPDATE SUPPLIER_CLONE
SET S_PHONE='###';

--> Query ID: 01b8d9fa-020b-999d-0009-f3f300051b66

SELECT * FROM DEMO_DB.PUBLIC.SUPPLIER_CLONE;

CREATE OR REPLACE TABLE DEMO_DB.PUBLIC.SUPPLIER_CLONE_CLONE
CLONE DEMO_DB.PUBLIC.SUPPLIER_CLONE BEFORE (STATEMENT => '01b8d9fa-020b-999d-0009-f3f300051b66');

SELECT * FROM DEMO_DB.PUBLIC.SUPPLIER_CLONE_CLONE;

DROP TABLE DEMO_DB.PUBLIC.SUPPLIER;

SELECT * FROM DEMO_DB.PUBLIC.SUPPLIER_CLONE;

SELECT * FROM DEMO_DB.PUBLIC.SUPPLIER_CLONE_CLONE;