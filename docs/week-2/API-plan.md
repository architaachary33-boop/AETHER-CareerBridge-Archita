# CareerBridge – REST API Plan (Week 2)

Only the **plan** is written this week. Nothing is implemented yet.

## REST basics
An API is how the frontend asks the backend for data or asks it to do something.

| Method | Meaning | Example in CareerBridge |
|---|---|---|
| GET | Read data | Show the list of opportunities |
| POST | Create something new | Register a user, apply to an opportunity |
| PATCH (or PUT) | Update existing data | Change an application status |
| DELETE | Remove data | Remove an opportunity |

## Endpoint list (MVP)
| # | Method | Endpoint | Purpose | Input | Output | Access |
|---|---|---|---|---|---|---|
| 1 | POST | `/api/auth/register` | Create an account | name, email, password (course and graduation_year for students) | Success message or "email already registered" error | Public |
| 2 | POST | `/api/auth/login` | Log in | email, password | Login token and the user's role, or an error | Public |
| 3 | GET | `/api/opportunities` | Browse, search and filter opportunities | Optional query: `search`, `type`, `location` | List of active opportunities | Public or logged-in |
| 4 | GET | `/api/opportunities/:id` | View one opportunity's details | Opportunity id in the URL | Full details of that opportunity | Public or logged-in |
| 5 | POST | `/api/opportunities` | Create an opportunity | title, organization, description, type, location, eligibility, deadline, status | The newly created opportunity | Admin |
| 6 | PATCH | `/api/opportunities/:id` | Edit or update an opportunity | Id in the URL and the fields to change | The updated opportunity | Admin |
| 7 | DELETE | `/api/opportunities/:id` | Delete or deactivate an opportunity | Id in the URL | Success message | Admin |
| 8 | POST | `/api/applications` | Apply to an opportunity | opportunity_id (the student comes from the login token) | Application with status "Submitted", or an error (deadline passed, inactive, already applied) | Student |
| 9 | GET | `/api/applications/my` | View my own applications | none | List of the student's applications with opportunity and status | Student |
| 10 | PATCH | `/api/applications/:id/status` | Update an application's status | Application id in the URL and the new status | The updated application | Admin |

## Common error cases
| Situation | Message |
|---|---|
| Wrong email or password | "Invalid email or password" |
| Email already used | "Email already registered" |
| Not logged in | "Please log in" |
| Student tries an admin action | "Access denied" |
| Deadline passed or opportunity inactive | "Applications are closed" |
| Applying twice | "You have already applied" |

## How the API matches the wireframes
| Wireframe | API used |
|---|---|
| 1 Login / Register | #1, #2 |
| 2 Student Dashboard | #9 (status counts), #3 (latest opportunities) |
| 3 Opportunity Listing | #3 |
| 4 Opportunity Details | #4, #8 (Apply button) |
| 5 My Applications | #9 |
| 6 Admin Opportunity Management | #3, #7 |
| 7 Admin Create / Edit | #5, #6 |
| Admin updates status | #10 |
