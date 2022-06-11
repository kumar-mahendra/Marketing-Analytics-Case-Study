/*
Generate Movies Recommendations based on top actor.
*/

/* 
    Generate a table which contain unwatched movies of top_actor by each customer along with a column indicating popularity of movie (i.e. no of people who actually saw that movie)
    First assume customer has not watched any movie of any actor , 
    then remove those movies from list which customer has watched
    and then those movies which are already recommended to customer in top 2 categories. 

*/

/*

Preview Output 

| film_id | film_name        | actor_id | actor_name       |
| ------- | ---------------- | -------- | ---------------- |
| 1       | ACADEMY DINOSAUR | 1        | PENELOPE GUINESS |
| 1       | ACADEMY DINOSAUR | 10       | CHRISTIAN GABLE  |
| 1       | ACADEMY DINOSAUR | 20       | LUCILLE TRACY    |
| 1       | ACADEMY DINOSAUR | 30       | SANDRA PECK      |
| 1       | ACADEMY DINOSAUR | 40       | JOHNNY CAGE      |
*/

DROP TABLE IF EXISTS films_with_actors_table; 
CREATE TABLE films_with_actors_table AS ( 
WITH t1 AS (
    SELECT
      film_id,
      title as film_name
    FROM
      dvd_rentals.film
  )
SELECT
  t1.film_id,
  t1.film_name,
  t2.actor_id,
  (t3.first_name || ' ' || t3.last_name) AS actor_name
FROM
  t1
  INNER JOIN dvd_rentals.film_actor AS t2 ON t1.film_id = t2.film_id
  INNER JOIN dvd_rentals.actor AS t3 ON t3.actor_id = t2.actor_id
ORDER BY film_id , actor_id); 


/*
Preview Output 

| film_id | film_popularity |
| ------- | --------------- |
| 103     | 34              |
| 738     | 33              |
| 382     | 32              |
| 730     | 32              |
| 331     | 32              |

*/

DROP TABLE IF EXISTS film_popularity_table; 
CREATE TABLE film_popularity_table AS ( 
WITH temp_table AS ( 
SELECT t2.film_id FROM dvd_rentals.rental AS t1 INNER JOIN dvd_rentals.inventory AS t2 ON t1.inventory_id = t2.inventory_id )
SELECT film_id , COUNT(*) AS film_popularity FROM temp_table GROUP BY film_id ); 
SELECT * FROM film_popularity_table ORDER BY film_popularity DESC LIMIT 5; 

/*
Preview Output 

| customer_id | film_id | film_name           | actor_id | actor_name | film_popularity |
| ----------- | ------- | ------------------- | -------- | ---------- | --------------- |
| 1           | 697     | PRIMARY GLASS       | 37       | VAL BOLGER | 27              |
| 1           | 572     | METROPOLIS COMA     | 37       | VAL BOLGER | 26              |
| 1           | 12      | ALASKA PHANTOM      | 37       | VAL BOLGER | 26              |
| 1           | 989     | WORKING MICROCOSMOS | 37       | VAL BOLGER | 25              |
| 1           | 555     | MALLRATS UNITED     | 37       | VAL BOLGER | 25              |

*/


  DROP TABLE IF EXISTS top_actor_film_popularity; 
  CREATE TABLE top_actor_film_popularity AS (
  WITH temp_table AS (
    SELECT
      t1.film_id,
      t1.film_name, 
      t1.actor_id, 
      t1.actor_name,
      t2.film_popularity
    FROM
      films_with_actors_table AS t1
    INNER JOIN film_popularity_table AS t2 ON t1.film_id = t2.film_id
  )
SELECT
  t1.customer_id, 
  t2.film_id,
  t2.film_name, 
  t2.actor_id, 
  t2.actor_name,
  t2.film_popularity
FROM
  top_actor_table AS t1
  INNER JOIN temp_table AS t2 ON t1.actor_id = t2.actor_id
ORDER BY customer_id, actor_id, film_popularity DESC); 

SELECT * FROM top_actor_film_popularity;

/*------------------------------------------------------------------------------------------------------*/

/*
Preview Output 

| customer_id | film_id | film_name        | actor_id | actor_name | film_popularity |
| ----------- | ------- | ---------------- | -------- | ---------- | --------------- |
| 1           | 10      | ALADDIN CALENDAR | 37       | VAL BOLGER | 23              |
| 1           | 12      | ALASKA PHANTOM   | 37       | VAL BOLGER | 26              |
| 1           | 19      | AMADEUS HOLY     | 37       | VAL BOLGER | 21              |
| 1           | 118     | CANYON STOCK     | 37       | VAL BOLGER | 19              |

*/
DROP TABLE IF EXISTS actor_based_film_recommendations;
CREATE TABLE actor_based_film_recommendations AS (
WITH temp_table AS ( 
SELECT
  *
FROM
  top_actor_film_popularity AS t1
WHERE
  NOT EXISTS (
    SELECT
      1
    FROM
      base_table_category_insights AS base
    WHERE
      base.customer_id = t1.customer_id
      AND base.film_id = t1.film_id
  ))
  SELECT t1.*  FROM temp_table AS t1 WHERE NOT EXISTS ( SELECT 1 FROM film_recommendations_category_table AS t2 WHERE t1.customer_id = t2.customer_id AND t1.film_name = t2.film_name)
  );


  /*

Top 3 recommendations 

Preview Output 

| customer_id | actor_name     | recommend_rank | film_name         |
| ----------- | -------------- | -------------- | ----------------- |
| 1           | VAL BOLGER     | 1              | PRIMARY GLASS     |
| 1           | VAL BOLGER     | 2              | ALASKA PHANTOM    |
| 1           | VAL BOLGER     | 3              | METROPOLIS COMA   |
| 2           | GINA DEGENERES | 1              | GOODFELLAS SALUTE |

*/

DROP TABLE IF EXISTS top_3_actor_based_recommendations; 
CREATE TEMP TABLE top_3_actor_based_recommendations AS ( 
WITH temp_table AS ( 
SELECT *, DENSE_RANK() OVER ( PARTITION BY customer_id ORDER BY film_popularity DESC , film_name ) AS recommend_rank  FROM actor_based_film_recommendations
)
SELECT customer_id, actor_name, recommend_rank, film_name FROM temp_table WHERE recommend_rank <= 3
);

SELECT * FROM top_3_actor_based_recommendations LIMIT 4;



