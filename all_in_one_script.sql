/*
This script generates category level insights for each customer.
Mainly it finds 
1. Top 2 categories for each customer
2. Category specific insight for these category as asked in buisness questions
3. Top 3 recommendations for each of top 2  category
*/

/*
Generate base table `base_table_category_insights`

Based on analysis we did in Exploratory Data Analysis Section
we can perform inner join as shown below without any duplicates 

Preview Output : 

| customer_id | film_id | film_name           | category_id | category_name |
| ----------- | ------- | --------------- | ----------- | ------------- |
| 130         | 80      | BLANKET BEVERLY | 8           | Family        |
| 459         | 333     | FREAKY POCUS    | 12          | Music         |
| 408         | 373     | GRADUATE LORD   | 3           | Children      |
| 333         | 535     | LOVE SUICIDES   | 11          | Horror        |
| 222         | 450     | IDOLS SNATCHERS | 3           | Children      |

*/

DROP TABLE IF EXISTS base_table_category_insights; 
CREATE TABLE base_table_category_insights AS (
SELECT
  t1.customer_id,
  t2.film_id,
  t3.title AS film_name,
  t4.category_id,
  t5.name AS category_name
FROM
  dvd_rentals.rental t1
  INNER JOIN dvd_rentals.inventory AS t2 ON t1.inventory_id = t2.inventory_id
  INNER JOIN dvd_rentals.film AS t3 ON t2.film_id = t3.film_id
  INNER JOIN dvd_rentals.film_category AS t4 ON t3.film_id = t4.film_id
  INNER JOIN dvd_rentals.category AS t5 ON t5.category_id = t4.category_id
); 

/*----------------------------------------------------------------------------------------*/

/*
Generate category_count columns for each customer and category

Preview Output :

intermediate_table_1 

| customer_id | category_id | category_name | category_count |
| ----------- | ----------- | ------------- | -------------- |
| 1           | 1           | Action        | 2              |
| 1           | 2           | Animation     | 2              |
| 1           | 4           | Classics      | 6              |
| 1           | 5           | Comedy        | 5              |
| 1           | 6           | Documentary   | 1              |
*/

DROP TABLE IF EXISTS intermediate_table_1 ; 
CREATE TEMP TABLE intermediate_table_1 AS ( 
SELECT
  customer_id,
  category_id,
  category_name,
  COUNT(*) AS category_count
FROM
  base_table_category_insights
GROUP BY
  customer_id,
  category_id,
  category_name
ORDER BY 
  customer_id , category_id
) ; 

SELECT * FROM intermediate_table_1 LIMIT 5; 

/*----------------------------------------------------------------------------------------*/

/*
Generate total_film_count for each category and append it to 
previous table .  

Previous Output :

intermediate_table_2 

| customer_id | category_id | category_name | category_count | total_film_count |
| ----------- | ----------- | ------------- | -------------- | ---------------- |
| 1           | 1           | Action        | 2              | 32               |
| 1           | 2           | Animation     | 2              | 32               |
| 1           | 4           | Classics      | 6              | 32               |
| 1           | 5           | Comedy        | 5              | 32               |
| 1           | 6           | Documentary   | 1              | 32               |
| 1           | 7           | Drama         | 4              | 32               |
| 1           | 8           | Family        | 1              | 32               |
| 1           | 9           | Foreign       | 1              | 32               |
| 1           | 10          | Games         | 1              | 32               |
| 1           | 12          | Music         | 2              | 32               |
| 1           | 13          | New           | 2              | 32               |
| 1           | 14          | Sci-Fi        | 2              | 32               |
| 1           | 15          | Sports        | 2              | 32               |
| 1           | 16          | Travel        | 1              | 32               |
*/

DROP TABLE IF EXISTS intermediate_table_2;
CREATE TEMP TABLE intermediate_table_2 AS (
  SELECT
    *,
    SUM (category_count) OVER (PARTITION BY customer_id) AS total_film_count
  FROM
    intermediate_table_1
);
SELECT
  *
FROM
  intermediate_table_2
WHERE
  customer_id = 1;

/*----------------------------------------------------------------------------------------*/

