   DECLARE @month    int=12
   DECLARE @Counter int=0

WHILE @month > 6 --24
BEGIN
   PRINT 'LOOP is in month of';
   PRINT @month;
IF (EXISTS(SELECT * FROM sysdatabases WHERE name='InvestX_Archive'))
BEGIN
	USE [InvestX_Archive];

	IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
			   WHERE TABLE_NAME = N'AccountSessions')
	BEGIN
	 exec CreatTblAccountSessions;
	 PRINT 'AccountSessions Table Created!'
	END
	
	IF EXISTS(SELECT 1 FROM InvestX_Archive.sys.procedures 
				WHERE Name = 'GetAccountSessions')
	BEGIN
		begin try
			Select @Counter = COUNT(*) from InvestX.dbo.AccountSessions WITH (NOLOCK) WHERE CONVERT(DATE,ExpiresUtc) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));
			IF @Counter > 0
				exec GetAccountSessions @month ;
			ELSE Print('Zero Record for Archiving in InvestX.dbo.AccountSessions!')		
		end try 
		begin catch	
			select ERROR_MESSAGE() as messages;
		end catch
	END
	Else
	  PRINT('Stored Procedure GetAccountSessions does not exist!')

--///////////////////////////////////////////////////////////////////////////////////

	IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
			   WHERE TABLE_NAME = N'AccountSummaries')
	BEGIN
	 exec CreatTblAccountSummaries;
	 PRINT 'AccountSummaries Table Created!'
	END
	
	IF EXISTS(SELECT 1 FROM InvestX_Archive.sys.procedures 
				WHERE Name = 'GetAccountSummaries')
	BEGIN
		begin try
			Select @Counter = COUNT(*) from InvestX_Admin.dbo.AccountSummaries WITH (NOLOCK) WHERE CONVERT(DATE,UtcSummaryDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));
			IF @Counter > 0
				exec GetAccountSummaries @month ;
			ELSE Print('Zero Record for Archiving in InvestX_Admin.dbo.AccountSummaries!')
		end try 
		begin catch	
			select ERROR_MESSAGE() as messages;
		end catch
	END
	Else
	  PRINT('Stored Procedure GetAccountSummaries does not exist!')

--///////////////////////////////////////////////////////////////////////////////////

	IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
			   WHERE TABLE_NAME = N'AccountSummaryAccountDetails')
	BEGIN
	 exec CreatTblAccountSummaryAccountDetails;
	 PRINT 'AccountSummaryAccountDetails Table Created!'
	END
	
	IF EXISTS(SELECT 1 FROM InvestX_Archive.sys.procedures 
				WHERE Name = 'GetAccountSummaryAccountDetails')
	BEGIN
		begin try
			Select @Counter = COUNT(*) from InvestX_Admin.dbo.AccountSummaryAccountDetails WITH (NOLOCK) WHERE CONVERT(DATE,LastLoginDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));
			IF @Counter > 0
				exec GetAccountSummaryAccountDetails @month ;
			ELSE Print('Zero Record for Archiving in InvestX_Admin.dbo.AccountSummaryAccountDetails!')
		end try 
		begin catch	
			select ERROR_MESSAGE() as messages;
		end catch
	END
	Else
	  PRINT('Stored Procedure GetAccountSummaryAccountDetails does not exist!')

