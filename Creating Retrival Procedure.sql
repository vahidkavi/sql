
USE [InvestX_Archive]
GO

CREATE PROCEDURE [dbo].[GetAccountSessions](@month int)	
AS
BEGIN
	SET NOCOUNT ON;   
	SET @month = @month
	DECLARE @counter int=0;
	DECLARE @Done BIT = 0;
		
			Select COUNT(*) as 'Number of targeted Records at "InvestX.dbo.AccountSessions"' from InvestX.dbo.AccountSessions 
			WITH (NOLOCK) WHERE CONVERT(DATE,ExpiresUtc) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));
		
			INSERT INTO InvestX_Archive.dbo.AccountSessions(Id,Token,ExpiresUtc,AccountId,Urn) 
			SELECT * FROM  InvestX.dbo.AccountSessions
			WITH (NOLOCK) WHERE CONVERT(DATE,ExpiresUtc) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	
			
			Select COUNT(*) as 'Number of archived Records at "InvestX.dbo.AccountSessions"' FROM InvestX.dbo.AccountSessions IXAS
			WITH (NOLOCK) INNER JOIN InvestX_Archive.dbo.AccountSessions ArchIXAS ON IXAS.Id = ArchIXAS.Id
			WHERE (IXAS.Id = ArchIXAS.Id);

			Select @counter = COUNT(*) FROM InvestX.dbo.AccountSessions IXAS
			WITH (NOLOCK) INNER JOIN InvestX_Archive.dbo.AccountSessions ArchIXAS ON IXAS.Id = ArchIXAS.Id
			WHERE (IXAS.Id = ArchIXAS.Id);

			IF @counter > 0
			Print('Number of Records Removing in InvestX.dbo.AccountSessions')

			SET @Done = 0	
			
	  	WHILE (@counter > 0 AND @Done=0)
		BEGIN
			BEGIN TRY
				BEGIN TRANSACTION 
					DELETE TOP(3000) IXAS FROM InvestX.dbo.AccountSessions IXAS INNER JOIN 
					InvestX_Archive.dbo.AccountSessions ArchIXAS ON IXAS.Id = ArchIXAS.Id
					WHERE (IXAS.Id = ArchIXAS.Id);

					Select @counter = COUNT(*) FROM InvestX.dbo.AccountSessions IXAS
					WITH (NOLOCK) INNER JOIN InvestX_Archive.dbo.AccountSessions ArchIXAS ON IXAS.Id = ArchIXAS.Id
					WHERE (IXAS.Id = ArchIXAS.Id);
					print(@counter);	

					IF @counter > 0
					BEGIN
						DBCC UPDATEUSAGE (0); 
						CHECKPOINT -- marks log space reusable in simple recovery
					END	
					IF @counter = 0 
					BEGIN
						SET @Done = 1
					END
				COMMIT TRANSACTION
			END TRY
			BEGIN CATCH
				ROLLBACK TRAN
				DECLARE @Line INT = ERROR_LINE()
				DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE() + ' On Line:' + cast(@Line as varchar(50))
				DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
				DECLARE @ErrorState INT = ERROR_STATE()
					RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
					Print(@Line + @ErrorMessage + @ErrorSeverity + @ErrorState);
				INSERT INTO ErrorLog(ProcedureName,ActionDateTime,ErrorMessage,ErrorSeverity,ErrorState) 
				VALUES('GetAccountSessions',getdate(),ERROR_MESSAGE(),ERROR_SEVERITY(),ERROR_STATE())
			END CATCH
		END
END
GO
--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

USE [InvestX_Archive]
GO
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO

CREATE PROCEDURE [dbo].[GetAccountSummaries](@month int)
	-- Add the parameters for the stored procedure here
AS
BEGIN
	SET @month = @month		
	DECLARE @Done BIT = 0;
	DECLARE @CTAccountSummaries int=0;

		Select COUNT(*) as 'Number of targeted Records at "InvestX_Admin.dbo.AccountSummaries"' from InvestX_Admin.[dbo].[AccountSummaries]
		WITH (NOLOCK) WHERE CONVERT(DATE,UtcSummaryDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));

		INSERT INTO InvestX_Archive.dbo.AccountSummaries SELECT * FROM InvestX_Admin.[dbo].[AccountSummaries]
		WHERE CONVERT(DATE,UtcSummaryDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));

		Select COUNT(*) as 'Number of archived Records at "InvestX_Archive.dbo.AccountSummaries"' from InvestX_Archive.dbo.AccountSummaries IXAS
		WITH (NOLOCK) INNER JOIN InvestX_Admin.dbo.AccountSummaries ArchIXAS ON IXAS.Id = ArchIXAS.Id
		WHERE (IXAS.Id = ArchIXAS.Id);

		Select @CTAccountSummaries = COUNT(*) from InvestX_Archive.dbo.AccountSummaries IXAS
		WITH (NOLOCK) INNER JOIN InvestX_Admin.dbo.AccountSummaries ArchIXAS ON IXAS.Id = ArchIXAS.Id
		WHERE (IXAS.Id = ArchIXAS.Id);

			IF @CTAccountSummaries > 0
			Print('Number of Records Removing in InvestX_Admin.dbo.AccountSummaries')

			SET @Done = 0	

  	WHILE (@CTAccountSummaries > 0 AND @Done=0)
		BEGIN
			BEGIN TRY
				BEGIN TRANSACTION 
					DELETE TOP(3000) IXAS FROM InvestX_Admin.dbo.AccountSummaries IXAS INNER JOIN 
					InvestX_Archive.dbo.AccountSummaries ArchIXAS ON IXAS.Id = ArchIXAS.Id
					WHERE (IXAS.Id = ArchIXAS.Id);

					Select @CTAccountSummaries = COUNT(*) FROM InvestX_Admin.dbo.AccountSummaries IXAS
					WITH (NOLOCK) INNER JOIN InvestX_Archive.dbo.AccountSummaries ArchIXAS ON IXAS.Id = ArchIXAS.Id
					WHERE (IXAS.Id = ArchIXAS.Id);
					print(@CTAccountSummaries);	

					IF @CTAccountSummaries > 0
					BEGIN
						DBCC UPDATEUSAGE (0); 
						CHECKPOINT -- marks log space reusable in simple recovery
					END	
					IF @CTAccountSummaries = 0 
					BEGIN
						SET @Done = 1
					END
				COMMIT TRANSACTION
			END TRY
			BEGIN CATCH
				ROLLBACK TRAN
				DECLARE @Line INT = ERROR_LINE()
				DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE() + ' On Line:' + cast(@Line as varchar(50))
				DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
				DECLARE @ErrorState INT = ERROR_STATE()
					RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
					Print(@Line + @ErrorMessage + @ErrorSeverity + @ErrorState);
				INSERT INTO ErrorLog(ProcedureName,ActionDateTime,ErrorMessage,ErrorSeverity,ErrorState) 
				VALUES('GetAdminAccountSessions',getdate(),ERROR_MESSAGE(),ERROR_SEVERITY(),ERROR_STATE())
			END CATCH
		END
END
GO


--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

USE [InvestX_Archive]
GO

