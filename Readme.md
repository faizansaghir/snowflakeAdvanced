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
2. <strong>Loading Data From Azure</strong> </br>
    &emsp;a. Use ./sql/azure/01_creating_storage_integration.sql to create a Storage Integration object. <br>
    &emsp;&emsp;Tenant ID is available from your azure account and locations to access should be provided. <br>
    &emsp;b. Describe the Storage Integration object and visit the link under AZURE_CONSENT_URL and grant access. <br>
    &emsp;c. Go to Azure console and under IAM, and create new Add Role Assignment and assign permission to our containers. <br>
    &emsp;d. Under Role, select Job Function roles and select Storage Blob Data Container. <br>
    &emsp;e. Under Members, add member with name same as that which appeared during consent.
    &emsp;&emsp;Can also be found under Storage Integration description as AZURE_MULTITENANT_APP_NAME. <br>
    &emsp;e. Use ./sql/azure/02_loading_data_using_storage_integration.sql to create stage and attach Storage Integration. <br>
    &emsp;f. Load data from stage created. <br><br>
3. <strong>Snowpipe Overview </strong> <br>
    Feature of snowflake that enables loading once a file appears in a bucket. <br>
    It is used when data needs to be immediately available. <br>
    Snowpipe uses serverless features instead of using traditional warehouses which is managed by Snowflake. <br>
    Flow diagram of Snowpipe: 
    ![Snowpipe Flow Diagram](./img/snowpipeFlowDiagram.PNG "SnowpipeFlowDiagram") <br><br>
4. <strong>Steps for setting up Snowpipe</strong> <br>
    &emsp;a. Create stage object with Storage integration(is using Storage integration) and file format(or add it in COPY command). <br>
    &emsp;b. Test COPY command which works as it will be part of the pipe and needs to work properly. <br>
    &emsp;c. Create the pipe object, describe the pipe and get the <code>notification_channel</code> attribute. <br>
    &emsp;d. Go to S3 bucket and under <code>properties -> Event notifications</code> and create a new event notification. <br>
    &emsp;e. Provide the ARN copied after selecting <code>Destination: SQS queue -> Specify SQS queue: Enter SQS name ARN</code>. <br>
    <em>See ./sql/01_creating_snowpipe.sql</em> <br><br>
5. <strong>Monitoring and Managing Snowpipes</strong> <br>
    <em>See ./sql/02_monitoring_and_managing_pipes.sql</em> <br>
    <em>Note: Recreating a pipe does not delete metadata related to the pipe or notification channel change. </em> <br><br>
6. <strong>Time Travel in Snowflake</strong> <br>
    Advantages of Time: <br>
    &emsp;a. We can query deleted or updated data <br>
    &emsp;b. Restore tables, schemas, and databases that have been dropped <br>
    &emsp;c. Create clones of tables, schemas and databases from previous state <br>
    Different ways to use time travel: <br>
    &emsp;a. <strong>TIMESTAMP</strong>: By providing timestamp from when we want to query. <br>
    &emsp;b. <strong>OFFSET</strong>: By providing offset i.e. look-back duration (in seconds). <br>
    &emsp;c. <strong>QUERY ID/ STATEMENT</strong>: By providing query id before which we want to get state as statement. <br>
    &emsp;d. <strong>UNDROP TABLE/ SCHEMA/ DATABASE</strong>: Undo drop of table, schema or database if within recovery range. <br>
    <em>Note: Cannot undrop if another object of same name already exists, solution is to rename current object and then undrop. <br>
    &emsp;Should have ownership privileges for an object to be restored. <br> 
    See ./sql/03_using_time_travel.sql</em> <br><br>
7. <strong>Restoring Data Using Time Travel</strong> <br>
    The usual approach which can cause issue is as follows: <br>
    &emsp;Using <code>CREATE OR REPLACE TABLE</code> which will create a new table with same name but with different underlying id. <br>
    &emsp;This will cause us to lose any time travel or history of the previous table with same name but different ID. <br>
    The recommended approach is as follows: <br>
    &emsp;a. Create a temp table with state of table which you want to revert to. <br>
    &emsp;b. Truncate current table. This will retain time travel/ query history of the current table. <br>
    &emsp;c. Copy values from temp table to current table using <code>INSERT INTO</code> and <code>SELECT</code> commands. <br>
    <em>See ./sql/04_restoring_data_using_time_travel.sql</em> <br><br>
8. <strong>Restoring Data Using UNDROP Command</strong> <br>
    &emsp;a. We can undrop a dropped table, schema or database with all its objects. <br>
    &emsp;b. If we have used the bad method of time travel and now unable to get the previous table, we can use rename table and undrop. <br>
    &emsp;&emsp;i. Rename the current table with same name to a different name table. <br>
    &emsp;&emsp;ii. Undrop the table with desired name. <br>
    &emsp;&emsp;iii. Use time travel feature and query history of the desired table. <br>
    <em>See ./sql/05_restoring_data_using_undrop.sql</em> <br><br>
