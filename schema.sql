-- create database MyMovieList

CREATE DATABASE MyMovieList;

USE MyMovieList;

-- create movies table

CREATE TABLE movies (
	movie_id INT NOT NULL AUTO_INCREMENT,
    movie_title VARCHAR(250) NOT NULL,
    release_year VARCHAR(4),
    runtime_minutes SMALLINT NOT NULL, 
    date_added DATE NOT NULL,
    my_rating TINYINT NOT NULL,
    PRIMARY KEY (movie_id)
);

SELECT * FROM movies;

-- create directors table

CREATE TABLE directors (
	director_id INT NOT NULL AUTO_INCREMENT,
    director_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (director_id)
);

SELECT * FROM directors;

-- create genres table

CREATE TABLE genres (
	genre_id INT NOT NULL AUTO_INCREMENT,
    genre VARCHAR(50) NOT NULL,
    PRIMARY KEY (genre_id)
);

SELECT * FROM genres;

-- create movie_director table (junction table with composite key - will prevent duplicate movie/director combinations from being added to the table)

CREATE TABLE movie_director (
	movie_id INT NOT NULL,
    director_id INT NOT NULL,
    CONSTRAINT pk_movie_director PRIMARY KEY (director_id, movie_id),
    CONSTRAINT fk_movie_director_id FOREIGN KEY (director_id) REFERENCES directors (director_id),
    CONSTRAINT fk_movie_movie_id FOREIGN KEY (movie_id) REFERENCES movies (movie_id)
);

SELECT * FROM movie_director;

-- create movie_genre table (junction table with composite key - will prevent duplicate movie/genre combinations from being added to the table.)

CREATE TABLE movie_genre (
	movie_id INT NOT NULL,
    genre_id INT NOT NULL,
    CONSTRAINT pk_movie_genre PRIMARY KEY (genre_id, movie_id),
    CONSTRAINT fk_movie_genre_genre_id FOREIGN KEY (genre_id) REFERENCES genres (genre_id),
    CONSTRAINT fk_movie_genre_movie_id FOREIGN KEY (movie_id) REFERENCES movies (movie_id)
);

SELECT * FROM movie_genre;

-- create stored procedure InsertNewDirector to add new directors

DELIMITER //
CREATE PROCEDURE InsertNewDirector (IN NewDirectorName VARCHAR(50))
BEGIN
	INSERT INTO directors (director_name)
	VALUES
	(NewDirectorName);
END //
DELIMITER ;

-- create stored procedure GetMoviesInYear

DELIMITER //
CREATE PROCEDURE GetMoviesInYear (IN releaseyear VARCHAR(4))
BEGIN 
	SELECT * FROM movies WHERE release_year = releaseyear;
END //
DELIMITER ;


-- create stored function to return gold/silver/bronze if the rating is high enough

DELIMITER //
CREATE FUNCTION RatingRank(my_rating INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
		DECLARE RatingRank VARCHAR(20);
		IF my_rating >= 8 THEN 
			SET RatingRank = 'GOLD';
		ELSEIF (my_rating >= 5 AND my_rating < 8) THEN
			SET RatingRank  ='SILVER';
		ELSEIF my_rating < 5 THEN
			SET RatingRank  = 'BRONZE';
		END IF;
		RETURN (RatingRank);
END //
DELIMITER ;

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

