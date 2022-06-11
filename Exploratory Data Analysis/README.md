## Exploratory Data Analysis
---

>**Short Story** : Even Mathematician Srinivasa Ramanujan had to provide proof to every result he claimed was true to get published. Even though G.H. Hardy  believed him but that doesn't validate his research. At last when he provided proofs and then his theory of **higly composite numbers** was published which helped him gain recognition throughout the world for first time. Rest is history. 



Have a look at diagram below which shows all table provided by DVD Rental Co. and their inter-relationships. 

<p align="center">
<img src="../Images/erd.png" width="700" height="400">
</p>

Looking at [business questions](../README.md#📀-business-problem) and these tables, it is clear we need to join the table and peroform some intese calculations to get the desired results we want.

While performing table join our only point of concern is if there is any data loss w.r.t. customer or not. other than that we are also concerned about avoiding duplicates unless they are important. 

Lets begin!

I have here created crux of my analysis.

| Left_table | Right_table | Foreign_key |Join type|  Analysis | 
|--|--|--|--|--|
|rental|inventory|inventory_id|`INNER`|[<img src="../Images/click_me.gif" alt="drawing" width="30"/>](../Exploratory%20Data%20Analysis/analysis_1.sql)
|inventory|film|film_id|`INNER`|[<img src="../Images/click_me.gif" alt="drawing" width="30"/>](../Exploratory%20Data%20Analysis/analysis_2.sql)|
|film|film_category|film_id|`INNER`|[<img src="../Images/click_me.gif" alt="drawing" width="30"/>](../Exploratory%20Data%20Analysis/analysis_3.sql)|
|film_category|category|category_id|`INNER`|[<img src="../Images/click_me.gif" alt="drawing" width="30"/>](../Exploratory%20Data%20Analysis/analysis_4.sql)|
|film| film_actor | film_id | `None`  |[<img src="../Images/click_me.gif" alt="drawing" width="30"/>](../Exploratory%20Data%20Analysis/analysis_5.sql)|
|film_actor|actor|actor_id| `INNER`|[<img src="../Images/click_me.gif" alt="drawing" width="30"/>](../Exploratory%20Data%20Analysis/analysis_6.sql)|











