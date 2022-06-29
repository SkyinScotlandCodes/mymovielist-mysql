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

