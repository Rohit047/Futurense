-- Active: 1707469488285@@127.0.0.1@3306@company
use company;

DROP Table department;

create table department(
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(255) NOT NULL UNIQUE,
    loca VARCHAR(255) DEFAULT NULL,
    manager_id INT DEFAULT NULL
);

create table empolyees(
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    hire_date DATE NOT NULL,
    department_id INT NOT NULL,
    salary DECIMAL(10,2) NOT NULL check (salary >= 0),
    Foreign Key (department_id) REFERENCES department(department_id)
);