
IF (EXISTS(SELECT * FROM sysdatabases WHERE name='InvestX_Archive'))
BEGIN
	USE [InvestX_Archive];

	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
			   WHERE TABLE_NAME = N'AccountSessions')
	BEGIN
	  PRINT 'AccountSessions Table Exists!'
	END
	Else
	BEGIN
	 exec CreatTblAccountSessions;
	  PRINT 'AccountSessions Table Created!'
	END

	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
			   WHERE TABLE_NAME = N'AccountSummaries')
	BEGIN
	  PRINT 'AccountSummaries Table Exists!'
	END
	Else
	BEGIN
	 exec CreatTblAccountSummaries;
	  PRINT 'AccountSummaries Table Created!'
	END

	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
			   WHERE TABLE_NAME = N'AccountSummaryAccountDetails')
	BEGIN
	  PRINT 'AccountSummaryAccountDetails Table Exists!'
	END
	Else
	BEGIN
	 exec CreatTblAccountSummaryAccountDetails;
	  PRINT 'AccountSummaryAccountDetails Table Created!'
	END

	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
			   WHERE TABLE_NAME = N'AdminAccountSessions')
	BEGIN
	  PRINT 'AdminAccountSessions Table Exists!'
	END
	Else
	BEGIN
	 exec CreatTblAdminAccountSessions;
	  PRINT 'AdminAccountSessions Table Created!'
	END


	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
			   WHERE TABLE_NAME = N'DealSummaries')
	BEGIN
	  PRINT 'DealSummaries Table Exists!'
	END
	Else
	BEGIN
	 exec CreatTblDealSummaries;
	  PRINT 'DealSummaries Table Created!'
	END

	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
			   WHERE TABLE_NAME = N'DealSummaryAccountDetails')
	BEGIN
	  PRINT 'DealSummaryAccountDetails Table Exists!'
	END
	Else
	BEGIN
	 exec CreatTblDealSummaryAccountDetails;
	  PRINT 'DealSummaryAccountDetails Table Created!'
	END

	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
			   WHERE TABLE_NAME = N'DealSummaryDealAccounts')
	BEGIN
	  PRINT 'DealSummaryDealAccounts Table Exists!'
	END
	Else
	BEGIN
	 exec CreatTblDealSummaryDealAccounts;
	  PRINT 'DealSummaryDealAccounts Table Created!'
	END

	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
			   WHERE TABLE_NAME = N'ErrorLog')
	BEGIN
	  PRINT 'ErrorLog Table Exists!'
	END
	Else
	BEGIN
	 exec CreatTblErrorLog;
	  PRINT 'ErrorLog Table Created!'
	END

	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
			   WHERE TABLE_NAME = N'GenericLogItems')
	BEGIN
	  PRINT 'TblGenericLogItems Table Exists!'
	END
	Else
	BEGIN
	 exec CreatTblGenericLogItems;
	  PRINT 'TblGenericLogItems Table Created!'
	END

	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
			   WHERE TABLE_NAME = N'HttpContextLogItems')
	BEGIN
	  PRINT 'HttpContextLogItems Table Exists!'
	END
	Else
	BEGIN
	 exec CreatTblHttpContextLogItems;
	  PRINT 'HttpContextLogItems Table Created!'
	END

	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
			   WHERE TABLE_NAME = N'SectionContentEditHistory')
	BEGIN
	  PRINT 'SectionContentEditHistory Table Exists!'
	END
	Else
	BEGIN
	 exec CreatTblSectionContentEditHistory;
	  PRINT 'SectionContentEditHistory Table Created!'
	END

	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
			   WHERE TABLE_NAME = N'TrackableItems')
	BEGIN
	  PRINT 'TrackableItems Table Exists!'
	END
	Else
	BEGIN
	 exec CreatTblTrackableItems;
	  PRINT 'TrackableItems Table Created!'
	END

	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
			   WHERE TABLE_NAME = N'DealDocumentSummaries')
	BEGIN
	  PRINT 'DealDocumentSummaries Table Exists!'
	END
	Else
	BEGIN
	 exec CreatTblDealDocumentSummaries;
	  PRINT 'DealDocumentSummaries Table Created!'
	END


	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
			   WHERE TABLE_NAME = N'ApiLogItems')
	BEGIN
	  PRINT 'ApiLogItems Table Exists!'
	END
	Else
	BEGIN
	 exec CreatTblApiLogItems;
	  PRINT 'ApiLogItems Table Created!'
	END

	
	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
			   WHERE TABLE_NAME = N'FIXLogItems')
	BEGIN
	  PRINT 'FIXLogItems Table Exists!'
	END
	Else
	BEGIN
	 exec CreatTblFIXLogItems;
	  PRINT 'FIXLogItems Table Created!'
	END

	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
			   WHERE TABLE_NAME = N'Heartbeat')
	BEGIN
	  PRINT 'Heartbeat Table Exists!'
	END
	Else
	BEGIN
	 exec CreatTblHeartbeat;
	  PRINT 'Heartbeat Table Created!'
	END

	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
			   WHERE TABLE_NAME = N'ITCHLogItems')
	BEGIN
	  PRINT 'ITCHLogItems Table Exists!'
	END
	Else
	BEGIN
	 exec CreatTblITCHLogItems;
	  PRINT 'ITCHLogItems Table Created!'
	END

	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
			   WHERE TABLE_NAME = N'SerilogLogItems')
	BEGIN
	  PRINT 'SerilogLogItems Table Exists!'
	END
	Else
	BEGIN
	 exec CreatTblSerilogLogItems;
	  PRINT 'SerilogLogItems Table Created!'
	END

	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
			   WHERE TABLE_NAME = N'DealRoleSummaries')
	BEGIN
	  PRINT 'DealRoleSummaries Table Exists!'
	END
	Else
	BEGIN
	 exec CreatTblDealRoleSummaries;
	  PRINT 'DealRoleSummaries Table Created!'
	END

	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
			   WHERE TABLE_NAME = N'GEMPortalLogItems')
	BEGIN
	  PRINT 'GEMPortalLogItems Table Exists!'
	END
	Else
	BEGIN
	 exec CreatTblGEMPortalLogItems;
	  PRINT 'GEMPortalLogItems Table Created!'
	END

	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
			   WHERE TABLE_NAME = N'GEMHubLogItems')
	BEGIN
	  PRINT 'GEMHubLogItems Table Exists!'
	END
	Else
	BEGIN
	 exec CreatTblGEMHubLogItems;
	  PRINT 'GEMHubLogItems Table Created!'
	END

	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
			   WHERE TABLE_NAME = N'IdentityServerLogs')
	BEGIN
	  PRINT 'IdentityServerLogs Table Exists!'
	END
	Else
	BEGIN
	 exec CreatTblIdentityServerLogs;
	  PRINT 'IdentityServerLogs Table Created!'
	END

	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
			   WHERE TABLE_NAME = N'TradingLogItems')
	BEGIN
	  PRINT 'TradingLogItems Table Exists!'
	END
	Else
	BEGIN
	 exec CreatTblTradingLogItems;
	  PRINT 'TradingLogItems Table Created!'
	END

END
Else
BEGIN
 print('Archive DataBase DOES NOT exist!Please run "CreateTableProcedures" Query file first!');
END