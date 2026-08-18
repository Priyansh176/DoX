# Product Requirements Document (PRD)
# Hospital / Clinic Token Booking System

**Document Version:** 1.0  
**Status:** MVP Product Specification  
**Primary Platforms:** Doctor Web Dashboard + Patient Mobile App  
**Web:** React  
**Mobile:** Flutter or Kotlin  
**Backend:** Node.js + Express  
**Database:** MySQL / PostgreSQL  
**Real-Time Communication:** Socket.IO (recommended)  
**Authentication:** JWT  
**Reference UI:** Attached Crextio-style dashboard image

---

## 1. Product Overview

The Hospital / Clinic Token Booking System is a lightweight queue-management platform connecting patients with doctors through two simple interfaces:

1. **Doctor Web Dashboard**
   - Doctors log in.
   - See the current patient queue.
   - See the currently serving token.
   - Advance to the next token.
   - Cancel tokens when necessary.
   - See basic queue statistics.

2. **Patient Mobile App**
   - Patients select a clinic/doctor.
   - Enter basic patient details.
   - Book a token.
   - Receive their token number and queue status.
   - See real-time changes to the queue.
   - Know when their token is approaching.

The system should deliberately avoid becoming a full hospital-management system. The MVP is a focused **digital token/queue booking system**, not an EMR, billing platform, pharmacy system, or appointment-management suite.

---

# 2. Product Vision

Create a simple system that replaces physical waiting-line token management with a digital queue.

The core user journey should be:

**Patient → Select Doctor → Enter Details → Book Token → Track Queue → Visit Doctor**

and:

**Doctor → Login → View Queue → Call/Advance Token → Complete Patient → Continue Queue**

The product should feel fast, clean, and obvious enough that a first-time user does not need instructions. Humans have already invented enough software that requires a training session to press three buttons. This should not be one of them.

---

# 3. Goals

## 3.1 Primary Goals

- Allow patients to book a token for a specific doctor.
- Generate unique token numbers for a doctor's queue.
- Display the queue to the doctor in real time.
- Allow doctors to advance the queue.
- Allow doctors to cancel a token.
- Allow patients to see their current queue position.
- Keep the web dashboard and mobile app synchronized through the backend.
- Provide secure doctor authentication.
- Maintain persistent queue/token data in SQL.
- Keep the UI minimal, modern, and responsive.
- Keep the architecture simple enough for a student/project implementation and future deployment.

## 3.2 Secondary Goals

- Show estimated waiting time.
- Show currently serving token.
- Prevent duplicate or invalid bookings.
- Handle multiple doctors independently.
- Support multiple clinics/branches in the future.
- Provide basic audit information for important queue actions.

---

# 4. Non-Goals for MVP

The following should NOT be included in the initial version unless required later:

- Full electronic medical records (EMR/EHR).
- Prescription management.
- Online payments.
- Insurance processing.
- Pharmacy management.
- Laboratory management.
- Medical history management beyond basic booking information.
- Video consultation.
- Complex appointment scheduling.
- Doctor-to-doctor communication.
- AI diagnosis.
- Patient medical records.
- Hospital billing.
- Inventory management.
- Complex analytics dashboards.
- Multi-level hospital administration.

The product should solve one problem properly before attempting to solve healthcare itself.

---

# 5. Target Users

## 5.1 Patient

A person who wants to visit a particular doctor and obtain a digital queue token.

### Patient needs

- Find/select a doctor.
- Understand whether the doctor is available.
- Enter basic information quickly.
- Receive a token.
- Know how many people are ahead.
- Know the currently serving token.
- Know whether their token was cancelled.
- Avoid repeatedly refreshing the application.

---

## 5.2 Doctor

A doctor who manages their own patient queue.

### Doctor needs

- Secure login.
- See today's queue.
- See current token.
- Call/advance the next patient.
- Cancel a token.
- See patient details relevant to the visit.
- Know how many patients are waiting.
- See basic queue status in real time.

---

## 5.3 Admin - Optional / Lightweight

A minimal administrative capability may be added to configure the system.

Possible responsibilities:

- Create doctor accounts.
- Update doctor information.
- Enable/disable doctors.
- Assign doctors to clinics.
- Configure token settings.

The admin interface is not part of the core MVP UI and can initially be implemented through database seed scripts or a minimal protected admin API.

---

# 6. Core User Flows

## 6.1 Patient Booking Flow

1. Open mobile app.
2. View available doctors.
3. Select a doctor.
4. View doctor information:
   - Name
   - Specialty
   - Clinic
   - Availability
   - Queue status
5. Enter patient details:
   - Full name
   - Mobile number
   - Age
   - Gender
6. Tap **Book Token**.
7. Backend validates the request.
8. Backend generates the next token number for that doctor's queue.
9. Booking is saved in SQL database.
10. Patient receives confirmation:
    - Token number
    - Doctor name
    - Current serving token
    - Queue position
    - Estimated waiting time
11. Doctor dashboard receives a real-time queue update.

---

# 7. Doctor Flow

## 7.1 Login

Doctor enters:

- Email / username
- Password

Backend verifies credentials and returns a JWT.

The JWT is used for protected doctor API requests.

---

## 7.2 Dashboard

After login, doctor sees:

### Header

- Doctor name
- Specialty
- Clinic
- Logout
- Optional profile icon

### Main Queue Card

Display prominently:

**Now Serving: Token 12**

Additional information:

- Patient name
- Queue position
- Total waiting patients

Primary action:

**Next Token**

---

## 7.3 Queue List

Example:

| Token | Patient | Status | Booked At | Action |
|---|---|---|---|---|
| 13 | Rahul | Waiting | 10:21 | Cancel |
| 14 | Ananya | Waiting | 10:26 | Cancel |
| 15 | Arjun | Waiting | 10:31 | Cancel |

The current patient should be visually distinct.

---

# 8. Token Lifecycle

A token should move through a simple state machine.

```text
WAITING
   |
   v
SERVING
   |
   v
COMPLETED
```

A waiting token can also become:

