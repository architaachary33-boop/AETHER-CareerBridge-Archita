-- ==========================================================
-- CareerBridge - Week 2 SQL Practice
-- Practice file only. Uses small SAMPLE data (not real student data).
-- Concepts: CREATE TABLE, PRIMARY KEY, FOREIGN KEY, UNIQUE,
--           INSERT, SELECT, WHERE, ORDER BY, UPDATE, DELETE, JOIN
-- ==========================================================

-- ----------------------------------------------------------
-- 1. CREATE TABLES  (the ER diagram turned into tables)
-- ----------------------------------------------------------
CREATE TABLE users (
    user_id         INTEGER PRIMARY KEY,
    name            VARCHAR(100) NOT NULL,
    email           VARCHAR(150) NOT NULL UNIQUE,
    password_hash   VARCHAR(255) NOT NULL,
    role            VARCHAR(10)  NOT NULL CHECK (role IN ('student', 'admin')),
    course          VARCHAR(100),
    graduation_year INTEGER,
    resume_link     VARCHAR(255),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE opportunities (
    opportunity_id  INTEGER PRIMARY KEY,
    title           VARCHAR(150) NOT NULL,
    organization    VARCHAR(150) NOT NULL,
    description     TEXT,
    type            VARCHAR(15)  NOT NULL CHECK (type IN ('internship', 'job')),
    location        VARCHAR(100),
    eligibility     TEXT,
    deadline        DATE NOT NULL,
    status          VARCHAR(10)  NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    created_by      INTEGER NOT NULL,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);

CREATE TABLE applications (
    application_id  INTEGER PRIMARY KEY,
    student_id      INTEGER NOT NULL,
    opportunity_id  INTEGER NOT NULL,
    applied_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status          VARCHAR(15) NOT NULL DEFAULT 'Submitted'
                    CHECK (status IN ('Submitted', 'Under Review', 'Shortlisted', 'Rejected', 'Selected')),
    FOREIGN KEY (student_id)     REFERENCES users(user_id),
    FOREIGN KEY (opportunity_id) REFERENCES opportunities(opportunity_id),
    -- One student can apply only once to one opportunity:
    UNIQUE (student_id, opportunity_id)
);

-- ----------------------------------------------------------
-- 2. INSERT  (add sample rows)
-- ----------------------------------------------------------
INSERT INTO users (user_id, name, email, password_hash, role, course, graduation_year) VALUES
(1, 'Admin One',   'admin@test.com',    'hash_demo_1', 'admin',   NULL,        NULL),
(2, 'Student One', 'student1@test.com', 'hash_demo_2', 'student', 'B.Tech CSE', 2027),
(3, 'Student Two', 'student2@test.com', 'hash_demo_3', 'student', 'BCA',        2026),
(4, 'Student Three','student3@test.com','hash_demo_4', 'student', 'B.Tech IT',  2028);

INSERT INTO opportunities (opportunity_id, title, organization, description, type, location, eligibility, deadline, status, created_by) VALUES
(1, 'Web Developer Intern', 'ABC Tech',      'Build web pages with React.',  'internship', 'Remote', 'B.Tech / BCA',  '2026-12-15', 'active',   1),
(2, 'Data Analyst Intern',  'XYZ Analytics', 'Analyse sample datasets.',     'internship', 'Pune',   'Any graduate',  '2026-12-20', 'active',   1),
(3, 'UI/UX Design Intern',  'Creative Labs', 'Design simple app screens.',   'internship', 'Remote', 'Any course',    '2026-11-20', 'inactive', 1),
(4, 'Junior Backend Dev',   'CodeWorks',     'Work on Node.js APIs.',        'job',        'Delhi',  'B.Tech CSE/IT', '2027-01-10', 'active',   1);

INSERT INTO applications (application_id, student_id, opportunity_id, status) VALUES
(1, 2, 1, 'Submitted'),
(2, 2, 2, 'Under Review'),
(3, 3, 1, 'Shortlisted'),
(4, 4, 4, 'Submitted');

-- ----------------------------------------------------------
-- 3. SELECT + WHERE  (filter rows)
-- ----------------------------------------------------------
-- 3a. All active opportunities
SELECT opportunity_id, title, organization, deadline
FROM opportunities
WHERE status = 'active';

-- 3b. Only internships that are active
SELECT title, organization, location
FROM opportunities
WHERE status = 'active' AND type = 'internship';

-- 3c. Search by title (case-insensitive style using LIKE)
SELECT title, organization
FROM opportunities
WHERE title LIKE '%Intern%';

-- ----------------------------------------------------------
-- 4. ORDER BY  (sort rows)
-- ----------------------------------------------------------
-- Active opportunities, nearest deadline first
SELECT title, organization, deadline
FROM opportunities
WHERE status = 'active'
ORDER BY deadline ASC;

-- ----------------------------------------------------------
-- 5. INSERT  (a student applies)
-- ----------------------------------------------------------
INSERT INTO applications (application_id, student_id, opportunity_id)
VALUES (5, 4, 1);

-- The next line would FAIL because student 4 already applied to opportunity 1.
-- The UNIQUE (student_id, opportunity_id) rule blocks duplicate applications.
-- (Uncomment to see the error. Keep it commented when running the whole file.)
-- INSERT INTO applications (application_id, student_id, opportunity_id) VALUES (6, 4, 1);

-- ----------------------------------------------------------
-- 6. UPDATE  (admin changes a status)
-- ----------------------------------------------------------
-- 6a. Application status
UPDATE applications
SET status = 'Under Review'
WHERE application_id = 1;

-- 6b. Deactivate an opportunity (instead of deleting it)
UPDATE opportunities
SET status = 'inactive'
WHERE opportunity_id = 4;

-- ----------------------------------------------------------
-- 7. DELETE  (remove a SAMPLE row only - never project data)
-- ----------------------------------------------------------
-- application 5 was only a practice row, so removing it is safe
DELETE FROM applications
WHERE application_id = 5;

-- ----------------------------------------------------------
-- 8. JOIN  (connect tables using keys)
-- ----------------------------------------------------------
-- 8a. Each application with the opportunity it belongs to
SELECT a.application_id, o.title, o.organization, a.status
FROM applications a
JOIN opportunities o ON a.opportunity_id = o.opportunity_id;

-- 8b. "My Applications" page for student 2 (student name + opportunity + status)
SELECT u.name, o.title, o.organization, a.applied_at, a.status
FROM applications a
JOIN users u         ON a.student_id     = u.user_id
JOIN opportunities o ON a.opportunity_id = o.opportunity_id
WHERE u.user_id = 2
ORDER BY a.applied_at DESC;

-- 8c. Admin view: who applied to opportunity 1
SELECT u.name, u.email, u.course, a.status
FROM applications a
JOIN users u ON a.student_id = u.user_id
WHERE a.opportunity_id = 1;
