CREATE TABLE departments
(
    id       SERIAL PRIMARY KEY,
    name     VARCHAR(50) NOT NULL,
    location VARCHAR(50)
);

CREATE TABLE employees
(
    id            SERIAL PRIMARY KEY,
    name          VARCHAR(50) NOT NULL,
    position      VARCHAR(50),
    salary        NUMERIC(10, 2),
    department_id INTEGER     REFERENCES departments (id) ON DELETE SET NULL,
    manager_id    INTEGER     REFERENCES employees (id) ON DELETE SET NULL
);

CREATE TABLE customers
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(50)
);

CREATE TABLE orders
(
    id          SERIAL PRIMARY KEY,
    order_date  DATE    NOT NULL,
    amount      NUMERIC(10, 2),
    employee_id INTEGER REFERENCES employees (id) ON DELETE SET NULL,
    customer_id INTEGER REFERENCES customers (id) ON DELETE SET NULL
);

CREATE TABLE products
(
    id    SERIAL PRIMARY KEY,
    name  VARCHAR(100) NOT NULL,
    price NUMERIC(10, 2)
);

CREATE TABLE order_items
(
    id         SERIAL PRIMARY KEY,
    order_id   INTEGER REFERENCES orders (id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES products (id) ON DELETE SET NULL,
    quantity   INTEGER NOT NULL
);

INSERT INTO departments (name, location)
VALUES ('Sales', 'New York'),
       ('IT', 'San Francisco'),
       ('HR', 'Los Angeles'),
       ('Finance', 'Chicago');

-- Employees
INSERT INTO employees (name, position, salary, department_id, manager_id)
VALUES ('John Smith', 'Sales Manager', 8500.00, 1, NULL),
       ('Alice Johnson', 'Sales Representative', 5000.00, 1, 1),
       ('Robert Brown', 'IT Manager', 9000.00, 2, NULL),
       ('Emily Davis', 'Software Engineer', 6000.00, 2, 3),
       ('Michael Wilson', 'HR Manager', 7000.00, 3, NULL),
       ('Sarah Miller', 'HR Specialist', 4500.00, 3, 5),
       ('David Taylor', 'Accountant', 5500.00, 4, NULL);

-- Customers
INSERT INTO customers (name, city)
VALUES ('Acme Corp', 'New York'),
       ('Global Solutions', 'San Francisco'),
       ('Tech Innovations', 'Los Angeles'),
       ('Urban Traders', 'Chicago'),
       ('BlueSky Ltd', 'Houston');

-- Products
INSERT INTO products (name, price)
VALUES ('Laptop', 1200.00),
       ('Smartphone', 800.00),
       ('Office Chair', 150.00),
       ('Desk Lamp', 50.00),
       ('Headphones', 100.00),
       ('Monitor', 300.00);

-- Orders
INSERT INTO orders (order_date, amount, employee_id, customer_id)
VALUES ('2025-10-01', 2400.00, 2, 1),
       ('2025-10-02', 800.00, 4, 2),
       ('2025-10-03', 950.00, 2, 3),
       ('2025-10-04', 1200.00, 7, 4),
       ('2025-10-05', 450.00, 6, 5);

-- Order Items
INSERT INTO order_items (order_id, product_id, quantity)
VALUES (1, 1, 2),
       (1, 6, 1),
       (2, 2, 1),
       (3, 3, 5),
       (3, 4, 2),
       (4, 1, 1),
       (4, 5, 3),
       (5, 4, 3);

--1
SELECT e.id, e.name,COALESCE(d.name, 'No Department') AS department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.id;
--2
SELECT e.name AS employee_name,m.name AS manager_name
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.id
WHERE e.manager_id IS NOT NULL;
--3
SELECT d.id,d.name
FROM departments d LEFT JOIN employees e ON d.id = e.department_id
WHERE e.id IS NULL;
--4
SELECT o.id,COALESCE(e.name, 'No Employee') AS employee_name,
COALESCE(c.name, 'No Customer') AS customer_name
FROM orders o
LEFT JOIN employees e ON o.employee_id = e.id
LEFT JOIN customers c ON o.customer_id = c.id;
--5
SELECT o.id AS order_id,COALESCE(p.name, 'No Product') AS product_name,    COALESCE(oi.quantity, 0) AS quantity
FROM orders o
LEFT JOIN order_items oi ON o.id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.id;
--6
SELECT
    d.id AS department_id,
    d.name AS department_name,
    o.id AS order_id,
    o.order_date,
    o.amount
FROM departments d
LEFT JOIN employees e ON d.id = e.department_id
LEFT JOIN orders o ON e.id = o.employee_id;
--7
SELECT
    c.id AS customer_id,
    c.name AS customer_name,
    p.id AS product_id,
    p.name AS product_name
FROM customers c, products p
WHERE (c.id, p.id) NOT IN (
    SELECT DISTINCT o.customer_id, oi.product_id
    FROM orders o
    JOIN order_items oi ON o.id = oi.order_id
    WHERE o.customer_id IS NOT NULL
);
--8
SELECT p.id,p.name
FROM products p LEFT JOIN order_items oi ON p.id = oi.product_id
WHERE oi.id IS NULL;
--9
SELECT
    m.id AS manager_id,
    m.name AS manager_name,
    COALESCE(SUM(o.amount), 0) AS total_sales
FROM employees m
         LEFT JOIN employees e ON m.id = e.manager_id
         LEFT JOIN orders o ON e.id = o.employee_id
WHERE m.manager_id IS NULL
GROUP BY m.id, m.name;
--10
SELECT COUNT(*) AS total_orders,
COALESCE(SUM(amount), 0) AS total_revenue
FROM orders;
--11
SELECT
    d.id,
    d.name,
    COALESCE(AVG(e.salary), 0) AS avg_salary,
    COALESCE(MAX(e.salary), 0) AS max_salary
FROM departments d
LEFT JOIN employees e ON d.id = e.department_id
GROUP BY d.id, d.name;
--12
SELECT o.id AS order_id,
COALESCE(SUM(oi.quantity), 0) AS total_quantity,
COUNT(DISTINCT oi.product_id) AS unique_products
FROM orders o LEFT JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id;
--13
SELECT p.id, p.name, SUM(p.price * oi.quantity) AS total_revenue
FROM products p JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.id, p.name
ORDER BY total_revenue DESC
LIMIT 3;
--14
SELECT COUNT(DISTINCT customer_id) AS customers_with_orders
FROM orders
WHERE customer_id IS NOT NULL;
--15
SELECT
    d.id,
    d.name,
    COUNT(e.id) AS employee_count,
    COALESCE(AVG(e.salary), 0) AS avg_salary,
    COALESCE(SUM(o.amount), 0) AS total_sales
FROM departments d LEFT JOIN employees e ON d.id = e.department_id
LEFT JOIN orders o ON e.id = o.employee_id
GROUP BY d.id, d.name;
--16
WITH customer_avg AS (
    SELECT
        customer_id,
        AVG(amount) AS avg_order_amount
    FROM orders
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
),
overall_avg AS (
         SELECT AVG(amount) AS overall_avg_amount
         FROM orders
     )
SELECT
    c.id,
    c.name,
    ca.avg_order_amount
FROM customer_avg ca JOIN customers c ON ca.customer_id = c.id
WHERE ca.avg_order_amount > (SELECT overall_avg_amount FROM overall_avg);
--17
SELECT id,name AS full_name
FROM employees;
--18
SELECT
    id,
    TO_CHAR(order_date, 'DD.MM.YYYY HH24:MI') AS formatted_date
FROM orders;
--19
SELECT *
FROM orders
WHERE order_date < CURRENT_DATE - INTERVAL '30 days';
--20
SELECT
    id,
    name,
    COALESCE(salary, 0) AS salary,
    CASE
        WHEN position ILIKE '%manager%' THEN COALESCE(salary, 0) * 1.10
        ELSE COALESCE(salary, 0)
        END AS salary_with_bonus
FROM employees;
