SET search_path = human_resources;

INSERT INTO education_level (level_description)
SELECT DISTINCT
    education_level
FROM landing_stage;

INSERT INTO staff
SELECT DISTINCT ON (ls.emp_id)
    ls.emp_id,
    REPLACE(ls.emp_name, '  ', ' '),
    LOWER(REPLACE(ls.email, ' ', '')),
    el.id,
    ls.hire_date
FROM landing_stage ls
    JOIN education_level el ON ls.education_level = el.level_description;

INSERT INTO location_state (state_name)
SELECT DISTINCT
    state
FROM landing_stage;

INSERT INTO location_city (city_name, state_id)
SELECT DISTINCT ON (ls.city)
    ls.city,
    loc_s.id
FROM landing_stage ls
    JOIN location_state loc_s ON ls.state = loc_s.state_name;

INSERT INTO location_address (address, city_id)
SELECT DISTINCT ON (ls.address)
    ls.address,
    lc.id
FROM landing_stage ls
    JOIN location_city lc ON ls.city = lc.city_name;

INSERT INTO location (location_name, address_id)
SELECT DISTINCT ON (ls.location)
    ls.location,
    la.id
FROM landing_stage ls
    JOIN location_address la ON ls.address = la.address;

INSERT INTO department (department_name)
SELECT DISTINCT
    ls.department
FROM landing_stage ls;

INSERT INTO employment_position (position_name)
SELECT DISTINCT
    ls.job_title
FROM landing_stage ls;

INSERT INTO employment_salary (salary)
SELECT DISTINCT
    REPLACE(ls.salary, ' ', '') :: INT
FROM landing_stage ls;

INSERT INTO employment (staff_id, position_id, location_id, department_id, manager_id, start_date, end_date, salary_id)
SELECT
    s.id,
    ep.id,
    l.id,
    d.id,
    m.id,
    ls.start_date,
    ls.end_date,
    es.id
FROM landing_stage ls
    JOIN staff s ON ls.emp_id = s.id
    LEFT JOIN staff m ON ls.manager = m.name
    JOIN employment_position ep ON ls.job_title = ep.position_name
    JOIN location l ON ls.location = l.location_name
    JOIN department d ON ls.department = d.department_name
    JOIN employment_salary es ON REPLACE(ls.salary, ' ', '') :: INT = es.salary;

DROP TABLE landing_stage;