--///////////////////////////////////////////////////////////////////////////////////

	IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
			   WHERE TABLE_NAME = N'AdminAccountSessions')
	BEGIN
	 exec CreatTblAdminAccountSessions;
	 PRINT 'AdminAccountSessions Table Created!'
	END
	
	IF EXISTS(SELECT 1 FROM InvestX_Archive.sys.procedures 
				WHERE Name = 'GetAdminAccountSessions')
	BEGIN
		begin try
			Select @Counter = COUNT(*) from InvestX_Admin.dbo.AccountSessions 
			WITH (NOLOCK) WHERE CONVERT(DATE,ExpiresUtc) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	
			IF @Counter > 0
				exec GetAdminAccountSessions @month ;
			ELSE Print('Zero Record for Archiving in InvestX_Admin.dbo.AdminAccountSessions!')
		end try 
		begin catch	
			select ERROR_MESSAGE() as messages;
		end catch
	END
	Else
	  PRINT('Stored Procedure GetAdminAccountSessions does not exist!')

	IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
			   WHERE TABLE_NAME = N'DealSummaryDealAccounts')
	BEGIN
	 exec CreatTblDealSummaryDealAccounts;
	 PRINT 'DealSummaryDealAccounts Table Created!'
	END
	
	IF EXISTS(SELECT 1 FROM InvestX_Archive.sys.procedures 
				WHERE Name = 'GetDealSummaryDealAccounts')
	BEGIN
		begin try
				Select @Counter = COUNT(*) from InvestX_Admin.[dbo].[DealSummaryDealAccounts]
				WITH (NOLOCK) WHERE DealSummaryId in (SELECT DealSummaryId FROM  InvestX_Admin.dbo.DealSummaries
				WHERE CONVERT(DATE,UtcSummaryDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE())));	
		IF @Counter > 0
			exec GetDealSummaryDealAccounts @month ;
		ELSE Print('Zero Record for Archiving in InvestX_Admin.dbo.DealSummaryDealAccounts!')
		end try 
		begin catch	
			select ERROR_MESSAGE() as messages;
		end catch
	END
	Else
	  PRINT('Stored Procedure GetDealSummaryDealAccounts does not exist!')

--///////////////////////////////////////////////////////////////////////////////////

	IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
			   WHERE TABLE_NAME = N'DealSummaries')
	BEGIN
	 exec CreatTblDealSummaries;
	 PRINT 'DealSummaries Table Created!'
	END
	
	IF EXISTS(SELECT 1 FROM InvestX_Archive.sys.procedures 
				WHERE Name = 'GetDealSummaries')
	BEGIN
		begin try
			--Select @Counter = COUNT(*) from InvestX_Admin.dbo.DealSummaries WHERE CONVERT(DATE,ExpiresUtc) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));
		--	IF @Counter > 0
				exec GetDealSummaries @month ;
			--ELSE Print('Zero Record for Archiving in InvestX_Admin.dbo.DealSummaries!')
		end try 
		begin catch	
			select ERROR_MESSAGE() as messages;
		end catch
	END
	Else
	  PRINT('Stored Procedure GetDealSummaries does not exist!')

--///////////////////////////////////////////////////////////////////////////////////

	IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
			   WHERE TABLE_NAME = N'DealSummaryAccountDetails')
	BEGIN
	 exec CreatTblDealSummaryAccountDetails;
	 PRINT 'DealSummaryAccountDetails Table Created!'
	END
	
	IF EXISTS(SELECT 1 FROM InvestX_Archive.sys.procedures 
				WHERE Name = 'GetDealSummaryAccountDetails')
	BEGIN
		begin try
				Select @Counter = COUNT(*) from InvestX_Admin.dbo.DealSummaryAccountDetails WITH (NOLOCK) WHERE CONVERT(DATE,UtcDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));
		IF @Counter > 0
			exec GetDealSummaryAccountDetails @month ;
		ELSE Print('Zero Record for Archiving in InvestX_Admin.dbo.DealSummaryAccountDetails!')
		end try 
		begin catch	
			select ERROR_MESSAGE() as messages;
		end catch
	END
	Else
	  PRINT('Stored Procedure GetDealSummaryAccountDetails does not exist!')

--///////////////////////////////////////////////////////////////////////////////////


		IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
			   WHERE TABLE_NAME = N'FIXLogItems')
	BEGIN
	 exec CreatTblFIXLogItems;
	 PRINT 'FIXLogItems Table Created!'
	END
	
	IF EXISTS(SELECT 1 FROM InvestX_Archive.sys.procedures 
				WHERE Name = 'GetFIXLogItems')
	BEGIN
		begin try
			Select @Counter = COUNT(*) from InvestX_Logging.dbo.FIXLogItems 
			WITH (NOLOCK) WHERE CONVERT(DATE,InvestX_Logging.dbo.FIXLogItems.UtcDateTime) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	
			IF @Counter > 0
			exec GetFIXLogItems @month ;
		ELSE Print('Zero Record for Archiving in InvestX_Logging.dbo.FIXLogItems!')
		end try 
		begin catch	
			select ERROR_MESSAGE() as messages;
		end catch
	END
	Else
	  PRINT('Stored Procedure GetFIXLogItems does not exist!')

