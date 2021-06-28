SET search_path = human_resources;

-- Question 1: Return a list of employees with Job Titles and Department Names
SELECT
    s.id,
    s.name,
    ep.position_name,
    d.department_name
FROM employment e
    JOIN employment_position ep ON e.position_id = ep.id
    JOIN department d ON e.department_id = d.id
    JOIN staff s ON e.staff_id = s.id;

-- Question 2: Insert Web Programmer as a new job title
INSERT INTO employment_position (position_name)
VALUES
    ('Web Programmer');

SELECT *
FROM employment_position
WHERE position_name ILIKE 'web%';

-- Question 3: Correct the job title from web programmer to Web Developer
UPDATE employment_position
SET
    position_name = 'Web Developer'
WHERE position_name = 'Web Programmer';

SELECT *
FROM employment_position
WHERE position_name ILIKE 'web%';

-- Question 4: Delete the job title Web Developer from the database
DELETE
FROM employment_position
WHERE position_name = 'Web Developer';

-- Question 5: How many employees are in each department?
SELECT
    d.department_name,
    COUNT(DISTINCT staff_id) AS employee_count
FROM employment e
    JOIN department d ON e.department_id = d.id
GROUP BY d.id;

-- Question 6: Write a query that returns current and past jobs (include employee name, job title, department, manager name, start and end date for position) for employee Toni Lembeck.
SELECT
    s.name AS employee_name,
    ep.position_name AS job_title,
    d.department_name AS department,
    m.name AS manager_name,
    e.start_date AS position_start_date,
    e.end_date AS position_end_date
FROM employment e
    JOIN staff s ON e.staff_id = s.id
    JOIN employment_position ep ON e.position_id = ep.id
    JOIN department d ON e.department_id = d.id
    LEFT JOIN staff m ON e.manager_id = m.id
WHERE s.name = 'Toni Lembeck';

-- Question 7: Describe how you would apply table security to restrict access to employee salaries using an SQL server.
-- Create different roles and segment users into those roles.
-- One role would have read and write access (NO DDL's) to all tables in human_resources schema,
-- while the other would have read only access to the schema's tables, except with no access to salary entity.