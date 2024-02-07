/* Configure the database */
/* Run the following under Master DB */
USE Master
GO

ALTER DATABASE myapp_repository SET READ_COMMITTED_SNAPSHOT ON;
GO

ALTER DATABASE myapp_repository SET QUOTED_IDENTIFIER ON;
GO

/* Create a login to connect the database */

CREATE LOGIN _db_administrator WITH PASSWORD='password';
GO

/* Add a user for that login in the database */
/*Run the following under myapp_repositiory DB*/

USE myapp_repository
GO

CREATE USER _db_administrator FOR LOGIN _db_administrator
GO

ALTER ROLE db_owner ADD MEMBER _db_administrator
GO

/* Create the repository read-only user */
/* Run this under Master DB*/
USE Master
GO

CREATE LOGIN _db_administrator_ro WITH PASSWORD='password';
GO

/* Add a user for that login in the database */
/* Run this under myapp_repository DB*/
USE myapp_repository
GO

CREATE USER _db_administrator_ro FOR LOGIN _db_administrator_ro;
GO

/* Grant minimum access to the user */
GRANT CONNECT TO _db_administrator_ro;
GO