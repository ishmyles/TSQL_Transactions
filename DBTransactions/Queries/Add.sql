CREATE FUNCTION ADDITION (@param1 int, @param2 int) 
RETURNS NVARCHAR(50) AS
BEGIN
	RETURN CONCAT('The sum of ', @param1, ' and ', @param2, ' is ', (@param1 + @param2)); 
END;
--
--BEGIN
--	SELECT dbo.ADDITION(3, 4);
--END;
--
--DROP FUNCTION ADDITION;
--GO