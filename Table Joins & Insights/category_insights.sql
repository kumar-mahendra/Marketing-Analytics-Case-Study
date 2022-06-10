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

----------------------------------------------------------------------------------------

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

---------------------------------------------------------------------------

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

------------------------------------------------------------------------------

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
------------------------------------------------------------------------------

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

-------------------------------------------------------------------------------

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


-----------------------------------------------------------------------------------------------------
/*
Customer Insights for top 2 categories 

Preview Output 

| customer_id | category_rank | category_name | insights                                                                                                        |
| ----------- | ------------- | ------------- | ----------------------------------------------------------------------------------------------------------- |
| 1           | 1             | Classics      | You have watched 6 Classics that"s 4 more than the DVD Rental Co. average and puts you top 1 % of experts.  |
| 1           | 2             | Comedy        | You have watched 5  making up 16 % of your total watch history!                                             |
| 2           | 1             | Sports        | You have watched 5 Sports that"s 3 more than the DVD Rental Co. average and puts you top 3 % of experts.    |
| 2           | 2             | Classics      | You have watched 4  making up 15 % of your total watch history!                                             |
| 3           | 1             | Action        | You have watched 4 Action that"s 2 more than the DVD Rental Co. average and puts you top 5 % of experts.    |
*/



SELECT
  customer_id,
  category_rank,
  category_name
  CASE
    WHEN category_rank = 1 THEN 'You have watched ' || category_count :: text || ' ' || category_name :: text || ' that"s ' || (category_count - average_category_count) :: text || ' more than the DVD Rental Co. average and puts you top ' || category_percent_rank :: text || ' % of experts. '
    ELSE 'You have watched ' || category_count :: text || ' ' || ' making up ' || category_percentage :: text || ' % of your total watch history!'
  END AS insights
FROM
  intermediate_table_5
WHERE
  category_rank = 1
  or category_rank = 2
ORDER BY
  customer_id,
  category_rank
LIMIT
  5;

---------------------------------------------------------------------------------------------------------------------