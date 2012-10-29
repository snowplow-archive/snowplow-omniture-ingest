-- 1. Add the JAR from https://github.com/snowplow/omniture-data-file-input-format, to enable parsing of data from Omniture clickstream logs. (Note: update the location to reflect the location of the JAR file.)

ADD JAR s3://omniture-connector/static/omniture-data-file-input-format-0.0.1.jar ;

-- 2. Create a table to represent the data to be imported from Omniture. (Update the path to reflect where your Omniture log files have been uploaded to in S3)

CREATE EXTERNAL TABLE omniture_raw (
hit_time_gmt STRING,
service STRING,
accept_language STRING,
date_time STRING,
visid_high STRING,
visid_low STRING,
event_list STRING,
homepage STRING,
ip STRING,
page_event INT,
page_event_var1 STRING,
page_event_var2 STRING,
page_type STRING,
page_url STRING,
pagename STRING,
product_list STRING,
user_server STRING,
channel STRING,
prop1 STRING,
prop2 STRING,
prop3 STRING,
prop4 STRING,
prop5 STRING,
prop6 STRING,
prop7 STRING,
prop8 STRING,
prop9 STRING,
prop10 STRING,
prop11 STRING,
prop12 STRING,
prop13 STRING,
prop14 STRING,
prop15 STRING,
prop16 STRING,
prop17 STRING,
prop18 STRING,
prop19 STRING,
prop20 STRING,
prop21 STRING,
prop22 STRING,
prop23 STRING,
prop24 STRING,
prop25 STRING,
prop26 STRING,
prop27 STRING,
prop28 STRING,
prop29 STRING,
prop30 STRING,
prop31 STRING,
prop32 STRING,
prop33 STRING,
prop34 STRING,
prop35 STRING,
prop36 STRING,
prop37 STRING,
prop38 STRING,
prop39 STRING,
prop40 STRING,
prop41 STRING,
prop42 STRING,
prop43 STRING,
prop44 STRING,
prop45 STRING,
prop46 STRING,
prop47 STRING,
prop48 STRING,
prop49 STRING,
prop50 STRING,
purchaseid STRING,
referrer STRING,
state STRING,
user_agent STRING,
zip STRING,
search_engine INT,
exclude_hit INT,
hier1 STRING,
hier2 STRING,
hier3 STRING,
hier4 STRING,
hier5 STRING,
browser INT,
post_browser_height INT,
post_browser_width INT,
post_cookies STRING,
post_java_enabled STRING,
post_persistent_cookie STRING,
color INT,
connection_type INT,
country INT,
domain STRING,
post_t_time_info STRING,
javascript INT,
language INT,
os INT,
plugins STRING,
resolution INT,
last_hit_time_gmt BIGINT,
first_hit_time_gmt BIGINT,
visit_start_time_gmt BIGINT,
last_purchase_time_gmt BIGINT,
last_purchase_num BIGINT,
first_hit_page_url STRING,
first_hit_pagename STRING,
visit_start_page_url STRING,
visit_start_pagename STRING,
first_hit_referrer STRING,
visit_referrer STRING,
visit_search_engine INT,
visit_num BIGINT,
visit_page_num BIGINT,
prev_page BIGINT,
geo_city STRING,
geo_country STRING,
geo_region STRING,
duplicate_purchase INT,
new_visit INT,
daily_visitor INT,
hourly_visitor INT,
monthly_visitor INT,
yearly_visitor INT,
post_campaign STRING,
evar1 STRING,
evar2 STRING,
evar3 STRING,
evar4 STRING,
evar5 STRING,
evar6 STRING,
evar7 STRING,
evar8 STRING,
evar9 STRING,
evar10 STRING,
evar11 STRING,
evar12 STRING,
evar13 STRING,
evar14 STRING,
evar15 STRING,
evar16 STRING,
evar17 STRING,
evar18 STRING,
evar19 STRING,
evar20 STRING,
evar21 STRING,
evar22 STRING,
evar23 STRING,
evar24 STRING,
evar25 STRING,
evar26 STRING,
evar27 STRING,
evar28 STRING,
evar29 STRING,
evar30 STRING,
evar31 STRING,
evar32 STRING,
evar33 STRING,
evar34 STRING,
evar35 STRING,
evar36 STRING,
evar37 STRING,
evar38 STRING,
evar39 STRING,
evar40 STRING,
evar41 STRING,
evar42 STRING,
evar43 STRING,
evar44 STRING,
evar45 STRING,
evar46 STRING,
evar47 STRING,
evar48 STRING,
evar49 STRING,
evar50 STRING,
post_evar1 STRING,
post_evar2 STRING,
post_evar3 STRING,
post_evar4 STRING,
post_evar5 STRING,
post_evar6 STRING,
post_evar7 STRING,
post_evar8 STRING,
post_evar9 STRING,
post_evar10 STRING,
post_evar11 STRING,
post_evar12 STRING,
post_evar13 STRING,
post_evar14 STRING,
post_evar15 STRING,
post_evar16 STRING,
post_evar17 STRING,
post_evar18 STRING,
post_evar19 STRING,
post_evar20 STRING,
post_evar21 STRING,
post_evar22 STRING,
post_evar23 STRING,
post_evar24 STRING,
post_evar25 STRING,
post_evar26 STRING,
post_evar27 STRING,
post_evar28 STRING,
post_evar29 STRING,
post_evar30 STRING,
post_evar31 STRING,
post_evar32 STRING,
post_evar33 STRING,
post_evar34 STRING,
post_evar35 STRING,
post_evar36 STRING,
post_evar37 STRING,
post_evar38 STRING,
post_evar39 STRING,
post_evar40 STRING,
post_evar41 STRING,
post_evar42 STRING,
post_evar43 STRING,
post_evar44 STRING,
post_evar45 STRING,
post_evar46 STRING,
post_evar47 STRING,
post_evar48 STRING,
post_evar49 STRING,
post_evar50 STRING,
click_action STRING,
click_action_type INT,
click_context STRING,
click_context_type INT,
click_sourceid BIGINT,
click_tag STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' 
STORED AS 
INPUTFORMAT 'com.tgam.hadoop.mapred.OmnitureDataFileInputFormat' 
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.IgnoreKeyTextOutputFormat'
LOCATION 's3://omniture-connector/data/sample/';

-- 3. Define the table where your SnowPlow data lives. This will be where the Omniture data is ingested into

CREATE EXTERNAL TABLE IF NOT EXISTS `snowplow_events` (
tm STRING,
txn_id STRING,
user_id STRING,
user_ipaddress STRING,
visit_id int,
page_url STRING,
page_title STRING,
page_referrer STRING,
mkt_source STRING,
mkt_medium STRING,
mkt_term STRING,
mkt_content STRING,
mkt_campaign STRING,
ev_category STRING,
ev_action STRING,
ev_label STRING,
ev_property STRING,
ev_value STRING,
tr_orderid STRING,
tr_affiliation STRING,
tr_total STRING,
tr_tax STRING,
tr_shipping STRING,
tr_city STRING,
tr_state STRING,
tr_country STRING,
ti_orderid STRING,
ti_sku STRING,
ti_name STRING,
ti_category STRING,
ti_price STRING,
ti_quantity STRING,
br_name STRING,
br_family STRING,
br_version STRING,
br_type STRING,
br_renderengine STRING,
br_lang STRING,
br_features array<STRING>,
br_cookies boolean,
os_name STRING,
os_family STRING,
os_manufacturer STRING,
dvce_type STRING,
dvce_ismobile boolean,
dvce_screenwidth int,
dvce_screenheight int,
app_id STRING,
mkt_referrerurl STRING,
br_windowheight STRING,
br_windowwidth STRING,
br_colordepth STRING,
br_jsversion STRING,
os_version STRING,
dvce_name STRING,
dvce_isspider STRING,
geo_country STRING,
geo_region STRING,
geo_city STRING,
geo_postcode STRING,
geo_latitude STRING,
geo_longitude STRING,
social_network STRING,
social_action STRING,
social_target STRING,
social_pagepath STRING,
click_targeturl STRING,
click_targettype STRING,
click_sourceid STRING,
domain STRING,
connection_type STRING,
event_name STRING,
cv_user1 STRING,
cv_user2 STRING,
cv_user3 STRING,
cv_user4 STRING,
cv_user5 STRING,
cv_user6 STRING,
cv_user7 STRING,
cv_user8 STRING,
cv_user9 STRING,
cv_user10 STRING,
cv_session1 STRING,
cv_session2 STRING,
cv_session3 STRING,
cv_session4 STRING,
cv_session5 STRING,
cv_session6 STRING,
cv_session7 STRING,
cv_session8 STRING,
cv_session9 STRING,
cv_session10 STRING,
cv_event1 STRING,
cv_event2 STRING,
cv_event3 STRING,
cv_event4 STRING,
cv_event5 STRING,
cv_event6 STRING,
cv_event7 STRING,
cv_event8 STRING,
cv_event9 STRING,
cv_event10 STRING,
cv_context1 STRING,
cv_context2 STRING,
cv_context3 STRING,
cv_context4 STRING,
cv_context5 STRING,
cv_context6 STRING,
cv_context7 STRING,
cv_context8 STRING,
cv_context9 STRING,
cv_context10 STRING,
cv_json STRING
)
PARTITIONED BY (dt STRING)
LOCATION 's3://omniture-connector/data/output/' ;



-- 4. Now ingest the data

INSERT INTO TABLE `snowplow_events`
SELECT

SUBSTRING(date_time, 12, 8) AS tm,

-- update following line with a suitable function to set txn_id (e.g. based on random number)
NULL AS txn_id,				
CONCAT(visid_low, visid_high) AS user_id,
ip AS ip_address, 
visit_num as visit_id,

-- page level variables
page_url AS page_url,
pagename AS page_title,
referrer AS page_referrer,

-- Need to confirm that we can only set the mkt_campaign based on the Omniture log data (REF http://blogs.adobe.com/digitalmarketing/analytics/campaign-tracking-inside-omniture-sitecatalyst/)
IF(visit_search_engine IS NOT NULL, visit_search_engine, visit_referrer) AS mkt_source,
IF(visit_search_engine IS NOT NULL, "organic", NULL) AS mkt_medium,
NULL AS mkt_term,
NULL AS mkt_content,
post_campaign AS mkt_campaign,

-- Not possible to define a general purpose way to map custom events in Omniture with SnowPlow -> business logic needs to be implementation-specific
NULL AS ev_category, 
NULL AS ev_action,
NULL AS ev_label,
NULL AS ev_property,
NULL AS ev_value,

-- transaction related variables
purchaseid AS tr_orderid,
NULL AS tr_affiliation,
NULL AS tr_total,
NULL AS tr_tax,
NULL AS tr_shipping,
NULL AS tr_city,
state AS tr_state,
NULL AS tr_country,
purchaseid AS ti_orderid,
-- TODO: check if we can shopping basket details are generally packed in the Omniture collection of events field `product_list`
NULL AS ti_sku,
NULL AS ti_name,
NULL AS ti_category,
NULL AS ti_price,
NULL AS ti_quantity,
-- TODO: check if we should add a zip code to SnowPlow transaction handling

-- Browser fields. TODO: These need to be set based on a lookup from the browser_id (BROWSER LOOKUP TABLE) i.e. (field = `browser`). Until then, set to NULL
NULL AS br_name,
NULL AS br_family,
NULL AS br_version,
NULL AS br_type,
NULL AS br_renderengine,
accept_language AS br_lang,

-- TODO: work out if possible to deduce other browser features from Omniture logs...
ARRAY(IF(post_cookies="Y", "java", NULL)) AS br_features, 
post_cookies AS br_cookies,

-- OS fields. TODO: set based on OS LOOKUP TABLE
NULL AS os_name,
NULL AS os_family,
NULL AS os_manufacturer,

--dvce fields. TODO: set dvce_type and dvce_ismobile from user_agent string
NULL AS dvce_type,
NULL AS dvce_ismobile,
post_browser_width AS dvce_screenwidth,
post_browser_height AS dvce_screenheight,

-- TODO: check how SiteCatalyst sets mobile_id. (This isn't provided in the sample data set)
NULL AS app_id, 
visit_referrer AS mkt_referrerurl, 
post_browser_height AS br_windowheight,
post_browser_width AS br_windowwidth,
color AS br_colordepth,
javascript AS br_jsversion,

-- TODO: set below fields based on user_agent
NULL AS os_version,
NULL AS dvce_name,
NULL AS dvce_isspider,

-- Geo data
geo_country AS geo_country,
geo_region AS geo_region,
geo_city AS geo_city,
zip AS geo_postcode,
NULL AS geo_latitude,
NULL AS geo_longitude,

-- Social fields. (TODO: check these are not supported by Omniture, as it looks)
NULL AS social_network,
NULL AS social_action,
NULL AS social_target,
NULL AS social_pagepath,

-- click tracking
click_action AS click_targeturl,
-- TODO: create a function to map Omniture `click_action_type` with SnowPlow `click_targettype`
click_action_type AS click_targettype, 
-- TODO: define a function to map the way SnowPlow defines sourceid to the way Omniture defines it
click_sourceid AS click_sourceid, 

-- other fields
domain AS domain,
connection_type AS onnection_type,
-- TODO: define a mapping function based on the Omniture definitions of page_event,
page_event AS event_name, 

-- Custom variables. Note that we **cannot** define a standard mapping between Omniture's and SnowPlow's custom variables, but that these can be defined on a client-specific implementation, based on the way the client uses their custom variables
NULL AS cv_user1,
NULL AS cv_user2,
NULL AS cv_user3,
NULL AS cv_user4,
NULL AS cv_user5,
NULL AS cv_user6,
NULL AS cv_user7,
NULL AS cv_user8,
NULL AS cv_user9,
NULL AS cv_user10,
NULL AS cv_session1,
NULL AS cv_session2,
NULL AS cv_session3,
NULL AS cv_session4,
NULL AS cv_session5,
NULL AS cv_session6,
NULL AS cv_session7,
NULL AS cv_session8,
NULL AS cv_session9,
NULL AS cv_session10,
NULL AS cv_event1,
NULL AS cv_event2,
NULL AS cv_event3,
NULL AS cv_event4,
NULL AS cv_event5,
NULL AS cv_event6,
NULL AS cv_event7,
NULL AS cv_event8,
NULL AS cv_event9,
NULL AS cv_event10,
NULL AS cv_context1,
NULL AS cv_context2,
NULL AS cv_context3,
NULL AS cv_context4,
NULL AS cv_context5,
NULL AS cv_context6,
NULL AS cv_context7,
NULL AS cv_context8,
NULL AS cv_context9,
NULL AS cv_context10,
NULL AS cv_json,

-- date field, used for partitioning
to_date(date_time) AS dt
FROM omniture_raw ;