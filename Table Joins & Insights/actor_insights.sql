  /*
Actor Insights 
*/


/*

Preview Output 

Create Base Table base_table_actor_insights

| customer_id | film_id | actor_id | first_name | actor_name    | total_no_of_rows |
| ----------- | ------- | -------- | ---------- | ------------- | --------------- |
| 130         | 80      | 200      | THORA      | THORA TEMPLE  | 87980           |
| 130         | 80      | 193      | BURT       | BURT TEMPLE   | 87980           |
| 130         | 80      | 173      | ALAN       | ALAN DREYFUSS | 87980           |
| 130         | 80      | 16       | FRED       | FRED COSTNER  | 87980           |
| 459         | 333     | 147      | FAY        | FAY WINSLET   | 87980           |


*/

DROP TABLE IF EXISTS base_table_actor_insights ; 
CREATE TABLE base_table_actor_insights AS ( 
SELECT
  t1.customer_id,
  t2.film_id,
  t3.actor_id,
  t4.first_name AS first_name,
  (t4.first_name || ' ' || t4.last_name) AS actor_name,
  t1.rental_date 
FROM
  dvd_rentals.rental AS t1
  INNER JOIN dvd_rentals.inventory AS t2 ON t2.inventory_id = t1.inventory_id
  INNER JOIN dvd_rentals.film_actor AS t3 ON t3.film_id = t2.film_id
  INNER JOIN dvd_rentals.actor AS t4 ON t4.actor_id = t3.actor_id
); 

SELECT *, COUNT(*) OVER() AS total_no_of_rows FROM base_table_actor_insights LIMIT 5; 

/*-------------------------------------------------------------------------------------*/

/*
For each (customer, actor) combination find count of movies watched 
and rank actors based on decreasing order of count. 
Then just filter the records to find top actor for each customer.

Preview Output 

| customer_id | actor_id | actor_name     | top_actor_count | actor_insight                                                                     |
| ----------- | -------- | -------------- | --------------- | --------------------------------------------------------------------------------- |
| 503         | 3        | ED CHASE       | 3               | You have watched 3 films featuring Ed ! Here are some other films to binge!.      |
| 1           | 37       | VAL BOLGER     | 6               | You have watched 6 films featuring Val ! Here are some other films to binge!.     |
| 2           | 107      | GINA DEGENERES | 5               | You have watched 5 films featuring Gina ! Here are some other films to binge!.    |
| 3           | 150      | JAYNE NOLTE    | 4               | You have watched 4 films featuring Jayne ! Here are some other films to binge!.   |
| 4           | 102      | WALTER TORN    | 4               | You have watched 4 films featuring Walter ! Here are some other films to binge!.  |
*/

DROP TABLE IF EXISTS actor_rank_table;
CREATE TABLE actor_rank_table AS (
    WITH actor_films_count_table AS (
      SELECT
        customer_id,
        actor_id,
        first_name,
        actor_name,
        MAX(rental_date) AS latest_rental_date,
        COUNT(*) AS films_count
      FROM
        base_table_actor_insights
      GROUP BY
        customer_id,
        actor_id,
        first_name,  -- first_name & actor_name are unique to each actor_id. I need these two columns later so adding in group by . 
        actor_name
      ORDER BY
        films_count DESC
    )
    SELECT
      customer_id,
      actor_id,
      first_name,
      actor_name,
      films_count,
      latest_rental_date,
      DENSE_RANK() OVER (
        PARTITION BY customer_id
        ORDER BY
          films_count DESC,
          latest_rental_date DESC,
          actor_name
      ) AS actor_rank
    FROM
      actor_films_count_table
  );
  
UPDATE actor_rank_table 
SET first_name = UPPER( LEFT( first_name, 1)) ||LOWER( SUBSTRING(first_name, 2, LENGTH(first_name))); 

DROP TABLE IF EXISTS top_actor_table;
CREATE TABLE top_actor_table AS (
    SELECT
      customer_id,
      actor_id,
      actor_name,
      films_count AS top_actor_count,
      'You have watched ' || films_count || ' films featuring ' || first_name || ' ! Here are some other films to binge!. ' AS actor_insight 

    FROM
      actor_rank_table
    WHERE
      actor_rank = 1
  );
  
SELECT
  *
FROM
  top_actor_table LIMIT 5;
/*--------------------------------------------------------------------*/



