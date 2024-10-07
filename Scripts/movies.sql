
--Q1. Give the name, release year, and worldwide gross of the lowest grossing movie.
SELECT s.film_title, s.release_year, r.worldwide_gross
FROM specs AS s
INNER JOIN revenue r
USING(movie_id)
GROUP BY s.film_title, s.release_year, r.worldwide_gross
ORDER BY MIN(worldwide_gross) 
LIMIT 1
-- Answer = "Semi-Tough"	1977	37187139

--Q2. What year has the highest average imdb rating?
SELECT s.film_title, s.release_year, ROUND(AVG(r.imdb_rating),2) AS avg_imdb_rating
FROM specs AS s
INNER JOIN rating r
USING(movie_id)
GROUP BY s.film_title, s.release_year
ORDER BY avg_imdb_rating DESC
LIMIT 1
--Answer = 2008

--Q3. What is the highest grossing G-rated movie? Which company distributed it?

SELECT s.film_title, s.release_year, d.company_name, r.worldwide_gross
FROM specs AS s
INNER JOIN distributors AS d
ON s.domestic_distributor_id = d.distributor_id
INNER JOIN revenue AS r
USING(movie_id)
WHERE s.mpaa_rating ='G'
GROUP BY s.film_title, s.release_year,d.company_name, r.worldwide_gross
ORDER BY r.worldwide_gross DESC
LIMIT 1
--Answer = In 2019 "Toy Story 4" was the highest grossing G-rated movie, distributed by "Walt Disney"

--Q4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.

SELECT d.company_name AS distributor, COUNT(s.movie_id) AS movie_count
FROM distributors AS d
LEFT JOIN specs AS s
ON d.distributor_id = s.domestic_distributor_id
GROUP BY d.company_name
ORDER BY movie_count DESC
--Answer = table with 23 distributors and movie count as second column

--Q5. Write a query that returns the five distributors with the highest average movie budget.
SELECT s.film_title, d.company_name, ROUND(AVG(film_budget),0) AS avg_movie_budget
FROM specs AS s
INNER JOIN distributors AS d
ON s.domestic_distributor_id = d.distributor_id
INNER JOIN revenue AS r
USING(movie_id)
GROUP BY s.film_title, d.company_name
ORDER BY avg_movie_budget DESC
LIMIT 5

--6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?

SELECT s.film_title, d.company_name, r.imdb_rating
FROM specs AS s
INNER JOIN distributors AS d
ON s.domestic_distributor_id = d.distributor_id
INNER JOIN rating AS r
USING(movie_id)
WHERE headquarters NOT LIKE '%CA' 
ORDER By imdb_rating DESC

--Q7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?

SELECT s.film_title, s.release_year,s.length_in_min/60  AS length_in_hour, ROUND(AVG(r.imdb_rating),2) AS avg_imdb_rating
FROM specs AS s
INNER JOIN rating r
USING(movie_id)
--WHERE s.length_in_min/60 < 2
--103 out of 223 7+ rating
--WHERE s.length_in_min/60 > 2
--8 out of 9 7+ rating
--WHERE s.length_in_min/60 = 2
-- 131 out of 198 7+ rating
GROUP BY s.film_title, s.release_year, s.length_in_min
--ORDER BY avg_imdb_rating DESC
ORDER BY avg_imdb_rating DESC, length_in_hour


/* Fun Facts:
3 movies With G rating throughout = Cars(2 movies),Monsters(2 movies),TOY story(4 movies)
4 movies Evolved from G to PG = aladdin, Beauty and the Beast,Finding Nemo(G) and Dori(PG), The Lion King 
1 movie with Null rating = "Wolf Warrior 2" distributor = The H Collective worldwide gross = 870325439 */