```text
WAITING → CANCELLED
```

The recommended statuses are:

- `WAITING`
- `SERVING`
- `COMPLETED`
- `CANCELLED`

Optional future status:

- `NO_SHOW`

---

# 9. "Next Token" Logic

When the doctor presses **Next Token**:

### If a patient is currently serving

1. Current `SERVING` token becomes `COMPLETED`.
2. Earliest `WAITING` token becomes `SERVING`.
3. Queue positions are recalculated.
4. Database transaction commits.
5. Real-time event is emitted.
6. Doctor dashboard updates.
7. Patient apps watching the affected doctor update automatically.

### If nobody is currently serving

The earliest `WAITING` token becomes `SERVING`.

### If no waiting patients exist

The dashboard should display:

**No patients waiting**

The Next Token button should be disabled.

---

# 10. Token Cancellation

A doctor can cancel a waiting token.

Before cancellation:

**Cancel Token**

Optional confirmation:

> Cancel token #15?

After confirmation:

- Token status becomes `CANCELLED`.
- Token disappears from the active queue.
- Queue positions are recalculated.
- A real-time update is sent.
- The affected patient's app shows that their token has been cancelled.

A completed or already-cancelled token should not be cancellable.

---

# 11. Token Numbering

Token numbers should be generated independently for each doctor and queue/day.

Recommended MVP format:

```text
A001
A002
A003
...
```

or simply:

```text
1
2
3
...
```

For a single-clinic MVP, numeric tokens are preferable because they are simpler.

### Recommended rule

Token numbering resets at the beginning of each clinic day.

Example:

**Monday**

1, 2, 3, 4, 5...

**Tuesday**

1, 2, 3, 4, 5...

The database should retain historical tokens even after the daily queue resets.

---

# 12. Patient Mobile App

## 12.1 Technology

Preferred:

- Flutter
- Dart

Alternative:

- Native Android using Kotlin

Flutter is recommended if the objective is to support Android and potentially iOS with one codebase.

---

## 12.2 Mobile Screens

### Screen 1: Home

Minimal interface.

Components:

- App name/logo
- Search/select doctor
- Available doctors
- Basic clinic information

Example:

```text
Good Morning

Choose a doctor

Dr. Sharma
General Physician
12 patients waiting

Dr. Mehta
Dermatologist
5 patients waiting
```

---

### Screen 2: Doctor Details

Display:

- Doctor name
- Specialty
- Clinic
- Availability
- Current token
- Waiting patients

Primary button:

**Book Token**

---

### Screen 3: Patient Details

Fields:

- Full Name
- Mobile Number
- Age
- Gender

Optional:

- Email

Keep the form short.

Do not ask for unnecessary medical information during token booking.

---

### Screen 4: Booking Confirmation

Display:

```text
Token Booked

Your Token
#24

Dr. Sharma

Currently Serving
#18

Patients Ahead
5

Estimated Wait
~30 min
```

Primary action:

**Track Queue**

---

### Screen 5: Live Queue Tracking

Display:

- Token number
- Current serving token
- Patients ahead
- Estimated waiting time
- Doctor name
- Queue status

Example:

```text
Your Token

#24

Now Serving
#20

3 Patients Ahead

Estimated Wait
~18 min

● Live
```

The screen should update automatically.

---

# 13. Patient Identity / Authentication

For the MVP, full patient account registration is not necessary.

Recommended approach:

- Patient enters name + mobile number.
- Backend creates a booking.
- Booking response contains a secure tracking identifier.
- Mobile app stores the tracking identifier locally.
- Patient can reopen the active token from the app.

Optional future implementation:

- OTP login using mobile number.

Do not introduce OTP infrastructure unless it is actually required. It adds operational complexity for almost no MVP value.

---

# 14. Doctor Web Application

## 14.1 Technology

- React
- JavaScript or TypeScript
- React Router
- Axios / Fetch
- Socket.IO Client
- CSS / Tailwind CSS / simple CSS

Recommended:

**React + TypeScript**

This provides better type safety for API responses and queue states without making the application unnecessarily complicated.

---

# 15. Doctor Web Pages

## 15.1 Login Page

Minimal layout:

```text
Clinic Logo

Doctor Login

Email
[________________]

Password
[________________]

[ Login ]
```

---

## 15.2 Dashboard

Primary sections:

### Top Bar

- Doctor name
- Clinic
- Logout

### Queue Summary

```text
Now Serving     Waiting     Completed
     24            8            16
```

### Current Patient

```text
Token #24
Patient: Rahul Sharma

[ Next Token ]
```

### Queue

```text
#25   Ananya   Waiting     [Cancel]
#26   Arjun    Waiting     [Cancel]
#27   Priya    Waiting     [Cancel]
```

---


# 15.3 Doctor Availability Status

When a doctor logs into the web dashboard, the doctor must have a prominent **status toggle** that allows them to control whether they are currently available to receive/manage patients.

The status has two states:

- **ACTIVE** - Doctor is available and the queue is open for token booking.
- **INACTIVE** - Doctor is unavailable and new patients cannot book tokens for that doctor.

### UI Behavior

The status control should be a simple sliding toggle, positioned prominently in the dashboard header.

Example:

```text
Dr. Sharma
General Physician

Availability
[ ● ACTIVE  ]
```

When inactive:

```text
Availability
[ INACTIVE ○ ]
```

The toggle should immediately communicate the current state through:

- Toggle position
- Short text label
- Subtle visual state change

Do not rely on color alone to communicate the state.

### Status Change Flow

When the doctor changes:

```text
INACTIVE → ACTIVE
```

the backend should:

1. Authenticate the doctor.
2. Update the doctor's availability status.
3. Persist the status in SQL.
4. Return the new status to the web application.
5. Emit a real-time availability event.
6. Make the doctor available for new patient token bookings.

When the doctor changes:

```text
ACTIVE → INACTIVE
```

the backend should:

1. Authenticate the doctor.
2. Update the doctor's availability status.
3. Persist the status in SQL.
4. Return the new status to the web application.
5. Emit a real-time availability event.
6. Prevent new patients from booking tokens for that doctor.

