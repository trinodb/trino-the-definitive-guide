# Flight Data Set

As mentioned in the Presto Resources section in the Introduction chapter in the
book, the Flight Data Set is a complex data set including a few tables with
lookup as well as transaction data.

This directory contains instructions and resources to use the data set to
reproduce the queries as used in the book.

## Tables in PostgreSQL

The two tables `airport` and `carrier` are available as SQL scripts to create
the content in a PostgreSQL server. These are small lookup tables that can be
easily managed by an RDBMS.

After installing PostgreSQL use pgAdmin to perform the following steps:

* Create a schema `airline` in the default `postgres` database.
* Use the query tool to run `carrier.sql` to get the `carrier` table created in
  the `airline` schema.
* Use the query tool to run `airport.sql` to get the `airport` table created in
  the `airline` schema.
* Adapt the content of the PostgreSQL catalog file `postgresql.properties` to
  point to your PostgreSQL server and update username and password.
* Copy the PostgreSQL catalog file into the `etc/catalog` folder of your Presto
  coordinator, and potentially workers.
* Start your Presto server or cluster.
* Start your Presto CLI or a JDBC tool and test with the queries in
  `flight-queries.sql`.

## Data in Object Storage

The transactional data for all the flights is stored in a distributed object
storage system such as Hadoop or S3.

As usual Presto needs the meta data in the Hive metastore.

You can download CSV files from the United States Department of Transportation
website, specifically the Bureau of Transportation Statistics.

The page at https://www.transtats.bts.gov/DL_SelectFields.asp?Table_ID=236
allows you to download data for _Reporting Carrier On-Time Performance
(1987-present)_.

Perform these steps to follow get the flights data:

* Visit the URL above
* Select the desired geography, year, and month 
* Select all field names
* Press the _Download_ button
* Repeat for as many years and months as desired

Now you can use the CSV files to populate your object storage and configure Presto: 

* Copy the downloaded CSV file into your object storage
* Create a suitable Presto catalog file e.g. `hive.properties` using the Hive
  connector as explained in the Connectors chapter in the book.
* Update the `flights_orc.sql` with the location of your external storage 
* Run the SQL in `flights_orc.sql` to create the table information in the Hive
  metastore, pointing at the external files.

