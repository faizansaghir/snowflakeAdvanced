
-- Create Reader Account --

CREATE MANAGED ACCOUNT tech_joy_account
ADMIN_NAME = tech_joy_admin,
ADMIN_PASSWORD = 'Pass#123',
TYPE = READER;

// Make sure to have selected the role of accountadmin

// Show accounts
SHOW MANAGED ACCOUNTS;


-- Share the data by adding account to existing share object --

ALTER SHARE ORDERS_SHARE
ADD ACCOUNT = <account_name_consumer>;


ALTER SHARE ORDERS_SHARE
ADD ACCOUNT =  <account_name_consumer>
SHARE_RESTRICTIONS=false;


---- In consumer/reader account ----


-- Create database from share --

// Make sure to have selected the role of accountadmin

// Show all shares (consumer & producers)
SHOW SHARES;

// See details on share
DESC SHARE <account_name_producer>.ORDERS_SHARE;

// Create a database in consumer account using the share
CREATE DATABASE DATA_SHARE_DB FROM SHARE <account_name_producer>.ORDERS_SHARE;

// Validate table access
SELECT * FROM  DATA_SHARE_DB.PUBLIC.ORDERS;


// Setup virtual warehouse
CREATE WAREHOUSE READ_WH WITH
WAREHOUSE_SIZE='X-SMALL'
AUTO_SUSPEND = 180
AUTO_RESUME = TRUE
INITIALLY_SUSPENDED = TRUE;

// Validate table access
SELECT * FROM  DATA_SHARE_DB.PUBLIC.ORDERS;





-- Create and set up users --

// Create user
CREATE USER MYRIAM PASSWORD = 'difficult_passw@ord=123';

// Grant usage on warehouse
GRANT USAGE ON WAREHOUSE READ_WH TO ROLE PUBLIC;


// Grating privileges on a Shared Database for other users
GRANT IMPORTED PRIVILEGES ON DATABASE DATA_SHARE_DB TO ROLE PUBLIC;