--///////////////////////////////////////////////////////////////////////////////////

	IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
	WITH (NOLOCK) WHERE TABLE_NAME = N'GenericLogItems')
	BEGIN
	 exec CreatTblGenericLogItems;
	 PRINT 'GenericLogItems Table Created!'
	END
	
	IF EXISTS(SELECT 1 FROM InvestX_Archive.sys.procedures 
				WHERE Name = 'GetGenericLogItems')
	BEGIN
		begin try
			Select @Counter = COUNT(*) from InvestX_Logging.dbo.GenericLogItems 
			WITH (NOLOCK) WHERE CONVERT(DATE,GenericLogItems."UtcDateTime") <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()))
			IF @Counter > 0
			exec GetGenericLogItems @month ;
		ELSE Print('Zero Record for Archiving in InvestX_Logging.dbo.GenericLogItems!')
		end try 
		begin catch	
			select ERROR_MESSAGE() as messages;
		end catch
	END
	Else
	  PRINT('Stored Procedure GetGenericLogItems does not exist!')

--///////////////////////////////////////////////////////////////////////////////////

	IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = N'Heartbeat')
	BEGIN
	 exec CreatTblHeartbeat;
	 PRINT 'Heartbeat Table Created!'
	END
	
	IF EXISTS(SELECT 1 FROM InvestX_Archive.sys.procedures 
				WHERE Name = 'GetHeartbeat')
	BEGIN
		begin try
			Select @Counter = COUNT(*) from InvestX_Logging.dbo.Heartbeat 
			WITH (NOLOCK) WHERE CONVERT(DATE,RegisterDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	
			IF @Counter > 0
			exec GetHeartbeat @month ;
		ELSE Print('Zero Record for Archiving in InvestX_Logging.dbo.Heartbeat!')
		end try 
		begin catch	
			select ERROR_MESSAGE() as messages;
		end catch
	END
	Else
	  PRINT('Stored Procedure GetHeartbeat does not exist!')

--///////////////////////////////////////////////////////////////////////////////////

	IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = N'HttpContextLogItems')
	BEGIN
	 exec CreatTblHttpContextLogItems;
	 PRINT 'HttpContextLogItems Table Created!'
	END
	
	IF EXISTS(SELECT 1 FROM InvestX_Archive.sys.procedures 
				WHERE Name = 'GetHttpContextLogItems')
	BEGIN
		begin try
			Select @Counter = COUNT(*)  from InvestX_Logging.dbo.HttpContextLogItems 
			WITH (NOLOCK) WHERE CONVERT(DATE,"UtcDateTime") <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	
			IF @Counter > 0
			exec GetHttpContextLogItems @month ;
		ELSE Print('Zero Record for Archiving in InvestX_Logging.dbo.HttpContextLogItems!')
		end try 
		begin catch	
			select ERROR_MESSAGE() as messages;
		end catch
	END
	Else
	  PRINT('Stored Procedure GetHttpContextLogItems does not exist!')

	--///////////////////////////////////////////////////////////////////////////////////
	
	IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = N'ITCHLogItems')
	BEGIN
	 exec CreatTblITCHLogItems;
	 PRINT 'ITCHLogItems Table Created!'
	END
	
	IF EXISTS(SELECT 1 FROM InvestX_Archive.sys.procedures 
				WHERE Name = 'GetITCHLogItems')
	BEGIN
		begin try
			Select @Counter = COUNT(*)  from InvestX_Logging.dbo.ITCHLogItems 
			WITH (NOLOCK) WHERE CONVERT(DATE,UtcDateTime) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	
			IF @Counter > 0
			exec GetITCHLogItems @month ;
		ELSE Print('Zero Record for Archiving in InvestX_Logging.dbo.ITCHLogItems!')
		end try 
		begin catch	
			select ERROR_MESSAGE() as messages;
		end catch
	END
	Else
	  PRINT('Stored Procedure GetITCHLogItems does not exist!')

