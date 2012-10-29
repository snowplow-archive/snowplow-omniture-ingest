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

TO WRITE

## Mappings that have not yet been included as part of this version of the ingest

TO WRITE
