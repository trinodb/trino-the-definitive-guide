SELECT * FROM memory.default.iris;

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

