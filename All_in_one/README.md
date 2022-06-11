## All in ONE [<img src="../Images/folder.png" width=30 height=30 align=middle>](./transform_outputs.sql) 
---

This are following columns in final table : 

1. `customer_id` : Unique ID corresponding to each customer
2. `cat_1` : Most watched category by customer 
3. `cat_1_rec_1`, `cat_1_rec_2`, `cat_1_rec_3` are top 3 movie recommendations corresponding to most watched category
4. `cat_2` : Second most watched category by customer 
5. `cat_2_rec_1`, `cat_2_rec_2`, `cat_2_rec_3` are top 3 movie recommendations corresponding to **second** most watched category
6. `cat_1_insight` : Insight corresponding to top most category 
7. `cat_2_insight` : Insight corresponding to second top most category 
8. `top_actor` : Name of actor who appeared most in watched history of customer 
9. `actor_rec_1`, `actor_rec_2`, `actor_rec_3` are top 3 movie recommendations corresponding to given actor. These are different from category level recommendation given above.

In fact these are all the things which were absent in our initial draft/template provided to us.

<details>
<summary>All in ONE</summary>

| customer_id | cat_1    | cat_1_rec_1         | cat_1_rec_2       | cat_1_rec_3       | cat_1_insight                                                                                               | cat_2     | cat_2_rec_1    | cat_2_rec_2    | cat_2_rec_3         | cat_2_insight                                                                  | actor_name     | actor_rec_1       | actor_rec_2           | actor_rec_3            |
| ----------- | -------- | ------------------- | ----------------- | ----------------- | ----------------------------------------------------------------------------------------------------------- | --------- | -------------- | -------------- | ------------------- | ------------------------------------------------------------------------------ | -------------- | ----------------- | --------------------- | ---------------------- |
| 1           | Classics | TIMBERLAND SKY      | GILMORE BOILED    | VOYAGE LEGALLY    | You have watched 6 Classics that"s 4 more than the DVD Rental Co. average and puts you top 1 % of experts.  | Comedy    | ZORRO ARK      | CAT CONEHEADS  | OPERATION OPERATION | You have watched 5 Comedy films making up 16 % of your total watch history!    | VAL BOLGER     | PRIMARY GLASS     | ALASKA PHANTOM        | METROPOLIS COMA        |
| 2           | Sports   | GLEAMING JAWBREAKER | TALENTED HOMICIDE | ROSES TREASURE    | You have watched 5 Sports that"s 3 more than the DVD Rental Co. average and puts you top 3 % of experts.    | Classics  | FROST HEAD     | GILMORE BOILED | VOYAGE LEGALLY      | You have watched 4 Classics films making up 15 % of your total watch history!  | GINA DEGENERES | GOODFELLAS SALUTE | WIFE TURN             | DOGMA FAMILY           |
| 3           | Action   | RUGRATS SHAKESPEARE | SUSPECTS QUILLS   | HANDICAP BOONDOCK | You have watched 4 Action that"s 2 more than the DVD Rental Co. average and puts you top 5 % of experts.    | Animation | JUGGLER HARDLY | DOGMA FAMILY   | STORM HAPPINESS     | You have watched 3 Animation films making up 12 % of your total watch history! | JAYNE NOLTE    | ENGLISH BULWORTH  | SWEETHEARTS SUSPECTS  | DANCING FEVER          |
| 4           | Horror   | PULP BEVERLY        | FAMILY SWEET      | SWARM GOLD        | You have watched 3 Horror that"s 2 more than the DVD Rental Co. average and puts you top 8 % of experts.    | Comedy    | ZORRO ARK      | CAT CONEHEADS  | CLOSER BANG         | You have watched 2 Comedy films making up 9 % of your total watch history!     | WALTER TORN    | HOBBIT ALIEN      | WITCHES PANIC         | CURTAIN VIDEOTAPE      |
| 5           | Classics | TIMBERLAND SKY      | FROST HEAD        | GILMORE BOILED    | You have watched 7 Classics that"s 5 more than the DVD Rental Co. average and puts you top 1 % of experts.  | Animation | JUGGLER HARDLY | DOGMA FAMILY   | STORM HAPPINESS     | You have watched 6 Animation films making up 16 % of your total watch history! | KARL BERRY     | VIRGINIAN PLUTO   | STAGECOACH ARMAGEDDON | TELEMARK HEARTBREAKERS |


</details>

