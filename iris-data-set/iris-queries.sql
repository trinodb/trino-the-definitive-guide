-- Test without session catalog and schema set
SELECT *
FROM memory.default.iris;

-- Set default
USE memory.default;

SELECT histogram( floor(petal_length_cm) )
FROM iris;

SELECT floor(petal_length_cm) k, count(*) v
FROM iris
GROUP BY 1
ORDER BY 2 DESC;

SELECT map_agg(k, v) FROM (SELECT floor(petal_length_cm) k, count(*) v
FROM iris
GROUP BY 1);

SELECT multimap_agg(species, petal_length_cm)
FROM iris;

SELECT histogram( floor(petal_length_cm) ) x
FROM iris
GROUP BY species;

SELECT map_union(m)
FROM (
  SELECT histogram( floor(petal_length_cm) ) m
  FROM iris
  GROUP BY species);


SELECT species,
       AVG(petal_length_cm),
       MAX(petal_length_cm),
       MIN(petal_length_cm)
FROM iris
GROUP BY species;

-- Window functions

SELECT avg(sepal_length_cm)
FROM iris;

SELECT avg(sepal_length_cm)
FROM iris
WHERE species = 'setosa';

SELECT species,
  sepal_length_cm,
  avg(sepal_length_cm)
  OVER()
  AS avg_sepal_length_cm
FROM iris;

SELECT species,
  sepal_length_cm,
  avg(sepal_length_cm)
  OVER(PARTITION BY species)
  AS avg_sepal_length_cm
FROM iris;

SELECT DISTINCT species,
  avg(sepal_length_cm) OVER(PARTITION BY species)
  AS avg_sepal_length_cm
FROM iris;

SELECT DISTINCT species,
  min(sepal_length_cm) OVER(PARTITION BY species) AS min_sepal_length_cm,
  avg(sepal_length_cm) OVER(PARTITION BY species) AS avg_sepal_length_cm,
  max(sepal_length_cm) OVER(PARTITION BY species) AS max_sepal_length_cm
FROM iris;


SELECT species,
 count(*) AS count
FROM iris
GROUP BY species;

SELECT species,
  count(*) AS count
FROM iris
WHERE petal_length_cm > 4
GROUP BY species;

SELECT species,
  count(*) FILTER (where petal_length_cm > 4) AS count
FROM iris
GROUP BY species;