### Existing Queue When Doctor Becomes Inactive

Changing the doctor to **INACTIVE must NOT automatically cancel existing tokens**.

Existing tokens should remain in the database.

Recommended behavior:

```text
ACTIVE → INACTIVE

Existing queue:
#21 WAITING
#22 WAITING
#23 SERVING

Result:
Existing tokens remain unchanged.
New bookings are disabled.
```

If the doctor is currently serving a patient, that patient remains in the `SERVING` state.

The doctor can still manage the existing queue after switching to inactive, unless the product later introduces a separate "close queue" function.

### Patient App Behavior

The patient app must reflect the doctor's current availability.

If the doctor is ACTIVE:

```text
Dr. Sharma
General Physician

● Active
8 patients waiting

[ Book Token ]
```

If the doctor is INACTIVE:

```text
Dr. Sharma
General Physician

○ Currently unavailable

[ Booking unavailable ]
```

The patient must not be able to create a new token while the doctor is inactive.

The backend must enforce this rule. Disabling a frontend button alone is not sufficient.

### Real-Time Availability Updates

Availability changes should be communicated using Socket.IO.

Recommended event:

```text
doctor:availability:updated
```

Payload:

```json
{
  "doctorId": 1,
  "status": "ACTIVE",
  "timestamp": "2026-08-18T10:30:00Z"
}
```

The patient application should update the doctor's availability without requiring a manual refresh.

### Status Persistence

The doctor's current availability must be stored in the `doctors` table.

Recommended field:

```text
status ENUM('ACTIVE', 'INACTIVE')
```

Default:

```text
INACTIVE
```

A doctor should explicitly activate themselves when they are ready to accept/manage patients.

### Login Behavior

After successful login:

1. Fetch the doctor's current status.
2. Display the status toggle in the dashboard.
3. Do not automatically change the status merely because the doctor logged in.

This is important because **login and availability are different concepts**.

Example:

```text
Doctor logs in at 8:00 AM
Status: INACTIVE

Doctor arrives at clinic
        ↓
Slides toggle
        ↓
Status: ACTIVE
        ↓
Patients can now book tokens
```

### Logout Behavior

Logging out should NOT necessarily set the doctor to INACTIVE automatically.

The doctor's availability should represent their operational status, not whether a browser session happens to be open.

However, for the MVP, the system may optionally enforce an automatic inactive transition if the product specifically requires session-based availability.

The preferred behavior is:

**Logout ≠ Automatically inactive.**

### Status API

Add:

```http
GET /api/doctors/me/status
Authorization: Bearer <JWT>
```

Response:

```json
{
  "success": true,
  "status": "ACTIVE"
}
```

Update status:

```http
PATCH /api/doctors/me/status
Authorization: Bearer <JWT>
Content-Type: application/json
```

Request:

```json
{
  "status": "ACTIVE"
}
```

Response:

```json
{
  "success": true,
  "status": "ACTIVE"
}
```

Allowed values:

```text
ACTIVE
INACTIVE
```

### Status Authorization

Only the authenticated doctor can modify their own status.

A doctor must not be able to modify another doctor's availability through the API.

### Booking Enforcement

The token creation endpoint must verify:

```text
doctor exists
        ↓
doctor is active
        ↓
doctor can receive booking
```

If the doctor is inactive:

```http
POST /api/tokens
```

must return:

```http
409 Conflict
```

with:

```json
{
  "success": false,
  "message": "Doctor is currently unavailable for new bookings."
}
```

### Dashboard Status Placement

Recommended layout:

```text
┌──────────────────────────────────────────────────────────┐
│ Clinic Logo                  Dr. Sharma   Availability   │
│                                        [ ● ACTIVE ]      │
├──────────────────────────────────────────────────────────┤
│                                                          │
│ Good Morning, Dr. Sharma                                │
│                                                          │
│ ...                                                      │
└──────────────────────────────────────────────────────────┘
```

The status toggle should be visible without opening a settings page.

This is a primary operational control, not a profile preference.

# 16. UI / UX Requirements

The attached image should be treated as a **visual direction**, not something to copy literally.

The desired design language is:

- Minimal
- Soft
- Modern
- Spacious
- Rounded
- Clean typography
- Very limited color usage
- Strong visual hierarchy
- Minimal borders
- Large readable numbers
- Small number of actions
- Soft cards
- Subtle shadows

---

# 17. Color Palette

Based on the reference image, use a restrained palette.

### Primary Dark

```text
#303030
```

Use for:

- Primary buttons
- Active navigation
- Important text
- Current token card

### Soft Yellow

```text
#FDF7E5
```

Use for:

- Background accents
- Highlight areas

### Accent Yellow

Approximate:

```text
#FFD84D
```

Use for:

- Important status
- Token highlights
- Progress indicators
- Primary accent

### Light Gray

```text
#E3E5E6
```

Use for:

- Secondary surfaces
- Borders
- Disabled controls

### Medium Gray

```text
#A4ABB6
```

Use sparingly for:

- Secondary text
- Backgrounds
- Inactive states

### White

```text
#FFFFFF
```

Use for:

- Cards
- Inputs
- Main content areas

The exact colors may be adjusted during implementation to maintain accessibility and contrast.

---

# 18. Typography

Recommended:

- Inter
- Geist
- Manrope

Use one font family consistently.

Recommended hierarchy:

```text
Page title       28–36px
Section title    18–22px
Body             14–16px
Secondary text   12–14px
Token number     40–64px
```

Token numbers should be visually dominant because they are the most important queue information.

---

# 19. Responsive Design

The doctor dashboard should support:

- Desktop
- Laptop
- Tablet

Minimum supported target:

**1280 × 720**

The MVP does not need a complicated mobile version of the doctor dashboard because patients use the mobile application.

---

# 20. Architecture

Recommended architecture:

