select * from Swiggy 
limit 10;

-- 1. How many resturants have rating more than 4.5 ?--

select count( distinct restaurant_name) as High_rated_restaurant
from swiggy
where rating > 4.5;

-- 2. which is top city with the highest no. of restaurants?--

SELECT 
    city, 
    COUNT(DISTINCT restaurant_no) AS total_restaurants
FROM 
    swiggy
GROUP BY 
    city
ORDER BY 
    total_restaurants DESC
LIMIT 1;

-- 3. How many restaurant sell ( have "pizza" in their name)--
SELECT DISTINCT restaurant_name AS total_pizza_restaurants
FROM 
    swiggy
WHERE 
    restaurant_name LIKE '%pizza%';
    
    -- 4. o find the most common cuisine among the restaurants--
    SELECT 
    cuisine, 
    COUNT(*) AS total_restaurants
FROM 
    swiggy
GROUP BY 
    cuisine
ORDER BY 
    total_restaurants DESC
LIMIT 1;

-- 5. To calculate the average rating of restaurants in each city--
SELECT 
    city, 
    ROUND(AVG(rating), 2) AS avg_rating
FROM 
    swiggy
GROUP BY 
    city
ORDER BY 
    avg_rating DESC;

-- 6. To find the highest price of an item under the "recommended" menu category for each restaurant--
SELECT 
    restaurant_name,
    MAX(price) AS highest_price
FROM 
    swiggy
WHERE 
    menu_category = 'recommended'
GROUP BY 
    restaurant_name;
    
    
-- 7.find the top 5 most expensive restaurants that offer cuisine other than Indian cuisine--
SELECT 
    restaurant_no, 
    restaurant_name, 
    city, 
    cuisine, 
    AVG(cost_per_person) AS avg_cost_per_person
FROM 
    swiggy
WHERE 
    cuisine NOT LIKE '%Indian%'
GROUP BY 
    restaurant_no, 
    restaurant_name, 
    city, 
    cuisine
ORDER BY 
    avg_cost_per_person DESC
LIMIT 5;

-- 8. To find the restaurants where the cost per person is higher than the average cost of all restaurants--
SELECT restaurant_name, cost_per_person
FROM swiggy
WHERE cost_per_person > (SELECT AVG(cost_per_person) FROM swiggy);


-- 9.  retrieve the details of restaurants that have the same name but are located in different cities--
SELECT DISTINCT t1. restaurant_name , t1. city, t2. city
from swiggy t1 join swiggy t2
on t1.restaurant_name = t2. restaurant_name and t1.city <>t2.city;


-- 10. To find the restaurant that offers the most number of items in the 'Main course' category--

SELECT restaurant_name, COUNT(item) AS item_count
FROM swiggy
WHERE menu_category = 'Main course'
GROUP BY restaurant_name
ORDER BY item_count DESC;

-- 11. list the names of restaurants that are 100% vegeatarian and sort them alphabetically--

SELECT DISTINCT restaurant_name
FROM swiggy
WHERE veg_or_nonveg = 'Veg'
  AND restaurant_name NOT IN (
      SELECT restaurant_name
      FROM swiggy
      WHERE veg_or_nonveg <> 'Veg'
  )
ORDER BY restaurant_name ASC;


-- 12. To find the restaurant providing the lowest average price for all its items--
SELECT restaurant_name, AVG(CAST(price AS DECIMAL)) AS average_price
FROM swiggy
GROUP BY restaurant_name
ORDER BY average_price ASC
LIMIT 1;

 -- 13. To find the restaurant providing the lowest average price for all its items, you can use the following query--
 
SELECT restaurant_name, COUNT(DISTINCT menu_category) AS category_count
FROM swiggy
GROUP BY restaurant_name
ORDER BY category_count DESC
LIMIT 5;

-- 14. To find the restaurant that provides the highest percentage of non-vegetarian food--

SELECT restaurant_name, 
       (COUNT(CASE WHEN veg_or_nonveg = 'Non-Veg' THEN 1 END) * 100.0 / COUNT(*)) AS non_veg_percentage
FROM swiggy
GROUP BY restaurant_name
ORDER BY non_veg_percentage DESC
limit 1;

-- 15. To determine the most and least expensive cities for dining--

-- Most expensive city
SELECT city, AVG(cost_per_person) AS average_cost
FROM swiggy
GROUP BY city
ORDER BY average_cost DESC
LIMIT 1;

-- Least expensive city
SELECT city, AVG(cost_per_person) AS average_cost
FROM swiggy
GROUP BY city
ORDER BY average_cost ASC
LIMIT 1;




with city_exp as (
select city,
max(cost_per_person) as max_cost,
min(cost_per_person) as min_cost
from swiggy
group by city )

select city, max_cost,min_cost
from city_exp
order by max_cost desc;


-- 16 To find the top 2 rated restaurants in each city, you can use the window function --


with Rating_rank_city as (
SELECT city, restaurant_name, rating,
DENSE_RANK() OVER (PARTITION BY city ORDER BY rating DESC) AS rank_in_city
FROM swiggy
)
select * from 
 Rating_rank_city
WHERE rank_in_city <= 2
ORDER BY city, rank_in_city;











