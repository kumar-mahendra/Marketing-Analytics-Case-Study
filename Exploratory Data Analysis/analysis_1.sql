/*
LEFT Table : Rental Table 
---------------
columns needed : inventory_id-->FOREIGN KEY  , customer_id 

RIGHT Table : Inventory Table 
---------------
columns needed : inventory_id-->FOREIGN, film_id
*/

/*
Q means Question
A means Answer 
J means Justification through a SQL query output
*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Q : Are there duplicate rows in dataset? 
A : No 
J : No of rows before and after applying DISTINCT keyword remain same. 

|Count_with_Distinct|
|-------------------|
| 16044             |

|Count_without_Distinct|
|-------------------|
| 16044             |

sql queries to generate these outputs
*/
SELECT
  COUNT(*) as Count_with_Distinct
FROM
  (
    SELECT
      DISTINCT *
    FROM
      dvd_rentals.rental
  ) AS subquery;
--  then seperatly run this
SELECT
  COUNT(*) as Count_without_Distinct
FROM
  dvd_rentals.rental;

--------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
Q : is inventory_id unique? 
A : No, inventory_id denote the item/dvd in a shop. Same item can be purchased by multiple customers at different point of time. 
J : 

| inventory_id | frequency |
| ------------ | --------- |
| 2520         | 5         |
| 1489         | 5         |
| 2574         | 5         |
| 273          | 5         |
| 2466         | 5         |

sql query to generate above output
*/
SELECT
  inventory_id,
  count(*) as frequency
FROM
  dvd_rentals.rental
GROUP BY
  inventory_id
ORDER BY
  frequency desc
LIMIT
  5 ;

--------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
Q : What is type of relation between inventory_id and customer_id?
A : one-to-one
J : 

| customer_id | inventory_id | frequency |
| ----------- | ------------ | --------- |
| 288         | 4360         | 1         |
| 71          | 738          | 1         |
| 161         | 1797         | 1         |
| 476         | 2494         | 1         |
| 319         | 1084         | 1         |

sql query 
*/

SELECT
  customer_id,
  inventory_id,
  COUNT(*) AS frequency
FROM
  dvd_rentals.rental
GROUP BY
  customer_id,
  inventory_id
ORDER BY
  frequency DESC
LIMIT 5; 

--------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
Q : Are all inventory_id in right table are unique? 
A : Yes
J : 

|total_rows | distinct_rows_count | 
|-----------|-------------------- |
| 4581      | 4581                |

*/

WITH table_1 AS (
  SELECT
    COUNT(inventory_id) as total_rows
  FROM
    dvd_rentals.inventory
),
table_2 as (
  SELECT
    COUNT(DISTINCT inventory_id) as distinct_inventory_row_count
  FROM
    dvd_rentals.inventory
)
SELECT
  *
FROM
  table_1,
  table_2

--------------------------------------------------------------------------------------------------------------------------------------------------------------


/*
Q : Are all inventory_id in left table are also there in right table?
A : Yes
J : note in rental-table there is one-one relationship between 
    customer_id and inventory_id and also inventory_id is unique
    in inventory table then anti join can have at atmost 0 rows as
    after anti join return rows which are in left table but not in
    right table. 

|count                 |
|----------------------|
| 0                    |

Note : we can also use left join as there are no duplicates inventory_id 
in right table. I will stick to inner join whenever there is choice. 
sql query 
*/

-- how many foreign keys only exist in the left table and not in the right?
SELECT
  COUNT(DISTINCT rental.inventory_id)
FROM dvd_rentals.rental
WHERE NOT EXISTS (
  SELECT inventory_id
  FROM dvd_rentals.inventory
  WHERE rental.inventory_id = inventory.inventory_id
);
--------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
TL; DR 

1. We saw that each combination of customer-id and inventory_id is 
unique means every customer has purchased a inventory_id from a 
shop at most once. 

2. In inventory table inventory_id are all unique. 

3. We will use inner join for joining rental and invnetory table. 
*/










