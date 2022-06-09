/*
Left Table : film_category 
---------------------------
columns used : film_id, category_id 

Right Table : category
---------------------------
columns used : category_id
*/

-------------------------------------------------------------

/*
Q : Are there duplicates in category_id column of category?
A : No
J : for each category_id there is unique rows so no duplicates. 

| category_id | frequency |
| ----------- | --------- |
| 10          | 1         |
| 6           | 1         |
| 13          | 1         |
| 2           | 1         |
| 4           | 1         |

sql query
*/

SELECT
  category_id,
  COUNT(*) as frequency
FROM
  dvd_rentals.category
GROUP BY
  category_id
ORDER BY
  frequency DESC
LIMIT
  5;

/*
Q : Do foreign Key analysis and Determine the type of Join to use. 
A : Inner Join
J : 

| total_unique_category_id_right | total_unique_category_id_left | total_unique_left_and_right | total_unique_only_left | total_unique_only_right |
| ------------------------------ | ----------------------------- | --------------------------- | ---------------------- | ----------------------- |
| 16                             | 16                            | 16                          | 0                      | 0                       |

*/

WITH table_1 AS  ( 
SELECT COUNT(DISTINCT category_id) AS total_unique_category_id_right FROM dvd_rentals.category ), 
table_2 AS ( 
SELECT COUNT(DISTINCT category_id) AS total_unique_category_id_left FROM dvd_rentals.film_category), 
table_3 AS ( 
SELECT COUNT(DISTINCT category_id) AS total_unique_left_and_right FROM dvd_rentals.film_category WHERE EXISTS( SELECT 1 FROM dvd_rentals.category WHERE film_category.category_id = category.category_id )),
table_4 AS ( 
SELECT COUNT(DISTINCT category_id) AS total_unique_only_left FROM dvd_rentals.film_category WHERE NOT EXISTS( SELECT 1 FROM dvd_rentals.category WHERE film_category.category_id = category.category_id )),
table_5 AS ( 
SELECT COUNT(DISTINCT category_id) AS total_unique_only_right FROM dvd_rentals.category WHERE NOT EXISTS( SELECT 1 FROM dvd_rentals.film_category WHERE film_category.category_id = category.category_id ))
SELECT * FROM table_1, table_2, table_3, table_4, table_5 

-------------------------------------------------------------

/*
So we can use any of inner join or left join as all category_id 
of film_category table are there in category table and category_id 
column has no dupliates in category table. 
*/
