CREATE TABLE departments
(
    id   SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE employees
(
    id            SERIAL PRIMARY KEY,
    name          TEXT NOT NULL,
    position      TEXT NOT NULL,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments (id) ON DELETE SET NULL
);

INSERT INTO departments(name)
VALUES ('IT department');
VALUES ('HR department');

INSERT INTO employees(name, position, department_id)
VALUES  ('Jonh','jun',1);
VALUES  ('Lily','manager',2);

DELETE FROM departments WHERE id=1;