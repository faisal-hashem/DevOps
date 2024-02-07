CREATE DATABASE myapp_analytics_repository
GO

ALTER DATABASE myapp_analytics_repository SET READ_COMMITTED_SNAPSHOT ON;
GO

ALTER DATABASE myapp_analytics_repository SET QUOTED_IDENTIFIER ON;
GO

CREATE LOGIN myapp_db_administrator WITH PASSWORD='CheckMeOut123';
GO


# switch myapp repo

CREATE USER myapp_db_administrator FOR LOGIN myapp_db_administrator
GO

ALTER ROLE db_owner ADD MEMBER myapp_db_administrator;
GO