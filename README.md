## Email Marketing Campaign by DVD Rental Co.
> *It is not customer's job to know what they want.* 
>                                   - Steve Jobs

### Table of Contents
  - [📀 Business Problem](#-business-problem)
  - [🙋 Business Questions](#-business-questions)
  - [🔎Data Exploration and Analysis](#data-exploration-and-analysis)
  - [🏝️ Table Joins & Insights](#️-table-joins--insights)
  - [🏆 All in ONE](#-all-in-one)
   
---

### 📀 Business Problem 

Marketing team @DVD Rental Co. wants to launch its very first [email markeing][1] campaign and wants our help to fill missing entries in their email template. <br>
The team believes these personalized email will help increase their dvd sales and which in turn will raise company's revenue. 

[1]: https://en.wikipedia.org/wiki/Email_marketing "Email marketing is the act of sending a commercial message, typically to a group of people, using email. "


### 🙋 Business Questions

Before we proceed further have a look on email-draft  provided by the company. 

<details>
<summary><p align="center">
<img src="./Images/click_me.gif" >
<center>Click me to see see business questions.</center>
</p></summary>

<br><br>

>**Question 1** What are **top 2 movie categories** based on total movies rented by customer in each category and also **how many movies** customer has watched in each category? 

>**Question 2** For **topmost** category provide following additional insights? 

 >- **How many more films** customer has watched compared to average number of movies rented by all customers in this category? 
 >-  Where does the customer stands in terms of **top x%** compared to all other customer in this category? 
 >-  what are **top 3 movie-recommendations** ( that customer has not seen yet ) you will give to customer in this category based on total customer rental count of each movie in this category? 

>**Question 3** For **seond topmost** category provide following additional insights? 
 >-  What **percentage(%)** does this category makes up to total number of movies watched by the customer in all categories?
 >- what are **top 3 movie-recommendations** ( that customer has not seen yet ) you will give to customer in this category based on total customer rental count of each movie in this category? 

>**Question 4** **Actor recommendation**
>- **Which actor** is featured most in customer rental history of movies? 
>- **How many films featuring** this actor has been watched by customer? 
>- what are **top 3 films featuring** the same actor which are not watched by customer? 

<details>
<summary><u>🏷️ Additional Remarks for Edge Cases :</u></summary>

>* While choosing top 2 categories if there is a tie between 2nd topmost and its next category choose the category which comes first in alphabetical order.
>* Similarly , for movie recommendation , in case of tie between top 3 and next movie ,  choose the movie which come first in alphabetical order.
>* Again, for most featured actor, if there is ties between two actor, choose the actor whose name comes first in alphabetical order. 
>* If for a customer , top 3 recommendations are not available ( either for actor movie recommendation or for movie-recommendation in top 2 categories ) marketing team is happy with at least 1 movie. 
>* But in case if that is also not available then mark the customer as red-flag . make sure you flag for all 3 different types of movie-recommendations ( movie, top category, second top category) seperatly in different different column. 
</details>

</details>

### 🔎Data Exploration and Analysis [<img src="./Images/folder.gif" align=middle width=45 height=45>](./README.md "Go to folder to see full analysis") 

Data exploration is 💗 of any data science project. If you don't do this you will probably end up making observations/conclusion which are not backed by any evidence and hence of no use in real-world as nobody will believe you. 

### 🏝️ Table Joins & Insights [<img src="./Images/folder.gif" align=middle width=45 height=45>](./README.md "Go to folder to see detailed Insights") 

Data Exploration helps us understand data better but what after that? With better understanding of data lets generate insights from data using suitable table joins and many other functions to meet requirement of business. 


### 🏆 All in ONE [<img src="./Images/folder.gif" align=middle width=45 height=45>](./README.md "See Full Script") 

This is how our final table looks like 

<details>
<summary>Ultimate Table</summary>

| customer_id | cat_1    | cat_1_rec_1         | cat_1_rec_2       | cat_1_rec_3       | cat_1_insight                                                                                               | cat_2     | cat_2_rec_1    | cat_2_rec_2    | cat_2_rec_3         | cat_2_insight                                                                  | actor_name     | actor_rec_1       | actor_rec_2           | actor_rec_3            |
| ----------- | -------- | ------------------- | ----------------- | ----------------- | ----------------------------------------------------------------------------------------------------------- | --------- | -------------- | -------------- | ------------------- | ------------------------------------------------------------------------------ | -------------- | ----------------- | --------------------- | ---------------------- |
| 1           | Classics | TIMBERLAND SKY      | GILMORE BOILED    | VOYAGE LEGALLY    | You have watched 6 Classics that"s 4 more than the DVD Rental Co. average and puts you top 1 % of experts.  | Comedy    | ZORRO ARK      | CAT CONEHEADS  | OPERATION OPERATION | You have watched 5 Comedy films making up 16 % of your total watch history!    | VAL BOLGER     | PRIMARY GLASS     | ALASKA PHANTOM        | METROPOLIS COMA        |
| 2           | Sports   | GLEAMING JAWBREAKER | TALENTED HOMICIDE | ROSES TREASURE    | You have watched 5 Sports that"s 3 more than the DVD Rental Co. average and puts you top 3 % of experts.    | Classics  | FROST HEAD     | GILMORE BOILED | VOYAGE LEGALLY      | You have watched 4 Classics films making up 15 % of your total watch history!  | GINA DEGENERES | GOODFELLAS SALUTE | WIFE TURN             | DOGMA FAMILY           |
| 3           | Action   | RUGRATS SHAKESPEARE | SUSPECTS QUILLS   | HANDICAP BOONDOCK | You have watched 4 Action that"s 2 more than the DVD Rental Co. average and puts you top 5 % of experts.    | Animation | JUGGLER HARDLY | DOGMA FAMILY   | STORM HAPPINESS     | You have watched 3 Animation films making up 12 % of your total watch history! | JAYNE NOLTE    | ENGLISH BULWORTH  | SWEETHEARTS SUSPECTS  | DANCING FEVER          |
| 4           | Horror   | PULP BEVERLY        | FAMILY SWEET      | SWARM GOLD        | You have watched 3 Horror that"s 2 more than the DVD Rental Co. average and puts you top 8 % of experts.    | Comedy    | ZORRO ARK      | CAT CONEHEADS  | CLOSER BANG         | You have watched 2 Comedy films making up 9 % of your total watch history!     | WALTER TORN    | HOBBIT ALIEN      | WITCHES PANIC         | CURTAIN VIDEOTAPE      |
| 5           | Classics | TIMBERLAND SKY      | FROST HEAD        | GILMORE BOILED    | You have watched 7 Classics that"s 5 more than the DVD Rental Co. average and puts you top 1 % of experts.  | Animation | JUGGLER HARDLY | DOGMA FAMILY   | STORM HAPPINESS     | You have watched 6 Animation films making up 16 % of your total watch history! | KARL BERRY     | VIRGINIAN PLUTO   | STAGECOACH ARMAGEDDON | TELEMARK HEARTBREAKERS |

</details>

All column names and further explainations are provided in [All_in_One](All_in_one) Folder.
Now marketing team can use this table to do their email-marketing. Good luck 





























