--lesson05 task related to lesson04
-- 1
SELECT id, name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- 2
SELECT id, name, price
FROM products
WHERE price > (SELECT AVG(price) FROM products);

-- 3
SELECT DISTINCT d.id, d.name
FROM departments d JOIN employees e ON d.id = e.department_id
WHERE e.salary > 10000;

-- 4
SELECT p.id, p.name, COUNT(oi.id) AS order_count
FROM products p JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.id, p.name
ORDER BY order_count DESC
LIMIT 1;

-- 5
SELECT c.id, c.name, COUNT(o.id) AS order_count
FROM customers c LEFT JOIN orders o ON c.id = o.customer_id
GROUP BY c.id, c.name;

-- 6
SELECT d.id, d.name, AVG(e.salary) AS avg_salary
FROM departments d JOIN employees e ON d.id = e.department_id
GROUP BY d.id, d.name
ORDER BY avg_salary DESC
LIMIT 3;

-- 7
SELECT c.id, c.name
FROM customers c LEFT JOIN orders o ON c.id = o.customer_id
WHERE o.id IS NULL;
-- 8
SELECT e.id, e.name, e.salary
FROM employees e
WHERE e.salary > ALL (
    SELECT salary
    FROM employees
    WHERE position ILIKE '%manager%'
      AND salary IS NOT NULL
);

-- 9
SELECT d.id, d.name
FROM departments d
WHERE NOT EXISTS (
    SELECT 1
    FROM employees e
    WHERE e.department_id = d.id
      AND (e.salary IS NULL OR e.salary <= 5000)
);