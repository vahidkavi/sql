   DECLARE @month    int=6
   DECLARE @Counter int = 0

IF (EXISTS(SELECT * FROM sysdatabases WHERE name='InvestX_Archive'))
BEGIN
	USE [InvestX_Archive];

--///////////////////////////////////////////////////////////////////////////////////

		IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
			   WHERE TABLE_NAME = N'GEMPortalLogItems')
	BEGIN
	 exec CreatTblGEMPortalLogItems;
	 PRINT 'GEMPortalLogItems Table Created!'
	END
	
	IF EXISTS(SELECT 1 FROM InvestX_Archive.sys.procedures 
				WHERE Name = 'GetGEMPortalLogItems')
	BEGIN
		begin try
			Select @Counter = COUNT(*) from InvestX_Logging.dbo.GEMPortalLogItems 
			WITH (NOLOCK) WHERE CONVERT(DATE,InvestX_Logging.dbo.GEMPortalLogItems.[TimeStamp]) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	
			IF @Counter > 0
			exec GetGEMPortalLogItems @month ;
		ELSE Print('Zero Record for Archiving in InvestX_Logging.dbo.GEMPortalLogItems!')
		end try 
		begin catch	
			select ERROR_MESSAGE() as messages;
		end catch
	END
	Else
	  PRINT('Stored Procedure GetGEMPortalLogItems does not exist!')

--///////////////////////////////////////////////////////////////////////////////////

	IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
			   WHERE TABLE_NAME = N'GEMHubLogItems')
	BEGIN
	 exec CreatTblGEMHubLogItems;
	 PRINT 'GEMHubLogItems Table Created!'
	END
	
	IF EXISTS(SELECT 1 FROM InvestX_Archive.sys.procedures 
				WHERE Name = 'GetGEMHubLogItems')
	BEGIN
		begin try
			Select @Counter = COUNT(*) from InvestX_Logging.dbo.GEMHubLogItems 
			WITH (NOLOCK) WHERE CONVERT(DATE,InvestX_Logging.dbo.GEMHubLogItems.[TimeStamp]) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	
			IF @Counter > 0
			exec GetGEMHubLogItems @month ;
		ELSE Print('Zero Record for Archiving in InvestX_Logging.dbo.GEMHubLogItems!')
		end try 
		begin catch	
			select ERROR_MESSAGE() as messages;
		end catch
	END
	Else
	  PRINT('Stored Procedure GetGEMHubLogItems does not exist!')

--///////////////////////////////////////////////////////////////////////////////////

	IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
			   WHERE TABLE_NAME = N'IdentityServerLogs')
	BEGIN
	 exec CreatTblIdentityServerLogs;
	 PRINT 'IdentityServerLogs Table Created!'
	END
	
	IF EXISTS(SELECT 1 FROM InvestX_Archive.sys.procedures 
				WHERE Name = 'GetIdentityServerLogs')
	BEGIN
		begin try
			Select @Counter = COUNT(*) from InvestX_Logging.dbo.IdentityServerLogs 
			WITH (NOLOCK) WHERE CONVERT(DATE,InvestX_Logging.dbo.IdentityServerLogs.[TimeStamp]) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	
			IF @Counter > 0
			exec GetIdentityServerLogs @month ;
		ELSE Print('Zero Record for Archiving in InvestX_Logging.dbo.IdentityServerLogs!')
		end try 
		begin catch	
			select ERROR_MESSAGE() as messages;
		end catch
	END
	Else
	  PRINT('Stored Procedure GetIdentityServerLogs does not exist!')

