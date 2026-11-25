# CareerBridge – Data Fields, Statuses and Rules (Week 2)

This file lists the minimum data CareerBridge will store, the application statuses, and the basic rules.
Everything here matches the wireframes, the ER diagram and the API plan in this folder.

## 1. Data fields

### Users (Students and Admins share one table; `role` decides access)
| Field | Type | Notes |
|---|---|---|
| user_id | INT, **PK** | Unique id of the user |
| name | VARCHAR | Full name |
| email | VARCHAR, **UNIQUE** | Used to log in; one account per email |
| password_hash | VARCHAR | Password is stored hashed, never as plain text |
| role | `student` / `admin` | Decides what the user can do |
| course | VARCHAR | Student only (e.g. B.Tech CSE) |
| graduation_year | INT | Student only |
| resume_link | VARCHAR | Student only, optional |
| created_at | TIMESTAMP | When the account was created |

> Decision: student profile fields are kept inside **Users** to keep the schema simple (course, graduation_year and resume_link stay empty for admins). A separate StudentProfiles table can be added later if the mentor suggests it.

### Opportunities
| Field | Type | Notes |
|---|---|---|
| opportunity_id | INT, **PK** | Unique id |
| title | VARCHAR | e.g. Web Developer Intern |
| organization | VARCHAR | Company or institute name |
| description | TEXT | What the role is about |
| type | `internship` / `job` | |
| location | VARCHAR | City or Remote |
| eligibility | TEXT | Who can apply |
| deadline | DATE | Last date to apply |
| status | `active` / `inactive` | Inactive opportunities are hidden from students |
| created_by | INT, **FK** → Users.user_id | The admin who created it |
| created_at | TIMESTAMP | |

### Applications
| Field | Type | Notes |
|---|---|---|
| application_id | INT, **PK** | Unique id |
| student_id | INT, **FK** → Users.user_id | Who applied |
| opportunity_id | INT, **FK** → Opportunities.opportunity_id | What they applied to |
| applied_at | TIMESTAMP | Set automatically on submit |
| status | VARCHAR | See statuses below |

**Unique rule:** `UNIQUE (student_id, opportunity_id)` – one student can apply to one opportunity only once.

## 2. Application statuses
| Status | Meaning | Who updates it? |
|---|---|---|
| Submitted | Application was received | System (automatically) |
| Under Review | Admin is reviewing the application | Admin |
| Shortlisted | Student is shortlisted | Admin |
| Rejected | Application was not selected | Admin |
| Selected | Student is selected for the opportunity | Admin |

Flow: **Submitted → Under Review → Shortlisted → Selected** (an admin can also set **Rejected**).

## 3. Basic rules
1. A student can apply only while the opportunity is **active** and **before the deadline**.
2. A student **cannot apply twice** to the same opportunity. The database blocks it with `UNIQUE (student_id, opportunity_id)`, and the API returns a clear "already applied" message.
3. A student can view **only their own** applications (`GET /api/applications/my` filters by the logged-in student).
4. An admin can create, edit and deactivate/delete opportunities and update application statuses.
5. Applications are **not editable after submission** (simpler for the MVP).
6. Passwords are stored as a hash. No passwords, API keys or `.env` files are uploaded to GitHub.
