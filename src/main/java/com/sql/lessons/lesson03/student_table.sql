CREATE TABLE students
(
    student_id BIGINT,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    birth_date DATE        NOT NULL,
    email      VARCHAR(100) UNIQUE,
    group_id   INT         NOT NULL
);
INSERT INTO students (first_name, last_name, birth_date, email, group_id) VALUES
    ('Shukrullo', 'Hakimjavon', '2005-03-14', 'shukrullo@example.com', 1),
    ('Maria', 'Smith', '2004-07-21', 'maria.smith@example.com', 1),
    ('John', 'Brown', '2003-11-05', 'john.brown@example.com', 2),
    ('Shukrullo', 'Hakimjavon', '2005-03-14', 'shukrullo1@example.com', 1),
    ('Alex', 'Johnson', '2005-03-14', 'alex.johnson2@example.com', 1), -- дубликат
    ('Emily', 'Davis', '2004-01-29', 'emily.davis@example.com', 3),
    ('Maria', 'Smith', '2004-07-21', 'maria.smith2@example.com', 2); -- дубликат

SELECT first_name, last_name, COUNT(*) AS duplicates_count
FROM students
GROUP BY first_name, last_name
HAVING COUNT(*) > 1;

WITH duplicates AS (
    SELECT
        student_id,
        ROW_NUMBER() OVER (PARTITION BY first_name, last_name ORDER BY student_id) AS rn
    FROM students
)
DELETE FROM students
WHERE student_id IN (
    SELECT student_id FROM duplicates WHERE rn > 1
);


SELECT * FROM students ORDER BY student_id;
