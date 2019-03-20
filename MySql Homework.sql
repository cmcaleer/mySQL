use sakila;

#Problem 1a. Display the first and last names of all actors from the table actor
select actor.first_name, actor.last_name 
from actor; 

SET SQL_SAFE_UPDATES = 0;

#Problem 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name
Alter table actor 
add column 
Actor_Name varchar(50) not null;
UPDATE actor SET Actor_name = concat(first_name," ",last_name); 

/* Problem 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
What is one query would you use to obtain this information? */
select actor.actor_id, actor.first_name,actor.last_name 
from actor 
where first_name = 'JOE';  

#Problem 2b. Find all actors whose last name contain the letters GEN
select actor.Actor_Name 
from actor 
where last_name like '%GEN%'; 

#Problem 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order
select actor.actor_id, actor.first_name,actor.last_name 
from actor 
where last_name like '%LI%' 
order by last_name asc, 
		first_name asc; 

#Problem 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China 
SELECT country.country_id , country.country 
from country   
WHERE country IN ('Afghanistan','Bangladesh','China');      

/* Problem 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, 
so create a column in the table actor named description and use the data type BLOB */
Alter table actor 
add column Description blob; 
    
#Problem 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column
Alter table actor 
drop column Description; 

#Problem 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(*) AS Last_name_count 
from actor 
group by last_name; 
        
#Problem 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(*) AS Last_name_count 
from actor 
group by last_name 
having Last_name_count >= 2; 

#Problem 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record
update actor set first_name = 'HARPO' 
where last_name = 'WILLIAMS' 
and first_name = 'GROUCHO'; 

 /* Problem 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! 
 In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO */
update actor set first_name = 'GROUCHO' 
where last_name = 'WILLIAMS' 
and first_name = 'HARPO';

#Problem 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
select * from INFORMATION_SCHEMA.TABLES
where TABLES.TABLE_NAME like 'address'; 

#Problem 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address
select staff.first_name, staff.last_name, address.address
from staff
inner join address 
on staff.address_id = address.address_id; 

#Problem 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment
select staff.first_name, staff.last_name, sum(payment.amount) as Total_Rung 
from staff 
inner join payment 
on staff.staff_id = payment.staff_id 
where payment.payment_date like '2005-08%'
group by staff.staff_id;   

#Problem 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join
create view Merge_data2 as      
select film.film_id, film.title, film_actor.actor_id
from film 
inner join film_actor
on film.film_id = film_actor.film_id;
select merge_data2.title, count(actor.Actor_Name) as Total_Actors_in_Film
from merge_data2 left join actor  
on merge_data2.actor_id = actor.actor_id
group by title;                        

#Problem 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT title, (select count(*) from inventory WHERE film.film_id = inventory.film_id) AS 'Number of Copies' 
FROM film
where title = 'Hunchback Impossible';

/* Problem 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
List the customers alphabetically by last name */
select customer.first_name, customer.last_name, sum(payment.amount)
from customer
join payment
on customer.customer_id = payment.customer_id
group by customer.customer_id
order by last_name asc;
                    
/* Problem 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters 
K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English */
SELECT title, (select name from language WHERE language.language_id = film.language_id) AS 'Language'
from film
where (film.title like 'q%' or film.title like 'k%') and language_id = 1;
  
#Problem 7b. Use subqueries to display all actors who appear in the film Alone Trip
select Actor_name from actor 
where actor_id in (
select actor_id from film_actor 
where film_id in (
select film_id from film
where title = 'Alone Trip'))

#Problem 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information
select first_name, last_name, email
from customer, address, city, country 
where country.country_id = city.country_id 
and city.city_id = address.city_id 
and customer.address_id = address.address_id 
and country.country = 'Canada';

#Problem 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films
select title 
from film, category, film_category
where film.film_id = film_category.film_id 
and category.category_id = film_category.category_id
and category.name = 'family';
                                       
#Problem 7e. Display the most frequently rented movies in descending order.
select title, count(rental.inventory_id) as Times_Rented
from rental, inventory, film
where inventory.inventory_id = rental.inventory_id
and inventory.film_id = film.film_id
group by film.title
order by Times_Rented desc;
    
#Problem 7f. Write a query to display how much business, in dollars, each store brought in.
select store_id, sum(amount) as 'Total_Store_Sales'
from payment, customer
where payment.customer_id = customer.customer_id
group by store_id;
 
#Problem 7g. Write a query to display for each store its store ID, city, and country.
select store_id, city, country
from store,address,city,country
where store.address_id = address.address_id
and address.city_id = city.city_id
and city.country_id = country.country_id;

/* Problem 7h. List the top five genres in gross revenue in descending order. 
(Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.) */
		
select name, sum(amount) as Total_Revenue
from category, film_category, inventory, payment, rental
where payment.rental_id = rental.rental_id
and rental.inventory_id = inventory.inventory_id
and inventory.film_id = film_category.film_id
and film_category.category_id = category.category_id
group by name
order by Total_Revenue desc
limit 5;

/* Problem 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view */
create view Top_5_Genres as
select name, sum(amount) as Total_Revenue
from category, film_category, inventory, payment, rental
where payment.rental_id = rental.rental_id
and rental.inventory_id = inventory.inventory_id
and inventory.film_id = film_category.film_id
and film_category.category_id = category.category_id
group by name
order by Total_Revenue desc
limit 5;

#Problem 8b. How would you display the view that you created in 8a?
select * from Top_5_Genres;

#Problem 8c. You find that you no longer need the view top_five_genres. Write a query to delete it
drop view Top_5_Genres;

SET SQL_SAFE_UPDATES = 1;



