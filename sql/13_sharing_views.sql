SHOW SHARES;

// Create share object
CREATE OR REPLACE SHARE VIEW_SHARE;

// Grant usage on dabase & schema
GRANT USAGE ON DATABASE CUSTOMER_DB TO SHARE VIEW_SHARE;
GRANT USAGE ON SCHEMA CUSTOMER_DB.PUBLIC TO SHARE VIEW_SHARE;

// Grant select on view
GRANT SELECT ON VIEW  CUSTOMER_DB.PUBLIC.CUSTOMER_VIEW TO SHARE VIEW_SHARE;

ALTER SHARE VIEW_SHARE
SET secure_objects_only=false;

GRANT SELECT ON VIEW  CUSTOMER_DB.PUBLIC.CUSTOMER_VIEW TO SHARE VIEW_SHARE;

CREATE OR REPLACE SHARE SECURE_VIEW_SHARE;


GRANT USAGE ON DATABASE CUSTOMER_DB TO SHARE SECURE_VIEW_SHARE;
GRANT USAGE ON SCHEMA CUSTOMER_DB.PUBLIC TO SHARE SECURE_VIEW_SHARE;

GRANT SELECT ON VIEW  CUSTOMER_DB.PUBLIC.CUSTOMER_VIEW_SECURE TO SHARE SECURE_VIEW_SHARE;


// Add account to share
ALTER SHARE VIEW_SHARE
ADD ACCOUNT=<account_name_consumer>;

ALTER SHARE SECURE_VIEW_SHARE
ADD ACCOUNT=<account_name_consumer>;




---- In consumer account ----

SHOW SHARES;

DESC SHARE <account_name_producer>.SECURE_VIEW_SHARE;

CREATE OR REPLACE DATABASE SECURE_DATA_SHARE_DB FROM SHARE <account_name_producer>.SECURE_VIEW_SHARE;

SHOW SHARES;

DESC SHARE <account_name_producer>.VIEW_SHARE;

CREATE OR REPLACE DATABASE DATA_SHARE_DB FROM SHARE GKJZFHQ.WWB35617.VIEW_SHARE;