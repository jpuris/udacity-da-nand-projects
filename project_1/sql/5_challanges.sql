SET search_path = human_resources;

-- Challange 1: Create a view that returns all employee attributes; results should resemble initial Excel file
CREATE OR REPLACE VIEW all_employee_data AS
SELECT
    e.staff_id AS "EMP_ID",
    s.name AS "NAME",
    s.email AS "EMAIL",
    s.hire_date AS "HIRE_DT",
    ep.position_name AS "JOB_TITLE",
    es.salary AS "SALARY",
    d.department_name AS "DEPARTMENT",
    m.name AS "MANAGER",
    e.start_date AS "START_DT",
    e.end_date AS "END_DT",
    l.location_name AS "LOCATION",
    la.address AS "ADDRESS",
    lc.city_name AS "CITY",
    ls.state_name AS "STATE",
    el.level_description AS "EDUCATION LEVEL"
FROM employment e
    JOIN staff s ON e.staff_id = s.id
    LEFT JOIN staff m ON e.manager_id = m.id
    JOIN employment_position ep ON e.position_id = ep.id
    JOIN employment_salary es ON e.salary_id = es.id
    JOIN department d ON e.department_id = d.id
    JOIN location l ON e.location_id = l.id
    JOIN location_address la ON l.address_id = la.id
    JOIN location_city lc ON la.city_id = lc.id
    JOIN location_state ls ON lc.state_id = ls.id
    JOIN education_level el ON s.education_id = el.id;

SELECT * FROM all_employee_data;

-- Challange 2: Create a stored procedure with parameters that returns current and past jobs (include employee name, job title, department, manager name, start and end date for position) when given an employee name.
DROP FUNCTION IF EXISTS employment_history;
CREATE FUNCTION employment_history(staff_name TEXT)
    RETURNS TABLE
            (
                employee_name       TEXT,
                job_title           TEXT,
                department          TEXT,
                manager_name        TEXT,
                position_start_date DATE,
                position_end_date   DATE
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT
            s.name,
            ep.position_name,
            d.department_name,
            m.name,
            e.start_date,
            e.end_date
        FROM employment e
            JOIN staff s ON e.staff_id = s.id
            JOIN employment_position ep ON e.position_id = ep.id
            JOIN department d ON e.department_id = d.id
            LEFT JOIN staff m ON e.manager_id = m.id
        WHERE s.name = staff_name;
END;
$$
    LANGUAGE plpgsql;

SELECT *
FROM employment_history('Toni Lembeck');


-- Challange 3: Implement user security on the restricted salary attribute.
CREATE ROLE management_role;
GRANT USAGE ON SCHEMA human_resources TO management_role;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA human_resources TO management_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON ALL TABLES IN SCHEMA human_resources TO management_role;

CREATE ROLE employee_role;
GRANT USAGE ON SCHEMA human_resources TO employee_role;
GRANT SELECT ON ALL TABLES IN SCHEMA human_resources TO employee_role;
REVOKE SELECT ON TABLE employment_salary FROM employee_role;

CREATE USER employee_user WITH PASSWORD 'employee_user';
CREATE USER management_user WITH PASSWORD 'management_user';

GRANT management_role TO management_user;
GRANT employee_role TO employee_user;

