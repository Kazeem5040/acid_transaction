-- ===========================
-- Online Learning Management System (LMS)
-- ===========================

-- Create LMS tables
CREATE TABLE Students (
    student_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL
);

CREATE TABLE Courses (
    course_id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    instructor TEXT NOT NULL
);

CREATE TABLE Enrollments (
    enrollment_id INTEGER PRIMARY KEY,
    student_id INTEGER,
    course_id INTEGER,
    enroll_date TEXT,
    FOREIGN KEY(student_id) REFERENCES Students(student_id),
    FOREIGN KEY(course_id) REFERENCES Courses(course_id)
);

CREATE TABLE Grades (
    grade_id INTEGER PRIMARY KEY,
    enrollment_id INTEGER,
    grade TEXT,
    FOREIGN KEY(enrollment_id) REFERENCES Enrollments(enrollment_id)
);

-- Insert mock data using a transaction
BEGIN TRANSACTION;

INSERT INTO Students (name, email) VALUES 
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com'),
('Charlie', 'charlie@example.com');

INSERT INTO Courses (title, instructor) VALUES
('Math 101', 'Prof. Smith'),
('History 201', 'Dr. Jones'),
('Science 301', 'Dr. Brown');

INSERT INTO Enrollments (student_id, course_id, enroll_date) VALUES
(1, 1, '2025-01-15'),
(1, 2, '2025-01-16'),
(2, 1, '2025-01-17'),
(3, 3, '2025-01-18');

INSERT INTO Grades (enrollment_id, grade) VALUES
(1, 'A'),
(2, 'B'),
(3, 'A'),
(4, 'C');

COMMIT;
-- Transaction ensures all inserts succeed together; if one fails, nothing is added

-- Example Queries

-- 1. List all courses a student is enrolled in
SELECT Students.name, Courses.title
FROM Students
JOIN Enrollments ON Students.student_id = Enrollments.student_id
JOIN Courses ON Courses.course_id = Enrollments.course_id;

-- 2. Find all students with grade 'A'
SELECT Students.name, Courses.title, Grades.grade
FROM Grades
JOIN Enrollments ON Grades.enrollment_id = Enrollments.enrollment_id
JOIN Students ON Enrollments.student_id = Students.student_id
JOIN Courses ON Enrollments.course_id = Courses.course_id
WHERE Grades.grade = 'A';

-- 3. Count number of students in each course
SELECT Courses.title, COUNT(Enrollments.student_id) as num_students
FROM Courses
LEFT JOIN Enrollments ON Courses.course_id = Enrollments.course_id
GROUP BY Courses.title;
