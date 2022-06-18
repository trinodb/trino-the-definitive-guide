SHOW SCHEMAS FROM tpch;

SHOW SCHEMAS IN tpch LIKE '%3%';

CREATE SCHEMA abyss.test;
CREATE TABLE abyss.test.orders AS SELECT * from tpch.tiny.orders;
INSERT INTO abyss.test.orders SELECT * FROM tpch.sf3.orders;

DESCRIBE tpch.tiny.nation;

EXPLAIN
SELECT name FROM tpch.tiny.region;

EXPLAIN (TYPE VALIDATE)
SELECT name FROM tpch.tiny.region;


SELECT nationkey, name, regionkey 
FROM tpch.sf1.nation;

SELECT custkey, nationkey, phone, acctbal, mktsegment
FROM tpch.tiny.customer;

SELECT acctbal, round(acctbal) FROM tpch.sf1.customer;

SELECT custkey, acctbal
FROM tpch.sf1.customer WHERE acctbal < 0; 

SELECT custkey, acctbal FROM tpch.sf1.customer WHERE acctbal > 0 AND acctbal < 500;

SELECT mktsegment
FROM tpch.sf1.customer
GROUP BY mktsegment;

SELECT mktsegment, round(sum(acctbal) / 1000000, 3) AS acctbal_millions
FROM tpch.sf1.customer
GROUP BY mktsegment;

SELECT round(sum(acctbal) / 1000000, 3) AS acctbal_millions
FROM tpch.sf1.customer;

SELECT mktsegment,
      round(sum(acctbal), 1) AS acctbal_per_mktsegment
FROM tpch.tiny.customer
GROUP BY mktsegment
HAVING round(sum(acctbal), 1) > 5283.0;

SELECT mktsegment,
       round(sum(acctbal), 1) AS acctbal_per_mktsegment
FROM tpch.tiny.customer
GROUP BY mktsegment
HAVING round(sum(acctbal), 1) > 1300000;

SELECT mktsegment,
       round(sum(acctbal), 2) AS acctbal_per_mktsegment
FROM tpch.sf1.customer
GROUP BY mktsegment
HAVING sum(acctbal) > 0
ORDER BY acctbal_per_mktsegment DESC
LIMIT 1;

SELECT custkey, mktsegment, nation.name AS nation
FROM tpch.tiny.nation JOIN tpch.tiny.customer
ON nation.nationkey = customer.nationkey;

SELECT custkey, mktsegment, nation.name AS nation
FROM tpch.tiny.nation, tpch.tiny.customer
WHERE nation.nationkey = customer.nationkey;

SELECT mktsegment,
  round(sum(acctbal), 2) AS total_acctbal,
  GROUPING(mktsegment) AS id
FROM tpch.tiny.customer
GROUP BY ROLLUP (mktsegment)
ORDER BY id, total_acctbal;

SELECT nation.name AS nation, region.name AS region
FROM tpch.sf1.region, tpch.sf1.nation
WHERE region.regionkey = nation.regionkey
AND region.name LIKE 'AFRICA'
ORDER by nation;

SELECT nation.name || ' / ' || region.name AS Location
FROM tpch.sf1.region JOIN tpch.sf1.nation
ON region.regionkey = nation.regionkey
AND region.name LIKE 'AFRICA'
ORDER BY Location;

SELECT
    n.name AS nation_name,
    avg(extendedprice) as avg_price
FROM nation n, orders o, customer c, lineitem l
WHERE n.nationkey = c.nationkey
  AND c.custkey = o.custkey
  AND o.orderkey = l.orderkey
GROUP BY n.nationkey, n.name
ORDER BY nation_name;

SELECT
    n.name AS nation_name,
    avg(extendedprice) as avg_price
FROM nation n, orders o, customer c, lineitem l
WHERE n.nationkey = c.nationkey
  AND c.custkey = o.custkey
  AND o.orderkey = l.orderkey
  AND l.partkey = 638