/*
Generate average count of movies watched by customer in each category

Preview Output :

intermediate_table_3

| customer_id | category_id | category_name | category_count | total_film_count | average_category_count | category_percentage |
| ----------- | ----------- | ------------- | -------------- | ---------------- | ---------------------- | ------------------- |
| 349         | 1           | Action        | 1              | 29               | 2                      | 3                   |
| 40          | 1           | Action        | 3              | 27               | 2                      | 11                  |
| 103         | 1           | Action        | 3              | 31               | 2                      | 10                  |
| 79          | 1           | Action        | 1              | 22               | 2                      | 5                   |
| 380         | 1           | Action        | 3              | 36               | 2                      | 8                   |
*/
DROP TABLE IF EXISTS intermediate_table_3;
CREATE TEMP TABLE intermediate_table_3 AS (
  WITH temp_table AS ( 
  SELECT
    *,
  SUM(category_count)  OVER ( PARTITION BY category_id ) AS numerator,
  COUNT(category_count) OVER ( PARTITION BY category_id) AS denominator
  FROM
    intermediate_table_2
  ) 
  SELECT 
  customer_id, 
  category_id, 
  category_name,
  category_count, 
  total_film_count, 
  FLOOR( numerator/denominator ) AS average_category_count,
  ROUND( 100* (category_count/total_film_count) ) AS category_percentage 
  FROM temp_table
);

SELECT * FROM intermediate_table_3 LIMIT 5; 

/*----------------------------------------------------------------------------------------*/

/*
Find category rank for each customer and each category using 
DENSE_RANK window function by paritioning by customer_id  

Preview Output

intermediate_table_4 

| customer_id | category_id | category_name | category_count | total_film_count | average_category_count | category_percentage | category_rank |
| ----------- | ----------- | ------------- | -------------- | ---------------- | ---------------------- | ------------------- | ------------- |
| 1           | 4           | Classics      | 6              | 32               | 2                      | 19                  | 1             |
| 1           | 5           | Comedy        | 5              | 32               | 1                      | 16                  | 2             |
| 1           | 7           | Drama         | 4              | 32               | 2                      | 13                  | 3             |
| 1           | 1           | Action        | 2              | 32               | 2                      | 6                   | 4             |
| 1           | 2           | Animation     | 2              | 32               | 2                      | 6                   | 5             |
*/

DROP TABLE IF EXISTS intermediate_table_4; 
CREATE TEMP TABLE intermediate_table_4 AS (
SELECT
  *,
  DENSE_RANK() OVER (
    PARTITION BY customer_id
    ORDER BY
      category_count DESC,
      category_name
  ) AS category_rank
FROM
  intermediate_table_3
ORDER BY
  customer_id,
  category_rank
); 
SELECT * FROM intermediate_table_4 LIMIT 5; 

/*----------------------------------------------------------------------------------------*/

/*
At last we need to find where customer falls in top x% in each category. 
specifically we need to find it for topmost category but we can anyway 
filter that with help of WHERE clause.

Preview Output 

intermediate_table_5 

| customer_id | category_name | category_count | average_category_count | category_percentage | category_rank | category_percent_rank |
| ----------- | ------------- | -------------- | ---------------------- | ------------------- | ------------- | --------------------- |
| 323         | Action        | 7              | 2                      | 23                  | 1             | 1                     |
| 506         | Action        | 7              | 2                      | 20                  | 1             | 1                     |
| 151         | Action        | 6              | 2                      | 22                  | 1             | 1                     |
| 111         | Action        | 6              | 2                      | 23                  | 1             | 1                     |
| 209         | Action        | 6              | 2                      | 19                  | 1             | 1                     |
*/

DROP TABLE IF EXISTS intermediate_table_5; 
CREATE TABLE intermediate_table_5 AS ( 
  WITH temp_table AS (
    SELECT
      customer_id,
      category_name,
      category_count,
      average_category_count,
      category_percentage,
      category_rank,
      CEIL(
        100 * PERCENT_RANK() OVER (
          PARTITION BY category_id
          ORDER BY
            category_count DESC
        )
      ) AS percent_rank
    FROM
      intermediate_table_4
  )
SELECT
  customer_id,
  category_name,
  category_count,
  average_category_count,
  category_percentage,
  category_rank,
  CASE
    WHEN percent_rank = 0 THEN 1
    ELSE percent_rank
  END AS category_percent_rank
FROM
  temp_table
); 
SELECT * FROM intermediate_table_5 LIMIT 5; 


