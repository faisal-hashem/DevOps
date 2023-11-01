/* Script does NOT work, need to run init-db-sql-working.sql commands one by one */
CREATE SCHEMA extensions;
GRANT USAGE ON SCHEMA extensions TO PUBLIC;
ALTER DEFAULT PRIVILEGES IN SCHEMA extensions GRANT EXECUTE ON FUNCTIONS TO PUBLIC;
ALTER DATABASE semarchy_repository SET SEARCH_PATH TO "$user",public,extensions;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp"     with schema extensions;
CREATE EXTENSION IF NOT EXISTS "fuzzystrmatch" with schema extensions;

SET ROLE "${db_cluster_username}";
GRANT "${db_cluster_username}" TO semarchy_repository;

/* Create the repository user and schema */
CREATE USER "${_REPOSITORY_USERNAME}" WITH PASSWORD '${_REPOSITORY_PASSWORD}';

/*Give dataadmin access to _db_administrator*/
GRANT "${_REPOSITORY_USERNAME}" TO "${db_cluster_username}";
ALTER ROLE "${db_cluster_username}" SET ROLE "${_REPOSITORY_USERNAME}";

/*Give _db username rights to the DB*/
CREATE SCHEMA semarchy_repository AUTHORIZATION "${_REPOSITORY_USERNAME}";

/* Create the repository read-only user */
CREATE USER "${_REPOSITORY_READONLY_USERNAME}" WITH PASSWORD '${_REPOSITORY_READONLY_PASSWORD}';

/* Give _db RO username rights to the DB */
GRANT CONNECT ON DATABASE semarchy_repository to "${_REPOSITORY_READONLY_USERNAME}";
 
 /*Alter RO Username to the seach paths in the command*/
ALTER ROLE "${_REPOSITORY_READONLY_USERNAME}" SET SEARCH_PATH TO "$user",semarchy_repository,public,extensions;

/*Grant usage on db to RO username*/
GRANT USAGE ON SCHEMA semarchy_repository TO "${_REPOSITORY_READONLY_USERNAME}";

/*
 Grants access to the repository to the superuser.
 
GRANT CONNECT ON DATABASE semarchy_repository TO dataadmin;
*/
