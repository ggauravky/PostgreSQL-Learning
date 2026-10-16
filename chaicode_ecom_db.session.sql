create TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    manager_id INT,
    location_id INT
);



INSERT INTO departments (department_name) VALUES
    ('Human Resources'),
    ('Finance'),
    ('IT'),
    ('Marketing');

INSERT INTO departments (department_name, manager_id, location_id) VALUES
    ('Sales', 1, 101),
    ('Customer Support', 2, 102),
    ('Research and Development', 3, 103);

SELECT * FROM departments;


CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    hire_date DATE NOT NULL,
    job_id INT NOT NULL,
    salary DECIMAL(10, 2) NOT NULL,
    department_id INT REFERENCES departments(department_id)
);

-- 
-- employee- active or on leave or terminated 
-- here is how can you do - 
-- Add a status column to the employees table

-- ALTER TABLE employees ADD COLUMN status VARCHAR(20) DEFAULT 'active' check (employees.status IN ('active', 'on leave', 'terminated'));
-- 

-- foreign key constraint for job_id referencing jobs table
-- ALTER TABLE employees ADD CONSTRAINT fk_job FOREIGN KEY (job_id) REFERENCES jobs(job_id); 