```text
                    ┌──────────────────────┐
                    │      Patient App     │
                    │   Flutter / Kotlin   │
                    └──────────┬───────────┘
                               │
                         REST API / HTTPS
                               │
                               ▼
                    ┌──────────────────────┐
                    │      Node.js API     │
                    │   Express Backend    │
                    └──────────┬───────────┘
                               │
                    ┌──────────┴───────────┐
                    │                      │
                    ▼                      ▼
             ┌─────────────┐       ┌──────────────┐
             │ SQL Database│       │   Socket.IO  │
             │ MySQL/Postgres      │ Real-time    │
             └─────────────┘       └──────┬───────┘
                                           │
                                      WebSocket
                                           │
                                           ▼
                                ┌──────────────────┐
                                │ Doctor Web App   │
                                │ React            │
                                └──────────────────┘
```

---

# 21. Communication Model

## REST API

REST APIs are responsible for:

- Login
- Fetching doctors
- Fetching queue
- Creating bookings
- Cancelling tokens
- Advancing tokens
- Fetching token status

## Socket.IO

Socket.IO is responsible for real-time queue updates.

This avoids constantly polling the backend.

Example:

```text
Patient books token
       ↓
POST /api/tokens
       ↓
Database updated
       ↓
Server emits "queue:updated"
       ↓
Doctor dashboard receives event
       ↓
Queue updates immediately
```

The patient app can also subscribe to the selected doctor's queue.

---

# 22. Backend Technology

Recommended:

- Node.js
- Express.js
- TypeScript
- MySQL or PostgreSQL
- Prisma / Sequelize / mysql2
- JWT
- bcrypt
- Socket.IO
- Zod / Joi for request validation
- dotenv

A simple stack is preferable.

Recommended MVP:

```text
Node.js
Express
TypeScript
MySQL
Prisma
JWT
bcrypt
Socket.IO
```

---

# 23. Database

MySQL is sufficient for the MVP.

PostgreSQL is also acceptable.

The system does not require a NoSQL database.

A relational database is actually a better fit because:

- Doctors belong to clinics.
- Tokens belong to doctors.
- Tokens belong to patients.
- Token status must be consistent.
- Queue ordering is important.
- Transactions are important when advancing tokens.

---

# 24. Database Schema

## 24.1 clinics

```text
clinics
-------
id              INT / UUID PRIMARY KEY
name            VARCHAR
address         VARCHAR
phone           VARCHAR
is_active       BOOLEAN
created_at      DATETIME
updated_at      DATETIME
```

---

## 24.2 doctors

```text
doctors
-------
id              INT / UUID PRIMARY KEY
clinic_id       FK
name            VARCHAR
email           VARCHAR UNIQUE
password_hash   VARCHAR
specialization  VARCHAR
status          ENUM('ACTIVE', 'INACTIVE')
created_at      DATETIME
updated_at      DATETIME
```

---

## 24.3 patients

```text
patients
--------
id              INT / UUID PRIMARY KEY
name            VARCHAR
phone           VARCHAR
age             INT
gender          VARCHAR
created_at      DATETIME
updated_at      DATETIME
```

A patient can exist without creating a permanent account.

---

## 24.4 tokens

```text
tokens
------
id                  INT / UUID PRIMARY KEY
doctor_id            FK
patient_id           FK
token_number         INT
status               ENUM
booking_date         DATE
booked_at            DATETIME
started_at           DATETIME NULL
completed_at         DATETIME NULL
cancelled_at         DATETIME NULL
created_at           DATETIME
updated_at           DATETIME
```

Recommended unique constraint:

```text
UNIQUE(doctor_id, booking_date, token_number)
```

This ensures two patients cannot accidentally receive the same token.

---

# 25. Token Queue Rules

For a particular doctor and date:

```text
WAITING tokens
    ↓
ordered by token_number ASC
```

The next patient is always the earliest waiting token.

Example:

```text
Current: #10

Waiting:
#11
#12
#13
#14
```

After Next Token:

```text
Completed: #10
Serving:   #11

Waiting:
#12
#13
#14
```

After another Next Token:

```text
Completed: #11
Serving:   #12

Waiting:
#13
#14
```

---

# 26. API Design

Base URL:

```text
/api
```

---

## 26.1 Authentication

### Doctor Login

```http
POST /api/auth/doctor/login
```

Request:

```json
{
  "email": "doctor@example.com",
  "password": "password"
}
```

Response:

```json
{
  "success": true,
  "token": "JWT_TOKEN",
  "doctor": {
    "id": 1,
    "name": "Dr. Sharma",
    "specialization": "General Physician"
  }
}
```

---

# 27. Doctor APIs

## Get Doctor Profile

```http
GET /api/doctors/me
Authorization: Bearer <JWT>
```

---

## Get Today's Queue

```http
GET /api/doctors/me/queue
Authorization: Bearer <JWT>
```

Response:

```json
{
  "doctor": {
    "id": 1,
    "name": "Dr. Sharma"
  },
  "currentToken": {
    "tokenNumber": 24,
    "patientName": "Rahul"
  },
  "waitingCount": 8,
  "queue": [
    {
      "tokenNumber": 25,
      "patientName": "Ananya",
      "status": "WAITING"
    }
  ]
}
```

---

## Advance Queue

```http
POST /api/doctors/me/queue/next
Authorization: Bearer <JWT>
```

Response:

```json
{
  "success": true,
  "completedToken": 24,
  "currentToken": 25
}
```

This operation MUST be transactional.

---

## Cancel Token

```http
PATCH /api/tokens/:tokenId/cancel
Authorization: Bearer <JWT>
```

Response:

```json
{
  "success": true,
  "tokenId": 25,
  "status": "CANCELLED"
}
```

---

# 28. Patient APIs

## Get Clinics

```http
GET /api/clinics
```

---

## Get Doctors

```http
GET /api/doctors?clinicId=1
```

---

## Get Doctor Queue Summary

```http
GET /api/doctors/:doctorId/queue/summary
```

Response:

```json
{
  "doctorId": 1,
  "currentToken": 18,
  "waitingCount": 7,
  "isAvailable": true
}
```

---

## Create Token

```http
POST /api/tokens
```

Request:

```json
{
  "doctorId": 1,
  "patient": {
    "name": "Rahul Sharma",
    "phone": "9876543210",
    "age": 24,
    "gender": "Male"
  }
}
```

Response:

```json
{
  "success": true,
  "token": {
    "id": 125,
    "tokenNumber": 24,
    "status": "WAITING"
  },
  "queue": {
    "currentToken": 18,
    "patientsAhead": 5,
    "estimatedWaitMinutes": 30
  }
}
```

---

## Get Token Status

```http
GET /api/tokens/:tokenId
```

Response:

```json
{
  "tokenNumber": 24,
  "status": "WAITING",
  "currentToken": 20,
  "patientsAhead": 3,
  "estimatedWaitMinutes": 18
}
```

---

# 29. Real-Time Events

Socket.IO namespace:

```text
/queue
```

Clients join a doctor's queue room:

```text
doctor:{doctorId}
```

Example:

```text
doctor:1
```

---

## Event: queue:updated

Payload:

```json
{
  "doctorId": 1,
  "currentToken": 25,
  "waitingCount": 7,
  "timestamp": "2026-08-18T10:30:00Z"
}
```

---

## Event: token:cancelled

Payload:

```json
{
  "doctorId": 1,
  "tokenId": 25,
  "tokenNumber": 25,
  "status": "CANCELLED"
}
```

---

## Event: token:serving

Payload:

```json
{
  "doctorId": 1,
  "tokenNumber": 25,
  "status": "SERVING"
}
```

---

# 30. Real-Time Synchronization Requirements

When a patient books a token:

```text
Mobile App
    ↓
POST /api/tokens
    ↓
Backend
    ↓
SQL
    ↓
Socket.IO event
    ↓
Doctor Dashboard
```

When doctor advances:

```text
Doctor Dashboard
    ↓
POST /api/doctors/me/queue/next
    ↓
Backend
    ↓
SQL transaction
    ↓
Socket.IO event
    ↓
Patient App
```

No manual page refresh should be required.

---

# 31. Estimated Waiting Time

For the MVP, estimated wait can use a simple calculation.

Example:

```text
Average consultation time = 5 minutes
Patients ahead = 4

Estimated wait = 4 × 5
               = 20 minutes
```

The average consultation duration can be configured per doctor later.

Recommended initial default:

```text
5 minutes per patient
```

The estimate is informational only.

The UI should label it:

**Estimated wait**

not:

**Guaranteed wait**

Because apparently patients dislike being promised fictional time estimates.

---

# 32. Queue Position

For a patient's token:

```text
patientsAhead =
number of WAITING tokens
with token_number < current patient's token_number
+
1 if a SERVING token exists and is before the patient
```

The backend should calculate this rather than relying on the client.

---

# 33. Booking Rules

The backend must enforce:

1. Doctor must exist.
2. Doctor must be active.
3. Clinic must be active.
4. Patient name is required.
5. Phone number is required.
6. Age must be valid.
7. Token must be generated server-side.
8. Token numbers must be unique per doctor per date.
9. A patient should not accidentally create unlimited duplicate active tokens.

Recommended duplicate protection:

A patient phone number can have only one active token per doctor per day.

Example:

```text
Phone: 9876543210
Doctor: Dr. Sharma
Date: 18 Aug

Existing active token: #24

New booking:
REJECT
```

Return:

```json
{
  "success": false,
  "message": "You already have an active token for this doctor today."
}
```

---

# 34. Doctor Queue Rules

Only the authenticated doctor should be able to modify their queue.

A doctor must NOT be able to:

- Advance another doctor's queue.
- Cancel another doctor's token.
- Access unrelated patient data.
- Modify token numbers manually.

The backend must enforce authorization rather than trusting the frontend.

---

# 35. Security Requirements

## Authentication

- Passwords must never be stored as plaintext.
- Use bcrypt or Argon2.
- Use JWT for doctor authentication.
- Protect all doctor endpoints.

## Authorization

Every doctor request should verify:

```text
JWT → doctor ID → resource ownership
```

## API Security

Implement:

- Input validation
- Rate limiting
- CORS
- Helmet
- Parameterized SQL queries / ORM
- Centralized error handling
- Environment variables for secrets

---

# 36. Environment Variables

Example:

```env
PORT=5000

DATABASE_URL=mysql://user:password@localhost:3306/clinic_queue

JWT_SECRET=change_this_secret

CLIENT_URL=http://localhost:5173

SOCKET_CORS_ORIGIN=http://localhost:5173
```

Never commit real credentials to Git.

---

# 37. Backend Project Structure

Recommended:

```text
backend/
│
├── src/
│   ├── config/
│   │   ├── database.ts
│   │   └── env.ts
│   │
│   ├── controllers/
│   │   ├── auth.controller.ts
│   │   ├── doctor.controller.ts
│   │   ├── token.controller.ts
│   │   └── clinic.controller.ts
│   │
│   ├── routes/
│   │   ├── auth.routes.ts
│   │   ├── doctor.routes.ts
│   │   ├── token.routes.ts
│   │   └── clinic.routes.ts
│   │
│   ├── middleware/
│   │   ├── auth.middleware.ts
│   │   ├── error.middleware.ts
│   │   └── validation.middleware.ts
│   │
│   ├── services/
│   │   ├── queue.service.ts
│   │   ├── token.service.ts
│   │   └── auth.service.ts
│   │
│   ├── models/
│   │
│   ├── sockets/
│   │   └── queue.socket.ts
│   │
│   ├── utils/
│   │
│   ├── app.ts
│   └── server.ts
│
├── prisma/
│   └── schema.prisma
│
├── .env
├── package.json
└── tsconfig.json
```

---

# 38. React Project Structure

