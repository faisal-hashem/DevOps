DECLARE @dbName NVARCHAR(100) = 'myapp_repository'
DECLARE @adminLogin NVARCHAR(100) = 'myapp_db_administrator'
DECLARE @adminReadOnlyLogin NVARCHAR(100) = 'myapp_db_administrator_ro'
DECLARE @adminPassword NVARCHAR(100) = '$(AdminPassword)'
DECLARE @adminReadOnlyPassword NVARCHAR(100) = '$(AdminReadOnlyPassword)'

EXEC('ALTER DATABASE ' + @dbName + ' SET READ_COMMITTED_SNAPSHOT ON;');
EXEC('ALTER DATABASE ' + @dbName + ' SET QUOTED_IDENTIFIER ON;');
EXEC('CREATE LOGIN ' + @adminLogin + ' WITH PASSWORD=N''' + @adminPassword + ''';');
EXEC('CREATE LOGIN ' + @adminReadOnlyLogin + ' WITH PASSWORD=N''' + @adminReadOnlyPassword + ''';');