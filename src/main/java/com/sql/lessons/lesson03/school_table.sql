CREATE TABLE students_school
(
    student_id INT PRIMARY KEY,
    full_name  VARCHAR(100),
    age        INT,
    group_id   INT
);

CREATE TABLE groups
(
    group_id   INT PRIMARY KEY,
    group_name VARCHAR(50)
);

CREATE TABLE subjects
(
    subject_id   INT PRIMARY KEY,
    subject_name VARCHAR(50)
);

CREATE TABLE grades
(
    grade_id   INT PRIMARY KEY,
    student_id INT,
    subject_id INT,
    grade      INT,
    FOREIGN KEY (student_id) REFERENCES students_school (student_id),
    FOREIGN KEY (subject_id) REFERENCES subjects (subject_id)
);


-- Группы
INSERT INTO groups (group_id, group_name)
VALUES (1, 'Java Developers'),
       (2, 'Python Developers'),
       (3, 'Data Analysts');

-- Студенты
INSERT INTO students (student_id, full_name, age, group_id)
VALUES (1, 'Ali Karimov', 20, 1),
       (2, 'Dilshod Rakhimov', 22, 1),
       (3, 'Malika Tursunova', 19, 2),
       (4, 'Azizbek Saidov', 21, 2),
       (5, 'Shahzoda Ergasheva', 23, 3);

-- Предметы
INSERT INTO subjects (subject_id, subject_name)
VALUES (1, 'Database Systems'),
       (2, 'Algorithms'),
       (3, 'Statistics');

-- Оценки
INSERT INTO grades (grade_id, student_id, subject_id, grade)
VALUES (1, 1, 1, 9),
       (2, 1, 2, 8),
       (3, 1, 3, 7),
       (4, 2, 1, 10),
       (5, 2, 2, 9),
       (6, 3, 1, 8),
       (7, 3, 3, 9),
       (8, 4, 1, 7),
       (9, 4, 2, 8),
       (10, 5, 3, 10);


-- 1. Количество студентов
SELECT COUNT(*) AS total_students
FROM students;

-- 2. Средний возраст студентов
SELECT AVG(age) AS average_age
FROM students;

-- 3. Минимальный и максимальный возраст
SELECT MIN(age) AS min_age, MAX(age) AS max_age
FROM students;

-- 4. Всего оценок выставлено
SELECT COUNT(*) AS total_grades
FROM grades;

-- 5. Средний возраст студентов по каждой группе
SELECT group_id, AVG(age) AS average_age
FROM students
GROUP BY group_id
ORDER BY group_id ASC;

-- 6. Средний балл по каждому предмету
SELECT subject_id, AVG(grade) AS average_grade
FROM grades
GROUP BY subject_id
ORDER BY subject_id ASC;

-- 7. Количество студентов, у которых есть оценки по каждому предмету
SELECT COUNT(DISTINCT student_id) AS students_with_all_subjects
FROM grades
GROUP BY student_id
HAVING COUNT(DISTINCT subject_id) = (SELECT COUNT(*) FROM subjects);

-- 8. Группы, где учится больше 1 студента
SELECT group_id, COUNT(*) AS total_students
FROM students
GROUP BY group_id
HAVING COUNT(*) > 1;

-- 9. Предметы, где средний балл выше 8
SELECT subject_id, AVG(grade) AS average_grade
FROM grades
GROUP BY subject_id
HAVING AVG(grade) > 8;

-- 10. Студенты, у которых средний балл выше 8.5
SELECT student_id, AVG(grade) AS average_grade
FROM grades
GROUP BY student_id
HAVING AVG(grade) > 8.5;
