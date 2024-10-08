
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

SELECT d.company_name, ROUND(AVG(r.film_budget),2) AS avg_movie_budget
FROM specs AS s
INNER JOIN distributors AS d
ON s.domestic_distributor_id = d.distributor_id
INNER JOIN revenue AS r
USING(movie_id)
GROUP BY d.company_name
ORDER BY avg_movie_budget DESC
LIMIT 5

--6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?

SELECT s.film_title, d.company_name, r.imdb_rating
FROM specs AS s
INNER JOIN distributors AS d
ON s.domestic_distributor_id = d.distributor_id
INNER JOIN rating AS r
USING(movie_id)
WHERE d.headquarters NOT ILIKE '%CA' 
ORDER By r.imdb_rating DESC
--Answer = 2 movies without having headquartered

--Q7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?

SELECT 'Less than 2 hours' AS movie_length, ROUND(AVG(avg_imdb_rating),2) avg_rating
FROM (
SELECT AVG(r.imdb_rating) AS avg_imdb_rating
FROM specs AS s
INNER JOIN rating r
USING(movie_id) 
GROUP BY s.length_in_min
HAVING s.length_in_min<120) 
UNION ALL
SELECT 'Greater than 2 hours' AS movie_length, ROUND(AVG(avg_imdb_rating),2) avg_rating
FROM (
Select AVG(r.imdb_rating) AS avg_imdb_rating
FROM specs AS s
INNER JOIN rating r
USING(movie_id) 
GROUP BY s.length_in_min
HAVING s.length_in_min>=120) 
--Answer = Movies over 2 hour has higher average rating i.e. 7.26 for over 2 hours and 6.92 for under 2 hours

/* Fun Facts:
3 movies With G rating throughout = Cars(2 movies),Monsters(2 movies),TOY story(4 movies)
4 movies Evolved from G to PG = aladdin, Beauty and the Beast,Finding Nemo(G) and Dori(PG), The Lion King 
1 movie with Null rating = "Wolf Warrior 2" distributor = The H Collective worldwide gross = 870325439 */

/* Q12 - Another way of doing it execution time = 
SELECT
	CASE 
		WHEN s.length_in_min > 120 THEN 'Over 2 hrs'
		ELSE 'Under 2 hrs' 
		END AS filtered_length
,	ROUND(AVG(r.imdb_rating),2) AS avg_imdb
FROM specs AS s
	INNER JOIN rating AS r
		ON s.movie_id = r.movie_id
GROUP BY 
	filtered_length
ORDER BY avg_imdb DESC;*/

