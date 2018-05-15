/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

IF '$(LoadTestData)' = 'true'

BEGIN

DELETE FROM Log;
DELETE FROM Account;

INSERT INTO Account(AcctNo, Fname, Lname, CreditLimit, Balance) VALUES
(12345678, 'Kobe', 'Bryant', -$500.00, $2400.00),
(23456789, 'Michael', 'Jordan', -$1000.00, $2300.00),
(34567890, 'Tim', 'Duncan', -$750.00, $2100.00);


INSERT INTO Log(OrigAcct, LogDateTime, RecAcct, Amount) VALUES
(
	23456789,
	CONVERT(DATETIME, '02/APR/2018 12:34:56:000', 100),
	12345678,
	$500.00
),

(
	34567890,
	CONVERT(DATETIME, '14/APR/2018 15:46:23:000', 100),
	23456789,
	$600.00
),

(
	34567890,
	CONVERT(DATETIME, '25/APR/2018 19:25:15:000', 100),
	12345678,
	$100.00
),

(
	12345678,
	CONVERT(DATETIME, '07/MAY/2018 09:17:30:000', 100),
	34567890,
	50.00
)

END;