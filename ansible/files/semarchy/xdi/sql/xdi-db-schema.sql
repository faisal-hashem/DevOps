CREATE DATABASE xdi_analytics_repository
GO

ALTER DATABASE xdi_analytics_repository SET READ_COMMITTED_SNAPSHOT ON;
GO

ALTER DATABASE xdi_analytics_repository SET QUOTED_IDENTIFIER ON;
GO

CREATE LOGIN xdi_db_administrator WITH PASSWORD='CheckMeOut123';
GO


# switch xdi repo

CREATE USER xdi_db_administrator FOR LOGIN xdi_db_administrator
GO

ALTER ROLE db_owner ADD MEMBER xdi_db_administrator;
GO