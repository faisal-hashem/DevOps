CREATE ROLE myapp_repository;
GRANT gadataadmin TO myapp_repository;

CREATE SCHEMA extensions;
GRANT USAGE ON SCHEMA extensions TO PUBLIC;
ALTER DEFAULT PRIVILEGES IN SCHEMA extensions GRANT EXECUTE ON FUNCTIONS TO PUBLIC;
ALTER DATABASE myapp_repository SET SEARCH_PATH TO "$user",public,extensions;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp"     with schema extensions;
CREATE EXTENSION IF NOT EXISTS "fuzzystrmatch" with schema extensions;

/* Create the repository user and schema */
CREATE USER myapp_db_administrator WITH PASSWORD 'password';

/*create schema with myapp_db_administrator*/
GRANT myapp_db_administrator TO dataadmin;
ALTER ROLE dataadmin SET ROLE myapp_db_administrator;
CREATE SCHEMA myapp_repository AUTHORIZATION myapp_db_administrator;

/* Create the repository read-only user */
CREATE USER myapp_db_administrator_ro WITH PASSWORD 'password';

/* Give app_db RO username rights to the DB */
GRANT CONNECT ON DATABASE myapp_repository to myapp_db_administrator_ro;
 
 /*Alter RO Username to the seach paths in the command*/
ALTER ROLE myapp_db_administrator_ro SET SEARCH_PATH TO "$user",myapp_repository,public,extensions;

/*Grant usage on db to RO username*/
GRANT USAGE ON SCHEMA myapp_repository TO myapp_db_administrator_ro;