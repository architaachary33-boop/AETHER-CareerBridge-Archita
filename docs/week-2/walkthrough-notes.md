# Week 2 Walkthrough Notes (3–5 minutes)

Use this as a speaking guide. Say it in your own words.

## 1. Introduction (20 sec)
"CareerBridge is a student career portal. An admin publishes opportunities, students find and apply to them, and then track their applications. This week I designed the screens, the database, the statuses and the API plan. No coding yet."

## 2. Student workflow (45 sec)
Register / log in → Dashboard (profile summary and status counts) → Opportunity Listing (search by title or organization, filter by type and location) → Opportunity Details (description, requirements, eligibility, deadline) → Apply → My Applications to track the status.

## 3. Admin workflow (30 sec)
Admin logs in → Manage Opportunities (list, search) → Create or Edit form (title, organization, description, eligibility, deadline, location, type, status) → Edit, Delete or set Inactive → updates application statuses.

## 4. Database and ER diagram (60 sec)
- Three tables: **Users, Opportunities, Applications**.
- They are separate because each stores a different kind of thing, and one student can have many applications. Keeping them apart avoids repeating data.
- **Primary key (PK):** a column that uniquely identifies each row (user_id, opportunity_id, application_id).
- **Foreign key (FK):** a column that points to a PK in another table (student_id, opportunity_id in Applications; created_by in Opportunities).
- Relationships: 1 user → many applications; 1 opportunity → many applications; 1 admin → many opportunities.
- **Stopping duplicates:** `UNIQUE (student_id, opportunity_id)` in the Applications table. The API also returns "You have already applied".

## 5. Statuses and rules (30 sec)
Submitted (system) → Under Review → Shortlisted → Selected or Rejected (admin). Students can apply only while the opportunity is active and before the deadline. Students see only their own applications. Applications are not editable after submission.

## 6. API plan (45 sec)
- **GET** reads (list and details of opportunities, my applications).
- **POST** creates (register, login, create opportunity, apply).
- **PATCH** updates (edit opportunity, change application status).
- **DELETE** removes (delete or deactivate an opportunity).
- 10 endpoints in total, each with an access role: Public, Student or Admin.

## 7. SQL JOIN example (30 sec)
```sql
SELECT u.name, o.title, o.organization, a.status
FROM applications a
JOIN users u         ON a.student_id     = u.user_id
JOIN opportunities o ON a.opportunity_id = o.opportunity_id;
```
"This joins an application to the student who applied and the opportunity they applied to, using the foreign keys."

## 8. Wrap-up (10 sec)
"The wireframes, ER diagram, statuses and API plan all describe the same workflow, so I am ready to start the frontend foundation in Week 3."

## If you don't know an answer
Say: "I haven't covered that yet, but I would look into it." Do not guess.