--///////////////////////////////////////////////////////////////////////////////////
	
	IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = N'SectionContentEditHistory')
	BEGIN
	 exec CreatTblSectionContentEditHistory;
	 PRINT 'SectionContentEditHistory Table Created!'
	END
	
	IF EXISTS(SELECT 1 FROM InvestX_Archive.sys.procedures 
				WHERE Name = 'GetSectionContentEditHistory')
	BEGIN
		begin try
			Select @Counter = COUNT(*)  from InvestX.dbo.SectionContentEditHistory 
			WITH (NOLOCK) WHERE CONVERT(DATE,ChangeDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));		
			IF @Counter > 0
			exec GetSectionContentEditHistory @month ;
		ELSE Print('Zero Record for Archiving in InvestX.dbo.SectionContentEditHistory!')
		end try 
		begin catch	
			select ERROR_MESSAGE() as messages;
		end catch
	END
	Else
	  PRINT('Stored Procedure GetSectionContentEditHistory does not exist!')

--///////////////////////////////////////////////////////////////////////////////////

	IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = N'SerilogLogItems')
	BEGIN
	 exec CreatTblSerilogLogItems;
	 PRINT 'SerilogLogItems Table Created!'
	END
	
	IF EXISTS(SELECT 1 FROM InvestX_Archive.sys.procedures 
				WHERE Name = 'GetSerilogLogItems')
	BEGIN
		begin try
			Select @Counter = COUNT(*)  from InvestX_Logging.dbo.SerilogLogItems 
			WITH (NOLOCK) WHERE CONVERT(DATE, InvestX_Logging.dbo.SerilogLogItems.UtcDateTime) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));		
			IF @Counter > 0
			exec GetSerilogLogItems @month ;
		ELSE Print('Zero Record for Archiving in InvestX_Logging.dbo.SerilogLogItems!')
		end try 
		begin catch	
			select ERROR_MESSAGE() as messages;
		end catch
	END
	Else
	  PRINT('Stored Procedure GetSerilogLogItems does not exist!')

--///////////////////////////////////////////////////////////////////////////////////

	IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = N'TrackableItems')
	BEGIN
	 exec CreatTblTrackableItems;
	 PRINT 'TrackableItems Table Created!'
	END
	
	IF EXISTS(SELECT 1 FROM InvestX_Archive.sys.procedures 
				WHERE Name = 'GetTrackableItems')
	BEGIN
		begin try
			Select @Counter = COUNT(*) from InvestX_Logging.dbo.TrackableItems 
			WITH (NOLOCK) WHERE CONVERT(DATE,UtcActionDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));
			IF @Counter > 0
			exec GetTrackableItems @month ;
		ELSE Print('Zero Record for Archiving in InvestX_Logging.dbo.TrackableItems!')
		end try 
		begin catch	
			select ERROR_MESSAGE() as messages;
		end catch
	END
	Else
	  PRINT('Stored Procedure GetTrackableItems does not exist!')

--///////////////////////////////////////////////////////////////////////////////////

		IF NOT(EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'DealRoleSummaries'))
		BEGIN
			exec CreatTblDealRoleSummaries;
		END
		Else
		BEGIN
		  PRINT 'DealRoleSummaries table exist!'
		END


		IF NOT(EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'DealDocumentSummaries'))
		BEGIN
			exec CreatTblDealDocumentSummaries;
		END
		Else
		BEGIN
		  PRINT 'DealDocumentSummaries table exist!'
		END
--///////////////////////////////////////////////////////////////////////////////////

	IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
			   WHERE TABLE_NAME = N'ErrorLog')
	BEGIN
	 exec CreatTblErrorLog;
	 PRINT 'ErrorLog Table Created!'
	END
	
	IF EXISTS(SELECT 1 FROM InvestX_Archive.sys.procedures 
				WHERE Name = 'GetErrorLog')
	BEGIN
		begin try
			--Select @Counter = COUNT(*) from InvestX_Admin.dbo.ErrorLog WHERE CONVERT(DATE,ExpiresUtc) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));
		--	IF @Counter > 0
				exec GetErrorLog @month ;
			--ELSE Print('Zero Record for Archiving in InvestX_Admin.dbo.ErrorLog!')
		end try 
		begin catch	
			select ERROR_MESSAGE() as messages;
		end catch
	END
	Else
	  PRINT('Stored Procedure GetErrorLog does not exist!')

