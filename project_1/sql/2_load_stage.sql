SET search_path = human_resources;

COPY
    landing_stage (
                   emp_id,
                   emp_name,
                   email,
                   hire_date,
                   job_title,
                   salary,
                   department,
                   manager,
                   start_date,
                   end_date,
                   location,
                   address,
                   city,
                   state,
                   education_level
        )
    FROM '/tmp/hr-dataset/hr-dataset.csv' DELIMITER ';' CSV HEADER;