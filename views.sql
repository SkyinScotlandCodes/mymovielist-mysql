-- create view movie_list

CREATE VIEW vw_movie_list
AS
SELECT 
	m.movie_id AS 'MovieID', 
	m.movie_title AS 'Title', 
	GROUP_CONCAT(DISTINCT genre SEPARATOR ', ') AS 'Genres', 
	GROUP_CONCAT(DISTINCT director_name SEPARATOR ', ') AS 'DirectorNames', 
	release_year AS 'ReleaseYear', 
	CONCAT(runtime_minutes DIV 60, ' ', 'h', ' ', runtime_minutes % 60, ' ', 'm') AS 'Runtime',
	DATE_FORMAT(date_added, '%D %M %Y') AS 'DateAdded',
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
GROUP BY m.movie_id;

-- use view movie_list 

SELECT * FROM vw_movie_list;

-- create view directors_list to show numbers of movies they directed

CREATE VIEW vw_directors_list
AS
SELECT 
	d.director_id AS 'DirectorID', 
	d.director_name AS 'DirectorName', 
	GROUP_CONCAT(m.movie_title SEPARATOR ', ') AS 'MovieTitle',
	count(m.movie_title) AS 'Total'
FROM directors AS d
JOIN movie_director as md
	ON d.director_id = md.director_id
JOIN movies as m
	ON m.movie_id = md.movie_id
GROUP BY d.director_id
ORDER BY d.director_id;
