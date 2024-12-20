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
9. <strong>Retention Period</strong> <br>
    &emsp;a. The default retention period set for tables is 1 day. <br>
    &emsp;b. The standard edition allows retention for 1 day but other editions can allow increasing retention period up to 90 days. <br>
    &emsp;c. As we increase the retention period, the storage cost increases with it. <br>
    &emsp;d. Each time we run a query which has time travel feature associated, we create additional storage for changes made. <br>
    &emsp;&emsp;These changes history if made for a lot of times can accumulate to cost us high storage charge. <br>
    <em>See ./sql/06_retention_period.sql for setting retention period and to get cost of each table with time travel</em> <br><br>
10. <strong>Fail Safe</strong> <br>
    Used to recover data from disaster. After the time travel period ends, fail-safe support starts for next 7 days. <br>
    For recovering data using fail-safe method, we need to reach our to Snowflake team. <br>
    &emsp;a. It is 7 days for permanent tables and 0 for transient tables. <br>
    &emsp;b. Storage cost is incurred by us for this fail-safe feature by default. <br>
    &emsp;c. If the table still exists, but the time travel date has passed, we can get back state using fail-safe feature. <br>
    <em>See ./sql/07_fail_safe_metric_query.sql</em> <br><br>
11. <strong>Types of Tables</strong> <br>
    &emsp;a. Permanent: Has features of time travel as well as fail-safe. Resides in storage memory until dropped. <br>
    &emsp;b. Transient: Has features of time travel but not fail-safe. Resides in storage memory until dropped. <br>
    &emsp;c. Temporary: Has features of time travel but not fail-safe. Resides in storage memory until session ends. <br>
    <em>Note: Similar to Tables, schemas and other objects can also be permanent, transient or temporary. <br>
    eg: for schema with transient nature, all tables inside it will be transient only. <br>
    If we create a temporary table with same name as permanent table in a schema, it will not replace the permanent table. <br>
    The temporary table will override the permanent table for the session.</em> <br><br>
12. <strong>Zero Copy Cloning</strong> <br>
    We can clone any object in Snowflake. The child objects will also be cloned like cloning schema will clone tables also. <br>
    The child objects will inherit all the privileges but the source object being cloned will not inherit the privileges. <br>
    Privileges needed for cloning: <br>
    &emsp;a. To clone a table, SELECT privileges on the tables should be there. <br>
    &emsp;b. To clone a Pipe, stream and task, OWNERSHIP privileges should be there. <br>
    &emsp;c. To clone any other object, USAGE privileges should be there. <br>
    In Zero COPY cloning when a table is cloned, the source and cloned table share same storage. <br>
    Once we make changes to the new storage, we will only store the deltas thus reducing storage cost. <br>
    The load history is not copied thus reloading same file to source will skip the files but will be copied in cloned table <br>
    An object clone inherits any metadata, such as comments or table clustering keys. <br> 
    <em>Cloning PERMANENT table to TRANSIENT or TEMPORARY table works, but not vice versa</em> <br>
    ![Zero Copy Cloning](./img/zeroCopyCloning.PNG "ZeroCopyCloning") <br>
    We can also clone tables in combination with time travel feature. <br>
    <em>See ./sql/08_zero_copy_cloning.sql</em> <br><br>
13. <strong>Swapping</strong> <br>
    Similar to Zero Copy Cloning, we can swap 2 tables, schemas using Swapping feature. <br>
    The storage is kept same but the tables reference the underlying storage of the other table. <br>
    ![Swapping Tables](./img/swappingTables.PNG "SwappingTables") <br>
    <em>See ./sql/09_swapping.sql</em> <br><br>
14. <strong>Data Sharing between 2 Snowflake Accounts</strong> <br>
    Data can be shared from one account to another using Data sharing feature of snowflake. <br>
    This is just a metadata operation and does not involve copying of data. <br>
    The producer pays for the storage but the consumer pays for any compute they do on the data using their warehouses. <br> 
    To create a data sharing object:
    <ol>
        <li>Create a share object which is a container which contains metadata</li>
        <li>Grant access to schema, databases, and tables as per requirements</li>
        <li>Add account detail of account that can access the share object</li>
        <li>In the consumer account, create database using the share object</li>
    </ol>
    We can also create share object using UI. Go to Data Products -> Private Sharing. <br>
    In this you can also get details of all share object created by you and modify existing share objects also. <br>
    <em>See ./sql/10_data_sharing_1.sql</em> <br><br>