```text
doctor-web/
│
├── src/
│   ├── components/
│   │   ├── Header.tsx
│   │   ├── QueueList.tsx
│   │   ├── QueueItem.tsx
│   │   ├── CurrentToken.tsx
│   │   └── StatCard.tsx
│   │
│   ├── pages/
│   │   ├── Login.tsx
│   │   └── Dashboard.tsx
│   │
│   ├── services/
│   │   ├── api.ts
│   │   └── socket.ts
│   │
│   ├── hooks/
│   │   └── useQueue.ts
│   │
│   ├── types/
│   │   └── queue.ts
│   │
│   ├── context/
│   │   └── AuthContext.tsx
│   │
│   ├── App.tsx
│   └── main.tsx
│
└── package.json
```

---

# 39. Flutter Project Structure

```text
patient_app/
│
├── lib/
│   ├── models/
│   │   ├── doctor.dart
│   │   ├── patient.dart
│   │   └── token.dart
│   │
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── doctor_screen.dart
│   │   ├── patient_details_screen.dart
│   │   ├── booking_confirmation_screen.dart
│   │   └── queue_tracking_screen.dart
│   │
│   ├── services/
│   │   ├── api_service.dart
│   │   └── socket_service.dart
│   │
│   ├── widgets/
│   │   ├── doctor_card.dart
│   │   ├── token_card.dart
│   │   └── queue_status.dart
│   │
│   └── main.dart
│
└── pubspec.yaml
```

---

# 40. Doctor Dashboard Layout

The dashboard should follow the visual hierarchy of the reference image without copying its HR-specific components.

Recommended structure:

```text
┌──────────────────────────────────────────────────────────┐
│ Clinic Logo                         Dr. Sharma     Logout │
├──────────────────────────────────────────────────────────┤
│                                                          │
│ Good Morning, Dr. Sharma                                │
│                                                          │
│ ┌───────────────┐  ┌──────────────┐  ┌───────────────┐ │
│ │ NOW SERVING   │  │ WAITING      │  │ COMPLETED     │ │
│ │               │  │              │  │               │ │
│ │     #24       │  │      8       │  │      16       │ │
│ └───────────────┘  └──────────────┘  └───────────────┘ │
│                                                          │
│ ┌──────────────────────────────────────────────────────┐ │
│ │ Current Patient                                      │ │
│ │                                                      │ │
│ │ Token #24                                            │ │
│ │ Rahul Sharma                                         │ │
│ │                                                      │ │
│ │                  [ NEXT TOKEN ]                      │ │
│ └──────────────────────────────────────────────────────┘ │
│                                                          │
│ Queue                                                    │
│ ┌─────┬────────────────┬───────────┬──────────────────┐ │
│ │ #25 │ Ananya         │ Waiting   │ Cancel           │ │
│ │ #26 │ Arjun          │ Waiting   │ Cancel           │ │
│ │ #27 │ Priya          │ Waiting   │ Cancel           │ │
│ └─────┴────────────────┴───────────┴──────────────────┘ │
└──────────────────────────────────────────────────────────┘
```

---

# 41. Mobile UI Layout

The patient app should be even simpler.

### Home

```text
Clinic Queue

Choose a Doctor

┌────────────────────────────┐
│ Dr. Sharma                 │
│ General Physician          │
│ 8 patients waiting         │
│                            │
│ [ View & Book ]            │
└────────────────────────────┘
```

### Confirmation

```text
Your Token

#24

Dr. Sharma

Now Serving
#20

Patients Ahead
3

Estimated Wait
18 min

● Live
```

---

# 42. Accessibility

The UI should:

- Maintain readable contrast.
- Avoid using color alone to communicate status.
- Use text labels with icons.
- Have sufficiently large buttons.
- Support keyboard navigation on web.
- Provide clear error messages.
- Avoid tiny text.

Example:

Do not show only a yellow dot.

Use:

```text
● Waiting
```

---

# 43. Error Handling

The frontend must handle:

### Network Error

```text
Unable to connect to the server.
Please check your internet connection.
```

### Booking Failure

```text
Unable to book your token.
Please try again.
```

### Duplicate Token

```text
You already have an active token for this doctor today.
```

### Doctor Unavailable

```text
This doctor is currently unavailable.
```

### Session Expired

Doctor web:

```text
Your session has expired.
Please log in again.
```

---

# 44. Loading States

Do not leave blank screens while requests are running.

Use simple skeletons/spinners for:

- Doctor list
- Queue list
- Booking submission
- Login
- Queue refresh

Buttons should become disabled while an action is being processed.

Example:

```text
[ Booking... ]
```

instead of allowing five simultaneous taps.

---

# 45. Empty States

Doctor queue:

```text
No patients waiting

You're all caught up.
```

Patient doctor list:

```text
No doctors available right now.
```

---

# 46. Notifications

## MVP

No push notification system is required.

Real-time in-app updates are sufficient.

## Future

Possible notifications:

- Your token is approaching.
- Your token has been called.
- Doctor is delayed.
- Doctor is unavailable.
- Token cancelled.

Firebase Cloud Messaging can be introduced later.

---

# 47. Clinic / Doctor Availability

Doctor availability is controlled directly from the authenticated doctor's dashboard using the **ACTIVE / INACTIVE** status toggle described in Section 15.3.

The database should store:

```text
status ENUM('ACTIVE', 'INACTIVE')
```

A doctor is bookable when:

```text
doctor.status = 'ACTIVE'
```

A doctor who is `INACTIVE`:

- Remains visible in the patient app if desired.
- Cannot receive new token bookings.
- Retains existing queue tokens.
- Can still manage existing tokens from the dashboard.
- Can switch back to `ACTIVE` at any time.

Future versions can introduce scheduled availability:

```text
Doctor Schedule
Monday: 09:00 - 13:00
Tuesday: 09:00 - 13:00
...
```

For the MVP, the manual status toggle is sufficient and should be the source of truth for whether new bookings are accepted.

---

# 48. Concurrency Requirements

This is one of the most important backend requirements.

Two patients may attempt to book simultaneously.

Example:

```text
Patient A → requests token
Patient B → requests token
```

Both must NOT receive:

```text
Token #25
```

The database must guarantee uniqueness.

Use:

- Database transaction
- Row-level locking where appropriate
- Unique constraint

The token-generation logic should be handled on the backend.

---

# 49. Queue Advancement Concurrency

