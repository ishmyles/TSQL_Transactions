CREATE PROCEDURE MULTIPLY @param1 int = 0, @param2 int = 0
AS
BEGIN
	SELECT CONCAT('The product of ', @param1, ' and ', @param2, ' is ', (@param1 * @param2));
END;
--
EXEC MULTIPLY @param1 = 9, @param2 = 9; 
--
DROP PROCEDURE MULTIPLY;
GO