15. <strong>Data Sharing between Snowflake account and Non-Snowflake User</strong> <br>
    The producer will create a share account and a reader account using which the consumer can consume data. <br>
    The cost of storage and compute are both charged from producer as the producer has created the read only account. <br>
    To create a data sharing object:
    <ol>
        <li>Create a reader account i.e. a managed account of type <code>READER</code></li>
        <li>Create a share object which is a container which contains metadata</li>
        <li>Grant access to schema, databases, and tables as per requirements</li>
        <li>Add account detail of account that can access the share object</li>
        <li>In the reader account, create database using the share object</li>
    </ol>
    We can also create managed account using UI. Go to Data Products -> Private Sharing -> Reader Accounts. <br>
    <em>See ./sql/11_data_sharing_2.sql</em> <br><br>
16. <strong>Data sharing for Entire Schema/ Database</strong> <br>
    We can grant permission to all tables in a schema or database at once. <br>
    This is only for tables present at the time of granting permission, any new table created will not be part of it. <br>
    Any update to existing table will also be reflected in consumer/reader tables. <br>
    Any new table created in database or schema will not be reflected on the consumer account. <br>
    <em>See ./sql/12_data_sharing_3.sql</em> <br><br>
17. <strong>Secure View</strong> <br>
    A view is used to secure our data and reveal only columns and rows(using where clause) which we want to share. <br>
    This view when used with <code>DESCRIBE</code> or <code>SHOW VIEWS</code> command, show the definition of the view. <br>
    This can lead to revealing column names, or row values that we do not want to reveal. <br>
    eg: If we have CREATE VIEW AS SELECT first_name, last_name FROM customers WHERE email NOT LIKE '%@gmail.com'
    The view definition would reveal that there is column called email and the email column has values like '%@gmail.com'. <br>
    To overcome this issue, we use Secure Views. This does not show the view definition at all. <br>
    <em>See ./sql/13_sharing_views.sql</em> <br>
    In case our secure view uses multiple databases, we need to also give REFERENCE_USAGE to share object. <br>
    <em>See ./sql/14_secure_view_with_multiple_database.sql</em> <br><br>
18. <strong>Sampling Feature in Snowflake</strong> <br>
    We need sampling if we are working on DEV and want to test our solution on some subset of the production data. <br>
    Since the production data can be very large, we can use sampling to select a subset of data and perform analysis or testing. <br>
    This sampling would help us reduce cost and time for execution of our solution and analysis. <br>
    ![Sampling Types](./img/samplingTypes.PNG "SamplingTypes")
    <em>See ./sql/15_sampling_data.sql</em> <br><br>
19. <strong>Scheduling Tasks</strong> <br>
    A task is a SQL statement that can be executed at a particular time or on scheduled intervals. <br>
    A task can execute a single SQL statement, including a call to a stored procedure. <br>
    It can run on both a warehouse or can be serverless. <br>
    <em>See ./sql/16_scheduling_tasks.sql</em> <br><br>
20. <strong>Tree Of Tasks</strong> <br>
    A task not necessarily needs to be scheduled, it can be dependent on execution of another tasks. <br>
    This upstream task may be scheduled or another dependent task. Thus creating a tree as multiple task may have same upstream. <br>
    We can also call a stored procedure and also get the history of task execution. <br>
    An individual task can have only a single predecessor (parent) task. <br>
    We can also specify a condition to check before running the task using <code>WHEN &lt;condition&gt;</code> as parameter while creating the task. <br>
    <em>See ./sql/17_tree_of_tasks.sql</em> <br><br>
21. <strong>Streams</strong> <br>
    When we load data from DB to our Warehouse, we use ETL(Extract Transform Load) process. <br>
    We usually bring in only deltas i.e. not the full snapshot, rather only the DML(Data Manipulation Language) changes. <br>
    These can be <code>Delete</code>, <code>Insert</code> or <code>Update</code> operations and a streams captures these changes. <br>
    A stream captures all the columns of the delta row and adds additional columns of metadata. <br>
    The additional columns contained in stream will be <code>METADATA$ACTION</code>, <code>METADATA$UPDATE</code> and <code>METADATA$ROW_ID</code>. <br>
    This process of capturing changes is called CDC(Change Data Capture). This is done without data duplication. <br>
    The stream does not actually store the actual data related to the delta rows, rather it queries the original table only. <br>
    Once the stream is consumed(used with <code>INSERT</code> or <code>MERGE</code> command), it removes the consumed rows automatically. <br>
    <em>See ./sql/18_streams_and_insert_operation.sql</em> <br>
    When we <strong>update</strong> an entry in source table, a stream captures it as 2 rows: <br>
    <ul>
        <li>Row with <code>METADATA$ACTION</code> as DELETE, <code>METADATA$UPDATE</code> as TRUE and with old values</li>
        <li>Row with <code>METADATA$ACTION</code> as INSERT, <code>METADATA$UPDATE</code> as TRUE and with new values</li>
    </ul>
    These 2 rows can be consumed as per our requirement, we can choose to only consider any one of the entries while discarding other. <br>
    <em>See ./sql/19_streams_and_update_operation.sql</em> <br>
    When we <strong>delete</strong> an entry in source table, a stream captures it as single row: <br>
    Row with <code>METADATA$ACTION</code> as DELETE, <code>METADATA$UPDATE</code> as FALSE and with old values. <br>
    This row can be consumed as per our requirement. <br>
    <em>See ./sql/20_streams_and_delete_operation.sql</em> <br>
    <em>See ./sql/21_streams_and_all_operations.sql</em> <br><br>
