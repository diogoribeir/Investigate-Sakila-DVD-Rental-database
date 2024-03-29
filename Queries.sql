#QUESTION 1

WITH t1 AS (SELECT *
      			FROM category AS c
      			JOIN film_category AS fc
      			ON fc.category_id = c.category_id
      			JOIN film AS f
      			ON f.film_id = fc.film_id
      			JOIN Inventory AS i
      			ON i.film_id = f.film_id
      			JOIN rental AS r
      			ON i.inventory_id = r.inventory_id
      			WHERE name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
      			ORDER BY title)


SELECT title AS film_title, name AS category_name, COUNT(*) AS rental_count
FROM AS t1
GROUP BY 1,2
ORDER BY category_name, film_title, rental_count DESC;



#QUESTION 2

SELECT DATE_PART('month',r.rental_date) AS Rental_month, DATE_PART('year',r.rental_date) AS Rental_year, s.store_id,
count(*) AS count_rentals
FROM rental AS r
JOIN staff AS s
ON r.staff_id = s.staff_id
GROUP BY 1,2,3
ORDER BY count_rentals DESC;



#QUESTION 3

WITH results AS (SELECT DATE_TRUNC('month',p.payment_date) AS pay_mon,
          				c.first_name || ' ' || c.last_name AS full_name,
          				COUNT(*) AS pay_counterpermon, SUM(p.amount) AS pay_amount
          				FROM PAYMENT AS p
          				JOIN CUSTOMER AS c
          				ON p.customer_id = c.customer_id
          				WHERE DATE_TRUNC('month',p. payment_date) > '2007-01-01'
          				GROUP BY 1,2
          				ORDER BY full_name),

    	    top AS (SELECT c.first_name || ' ' || c.last_name AS full_name,
          				SUM(p.amount) AS pay_amount
          				FROM PAYMENT AS p
          				JOIN CUSTOMER AS c
          				ON p.customer_id = c.customer_id
          				GROUP BY 1
          				ORDER BY pay_amount DESC
          				LIMIT 10)

SELECT r.pay_mon, r.full_name, r.pay_counterpermon, r.pay_amount
FROM results AS r
JOIN top AS t
ON r.full_name = t.full_name
ORDER BY full_name, pay_mon;



#QUESTION 4

WITH results AS (SELECT DATE_TRUNC('month',p.payment_date) AS pay_mon,
          				c.first_name || ' ' || c.last_name AS full_name,
          				COUNT(*) AS pay_counterpermon, SUM(p.amount) AS pay_amount
          				FROM PAYMENT AS p
          				JOIN CUSTOMER AS c
          				ON p.customer_id = c.customer_id
          				WHERE DATE_TRUNC('month',p. payment_date) > '2007-01-01'
          				GROUP BY 1,2
          				ORDER BY full_name),

        top as (SELECT c.first_name || ' ' || c.last_name AS full_name,
          				SUM(p.amount) AS pay_amount
          				FROM PAYMENT AS p
          				JOIN CUSTOMER AS c
          				ON p.customer_id = c.customer_id
          				GROUP BY 1
          				ORDER BY pay_amount DESC
          				LIMIT 10),

        t1 AS (SELECT r.pay_mon, r.full_name, r.pay_counterpermon, r.pay_amount
                  FROM results AS r
                  JOIN top AS t
                  ON r.full_name = t.full_name
                  ORDER BY full_name, pay_mon)

SELECT *,
pay_amount - LAG(pay_amount) OVER (ORDER BY full_name) AS difference,
LAG(pay_amount) OVER (ORDER BY full_name) AS lag_collumn
FROM t1;
