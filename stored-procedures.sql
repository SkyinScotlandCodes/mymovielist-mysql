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
