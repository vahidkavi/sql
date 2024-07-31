USE [master]
GO

----Delete Databases
DROP DATABASE [InvestX]
GO

DROP DATABASE [InvestX_Admin]
GO

DROP DATABASE [InvestX_Logging]
GO

DROP DATABASE [InvestX_Secure]
GO

DROP DATABASE [InvestX_Vision]
GO

DROP DATABASE [InvestX_Archive]
GO

----Restore Database
RESTORE DATABASE InvestX_Admin
FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\InvestX_Admin\InvestX_Admin_backup_2021_01_31_010001_0988190.bak'
WITH MOVE 'InvestX_Admin' TO 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\InvestX_Admin.mdf',
MOVE 'InvestX_Admin_log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\InvestX_Admin_log.ldf'

----Restore Database
RESTORE DATABASE InvestX
FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\InvestX\InvestX_backup_2021_01_30_010000_8198019.bak'
WITH MOVE 'InvestX' TO 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\InvestX.mdf',
MOVE 'InvestX_log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\InvestX_log.ldf'

----Restore Database
RESTORE DATABASE InvestX_Logging
FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\InvestX_Logging\InvestX_Logging_backup_2021_01_31_010001_1118050.bak'
WITH MOVE 'InvestX_Logging' TO 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\InvestX_Logging.mdf',
MOVE 'InvestX_Logging_log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\InvestX_Logging_log.ldf'

----Restore Database
RESTORE DATABASE InvestX_Secure
FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\InvestX_Secure\InvestX_Secure_backup_2021_01_30_010000_8318024.bak'
WITH MOVE 'InvestX_Secure' TO 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\InvestX_Secure.mdf',
MOVE 'InvestX_Secure_log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\InvestX_Secure_log.ldf'

----Restore Database
RESTORE DATABASE InvestX_Vision
FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\InvestX_Vision\InvestX_Vision_backup_2021_01_30_010000_8387833.bak'
WITH MOVE 'InvestX_Vision' TO 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\InvestX_Vision.mdf',
MOVE 'InvestX_Vision_log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\InvestX_Vision_log.ldf'
