# Hive version of SnowPlow-Omniture-Ingest

## What it does

The Hive-based version of the SnowPlow-Omniture-Ingest tool parses through Omniture log files (uploaded onto S3), reads the data and writes it to the SnowPlow log files, stored in another location in S3.

## How the Hive version of SnowPlow-Omniture-Ingest works

1. A JAR file is added to Hive. This uses the [JAR file](https://github.com/snowplow/snowplow-omniture-ingest/tree/master/hive/supporting_jar) included in the repo. This is a compiled version of the [omniture-data-file-input-format](https://github.com/snowplow/omniture-data-file-input-format), used to handle new line characters present in some Omniture log field values. **Note**: this has to be uploaded into S3 in order to be used by Hive on EMR. (The location specified for the JAR file in the query will need to be modified to point at where *you* have saved the JAR file.)

2. The Omniture log files are uploaded into a specific bucket / folder in S3, and an external **input table** is defined, pointing at their location, utilising the above JAR, so that the values in the log files can be read into Hive. (Again, the `LOCATION` parameter in the query will have to be uploaded the Omniture log files.)

3. The SnowPlow **output table** is defined in Hive. This is where the Omniture data will be ingested into. Genearlly this will be the same place your SnowPlow events table is saved (if you are adding Omniture data to an existing SnowPlow installation, **or** a new location if you are e.g. testing SnowPlow analyses on Omniture data.)

4. The data transfer is run, mapping fields from the Omniture logs onto the appropriate fields in SnowPlow.

The actual queries corresponding to each of the above steps can be found in the [omniture-ingest.q](https://github.com/snowplow/snowplow-omniture-ingest/blob/master/hive/omniture-ingest.q) file.

## Running the Hive version in batch-mode 

You can either run the queries by pasting them directly into the Hive console, or in batch mode by running:

	$ OMNITURE_LOGS_LOCATION=s3://{{enter bucket and folder(s) here pointing at folder in S3 containing Omniture logs}}
	$ SNOWPLOW_DATA_LOCATION=s3://{{enter appropriate bucket and folder(s) here where SnowPlow data will be imported into}}
	$ ./elastic-mapreduce --create --name "omniture ingest" \
		--hive-script --arg s3://{{enter location of omniture-ingest.q}} \
		--args -d OMNITURE_LOGS_LOCATION=$OMNITURE_LOGS_LOCATION \
		--args -d SNOWPLOW_DATA_LOCATION=$SNOWPLOW_DATA_LOCATION

## Omniture table definitions: what has and has not been mapped

The below table lists all of the fields in the Omniture log files, and indicates if they have been mapped, if so, where they have been mapped to, and indicates any fields that are still to be mapped into SnowPlow.


| **FIELD**      | **DESCRIPTION**   | **MAPPED?**          | **DESCRIPTION OF MAPPING**                          |
|:---------------|:------------------|:---------------------|:----------------------------------------------------|
| `hit_time_gmt` | Event time        | Will not be included | We use `date_time` field instead                    |
| `service`      | pe (page event) or ss  | Will not be included | Deprecated field                               |
| `accept_language`| Accept language header from browser | Yes | Direct mapping: `br_lang`                        |
| `date_time`      | Time (recorded by Omniture servers) | Yes | Mapped to `dt` and `tm`                            |
| `visid_high`   | 1st part of user_id | Yes             | Mapped to `user_id`: `user_id` = CONCAT(`visid_high`, `visid_low`) |
| `visid_low`    | 2nd part of user_id | Yes             | Mapped to `user_id`: `user_id` = CONCAT(`visid_high`, `visid_low`) |
| `event_list`   | Comma separated list of numeric IDs, representing events passed in from the customer | Potential todo | Need to work out when / how this is used |
| `homepage`     | Homepage flag     | Will not be included | Redundant (easy to deduce if homepage view from `page_url` |
| `ip`           | IP Address        | Yes                  | Direct mapping: `ip_address`                        |
| `page_event    |                   | In progress          | Need to map fields looked up by `page_event` (normal, download, exit, custom) to `event_name` |
| `page_event_var_1` | Related to the `page_event` column. URL of the download link, exit link or custom link clicked. | Will not be included | We use `click_action_type` column instead |
| `page_type`    | Only used for error pages | Will not be included | Hard to see the value of this field         |
| `page_url`    | URL of the page view | Yes                | Direct mapping: `page_url`                          |
| `pagename`    | The title of the page | Yes               | Direct mapping: `page_title`                        |
| `product_list`| The product list as passed in through the javascript | In progress | Need to work out the format of the JSON, and create multiple lines in SnowPlow that correspond to each product (`ti_sku` / `ti_name`) in the list | 
| `user_server` | Custom insight variable for servers | No  | Not clear if there is a generic mapping for Omniture -> SnowPlow custom variables (needs to be client specific) |
| `channel`     | Custom insight variable for site sections (chnanels) |  No  | Not clear if there is a generic mapping for Omniture -> SnowPlow custom variables (needs to be client specific) |
| `prop1` -> `prop50` | Custom insight variables (50 in total) | No  | Not clear if there is a generic mapping for Omniture -> SnowPlow custom variables (needs to be client specific) |
| `purchaseid`  | Unique dientifier for purchase | Yes     | Direct mapping: `tr_orderid` **and** `ti_orderid` |
| `referrer`    | Page prior to the current page | Yes     | Direct mapping: `page_referrer` |
| `state`       | Geographical region (e.g. Arizona) passed in on Javascript. Normally only set on purchase page. | Yes | Direct mapping: `tr_state` |
| `user_agent`  | User agent from HTTP header    | In progress | Range of Browser, Operating System and Device related fields we can set with this - need to decide which we use. |
| `zip`         | Zip code passed in on javascript. Usually only set on purchase page | No | Not useful? |
| `search_engine` | Search engine ID             | In progress | Want to use this as one input to set `mkt_source`, `mkt_medium`. Need to develop the function to do this. Also need to work out how to query the lookup table. |
| `exclude_hit` | Hit excluded by client rule    | In progress | Need to incorporate logic that ignores any row where this is set |
| `hier1` -> `hier5` | Delimited list of values passed in on an image request | No | Not clear if there is a generic mapping for Omniture -> SnowPlow custom variables (needs to be client specific) |
| `browser`     | Browser ID (has lookup table)  | In progress | Need to work out how to get contents of browser lookup table. (And whether this is constant across Omniture instances.) If so, browser fields can be derived from this dirctly, rather than the `user_agent` field |
| `post_browser_height` | Height in pixels of browser window | Yes | Direct mapping: `dvce_screenheight` |
| `post_browser_width`  | Width in pixels of browser window  | Yes | Direct mapping: `dvce_screenwidth`  |
| `post_cookies` | Flag to indicate whether a Javascript session cookie is accepted | Yes | Direct mapping: `br_cookies` |
| `post_java_enabled` | Flag indicated whether or not Java is enabled | Yes | Funcional mapping: `br_features`. |
| `post_persistent_cookie`| Flag indicating if 3rd party cookies and / or persistent cookies are enabled | In progress | Need to add a new field for this in SnowPlow? |
| `connection_type` | Connection type ID (has lookup table) | Yes | Direct mapping: `connection_type`. Need to work out how to lookup associated table |
| `country`    | Country ID (has lookup table)              | No  | We use `geo_country` field instead |
| `domain`     | Domain of users ISP                        | Yes | Direct mapping: `domain` |
| `post_t_time_info | Raw time info from javascript         | No  | Use `date_time` instead  |
| `javascript` | Javascript version                         | Yes | Direct mapping: `br_jsversion` |
| `language`   | Language ID (has lookup table)             | No  | Currently us `accept_language`  instead. Is that the best approach? |
| `os`         | Operating System ID (has lookup table)     | In progress | Either need to use lookup table to populate OS fields, or deduce from `user_agent` |
| `plugins`    | List of plugin IDs available to browser (has lookup table) | In progress | Need to use lookup table and map onto `br_features` |
| `resolution` | Resolution ID (has lookup table)           | In progress | Functional mapping: `dvce_screenwidth` and `dvce_screenheight` |
| `last_hit_time_gmt` | Time of the previous record         | No | Redundant data (no additional information provided) |
| `first_hit_time_gmt`| Time of first hit in GMT            | No | Redundant data (no additional information provided) |
| `visit_start_time_gmt`| The gmt timestamp of the first pageview in this visit | No | Redundant data (no additional information provided) |
| `last_purchase_time_gmt` | The time of previous purchase record | No | Redundant data (no additional information provided) |
| `last_purchase_num` | The purchase number of the previous record | No| Redundant data (no additional information provided) | 
| `first_hit_page_url`| The original entry page URL         | No   | Redundant data (no additional information provided) |
| `first_hit_pagename`| Original entry page title           | No   | Redundant data (no additional information provided) |
| `first_hit_referrer`| Original referrer - referre of the first hit ever for the visit | No | Redundant data (no additional information provided) |
| `visit_referrer`    | Referrer for this visit             | Yes | Direct mapping: `mkt_referrerurl` |
| `visit_search_engine`| The search engine used to find the site | No | Ignored: use `search_engine_id` instead |
| `visit_num`         | The number of the current visit     | Yes | Direct mapping: `visit_id` |
| `visit_page_num`    | The page sequence number in the current visit | No | Redundant data (no additional information provided) | 
| `prev_page`         | The page id of the previous page - internal ID not used by the customer | No | Ignore |
| `geo_city`          | City from Digital Envoy             | Yes | Direct mapping: `geo_city` |
| `geo_country`       | Country from Digital Envoy          | Yes | Direct mapping: `geo_country` |
| `geo_region`        | Region / State from Digital Envoy   | Yes | Direct mapping: `geo_region` |
| `duplicate_purchase`| A flag indicating that the purchase event for this hit should be ignored because it's a duplicate | In progress | Need to build in logic to ignore rows where this flag is set to `TRUE` |
| `new_visit`         | A flag that determines if the current hit is a new visit | No | Redundant data (no additional information provided) |
| `daily_visitor`     | Flag to determine if current hit is a new daily visitor  | No | Redundant data (no additional information provided) |
| `hourly_visitor`    | Flag to determine if current hit is a new hourly visitor | No | Redundant data (no additional information provided) |
| `monthly_visitor`   | Flag to determine if current hit is a new monthly visitor| No | Redundant data (no additional information provided) |
| `yearly_visitor`    | Flag to determine if current hit is a new yearly visitor | No | Redundant data (no additional information provided) |
| `post_campaign`     | Campaign                            | Yes | Direct mapping: `mkt_campaign` |
| `evar1` -> `evar50` | Custom commerce variables           | No  | Not clear if there is a generic mapping for Omniture -> SnowPlow custom variables (needs to be client specific) |
| `post_evar1` -> `post_evar50` | Custom commerce variables | No  | Not clear if there is a generic mapping for Omniture -> SnowPlow custom variables (needs to be client specific) |
| `click_action`      | Click map info: this is what is contained in the address the link the user clicked on (URL / JS function) | Yes | Direct mapping: `click_targeturl` |
| `click_action_type` | Click map info: type of link clicked on | In progress | Need to create a functional mapping between Omniture `click_action_type` and SnowPlow `click_targettype` |
| `click_context`     | Click map info: title or URL of page where link was clicked | No |
| `click_context_type`| Click map info: type of click_context (whether a page title or URL was used) | No | 
| `click_sourceid`    | Click map info: numeric ID of the location of the page where the link was clicked | In progress | Need to create a functional mapping between Omniture `click_sourceid` and SnowPlow `click_sourceid` |
| `click_tag`         | Click map info: type of link / form element that was clicked on | No | 



