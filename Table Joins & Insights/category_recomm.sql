 /*
 Recommend Top 3  unseen movies for both of top 2 categories
 */

/*    
Generate a table contain movie name , category, and count of customers who watched this movie. 

Preview Output

| film_id | film_name       | total_film_count | category_id | category_name |
| ------- | --------------- | ---------------- | ----------- | ------------- |
| 721     | REDS POCUS      | 9                | 12          | Music         |
| 599     | MOTHER OLEANDER | 14               | 15          | Sports        |
| 719     | RECORDS ZORRO   | 8                | 15          | Sports        |
| 591     | MONSOON CAUSE   | 9                | 10          | Games         |
| 829     | SPINAL ROCKY    | 13               | 8           | Family        |
 
*/

DROP TABLE IF EXISTS intermediate_table_6; 
CREATE TEMP TABLE intermediate_table_6 AS (
 WITH temp_table AS (
  SELECT
    film_id,
    film_name,
    COUNT(*) as total_film_count
  FROM
    base_table_category_insights
  GROUP BY
    film_id,
    film_name
)
SELECT
  t1.*,
  t2.category_id,
  t3.name as category_name
FROM
  temp_table AS t1
  INNER JOIN dvd_rentals.film_category AS t2 ON t1.film_id = t2.film_id
  INNER JOIN dvd_rentals.category AS t3 ON t2.category_id = t3.category_id
); 

SELECT * FROM intermediate_table_6 LIMIT 5; 

/*----------------------------------------------------------------------------------*/

/*
Generate table contains all movies name for each customer for each category which are 
not seen by customer in that category 

| customer_id | film_id | film_name       | total_film_count | category_id | category_name |
| ----------- | ------- | --------------- | ---------------- | ----------- | ------------- |
| 1           | 721     | REDS POCUS      | 9                | 12          | Music         |
| 1           | 599     | MOTHER OLEANDER | 14               | 15          | Sports        |
| 1           | 719     | RECORDS ZORRO   | 8                | 15          | Sports        |
| 1           | 591     | MONSOON CAUSE   | 9                | 10          | Games         |
| 1           | 829     | SPINAL ROCKY    | 13               | 8           | Family        |
*/

DROP TABLE IF EXISTS watched_films_exclusions;
CREATE TABLE watched_films_exclusions AS (
    WITH temp_table AS (
      WITH customer_ids_table AS (
        SELECT
          DISTINCT customer_id
        FROM
          dvd_rentals.rental
        ORDER BY
          customer_id
      )
      SELECT
        *
      FROM
        customer_ids_table,
        intermediate_table_6
    )
    SELECT
      *
    FROM
      temp_table
    WHERE
      NOT EXISTS (
        SELECT
          1
        FROM
          base_table_category_insights AS base
        WHERE
          temp_table.film_id = base.film_id
          AND temp_table.customer_id = base.customer_id
      )
  );

SELECT * FROM watched_films_exclusions;

/*----------------------------------------------------------------------------------*/


/*
Generate table which contain our final table with movie recommendations

| customer_id | category_rank | category_name | film_name           | recommendation_rank |
| ----------- | ------------- | ------------- | ------------------- | ------------------- |
| 1           | 1             | Classics      | TIMBERLAND SKY      | 1                   |
| 1           | 1             | Classics      | GILMORE BOILED      | 2                   |
| 1           | 1             | Classics      | VOYAGE LEGALLY      | 3                   |
| 1           | 2             | Comedy        | ZORRO ARK           | 1                   |
| 1           | 2             | Comedy        | CAT CONEHEADS       | 2                   |
| 1           | 2             | Comedy        | OPERATION OPERATION | 3                   |
*/

DROP TABLE IF EXISTS film_recommendations_category_table;
CREATE TABLE film_recommendations_category_table AS (
WITH temp_table AS (
SELECT
  t1.customer_id,
  t1.category_rank,
  t1.category_name,
  t2.film_name , 
  DENSE_RANK() OVER(
    PARTITION BY t1.customer_id,
    t1.category_rank
    ORDER BY
      t2.total_film_count DESC, 
      t2.film_name   -- In case of ties prefer movie which come alphabetically first. 
  ) AS recommendation_rank
  
FROM
  category_insights AS t1
  INNER JOIN watched_films_exclusions AS t2 ON t1.customer_id = t2.customer_id AND t1.category_name = t2.category_name
) 
SELECT * FROM temp_table WHERE recommendation_rank <= 3
); 

SELECT * FROM film_recommendations_category_table LIMIT 6;   
/*----------------------------------------------------------------------------------*/

  /*
  Now we have 3 recommendations for each customer. 
  Lets check if there is any customer who has not get all 
  3 movie recommendations in any of top 2 groups 
  
  Output 

| category_rank | count_distinct_recommendations | customer_count | total_people_in_database |
| ------------- | ------------------------------ | --------- | ------------------------ |
| 1             | 3                              | 599       | 599                      |
| 2             | 3                              | 599       | 599                      |
  */

  WITH temp_table_2 AS (
    WITH temp_table AS (
      SELECT
        customer_id,
        category_rank,
        category_name,
        COUNT(*) AS count_distinct_recommendations
      FROM
        film_recommendations_category_table
      GROUP BY
        customer_id,
        category_rank,
        category_name
    )
    SELECT
      category_rank,
      count_distinct_recommendations,
      COUNT(DISTINCT customer_id) AS customer_count
    FROM
      temp_table
    GROUP BY
      count_distinct_recommendations,
      category_rank
  )
SELECT
  *
FROM
  temp_table_2
  CROSS JOIN (
    SELECT
      COUNT(DISTINCT customer_id) AS total_people_in_database
    FROM
      base_table_category_insights
  ) as table_3;


/*---------------------------------------------------------------------------------------*/

