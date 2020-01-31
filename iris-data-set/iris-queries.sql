SELECT * FROM memory.default.iris;

SELECT histogram(floor(petallengthcm)) FROM iris;

SELECT floor(petallengthcm) k, count(*) v FROM iris GROUP BY 1 ORDER BY 2 DESC;

SELECT map_agg(k, v) FROM (SELECT floor(petallengthcm) k, count(*) v FROM iris GROUP BY 1);

SELECT multimap_agg(species, petallengthcm) FROM iris;

SELECT histogram(floor(petallengthcm)) x FROM iris GROUP BY species;

SELECT map_union(m)
FROM (SELECT histogram(floor(petallengthcm)) m FROM iris GROUP BY species);


SELECT species, 
       AVG(petallengthcm), MAX(petallengthcm), MIN(petallengthcm) 
FROM iris
GROUP BY species

-- Window functions

SELECT avg(sepallengthcm) FROM memory.default.iris;

SELECT avg(sepallengthcm) FROM memory.default.iris 
WHERE species = 'setosa';

SELECT species, sepallengthcm, 
  avg(sepallengthcm) OVER() AS avgsepal 
FROM memory.default.iris

SELECT species, sepallengthcm, 
  avg(sepallengthcm) OVER(PARTITION BY species) AS avgsepal 
FROM memory.default.iris;

SELECT DISTINCT species, 
  avg(sepallengthcm) OVER(PARTITION BY species) AS avgsepal 
FROM memory.default.iris;

SELECT DISTINCT species, 
  min(sepallengthcm) OVER(PARTITION BY species) AS minsepal,
  avg(sepallengthcm) OVER(PARTITION BY species) AS avgsepal,
  max(sepallengthcm) OVER(PARTITION BY species) AS maxsepal
FROM memory.default.iris;

