SELECT ROUND(AVG(LAT_N), 4) AS median
FROM (
    SELECT LAT_N,
           ROW_NUMBER() OVER (ORDER BY LAT_N) AS row_num,
           COUNT(*) OVER () AS total_rows
    FROM STATION
) AS subquery
WHERE row_num IN (
    (total_rows + 1) / 2, -- Middle row for odd total_rows
    (total_rows + 2) / 2  -- Middle row for even total_rows
);