/*----------------------------------------------------------------------------------------*/

/*
Customer Insights for top 2 categories 

Preview Output 

| customer_id | category_rank | category_name | insights                                                                                                        |
| ----------- | ------------- | ------------- | ----------------------------------------------------------------------------------------------------------- |
| 1           | 1             | Classics      | You have watched 6 Classics that"s 4 more than the DVD Rental Co. average and puts you top 1 % of experts.  |
| 1           | 2             | Comedy        | You have watched 5 Comedy films making up 16 % of your total watch history!                                             |
| 2           | 1             | Sports        | You have watched 5 Sports that"s 3 more than the DVD Rental Co. average and puts you top 3 % of experts.    |
| 2           | 2             | Classics      | You have watched 4 Classics films making up 15 % of your total watch history!                                             |
| 3           | 1             | Action        | You have watched 4 Action that"s 2 more than the DVD Rental Co. average and puts you top 5 % of experts.    |
*/


DROP TABLE IF EXISTS category_insights; 
CREATE TEMP TABLE category_insights AS (
SELECT
  customer_id,
  category_rank,
  category_name,
  CASE
    WHEN category_rank = 1 THEN 'You have watched ' || category_count :: text || ' ' || category_name :: text || ' that"s ' || (category_count - average_category_count) :: text || ' more than the DVD Rental Co. average and puts you top ' || category_percent_rank :: text || ' % of experts. '
    ELSE 'You have watched ' || category_count :: text || ' ' || category_name::text || ' films making up ' || category_percentage :: text || ' % of your total watch history!'
  END AS insights
FROM
  intermediate_table_5
WHERE
  category_rank = 1
  or category_rank = 2
ORDER BY
  customer_id,
  category_rank
); 
SELECT * FROM category_insights LIMIT 5; 

/*----------------------------------------------------------------------------------------*/

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

/*---------------------------------------------*/

/*

Actor side Combined All 
---------------------

| customer_id | actor_name         | actor_rec_1        | actor_rec_2          | actor_rec_3        |
| ----------- | ------------------ | ------------------- | --------------------- | ------------------- |
| 345         | WARREN NOLTE       | WARDROBE PHANTOM    | ROMAN PUNK            | WEDDING APOLLO      |
| 275         | ANGELA WITHERSPOON | CAT CONEHEADS       | PULP BEVERLY          | CHANCE RESURRECTION |
| 499         | CHRISTIAN AKROYD   | CHANCE RESURRECTION | OPERATION OPERATION   | PRINCESS GIANT      |
| 486         | KIRSTEN AKROYD     | BUCKET BROTHERHOOD  | STAGECOACH ARMAGEDDON | MADNESS ATTACKS     |
| 189         | MINNIE ZELLWEGER   | SUSPECTS QUILLS     | TOMORROW HUSTLER      | BILL OTHERS         |

SQL query below 
*/

DROP TABLE IF EXISTS final_actor_table; 
CREATE TEMP TABLE final_actor_table AS ( 
SELECT 
  customer_id, 
  actor_name ,
  MAX(CASE WHEN recommend_rank = 1 THEN film_name END) AS actor_rec_1,
  MAX(CASE WHEN recommend_rank = 2 THEN film_name END) AS actor_rec_2,
  MAX(CASE WHEN recommend_rank = 3 THEN film_name END) AS actor_rec_3

FROM top_3_actor_based_recommendations
GROUP BY customer_id, actor_name 
); 

SELECT * FROM final_actor_table LIMIT 5; 

