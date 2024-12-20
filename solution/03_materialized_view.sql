CREATE OR REPLACE MATERIALIZED VIEW EXERCISE_DB.PUBLIC.MATERIALIZED_VIEW
AS
SELECT
    AVG(PS_SUPPLYCOST) as PS_SUPPLYCOST_AVG,
    AVG(PS_AVAILQTY) as PS_AVAILQTY_AVG,
    MAX(PS_COMMENT) as PS_COMMENT_MAX
    FROM"SNOWFLAKE_SAMPLE_DATA"."TPCH_SF100"."PARTSUPP";

-- Original query takes around 8s while select on materialized view takes around 266ms