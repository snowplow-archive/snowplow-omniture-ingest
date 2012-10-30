# Snowplow-Omniture-Ingest

## What it does

SnowPlow-Omniture-Ingest is a module for importing data from Omniture, provided in the form of log files from the Omniture Data Feed, into SnowPlow so that SnowPlow analytics can be performed on that data.

The module outputs Omniture Data into SnowPlow as Hive defined flat files in S3. It would be straightforward to extend the functionality to import Omniture data into the Infobright version of SnowPlow. However, this has not been prioritised, to date. (If this functionality is desired, then let us know.)

## Versions available

Two versions of the program are available in this repo:

1. [A Hive-based version](/snowplow/snowplow-omniture-ingest/tree/master/hive). This is operational. However, the code base is changing as we make incremental improvements to the module.
2. [A Scalding / Cascading-based version](/snowplow/snowplow-omniture-ingest/tree/master/scalding). This version is currently in development. 

## Process for running

In both cases, the overall process for importing the data into SnowPlow is broadly the same:

1. Create a bucket / folder in S3 for storing the raw data feed from Omniture, and transfer the files into it
2. Run the module, specifying the input location of the Omniture files in S3, and the output location in S3 where the SnowPlow formatted data should be created. (This might be directly on top of your current SnowPlow data, or more likely in a new location in S3 especially for it.)

More details on running each version can be found in it's separate folder e.g. [here](/snowplow/snowplow-omniture-ingest/tree/master/hive) for the Hive version.

## Dependencies

Both versions of the ETL make use [@msukmanowsky](https://github.com/msukmanowsky)'s [OmnitureDataFileInputFormat](https://github.com/msukmanowsky/OmnitureDataFileInputFormat) to handle (i.e. ignore) the escaped tabs and new line characters that are often present in field values in the Omniture log files. We maintain a version of his code [here](https://github.com/snowplow/omniture-data-file-input-format), and a compiled version of his JAR is (publically available) from `s3://snowplow-emr-assets/hadoop/omniture-ingest/omniture-data-file-input-format-0.0.1.jar`