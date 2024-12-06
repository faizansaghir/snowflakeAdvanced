// Cloning

SELECT * FROM OUR_FIRST_DB.PUBLIC.CUSTOMERS;

CREATE TABLE OUR_FIRST_DB.PUBLIC.CUSTOMERS_CLONE
CLONE OUR_FIRST_DB.PUBLIC.CUSTOMERS;


// Validate the data
SELECT * FROM OUR_FIRST_DB.PUBLIC.CUSTOMERS_CLONE;


// Update cloned table

UPDATE OUR_FIRST_DB.public.CUSTOMERS_CLONE
SET LAST_NAME = NULL;

SELECT * FROM OUR_FIRST_DB.PUBLIC.CUSTOMERS ;

SELECT * FROM OUR_FIRST_DB.PUBLIC.CUSTOMERS_CLONE;



CREATE OR REPLACE TEMPORARY TABLE OUR_FIRST_DB.PUBLIC.TEMP_TABLE(
  id int);

CREATE TEMPORARY TABLE OUR_FIRST_DB.PUBLIC.TABLE_COPY
CLONE OUR_FIRST_DB.PUBLIC.TEMP_TABLE;

SELECT * FROM OUR_FIRST_DB.PUBLIC.TABLE_COPY;





// Cloning Schema
CREATE TRANSIENT SCHEMA OUR_FIRST_DB.COPIED_SCHEMA
CLONE OUR_FIRST_DB.PUBLIC;

SELECT * FROM COPIED_SCHEMA.CUSTOMERS;


CREATE TRANSIENT SCHEMA OUR_FIRST_DB.EXTERNAL_STAGES_COPIED
CLONE MANAGE_DB.EXTERNAL_STAGES;



// Cloning Database
CREATE TRANSIENT DATABASE OUR_FIRST_DB_COPY
CLONE OUR_FIRST_DB;

DROP DATABASE OUR_FIRST_DB_COPY;
DROP SCHEMA OUR_FIRST_DB.EXTERNAL_STAGES_COPIED;
DROP SCHEMA OUR_FIRST_DB.COPIED_SCHEMA;


// Cloning using time travel

// Setting up table

CREATE OR REPLACE TABLE OUR_FIRST_DB.public.time_travel (
   id int,
   first_name string,
  last_name string,
  email string,
  gender string,
  Job string,
  Phone string);



CREATE OR REPLACE FILE FORMAT MANAGE_DB.file_formats.csv_file
    type = csv
    field_delimiter = ','
    skip_header = 1;

CREATE OR REPLACE STAGE MANAGE_DB.external_stages.time_travel_stage
    URL = 's3://data-snowflake-fundamentals/time-travel/'
    file_format = MANAGE_DB.file_formats.csv_file;



LIST @MANAGE_DB.external_stages.time_travel_stage;



COPY INTO OUR_FIRST_DB.public.time_travel
from @MANAGE_DB.external_stages.time_travel_stage
files = ('customers.csv');


SELECT * FROM OUR_FIRST_DB.public.time_travel;



// Update data

UPDATE OUR_FIRST_DB.public.time_travel
SET FIRST_NAME = 'Frank' ;


SELECT * FROM OUR_FIRST_DB.public.time_travel;


// Using time travel
SELECT * FROM OUR_FIRST_DB.public.time_travel at (OFFSET => -60*1);



// Using time travel
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.time_travel_clone
CLONE OUR_FIRST_DB.public.time_travel at (OFFSET => -60*1.5);

SELECT * FROM OUR_FIRST_DB.PUBLIC.time_travel_clone;


// Update data again

UPDATE OUR_FIRST_DB.public.time_travel_clone
SET JOB = 'Snowflake Analyst' ;


SELECT * FROM OUR_FIRST_DB.PUBLIC.time_travel_clone;


// Using time travel: Method 2 - before Query
SELECT * FROM OUR_FIRST_DB.public.time_travel_clone before (statement => '01b8d9eb-020b-9fb9-0009-f3f300056136');

CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.time_travel_clone_of_clone
CLONE OUR_FIRST_DB.public.time_travel_clone before (statement => '01b8d9eb-020b-9fb9-0009-f3f300056136');

SELECT * FROM OUR_FIRST_DB.public.time_travel_clone_of_clone ;


