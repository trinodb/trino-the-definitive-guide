# Flight Data Set

As mentioned in the Presto Resources section in the Introduction chapter in the
book, the Flight Data Set is a complex data set including a few tables with
lookup as well as transaction data.

This directory contains instructions and resources to use the data set to
reproduce the queries as used in the book.

## Tables in PostgreSQL

The two tables `airport` and `carrier` are available as SQL scripts to create
the content in a PostgreSQL server:

After installing PostgreSQL use pgAdmin to perform the following steps:

* Create a schema `airline` in the default `postgres` database.
* Use the query tool to run `carrier.sql`.
* Use the query tool to run `airport.sql`.
* Adapt the content of the `postgresql.properties` into the `etc/catalog` folder
  of your Presto server(s).
* Start your Presto cluster.
* Start your Presto CLI or a JDBC tool and test with the queries in
  `flight-queries.sql`.


  ## Data in Object Storage