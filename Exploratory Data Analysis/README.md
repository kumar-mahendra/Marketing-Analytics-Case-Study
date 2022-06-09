## Exploratory Data Analysis
---

Have a look at diagram below which shows all table provided by DVD Rental Co. and their inter-relationships. 

<p align="center">
<img src="../Images/erd.png" width="700" height="400">
</p>

Looking at [business questions](../README.md#📀-business-problem) and these tables, it is clear we need to join the table and peroform some intese calculations to get the desired results we want.

While performing table join our only point of concern is if there is any data loss w.r.t. customer or not. other than that we are also concerned about avoiding duplicates unless they are important. 

Lets begin!

I have here created crux of my analysis. 

| left_table | right_table | foreign_key |Join type| output_name | Analysis | 
|--|--|--|--|--|--|
|rental|inventory|inventory_id|INNER| table_join_1 |  [<img src="../images/click_me.gif" alt="drawing" width="30"/>](../Exploratory%20Data%20Analysis/analysis_1.sql)
|inventory|film|film_id|INNER|table_join_2| [<img src="../images/click_me.gif" alt="drawing" width="30"/>](../Exploratory%20Data%20Analysis/analysis_2.sql)|
|film|film_category|film_id|INNER|table_join_3|[<img src="../images/click_me.gif" alt="drawing" width="30"/>](../Exploratory%20Data%20Analysis/analysis_3.sql)|kv
|film_category|category|category_id|INNER|table_join_4|[<img src="../images/click_me.gif" alt="drawing" width="30"/>](../Exploratory%20Data%20Analysis/analysis_4.sql)|












