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
WITH RankedData AS (
    SELECT LAT_N,
           ROW_NUMBER() OVER (ORDER BY LAT_N) AS RowAsc,
           COUNT(*) OVER () AS TotalRows
    FROM STATION
)
SELECT ROUND(
           CASE
               WHEN TotalRows % 2 = 1 THEN  -- Odd number of rows
                   (SELECT LAT_N FROM RankedData WHERE RowAsc = (TotalRows + 1) / 2)
               ELSE  -- Even number of rows
                   (SELECT AVG(LAT_N) FROM RankedData WHERE RowAsc IN (TotalRows / 2, TotalRows / 2 + 1))
           END,
           4
       ) AS Median_Latitude
FROM RankedData
LIMIT 1;