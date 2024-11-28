
---- Create file format & stage objects ----

-- create file format
create or replace file format demo_db.public.fileformat_azure
    TYPE = CSV
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1;

-- create stage object
create or replace stage demo_db.public.stage_azure
    STORAGE_INTEGRATION = azure_integration
    URL = 'azure://storageaccountsnow.blob.core.windows.net/snowflakecsv'
    FILE_FORMAT = fileformat_azure;


-- list files
LIST @demo_db.public.stage_azure;


---- Load data ----

create or replace table happiness (
    country_name varchar,
    regional_indicator varchar,
    ladder_score number(4,3),
    standard_error number(4,3),
    upperwhisker number(4,3),
    lowerwhisker number(4,3),
    logged_gdp number(5,3),
    social_support number(4,3),
    healthy_life_expectancy number(5,3),
    freedom_to_make_life_choices number(4,3),
    generosity number(4,3),
    perceptions_of_corruption number(4,3),
    ladder_score_in_dystopia number(4,3),
    explained_by_log_gpd_per_capita number(4,3),
    explained_by_social_support number(4,3),
    explained_by_healthy_life_expectancy number(4,3),
    explained_by_freedom_to_make_life_choices number(4,3),
    explained_by_generosity number(4,3),
    explained_by_perceptions_of_corruption number(4,3),
    dystopia_residual number (4,3));


COPY INTO HAPPINESS
FROM @demo_db.public.stage_azure;

SELECT * FROM HAPPINESS;


--- Load JSON ----


create or replace file format demo_db.public.fileformat_azure_json
    TYPE = JSON;





create or replace stage demo_db.public.stage_azure
    STORAGE_INTEGRATION = azure_integration
    URL = 'azure://storageaccountsnow.blob.core.windows.net/snowflakejson'
    FILE_FORMAT = fileformat_azure_json;

LIST  @demo_db.public.stage_azure;

-- Query from stage
SELECT * FROM @demo_db.public.stage_azure;


-- Query one attribute/column
SELECT $1:"Car Model" FROM @demo_db.public.stage_azure;

-- Convert data type
SELECT $1:"Car Model"::STRING FROM @demo_db.public.stage_azure;

-- Query all attributes
SELECT
$1:"Car Model"::STRING,
$1:"Car Model Year"::INT,
$1:"car make"::STRING,
$1:"first_name"::STRING,
$1:"last_name"::STRING
FROM @demo_db.public.stage_azure;

-- Query all attributes and use aliases
SELECT
$1:"Car Model"::STRING as car_model,
$1:"Car Model Year"::INT as car_model_year,
$1:"car make"::STRING as "car make",
$1:"first_name"::STRING as first_name,
$1:"last_name"::STRING as last_name
FROM @demo_db.public.stage_azure;


Create or replace table car_owner (
    car_model varchar,
    car_model_year int,
    car_make varchar,
    first_name varchar,
    last_name varchar);

COPY INTO car_owner
FROM
(SELECT
$1:"Car Model"::STRING as car_model,
$1:"Car Model Year"::INT as car_model_year,
$1:"car make"::STRING as "car make",
$1:"first_name"::STRING as first_name,
$1:"last_name"::STRING as last_name
FROM @demo_db.public.stage_azure);

SELECT * FROM CAR_OWNER;


-- Alternative: Using a raw file table step
truncate table car_owner;
select * from car_owner;

create or replace table car_owner_raw (
  raw variant);

COPY INTO car_owner_raw
FROM @demo_db.public.stage_azure;

SELECT * FROM car_owner_raw;


INSERT INTO car_owner
(SELECT
$1:"Car Model"::STRING as car_model,
$1:"Car Model Year"::INT as car_model_year,
$1:"car make"::STRING as car_make,
$1:"first_name"::STRING as first_name,
$1:"last_name"::STRING as last_name
FROM car_owner_raw)  ;


select * from car_owner;
