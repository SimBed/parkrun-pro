SELECT
  date,
COUNT(time) AS count,
MIN(time) AS fastest,
MAX(time) AS slowest,
percentile_cont(0.5) WITHIN GROUP (ORDER BY time) AS median,
AVG(time) AS mean,
STDDEV(time) AS stddev,
AVG(
  CASE
    WHEN agegroup ~ '\d+-\d+' THEN
      (
        substring(agegroup FROM '\d+')::int +
        substring(agegroup FROM '-(\d+)')::int
      ) / 2.0
    WHEN agegroup ~ '\d+' THEN
      substring(agegroup FROM '\d+')::int
    ELSE NULL
  END
) AS avg_age
FROM runs
GROUP BY date;