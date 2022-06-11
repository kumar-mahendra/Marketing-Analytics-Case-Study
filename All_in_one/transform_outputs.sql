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

| customer_id | cat_1    | cat_1_rec_1         | cat_1_rec_2       | cat_1_rec_3       | cat_1_insight                                                                                               | cat_2     | cat_2_rec_1    | cat_2_rec_2    | cat_2_rec_3         | cat_2_insight                                                                  | actor_name     | actor_rec_1       | actor_rec_2           | actor_rec_3            |
| ----------- | -------- | ------------------- | ----------------- | ----------------- | ----------------------------------------------------------------------------------------------------------- | --------- | -------------- | -------------- | ------------------- | ------------------------------------------------------------------------------ | -------------- | ----------------- | --------------------- | ---------------------- |
| 1           | Classics | TIMBERLAND SKY      | GILMORE BOILED    | VOYAGE LEGALLY    | You have watched 6 Classics that"s 4 more than the DVD Rental Co. average and puts you top 1 % of experts.  | Comedy    | ZORRO ARK      | CAT CONEHEADS  | OPERATION OPERATION | You have watched 5 Comedy films making up 16 % of your total watch history!    | VAL BOLGER     | PRIMARY GLASS     | ALASKA PHANTOM        | METROPOLIS COMA        |
| 2           | Sports   | GLEAMING JAWBREAKER | TALENTED HOMICIDE | ROSES TREASURE    | You have watched 5 Sports that"s 3 more than the DVD Rental Co. average and puts you top 3 % of experts.    | Classics  | FROST HEAD     | GILMORE BOILED | VOYAGE LEGALLY      | You have watched 4 Classics films making up 15 % of your total watch history!  | GINA DEGENERES | GOODFELLAS SALUTE | WIFE TURN             | DOGMA FAMILY           |
| 3           | Action   | RUGRATS SHAKESPEARE | SUSPECTS QUILLS   | HANDICAP BOONDOCK | You have watched 4 Action that"s 2 more than the DVD Rental Co. average and puts you top 5 % of experts.    | Animation | JUGGLER HARDLY | DOGMA FAMILY   | STORM HAPPINESS     | You have watched 3 Animation films making up 12 % of your total watch history! | JAYNE NOLTE    | ENGLISH BULWORTH  | SWEETHEARTS SUSPECTS  | DANCING FEVER          |
| 4           | Horror   | PULP BEVERLY        | FAMILY SWEET      | SWARM GOLD        | You have watched 3 Horror that"s 2 more than the DVD Rental Co. average and puts you top 8 % of experts.    | Comedy    | ZORRO ARK      | CAT CONEHEADS  | CLOSER BANG         | You have watched 2 Comedy films making up 9 % of your total watch history!     | WALTER TORN    | HOBBIT ALIEN      | WITCHES PANIC         | CURTAIN VIDEOTAPE      |
| 5           | Classics | TIMBERLAND SKY      | FROST HEAD        | GILMORE BOILED    | You have watched 7 Classics that"s 5 more than the DVD Rental Co. average and puts you top 1 % of experts.  | Animation | JUGGLER HARDLY | DOGMA FAMILY   | STORM HAPPINESS     | You have watched 6 Animation films making up 16 % of your total watch history! | KARL BERRY     | VIRGINIAN PLUTO   | STAGECOACH ARMAGEDDON | TELEMARK HEARTBREAKERS |

*/


DROP TABLE IF EXISTS final_table; 
CREATE TABLE final_table AS (
SELECT t1.*, 
       t2.actor_name, 
       t2.actor_rec_1, 
       t2.actor_rec_2, 
       t2.actor_rec_3 
FROM final_category_table AS t1 
INNER JOIN final_actor_table AS t2 ON t1.customer_id = t2.customer_id); 

SELECT * FROM final_table LIMIT 5; 




/*

End of the Case Study . Thank You for reading !!!
*/





