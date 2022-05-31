USE MyMovieList;

-- use stored procedure InsertNewDirector to add John Smith

SELECT * FROM directors WHERE director_name LIKE '%Smith%';

Call InsertNewDirector('John Smith');

DELETE FROM directors WHERE director_name = 'John Smith';

-- use stored procedure GetMoviesInYear to get all movies released in 2019

CALL GetMoviesInYear('2019');

-- -- use stored fuction to return gold/silver/bronze if the rating is high enough
    
SELECT * FROM movies;
    
SELECT movie_id AS 'Movie Id', movie_title AS 'Movie Title', release_year as 'Release Year', RatingRank(my_rating) as 'Rank'
FROM movies
ORDER BY my_rating;

-- use view movie_list 

SELECT * FROM vw_movie_list;

-- use view movie_list to find movies with ratings 8 or higher and released in year 2018

SELECT * FROM vw_movie_list
WHERE MyRating >= 8 AND ReleaseYear = '2018'
ORDER BY MovieID;

-- use view directors_list showing total numbers of movies they directed

SELECT * FROM vw_directors_list;

-- use view directors_list to find how many movies Wes Anderson directed

SELECT * FROM vw_directors_list WHERE DirectorName LIKE '%Wes%';

-- use view directors_list to find the movie Lilo & Stitch's director/s

SELECT * FROM vw_directors_list WHERE MovieTitle LIKE '%Lilo%';

-- find total number of movies watched by movie release year

SELECT release_year as 'Movie Release Year', COUNT(release_year) as 'Total'
FROM movies
GROUP BY release_year
ORDER BY COUNT(release_year) DESC;

-- find my highest rated movies (gold rank) in 2019

SELECT 
	m.movie_id AS 'MovieID', 
	m.movie_title AS 'Title', 
	GROUP_CONCAT(DISTINCT genre SEPARATOR ', ') AS 'Genres', 
	GROUP_CONCAT(DISTINCT director_name SEPARATOR ', ') AS 'DirectorNames', 
	release_year AS 'ReleaseYear', 
	runtime_minutes AS 'RuntimeMinutes',
	date_added AS 'DateAdded',
	my_rating AS 'MyRating',
	RatingRank(my_rating) as 'Rank'
FROM genres AS g
JOIN movie_genre AS mg
	ON g.genre_id = mg.genre_id
JOIN movies AS m
	ON mg.movie_id = m.movie_id
JOIN movie_director AS md
	ON m.movie_id = md.movie_id
JOIN directors AS d
	ON md.director_id = d.director_id
WHERE my_rating >= 8 AND release_year = '2019'
GROUP BY m.movie_id;

-- find total movie runtime in days, hours, minutes

SELECT SUM(runtime_minutes)/(60*24) as days, SUM(runtime_minutes)/60 as hours, SUM(runtime_minutes) as minutes
FROM movies;

-- find movies where the runtime is less than 2 hour

SELECT 
	movie_id AS MovieID,
	movie_title AS Title, 
	runtime_minutes AS Minutes
FROM movies
GROUP BY movie_id
HAVING runtime_minutes <= 120
ORDER BY runtime_minutes ASC;

-- find directors that directed movies less than 2 hour

SELECT 
	m.movie_id AS 'MovieID',
    movie_title AS 'Title', 
	director_name AS 'DirectorNames',
	runtime_minutes AS 'Minutes'
FROM movies AS m
JOIN movie_director AS md
	ON m.movie_id = md.movie_id
JOIN directors AS d
	ON md.director_id = d.director_id
WHERE m.movie_id IN (SELECT DISTINCT movie_id FROM movies HAVING runtime_minutes <= 120)
GROUP BY director_name
ORDER BY runtime_minutes ASC;

-- Update movie_rating for Ni no kuni

SELECT * FROM movies WHERE movie_title LIKE '%ni no%';

UPDATE movies
SET my_rating = 4
WHERE movie_id = 66;

-- find average ratings of movies per month in each year

SELECT DATE_FORMAT(date_added, '%M %Y') as 'MonthYear', ROUND(AVG(my_rating),2)
FROM movies
GROUP BY YEAR(date_added), MONTH(date_added)
ORDER BY YEAR(date_added), MONTH(date_added);

-- find total number of movies watched per month in each year where count is 10 or higher

SELECT DATE_FORMAT(date_added, '%M %Y') as 'MonthYear', COUNT(movie_id) as 'Total Movies Watched'
FROM movies
GROUP BY YEAR(date_added), MONTH(date_added)
HAVING COUNT(movie_id) >=10
ORDER BY YEAR(date_added), MONTH(date_added);

-- find total numbers of distinct movies, directors and genres

SELECT 
  COUNT(DISTINCT m.movie_id) as 'Total Number of Movies', 
  COUNT(DISTINCT d.director_id) as 'Total Number of Directors', 
  COUNT(DISTINCT g.genre_id) as 'Total Number of Genres'
FROM movies AS m
JOIN movie_director AS md
	ON m.movie_id = md.movie_id
JOIN directors AS d
	ON md.director_id = d.director_id
JOIN movie_genre AS mg
	ON m.movie_id = mg.movie_id
JOIN genres AS g
	ON g.genre_id = mg.genre_id;

-- find max rating for each genre

SELECT 
	g.genre_id AS 'GenreID',
	g.genre AS 'Top Genres',
    MAX(my_rating) AS 'MaxRating'
FROM genres AS g
JOIN movie_genre mg
	ON g.genre_id = mg.genre_id
JOIN movies AS m
	ON mg.movie_id = m.movie_id
GROUP BY g.genre
ORDER BY g.genre ASC;
