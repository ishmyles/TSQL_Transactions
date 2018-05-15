﻿/*
Deployment script for TSQL-TransactionDB

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar LoadTestData "true"
:setvar DatabaseName "TSQL-TransactionDB"
:setvar DefaultFilePrefix "TSQL-TransactionDB"
:setvar DefaultDataPath ""
:setvar DefaultLogPath ""

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
IF EXISTS (SELECT 1
           FROM   [sys].[databases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [sys].[databases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ALLOW_SNAPSHOT_ISOLATION OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [sys].[databases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE (CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), MAX_STORAGE_SIZE_MB = 100) 
            WITH ROLLBACK IMMEDIATE;
    END


GO
PRINT N'Creating [dbo].[Account]...';


GO
CREATE TABLE [dbo].[Account] (
    [AcctNo]      INT           NOT NULL,
    [Fname]       NVARCHAR (15) NOT NULL,
    [Lname]       NVARCHAR (15) NOT NULL,
    [CreditLimit] MONEY         NOT NULL,
    [Balance]     MONEY         NOT NULL,
    CONSTRAINT [PK_ACCOUNT] PRIMARY KEY CLUSTERED ([AcctNo] ASC),
    CONSTRAINT [UC_ACCOUNT] UNIQUE NONCLUSTERED ([Fname] ASC, [Lname] ASC)
);


GO
PRINT N'Creating [dbo].[Log]...';


GO
CREATE TABLE [dbo].[Log] (
    [OrigAcct]    INT      NOT NULL,
    [LogDateTime] DATETIME NOT NULL,
    [RecAcct]     INT      NULL,
    [Amount]      MONEY    NOT NULL,
    CONSTRAINT [PK_LOG] PRIMARY KEY CLUSTERED ([OrigAcct] ASC, [LogDateTime] ASC)
);


GO
PRINT N'Creating [dbo].[FK_LOG_ORIGACCT]...';


GO
ALTER TABLE [dbo].[Log] WITH NOCHECK
    ADD CONSTRAINT [FK_LOG_ORIGACCT] FOREIGN KEY ([OrigAcct]) REFERENCES [dbo].[Account] ([AcctNo]);


GO
PRINT N'Creating [dbo].[FK_LOG_RECACCT]...';


GO
ALTER TABLE [dbo].[Log] WITH NOCHECK
    ADD CONSTRAINT [FK_LOG_RECACCT] FOREIGN KEY ([RecAcct]) REFERENCES [dbo].[Account] ([AcctNo]);


GO
PRINT N'Creating [dbo].[CHK_CREDITLIMIT]...';


GO
ALTER TABLE [dbo].[Account] WITH NOCHECK
    ADD CONSTRAINT [CHK_CREDITLIMIT] CHECK (CreditLimit < $0);


GO
PRINT N'Creating [dbo].[CHK_BALANCE]...';


GO
ALTER TABLE [dbo].[Account] WITH NOCHECK
    ADD CONSTRAINT [CHK_BALANCE] CHECK (Balance > CreditLimit);


GO
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
GO

GO
