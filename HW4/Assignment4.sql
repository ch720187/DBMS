
/*What is the average length of films in each category? List the results in alphabetic order of categories.*/
Select category.name, avg(film.length) as "Average Length" from film
INNER JOIN film_category 
On film.film_id = film_category.film_id
INNER JOIN category
On category.category_id = film_category.category_id
Group by category.name order by category.name asc;
/*Gets the average length of the films in each category and lists them in alphabetical order*/

/*Which categories have the longest and shortest average film lengths?*/
Select category.name, avg(film.length) as "Average Length" from film
INNER JOIN film_category 
On film.film_id = film_category.film_id
INNER JOIN category
On category.category_id = film_category.category_id
Group by category.name order by avg(film.length) desc
Limit 1;

/*Gets the longest average lengths of the films in each category and lists them in alphabetical order*/

Select category.name, avg(film.length) as "Average Length" from film
INNER JOIN film_category 
On film.film_id = film_category.film_id
INNER JOIN category
On category.category_id = film_category.category_id
Group by category.name order by avg(film.length) asc
Limit 1;
/*Gets the shortest average lengths of the films in each category and lists them in alphabetical order*/

/*Which customers have rented action but not comedy or classic movies?*/
Create table if not exists action_customers(Select customer.customer_id from customer
INNER JOIN rental 
On customer.customer_id = rental_id
inner join inventory on rental.inventory_id = inventory.inventory_id
inner join film on inventory.film_id = film.film_id
inner join film_category on film.film_id = film_category.film_id
inner join category on film_category.category_id = category.category_id
where category.name = "Action");
/*Gets customers who have rented action movies*/

Create table if not exists not_action_customers(Select customer.customer_id from customer
INNER JOIN rental 
On customer.customer_id = rental_id
inner join inventory on rental.inventory_id = inventory.inventory_id
inner join film on inventory.film_id = film.film_id
inner join film_category on film.film_id = film_category.film_id
inner join category on film_category.category_id = category.category_id
where category.name = "Comedy" or category.name = "Classic");
/*Gets customers who have rented classic or comedy movies*/

Select customer.customer_id, customer.first_name from customer
where customer.customer_id in (Select customer_id from action_customers) and customer.customer_id not in (Select customer_id from not_action_customers);
/* Gets customers who have rented action but not comedy or classic movies*/

/*Which actor has appeared in the most English-language movies?*/
Select actor.actor_id, actor.first_name, actor.last_name, count(distinct film.film_id) from actor
INNER JOIN film_actor on actor.actor_id = film_actor.actor_id
INNER JOIN film on film_actor.film_id = film.film_id
INNER JOIN language on language.language_id = film.language_id
where language.name = "English"
Group by actor_id, actor.first_name, actor.last_name
having count(distinct film.film_id) >0
Order by count(distinct film.film_id) desc
Limit 1;
/*Gets the actor has appeared in the most English-language movies*/

/*How many distinct movies were rented for exactly 10 days from the store where Mike works?*/
Select count(distinct inventory.film_id) from staff
INNER JOIN store
On staff.store_id = store.store_id
INNER JOIN inventory
On inventory.store_id = store.store_id
INNER JOIN rental 
On rental.inventory_id = inventory.inventory_id
where staff.first_name = "Mike" and datediff(date(return_date), date(rental_date)) = 10;
/*Gets the number of distinct movies that were rented for exactly 10 days from the store where Mike works*/

/*Alphabetically list actors who appeared in the movie with the largest cast of actors.*/
Create table if not exists most_actors (Select film_id from film_actor
Group by film_id
Order by count(distinct actor_id) desc 
Limit 1);
/*Gets the film id of the move with the largest cast of actors*/


Select actor.first_name, actor.last_name from actor
INNER JOIN film_actor
On actor.actor_id = film_actor.actor_id
where film_actor.film_id in (Select film_id from most_actors)
Order by actor.last_name, actor.first_name;

/*Alphabetically lists actors who appeared in the movie with the largest cast of actors.*/
