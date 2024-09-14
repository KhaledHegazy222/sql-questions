-- Drop all tables if they exist to reset the schema
DROP TABLE IF EXISTS Enrollments;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS Professor_Department;
DROP TABLE IF EXISTS Professors;
DROP TABLE IF EXISTS Departments;
DROP TABLE IF EXISTS Students;

-- Create Departments table
CREATE TABLE Departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) UNIQUE NOT NULL
);

-- Create Professors table
CREATE TABLE Professors (
    professor_id SERIAL PRIMARY KEY,
    professor_name VARCHAR(100) UNIQUE NOT NULL
);

-- Many-to-Many relationship between Professors and Departments
CREATE TABLE Professor_Department (
    professor_id INT REFERENCES Professors(professor_id) ON DELETE CASCADE,
    department_id INT REFERENCES Departments(department_id) ON DELETE CASCADE,
    PRIMARY KEY (professor_id, department_id)
);

-- Create Courses table
CREATE TABLE Courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100) UNIQUE NOT NULL,
    department_id INT REFERENCES Departments(department_id) ON DELETE SET NULL,
    professor_id INT REFERENCES Professors(professor_id) ON DELETE SET NULL
);

-- Create Students table
CREATE TABLE Students (
    student_id SERIAL PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- Many-to-Many relationship between Students and Courses (Enrollments)
CREATE TABLE Enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES Students(student_id) ON DELETE CASCADE,
    course_id INT REFERENCES Courses(course_id) ON DELETE CASCADE,
    enrollment_date DATE NOT NULL,
    UNIQUE (student_id, course_id)  -- Ensure unique enrollment for each student per course
);

-- Populate Departments table
INSERT INTO Departments (department_name) VALUES ('Computer Science');
INSERT INTO Departments (department_name) VALUES ('Electrical Engineering');
INSERT INTO Departments (department_name) VALUES ('Mathematics');

-- Populate Professors table
INSERT INTO Professors (professor_name) VALUES ('Dr. John Smith');
INSERT INTO Professors (professor_name) VALUES ('Dr. Jane Doe');
INSERT INTO Professors (professor_name) VALUES ('Dr. Alan Turing');

-- Assign Professors to Departments (Many-to-Many relationship)
INSERT INTO Professor_Department (professor_id, department_id) VALUES (1, 1);  -- Dr. John Smith in Computer Science
INSERT INTO Professor_Department (professor_id, department_id) VALUES (2, 2);  -- Dr. Jane Doe in Electrical Engineering
INSERT INTO Professor_Department (professor_id, department_id) VALUES (3, 3);  -- Dr. Alan Turing in Mathematics
INSERT INTO Professor_Department (professor_id, department_id) VALUES (3, 1);  -- Dr. Alan Turing also in Computer Science

-- Populate Courses table
INSERT INTO Courses (course_name, department_id, professor_id) VALUES ('Database Systems', 1, 1);  -- Dr. John Smith teaches Database Systems
INSERT INTO Courses (course_name, department_id, professor_id) VALUES ('Operating Systems', 1, 1);  -- Dr. John Smith teaches Operating Systems
INSERT INTO Courses (course_name, department_id, professor_id) VALUES ('Linear Algebra', 3, 3);  -- Dr. Alan Turing teaches Linear Algebra

-- Populate Students table
INSERT INTO Students (student_name, email) VALUES ('Alice Johnson', 'alice.johnson@example.com');
INSERT INTO Students (student_name, email) VALUES ('Bob Williams', 'bob.williams@example.com');
INSERT INTO Students (student_name, email) VALUES ('Charlie Brown', 'charlie.brown@example.com');

-- Populate Enrollments table (Students enrolling in Courses)
INSERT INTO Enrollments (student_id, course_id, enrollment_date) VALUES (1, 1, '2024-09-01');  -- Alice Johnson in Database Systems
INSERT INTO Enrollments (student_id, course_id, enrollment_date) VALUES (1, 3, '2024-09-02');  -- Alice Johnson in Linear Algebra
INSERT INTO Enrollments (student_id, course_id, enrollment_date) VALUES (2, 2, '2024-09-01');  -- Bob Williams in Operating Systems
INSERT INTO Enrollments (student_id, course_id, enrollment_date) VALUES (3, 3, '2024-09-01');  -- Charlie Brown in Linear Algebra
INSERT INTO Enrollments (student_id, course_id, enrollment_date) VALUES (3, 1, '2024-09-01');  -- Charlie Brown in Database Systems
