/*
Left Table : Inventory
------------------------------------
columns used : inventory_id, film_id

Right Table : film
-----------------------------------
columns used : film_id, category_id
*/

-----------------------------------------------------------------
/*
Q : Are there duplicates in film table ? 
A : No 
J : 

| distinct_rows_count | orig_total_rows |
| ------------------- | --------------- |
| 1000                | 1000            |


sql query 
*/
WITH table_1 AS (
  SELECT
    COUNT(DISTINCT film_id) AS distinct_rows_count
  FROM
    dvd_rentals.film
),
table_2 AS (
  SELECT
    COUNT(film_id) as orig_total_rows
  FROM
    dvd_rentals.film
)
SELECT * FROM table_1, table_2


-----------------------------------------------------------------

/*
Q : Are all film_id in inventory_table are there in film table?
A : Yes
J : 

| total_unique_film_id_right | total_unique_film_id_left | total_unique_left_and_right | total_unique_only_left | total_unique_only_right |
| -------------------------- | ------------------------- | --------------------------- | ---------------------- | ----------------------- |
| 1000                       | 958                       | 958                         | 0                      | 42                      |
sql query 
*/

WITH table_1 AS  ( 
SELECT COUNT(DISTINCT film_id) AS total_unique_film_id_right FROM dvd_rentals.film ), 
table_2 AS ( 
SELECT COUNT(DISTINCT film_id) AS total_unique_film_id_left FROM dvd_rentals.inventory), 
table_3 AS ( 
SELECT COUNT(DISTINCT film_id) AS total_unique_left_and_right FROM dvd_rentals.inventory WHERE EXISTS( SELECT 1 FROM dvd_rentals.film WHERE inventory.film_id = film.film_id )),
table_4 AS ( 
SELECT COUNT(DISTINCT film_id) AS total_unique_only_left FROM dvd_rentals.inventory WHERE NOT EXISTS( SELECT 1 FROM dvd_rentals.film WHERE inventory.film_id = film.film_id )),
table_5 AS ( 
SELECT COUNT(DISTINCT film_id) AS total_unique_only_right FROM dvd_rentals.film WHERE NOT EXISTS( SELECT 1 FROM dvd_rentals.inventory WHERE inventory.film_id = film.film_id ))
SELECT * FROM table_1, table_2, table_3, table_4, table_5 

-----------------------------------------------------------------

/*
So we can see we can use INNER JOIN all film_id of inventory 
table are there in film table. It was kind of expected. But there 
are some film_id which are not there in inventory table. It 
could be because of few reasons like 
1) New movies arrived so were not available for renting.
2) Movies are not available for renting. so no record found. 
Talk to source of data to know more about these things. 
*/




