/* Create a database for the repository */

CREATE DATABASE myapp_repository
GO

/* Configure the database */

ALTER DATABASE myapp_repository SET READ_COMMITTED_SNAPSHOT ON;
GO

ALTER DATABASE myapp_repository SET QUOTED_IDENTIFIER ON;
GO

/* Create a login to connect the database  - DEFAULT_DATABASE not supported */

CREATE LOGIN _db_administrator WITH PASSWORD='password', DEFAULT_DATABASE=myapp_repository
GO

/* Add a user for that login in the database */

USE myapp_repository
GO

CREATE USER _db_administrator FOR LOGIN _db_administrator
GO

/* Make this user database owner */

ALTER ROLE db_owner ADD MEMBER _db_administrator
GO

/* Create the repository read-only user */
CREATE LOGIN _db_administrator_ro WITH PASSWORD='password', DEFAULT_DATABASE=myapp_repository
GO

/* Add a user for that login in the database */

USE myapp_repository
GO

CREATE USER _db_administrator_ro FOR LOGIN _db_administrator_ro;
GO

/* Grant minimum access to the user */
GRANT CONNECT TO _db_administrator_ro;


/*DB, logins and roles were created successfully. Run the following after init is completed. 


/* Run the following commands after the repository creation. */
/* Grant select privileges on the profiling tables */
GRANT SELECT ON PRF_PROFILING TO _db_administrator_ro;
GRANT SELECT ON PRF_TABLE TO _db_administrator_ro;
GRANT SELECT ON PRF_COLUMN TO _db_administrator_ro;
GRANT SELECT ON PRF_DIST_VALS TO _db_administrator_ro;
GRANT SELECT ON PRF_DIST_PATTERNS TO _db_administrator_ro;

/* Create a database for the data location */

CREATE DATABASE <data_location_database_name>
GO

/* Configure the database */

ALTER DATABASE <data_location_database_name> SET READ_COMMITTED_SNAPSHOT ON;
GO

ALTER DATABASE <data_location_database_name> SET QUOTED_IDENTIFIER ON;
GO

/* Create a login to connect the database */

CREATE LOGIN <data_location_user_name> WITH PASSWORD='<data_location_user_password>', DEFAULT_DATABASE=<data_location_database_name>
GO

/* Add a user for that login in the database */

USE <data_location_database_name>
GO

CREATE USER <data_location_user_name> FOR LOGIN <data_location_user_name>
GO

/* Make this user database owner */

ALTER ROLE db_owner ADD MEMBER <data_location_user_name>
GO