Two browser requests must not cause:

```text
#25 → SERVING
#26 → SERVING
```

at the same time.

The queue advancement operation should use a database transaction.

Expected result:

```text
#25 → COMPLETED
#26 → SERVING
```

---

# 50. API Response Format

Use a consistent structure.

Success:

```json
{
  "success": true,
  "data": {}
}
```

Failure:

```json
{
  "success": false,
  "message": "Something went wrong"
}
```

Validation error:

```json
{
  "success": false,
  "message": "Validation failed",
  "errors": {
    "phone": "Phone number is required"
  }
}
```

---

# 51. HTTP Status Codes

Recommended:

| Situation | Status |
|---|---:|
| Success | 200 |
| Created | 201 |
| Bad Request | 400 |
| Unauthorized | 401 |
| Forbidden | 403 |
| Not Found | 404 |
| Conflict | 409 |
| Validation Error | 422 |
| Server Error | 500 |

---

# 52. Logging

Backend should log:

- Server startup.
- Database connection.
- Authentication failures.
- Token creation.
- Token cancellation.
- Queue advancement.
- Unexpected errors.

Do NOT log:

- Passwords.
- JWT secrets.
- Sensitive patient information unnecessarily.

---

# 53. Testing Requirements

## Backend Unit Tests

Test:

- Token generation.
- Queue ordering.
- Queue advancement.
- Cancellation.
- Duplicate booking.
- Doctor authorization.
- Token status transitions.

## API Tests

Test:

- Login.
- Doctor queue.
- Patient booking.
- Token status.
- Cancellation.
- Next token.

## Integration Tests

At minimum:

### Scenario 1

Patient books token.

Expected:

```text
Token created
Doctor queue updated
```

### Scenario 2

Doctor advances token.

Expected:

```text
Current token completed
Next token serving
Patient queue updated
```

### Scenario 3

Doctor cancels token.

Expected:

```text
Token cancelled
Queue updated
```

---

# 54. Important Edge Cases

The system must handle:

### No waiting patients

Display:

```text
No patients waiting
```

### Doctor has no active queue

Disable Next Token.

### Patient books while doctor is offline

Either reject booking or allow booking based on configured clinic behavior.

Recommended MVP:

**Allow only when doctor is active/bookable.**

### Patient closes app

Token remains valid because it exists in the database.

### Doctor refreshes browser

Queue should be fetched again from API.

### Socket connection drops

The frontend should:

1. Attempt reconnection.
2. Fetch current queue after reconnecting.

WebSocket events should improve responsiveness, but REST API data must remain the source of truth.

### Token is cancelled while patient is viewing it

Patient should immediately see:

```text
Token Cancelled
```

---

# 55. Source of Truth

The SQL database is the authoritative source.

The frontend must never assume that its local queue state is correct.

Flow:

```text
Database
   ↓
Backend
   ↓
REST / Socket
   ↓
Frontend
```

Not:

```text
Frontend
   ↓
"Probably still correct"
```

Because distributed state already causes enough headaches without us manufacturing more.

---

# 56. Performance Requirements

The system is expected to support the MVP scale of:

- 1–50 clinics
- 1–500 doctors
- 10–500 active patients per doctor/day

These are planning targets, not hard limits.

API target:

- Normal API response: < 500 ms
- Queue update propagation: ideally < 1 second under normal conditions

The architecture should remain simple enough to run on a single backend instance initially.

---

# 57. Deployment Architecture

Initial deployment:

```text
React Web
   ↓
Vercel / Netlify

Flutter App
   ↓
Android APK / Play Store

Node.js API
   ↓
Render / Railway / VPS

MySQL
   ↓
Managed MySQL / VPS
```

Alternative:

```text
Frontend → Vercel
Backend → Railway/Render
Database → Railway/PlanetScale/managed MySQL
```

The exact hosting provider is not part of the product requirement.

---

# 58. Environment Separation

Maintain:

```text
Development
Testing
Production
```

At minimum:

```text
.env.development
.env.production
```

Never use the production database for local development.

---

# 59. MVP Scope

The first usable version should contain ONLY:

## Doctor Web

- [ ] Login
- [ ] ACTIVE / INACTIVE availability toggle
- [ ] Dashboard
- [ ] Current token
- [ ] Waiting queue
- [ ] Next token
- [ ] Cancel token
- [ ] Logout
- [ ] Real-time queue updates

## Patient App

- [ ] Doctor list
- [ ] Doctor details
- [ ] Patient details form
- [ ] Book token
- [ ] Token confirmation
- [ ] Live queue tracking
- [ ] Real-time queue updates

## Backend

- [ ] Doctor authentication
- [ ] Doctor availability status API
- [ ] Booking enforcement based on doctor status
- [ ] Real-time doctor availability events
- [ ] Doctor APIs
- [ ] Clinic/doctor APIs
- [ ] Patient API
- [ ] Token API
- [ ] Queue service
- [ ] SQL database
- [ ] JWT
- [ ] Socket.IO
- [ ] Validation
- [ ] Error handling

---

# 60. Future Features

These should be considered only after the MVP is stable.

## Phase 2

- Patient OTP login.
- Push notifications.
- Doctor schedules.
- Multiple clinics.
- Admin dashboard.
- No-show handling.
- Queue pause/resume.
- Doctor unavailable mode.
- Average consultation time tracking.

## Phase 3

- Appointment booking.
- Patient history.
- Prescriptions.
- Payments.
- Reports.
- Analytics.
- Multiple departments.
- Hospital-wide queue management.

---

# 61. Recommended MVP Development Order

## Phase 1: Database

1. Create database.
2. Create clinics table.
3. Create doctors table.
4. Create patients table.
5. Create tokens table.
6. Add constraints and indexes.
7. Seed sample doctors.

---

## Phase 2: Backend Foundation

1. Initialize Node.js project.
2. Configure TypeScript.
3. Configure Express.
4. Configure SQL connection.
5. Add ORM.
6. Add environment configuration.
7. Add centralized error handling.
8. Add validation.

---

