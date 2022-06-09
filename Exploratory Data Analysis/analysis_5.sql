/*
Left Table : film 
-------------------------
columns used : film_id 

Right Table : film_actor
-------------------------
columns used : actor_id, film_id 
*/

--------------------------------------------------------------

/*
Q : Is film_id and actor_id columns  has duplicates in film_actor table?
A : Yes !!!
J : Since a film can have more than one actor, It makes sense
    that a film_id will repeat again and again for all actors. 

    Also same actor can be featured in more than one film so reverse also is true

| total_rows | distinct_film_id | distinct_actor_id |
| ---------- | ---------------- | ----------------- |
| 5462       | 997              | 200

*/

SELECT
  *
FROM
  dvd_rentals.film_actor;
WITH table_1 AS (
    SELECT
      COUNT(film_id) AS total_rows
    FROM
      dvd_rentals.film_actor
  ),
  table_2 AS (
    SELECT
      COUNT(DISTINCT film_id) AS distinct_film_id
    FROM
      dvd_rentals.film_actor
  ),
  table_3 AS (
    SELECT
      COUNT(DISTINCT actor_id) AS distinct_actor_id
    FROM dvd_rentals.film_actor
  )
SELECT
  *
FROM
  table_1,
  table_2,
  table_3

---------------------------------------------------------------------------------

/*
Q : Is combination of film_id and actor_id unique ? 
A : Yes
J : 
| film_id | actor_id | frequency |
| ------- | -------- | --------- |
| 599     | 140      | 1         |
| 637     | 186      | 1         |
| 839     | 176      | 1         |
| 494     | 40       | 1         |
| 919     | 111      | 1         |
 ....

sql query
*/

SELECT
  film_id,
  actor_id,
  COUNT(*) AS frequency
FROM
  dvd_rentals.film_actor
GROUP BY
  film_id,
  actor_id
ORDER BY
  frequency DESC
LIMIT
  5;

/*
  So it is clear we can not use inner join as there is 
  one-to-many relationship between film table and film_actor 
  table. now we have to think along lines of what output 
  we need. the thing is to find top actor for a customer 
  we need a table contains all customer and movies they watched 
  then only we can perform some calculation to get top actor. 

  See you in Table Joins Section where I will actually perform table joins
  and form many new tables which can be used as base table for more table joins. 
  Next section is going to be exciting. Lets dive in. 
*/