/* 
 Category side Combine All 
 -----------------------------

Preview Output 


| customer_id | cat_1    | cat_1_rec_1         | cat_1_rec_2       | cat_1_rec_3       | cat_1_insight                                                                                               | cat_2     | cat_2_rec_1    | cat_2_rec_2    | cat_2_rec_3         | cat_2_insight                                                                  |
| ----------- | -------- | ------------------- | ----------------- | ----------------- | ----------------------------------------------------------------------------------------------------------- | --------- | -------------- | -------------- | ------------------- | ------------------------------------------------------------------------------ |
| 1           | Classics | TIMBERLAND SKY      | GILMORE BOILED    | VOYAGE LEGALLY    | You have watched 6 Classics that"s 4 more than the DVD Rental Co. average and puts you top 1 % of experts.  | Comedy    | ZORRO ARK      | CAT CONEHEADS  | OPERATION OPERATION | You have watched 5 Comedy films making up 16 % of your total watch history!    |
| 2           | Sports   | GLEAMING JAWBREAKER | TALENTED HOMICIDE | ROSES TREASURE    | You have watched 5 Sports that"s 3 more than the DVD Rental Co. average and puts you top 3 % of experts.    | Classics  | FROST HEAD     | GILMORE BOILED | VOYAGE LEGALLY      | You have watched 4 Classics films making up 15 % of your total watch history!  |
| 3           | Action   | RUGRATS SHAKESPEARE | SUSPECTS QUILLS   | HANDICAP BOONDOCK | You have watched 4 Action that"s 2 more than the DVD Rental Co. average and puts you top 5 % of experts.    | Animation | JUGGLER HARDLY | DOGMA FAMILY   | STORM HAPPINESS     | You have watched 3 Animation films making up 12 % of your total watch history! |
| 4           | Horror   | PULP BEVERLY        | FAMILY SWEET      | SWARM GOLD        | You have watched 3 Horror that"s 2 more than the DVD Rental Co. average and puts you top 8 % of experts.    | Comedy    | ZORRO ARK      | CAT CONEHEADS  | CLOSER BANG         | You have watched 2 Comedy films making up 9 % of your total watch history!     |
| 5           | Classics | TIMBERLAND SKY      | FROST HEAD        | GILMORE BOILED    | You have watched 7 Classics that"s 5 more than the DVD Rental Co. average and puts you top 1 % of experts.  | Animation | JUGGLER HARDLY | DOGMA FAMILY   | STORM HAPPINESS     | You have watched 6 Animation films making up 16 % of your total watch history! |

*/

DROP TABLE IF EXISTS final_category_table ; 
CREATE TEMP TABLE final_category_table AS (
WITH temp_table AS ( 
SELECT t1.* , t2.insights FROM film_recommendations_category_table AS t1 INNER JOIN category_insights AS t2 ON t1.customer_id = t2.customer_id AND t1.category_rank = t2.category_rank
)
SELECT 
    customer_id,
    MAX( CASE WHEN category_rank = 1 THEN category_name END ) AS cat_1,
    MAX( CASE WHEN category_rank = 1 AND recommendation_rank=1 THEN film_name END ) AS cat_1_rec_1,
    MAX( CASE WHEN category_rank = 1 AND recommendation_rank=2 THEN film_name END ) AS cat_1_rec_2,
    MAX( CASE WHEN category_rank = 1 AND recommendation_rank=3 THEN film_name END ) AS cat_1_rec_3,
    MAX( CASE WHEN category_rank = 1 THEN insights END ) AS cat_1_insight,
    
    MAX( CASE WHEN category_rank = 2 THEN category_name END ) AS cat_2,
    MAX( CASE WHEN category_rank = 2 AND recommendation_rank=1 THEN film_name END ) AS cat_2_rec_1,
    MAX( CASE WHEN category_rank = 2 AND recommendation_rank=2 THEN film_name END ) AS cat_2_rec_2,
    MAX( CASE WHEN category_rank = 2 AND recommendation_rank=3 THEN film_name END ) AS cat_2_rec_3,
    MAX( CASE WHEN category_rank = 2 THEN insights END ) AS cat_2_insight
FROM temp_table 
GROUP BY customer_id
); 

SELECT * FROM final_category_table LIMIT 5; 

