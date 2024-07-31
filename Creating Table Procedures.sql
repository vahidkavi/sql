USE [master]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF NOT(EXISTS(SELECT * FROM sysdatabases WHERE name='InvestX_Archive'))
BEGIN

	CREATE DATABASE [InvestX_Archive]
	 CONTAINMENT = NONE
	 ON  PRIMARY 
	( NAME = N'InvestX_Archive', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\InvestX_Archive.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
	 LOG ON 
	( NAME = N'InvestX_Archive_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\InvestX_Archive_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
	--GO

	IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
	begin
	EXEC [InvestX_Archive].[dbo].[sp_fulltext_database] @action = 'enable'
	end
	--GO

	ALTER DATABASE [InvestX_Archive] SET ANSI_NULL_DEFAULT OFF 
	--GO

	ALTER DATABASE [InvestX_Archive] SET ANSI_NULLS OFF 
	--GO

	ALTER DATABASE [InvestX_Archive] SET ANSI_PADDING OFF 
	--GO

	ALTER DATABASE [InvestX_Archive] SET ANSI_WARNINGS OFF 
	--GO

	ALTER DATABASE [InvestX_Archive] SET ARITHABORT OFF 
	--GO

	ALTER DATABASE [InvestX_Archive] SET AUTO_CLOSE OFF 
	--GO

	ALTER DATABASE [InvestX_Archive] SET AUTO_SHRINK OFF 
	--GO

	ALTER DATABASE [InvestX_Archive] SET AUTO_UPDATE_STATISTICS ON 
	--GO

	ALTER DATABASE [InvestX_Archive] SET CURSOR_CLOSE_ON_COMMIT OFF 
	--GO

	ALTER DATABASE [InvestX_Archive] SET CURSOR_DEFAULT  GLOBAL 
	--GO

	ALTER DATABASE [InvestX_Archive] SET CONCAT_NULL_YIELDS_NULL OFF 
	--GO

	ALTER DATABASE [InvestX_Archive] SET NUMERIC_ROUNDABORT OFF 
	--GO

	ALTER DATABASE [InvestX_Archive] SET QUOTED_IDENTIFIER OFF 
	--GO

	ALTER DATABASE [InvestX_Archive] SET RECURSIVE_TRIGGERS OFF 
	--GO

	ALTER DATABASE [InvestX_Archive] SET  DISABLE_BROKER 
	--GO

	ALTER DATABASE [InvestX_Archive] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
	--GO

	ALTER DATABASE [InvestX_Archive] SET DATE_CORRELATION_OPTIMIZATION OFF 
	--GO

	ALTER DATABASE [InvestX_Archive] SET TRUSTWORTHY OFF 
	--GO

	ALTER DATABASE [InvestX_Archive] SET ALLOW_SNAPSHOT_ISOLATION OFF 
	--GO

	ALTER DATABASE [InvestX_Archive] SET PARAMETERIZATION SIMPLE 
	--GO

	ALTER DATABASE [InvestX_Archive] SET READ_COMMITTED_SNAPSHOT OFF 
	--GO

	ALTER DATABASE [InvestX_Archive] SET HONOR_BROKER_PRIORITY OFF 
	--GO

	ALTER DATABASE [InvestX_Archive] SET RECOVERY FULL 
	--GO

	ALTER DATABASE [InvestX_Archive] SET  MULTI_USER 
	--GO

	ALTER DATABASE [InvestX_Archive] SET PAGE_VERIFY CHECKSUM  
	--GO

	ALTER DATABASE [InvestX_Archive] SET DB_CHAINING OFF 
	--GO

	ALTER DATABASE [InvestX_Archive] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
	--GO

	ALTER DATABASE [InvestX_Archive] SET TARGET_RECOVERY_TIME = 60 SECONDS 
	--GO

	ALTER DATABASE [InvestX_Archive] SET DELAYED_DURABILITY = DISABLED 
	--GO

	ALTER DATABASE [InvestX_Archive] SET QUERY_STORE = OFF
	--GO

	ALTER DATABASE [InvestX_Archive] SET  READ_WRITE 
	--GO
	print('Archive DataBase created successfully!');
	END

	GO

	GO
	-----////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	USE [InvestX_Archive]
	GO
	SET ANSI_NULLS ON
	GO
	SET QUOTED_IDENTIFIER ON
	GO

	CREATE PROCEDURE CreatTblAccountSessions	
	AS

	CREATE TABLE [dbo].[AccountSessions](
		[ArchiveId] [bigint] IDENTITY(1,1) NOT NULL,
		[Id] [uniqueidentifier] NOT NULL,
		[Token] [nvarchar](1000) NULL,
		[ExpiresUtc] [datetime2](7) NULL,
		[AccountId] [uniqueidentifier] NULL,
		[Urn] [nvarchar](255) NULL,
	 CONSTRAINT [PK_AccountSessions] PRIMARY KEY CLUSTERED 
	(
		[ArchiveId] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
	GO

	----////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	USE [InvestX_Archive]
	GO
	SET ANSI_NULLS ON
	GO
	SET QUOTED_IDENTIFIER ON
	GO

	CREATE PROCEDURE CreatTblAccountSummaries
	AS

	CREATE TABLE [dbo].[AccountSummaries](
		[ArchiveId] [bigint] IDENTITY(1,1) NOT NULL,
		[Id] [uniqueidentifier] NOT NULL,
		[AccreditedAccounts] [int] NULL,
		[AccreditedAndFullMemberAccounts] [int] NULL,
		[AccreditedAndVerifiedAccounts] [int] NULL,
		[TotalAccounts] [int] NULL,
		[UtcSummaryDate] [datetime] NULL,
		[EmailConfirmed] [int] NULL,
		[EmailOptIn] [int] NULL,
		[CoRegistration] [int] NULL,
		[Unqualified] [int] NULL,
	 CONSTRAINT [PK__AccountS__3214EC0751351F70] PRIMARY KEY CLUSTERED 
	(
		[ArchiveId] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
	GO

	Go

	----////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	USE [InvestX_Archive]
	GO
	SET ANSI_NULLS ON
	GO
	SET QUOTED_IDENTIFIER ON
	GO
	CREATE PROCEDURE [dbo].[CreatTblAccountSummaryAccountDetails]	
	AS

	CREATE TABLE [dbo].[AccountSummaryAccountDetails](
		[ArchiveId] [bigint] IDENTITY(1,1) NOT NULL,
		[Id] [uniqueidentifier] NOT NULL,
		[AccountId] [uniqueidentifier] NULL,
		[AccountSummaryId] [uniqueidentifier] NULL,
		[Accredited] [bit] NULL,
		[IdVerified] [bit] NULL,
		[EmailAddress] [nvarchar](255) NULL,
		[FirstName] [nvarchar](255) NULL,
		[FullMember] [bit] NULL,
		[LastName] [nvarchar](255) NULL,
		[CountryCode] [nvarchar](255) NULL,
		[EmailOptIn] [bit] NULL,
		[EmailConfirmed] [bit] NULL,
		[Source] [nvarchar](255) NULL,
		[LastLoginDate] [datetime] NULL,
	 CONSTRAINT [PK__AccountS__3214EC076CDB8BD8] PRIMARY KEY CLUSTERED 
	(
		[ArchiveId] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
	GO

	GO

	----////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	USE [InvestX_Archive]
	GO
	SET ANSI_NULLS ON
	GO
	SET QUOTED_IDENTIFIER ON
	GO
	CREATE PROCEDURE [dbo].[CreatTblAdminAccountSessions]	
	AS

	CREATE TABLE [dbo].[AdminAccountSessions](
		[ArchiveId] [bigint] IDENTITY(1,1) NOT NULL,
		[Id] [uniqueidentifier] NOT NULL,
		[Token] [nvarchar](1000) NULL,
		[ExpiresUtc] [datetime2](7) NULL,
		[Urn] [nvarchar](255) NULL,
		[AccountId] [uniqueidentifier] NULL,
	 CONSTRAINT [PK_AdminAccountSessions] PRIMARY KEY CLUSTERED 
	(
		[ArchiveId] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
	GO

	GO

	---///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	USE [InvestX_Archive]
	GO
	SET ANSI_NULLS ON
	GO
	SET QUOTED_IDENTIFIER ON
	GO
	CREATE PROCEDURE [dbo].[CreatTblApiLogItems]	
	AS

	CREATE TABLE [dbo].[ApiLogItems](
		[ArchiveId] [bigint] IDENTITY(1,1) NOT NULL,
		[Id] [uniqueidentifier] NOT NULL,
		[Request] [nvarchar](max) NULL,
		[Response] [nvarchar](max) NULL,
		[Urn] [nvarchar](255) NULL,
		[Exception] [nvarchar](1024) NULL,
	 CONSTRAINT [PK_ApiLogItems] PRIMARY KEY CLUSTERED 
	(
		[ArchiveId] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
	GO

	GO
	---///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

USE [InvestX_Archive]
GO

/****** Object:  Table [dbo].[FIXLogItems]    Script Date: 2020-12-14 7:46:32 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CreatTblFIXLogItems]	
AS
CREATE TABLE [dbo].[FIXLogItems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DevMessage] [nvarchar](max) NULL,
	[Type] [nvarchar](255) NULL,
	[UtcDateTime] [datetime] NOT NULL,
	[Exception] [nvarchar](max) NULL,
	[Key] [nvarchar](255) NULL,
	[KeyName] [nvarchar](50) NULL,
	[Service] [nvarchar](50) NULL,
	[Location] [nvarchar](255) NULL,
	[UserAgent] [nvarchar](50) NULL,
	[HttpCode] [nvarchar](max) NULL,
	[LocalLogId] [nvarchar](255) NULL,
 CONSTRAINT [PK_FIXLogItems] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
GO

---///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

USE [InvestX_Archive]
GO

/****** Object:  Table [dbo].[Heartbeat]    Script Date: 2020-12-14 8:00:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CreatTblHeartbeat]	
AS
CREATE TABLE [dbo].[Heartbeat](
	[Id] [uniqueidentifier] NOT NULL,
	[ServiceNumber] [int] NULL,
	[ServiceName] [varchar](255) NULL,
	[RegisterDate] [datetime] NULL,
	[ServiceDescription] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
GO

---///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

USE [InvestX_Archive]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CreatTblITCHLogItems]	
AS

CREATE TABLE [dbo].[ITCHLogItems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DevMessage] [nvarchar](max) NULL,
	[Type] [nvarchar](255) NULL,
	[UtcDateTime] [datetime] NOT NULL,
	[Exception] [nvarchar](max) NULL,
	[Key] [nvarchar](255) NULL,
	[KeyName] [nvarchar](50) NULL,
	[Service] [nvarchar](50) NULL,
	[Location] [nvarchar](255) NULL,
	[UserAgent] [nvarchar](50) NULL,
	[HttpCode] [nvarchar](max) NULL,
	[LocalLogId] [nvarchar](255) NULL,
 CONSTRAINT [PK_ITCHLogItems] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
GO

---///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

USE [InvestX_Archive]
GO

/****** Object:  Table [dbo].[SerilogLogItems]    Script Date: 2020-12-14 8:08:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CreatTblSerilogLogItems]	
AS

CREATE TABLE [dbo].[SerilogLogItems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DevMessage] [nvarchar](max) NULL,
	[Type] [nvarchar](255) NULL,
	[UtcDateTime] [datetime] NOT NULL,
	[Exception] [nvarchar](max) NULL,
	[Key] [nvarchar](255) NULL,
	[KeyName] [nvarchar](50) NULL,
	[Service] [nvarchar](50) NULL,
	[Location] [nvarchar](255) NULL,
	[UserAgent] [nvarchar](50) NULL,
	[HttpCode] [nvarchar](max) NULL,
	[LocalLogId] [nvarchar](255) NULL,
 CONSTRAINT [PK_SerilogLogItems] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
GO

---///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	USE [InvestX_Archive]
	GO
	SET ANSI_NULLS ON
	GO
	SET QUOTED_IDENTIFIER ON
	GO
	CREATE PROCEDURE [dbo].[CreatTblDealSummaries]	
	AS

	CREATE TABLE [dbo].[DealSummaries](
		[ArchiveId] [bigint] IDENTITY(1,1) NOT NULL,
		[Id] [uniqueidentifier] NOT NULL,
		[DealGuid] [uniqueidentifier] NULL,
		[InterestExpressed] [int] NULL,
		[ConfidentialityAgreementInvited] [int] NULL,
		[ConfidentialityAgreementSigned] [int] NULL,
		[DisclaimerAccepted] [int] NULL,
		[ExpressedFundingAmount] [int] NULL,
		[SubscriptionAgreementInvited] [int] NULL,
		[SubscriptionAgreementSigned] [int] NULL,
		[ConfidentialityAgreementDownloaded] [int] NULL,
		[SubscriptionAgreementDownloaded] [int] NULL,
		[UtcSummaryDate] [datetime] NULL,
	 CONSTRAINT [PK_DealSummaries] PRIMARY KEY CLUSTERED 
	(
		[ArchiveId] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
	GO
	GO
	---///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	USE [InvestX_Archive]
	GO
	SET ANSI_NULLS ON
	GO
	SET QUOTED_IDENTIFIER ON
	GO
	CREATE PROCEDURE [dbo].[CreatTblDealSummaryAccountDetails]	
	AS

	CREATE TABLE [dbo].[DealSummaryAccountDetails](
		[Id] [uniqueidentifier] NOT NULL,
		[AccountId] [uniqueidentifier] NULL,
		[ReportType] [nvarchar](255) NULL,
		[ReportSubType] [nvarchar](255) NULL,
		[DealSummaryId] [uniqueidentifier] NULL,
		[Email] [nvarchar](255) NULL,
		[FirstName] [nvarchar](255) NULL,
		[LastName] [nvarchar](255) NULL,
		[UtcDate] [datetime] NULL,
		[AdditionalData1] [nvarchar](255) NULL,
	PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
	GO
	---///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	USE [InvestX_Archive]
	GO
	SET ANSI_NULLS ON
	GO
	SET QUOTED_IDENTIFIER ON
	GO
	CREATE PROCEDURE [dbo].[CreatTblDealSummaryDealAccounts]	
	AS

	CREATE TABLE [dbo].[DealSummaryDealAccounts](
		[ArchiveId] [bigint] IDENTITY(1,1) NOT NULL,
		[Id] [uniqueidentifier] NOT NULL,
		[DealSummaryId] [uniqueidentifier] NULL,
		[DealAccountId] [uniqueidentifier] NULL,
		[AccountId] [uniqueidentifier] NULL,
		[DealRoleId] [uniqueidentifier] NULL,
		[Email] [nvarchar](255) NULL,
		[FirstName] [nvarchar](255) NULL,
		[LastName] [nvarchar](255) NULL,
	 CONSTRAINT [PK_DealSummaryDealAccounts] PRIMARY KEY CLUSTERED 
	(
		[ArchiveId] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
	GO

	GO
	----///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	USE [InvestX_Archive]
	GO
	SET ANSI_NULLS ON
	GO
	SET QUOTED_IDENTIFIER ON
	GO
	CREATE PROCEDURE [dbo].[CreatTblErrorLog]	
	AS

	CREATE TABLE [dbo].[ErrorLog](
		[Id] [bigint] IDENTITY(1,1) NOT NULL,
		[ProcedureName] [varchar](100) NULL,
		[ActionDateTime] [datetime] NULL,
		[ErrorMessage] [varchar](5000) NULL,
		[ErrorSeverity] [int] NULL,
		[ErrorState] [int] NULL,
	 CONSTRAINT [PK_ErrorLog] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
	GO

	GO
	----/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	USE [InvestX_Archive]
	GO
	SET ANSI_NULLS ON
	GO
	SET QUOTED_IDENTIFIER ON
	GO
	CREATE PROCEDURE [dbo].[CreatTblGenericLogItems]	
	AS

	CREATE TABLE [dbo].[GenericLogItems](
		[ArchiveId] [bigint] IDENTITY(1,1) NOT NULL,
		[Id] [uniqueidentifier] NOT NULL,
		[ExceptionId] [uniqueidentifier] NULL,
		[UtcDateTime] [datetime] NULL,
		[AccountId] [nvarchar](255) NULL,
		[Source] [nvarchar](max) NULL,
		[StackTrace] [nvarchar](max) NULL,
		[Exception] [nvarchar](max) NULL,
	 CONSTRAINT [PK_GenericLogItems] PRIMARY KEY CLUSTERED 
	(
		[ArchiveId] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
	GO

	GO
	----/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	USE [InvestX_Archive]
	GO
	SET ANSI_NULLS ON
	GO
	SET QUOTED_IDENTIFIER ON
	GO

	CREATE PROCEDURE [dbo].[CreatTblHttpContextLogItems]	
	AS

	CREATE TABLE [dbo].[HttpContextLogItems](
		[ArchiveId] [bigint] IDENTITY(1,1) NOT NULL,
		[Id] [uniqueidentifier] NOT NULL,
		[ExceptionId] [uniqueidentifier] NULL,
		[UtcDateTime] [datetime] NULL,
		[AccountId] [nvarchar](255) NULL,
		[RequestParams] [nvarchar](max) NULL,
		[RequestType] [nvarchar](max) NULL,
		[RequestUrl] [nvarchar](max) NULL,
		[RequestUrlReferrer] [nvarchar](max) NULL,
		[Source] [nvarchar](max) NULL,
		[StackTrace] [nvarchar](max) NULL,
		[Exception] [nvarchar](max) NULL,
	 CONSTRAINT [PK_HttpContextLogItems] PRIMARY KEY CLUSTERED 
	(
		[ArchiveId] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
	GO

	GO
	----/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	USE [InvestX_Archive]
	GO
	SET ANSI_NULLS ON
	GO
	SET QUOTED_IDENTIFIER ON
	GO

	CREATE PROCEDURE [dbo].[CreatTblSectionContentEditHistory]	
	AS

	CREATE TABLE [dbo].[SectionContentEditHistory](
		[ArchiveId] [bigint] IDENTITY(1,1) NOT NULL,
		[Id] [uniqueidentifier] NOT NULL,
		[SectionContentId] [uniqueidentifier] NULL,
		[ChangeDate] [datetime] NULL,
		[ChangedByUserName] [nvarchar](255) NULL,
		[Notes] [nvarchar](255) NULL,
		[StatusChangedTo] [nvarchar](255) NULL,
		[Value] [nvarchar](max) NULL,
		[DraftValue] [nvarchar](max) NULL,
	 CONSTRAINT [PK__SectionC__3214EC078EB4B7EB] PRIMARY KEY CLUSTERED 
	(
		[ArchiveId] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
	GO

	GO

	----/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	USE [InvestX_Archive]
	GO
	SET ANSI_NULLS ON
	GO
	SET QUOTED_IDENTIFIER ON
	GO

	CREATE PROCEDURE [dbo].[CreatTblTrackableItems]	
	AS

	CREATE TABLE [dbo].[TrackableItems](
		[ArchiveId] [bigint] IDENTITY(1,1) NOT NULL,
		[Id] [uniqueidentifier] NOT NULL,
		[AccountId] [uniqueidentifier] NULL,
		[UtcActionDate] [datetime] NULL,
		[Controller] [nvarchar](255) NULL,
		[Action] [nvarchar](255) NULL,
		[ActionType] [nvarchar](255) NULL,
		[ActionSubType] [nvarchar](255) NULL,
		[PrimaryArg] [nvarchar](255) NULL,
		[Args] [nvarchar](max) NULL,
	 CONSTRAINT [PK_TrackableItems] PRIMARY KEY CLUSTERED 
	(
		[ArchiveId] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
	GO

	GO
	-----///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--END

USE [InvestX_Archive]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CreatTblDealDocumentSummaries]	
AS

CREATE TABLE [dbo].[DealDocumentSummaries](
	[Id] [uniqueidentifier] NOT NULL,
	[DealId] [uniqueidentifier] NULL,
	[DealSummaryId] [uniqueidentifier] NULL,
	[ReportSubType] [nvarchar](255) NULL,
	[DownloadCount] [int] NULL,
	[ReportType] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

GO

-----///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


USE [InvestX_Archive]
GO

/****** Object:  Table [dbo].[DealRoleSummaries]    Script Date: 2020-12-18 11:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CreatTblDealRoleSummaries]	
AS
CREATE TABLE [dbo].[DealRoleSummaries](
	[Id] [uniqueidentifier] NOT NULL,
	[DealSummaryId] [uniqueidentifier] NULL,
	[DealRoleId] [uniqueidentifier] NULL,
	[Count] [int] NULL,
	[Hierarchy] [int] NULL,
	[RoleName] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
GO
-----///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
USE [InvestX_Archive]
GO

/****** Object:  Table [dbo].[GEMPortalLogItems]    Script Date: 9/15/2022 7:33:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CreatTblGEMPortalLogItems]	
AS
CREATE TABLE [dbo].[GEMPortalLogItems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Message] [nvarchar](max) NULL,
	[MessageTemplate] [nvarchar](max) NULL,
	[Level] [nvarchar](max) NULL,
	[TimeStamp] [datetime] NULL,
	[Exception] [nvarchar](max) NULL,
	[Properties] [nvarchar](max) NULL,
	[UserName] [nvarchar](255) NULL,
	[AccountID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_GEMPortalLogItems] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
GO

-----///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
USE [InvestX_Archive]
GO

/****** Object:  Table [dbo].[GEMHubLogItems]    Script Date: 9/15/2022 7:41:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CreatTblGEMHubLogItems]	
AS

CREATE TABLE [dbo].[GEMHubLogItems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Message] [nvarchar](max) NULL,
	[MessageTemplate] [nvarchar](max) NULL,
	[Level] [nvarchar](max) NULL,
	[TimeStamp] [datetime] NULL,
	[Exception] [nvarchar](max) NULL,
	[Properties] [nvarchar](max) NULL,
	[UserName] [nvarchar](255) NULL,
	[AccountID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_GEMHubLogItems] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
GO

-----///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
USE [InvestX_Archive]
GO

/****** Object:  Table [dbo].[IdentityServerLogs]    Script Date: 9/15/2022 7:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CreatTblIdentityServerLogs]	
AS

CREATE TABLE [dbo].[IdentityServerLogs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Message] [nvarchar](max) NULL,
	[MessageTemplate] [nvarchar](max) NULL,
	[Level] [nvarchar](max) NULL,
	[TimeStamp] [datetime] NULL,
	[Exception] [nvarchar](max) NULL,
	[Properties] [nvarchar](max) NULL,
	[UserName] [nvarchar](255) NULL,
	[AccountID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_IdentityServerLogs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
GO
-----///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

USE [InvestX_Archive]
GO

/****** Object:  Table [dbo].[TradingLogItems]    Script Date: 9/15/2022 7:46:39 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CreatTblTradingLogItems]	
AS
CREATE TABLE [dbo].[TradingLogItems](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[DevMessage] [nvarchar](max) NULL,
	[Type] [nvarchar](255) NULL,
	[UtcDateTime] [datetime] NOT NULL,
	[Exception] [nvarchar](max) NULL,
	[Key] [nvarchar](255) NULL,
	[KeyName] [nvarchar](50) NULL,
	[Service] [nvarchar](50) NULL,
	[Location] [nvarchar](255) NULL,
	[UserAgent] [nvarchar](50) NULL,
	[HttpCode] [nvarchar](max) NULL,
	[LocalLogId] [nvarchar](255) NULL,
 CONSTRAINT [PK_TradingLogItems] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-----///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

USE [InvestX_Archive]
GO
/****** Object:  StoredProcedure [dbo].[GetGenericLogItems]    Script Date: 2/14/2018 12:49:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DeleteRecords](
	@TargetName sysname,
	@SourceName sysname,
	@DBT sysname,
	@DBS sysname) AS
BEGIN
	SET NOCOUNT ON;
	 DECLARE @Done BIT
		DECLARE @count int=0
		DECLARE @Target as sysname
		DECLARE @Source as sysname
		DECLARE @cmd AS NVARCHAR(max)

		SET @TargetName = RTRIM(@TargetName)
		SET @SourceName = RTRIM(@SourceName)
		SET @DBT = RTRIM(@DBT)
		SET @DBS = RTRIM(@DBS)
		SET @Target = RTRIM(@DBT) + N'.dbo.'+ RTRIM(@TargetName)
		SET @Source = RTRIM(@DBS) + N'.dbo.'+ RTRIM(@SourceName)
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRAN
				SET @Done = 0

				SET @cmd = N'Select @Count = COUNT(*) FROM ' + RTRIM(@Target) + N' IXAS INNER JOIN ' +
				RTRIM(@Source) + N' ArchIXAS ON IXAS.Id = ArchIXAS.Id WHERE (IXAS.Id = ArchIXAS.Id);'
				EXEC sp_executesql @cmd, N'@Count int output', @Count = @Count OUTPUT
				print('Number of remaining records to be deleted from '+RTRIM(@Target));	
				print(@count);	

				WHILE (@count > 0 AND @Done=0)
					BEGIN
							SET @cmd = N'DELETE TOP(30000) IXAS FROM ' + RTRIM(@Target) + N' IXAS INNER JOIN ' +
							RTRIM(@Source)+ N' ArchIXAS ON IXAS.Id = ArchIXAS.Id WHERE (IXAS.Id = ArchIXAS.Id);'
							EXEC sp_executesql @cmd 

							SET @cmd = N'Select @Count = COUNT(*) FROM ' + RTRIM(@Target) + N' IXAS INNER JOIN ' +
							RTRIM(@Source) + N' ArchIXAS ON IXAS.Id = ArchIXAS.Id WHERE (IXAS.Id = ArchIXAS.Id);'
							EXEC sp_executesql @cmd, N'@Count int output', @Count = @Count OUTPUT
							print(@count);	

							--DBCC UPDATEUSAGE (0); 
							CHECKPOINT -- marks log space reusable in simple recovery
							IF @@TRANCOUNT > 0
								BEGIN
									DBCC UPDATEUSAGE (0); 
									COMMIT TRAN
								END	
							IF @count = 0 
							BEGIN
								SET @Done = 1
							END
					END
		END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		INSERT INTO ErrorLog(ProcedureName,ActionDateTime,ErrorMessage,ErrorSeverity,ErrorState) 
		VALUES('GetGenericLogItems',getdate(),ERROR_MESSAGE(),ERROR_SEVERITY(),ERROR_STATE())
	END CATCH;
END