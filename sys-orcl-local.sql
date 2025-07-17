CREATE USER helena IDENTIFIED BY helena;

GRANT CREATE SESSION TO helena;

ALTER USER helena QUOTA UNLIMITED ON users;
grant alter any table to helena;

GRANT CREATE SEQUENCE TO helena;

grant create trigger to helena;

grant create view to helena;

grant create procedure to helena;

grant CREATE MATERIALIZED VIEW to helena;

grant create database link to helena;
GRANT create table TO helena;
CREATE SESSION, CREATE VIEW, ALTER SESSION, CREATE SEQUENCE,  
GRANT CREATE SYNONYM, RESOURCE, create procedure TO helena;