--///////////////////////////////////////////////////////////////////////////////////

	IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
			   WHERE TABLE_NAME = N'TradingLogItems')
	BEGIN
	 exec CreatTblTradingLogItems;
	 PRINT 'TradingLogItems Table Created!'
	END
	
	IF EXISTS(SELECT 1 FROM InvestX_Archive.sys.procedures 
				WHERE Name = 'GetTradingLogItems')
	BEGIN
		begin try
			Select @Counter = COUNT(*) from InvestX_Logging.dbo.TradingLogItems 
			WITH (NOLOCK) WHERE CONVERT(DATE,InvestX_Logging.dbo.TradingLogItems.[UtcDateTime]) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	
			IF @Counter > 0
			exec GetTradingLogItems @month ;
		ELSE Print('Zero Record for Archiving in InvestX_Logging.dbo.TradingLogItems!')
		end try 
		begin catch	
			select ERROR_MESSAGE() as messages;
		end catch
	END
	Else
	  PRINT('Stored Procedure GetTradingLogItems does not exist!')

--///////////////////////////////////////////////////////////////////////////////////

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
			BEGIN
				Select @Counter = COUNT(*) from InvestX.dbo.AccountSessions WITH (NOLOCK) WHERE CONVERT(DATE,ExpiresUtc) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));
				Select TOP(1) CONVERT(DATE,ExpiresUtc) as 'First Record Date for InvestX.dbo.AccountSessions ',@Counter'Number of Records' from InvestX.dbo.AccountSessions WITH (NOLOCK) 
				WHERE CONVERT(DATE,ExpiresUtc) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()))
				Order By ExpiresUtc ASC
				Select TOP(1) CONVERT(DATE,ExpiresUtc) as 'Last Date Record for InvestX.dbo.AccountSessions' ,@Counter'Number of Records'from InvestX.dbo.AccountSessions WITH (NOLOCK) 
				WHERE CONVERT(DATE,ExpiresUtc) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()))
				Order By ExpiresUtc DESC 
			END
			ELSE 
			Print('Zero Record for Archiving in InvestX.dbo.AccountSessions!')		
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
			BEGIN
				Select @Counter = COUNT(*) from InvestX_Admin.dbo.AccountSummaries WITH (NOLOCK) WHERE CONVERT(DATE,UtcSummaryDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));
				Select TOP(1) CONVERT(DATE,UtcSummaryDate) as 'First Record Date for InvestX_Admin.dbo.AccountSummaries ',@Counter'Number of Records' from InvestX_Admin.dbo.AccountSummaries
				WITH (NOLOCK) WHERE CONVERT(DATE,UtcSummaryDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()))
				Order By UtcSummaryDate ASC
				Select TOP(1) CONVERT(DATE,UtcSummaryDate) as 'Last Date Record for InvestX_Admin.dbo.AccountSummaries' ,@Counter'Number of Records'from InvestX_Admin.dbo.AccountSummaries
				WITH (NOLOCK) WHERE CONVERT(DATE,UtcSummaryDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()))
				Order By UtcSummaryDate DESC 
			END
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
			BEGIN
				Select @Counter = COUNT(*) from InvestX_Admin.dbo.AccountSummaryAccountDetails WITH (NOLOCK) WHERE CONVERT(DATE,LastLoginDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));
				Select TOP(1) CONVERT(DATE,LastLoginDate) as 'First Record Date for InvestX_Admin.dbo.AccountSummaryAccountDetails ',@Counter'Number of Records' from InvestX_Admin.dbo.AccountSummaryAccountDetails
				 WITH (NOLOCK) WHERE CONVERT(DATE,LastLoginDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()))
				Order By LastLoginDate ASC
				Select TOP(1) CONVERT(DATE,LastLoginDate) as 'Last Date Record for InvestX_Admin.dbo.AccountSummaryAccountDetails' ,@Counter'Number of Records'from InvestX_Admin.dbo.AccountSummaryAccountDetails
				WITH (NOLOCK) WHERE CONVERT(DATE,LastLoginDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()))
				Order By LastLoginDate DESC 
			END
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
			WHERE CONVERT(DATE,ExpiresUtc) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	
			IF @Counter > 0
			BEGIN
				Select @Counter = COUNT(*) from InvestX_Admin.dbo.AccountSessions WITH (NOLOCK) WHERE CONVERT(DATE,ExpiresUtc) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));
				Select TOP(1) CONVERT(DATE,ExpiresUtc) as 'First Record Date for InvestX_Admin.dbo.AccountSessions ',@Counter'Number of Records' from InvestX_Admin.dbo.AccountSessions
				WITH (NOLOCK) WHERE CONVERT(DATE,ExpiresUtc) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()))
				Order By ExpiresUtc ASC
				Select TOP(1) CONVERT(DATE,ExpiresUtc) as 'Last Date Record for InvestX_Admin.dbo.AccountSessions' ,@Counter'Number of Records'from InvestX_Admin.dbo.AccountSessions
				WITH (NOLOCK) WHERE CONVERT(DATE,ExpiresUtc) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()))
				Order By ExpiresUtc DESC 
			END			
		ELSE Print('Zero Record for Archiving in InvestX_Admin.dbo.AdminAccountSessions!')
		end try 
		begin catch	
			select ERROR_MESSAGE() as messages;
		end catch
	END
	Else
	  PRINT('Stored Procedure GetAdminAccountSessions does not exist!')

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
			Select @Counter = COUNT(*) from InvestX_Admin.dbo.DealSummaries WITH (NOLOCK) WHERE CONVERT(DATE,UtcSummaryDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));
			IF @Counter > 0
			BEGIN
				Select @Counter = COUNT(*) from InvestX_Admin.dbo.DealSummaries WITH (NOLOCK) WHERE CONVERT(DATE,UtcSummaryDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));
				Select TOP(1) CONVERT(DATE,UtcSummaryDate) as 'First Record Date for InvestX_Admin.dbo.DealSummaries ',@Counter'Number of Records' from InvestX_Admin.dbo.DealSummaries
				WITH (NOLOCK) WHERE CONVERT(DATE,UtcSummaryDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()))
				Order By UtcSummaryDate ASC
				Select TOP(1) CONVERT(DATE,UtcSummaryDate) as 'Last Date Record for InvestX_Admin.dbo.DealSummaries' ,@Counter'Number of Records'from InvestX_Admin.dbo.DealSummaries
				WITH (NOLOCK) WHERE CONVERT(DATE,UtcSummaryDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()))
				Order By UtcSummaryDate DESC 
			END				
			ELSE Print('Zero Record for Archiving in InvestX_Admin.dbo.DealSummaries!')
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
			BEGIN
				Select @Counter = COUNT(*) from InvestX_Admin.dbo.DealSummaryAccountDetails WITH (NOLOCK) WHERE CONVERT(DATE,UtcDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));
				Select TOP(1) CONVERT(DATE,UtcDate) as 'First Record Date for InvestX_Admin.dbo.DealSummaryAccountDetails ',@Counter'Number of Records' from InvestX_Admin.dbo.DealSummaryAccountDetails
				WITH (NOLOCK) WHERE CONVERT(DATE,UtcDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()))
				Order By UtcDate ASC
				Select TOP(1) CONVERT(DATE,UtcDate) as 'Last Date Record for InvestX_Admin.dbo.DealSummaryAccountDetails' ,@Counter'Number of Records'from InvestX_Admin.dbo.DealSummaryAccountDetails
				WITH (NOLOCK) WHERE CONVERT(DATE,UtcDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()))
				Order By UtcDate DESC 
			END			
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
	--	IF @Counter > 0
	--		BEGIN
				--Select @Counter = COUNT(*) from InvestX_Admin.dbo.DealSummaryDealAccounts 
				--WHERE DealSummaryId in (SELECT DealSummaryId FROM  InvestX_Admin.dbo.DealSummaries
				--WHERE CONVERT(DATE,UtcSummaryDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE())))
				--Select TOP(1) CONVERT(DATE,UtcSummaryDate) as 'First Record Date for InvestX_Admin.dbo.DealSummaryDealAccounts ',@Counter'Number of Records' from InvestX_Admin.dbo.DealSummaryDealAccounts
				--WHERE DealSummaryId in (SELECT DealSummaryId FROM  InvestX_Admin.dbo.DealSummaries
				--WHERE CONVERT(DATE,UtcSummaryDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE())))
				--Order By UtcSummaryDate ASC
				--Select TOP(1) CONVERT(DATE,UtcSummaryDate) as 'Last Date Record for InvestX_Admin.dbo.DealSummaryDealAccounts' ,@Counter'Number of Records'from InvestX_Admin.dbo.DealSummaryDealAccounts
				--WHERE DealSummaryId in (SELECT DealSummaryId FROM  InvestX_Admin.dbo.DealSummaries
				--WHERE CONVERT(DATE,UtcSummaryDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE())))
				--Order By UtcSummaryDate DESC 
		--	END		
		--	ELSE Print('Zero Record for Archiving in InvestX_Admin.dbo.DealSummaryDealAccounts!')
		end try 
		begin catch	
			select ERROR_MESSAGE() as messages;
		end catch
	END
	Else
	  PRINT('Stored Procedure GetDealSummaryDealAccounts does not exist!')

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
	WHERE TABLE_NAME = N'GenericLogItems')
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
			BEGIN
				Select @Counter = COUNT(*) from InvestX_Logging.dbo.GenericLogItems WITH (NOLOCK) WHERE CONVERT(DATE,UtcDateTime) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));
				Select TOP(1) CONVERT(DATE, UtcDateTime) as 'First Record Date for InvestX_Admin.dbo.GetGenericLogItems',@Counter'Number of Records' from InvestX_Logging.dbo.GenericLogItems
				WITH (NOLOCK) WHERE CONVERT(DATE,UtcDateTime) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()))
				Order By UtcDateTime ASC
				Select TOP(1) CONVERT(DATE, UtcDateTime) as 'Last Date Record for InvestX_Admin.dbo.GetGenericLogItems' ,@Counter'Number of Records'from InvestX_Logging.dbo.GenericLogItems
				WITH (NOLOCK) WHERE CONVERT(DATE,UtcDateTime) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()))
				Order By UtcDateTime DESC 
			END			
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
			WHERE CONVERT(DATE,RegisterDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	
			IF @Counter > 0
			BEGIN
				Select @Counter = COUNT(*) from InvestX_Logging.dbo.Heartbeat WHERE CONVERT(DATE,RegisterDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));
				Select TOP(1) CONVERT(DATE, RegisterDate) as 'First Record Date for InvestX_Admin.dbo.Heartbeat',@Counter'Number of Records' from InvestX_Logging.dbo.Heartbeat
				WITH (NOLOCK) WHERE CONVERT(DATE,RegisterDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()))
				Order By RegisterDate ASC
				Select TOP(1) CONVERT(DATE, RegisterDate) as 'Last Date Record for InvestX_Admin.dbo.Heartbeat' ,@Counter'Number of Records'from InvestX_Logging.dbo.Heartbeat
				WITH (NOLOCK) WHERE CONVERT(DATE, RegisterDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()))
				Order By RegisterDate DESC 
			END
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
			BEGIN
				Select @Counter = COUNT(*) from InvestX_Logging.dbo.HttpContextLogItems WITH (NOLOCK) WHERE CONVERT(DATE,UtcDateTime) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));
				Select TOP(1) CONVERT(DATE, UtcDateTime) as 'First Record Date for InvestX_Admin.dbo.HttpContextLogItems',@Counter'Number of Records' from InvestX_Logging.dbo.HttpContextLogItems
				WITH (NOLOCK) WHERE CONVERT(DATE,UtcDateTime) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()))
				Order By UtcDateTime ASC
				Select TOP(1) CONVERT(DATE, UtcDateTime) as 'Last Date Record for InvestX_Admin.dbo.HttpContextLogItems' ,@Counter'Number of Records'from InvestX_Logging.dbo.HttpContextLogItems
				WITH (NOLOCK) WHERE CONVERT(DATE,UtcDateTime) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()))
				Order By UtcDateTime DESC 
			END		
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
			BEGIN
				Select @Counter = COUNT(*) from InvestX_Logging.dbo.ITCHLogItems WITH (NOLOCK) WHERE CONVERT(DATE,UtcDateTime) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));
				Select TOP(1) CONVERT(DATE, UtcDateTime) as 'First Record Date for InvestX_Admin.dbo.ITCHLogItems',@Counter'Number of Records' from InvestX_Logging.dbo.ITCHLogItems
				WITH (NOLOCK) WHERE CONVERT(DATE,UtcDateTime) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()))
				Order By UtcDateTime ASC
				Select TOP(1) CONVERT(DATE, UtcDateTime) as 'Last Date Record for InvestX_Admin.dbo.ITCHLogItems' ,@Counter'Number of Records'from InvestX_Logging.dbo.ITCHLogItems
				WITH (NOLOCK) WHERE CONVERT(DATE,UtcDateTime) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()))
				Order By UtcDateTime DESC 
			END		
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
			BEGIN
				Select @Counter = COUNT(*) from InvestX.dbo.SectionContentEditHistory WHERE CONVERT(DATE,ChangeDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));
				Select TOP(1) CONVERT(DATE, ChangeDate) as 'First Record Date for InvestX_Admin.dbo.SectionContentEditHistory',@Counter'Number of Records' from InvestX.dbo.SectionContentEditHistory
				WITH (NOLOCK) WHERE CONVERT(DATE,ChangeDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()))
				Order By ChangeDate ASC
				Select TOP(1) CONVERT(DATE, ChangeDate) as 'Last Date Record for InvestX_Admin.dbo.SectionContentEditHistory' ,@Counter'Number of Records'from InvestX.dbo.SectionContentEditHistory
				WITH (NOLOCK) WHERE CONVERT(DATE,ChangeDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()))
				Order By ChangeDate DESC 
			END	
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
			BEGIN
				Select @Counter = COUNT(*) from InvestX_Logging.dbo.SerilogLogItems WITH (NOLOCK) WHERE CONVERT(DATE,UtcDateTime) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));
				Select TOP(1) CONVERT(DATE, UtcDateTime) as 'First Record Date for InvestX_Admin.dbo.SerilogLogItems',@Counter'Number of Records' from InvestX_Logging.dbo.SerilogLogItems
				WITH (NOLOCK) WHERE CONVERT(DATE,UtcDateTime) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()))
				Order By UtcDateTime ASC
				Select TOP(1) CONVERT(DATE, UtcDateTime) as 'Last Date Record for InvestX_Admin.dbo.SerilogLogItems' ,@Counter'Number of Records'from InvestX_Logging.dbo.SerilogLogItems
				WITH (NOLOCK) WHERE CONVERT(DATE,UtcDateTime) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()))
				Order By UtcDateTime DESC 
			END		
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
			BEGIN
				Select @Counter = COUNT(*) from InvestX_Logging.dbo.TrackableItems WITH (NOLOCK) WHERE CONVERT(DATE,UtcActionDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));
				Select TOP(1) CONVERT(DATE, UtcActionDate) as 'First Record Date for InvestX_Admin.dbo.TrackableItems',@Counter'Number of Records' from InvestX_Logging.dbo.TrackableItems
				WITH (NOLOCK) WHERE CONVERT(DATE,UtcActionDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()))
				Order By UtcActionDate ASC
				Select TOP(1) CONVERT(DATE, UtcActionDate) as 'Last Date Record for InvestX_Admin.dbo.TrackableItems' ,@Counter'Number of Records'from InvestX_Logging.dbo.TrackableItems
				WITH (NOLOCK) WHERE CONVERT(DATE,UtcActionDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()))
				Order By UtcActionDate DESC 
			END		
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

END
Else
 print('Archive DataBase DOES NOT exist!Please run "CreateTableProcedures" Query file first!');
