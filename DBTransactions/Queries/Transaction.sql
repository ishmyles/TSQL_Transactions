GO
CREATE PROCEDURE dbo.AccountTransfer(@fromAcct INT, @toAcct INT, @transAmt MONEY)
AS
BEGIN
	BEGIN TRANSACTION;
	SAVE TRANSACTION SavePoint;

	BEGIN TRY
	UPDATE dbo.Account
	SET Balance -= @transAmt
	WHERE AcctNo = @fromAcct

	UPDATE dbo.Account
	SET Balance += @transAmt
	WHERE AcctNo = @toAcct

	INSERT dbo.Log(OrigAcct, LogDateTime, RecAcct, Amount) VALUES
	(
		@fromAcct,
		CONVERT(DATETIME, CURRENT_TIMESTAMP, 100),
		@toAcct,
		@transAmt
	)
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION SavePoint;
	END CATCH
	COMMIT TRANSACTION;
END;
GO 

--EXEC dbo.AccountTransfer 23456789, 12345678, 300.00

--DROP PROCEDURE dbo.AccountTransfer;
--GO