## Phase 3: Authentication

1. Create doctor login.
2. Hash passwords.
3. Generate JWT.
4. Create authentication middleware.
5. Protect doctor endpoints.
6. Test unauthorized access.

---

## Phase 4: Queue APIs

1. Get doctors.
2. Get doctor queue.
3. Create token.
4. Get token.
5. Cancel token.
6. Advance queue.
7. Add transactions.
8. Add duplicate booking protection.

---

## Phase 5: Real-Time Layer

1. Install Socket.IO.
2. Create queue rooms.
3. Join doctor room.
4. Emit token-created event.
5. Emit token-cancelled event.
6. Emit token-serving event.
7. Implement reconnect logic.

---

## Phase 6: React Dashboard

1. Build login.
2. Build dashboard shell.
3. Build queue cards.
4. Build current token.
5. Add Next Token.
6. Add Cancel.
7. Connect REST API.
8. Connect Socket.IO.
9. Add loading/error states.
10. Apply final UI styling.

---

## Phase 7: Mobile App

1. Create Flutter project.
2. Build home screen.
3. Fetch doctors.
4. Build doctor detail.
5. Build patient form.
6. Implement token booking.
7. Build confirmation.
8. Build queue tracking.
9. Connect Socket.IO.
10. Add error/loading states.

---

## Phase 8: Testing

1. API tests.
2. Queue logic tests.
3. Authentication tests.
4. Concurrent booking tests.
5. Concurrent Next Token tests.
6. WebSocket tests.
7. Browser testing.
8. Android testing.
9. End-to-end testing.

---

## Phase 9: Deployment

1. Configure production SQL.
2. Configure production environment variables.
3. Deploy backend.
4. Deploy React dashboard.
5. Build Android application.
6. Configure production API URL.
7. Test real-time connection.
8. Run production smoke tests.

---

# 62. Acceptance Criteria

The MVP is considered complete when all of the following work.

## Doctor

- [ ] Doctor can log in.
- [ ] Doctor can see their current ACTIVE / INACTIVE status.
- [ ] Doctor can switch their status using a sliding toggle.
- [ ] Status changes are persisted in SQL.
- [ ] ACTIVE status allows new token bookings.
- [ ] INACTIVE status prevents new token bookings.
- [ ] Existing tokens are not automatically cancelled when the doctor becomes inactive.
- [ ] Patient app receives doctor availability changes in real time.
- [ ] Doctor can see today's queue.
- [ ] Doctor can see the current serving token.
- [ ] Doctor can advance to the next patient.
- [ ] Doctor can cancel a waiting token.
- [ ] Queue updates without browser refresh.
- [ ] Doctor cannot modify another doctor's queue.
- [ ] Doctor can log out.

## Patient

- [ ] Patient can view doctors.
- [ ] Patient can select a doctor.
- [ ] Patient can enter required details.
- [ ] Patient can book a token.
- [ ] Patient receives a unique token number.
- [ ] Patient can see queue position.
- [ ] Patient can see current serving token.
- [ ] Patient receives live queue updates.
- [ ] Patient sees cancellation if their token is cancelled.

## Backend

- [ ] All data is persisted in SQL.
- [ ] Token numbers are unique per doctor/day.
- [ ] Queue advancement is transactional.
- [ ] Duplicate active bookings are prevented.
- [ ] Doctor routes require JWT.
- [ ] Input validation is implemented.
- [ ] Errors are handled consistently.
- [ ] Socket.IO updates are emitted after queue changes.

---

# 63. Definition of Done

A feature is considered complete only when:

- Backend endpoint is implemented.
- Database operation is implemented.
- Validation exists.
- Authorization exists where required.
- Frontend/mobile integration exists.
- Loading state exists.
- Error state exists.
- Real-time behavior works where applicable.
- The feature has been manually tested.
- Relevant automated tests pass.
- No sensitive credentials are committed.
- UI follows the agreed minimal design system.

---

# 64. Recommended Final Stack

For this specific project, the recommended stack is:

### Doctor Web

```text
React
TypeScript
Vite
React Router
Axios
Socket.IO Client
CSS / Tailwind CSS
```

### Patient Mobile

```text
Flutter
Dart
Dio
Socket.IO Client
```

### Backend

```text
Node.js
Express
TypeScript
Prisma
JWT
bcrypt
Socket.IO
Zod
Helmet
```

### Database

```text
MySQL
```

### Deployment

```text
React → Vercel
Node.js → Render / Railway / VPS
MySQL → Managed MySQL
Flutter → Android APK / Play Store
```

---

# 65. Final Product Architecture

The final MVP should remain intentionally small:

```text
                  PATIENT
                     │
                     │
              Flutter App
                     │
                     │ REST API
                     ▼
          ┌─────────────────────┐
          │                     │
          │   Node.js Backend   │
          │      Express        │
          │                     │
          └───────┬─────┬───────┘
                  │     │
             SQL  │     │ Socket.IO
                  │     │
                  ▼     ▼
             ┌──────────────┐
             │    MySQL     │
             └──────────────┘
                         │
                         │ Real-time
                         ▼
                 React Dashboard
                         │
                       DOCTOR
```

The important architectural principle is:

> **Both applications communicate only through the backend.**

The patient app must never connect directly to the SQL database.

The React dashboard must never connect directly to the SQL database.

The backend owns:

- Authentication
- Authorization
- Token generation
- Queue ordering
- Token lifecycle
- Validation
- Database transactions
- Real-time events

This keeps the system secure, maintainable, and simple.

---

# 66. Product Principle

The system should optimize for one thing:

## **"Get the patient into the doctor's queue with as little friction as possible."**

Every feature should be evaluated against that principle.

If a feature does not improve:

- booking,
- queue visibility,
- queue management,
- reliability,
- security,

it should probably not be in the MVP.

The attached reference image provides the visual inspiration: **soft neutral backgrounds, dark primary elements, warm yellow accents, rounded cards, generous spacing, and minimal information density.** The hospital system should adapt those principles to queue management rather than copying the dashboard structure itself.
