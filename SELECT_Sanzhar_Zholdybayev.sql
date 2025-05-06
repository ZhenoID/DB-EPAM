
-- Task 1: Staff members with the highest revenue per store in 2017

-- Solution 1: Using RANK()
SELECT store_id, staff_id, total_revenue
FROM (
    SELECT s.store_id, p.staff_id, SUM(p.amount) AS total_revenue,
           RANK() OVER (PARTITION BY s.store_id ORDER BY SUM(p.amount) DESC) AS rnk
    FROM payment p
    JOIN rental r ON p.rental_id = r.rental_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN store s ON i.store_id = s.store_id
    WHERE DATE_PART('year', p.payment_date) = 2017
    GROUP BY s.store_id, p.staff_id
) ranked
WHERE rnk = 1;


-- Solution 2: Using DISTINCT ON (PostgreSQL-specific)
SELECT DISTINCT ON (s.store_id) s.store_id, p.staff_id, SUM(p.amount) AS total_revenue
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN store s ON i.store_id = s.store_id
WHERE DATE_PART('year', p.payment_date) = 2017
GROUP BY s.store_id, p.staff_id
ORDER BY s.store_id, SUM(p.amount) DESC;



-- Task 2: Five most rented movies and expected audience age

-- Solution 1: Top 5 rented films with rating
SELECT f.title, f.rating, COUNT(*) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title, f.rating
ORDER BY rental_count DESC
LIMIT 5;

-- Solution 2: Top 5 with expected audience age based on rating
WITH rentals_per_film AS (
  SELECT f.film_id, f.title, f.rating, COUNT(*) AS rental_count
  FROM film f
  JOIN inventory i ON f.film_id = i.film_id
  JOIN rental r ON i.inventory_id = r.inventory_id
  GROUP BY f.film_id, f.title, f.rating
)
SELECT rpf.title, rpf.rating, rpf.rental_count,
       CASE rpf.rating
         WHEN 'G' THEN 'All ages'
         WHEN 'PG' THEN '7+'
         WHEN 'PG-13' THEN '13+'
         WHEN 'R' THEN '17+'
         ELSE 'Unknown'
       END AS expected_audience
FROM rentals_per_film rpf
ORDER BY rpf.rental_count DESC
LIMIT 5;



-- Task 3: Actors who didnâ€™t act for the longest time

-- Solution 1: Based on the last film's release year
SELECT a.actor_id, a.first_name, a.last_name, MAX(f.release_year) AS last_active_year
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY last_active_year
LIMIT 5;

-- Solution 2: Using CTE to rank least recent activity
WITH actor_last_year AS (
  SELECT a.actor_id, a.first_name, a.last_name, MAX(f.release_year) AS last_film_year
  FROM actor a
  JOIN film_actor fa ON a.actor_id = fa.actor_id
  JOIN film f ON fa.film_id = f.film_id
  GROUP BY a.actor_id
)
SELECT *
FROM actor_last_year
ORDER BY last_film_year ASC
LIMIT 5;
