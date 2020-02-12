
SHOW SCHEMAS IN postgresql;

SHOW TABLES IN postgresql.airline;

USE postgresql.airline;

SELECT * FROM airport;

SELECT * FROM carrier;

SELECT code, name FROM airport WHERE code = 'ORD';

SELECT state, count(*)
FROM airport
WHERE country = 'US'
GROUP BY state;

SELECT state
FROM airport
WHERE country = 'US';

CREATE view airline.airports_per_us_state AS
SELECT state, count(*) AS count_star
FROM airline.airport
WHERE country = 'US'
GROUP BY state;

SELECT * FROM airports_per_us_state;


CREATE TABLE accumulo.ontime.flights (
    rowid VARCHAR,
    flightdate VARCHAR,
    flightnum, INTEGER,
    origin VARCHAR
    dest VARCHAR
);

CREATE TABLE accumulo.ontime.flights (
    rowid VARCHAR,
    flightdate VARCHAR,
    flightnum, INTEGER,
    origin VARCHAR
    dest VARCHAR
)
WITH
   column_mapping = ‘origin:location:origin,dest:location:dest’
);

CREATE TABLE accumulo.ontime.flights (
    rowid VARCHAR,
    flightdate VARCHAR,
    flightnum, INTEGER,
    origin VARCHAR
    dest VARCHAR
)
WITH
    external = true,
    column_mapping = ‘origin:location:origin,dest:location:dest’
);

SELECT flightnum, origin
FROM flights
WHERE flightdate BETWEEN DATE ‘2019-10-01’ AND 2019-11-05’
AND origin = ‘BOS’;


CREATE TABLE accumulo.ontime.flights (
    rowid VARCHAR,
    flightdate VARCHAR,
    flightnum, INTEGER,
    origin VARCHAR
    dest VARCHAR
)
WITH
    Index_columns = ‘flightdate,origin’
);

SELECT avg(depdelayminutes) AS delay, year
FROM flights_orc
GROUP BY year
ORDER BY year DESC;

SELECT dayofweek, avg(depdelayminutes) AS delay
FROM flights
WHERE month=2 AND origincityname LIKE '%Boston%'
GROUP BY dayofmonth
ORDER BY dayofweek;


SELECT uniquecarrier, count(*) AS ct
FROM flights_orc
GROUP BY uniquecarrier
ORDER BY count(*) DESC
LIMIT 10;

SELECT origin, count(*) AS ct
FROM flights_orc
GROUP BY origin
ORDER BY count(*) DESC
LIMIT 10;

SELECT * FROM carrier LIMIT 10;

SELECT f.uniquecarrier, c.description, count(*) AS ct
FROM hive.ontime.flights_orc f,
    postgres.public.carrier c
WHERE c.code = f.uniquecarrier
GROUP BY f.uniquecarrier, c.description
ORDER BY count(*) DESC
LIMIT 10;

SELECT code, name, city FROM airport LIMIT 10;

SELECT f.origin, c.name, c.city, count(*) AS ct
FROM hive.ontime.flights_orc f,
    postgres.public.airport c
WHERE c.code = f.origin
GROUP BY origin, c.name, c.city
ORDER BY count(*) DESC
LIMIT 10;

SELECT f.origin, c.name, c.city, count(*) AS ct
FROM hive.ontime.flights_orc f,
  postgres.public.airport c
WHERE c.code = f.origin AND c.state = ‘AK’
GROUP BY origin, c.name, c.city
ORDER BY count(*) DESC
LIMIT 10;

SELECT * FROM airline.airport;

SELECT code, city, name FROM airport WHERE state = 'AK';

SELECT dayofweek, avg(depdelayminutes) AS delay 
FROM flights_orc 
WHERE month = 2 AND origincityname LIKE '%Boston%' 
GROUP BY dayofweek
ORDER BY dayofweek;

SELECT avg(arrdelayminutes) AS avg_arrival_delay, carrier
FROM flights_orc
WHERE year > 2010 AND year < 2014
GROUP BY carrier, year;

