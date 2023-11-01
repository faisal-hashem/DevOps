CREATE ROLE semarchy_repository;
GRANT gadataadmin TO semarchy_repository;

CREATE SCHEMA extensions;
GRANT USAGE ON SCHEMA extensions TO PUBLIC;
ALTER DEFAULT PRIVILEGES IN SCHEMA extensions GRANT EXECUTE ON FUNCTIONS TO PUBLIC;
ALTER DATABASE semarchy_repository SET SEARCH_PATH TO "$user",public,extensions;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp"     with schema extensions;
CREATE EXTENSION IF NOT EXISTS "fuzzystrmatch" with schema extensions;

/* Create the repository user and schema */
CREATE USER _db_administrator WITH PASSWORD 'password';

/*create schema with _db_administrator*/
GRANT _db_administrator TO dataadmin;
ALTER ROLE dataadmin SET ROLE _db_administrator;
CREATE SCHEMA semarchy_repository AUTHORIZATION _db_administrator;

/* Create the repository read-only user */
CREATE USER _db_administrator_ro WITH PASSWORD 'password';

/* Give _db RO username rights to the DB */
GRANT CONNECT ON DATABASE semarchy_repository to _db_administrator_ro;
 
 /*Alter RO Username to the seach paths in the command*/
ALTER ROLE _db_administrator_ro SET SEARCH_PATH TO "$user",semarchy_repository,public,extensions;

/*Grant usage on db to RO username*/
GRANT USAGE ON SCHEMA semarchy_repository TO _db_administrator_ro;