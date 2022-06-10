/*
Left Table : film_actor 
------------------------
columns used : film_id, actor_id 

Right Table : actor 
------------------------
columns used : actor_id, actor_name 
*/

-----------------------------------------------------------

/*
Q : Are there duplicate entries in actor table ?  
A : No
J : there is one-to-one relationship between actor_id 
    & actor_name [ which is derived column as combination of first_name last_name]

| actor_id | actor_name          | frequency |
| -------- | ------------------- | --------- |
| 1        | PENELOPE GUINESS    | 1         |
| 2        | NICK WAHLBERG       | 1         |
| 3        | ED CHASE            | 1         |
| 4        | JENNIFER DAVIS      | 1         |
| 5        | JOHNNY LOLLOBRIGIDA | 1         |

sql query 
*/

SELECT
  actor_id,
  (first_name || ' ' || last_name) as actor_name,
  COUNT(*) frequency
FROM
  dvd_rentals.actor
GROUP BY
  actor_id,
  actor_name
ORDER BY
  frequency DESC,
  actor_id 
LIMIT
  5;



