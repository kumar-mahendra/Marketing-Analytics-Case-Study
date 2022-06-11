## Table Joins & Insights
---

Based on business questions we have,  now we design a *plan of attack* or *solution strategy* that will help us generate **insights** at ***category level*** as well as ***actor level***

>`Note` : Click icons in front of each section to know more


### Solution Strategy 
#### Category Insights [<img src="../Images/folder.png" width=30 height=30 align=middle>](./category_insights.sql) 
 
>  **Base Table** is a table from which we start with 
- Create a Base table `base_table_category_insights` by joining all the relevent tables. It must have 
  - `customer_id` : unique id of customer 
  - `film_id` : id of film watched by a customer
  - `film_name` : name of movie associated with given film_id
  - **`category_name`** : name of movie category  
    <details>
    <summary><u>Base Table</u></summary>

    | customer_id | film_id | film_name           | category_id | category_name |
    | ----------- | ------- | --------------- | ----------- | ------------- |
    | 130         | 80      | BLANKET BEVERLY | 8           | Family        |
    | 459         | 333     | FREAKY POCUS    | 12          | Music         |
    | 408         | 373     | GRADUATE LORD   | 3           | Children      |
    | 333         | 535     | LOVE SUICIDES   | 11          | Horror        |
    | 222         | 450     | IDOLS SNATCHERS | 3           | Children      |

    </details>

- Using Base table we can derive following columns 
   - `category_count` : count of movies watched by customer in this category
  - `total_film_count` : total count of  movies watched by a customer acrosss all categories 
  - `category_percentage` : percentage of category in total watch history of customer. it is customer specific.  
  - `average_category_count` : average number of movies watched by people in each category 
  - `category_rank` : rank categories for each customer based on _most_watched_ to _least_watched_ . we can filter this for **top 2 categories**
   - `category_percent_rank`: percent rank of customer in     comparision to all other customer in  in each category
        <details>
        <summary><u>Category insights</u></summary>
            
        | customer_id | category_rank | category_name | insights                                                                                                        |
        | ----------- | ------------- | ------------- | ----------------------------------------------------------------------------------------------------------- |
        | 1           | 1             | Classics      | You have watched 6 Classics that"s 4 more than the DVD Rental Co. average and puts you top 1 % of experts.  |
        | 1           | 2             | Comedy        | You have watched 5  Comedy films making up 16 % of your total watch history!                                             |
        | 2           | 1             | Sports        | You have watched 5 Sports that"s 3 more than the DVD Rental Co. average and puts you top 3 % of experts.    |
        | 2           | 2             | Classics      | You have watched 4  Classics films making up 15 % of your total watch history!                                             |
        | 3           | 1             | Action        | You have watched 4 Action that"s 2 more than the DVD Rental Co. average and puts you top 5 % of experts.    |
     
        </details>
 
  
  
#### Category Recommendations
  
  - `total_film_count` : total count of customer who watched a given film with category_name included. 
  - `watched_film_exclusions` : first sort total_film_count by decreasing order and then anti join it with `base_table_customer_category` to get movies not watched by customer 
  - `category_recommendations` : keep only movies in top_2 categories and then recommend top_3 movies in each category
    <details>
    <summary><u>Category based movie recommendations</u></summary>

    | customer_id | category_rank | category_name | recommendation_rank | recommended_movie   |
    | ----------- | ------------- | ------------- | ------------------- | ------------------- |
    | 1           | 1             | Classics      | 1                   | TIMBERLAND SKY      |
    | 1           | 1             | Classics      | 2                   | GILMORE BOILED      |
    | 1           | 1             | Classics      | 3                   | VOYAGE LEGALLY      |
    | 1           | 2             | Comedy        | 1                   | ZORRO ARK           |
    | 1           | 2             | Comedy        | 2                   | CAT CONEHEADS       |
    | 1           | 2             | Comedy        | 3                   | OPERATION OPERATION |
    | 2           | 2             | Classics      | 1                   | FROST HEAD          |


    </details>

  `Note` : Apart from columns mentioned above we might be required to generate some intermediate columns which will not be visible in final calculation. So be aware that too.


#### Actor Insights 
- Create a Base Table `base_table_actor_insights` which contains following columns 
  - `customer_id` : unique id of customer 
  - `film_id` : id of film watched by a customer
  - `film_name` : name of movie associated with given film_id
  - **`actor_id`** : id of actor in given film . note there can be multiple actors in same film so multiple rows can be there for same customer_id and film_id combinations. 
- Using base table we can derive following `columns`
    - `top_actor_count` : use base table to find customer_id, actor_id unique combinations and count of movies featuring this actor. Then pick actor with highest count for each customer. 
      <details>
      <summary><u>Actor insights</u></summary>

      | customer_id | actor_id | actor_name     | top_actor_count | actor_insight                                                                     |
      | ----------- | -------- | -------------- | --------------- | --------------------------------------------------------------------------------- |
      | 503         | 3        | ED CHASE       | 3               | You have watched 3 films featuring Ed ! Here are some other films to binge!.      |
      | 1           | 37       | VAL BOLGER     | 6               | You have watched 6 films featuring Val ! Here are some other films to binge!.     |
      | 2           | 107      | GINA DEGENERES | 5               | You have watched 5 films featuring Gina ! Here are some other films to binge!.    |
      | 3           | 150      | JAYNE NOLTE    | 4               | You have watched 4 films featuring Jayne ! Here are some other films to binge!.   |
      | 4           | 102      | WALTER TORN    | 4               | You have watched 4 films featuring Walter ! Here are some other films to binge!.  |
      </details>

#### Actor Recommendations
- `actor_film_popularity` : join the base table to `total_film_count` (which is number of customers watched a given film ) on column film_id of-course. 
- `actor_film_exclusion` : exclude already watched and already recommended movies for each customer . 
- `actor_recommendations` : now from previous output just return valid top 3 recommendations. 

  <details>
  <summary><u>Actor based movie recommendations</u></summary>

  | customer_id | actor_name     | recommend_rank | film_name         |
  | ----------- | -------------- | -------------- | ----------------- |
  | 1           | VAL BOLGER     | 1              | PRIMARY GLASS     |
  | 1           | VAL BOLGER     | 2              | ALASKA PHANTOM    |
  | 1           | VAL BOLGER     | 3              | METROPOLIS COMA   |
  | 2           | GINA DEGENERES | 1              | GOODFELLAS SALUTE |


  </details>
    