/*
----------------------------------------------------
THE FINAL JOIN EVER OF THIS CASE STUDY

The Final Command : Join final_category_table with final_actor_table to give the_final_table 
PS : I can't say how excited I am right now while typing this !!!!! :))))

So here I Go!!
---------------------------------------------------

FINAL TABLE PREVIEW

| customer_id | cat_1    | cat_1_rec_1         | cat_1_rec_2       | cat_1_rec_3       | cat_1_insight                                                                                               | cat_2     | cat_2_rec_1    | cat_2_rec_2    | cat_2_rec_3         | cat_2_insight                                                                  | actor_name     | actor_insight                                                                     | actor_rec_1       | actor_rec_2           | actor_rec_3            |
| ----------- | -------- | ------------------- | ----------------- | ----------------- | ----------------------------------------------------------------------------------------------------------- | --------- | -------------- | -------------- | ------------------- | ------------------------------------------------------------------------------ | -------------- | --------------------------------------------------------------------------------- | ----------------- | --------------------- | ---------------------- |
| 1           | Classics | TIMBERLAND SKY      | GILMORE BOILED    | VOYAGE LEGALLY    | You have watched 6 Classics that"s 4 more than the DVD Rental Co. average and puts you top 1 % of experts.  | Comedy    | ZORRO ARK      | CAT CONEHEADS  | OPERATION OPERATION | You have watched 5 Comedy films making up 16 % of your total watch history!    | VAL BOLGER     | You have watched 6 films featuring Val ! Here are some other films to binge!.     | PRIMARY GLASS     | ALASKA PHANTOM        | METROPOLIS COMA        |
| 2           | Sports   | GLEAMING JAWBREAKER | TALENTED HOMICIDE | ROSES TREASURE    | You have watched 5 Sports that"s 3 more than the DVD Rental Co. average and puts you top 3 % of experts.    | Classics  | FROST HEAD     | GILMORE BOILED | VOYAGE LEGALLY      | You have watched 4 Classics films making up 15 % of your total watch history!  | GINA DEGENERES | You have watched 5 films featuring Gina ! Here are some other films to binge!.    | GOODFELLAS SALUTE | WIFE TURN             | DOGMA FAMILY           |
| 3           | Action   | RUGRATS SHAKESPEARE | SUSPECTS QUILLS   | HANDICAP BOONDOCK | You have watched 4 Action that"s 2 more than the DVD Rental Co. average and puts you top 5 % of experts.    | Animation | JUGGLER HARDLY | DOGMA FAMILY   | STORM HAPPINESS     | You have watched 3 Animation films making up 12 % of your total watch history! | JAYNE NOLTE    | You have watched 4 films featuring Jayne ! Here are some other films to binge!.   | ENGLISH BULWORTH  | SWEETHEARTS SUSPECTS  | DANCING FEVER          |
| 4           | Horror   | PULP BEVERLY        | FAMILY SWEET      | SWARM GOLD        | You have watched 3 Horror that"s 2 more than the DVD Rental Co. average and puts you top 8 % of experts.    | Comedy    | ZORRO ARK      | CAT CONEHEADS  | CLOSER BANG         | You have watched 2 Comedy films making up 9 % of your total watch history!     | WALTER TORN    | You have watched 4 films featuring Walter ! Here are some other films to binge!.  | HOBBIT ALIEN      | WITCHES PANIC         | CURTAIN VIDEOTAPE      |
| 5           | Classics | TIMBERLAND SKY      | FROST HEAD        | GILMORE BOILED    | You have watched 7 Classics that"s 5 more than the DVD Rental Co. average and puts you top 1 % of experts.  | Animation | JUGGLER HARDLY | DOGMA FAMILY   | STORM HAPPINESS     | You have watched 6 Animation films making up 16 % of your total watch history! | KARL BERRY     | You have watched 4 films featuring Karl ! Here are some other films to binge!.    | VIRGINIAN PLUTO   | STAGECOACH ARMAGEDDON | TELEMARK HEARTBREAKERS |

*/


DROP TABLE IF EXISTS final_table; 
CREATE TABLE final_table AS (
SELECT t1.*, 
      t2.actor_name, 
      t3.actor_insight,
      t2.actor_rec_1, 
      t2.actor_rec_2, 
      t2.actor_rec_3 
FROM final_category_table AS t1 
INNER JOIN final_actor_table AS t2 ON t1.customer_id = t2.customer_id
INNER JOIN top_actor_table AS t3 ON t3.customer_id = t1.customer_id );

SELECT * FROM final_table;




/*

End of the Case Study . Thank You for reading !!!
*/





