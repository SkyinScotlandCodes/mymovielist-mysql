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
