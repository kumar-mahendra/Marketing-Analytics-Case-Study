/*
Left Table : film
----------------------
columns used : film_id 

Right Table : film_category
---------------------------------
columns used : film_id, category_id
*/
 
 ---------------------------------------------------------------
/*
Q : Are there duplicates in film_id in film_category table ?  
A : No
J : No all entries are unique in film_id

| total_rows | distinct_film_id |
| ---------- | ---------------- |
| 1000       | 1000             |

sql query
*/

SELECT
COUNT(*) as total_rows,
COUNT(DISTINCT film_id) as distinct_film_id
FROM
dvd_rentals.film_category

---------------------------------------------------------------
/*
Q : Can a movie belong to more than one category ? Also find 
    count of movies in each category. 
A : No
J : It is clear from previous output that every film_id is appearing only 
    once so unless there is some discrepencies in category_id column, It is 
    not possible that film_id can have two category_id e.g. 

    dummy example showing discrepensies

    |film_id | category_id |
    | 122    | 1,2 |

| category_id | movies_count_category | percentage |
| ----------- | --------------------- | ---------- |
| 1           | 64                    | 6.40       |
| 2           | 66                    | 6.60       |
| 3           | 60                    | 6.00       |
| 4           | 57                    | 5.70       |
| 5           | 58                    | 5.80       |
| 6           | 68                    | 6.80       |
| 7           | 62                    | 6.20       |
| 8           | 69                    | 6.90       |
| 9           | 73                    | 7.30       |
| 10          | 61                    | 6.10       |
| 11          | 56                    | 5.60       |
| 12          | 51                    | 5.10       |
| 13          | 63                    | 6.30       |
| 14          | 61                    | 6.10       |
| 15          | 74                    | 7.40       |
| 16          | 57                    | 5.70       |
/

SQL query to generate above output
*/

SELECT
  category_id,
  COUNT(*) AS movies_count_category, 
  ROUND( 100*COUNT(*)::NUMERIC / SUM( COUNT(*) ) OVER(), 2 )  AS percentage
FROM
  dvd_rentals.film_category
GROUP BY
  category_id
ORDER BY
  category_id

---------------------------------------------------------------

/*
Q : Determine type of join 
A : Inner Join ( or Left join )  
J : 

| total_unique_film_id_right | total_unique_film_id_left | total_unique_left_and_right | total_unique_only_left | total_unique_only_right |
| -------------------------- | ------------------------- | --------------------------- | ---------------------- | ----------------------- |
| 1000                       | 1000                      | 1000                        | 0                      | 0                       |
*/

WITH table_1 AS  ( 
SELECT COUNT(DISTINCT film_id) AS total_unique_film_id_right FROM dvd_rentals.film_category ), 
table_2 AS ( 
SELECT COUNT(DISTINCT film_id) AS total_unique_film_id_left FROM dvd_rentals.film), 
table_3 AS ( 
SELECT COUNT(DISTINCT film_id) AS total_unique_left_and_right FROM dvd_rentals.film WHERE EXISTS( SELECT 1 FROM dvd_rentals.film_category WHERE film.film_id = film_category.film_id )),
table_4 AS ( 
SELECT COUNT(DISTINCT film_id) AS total_unique_only_left FROM dvd_rentals.film WHERE NOT EXISTS( SELECT 1 FROM dvd_rentals.film_category WHERE film.film_id = film_category.film_id )),
table_5 AS ( 
SELECT COUNT(DISTINCT film_id) AS total_unique_only_right FROM dvd_rentals.film_category WHERE NOT EXISTS( SELECT 1 FROM dvd_rentals.film WHERE film.film_id = film_category.film_id ))
SELECT * FROM table_1, table_2, table_3, table_4, table_5 

---------------------------------------------------------------

/*
So we have now category_id for each film after we perform 
inner join of film table with film_category table .
*/