22. <strong>How does Stream work?</strong> <br>
    When we create a stream on a table, it adds the 3 columns to the table but these columns will be hidden. <br>
    Apart from this, it also has a <code>OFFSET</code> which will initially be the time when stream was created. <br>
    Once we use a DML operation on table, the OFFSET of stream is different from latest OFFSET of table. <br>
    After this, even if we consume just a single row from the stream, it will update the OFFSET of stream to current timestamp. <br>
    The stream also has a <code>stale_after</code> which shows post what time the stream can not be used. <br>
    This is dependent on the retention period of the data in the table which can be up to 14 days. <br>
    If the underlying data is not present, then stream will not be able to track the changes thus making it useless. <br>
    Also the <code>stale</code> flag turns to <code>TRUE</code>. <br>
    Once the data is consumed from stream, the <code>stale_after</code> also changes. <br>
    Streams keep minimal set of changes from OFFSET to NOW <br> 
    &emsp;i.e. say if a row is updated multiple times, it will only store the initial state as DELETE and the current state as INSERT. <br><br>
23. <strong>Append Only Streams</strong> <br>
    These streams track only insert into the table and ignores delete or update into the table. <br>
    We can empty <code>APPEND_ONLY</code>/ <code>DEFAULT</code> stream using <code>CREATE TABLE [table] AS SELECT * FROM [stream]</code> <br>
    <em>See ./sql/23_append_only_stream.sql</em> <br><br>
24. <strong>Change Tracking</strong> <br>
    Change tracking is an attribute of a table which is internally used by streams also. <br>
    If change tracking is enabled, we can get the difference between 2 snapshot of table if they are within time travel scope. <br>
    We can use similar attributes as in time travel to get snapshot at 2 different time. <br>
    This also  has modes that we can pass like append only during function call and also tracks minimal changes as in streams. <br>
    <em>See ./sql/24_change_tracking.sql</em> <br><br>
25. <strong>Materialized Views</strong> <br>
    A view is a SQL statement that queries one or more tables and gets data on the go thus having the latest data. <br>
    A simple view is recomputed every time we run a query to get data using view, thus it will increase cost. <br>
    A materialized view comes into picture if a view is frequently used, and we do not want to recompute it. <br>
    A materialized view is discarded if the data in underlying table(s) changes, lese it behaves as a regular table. <br>
    There is additional cost that is associated with a materialized view as it has to be managed to check if it is stale. <br>
    Snowflake uses serverless compute associated to materialized view which adds to more compute cost of maintenance. <br>
    We should not use materialized view if data changes very frequently and underlying table has large amount of data. <br>
    We can in this case use alternative such as combination of Tasks and Streams along with actual table to get same results. <br>
    It is supported in Enterprise edition and above, and does not support self-joins and limited set of aggregation functions. <br>
    We can also not use UDFs, HAVING clauses, ORDER BY clauses, or LIMIT clause. <br> 
    Ideal scenario for Materialized view, query takes long, data updated rarely and view used often. <br> 
    <em>See ./sql/25_materialized_view.sql</em> <br><br>
26. <strong>Masking Policy</strong> <br>
    If we want to control how a column data can be viewed by different role, we can add masking policy to the column. <br>
    In the masking policy, we can specify how the masked value is to be generated for different roles. <br>
    Policy is also an object defined in our schema which can be used/ re-used with multiple columns. <br>
    Once a policy is associated to any column(s), we cannot drop it or recreate it unless we remove the masking from all column(s). <br>
    However we can modify the masking policy by setting a new body definition for the masking policy. <br>
    A column can only be associated to 1 masking policy. <br> 
    <em>See ./sql/26_masking_policy.sql</em> <br><br>