GROUP BY n.nationkey, n.name
ORDER BY nation_name;

SELECT mktsegment,
       round(sum(acctbal), 2) AS total_acctbal,
       0 AS id
FROM tpch.tiny.customer
GROUP BY mktsegment
UNION
SELECT NULL, round(sum(acctbal), 2), 1
FROM tpch.tiny.customer
ORDER BY id, total_acctbal;

SELECT mktsegment,
       total_per_mktsegment,
       average
FROM 
  (
    SELECT mktsegment,
       round(sum(acctbal)) AS total_per_mktsegment
    FROM tpch.tiny.customer
    GROUP BY 1
  ),
  (
    SELECT round(avg(total_per_mktsegment)) AS average
    FROM 
      (
        SELECT mktsegment,
           sum(acctbal) AS total_per_mktsegment
        FROM tpch.tiny.customer
        GROUP BY 1
      )
  ) 
WHERE total_per_mktsegment > average;

WITH total AS (
  SELECT mktsegment,
    round(sum(acctbal)) AS total_per_mktsegment
  FROM tpch.tiny.customer
  GROUP BY 1
),
average AS (
  SELECT round(avg(total_per_mktsegment)) AS average
  FROM total
)
SELECT mktsegment,
  total_per_mktsegment,
  average
FROM total,
  average
WHERE total_per_mktsegment > average;

SELECT regionkey, name
FROM tpch.tiny.nation
WHERE regionkey = 
  (SELECT regionkey FROM tpch.tiny.region WHERE name LIKE 'AMERICA');


USE tpch.tiny;

SELECT
  nation,
  o_year,
  sum(amount) AS sum_profit
FROM (
       SELECT
         N.name AS nation,
         extract(YEAR FROM o.orderdate)AS o_year,
         l.extendedprice * (1 - l.discount) - ps.supplycost * l.quantity AS amount
       FROM
         part AS p,
         supplier AS s,
         lineitem AS l,
         partsupp AS ps,
         orders AS o,
         nation AS n
       WHERE
         s.suppkey = l.suppkey
         AND ps.suppkey = l.suppkey
         AND ps.partkey = l.partkey
         AND p.partkey = l.partkey
         AND o.orderkey = l.orderkey
         AND s.nationkey = n.nationkey
         AND p.name LIKE '%green%'
     ) AS profit
GROUP BY
  nation,
  o_year
ORDER BY
  nation,
  o_year DESC;


SELECT name
FROM tpch.tiny.nation
WHERE regionkey IN (SELECT regionkey FROM tpch.tiny.region);

SELECT name
FROM nation
WHERE regionkey = ANY (SELECT regionkey FROM region);

SELECT name
FROM nation
WHERE regionkey IN (SELECT regionkey FROM region);

SELECT name FROM nation;

SELECT
    (SELECT name FROM region r WHERE regionkey = n.regionkey)
        AS region_name,
    n.name AS nation_name,
    sum(totalprice) orders_sum
FROM nation n, orders o, customer c

WHERE n.nationkey = c.nationkey
  AND c.custkey = o.custkey
GROUP BY n.nationkey, regionkey, n.name
ORDER BY orders_sum DESC
LIMIT 5;

SELECT DISTINCT o.orderkey
FROM lineitem l
  JOIN orders o ON o.orderkey = l.orderkey
  JOIN customer c ON o.custkey = c.custkey
WHERE c.nationkey IN (                          
    -- All nations for all suppliers of an item
    SELECT s.nationkey
    FROM part p
      JOIN partsupp ps ON p.partkey = ps.partkey
      JOIN supplier s ON ps.suppkey = s.suppkey
    WHERE p.partkey = l.partkey
);

SELECT
    n.name AS nation_name,
    avg(extendedprice) as avg_price
FROM nation n, orders o, customer c, lineitem l
WHERE n.nationkey = c.nationkey
  AND c.custkey = o.custkey
  AND o.orderkey = l.orderkey
GROUP BY n.nationkey, n.name;