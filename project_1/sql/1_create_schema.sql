DROP SCHEMA IF EXISTS human_resources CASCADE;
CREATE SCHEMA human_resources;

SET search_path = human_resources;

-- create tables
CREATE TABLE IF NOT EXISTS landing_stage
(
    emp_id          TEXT,
    emp_name        TEXT,
    email           TEXT,
    hire_date       DATE,
    job_title       TEXT,
    salary          TEXT,
    department      TEXT,
    manager         TEXT,
    start_date      DATE,
    end_date        DATE,
    location        TEXT,
    address         TEXT,
    city            TEXT,
    state           TEXT,
    education_level TEXT
);

CREATE TABLE education_level
(
    id                SERIAL PRIMARY KEY,
    level_description TEXT
);

CREATE TABLE staff
(
    id           TEXT PRIMARY KEY,
    name         TEXT,
    email        TEXT,
    education_id INT REFERENCES education_level (id),
    hire_date    DATE
);

CREATE TABLE employment_salary
(
    id     SERIAL PRIMARY KEY,
    salary BIGINT
);

CREATE TABLE employment_position
(
    id            SERIAL PRIMARY KEY,
    position_name TEXT
);

CREATE TABLE location_state
(
    id         SERIAL PRIMARY KEY,
    state_name TEXT
);

CREATE TABLE location_city
(
    id        SERIAL PRIMARY KEY,
    city_name TEXT,
    state_id  INT REFERENCES location_state (id)
);

CREATE TABLE location_address
(
    id      SERIAL PRIMARY KEY,
    address TEXT,
    city_id INT REFERENCES location_city (id)
);

CREATE TABLE location
(
    id            SERIAL PRIMARY KEY,
    location_name TEXT,
    address_id    INT REFERENCES location_address (id)
);

CREATE TABLE department
(
    id              SERIAL PRIMARY KEY,
    department_name TEXT
);

CREATE TABLE employment
(
    staff_id      TEXT REFERENCES staff (id),
    position_id   INT REFERENCES employment_position (id),
    location_id   INT REFERENCES location (id),
    department_id INT REFERENCES department (id),
    manager_id    TEXT REFERENCES staff (id),
    start_date    DATE,
    end_date      DATE,
    salary_id     INT REFERENCES employment_salary (id)
);
