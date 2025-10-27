CREATE TABLE faculties
(
    id   SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE groups
(
    id         SERIAL PRIMARY KEY,
    name       TEXT NOT NULL,
    faculty_id INT  NOT NULL,
    FOREIGN KEY (faculty_id) REFERENCES faculties (id)
);

CREATE TABLE teachers
(
    id   SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE courses
(
    id         SERIAL PRIMARY KEY,
    name       TEXT NOT NULL,
    teacher_id INT  NOT NULL,
    FOREIGN KEY (teacher_id) REFERENCES teachers (id)
);

CREATE TABLE students
(
    id       SERIAL PRIMARY KEY,
    name     TEXT NOT NULL,
    group_id INT  NOT NULL,
    FOREIGN KEY (group_id) REFERENCES groups (id)
);

CREATE TABLE student_courses
(
    student_id      INT,
    course_id       INT,
    grade           INT NOT NULL CHECK (grade BETWEEN 1 AND 5),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students (id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses (id)
);


insert into faculties(name) values ('IT faculty');
insert into groups(name, faculty_id) values ('first group',1);
insert into teachers(name)values ('Shukrullo teacher');
insert into students(name, group_id) values ('Shukrullo student',1);
insert into courses(name, teacher_id) values ('computer',1);
insert into student_courses(student_id, course_id, grade) values (1,1,5);