SELECT count(*) FROM flights_orc WHERE year BETWEEN 2010 AND 2012;

SELECT count(*) FROM flights_orc WHERE year >= 2010 AND year <= 2012;

SELECT avg(DepDelayMinutes) AS delay, year 
FROM flights_orc 
WHERE airtime IS NOT NULL and year >= 2015
GROUP BY year 
ORDER BY year desc;

SELECT origincityname, count(*)
FROM flights_orc
WHERE origincityname LIKE '%Dallas%'
GROUP BY origincityname;

PREPARE example
FROM SELECT count(*) FROM hive.ontime.flights_orc;


PREPARE delay_query FROM
SELECT dayofweek,
       avg(depdelayminutes) AS delay
FROM   flights_orc
WHERE  month = ?
       AND origincityname LIKE ?
GROUP  BY dayofweek
ORDER  BY dayofweek;

EXECUTE delay_query USING 2, '%Boston%';

DESCRIBE INPUT delay_query;

DESCRIBE OUTPUT delay_query;

SELECT count(*) count, year, width_bucket(year, 2010, 2020, 4) bucket
FROM flights_orc 
WHERE year >= 2010
GROUP BY year;

EXPLAIN
SELECT f.uniquecarrier, c.description, count(*) AS ct 
FROM postgresql.airline.carrier c,
     hive.ontime.flights_orc f  
WHERE c.code = f.uniquecarrier
GROUP BY f.uniquecarrier, c.description
ORDER BY count(*) DESC
LIMIT 10;



-- More example queries

-- Airline Queries

--What is an average delay of airplanes by year?
select avg(DepDelayMinutes) as delay, year from flights_orc group by year order by year desc;

-- What is correlation between average delay and airplane congestion?
with number_of_flights as (select count(*) no, year from flights_orc group by year),
       avg_delay as (select avg(depdelayminutes) as delay, year from flights_orc group by year),
       combined as (select no, delay, n.year from number_of_flights n, avg_delay d where n.year = d.year)
select corr(no, delay) from combined;

--What is an average delay of airplane by month in 2014?
select avg(DepDelayMinutes) as delay, month from flights_orc where year = 2014 group by month order by month asc;

-- What are the most popular destinations for flights in 2014
select count(*) as number_of_flights, destcityname from flights_orc where year = 2014 group by destcityname order by number_of_flights desc;

-- When people are flying the most often
select count(*) as number_of_flights, month from flights_orc where year = 2014 group by month order by number_of_flights desc;

-- What are the best days of the week to fly out of Boston in the month of February?
select dayofweek, avg(depdelayminutes) as delay from flights_orc where month=2 AND origincityname like '%Boston%' group by dayofweek order by dayofweek;

-- What airport is the worst airport to make a connection at per airline?
 with avg_arr_delays as (select avg(arrdelay) as arr_delay, carrier from flights_orc where
 dest = 'LAX' group by carrier),
     avg_dept_delays as (select avg(depdelay) as dept_delay, carrier from flights_orc where
  origin = 'LAX' group by carrier),
     time_frames as (select dept_delay - arr_delay as time_frame, a.carrier from avg_arr_delays a, avg_dept_delays d where a.carrier = d.carrier group by (dept_delay - arr_delay), a.carrier),
     min_max as (select min(time_frame) min_time_to_change, carrier from time_frames group
 by carrier)
 select t.* from time_frames t inner join min_max m on t.time_frame = m.min_time_to_change
 order by t.time_frame asc;


-- Query Federation (using Glue)

select f.origin as airport, count(*) as flights
from glue.strata.flights_orc f
group by f.origin
order by flights desc
limit 10;

select code, name from postgresql.airline.airport limit 10;
select code, name from postgresql.airline.airport where code = 'ORD';

select a.name as airport, count(*) as flights
from glue.strata.flights_orc f join postgresql.airline.airport a on f.origin=a.code
group by a.name
order by flights desc
limit 10;

