<h1>Overview</h1>
Repository to record learning of advanced Snowflake topics

<h2>Notes</h2>

1. <strong>Loading Data From AWS</strong> </br>
    &emsp;a. Create IAM role that has access to the S3 bucket and copy the ARN. <br>
    &emsp;b. Use ./sql/aws/01_creating_storage_integration.sql to create a Storage integration and provide the ARN copied. <br>
    &emsp;c. Describe the Storage Integration object and get the USER ARN and EXTERNAL ID mentions. <br>
    &emsp;d. Navigate to the role in AWS and establish Trust Relationship by providing USER ARN and EXTERNAL ID. <br>
    &emsp;e. Use ./sql/aws/02_loading_data_using_storage_integration.sql to create stage and attach Storage Integration. <br>
    &emsp;d. Load data from stage created. <br><br>
2<strong>Loading Data From Azure</strong> </br>
    &emsp;a. Use ./sql/aws/01_creating_storage_integration.sql to create a Storage Integration object. <br>
    &emsp;&emsp;Tenant ID is available from your azure account and locations to access should be provided. <br>
    &emsp;b. Describe the Storage Integration object and visit the link under AZURE_CONSENT_URL and grant access. <br>
    &emsp;c. Go to Azure console and under IAM, and create new Add Role Assignment and assign permission to our containers. <br>
    &emsp;d. Under Role, select Job Function roles and select Storage Blob Data Container. <br>
    &emsp;e. Under Members, add member with name same as that which appeared during consent.
    &emsp;&emsp;Can also be found under Storage Integration description as AZURE_MULTITENANT_APP_NAME. <br>
    &emsp;e. Use ./sql/02_loading_data_using_storage_integration.sql to create stage and attach Storage Integration. <br>
    &emsp;f. Load data from stage created. <br><br>