## Email Marketing Campaign by DVD Rental Co.
> "It is not customer's job to know what they want." 
>                                   - Steve Jobs

### 📀 Business Problem 

Marketing team @DVD Rental Co. wants to launch its very first [email markeing][1] campaign and wants our help to fill missing entries in their email template. <br>
The team believes these personalized email will help increase their dvd sales and which in turn company's revenue. 

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

>#### 🏷️ Additional Remarks for Edge Cases : 

>* While choosing top 2 categories if there is a tie between 2nd topmost and its next category choose the category which comes first in alphabetical order.
>* Similarly , for movie recommendation , in case of tie between top 3 and next movie ,  choose the movie which come first in alphabetical order.
>* Again, for most featured actor, if there is ties between two actor, choose the actor whose name comes first in alphabetical order. 
>* If for a customer , top 3 recommendations are not available ( either for actor movie recommendation or for movie-recommendation in top 2 categories ) marketing team is happy with at least 1 movie. 
>* But in case if that is also not available then mark the customer as red-flag . make sure you flag for all 3 different types of movie-recommendations ( movie, top category, second top category) seperatly in different different column. 

</details>

### 🔎Data Exploration and Analysis

Data exploration is 💗 of any data science project. If you don't do this you will probably end up making observations/conclusion which are not backed by any evidence and hence of no use in real-world as nobody will believe you. 
[<center><img src="Images/eda.svg" width=300 height=100></center>](./Exploratory%20Data%20Analysis/ "Click here to see full analysis.")

### 🏝️ Table Joins & Insights

Data Exploration helps us understand data better but what after that? With better understanding of data lets generate insights from data using suitable table joins and many other functions to meet requirement of business. 

[<center><img src="Images/joins.svg" width=450 height=30></center>]( ./Table%20Joins%20%26%20Insights/ "Click here to see all insights.")


