--///////////////////////////////////////////////////////////////////////////////////

	IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = N'GEMPortalLogItems')
	BEGIN
	 exec CreatTblGEMPortalLogItems;
	 PRINT 'GEMPortalLogItems Table Created!'
	END
	
	IF EXISTS(SELECT 1 FROM InvestX_Archive.sys.procedures 
				WHERE Name = 'GEMPortalLogItems')
	BEGIN
		begin try
			Select @Counter = COUNT(*) from InvestX_Logging.dbo.GEMPortalLogItems 
			WITH (NOLOCK) WHERE CONVERT(DATE,[TimeStamp]) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));
			IF @Counter > 0
			exec GetGEMPortalLogItems @month ;
		ELSE Print('Zero Record for Archiving in InvestX_Logging.dbo.GEMPortalLogItems!')
		end try 
		begin catch	
			select ERROR_MESSAGE() as messages;
		end catch
	END
	Else
	  PRINT('Stored Procedure GEMPortalLogItems does not exist!')

	  --///////////////////////////////////////////////////////////////////////////////////

	IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = N'GEMHubLogItems')
	BEGIN
	 exec CreatTblGEMHubLogItems;
	 PRINT 'GEMHubLogItems Table Created!'
	END
	
	IF EXISTS(SELECT 1 FROM InvestX_Archive.sys.procedures 
				WHERE Name = 'GEMHubLogItems')
	BEGIN
		begin try
			Select @Counter = COUNT(*) from InvestX_Logging.dbo.GEMHubLogItems 
			WITH (NOLOCK) WHERE CONVERT(DATE,[TimeStamp]) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));
			IF @Counter > 0
			exec GetGEMHubLogItems @month ;
		ELSE Print('Zero Record for Archiving in InvestX_Logging.dbo.GEMHubLogItems!')
		end try 
		begin catch	
			select ERROR_MESSAGE() as messages;
		end catch
	END
	Else
	  PRINT('Stored Procedure GEMHubLogItems does not exist!')

--///////////////////////////////////////////////////////////////////////////////////

	IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = N'IdentityServerLogs')
	BEGIN
	 exec CreatTblIdentityServerLogs;
	 PRINT 'IdentityServerLogs Table Created!'
	END
	
	IF EXISTS(SELECT 1 FROM InvestX_Archive.sys.procedures 
				WHERE Name = 'IdentityServerLogs')
	BEGIN
		begin try
			Select @Counter = COUNT(*) from InvestX_Logging.dbo.IdentityServerLogs 
			WITH (NOLOCK) WHERE CONVERT(DATE,[TimeStamp]) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));
			IF @Counter > 0
			exec GetIdentityServerLogs @month ;
		ELSE Print('Zero Record for Archiving in InvestX_Logging.dbo.IdentityServerLogs!')
		end try 
		begin catch	
			select ERROR_MESSAGE() as messages;
		end catch
	END
	Else
	  PRINT('Stored Procedure IdentityServerLogs does not exist!')

--///////////////////////////////////////////////////////////////////////////////////

	IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = N'TradingLogItems')
	BEGIN
	 exec CreatTblTradingLogItems;
	 PRINT 'TradingLogItems Table Created!'
	END
	
	IF EXISTS(SELECT 1 FROM InvestX_Archive.sys.procedures 
				WHERE Name = 'TradingLogItems')
	BEGIN
		begin try
			Select @Counter = COUNT(*) from InvestX_Logging.dbo.TradingLogItems 
			WITH (NOLOCK) WHERE CONVERT(DATE,[TimeStamp]) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));
			IF @Counter > 0
			exec GetTradingLogItems @month ;
		ELSE Print('Zero Record for Archiving in InvestX_Logging.dbo.TradingLogItems!')
		end try 
		begin catch	
			select ERROR_MESSAGE() as messages;
		end catch
	END
	Else
	  PRINT('Stored Procedure TradingLogItems does not exist!')

--///////////////////////////////////////////////////////////////////////////////////

END
Else
 print('Archive DataBase DOES NOT exist!Please run "CreateTableProcedures" Query file first!');
  
  
  
   SET @month = @month - 1;
END;

PRINT 'End of the LOOP in archiveing DBs and Tbls at month of '
PRINT @month;
GO