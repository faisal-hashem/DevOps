DECLARE @adminLogin NVARCHAR(100) = 'myapp_db_administrator'
DECLARE @adminReadOnlyLogin NVARCHAR(100) = 'myapp_db_administrator_ro'

EXEC('CREATE USER ' + @adminLogin + ' FOR LOGIN ' + @adminLogin + ';');
EXEC('ALTER ROLE db_owner ADD MEMBER ' + @adminLogin + ';');
EXEC('CREATE USER ' + @adminReadOnlyLogin + ' FOR LOGIN ' + @adminReadOnlyLogin + ';');
EXEC('GRANT CONNECT TO ' + @adminReadOnlyLogin + ';');