CREATE PROCEDURE [dbo].[GetAccountSummaryAccountDetails](@month int)		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;   
	SET @month = @month
	DECLARE @counter int=0;
	DECLARE @Done BIT = 0;
		
			Select COUNT(*) as 'Number of targeted Records at "InvestX_Admin.dbo.AccountSummaryAccountDetails"' from InvestX_Admin.dbo.AccountSummaryAccountDetails 
			WITH (NOLOCK) WHERE CONVERT(DATE,LastLoginDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));
		
			INSERT INTO InvestX_Archive.dbo.AccountSummaryAccountDetails 
			SELECT * FROM  InvestX_Admin.dbo.AccountSummaryAccountDetails
			WITH (NOLOCK) WHERE CONVERT(DATE,LastLoginDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	
			
			Select COUNT(*) as 'Number of archived Records at "InvestX_Admin.dbo.AccountSummaryAccountDetails"' FROM InvestX_Admin.dbo.AccountSummaryAccountDetails IXAS
			WITH (NOLOCK) INNER JOIN InvestX_Archive.dbo.AccountSummaryAccountDetails ArchIXAS ON IXAS.Id = ArchIXAS.Id
			WHERE (IXAS.Id = ArchIXAS.Id);

			Select @counter = COUNT(*) FROM InvestX_Admin.dbo.AccountSummaryAccountDetails IXAS
			WITH (NOLOCK) INNER JOIN InvestX_Archive.dbo.AccountSummaryAccountDetails ArchIXAS ON IXAS.Id = ArchIXAS.Id
			WHERE (IXAS.Id = ArchIXAS.Id);

			IF @counter > 0
			Print('Number of Records Removing in InvestX_Admin.dbo.AccountSummaryAccountDetails')

			SET @Done = 0	
			WHILE (@counter > 0 AND @Done=0)
				BEGIN
					BEGIN TRY
						BEGIN TRANSACTION 
							DELETE TOP(3000) IXAS FROM InvestX_Admin.dbo.AccountSummaryAccountDetails IXAS INNER JOIN 
							InvestX_Archive.dbo.AccountSummaryAccountDetails ArchIXAS ON IXAS.Id = ArchIXAS.Id
							WHERE (IXAS.Id = ArchIXAS.Id);

							Select @counter = COUNT(*) FROM InvestX_Admin.dbo.AccountSummaryAccountDetails IXAS
							WITH (NOLOCK) INNER JOIN InvestX_Archive.dbo.AccountSummaryAccountDetails ArchIXAS ON IXAS.Id = ArchIXAS.Id
							WHERE (IXAS.Id = ArchIXAS.Id);
							print(@counter);	

							IF @counter > 0
							BEGIN
								DBCC UPDATEUSAGE (0); 
								CHECKPOINT -- marks log space reusable in simple recovery
							END	
							IF @counter = 0 
							BEGIN
								SET @Done = 1
							END
						COMMIT TRANSACTION
					END TRY
					BEGIN CATCH
						ROLLBACK TRAN
							DECLARE @Line INT = ERROR_LINE()
							DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE() + ' On Line:' + cast(@Line as varchar(50))
							DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
							DECLARE @ErrorState INT = ERROR_STATE()
							RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
							Print(@Line + @ErrorMessage + @ErrorSeverity + @ErrorState);
						INSERT INTO ErrorLog(ProcedureName,ActionDateTime,ErrorMessage,ErrorSeverity,ErrorState) 
						VALUES('GetAccountSummaryAccountDetails',getdate(),ERROR_MESSAGE(),ERROR_SEVERITY(),ERROR_STATE())
					END CATCH
				END
		END
GO
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

USE [InvestX_Archive]
GO

CREATE PROCEDURE [dbo].[GetAdminAccountSessions](@month int)		
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET @month = @month
	DECLARE @counter int=0;
	DECLARE @Done BIT = 0;
						
		Select COUNT(*) as 'Number of targeted Records at "InvestX_Admin.dbo.AccountSessions"' from InvestX_Admin.dbo.AccountSessions 
		WITH (NOLOCK) WHERE CONVERT(DATE,ExpiresUtc) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	

		INSERT INTO InvestX_Archive.dbo.AdminAccountSessions SELECT * FROM  InvestX_Admin.dbo.AccountSessions
		WHERE CONVERT(DATE,ExpiresUtc) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	

		Select COUNT(*) as 'Number of archived Records at "InvestX_Archive.dbo.AdminAccountSessions"' from InvestX_Archive.dbo.AdminAccountSessions IXAS
		WITH (NOLOCK) INNER JOIN InvestX_Admin.dbo.AccountSessions ArchIXAS ON IXAS.Id = ArchIXAS.Id
		WHERE (IXAS.Id = ArchIXAS.Id);

		Select @counter = COUNT(*) FROM InvestX_Admin.dbo.AccountSessions IXAS
		WITH (NOLOCK) INNER JOIN InvestX_Archive.dbo.AdminAccountSessions ArchIXAS ON IXAS.Id = ArchIXAS.Id
		WHERE (IXAS.Id = ArchIXAS.Id);

		IF @counter > 0
		Print('Number of Records Removing in InvestX_Admin.dbo.AccountSessions')
		SET @Done = 0	

			WHILE (@counter > 0 AND @Done=0)
				BEGIN
					BEGIN TRY
						BEGIN TRANSACTION 
							DELETE TOP(3000) IXAS FROM InvestX_Admin.dbo.AccountSessions IXAS INNER JOIN 
							InvestX_Archive.dbo.AdminAccountSessions ArchIXAS ON IXAS.Id = ArchIXAS.Id
							WHERE (IXAS.Id = ArchIXAS.Id);

							Select @counter = COUNT(*) FROM InvestX_Admin.dbo.AccountSessions IXAS
							WITH (NOLOCK) INNER JOIN InvestX_Archive.dbo.AdminAccountSessions ArchIXAS ON IXAS.Id = ArchIXAS.Id
							WHERE (IXAS.Id = ArchIXAS.Id);
							print(@counter);	

							IF @counter > 0
							BEGIN
								DBCC UPDATEUSAGE (0); 
								CHECKPOINT -- marks log space reusable in simple recovery
							END	
							IF @counter = 0 
							BEGIN
								SET @Done = 1
							END
						COMMIT TRANSACTION
					END TRY
					BEGIN CATCH
						ROLLBACK TRAN
						DECLARE @Line INT = ERROR_LINE()
						DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE() + ' On Line:' + cast(@Line as varchar(50))
						DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
						DECLARE @ErrorState INT = ERROR_STATE()
							RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
							Print(@Line + @ErrorMessage + @ErrorSeverity + @ErrorState);
						INSERT INTO ErrorLog(ProcedureName,ActionDateTime,ErrorMessage,ErrorSeverity,ErrorState) 
						VALUES('GetAdminAccountSessions',getdate(),ERROR_MESSAGE(),ERROR_SEVERITY(),ERROR_STATE())
					END CATCH
				END
END
GO

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

USE [InvestX_Archive]
GO

CREATE PROCEDURE [dbo].[GetDealSummaries](@month int)	
 AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--SET NOCOUNT ON;
	SET @month = @month
	DECLARE	@CTDealDocumentSummaries int=0;
	DECLARE	@CTDealRoleSummaries int=0;
	DECLARE	@CTDealSummaries int=0;
	DECLARE @Done BIT = 0;

		--DealDocumentSummaries
		Select COUNT(*) as 'Number of targeted Records at "InvestX_Admin.dbo.DealDocumentSummaries"' from InvestX_Admin.dbo.DealDocumentSummaries IXAS
		WITH (NOLOCK) INNER JOIN InvestX_Admin.dbo.DealSummaries ArchIXAS ON IXAS.DealSummaryId = ArchIXAS.Id
		WHERE (CONVERT(DATE,UtcSummaryDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()))) AND (IXAS.DealSummaryId = ArchIXAS.Id);
	 
		INSERT INTO InvestX_Archive.dbo.DealDocumentSummaries(Id, DealId, DealSummaryId, ReportSubType, DownloadCount, ReportType) 
		Select * from InvestX_Admin.dbo.DealDocumentSummaries WITH (NOLOCK)  
		WHERE DealSummaryId in (SELECT DealSummaryId FROM  InvestX_Admin.dbo.DealSummaries WITH (NOLOCK) 
		WHERE (CONVERT(DATE,UtcSummaryDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()))) AND (InvestX_Admin.[dbo].[DealSummaries].Id = InvestX_Admin.dbo.DealDocumentSummaries.DealSummaryId));

		Select COUNT(*) as 'Number of targeted Records at "InvestX_Archive.dbo.DealDocumentSummaries"' from InvestX_Archive.dbo.DealDocumentSummaries IXAS
		WITH (NOLOCK) INNER JOIN InvestX_Admin.dbo.DealDocumentSummaries ArchIXAS ON IXAS.Id = ArchIXAS.Id
		WHERE (IXAS.Id = ArchIXAS.Id);
	  --DealSummaries
		Select COUNT(*) as 'Number of targeted Records at "InvestX_Admin.dbo.DealSummaries"' from InvestX_Admin.[dbo].[DealSummaries]
		WITH (NOLOCK) WHERE CONVERT(DATE,UtcSummaryDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	
	
		INSERT INTO InvestX_Archive.dbo.DealSummaries SELECT * FROM  InvestX_Admin.dbo.DealSummaries
		WITH (NOLOCK) WHERE CONVERT(DATE,UtcSummaryDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	
	
		Select COUNT(*) as 'Number of archived Records at "InvestX_Archive.dbo.DealSummaries"' from InvestX_Archive.dbo.DealSummaries IXAS
		WITH (NOLOCK) INNER JOIN InvestX_Admin.dbo.DealSummaries ArchIXAS ON IXAS.Id = ArchIXAS.Id
		WHERE (IXAS.Id = ArchIXAS.Id);

        INSERT INTO InvestX_Archive.dbo.DealRoleSummaries([Id],[DealSummaryId],[DealRoleId],[Count],[Hierarchy],[RoleName]) 
		Select * from InvestX_Admin.dbo.DealRoleSummaries WITH (NOLOCK) 
		WHERE DealSummaryId in (SELECT DealSummaryId FROM  InvestX_Admin.dbo.DealSummaries
		WHERE (InvestX_Admin.[dbo].DealRoleSummaries.DealSummaryId = InvestX_Admin.dbo.DealSummaries.Id));

	  --DealRoleSummaries
		Select @CTDealRoleSummaries = COUNT(*) from InvestX_Admin.dbo.DealRoleSummaries IXAS
		WITH (NOLOCK) INNER JOIN InvestX_Archive.dbo.DealRoleSummaries ArchIXAS ON IXAS.Id = ArchIXAS.Id
		WHERE (IXAS.Id = ArchIXAS.Id);
		IF @CTDealRoleSummaries > 0
		Print('Number of Records Removing in InvestX_Admin.dbo.DealRoleSummaries')	
			SET @Done = 0	
			
		WHILE (@CTDealRoleSummaries > 0 AND @Done=0)
		BEGIN
			BEGIN TRY
				BEGIN TRANSACTION 
					DELETE TOP(3000) IXAS FROM InvestX_Admin.dbo.DealRoleSummaries IXAS INNER JOIN 
					InvestX_Archive.dbo.DealRoleSummaries ArchIXAS ON IXAS.Id = ArchIXAS.Id
					WHERE (IXAS.Id = ArchIXAS.Id);

					Select @CTDealRoleSummaries = COUNT(*) FROM InvestX_Admin.dbo.DealRoleSummaries IXAS
					WITH (NOLOCK) INNER JOIN InvestX_Archive.dbo.DealRoleSummaries ArchIXAS ON IXAS.Id = ArchIXAS.Id
					WHERE (IXAS.Id = ArchIXAS.Id);
					print(@CTDealRoleSummaries);	

					IF @CTDealRoleSummaries > 0
					BEGIN
						DBCC UPDATEUSAGE (0); 
						CHECKPOINT -- marks log space reusable in simple recovery
					END	
					IF @CTDealRoleSummaries = 0 
					BEGIN
						SET @Done = 1
					END
				COMMIT TRANSACTION
			END TRY
			BEGIN CATCH
				ROLLBACK TRAN
					DECLARE @Line INT = ERROR_LINE()
					DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE() + ' On Line:' + cast(@Line as varchar(50))
					DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
					DECLARE @ErrorState INT = ERROR_STATE()
					RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
					Print(@Line + @ErrorMessage + @ErrorSeverity + @ErrorState);
				INSERT INTO ErrorLog(ProcedureName,ActionDateTime,ErrorMessage,ErrorSeverity,ErrorState) 
				VALUES('GetDealSummaries',getdate(),ERROR_MESSAGE(),ERROR_SEVERITY(),ERROR_STATE())
			END CATCH
		END


		SET @Done = 0	
		--DealDocumentSummaries
		Select @CTDealDocumentSummaries = COUNT(*) from InvestX_Archive.dbo.DealDocumentSummaries IXAS
		INNER JOIN InvestX_Admin.dbo.DealDocumentSummaries ArchIXAS ON IXAS.Id = ArchIXAS.Id
		WHERE (IXAS.Id = ArchIXAS.Id);
		IF @CTDealDocumentSummaries > 0
		Print('Number of Records Removing from InvestX_Admin.dbo.DealDocumentSummaries')	


		WHILE (@CTDealDocumentSummaries > 0 AND @Done=0)
		BEGIN
			BEGIN TRY
				BEGIN TRANSACTION 
					DELETE TOP(3000) IXAS FROM InvestX_Admin.dbo.DealDocumentSummaries IXAS INNER JOIN 
					InvestX_Archive.dbo.DealDocumentSummaries ArchIXAS ON IXAS.Id = ArchIXAS.Id
					WHERE (IXAS.Id = ArchIXAS.Id);

					Select @CTDealDocumentSummaries = COUNT(*) FROM InvestX_Admin.dbo.DealDocumentSummaries IXAS
					WITH (NOLOCK) INNER JOIN InvestX_Archive.dbo.DealDocumentSummaries ArchIXAS ON IXAS.Id = ArchIXAS.Id
					WHERE (IXAS.Id = ArchIXAS.Id);
					print(@CTDealDocumentSummaries);	

					IF @CTDealDocumentSummaries > 0
					BEGIN
						DBCC UPDATEUSAGE (0); 
						CHECKPOINT -- marks log space reusable in simple recovery
					END	
					IF @CTDealDocumentSummaries = 0 
					BEGIN
						SET @Done = 1
					END
				COMMIT TRANSACTION
			END TRY
			BEGIN CATCH
				ROLLBACK TRAN
					SET @Line = ERROR_LINE()
					SET @ErrorMessage = ERROR_MESSAGE() + ' On Line:' + cast(@Line as varchar(50))
					SET @ErrorSeverity = ERROR_SEVERITY()
					SET @ErrorState = ERROR_STATE()
					RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
					Print(@Line + @ErrorMessage + @ErrorSeverity + @ErrorState);
				INSERT INTO ErrorLog(ProcedureName,ActionDateTime,ErrorMessage,ErrorSeverity,ErrorState) 
				VALUES('GetDealSummaries',getdate(),ERROR_MESSAGE(),ERROR_SEVERITY(),ERROR_STATE())
			END CATCH
		END


		SET @Done = 0	
	 --DealSummaries
		Select @CTDealSummaries = COUNT(*) from InvestX_Admin.dbo.DealSummaries IXAS
		WITH (NOLOCK) INNER JOIN InvestX_Archive.dbo.DealSummaries ArchIXAS ON IXAS.Id = ArchIXAS.Id
		WHERE (IXAS.Id = ArchIXAS.Id);
		IF @CTDealSummaries > 0
		Print('Number of Records Removing from InvestX_Admin.dbo.DealSummaries')		

			WHILE (@CTDealSummaries > 0 AND @Done=0)
				BEGIN
					BEGIN TRY
						BEGIN TRANSACTION 
							DELETE TOP(3000) IXAS FROM InvestX_Admin.dbo.DealSummaries IXAS INNER JOIN 
							InvestX_Archive.dbo.DealSummaries ArchIXAS ON IXAS.Id = ArchIXAS.Id
							WHERE (IXAS.Id = ArchIXAS.Id);

							Select @CTDealSummaries = COUNT(*) FROM InvestX_Admin.dbo.DealSummaries IXAS
							WITH (NOLOCK) INNER JOIN InvestX_Archive.dbo.DealSummaries ArchIXAS ON IXAS.Id = ArchIXAS.Id
							WHERE (IXAS.Id = ArchIXAS.Id);
							print(@CTDealSummaries);	

							IF @CTDealSummaries > 0
							BEGIN
								DBCC UPDATEUSAGE (0); 
								CHECKPOINT -- marks log space reusable in simple recovery
							END	
							IF @CTDealSummaries = 0 
							BEGIN
								SET @Done = 1
							END
						COMMIT TRANSACTION
					END TRY
					BEGIN CATCH
						ROLLBACK TRAN
							SET @Line = ERROR_LINE()
							SET @ErrorMessage = ERROR_MESSAGE() + ' On Line:' + cast(@Line as varchar(50))
							SET @ErrorSeverity = ERROR_SEVERITY()
							SET @ErrorState = ERROR_STATE()
							RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
							Print(@Line + @ErrorMessage + @ErrorSeverity + @ErrorState);
						INSERT INTO ErrorLog(ProcedureName,ActionDateTime,ErrorMessage,ErrorSeverity,ErrorState) 
						VALUES('GetDealSummaries',getdate(),ERROR_MESSAGE(),ERROR_SEVERITY(),ERROR_STATE())
					END CATCH
				END

	END;
GO

 --///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

USE [InvestX_Archive]
GO
/****** Object:  StoredProcedure [dbo].[GetDealSummaryAccountDetails]    Script Date: 2/14/2018 2:06:55 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO

CREATE PROCEDURE [dbo].[GetDealSummaryAccountDetails](@month int)
	-- Add the parameters for the stored procedure here
AS
	BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET @month = @month		
	DECLARE @Done BIT = 0;
    DECLARE @CTDealSummaryAccountDetails int = 0;

			Select COUNT(*) as 'Number of targeted Records at "InvestX_Admin.dbo.DealSummaryAccountDetails"' from InvestX_Admin.dbo.DealSummaryAccountDetails 
			WITH (NOLOCK) WHERE CONVERT(DATE,UtcDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	
			
			INSERT INTO InvestX_Archive.dbo.DealSummaryAccountDetails SELECT * from  InvestX_Admin.dbo.DealSummaryAccountDetails
			WITH (NOLOCK) WHERE CONVERT(DATE,UtcDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	

			Select COUNT(*) as 'Number of archived Records at "InvestX_Archive.dbo.DealSummaryAccountDetails"' from InvestX_Archive.dbo.DealSummaryAccountDetails IXAS
			WITH (NOLOCK) INNER JOIN InvestX_Admin.dbo.DealSummaryAccountDetails ArchIXAS ON IXAS.Id = ArchIXAS.Id
			WHERE (IXAS.Id = ArchIXAS.Id);

			Select @CTDealSummaryAccountDetails = COUNT(*) from InvestX_Archive.dbo.DealSummaryAccountDetails IXAS
			WITH (NOLOCK) INNER JOIN InvestX_Admin.dbo.DealSummaryAccountDetails ArchIXAS ON IXAS.Id = ArchIXAS.Id
			WHERE (IXAS.Id = ArchIXAS.Id);

			IF @CTDealSummaryAccountDetails > 0
			Print('Number of Records Removing from InvestX_Admin.dbo.DealSummaryAccountDetails')		
			SET @Done = 0	

			WHILE (@CTDealSummaryAccountDetails > 0 AND @Done=0)
				BEGIN
					BEGIN TRY
					   BEGIN TRAN
							DELETE TOP(3000) IXAS FROM InvestX_Admin.dbo.DealSummaryAccountDetails IXAS INNER JOIN 
							InvestX_Archive.dbo.DealSummaryAccountDetails ArchIXAS ON IXAS.Id = ArchIXAS.Id
							WHERE (IXAS.Id = ArchIXAS.Id);

							Select @CTDealSummaryAccountDetails = COUNT(*) FROM InvestX_Admin.dbo.DealSummaryAccountDetails IXAS
							WITH (NOLOCK) INNER JOIN InvestX_Archive.dbo.DealSummaryAccountDetails ArchIXAS ON IXAS.Id = ArchIXAS.Id
							WHERE (IXAS.Id = ArchIXAS.Id);
							print(@CTDealSummaryAccountDetails);	

							--DBCC UPDATEUSAGE (0); 
							CHECKPOINT -- marks log space reusable in simple recovery
							IF @CTDealSummaryAccountDetails > 0
								BEGIN
									DBCC UPDATEUSAGE (0);
									CHECKPOINT -- marks log space reusable in simple recovery
								END	
							IF @CTDealSummaryAccountDetails = 0 
							BEGIN
								SET @Done = 1
							END
						COMMIT TRAN
					 END TRY
					 BEGIN CATCH
						ROLLBACK TRAN
						  INSERT INTO ErrorLog(ProcedureName,ActionDateTime,ErrorMessage,ErrorSeverity,ErrorState) 
						  VALUES('GetDealSummaryAccountDetails',getdate(),ERROR_MESSAGE(),ERROR_SEVERITY(),ERROR_STATE())
					 END CATCH
				END
		END
GO

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

USE [InvestX_Archive]
GO
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO

CREATE PROCEDURE [dbo].[GetDealSummaryDealAccounts](@month int)
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;   
	SET @month = @month
	DECLARE @counter int=0;
	DECLARE @Done BIT = 0;
		
			Select COUNT(*) as 'Number of targeted Records at "InvestX_Admin.dbo.DealSummaryDealAccounts"' from InvestX_Admin.dbo.DealSummaryDealAccounts 
			WITH (NOLOCK) WHERE DealSummaryId in (SELECT DealSummaryId FROM  InvestX_Admin.dbo.DealSummaries
			WHERE CONVERT(DATE,UtcSummaryDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE())));
		
			INSERT INTO InvestX_Archive.dbo.DealSummaryDealAccounts SELECT * FROM InvestX_Admin.[dbo].[DealSummaryDealAccounts]
			WITH (NOLOCK) WHERE DealSummaryId in (SELECT DealSummaryId FROM  InvestX_Admin.dbo.DealSummaries
			WHERE CONVERT(DATE,UtcSummaryDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE())));
			
			Select COUNT(*) as 'Number of archived Records at "InvestX_Admin.dbo.DealSummaryDealAccounts"' FROM InvestX_Admin.dbo.DealSummaryDealAccounts IXAS
			WITH (NOLOCK) INNER JOIN InvestX_Archive.dbo.DealSummaryDealAccounts ArchIXAS ON IXAS.Id = ArchIXAS.Id
			WHERE (IXAS.Id = ArchIXAS.Id);

			Select @counter = COUNT(*) FROM InvestX_Admin.dbo.DealSummaryDealAccounts IXAS
			WITH (NOLOCK) INNER JOIN InvestX_Archive.dbo.DealSummaryDealAccounts ArchIXAS ON IXAS.Id = ArchIXAS.Id
			WHERE (IXAS.Id = ArchIXAS.Id);

			IF @counter > 0
			Print('Number of Records Removing in InvestX_Admin.dbo.DealSummaryDealAccounts')

			SET @Done = 0	
			WHILE (@counter > 0 AND @Done=0)
				BEGIN
					BEGIN TRY
						BEGIN TRANSACTION 
							DELETE TOP(3000) IXAS FROM InvestX_Admin.dbo.DealSummaryDealAccounts IXAS INNER JOIN 
							InvestX_Archive.dbo.DealSummaryDealAccounts ArchIXAS ON IXAS.Id = ArchIXAS.Id
							WHERE (IXAS.Id = ArchIXAS.Id);

							Select @counter = COUNT(*) FROM InvestX_Admin.dbo.DealSummaryDealAccounts IXAS
							WITH (NOLOCK) INNER JOIN InvestX_Archive.dbo.DealSummaryDealAccounts ArchIXAS ON IXAS.Id = ArchIXAS.Id
							WHERE (IXAS.Id = ArchIXAS.Id);
							print(@counter);	

							IF @counter > 0
							BEGIN
								DBCC UPDATEUSAGE (0); 
								CHECKPOINT -- marks log space reusable in simple recovery
							END	
							IF @counter = 0 
							BEGIN
								SET @Done = 1
							END
						COMMIT TRANSACTION
					END TRY
					BEGIN CATCH
						ROLLBACK TRAN
							DECLARE @Line INT = ERROR_LINE()
							DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE() + ' On Line:' + cast(@Line as varchar(50))
							DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
							DECLARE @ErrorState INT = ERROR_STATE()
							RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
							Print(@Line + @ErrorMessage + @ErrorSeverity + @ErrorState);
						INSERT INTO ErrorLog(ProcedureName,ActionDateTime,ErrorMessage,ErrorSeverity,ErrorState) 
						VALUES('GetDealSummaryDealAccounts',getdate(),ERROR_MESSAGE(),ERROR_SEVERITY(),ERROR_STATE())
					END CATCH
				END
		END
GO

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

USE [InvestX_Archive]
GO
/****** Object:  StoredProcedure [dbo].[GetApiLogItems]    Script Date: 2/14/2018 2:19:30 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO

CREATE PROCEDURE [dbo].[GetApiLogItems](@month int)	
 AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    SET @month = @month		
	DECLARE @Done BIT = 0;
	DECLARE @CTApiLogItems int = 0;
	BEGIN TRY
		BEGIN TRAN

		--Select COUNT(*) as 'Number of targeted Records at "InvestX_Logging.dbo.ApiLogItems"' from InvestX_Logging.dbo.ApiLogItems 
		--WHERE CONVERT(DATE,UtcActionDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	
			
		--INSERT INTO InvestX_Archive.dbo.ApiLogItems SELECT * from  InvestX_Logging.dbo.ApiLogItems
		--WHERE CONVERT(DATE,UtcActionDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	

		Select COUNT(*) as 'Number of archived Records at "InvestX_Archive.dbo.ApiLogItems"' from InvestX_Archive.dbo.ApiLogItems IXAS
		WITH (NOLOCK) INNER JOIN InvestX_Logging.dbo.ApiLogItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
		WHERE (IXAS.Id = ArchIXAS.Id);
	
		Select @CTApiLogItems = COUNT(*) from InvestX_Archive.dbo.ApiLogItems IXAS
		WITH (NOLOCK) INNER JOIN InvestX_Logging.dbo.ApiLogItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
		WHERE (IXAS.Id = ArchIXAS.Id);

			IF @CTApiLogItems > 0
			Print('Number of Records Removing from InvestX_Logging.dbo.ApiLogItems')
				SET @Done = 0	

			WHILE (@CTApiLogItems > 0 AND @Done=0)
				BEGIN

					DELETE TOP(3000) IXAS FROM InvestX_Logging.dbo.ApiLogItems IXAS INNER JOIN 
					InvestX_Archive.dbo.ApiLogItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
					WHERE (IXAS.Id = ArchIXAS.Id);

					Select @CTApiLogItems = COUNT(*) FROM InvestX_Logging.dbo.ApiLogItems IXAS
					WITH (NOLOCK) INNER JOIN InvestX_Archive.dbo.ApiLogItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
					WHERE (IXAS.Id = ArchIXAS.Id);
					print(@CTApiLogItems);	

					--DBCC UPDATEUSAGE (0); 
					CHECKPOINT -- marks log space reusable in simple recovery
					IF @CTApiLogItems > 0
						BEGIN
							DBCC UPDATEUSAGE (0); 
						END	
					IF @CTApiLogItems = 0 
					BEGIN
						SET @Done = 1
					END
				END
	COMMIT TRAN
 END TRY
  BEGIN CATCH
   ROLLBACK TRAN
	  INSERT INTO ErrorLog(ProcedureName,ActionDateTime,ErrorMessage,ErrorSeverity,ErrorState) 
	  VALUES('GetApiLogItems',getdate(),ERROR_MESSAGE(),ERROR_SEVERITY(),ERROR_STATE())
 END CATCH;
END
GO
 
 --///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

USE [InvestX_Archive]
GO
/****** Object:  StoredProcedure [dbo].[GetFIXLogItems]    Script Date: 2/14/2018 2:19:30 PM ******/
--SET ANSI_NULLS ON
--GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetFIXLogItems](@month int)	
 AS
BEGIN
		SET @month = @month		
		SET NOCOUNT ON;
		DECLARE @Done BIT = 0;
		DECLARE @CTFIXLogItems int = 0;	
		Select COUNT(*) as 'Number of targeted Records at "InvestX_Logging.dbo.FIXLogItems"' from InvestX_Logging.dbo.FIXLogItems 
		WITH (NOLOCK) WHERE CONVERT(DATE,InvestX_Logging.dbo.FIXLogItems.UtcDateTime) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	

		INSERT INTO InvestX_Archive.dbo.FIXLogItems SELECT [DevMessage],[Type],[UtcDateTime],[Exception],[Key],[KeyName],[Service],[Location],[UserAgent],[HttpCode],[LocalLogId]
		from  InvestX_Logging.dbo.FIXLogItems
		WITH (NOLOCK) WHERE CONVERT(DATE,UtcDateTime) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	
		
		Select COUNT(*) as 'Number of archived Records at "InvestX_Archive.dbo.FIXLogItems"' from InvestX_Archive.dbo.FIXLogItems IXAS
		WITH (NOLOCK) INNER JOIN InvestX_Logging.dbo.FIXLogItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
		WHERE (IXAS.Id = ArchIXAS.Id);
	
		Select @CTFIXLogItems = COUNT(*) from InvestX_Archive.dbo.FIXLogItems IXAS
		WITH (NOLOCK) INNER JOIN InvestX_Logging.dbo.FIXLogItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
		WHERE (IXAS.Id = ArchIXAS.Id);

			IF @CTFIXLogItems > 0
			Print('Number of Records Removing from InvestX_Logging.dbo.FIXLogItems')
			SET @Done = 0	

 		WHILE (@CTFIXLogItems > 0 AND @Done=0)
			BEGIN
				BEGIN TRY
					BEGIN TRANSACTION 
						DELETE TOP(3000) IXAS FROM InvestX_Logging.dbo.FIXLogItems IXAS INNER JOIN 
						InvestX_Archive.dbo.FIXLogItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
						WHERE (IXAS.Id = ArchIXAS.Id);

						Select @CTFIXLogItems = COUNT(*) FROM InvestX_Logging.dbo.FIXLogItems IXAS
						WITH (NOLOCK) INNER JOIN InvestX_Archive.dbo.FIXLogItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
						WHERE (IXAS.Id = ArchIXAS.Id);
						print(@CTFIXLogItems);	

						IF @CTFIXLogItems > 0
						BEGIN
							DBCC UPDATEUSAGE (0); 
							CHECKPOINT -- marks log space reusable in simple recovery
						END	
						IF @CTFIXLogItems = 0 
						BEGIN
							SET @Done = 1
						END
					COMMIT TRANSACTION
				END TRY
				BEGIN CATCH
					ROLLBACK TRAN
						DECLARE @Line INT = ERROR_LINE()
						DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE() + ' On Line:' + cast(@Line as varchar(50))
						DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
						DECLARE @ErrorState INT = ERROR_STATE()
						RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
						Print(@Line + @ErrorMessage + @ErrorSeverity + @ErrorState);
					INSERT INTO ErrorLog(ProcedureName,ActionDateTime,ErrorMessage,ErrorSeverity,ErrorState) 
					VALUES('GetFIXLogItems',getdate(),ERROR_MESSAGE(),ERROR_SEVERITY(),ERROR_STATE())
				END CATCH
			END
END
GO
 
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

USE [InvestX_Archive]
GO
/****** Object:  StoredProcedure [dbo].[GetGenericLogItems]    Script Date: 2/14/2018 12:49:16 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO

CREATE PROCEDURE [dbo].[GetGenericLogItems](@month int)	
	 AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	  SET NOCOUNT ON;
      SET @month = @month	

		 DECLARE @CTGenericLogItems int = 0;
		 DECLARE @Done BIT = 0;	 

		 Select COUNT(*) as 'Number of targeted Records at "InvestX_Logging.dbo.GenericLogItems"' from InvestX_Logging.dbo.GenericLogItems 
		 WITH (NOLOCK) WHERE CONVERT(DATE,GenericLogItems."UtcDateTime") <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	

		 INSERT INTO InvestX_Archive.dbo.GenericLogItems SELECT * from  InvestX_Logging.dbo.GenericLogItems
		 WITH (NOLOCK) WHERE CONVERT(DATE,UtcDateTime) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	
		 
		Select COUNT(*) as 'Number of archived Records at "InvestX_Archive.dbo.GenericLogItems"' from InvestX_Archive.dbo.GenericLogItems IXAS
		WITH (NOLOCK) INNER JOIN InvestX_Logging.dbo.GenericLogItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
		WHERE (IXAS.Id = ArchIXAS.Id);
	
		Select @CTGenericLogItems = COUNT(*) from InvestX_Archive.dbo.GenericLogItems IXAS
		WITH (NOLOCK) INNER JOIN InvestX_Logging.dbo.GenericLogItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
		WHERE (IXAS.Id = ArchIXAS.Id);

			IF @CTGenericLogItems > 0
			Print('Number of Records Removing from InvestX_Logging.dbo.GenericLogItems')

			SET @Done = 0	

WHILE (@CTGenericLogItems > 0 AND @Done=0)
	BEGIN
		BEGIN TRY
			BEGIN TRANSACTION 
				DELETE TOP(3000) IXAS FROM InvestX_Logging.dbo.GenericLogItems IXAS INNER JOIN 
				InvestX_Archive.dbo.GenericLogItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
				WHERE (IXAS.Id = ArchIXAS.Id);

				Select @CTGenericLogItems = COUNT(*) FROM InvestX_Logging.dbo.GenericLogItems IXAS
				WITH (NOLOCK) INNER JOIN InvestX_Archive.dbo.GenericLogItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
				WHERE (IXAS.Id = ArchIXAS.Id);
				print(@CTGenericLogItems);	

				IF @CTGenericLogItems > 0
				BEGIN
					DBCC UPDATEUSAGE (0); 
					CHECKPOINT -- marks log space reusable in simple recovery
				END	
				IF @CTGenericLogItems = 0 
				BEGIN
					SET @Done = 1
				END
			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
				DECLARE @Line INT = ERROR_LINE()
				DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE() + ' On Line:' + cast(@Line as varchar(50))
				DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
				DECLARE @ErrorState INT = ERROR_STATE()
				RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
				Print(@Line + @ErrorMessage + @ErrorSeverity + @ErrorState);
			INSERT INTO ErrorLog(ProcedureName,ActionDateTime,ErrorMessage,ErrorSeverity,ErrorState) 
			VALUES('GetGenericLogItems',getdate(),ERROR_MESSAGE(),ERROR_SEVERITY(),ERROR_STATE())
		END CATCH
	END
END
GO

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

USE [InvestX_Archive]
GO

CREATE PROCEDURE [dbo].[GetHeartbeat](@month int)	
 AS
BEGIN
	SET NOCOUNT ON;
    SET @month = @month		
		DECLARE @Done BIT = 0;
		DECLARE @CTHeartbeat int = 0;
		Select COUNT(*) as 'Number of targeted Records at "InvestX_Logging.dbo.Heartbeat"' from InvestX_Logging.dbo.Heartbeat 
		WITH (NOLOCK) WHERE CONVERT(DATE,RegisterDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	
			
		INSERT INTO InvestX_Archive.dbo.Heartbeat SELECT * from  InvestX_Logging.dbo.Heartbeat
		WHERE CONVERT(DATE,RegisterDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	

		Select COUNT(*) as 'Number of archived Records at "InvestX_Archive.dbo.Heartbeat"' from InvestX_Archive.dbo.Heartbeat IXAS
		WITH (NOLOCK) INNER JOIN InvestX_Logging.dbo.Heartbeat ArchIXAS ON IXAS.Id = ArchIXAS.Id
		WHERE (IXAS.Id = ArchIXAS.Id);
	
		Select @CTHeartbeat = COUNT(*) from InvestX_Archive.dbo.Heartbeat IXAS
		WITH (NOLOCK) INNER JOIN InvestX_Logging.dbo.Heartbeat ArchIXAS ON IXAS.Id = ArchIXAS.Id
		WHERE (IXAS.Id = ArchIXAS.Id);

		IF @CTHeartbeat > 0
			Print('Number of Records Removing from InvestX_Logging.dbo.Heartbeat')
		SET @Done = 0	


 WHILE (@CTHeartbeat > 0 AND @Done=0)
	BEGIN
		BEGIN TRY
			BEGIN TRANSACTION 
				DELETE TOP(3000) IXAS FROM InvestX_Logging.dbo.Heartbeat IXAS INNER JOIN 
				InvestX_Archive.dbo.Heartbeat ArchIXAS ON IXAS.Id = ArchIXAS.Id
				WHERE (IXAS.Id = ArchIXAS.Id);

				Select @CTHeartbeat = COUNT(*) FROM InvestX_Logging.dbo.Heartbeat IXAS
				WITH (NOLOCK) INNER JOIN InvestX_Archive.dbo.Heartbeat ArchIXAS ON IXAS.Id = ArchIXAS.Id
				WHERE (IXAS.Id = ArchIXAS.Id);
				print(@CTHeartbeat);	

				IF @CTHeartbeat > 0
				BEGIN
					DBCC UPDATEUSAGE (0); 
					CHECKPOINT -- marks log space reusable in simple recovery
				END	
				IF @CTHeartbeat = 0 
				BEGIN
					SET @Done = 1
				END
			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
				DECLARE @Line INT = ERROR_LINE()
				DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE() + ' On Line:' + cast(@Line as varchar(50))
				DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
				DECLARE @ErrorState INT = ERROR_STATE()
				RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
				Print(@Line + @ErrorMessage + @ErrorSeverity + @ErrorState);
			INSERT INTO ErrorLog(ProcedureName,ActionDateTime,ErrorMessage,ErrorSeverity,ErrorState) 
			VALUES('GetHeartbeat',getdate(),ERROR_MESSAGE(),ERROR_SEVERITY(),ERROR_STATE())
		END CATCH
	END
END
GO

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

USE [InvestX_Archive]
GO

CREATE PROCEDURE [dbo].[GetHttpContextLogItems](@month int)	
 AS
BEGIN

	SET NOCOUNT ON;
    SET @month = @month		

		DECLARE @Done BIT = 0;
		DECLARE @CTHttpContextLogItems int = 0;

		Select COUNT(*) as 'Number of targeted Records at "InvestX_Logging.dbo.HttpContextLogItems"' from InvestX_Logging.dbo.HttpContextLogItems 
		WITH (NOLOCK) WHERE CONVERT(DATE,"UtcDateTime") <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	
			
		INSERT INTO InvestX_Archive.dbo.HttpContextLogItems SELECT * from  InvestX_Logging.dbo.HttpContextLogItems
		WITH (NOLOCK) WHERE CONVERT(DATE,UtcDateTime) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	

		Select COUNT(*) as 'Number of archived Records at "InvestX_Archive.dbo.HttpContextLogItems"' from InvestX_Archive.dbo.HttpContextLogItems IXAS
		WITH (NOLOCK) INNER JOIN InvestX_Logging.dbo.HttpContextLogItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
		WHERE (IXAS.Id = ArchIXAS.Id);
	
		Select @CTHttpContextLogItems = COUNT(*) from InvestX_Archive.dbo.HttpContextLogItems IXAS
		WITH (NOLOCK) INNER JOIN InvestX_Logging.dbo.HttpContextLogItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
		WHERE (IXAS.Id = ArchIXAS.Id);

			IF @CTHttpContextLogItems > 0
			Print('Number of Records Removing from InvestX_Logging.dbo.HttpContextLogItems')
			
			SET @Done = 0	

 WHILE (@CTHttpContextLogItems > 0 AND @Done=0)
	BEGIN
		BEGIN TRY
			BEGIN TRANSACTION 
				DELETE TOP(3000) IXAS FROM InvestX_Logging.dbo.HttpContextLogItems IXAS INNER JOIN 
				InvestX_Archive.dbo.HttpContextLogItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
				WHERE (IXAS.Id = ArchIXAS.Id);

				Select @CTHttpContextLogItems = COUNT(*) FROM InvestX_Logging.dbo.HttpContextLogItems IXAS
				WITH (NOLOCK) INNER JOIN InvestX_Archive.dbo.HttpContextLogItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
				WHERE (IXAS.Id = ArchIXAS.Id);
				print(@CTHttpContextLogItems);	

				IF @CTHttpContextLogItems > 0
				BEGIN
					DBCC UPDATEUSAGE (0); 
					CHECKPOINT -- marks log space reusable in simple recovery
				END	
				IF @CTHttpContextLogItems = 0 
				BEGIN
					SET @Done = 1
				END
			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
				DECLARE @Line INT = ERROR_LINE()
				DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE() + ' On Line:' + cast(@Line as varchar(50))
				DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
				DECLARE @ErrorState INT = ERROR_STATE()
				RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
				Print(@Line + @ErrorMessage + @ErrorSeverity + @ErrorState);
			INSERT INTO ErrorLog(ProcedureName,ActionDateTime,ErrorMessage,ErrorSeverity,ErrorState) 
			VALUES('GetHttpContextLogItems',getdate(),ERROR_MESSAGE(),ERROR_SEVERITY(),ERROR_STATE())
		END CATCH
	END
END
GO

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

USE [InvestX_Archive]
GO

CREATE PROCEDURE [dbo].[GetITCHLogItems](@month int)	
 AS
BEGIN

    SET @month = @month	
	SET NOCOUNT ON;
		DECLARE @Done BIT = 0;
		DECLARE @CTITCHLogItems int = 0;
		Select COUNT(*) as 'Number of targeted Records at "InvestX_Logging.dbo.ITCHLogItems"' from InvestX_Logging.dbo.ITCHLogItems 
		WITH (NOLOCK) WHERE CONVERT(DATE,UtcDateTime) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	
		
		INSERT INTO InvestX_Archive.dbo.ITCHLogItems SELECT [DevMessage]
           ,[Type]
           ,[UtcDateTime]
           ,[Exception]
           ,[Key]
           ,[KeyName]
           ,[Service]
           ,[Location]
           ,[UserAgent]
           ,[HttpCode]
           ,[LocalLogId] from  InvestX_Logging.dbo.ITCHLogItems
		WHERE CONVERT(DATE,UtcDateTime) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	

		Select COUNT(*) as 'Number of archived Records at "InvestX_Archive.dbo.ITCHLogItems"' from InvestX_Archive.dbo.ITCHLogItems IXAS
		WITH (NOLOCK) INNER JOIN InvestX_Logging.dbo.ITCHLogItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
		WHERE (IXAS.Id = ArchIXAS.Id);
	
		Select @CTITCHLogItems = COUNT(*) from InvestX_Archive.dbo.ITCHLogItems IXAS
		WITH (NOLOCK) INNER JOIN InvestX_Logging.dbo.ITCHLogItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
		WHERE (IXAS.Id = ArchIXAS.Id);

		IF @CTITCHLogItems > 0
		Print('Number of Records Removing from InvestX_Logging.dbo.ITCHLogItems')
			
				SET @Done = 0	

  WHILE (@CTITCHLogItems > 0 AND @Done=0)
	BEGIN
		BEGIN TRY
			BEGIN TRANSACTION 
				DELETE TOP(3000) IXAS FROM InvestX_Logging.dbo.ITCHLogItems IXAS INNER JOIN 
				InvestX_Archive.dbo.ITCHLogItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
				WHERE (IXAS.Id = ArchIXAS.Id);

				Select @CTITCHLogItems = COUNT(*) FROM InvestX_Logging.dbo.ITCHLogItems IXAS
				WITH (NOLOCK) INNER JOIN InvestX_Archive.dbo.ITCHLogItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
				WHERE (IXAS.Id = ArchIXAS.Id);
				print(@CTITCHLogItems);	

				IF @CTITCHLogItems > 0
				BEGIN
					DBCC UPDATEUSAGE (0); 
					CHECKPOINT -- marks log space reusable in simple recovery
				END	
				IF @CTITCHLogItems = 0 
				BEGIN
					SET @Done = 1
				END
			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
				DECLARE @Line INT = ERROR_LINE()
				DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE() + ' On Line:' + cast(@Line as varchar(50))
				DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
				DECLARE @ErrorState INT = ERROR_STATE()
				RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
				Print(@Line + @ErrorMessage + @ErrorSeverity + @ErrorState);
			INSERT INTO ErrorLog(ProcedureName,ActionDateTime,ErrorMessage,ErrorSeverity,ErrorState) 
			VALUES('GetITCHLogItems',getdate(),ERROR_MESSAGE(),ERROR_SEVERITY(),ERROR_STATE())
		END CATCH
	END
 END
GO

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


USE [InvestX_Archive]
GO

CREATE PROCEDURE [dbo].[GetSectionContentEditHistory](@month int)
	-- Add the parameters for the stored procedure here
AS
BEGIN
	SET NOCOUNT ON;
	SET @month = @month
	DECLARE @Done BIT = 0;
    DECLARE @CTSectionContentEditHistory int = 0;
			Select COUNT(*) as 'Number of targeted Records at "InvestX.dbo.SectionContentEditHistory"' from InvestX.dbo.SectionContentEditHistory 
			WITH (NOLOCK) WHERE CONVERT(DATE,ChangeDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	
			
			INSERT INTO InvestX_Archive.dbo.SectionContentEditHistory SELECT * from  InvestX.dbo.SectionContentEditHistory WITH (NOLOCK)
			WHERE CONVERT(DATE,ChangeDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	

			Select COUNT(*) as 'Number of archived Records at "InvestX_Archive.dbo.SectionContentEditHistory"' from InvestX_Archive.dbo.SectionContentEditHistory IXAS
			WITH (NOLOCK) INNER JOIN InvestX.dbo.SectionContentEditHistory ArchIXAS ON IXAS.Id = ArchIXAS.Id
			WHERE (IXAS.Id = ArchIXAS.Id);

			Select @CTSectionContentEditHistory = COUNT(*) from InvestX_Archive.dbo.SectionContentEditHistory IXAS
			WITH (NOLOCK) INNER JOIN InvestX.dbo.SectionContentEditHistory ArchIXAS ON IXAS.Id = ArchIXAS.Id
			WHERE (IXAS.Id = ArchIXAS.Id);

			IF @CTSectionContentEditHistory > 0
			Print('Number of Records Removing from InvestX.dbo.SectionContentEditHistory')
			
			SET @Done = 0
			
    WHILE (@CTSectionContentEditHistory > 0 AND @Done=0)
	BEGIN
		BEGIN TRY
			BEGIN TRANSACTION 
				DELETE TOP(3000) IXAS FROM InvestX.dbo.SectionContentEditHistory IXAS INNER JOIN 
				InvestX.dbo.SectionContentEditHistory ArchIXAS ON IXAS.Id = ArchIXAS.Id
				WHERE (IXAS.Id = ArchIXAS.Id);

				Select @CTSectionContentEditHistory = COUNT(*) FROM InvestX.dbo.SectionContentEditHistory IXAS
				WITH (NOLOCK) INNER JOIN InvestX_Archive.dbo.SectionContentEditHistory ArchIXAS ON IXAS.Id = ArchIXAS.Id
				WHERE (IXAS.Id = ArchIXAS.Id);
				print(@CTSectionContentEditHistory);	

				IF @CTSectionContentEditHistory > 0
				BEGIN
					DBCC UPDATEUSAGE (0); 
					CHECKPOINT -- marks log space reusable in simple recovery
				END	
				IF @CTSectionContentEditHistory = 0 
				BEGIN
					SET @Done = 1
				END
			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
				DECLARE @Line INT = ERROR_LINE()
				DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE() + ' On Line:' + cast(@Line as varchar(50))
				DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
				DECLARE @ErrorState INT = ERROR_STATE()
				RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
				Print(@Line + @ErrorMessage + @ErrorSeverity + @ErrorState);
			INSERT INTO ErrorLog(ProcedureName,ActionDateTime,ErrorMessage,ErrorSeverity,ErrorState) 
			VALUES('GetSectionContentEditHistory',getdate(),ERROR_MESSAGE(),ERROR_SEVERITY(),ERROR_STATE())
		END CATCH
	END
END
GO
 
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

USE [InvestX_Archive]
GO

CREATE PROCEDURE [dbo].[GetSerilogLogItems](@month int)	
 AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    SET @month = @month		
	DECLARE @CTSerilLogItems int = 0;
	DECLARE @Done BIT = 0;

		Select COUNT(*) as 'Number of targeted Records at "InvestX_Logging.dbo.SerilogLogItems"' from InvestX_Logging.dbo.SerilogLogItems 
		WITH (NOLOCK) WHERE CONVERT(DATE, InvestX_Logging.dbo.SerilogLogItems.UtcDateTime) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	

		INSERT INTO InvestX_Archive.dbo.SerilogLogItems SELECT [DevMessage]
           ,[Type]
           ,[UtcDateTime]
           ,[Exception]
           ,[Key]
           ,[KeyName]
           ,[Service]
           ,[Location]
           ,[UserAgent]
           ,[HttpCode]
           ,[LocalLogId] from  InvestX_Logging.dbo.SerilogLogItems
		WITH (NOLOCK) WHERE CONVERT(DATE, InvestX_Logging.dbo.SerilogLogItems."UtcDateTime") <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	

		Select COUNT(*) as 'Number of archived Records at "InvestX_Archive.dbo.SerilogLogItems"' from InvestX_Archive.dbo.SerilogLogItems IXAS
		WITH (NOLOCK) INNER JOIN InvestX_Logging.dbo.SerilogLogItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
		WHERE (IXAS.Id = ArchIXAS.Id);
	
		Select @CTSerilLogItems = COUNT(*) from InvestX_Archive.dbo.SerilogLogItems IXAS
		WITH (NOLOCK) INNER JOIN InvestX_Logging.dbo.SerilogLogItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
		WHERE (IXAS.Id = ArchIXAS.Id);

			IF @CTSerilLogItems > 0
			Print('Number of Records Removing from InvestX_Logging.dbo.SerilogLogItems')
			
			SET @Done = 0	
     WHILE (@CTSerilLogItems > 0 AND @Done=0)
	BEGIN
		BEGIN TRY
			BEGIN TRANSACTION 
				DELETE TOP(3000) IXAS FROM InvestX_Logging.dbo.SerilogLogItems IXAS INNER JOIN 
				InvestX_Archive.dbo.SerilogLogItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
				WHERE (IXAS.Id = ArchIXAS.Id);

				Select @CTSerilLogItems = COUNT(*) FROM InvestX_Logging.dbo.SerilogLogItems IXAS
				WITH (NOLOCK) INNER JOIN InvestX_Archive.dbo.SerilogLogItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
				WHERE (IXAS.Id = ArchIXAS.Id);
				print(@CTSerilLogItems);	

				IF @CTSerilLogItems > 0
				BEGIN
					DBCC UPDATEUSAGE (0); 
					CHECKPOINT -- marks log space reusable in simple recovery
				END	
				IF @CTSerilLogItems = 0 
				BEGIN
					SET @Done = 1
				END
			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
				DECLARE @Line INT = ERROR_LINE()
				DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE() + ' On Line:' + cast(@Line as varchar(50))
				DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
				DECLARE @ErrorState INT = ERROR_STATE()
				RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
				Print(@Line + @ErrorMessage + @ErrorSeverity + @ErrorState);
			INSERT INTO ErrorLog(ProcedureName,ActionDateTime,ErrorMessage,ErrorSeverity,ErrorState) 
			VALUES('GetSerilogLogItems',getdate(),ERROR_MESSAGE(),ERROR_SEVERITY(),ERROR_STATE())
		END CATCH
	END
END
GO
 
 --///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

 USE [InvestX_Archive]
GO

CREATE PROCEDURE [dbo].[GetTrackableItems](@month int)	
 AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    SET @month = @month		
	DECLARE @CTTrackableItems int = 0;
	DECLARE @Done BIT = 0;

		Select COUNT(*) as 'Number of targeted Records at "InvestX_Logging.dbo.TrackableItems"' from InvestX_Logging.dbo.TrackableItems 
		WITH (NOLOCK) WHERE CONVERT(DATE,UtcActionDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	
			
		INSERT INTO InvestX_Archive.dbo.TrackableItems SELECT * from  InvestX_Logging.dbo.TrackableItems
		WITH (NOLOCK) WHERE CONVERT(DATE,UtcActionDate) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	

		Select COUNT(*) as 'Number of archived Records at "InvestX_Archive.dbo.TrackableItems"' from InvestX_Archive.dbo.TrackableItems IXAS
		WITH (NOLOCK) INNER JOIN InvestX_Logging.dbo.TrackableItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
		WHERE (IXAS.Id = ArchIXAS.Id);
	
		Select @CTTrackableItems = COUNT(*) from InvestX_Archive.dbo.TrackableItems IXAS
		WITH (NOLOCK) INNER JOIN InvestX_Logging.dbo.TrackableItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
		WHERE (IXAS.Id = ArchIXAS.Id);

		IF @CTTrackableItems > 0
		Print('Number of Records Removing from InvestX_Logging.dbo.TrackableItems')


		SET @Done = 0	
     WHILE (@CTTrackableItems > 0 AND @Done=0)
	BEGIN
		BEGIN TRY
			BEGIN TRANSACTION 
				DELETE TOP(3000) IXAS FROM InvestX_Logging.dbo.TrackableItems IXAS INNER JOIN 
				InvestX_Archive.dbo.TrackableItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
				WHERE (IXAS.Id = ArchIXAS.Id);

				Select @CTTrackableItems = COUNT(*) FROM InvestX_Logging.dbo.TrackableItems IXAS
				WITH (NOLOCK) INNER JOIN InvestX_Archive.dbo.TrackableItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
				WHERE (IXAS.Id = ArchIXAS.Id);
				print(@CTTrackableItems);	

				IF @CTTrackableItems > 0
				BEGIN
					DBCC UPDATEUSAGE (0); 
					CHECKPOINT -- marks log space reusable in simple recovery
				END	
				IF @CTTrackableItems = 0 
				BEGIN
					SET @Done = 1
				END
			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
				DECLARE @Line INT = ERROR_LINE()
				DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE() + ' On Line:' + cast(@Line as varchar(50))
				DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
				DECLARE @ErrorState INT = ERROR_STATE()
				RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
				Print(@Line + @ErrorMessage + @ErrorSeverity + @ErrorState);
			INSERT INTO ErrorLog(ProcedureName,ActionDateTime,ErrorMessage,ErrorSeverity,ErrorState) 
			VALUES('GetTrackableItems',getdate(),ERROR_MESSAGE(),ERROR_SEVERITY(),ERROR_STATE())
		END CATCH
	END
END
GO
 --///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  USE [InvestX_Archive]
GO

CREATE PROCEDURE [dbo].[GetGEMPortalLogItems](@month int)	
 AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    SET @month = @month		
	DECLARE @CTGEMPortalLogItems int = 0;
	DECLARE @Done BIT = 0;

		Select COUNT(*) as 'Number of targeted Records at "InvestX_Logging.dbo.GEMPortalLogItems"' from InvestX_Logging.dbo.GEMPortalLogItems 
		WITH (NOLOCK) WHERE CONVERT(DATE,[TimeStamp]) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	
			
		INSERT INTO InvestX_Archive.dbo.GEMPortalLogItems SELECT * from  InvestX_Logging.dbo.GEMPortalLogItems
		WITH (NOLOCK) WHERE CONVERT(DATE,[TimeStamp]) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	

		Select COUNT(*) as 'Number of archived Records at "InvestX_Archive.dbo.GEMPortalLogItems"' from InvestX_Archive.dbo.GEMPortalLogItems IXAS
		WITH (NOLOCK) INNER JOIN InvestX_Logging.dbo.GEMPortalLogItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
		WHERE (IXAS.Id = ArchIXAS.Id);
	
		Select @CTGEMPortalLogItems = COUNT(*) from InvestX_Archive.dbo.GEMPortalLogItems IXAS
		WITH (NOLOCK) INNER JOIN InvestX_Logging.dbo.GEMPortalLogItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
		WHERE (IXAS.Id = ArchIXAS.Id);

		IF @CTGEMPortalLogItems > 0
		Print('Number of Records Removing from InvestX_Logging.dbo.GEMPortalLogItems')


		SET @Done = 0	
     WHILE (@CTGEMPortalLogItems > 0 AND @Done=0)
	BEGIN
		BEGIN TRY
			BEGIN TRANSACTION 
				DELETE TOP(3000) IXAS FROM InvestX_Logging.dbo.GEMPortalLogItems IXAS INNER JOIN 
				InvestX_Archive.dbo.GEMPortalLogItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
				WHERE (IXAS.Id = ArchIXAS.Id);

				Select @CTGEMPortalLogItems = COUNT(*) FROM InvestX_Logging.dbo.GEMPortalLogItems IXAS
				WITH (NOLOCK) INNER JOIN InvestX_Archive.dbo.GEMPortalLogItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
				WHERE (IXAS.Id = ArchIXAS.Id);
				print(@CTGEMPortalLogItems);	

				IF @CTGEMPortalLogItems > 0
				BEGIN
					DBCC UPDATEUSAGE (0); 
					CHECKPOINT -- marks log space reusable in simple recovery
				END	
				IF @CTGEMPortalLogItems = 0 
				BEGIN
					SET @Done = 1
				END
			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
				DECLARE @Line INT = ERROR_LINE()
				DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE() + ' On Line:' + cast(@Line as varchar(50))
				DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
				DECLARE @ErrorState INT = ERROR_STATE()
				RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
				Print(@Line + @ErrorMessage + @ErrorSeverity + @ErrorState);
			INSERT INTO ErrorLog(ProcedureName,ActionDateTime,ErrorMessage,ErrorSeverity,ErrorState) 
			VALUES('GetGEMPortalLogItems',getdate(),ERROR_MESSAGE(),ERROR_SEVERITY(),ERROR_STATE())
		END CATCH
	END
END
GO

 --///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  USE [InvestX_Archive]
GO

CREATE PROCEDURE [dbo].[GetGEMHubLogItems](@month int)	
 AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    SET @month = @month		
	DECLARE @CTGEMHubLogItems int = 0;
	DECLARE @Done BIT = 0;

		Select COUNT(*) as 'Number of targeted Records at "InvestX_Logging.dbo.GEMHubLogItems"' from InvestX_Logging.dbo.GEMHubLogItems 
		WITH (NOLOCK) WHERE CONVERT(DATE,[TimeStamp]) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	
			
		INSERT INTO InvestX_Archive.dbo.GEMHubLogItems SELECT * from  InvestX_Logging.dbo.GEMHubLogItems
		WITH (NOLOCK) WHERE CONVERT(DATE,[TimeStamp]) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	

		Select COUNT(*) as 'Number of archived Records at "InvestX_Archive.dbo.GEMHubLogItems"' from InvestX_Archive.dbo.GEMHubLogItems IXAS
		WITH (NOLOCK) INNER JOIN InvestX_Logging.dbo.GEMHubLogItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
		WHERE (IXAS.Id = ArchIXAS.Id);
	
		Select @CTGEMHubLogItems = COUNT(*) from InvestX_Archive.dbo.GEMHubLogItems IXAS
		WITH (NOLOCK) INNER JOIN InvestX_Logging.dbo.GEMHubLogItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
		WHERE (IXAS.Id = ArchIXAS.Id);

		IF @CTGEMHubLogItems > 0
		Print('Number of Records Removing from InvestX_Logging.dbo.GEMHubLogItems')


		SET @Done = 0	
     WHILE (@CTGEMHubLogItems > 0 AND @Done=0)
	BEGIN
		BEGIN TRY
			BEGIN TRANSACTION 
				DELETE TOP(3000) IXAS FROM InvestX_Logging.dbo.GEMHubLogItems IXAS INNER JOIN 
				InvestX_Archive.dbo.GEMHubLogItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
				WHERE (IXAS.Id = ArchIXAS.Id);

				Select @CTGEMHubLogItems = COUNT(*) FROM InvestX_Logging.dbo.GEMHubLogItems IXAS
				WITH (NOLOCK) INNER JOIN InvestX_Archive.dbo.GEMHubLogItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
				WHERE (IXAS.Id = ArchIXAS.Id);
				print(@CTGEMHubLogItems);	

				IF @CTGEMHubLogItems > 0
				BEGIN
					DBCC UPDATEUSAGE (0); 
					CHECKPOINT -- marks log space reusable in simple recovery
				END	
				IF @CTGEMHubLogItems = 0 
				BEGIN
					SET @Done = 1
				END
			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
				DECLARE @Line INT = ERROR_LINE()
				DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE() + ' On Line:' + cast(@Line as varchar(50))
				DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
				DECLARE @ErrorState INT = ERROR_STATE()
				RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
				Print(@Line + @ErrorMessage + @ErrorSeverity + @ErrorState);
			INSERT INTO ErrorLog(ProcedureName,ActionDateTime,ErrorMessage,ErrorSeverity,ErrorState) 
			VALUES('GetGEMHubLogItems',getdate(),ERROR_MESSAGE(),ERROR_SEVERITY(),ERROR_STATE())
		END CATCH
	END
END
GO

 --///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

USE [InvestX_Archive]
GO

CREATE PROCEDURE [dbo].[GetIdentityServerLogs](@month int)	
 AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    SET @month = @month		
	DECLARE @CTIdentityServerLogs int = 0;
	DECLARE @Done BIT = 0;

		Select COUNT(*) as 'Number of targeted Records at "InvestX_Logging.dbo.IdentityServerLogs"' from InvestX_Logging.dbo.IdentityServerLogs 
		WITH (NOLOCK) WHERE CONVERT(DATE,[TimeStamp]) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	
			
		INSERT INTO InvestX_Archive.dbo.IdentityServerLogs SELECT * from  InvestX_Logging.dbo.IdentityServerLogs
		WITH (NOLOCK) WHERE CONVERT(DATE,[TimeStamp]) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	

		Select COUNT(*) as 'Number of archived Records at "InvestX_Archive.dbo.IdentityServerLogs"' from InvestX_Archive.dbo.IdentityServerLogs IXAS
		WITH (NOLOCK) INNER JOIN InvestX_Logging.dbo.IdentityServerLogs ArchIXAS ON IXAS.Id = ArchIXAS.Id
		WHERE (IXAS.Id = ArchIXAS.Id);
	
		Select @CTIdentityServerLogs = COUNT(*) from InvestX_Archive.dbo.IdentityServerLogs IXAS
		WITH (NOLOCK) INNER JOIN InvestX_Logging.dbo.IdentityServerLogs ArchIXAS ON IXAS.Id = ArchIXAS.Id
		WHERE (IXAS.Id = ArchIXAS.Id);

		IF @CTIdentityServerLogs > 0
		Print('Number of Records Removing from InvestX_Logging.dbo.IdentityServerLogs')


		SET @Done = 0	
     WHILE (@CTIdentityServerLogs > 0 AND @Done=0)
	BEGIN
		BEGIN TRY
			BEGIN TRANSACTION 
				DELETE TOP(3000) IXAS FROM InvestX_Logging.dbo.IdentityServerLogs IXAS INNER JOIN 
				InvestX_Archive.dbo.IdentityServerLogs ArchIXAS ON IXAS.Id = ArchIXAS.Id
				WHERE (IXAS.Id = ArchIXAS.Id);

				Select @CTIdentityServerLogs = COUNT(*) FROM InvestX_Logging.dbo.IdentityServerLogs IXAS
				WITH (NOLOCK) INNER JOIN InvestX_Archive.dbo.IdentityServerLogs ArchIXAS ON IXAS.Id = ArchIXAS.Id
				WHERE (IXAS.Id = ArchIXAS.Id);
				print(@CTIdentityServerLogs);	

				IF @CTIdentityServerLogs > 0
				BEGIN
					DBCC UPDATEUSAGE (0); 
					CHECKPOINT -- marks log space reusable in simple recovery
				END	
				IF @CTIdentityServerLogs = 0 
				BEGIN
					SET @Done = 1
				END
			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
				DECLARE @Line INT = ERROR_LINE()
				DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE() + ' On Line:' + cast(@Line as varchar(50))
				DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
				DECLARE @ErrorState INT = ERROR_STATE()
				RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
				Print(@Line + @ErrorMessage + @ErrorSeverity + @ErrorState);
			INSERT INTO ErrorLog(ProcedureName,ActionDateTime,ErrorMessage,ErrorSeverity,ErrorState) 
			VALUES('GetIdentityServerLogs',getdate(),ERROR_MESSAGE(),ERROR_SEVERITY(),ERROR_STATE())
		END CATCH
	END
END
GO

 --///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

USE [InvestX_Archive]
GO

CREATE PROCEDURE [dbo].[GetTradingLogItems](@month int)	
 AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    SET @month = @month		
	DECLARE @CTTradingLogItems int = 0;
	DECLARE @Done BIT = 0;

		Select COUNT(*) as 'Number of targeted Records at "InvestX_Logging.dbo.TradingLogItems"' from InvestX_Logging.dbo.TradingLogItems 
		WITH (NOLOCK) WHERE CONVERT(DATE,[UtcDateTime]) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	
			
		INSERT INTO InvestX_Archive.dbo.TradingLogItems SELECT * from  InvestX_Logging.dbo.TradingLogItems
		WITH (NOLOCK) WHERE CONVERT(DATE,[UtcDateTime]) <= CONVERT(DATE,DATEADD(MONTH,-@month,GETDATE()));	

		Select COUNT(*) as 'Number of archived Records at "InvestX_Archive.dbo.TradingLogItems"' from InvestX_Archive.dbo.TradingLogItems IXAS
		WITH (NOLOCK) INNER JOIN InvestX_Logging.dbo.TradingLogItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
		WHERE (IXAS.Id = ArchIXAS.Id);
	
		Select @CTTradingLogItems = COUNT(*) from InvestX_Archive.dbo.TradingLogItems IXAS
		WITH (NOLOCK) INNER JOIN InvestX_Logging.dbo.TradingLogItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
		WHERE (IXAS.Id = ArchIXAS.Id);

		IF @CTTradingLogItems > 0
		Print('Number of Records Removing from InvestX_Logging.dbo.TradingLogItems')


		SET @Done = 0	
     WHILE (@CTTradingLogItems > 0 AND @Done=0)
	BEGIN
		BEGIN TRY
			BEGIN TRANSACTION 
				DELETE TOP(3000) IXAS FROM InvestX_Logging.dbo.TradingLogItems IXAS INNER JOIN 
				InvestX_Archive.dbo.TradingLogItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
				WHERE (IXAS.Id = ArchIXAS.Id);

				Select @CTTradingLogItems = COUNT(*) FROM InvestX_Logging.dbo.TradingLogItems IXAS
				WITH (NOLOCK) INNER JOIN InvestX_Archive.dbo.TradingLogItems ArchIXAS ON IXAS.Id = ArchIXAS.Id
				WHERE (IXAS.Id = ArchIXAS.Id);
				print(@CTTradingLogItems);	

				IF @CTTradingLogItems > 0
				BEGIN
					DBCC UPDATEUSAGE (0); 
					CHECKPOINT -- marks log space reusable in simple recovery
				END	
				IF @CTTradingLogItems = 0 
				BEGIN
					SET @Done = 1
				END
			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
				DECLARE @Line INT = ERROR_LINE()
				DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE() + ' On Line:' + cast(@Line as varchar(50))
				DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
				DECLARE @ErrorState INT = ERROR_STATE()
				RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
				Print(@Line + @ErrorMessage + @ErrorSeverity + @ErrorState);
			INSERT INTO ErrorLog(ProcedureName,ActionDateTime,ErrorMessage,ErrorSeverity,ErrorState) 
			VALUES('GetTradingLogItems',getdate(),ERROR_MESSAGE(),ERROR_SEVERITY(),ERROR_STATE())
		END CATCH
	END
END
GO
  --///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
