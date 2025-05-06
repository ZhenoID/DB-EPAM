INSERT INTO film (title, description, release_year, language_id, rental_duration, rental_rate, length, replacement_cost, rating)
VALUES ('INCEPTION', 'A mind-bending thriller about dreams within dreams.', 2010, 1, 14, 4.99, 148, 19.99, 'PG-13');

INSERT INTO actor (first_name, last_name) VALUES ('Leonardo', 'DiCaprio');
INSERT INTO actor (first_name, last_name) VALUES ('Joseph', 'Gordon-Levitt');
INSERT INTO actor (first_name, last_name) VALUES ('Elliot', 'Page');

INSERT INTO inventory (film_id, store_id)
SELECT film_id, 1337
FROM film
WHERE title = 'INCEPTION';
