# SQL Questions

### 1. Design Database Schema

    Design a database schema for a University Management System to track students, professors, courses, and departments.

    Requirements:
      Departments:
        - Each department has a unique name.
        - Professors and courses belong to departments.

      Professors:
        - Professors have unique names.
        - A professor can work in multiple departments.
        - Each professor teaches one course at a time.

      Courses:
        - Courses have a unique name and belong to one department.
        - Each course is taught by one professor.

      Students:
        - Students have a unique email.
        - Students can enroll in multiple courses, but each enrollment is unique.

      Enrollments:
        - Track when a student enrolls in a course.
        - A student cannot enroll in the same course twice.

      Note:
        - Professors can work in multiple departments.

#### Answer:

<details>
<summary>
Show Answer...
</summary>

```sql
-- Table: Departments
CREATE TABLE Departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE
);

-- Table: Professors
CREATE TABLE Professors (
    professor_id SERIAL PRIMARY KEY,
    professor_name VARCHAR(100) NOT NULL,
    department_id INT,
    UNIQUE(professor_name),  -- Ensure professor names are unique
    FOREIGN KEY (department_id) REFERENCES Departments(department_id) -- Nullable, a professor might not have a department initially
);

-- Table: Students
CREATE TABLE Students (
    student_id SERIAL PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE  -- Unique constraint for emails
);

-- Table: Courses
CREATE TABLE Courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    professor_id INT UNIQUE,  -- One-to-One: Each course can only have one professor, and each professor can teach only one course.
    department_id INT NOT NULL,
    FOREIGN KEY (professor_id) REFERENCES Professors(professor_id),
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

-- Table: Enrollments (Many-to-One from Students to Courses)
CREATE TABLE Enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE NOT NULL,
    UNIQUE(student_id, course_id),  -- Ensure each student can enroll in a course only once
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- Many-to-Many relationship: Professors and Departments (one professor can work in multiple departments)
CREATE TABLE Professor_Departments (
    professor_id INT NOT NULL,
    department_id INT NOT NULL,
    PRIMARY KEY (professor_id, department_id),
    FOREIGN KEY (professor_id) REFERENCES Professors(professor_id),
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

```

</details>

### 2. Inserting data to the tables

#### 1. Insert a new department called "Computer Science".

<details>
<summary>Show Answer...</summary>

```sql
INSERT INTO Departments (department_name)
VALUES ('Computer Science');
```

</details>

#### 2. Insert a professor named "Dr. John Smith" who works in the "Computer Science" department.

<details>
<summary>Show Answer...</summary>

```sql
-- First, find the department_id for "Computer Science"
SELECT department_id FROM Departments WHERE department_name = 'Computer Science';

-- Insert Dr. John Smith into the Professors table with the department_id
INSERT INTO Professors (professor_name, department_id)
VALUES ('Dr. John Smith', 1);  -- Replace 1 with the actual department_id from the previous query
```

</details>

#### 3. Create a course called "Database Systems" taught by Dr. John Smith.

<details>
<summary>Show Answer...</summary>

```sql
-- Find the professor_id for Dr. John Smith
SELECT professor_id FROM Professors WHERE professor_name = 'Dr. John Smith';

-- Insert the course
INSERT INTO Courses (course_name, professor_id, department_id)
VALUES ('Database Systems', 1, 1);  -- Replace 1 with the actual professor_id and department_id
```

</details>

#### 4. Insert a student named "Alice Johnson" with the email alice.johnson@example.com.

<details>
<summary>Show Answer...</summary>

```sql
INSERT INTO Students (student_name, email)
VALUES ('Alice Johnson', 'alice.johnson@example.com');
```

</details>

#### 5. Enroll Alice Johnson in the "Database Systems" course.

<details>
<summary>Show Answer...</summary>

```sql
-- Find the student_id for Alice Johnson
SELECT student_id FROM Students WHERE email = 'alice.johnson@example.com';

-- Find the course_id for "Database Systems"
SELECT course_id FROM Courses WHERE course_name = 'Database Systems';

-- Insert the enrollment record
INSERT INTO Enrollments (student_id, course_id, enrollment_date)
VALUES (1, 1, '2024-09-15');  -- Replace 1 with the actual student_id and course_id, and set the enrollment_date
```

</details>


### 3. Data query questions
> Before answering these questions run the script added __(copy the script and paste in the db server shell)__
#### 1. Retrieve the list of all students.

<details>
<summary>Show Answer...</summary>

```sql
SELECT * FROM Students;
```
</details>

#### 2. Get a list of all students and the courses they are enrolled in, showing the course name and student name

<details>
<summary>Show Answer...</summary>

```sql
SELECT s.student_name, c.course_name
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id;
```
</details>

#### 3. Retrieve a list of all professors, their departments, and the courses they teach.
<details>
<summary>Show Answer...</summary>

```sql
SELECT p.professor_name, d.department_name, c.course_name
FROM Professors p
JOIN Departments d ON p.department_id = d.department_id
JOIN Courses c ON p.professor_id = c.professor_id;
```
</details>

#### 4. Find students who are enrolled in courses named either "Database Systems" or "Operating Systems".

<details>
<summary>Show Answer...</summary>

```sql
SELECT s.student_name, c.course_name
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
WHERE c.course_name IN ('Database Systems', 'Operating Systems');
```
</details>

#### 5. Find enrollments where students enrolled in courses between '2024-01-01' & '2024-12-31'.
<details>
<summary>Show Answer...</summary>

```sql
SELECT s.student_name, c.course_name, e.enrollment_date
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
WHERE e.enrollment_date BETWEEN '2024-01-01' AND '2024-12-31';
```
</details>

#### 6. Update the professor for the course "Database Systems" to a new professor with the name "Dr. Jane Doe".
<details>
<summary>Show Answer...</summary>

```sql
-- First, get the professor_id for Dr. Jane Doe
SELECT professor_id FROM Professors WHERE professor_name = 'Dr. Jane Doe';

-- Update the course to assign the new professor
UPDATE Courses
SET professor_id = 2  -- Replace 2 with the actual professor_id for Dr. Jane Doe
WHERE course_name = 'Database Systems';
```
</details>

#### 7. Find all students who are either enrolled in "Database Systems" or whose email ends with '@example.com'.
<details>
<summary>Show Answer...</summary>

```sql
SELECT s.student_name, s.email, c.course_name
FROM Students s
LEFT JOIN Enrollments e ON s.student_id = e.student_id
LEFT JOIN Courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Database Systems'
   OR s.email LIKE '%@example.com';
```
</details>

#### 8. Count the number of students enrolled in each course.
<details>
<summary>Show Answer...</summary>

```sql
SELECT c.course_name, COUNT(e.student_id) AS student_count
FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;
```
</details>

#### 9. Remove all enrollments for a student named "Alice Johnson".
<details>
<summary>Show Answer...</summary>

```sql
-- First, get the student_id for Alice Johnson
SELECT student_id FROM Students WHERE student_name = 'Alice Johnson';

-- Delete all enrollments for this student
DELETE FROM Enrollments
WHERE student_id = 1;  -- Replace 1 with the actual student_id for Alice Johnson
```
</details>

#### 10. Find the names of students who are enrolled in more than one course.
<details>
<summary>Show Answer...</summary>

```sql
SELECT s.student_name
FROM Students s
WHERE s.student_id IN (
    SELECT e.student_id
    FROM Enrollments e
    GROUP BY e.student_id
    HAVING COUNT(e.course_id) > 1
);
```
</details>
