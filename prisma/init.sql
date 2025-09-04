/*
    We need to create the schemas, before Prisma runs.
    Prisma will not create the schemas by itself.
*/
CREATE SCHEMA IF NOT EXISTS orders;

CREATE SCHEMA IF NOT EXISTS users;

CREATE SCHEMA IF NOT EXISTS products;