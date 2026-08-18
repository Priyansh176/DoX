# Hospital / Clinic Token Booking System
# Development TODO Roadmap

**Based on:** `hospital_clinic_token_booking_prd.md`  
**Version:** 1.0  
**Status:** Development Roadmap  
**Scope:** MVP first, followed by explicitly defined future phases

---

# 0. How to Use This TODO

This file is the implementation roadmap for the product described in the PRD.

## Rules

- [ ] **Database is SQL only: use MySQL as the sole database. Do not introduce MongoDB, Firebase/Firestore, Redis as a primary database, or any other NoSQL database.**
- Work through phases **in order**.
- Do not start a later phase until its required dependencies are complete.
- Do not add features to the MVP that are explicitly listed as non-goals in the PRD.
- Do not introduce patient authentication, OTP, push notifications, appointments, prescriptions, payments, EMR, analytics, or complex scheduling during the MVP.
- The SQL database remains the authoritative source of queue state.
- Both the React dashboard and Flutter/Kotlin patient app communicate **only through the Node.js backend**.
- Real-time synchronization uses Socket.IO, while REST APIs remain the authoritative data-access mechanism.
- Queue-changing operations must be handled safely with database transactions.
- Backend authorization must never depend solely on frontend restrictions.

## Status Legend

- `[ ]` Not started
- `[~]` In progress
- `[x]` Completed
- `[-]` Intentionally deferred / not part of current scope

---

# 1. Project Scope Checklist

## MVP Must Contain

### Doctor Web
- [ ] Doctor login
- [ ] Doctor ACTIVE / INACTIVE availability toggle
- [ ] Doctor dashboard
- [ ] Current serving token
- [ ] Waiting queue
- [ ] Queue statistics
- [ ] Next Token action
- [ ] Cancel Token action
- [ ] Real-time queue updates
- [ ] Doctor logout

### Patient Mobile App
- [ ] Doctor list
- [ ] Doctor availability
- [ ] Doctor details
- [ ] Patient details form
- [ ] Token booking
- [ ] Booking confirmation
- [ ] Live queue tracking
- [ ] Real-time queue updates
- [ ] Token cancellation visibility

### Backend
- [ ] Node.js + Express API
- [ ] TypeScript
- [ ] SQL database
- [ ] Doctor authentication
- [ ] JWT authorization
- [ ] Password hashing
- [ ] Clinic APIs
- [ ] Doctor APIs
- [ ] Patient APIs
- [ ] Token APIs
- [ ] Queue service
- [ ] Doctor availability status API
- [ ] Socket.IO
- [ ] Request validation
- [ ] Centralized error handling
- [ ] Transaction-safe token generation
- [ ] Transaction-safe queue advancement
- [ ] Duplicate active-token protection

---

# PHASE 0 - Requirements Lock and Project Setup

**Goal:** Freeze the MVP requirements and create the project foundation before writing business logic.

**Dependencies:** None

---

## 0.1 Lock the MVP Scope

- [ ] Confirm that the MVP contains only:
  - [ ] Doctor web dashboard
  - [ ] Patient mobile app
  - [ ] Node.js backend
  - [ ] SQL database
  - [ ] JWT doctor authentication
  - [ ] Socket.IO real-time communication
  - [ ] Token queue management
  - [ ] Doctor ACTIVE / INACTIVE status
- [ ] Explicitly defer:
  - [-] Full EMR/EHR
  - [-] Prescriptions
  - [-] Billing
  - [-] Payments
  - [-] Insurance
  - [-] Pharmacy
  - [-] Laboratory management
  - [-] Video consultation
  - [-] Complex appointment scheduling
  - [-] Patient medical records
  - [-] AI diagnosis
  - [-] Complex analytics
  - [-] Push notifications
  - [-] OTP authentication
  - [-] Doctor scheduling
  - [-] Patient accounts

---

## 0.2 Create Repository Structure

- [ ] Create Git repository.
- [ ] Create root project directory.
- [ ] Create backend directory.
- [ ] Create doctor web directory.
- [ ] Create patient mobile directory.
- [ ] Add root README.
- [ ] Add `.gitignore`.
- [ ] Add environment-variable documentation.
- [ ] Create separate development and production configuration strategy.

Recommended structure:

```text
hospital-token-system/
│
├── backend/
├── doctor-web/
├── patient-app/
├── docs/
├── README.md
└── .gitignore
```

---

## 0.3 Establish Git Workflow

- [ ] Create `main` branch.
- [ ] Create development branch if required.
- [ ] Use feature branches for major modules.
- [ ] Use meaningful commit messages.
- [ ] Do not commit `.env`.
- [ ] Do not commit database passwords.
- [ ] Do not commit JWT secrets.
- [ ] Do not commit build artifacts.

---

## 0.4 Establish Development Environment

- [ ] Install Node.js.
- [ ] Install npm.
- [ ] Install MySQL only.
- [ ] Install Flutter SDK if Flutter is selected.
- [ ] Install Android Studio / Android SDK if Flutter Android development is selected.
- [ ] Install a modern browser.
- [ ] Install Git.
- [ ] Verify all tools.
- [ ] Document required versions.

---

# PHASE 1 - Backend Foundation

**Goal:** Build a clean Node.js + Express + TypeScript backend foundation.

**Dependencies:** Phase 0

---

## 1.1 Initialize Backend

- [ ] Initialize Node.js project.
- [ ] Configure TypeScript.
- [ ] Configure `tsconfig.json`.
- [ ] Add development script.
- [ ] Add production build script.
- [ ] Add linting.
- [ ] Add formatting.
- [ ] Add environment configuration.

---

## 1.2 Install Core Backend Dependencies

- [ ] Express.
- [ ] TypeScript.
- [ ] Prisma.
- [ ] MySQL driver / Prisma MySQL support.
- [ ] JSON Web Token library.
- [ ] bcrypt.
- [ ] Socket.IO.
- [ ] Zod or equivalent validation library.
- [ ] Helmet.
- [ ] CORS.
- [ ] dotenv.
- [ ] Testing framework.

Recommended stack:

```text
Node.js
Express
TypeScript
Prisma
MySQL
JWT
bcrypt
Socket.IO
Zod
Helmet
```

---

## 1.3 Create Backend Structure

Create:

```text
backend/
└── src/
    ├── config/
    ├── controllers/
    ├── middleware/
    ├── models/
    ├── routes/
    ├── services/
    ├── sockets/
    ├── utils/
    ├── app.ts
    └── server.ts
```

- [ ] Create `config/`.
- [ ] Create `controllers/`.
- [ ] Create `middleware/`.
- [ ] Create `models/`.
- [ ] Create `routes/`.
- [ ] Create `services/`.
- [ ] Create `sockets/`.
- [ ] Create `utils/`.
- [ ] Create `app.ts`.
- [ ] Create `server.ts`.

---

## 1.4 Express Configuration

- [ ] Initialize Express.
- [ ] Enable JSON parsing.
- [ ] Configure CORS.
- [ ] Add Helmet.
- [ ] Add request logging.
- [ ] Add `/health` endpoint.
- [ ] Add centralized error middleware.
- [ ] Add 404 handler.
- [ ] Verify server startup.

---

## 1.5 Environment Configuration

Create:

```env
PORT=
DATABASE_URL=
JWT_SECRET=
CLIENT_URL=
SOCKET_CORS_ORIGIN=
```

- [ ] Validate required environment variables at startup.
- [ ] Prevent application startup when required secrets are missing.
- [ ] Create `.env.example`.
- [ ] Ensure real `.env` is ignored by Git.

---

# PHASE 2 - Database Design and Prisma Setup

**Goal:** Build the SQL data model exactly around the PRD.

**Dependencies:** Phase 1

---

## 2.1 Configure MySQL SQL Database

- [ ] Create a MySQL development database.
- [ ] Configure Prisma to use MySQL only.
- [ ] Connect Prisma to MySQL.
- [ ] Verify database connection.
- [ ] Create migration workflow.

---

## 2.2 Create `clinics` Table

Fields:

```text
id
name
address
phone
is_active
created_at
updated_at
```

- [ ] Define primary key.
- [ ] Define `name`.
- [ ] Define `address`.
- [ ] Define `phone`.
- [ ] Define `is_active`.
- [ ] Define timestamps.
- [ ] Add appropriate indexes.

---

## 2.3 Create `doctors` Table

Fields:

```text
id
clinic_id
name
email
password_hash
specialization
status
created_at
updated_at
```

Status must be:

```text
ACTIVE
INACTIVE
```

- [ ] Define primary key.
- [ ] Define clinic foreign key.
- [ ] Define unique email.
- [ ] Define password hash.
- [ ] Define specialization.
- [ ] Define doctor status.
- [ ] Default doctor status to `INACTIVE`.
- [ ] Define timestamps.
- [ ] Add indexes.

Important:

- [ ] Do NOT use login state as availability state.
- [ ] Do NOT automatically set the doctor to ACTIVE on login.
- [ ] Do NOT automatically set the doctor to INACTIVE on logout.

---

## 2.4 Create `patients` Table

Fields:

```text
id
name
phone
age
gender
created_at
updated_at
```

- [ ] Define primary key.
- [ ] Define required name.
- [ ] Define required phone.
- [ ] Define age.
- [ ] Define gender.
- [ ] Define timestamps.

The MVP does not require permanent patient authentication.

---

## 2.5 Create `tokens` Table

Fields:

```text
id
doctor_id
patient_id
token_number
status
booking_date
booked_at
started_at
completed_at
cancelled_at
created_at
updated_at
```

Status values:

```text
WAITING
SERVING
COMPLETED
CANCELLED
```

- [ ] Define token primary key.
- [ ] Define doctor foreign key.
- [ ] Define patient foreign key.
- [ ] Define token number.
- [ ] Define token status.
- [ ] Define booking date.
- [ ] Define timestamps.
- [ ] Add appropriate indexes.
- [ ] Add unique constraint:

```text
UNIQUE(doctor_id, booking_date, token_number)
```

---

## 2.6 Define Relationships

- [ ] Clinic → Doctors.
- [ ] Doctor → Tokens.
- [ ] Patient → Tokens.
- [ ] Doctor → current queue.
- [ ] Doctor → availability status.

---

## 2.7 Create Migrations

- [ ] Generate initial migration.
- [ ] Apply migration.
- [ ] Verify tables.
- [ ] Verify foreign keys.
- [ ] Verify unique constraints.
- [ ] Verify indexes.

---

## 2.8 Seed Development Data

Create sample:

- [ ] One clinic.
- [ ] Multiple doctors.
- [ ] Hashed doctor passwords.
- [ ] Active and inactive sample doctors.
- [ ] Optional sample patients.
- [ ] Optional sample tokens.

Do not seed production credentials.

---

# PHASE 3 - Backend Authentication and Authorization

**Goal:** Secure doctor-only functionality.

**Dependencies:** Phase 2

---

## 3.1 Doctor Login

Implement:

```http
POST /api/auth/doctor/login
```

- [ ] Validate email.
- [ ] Validate password.
- [ ] Find doctor.
- [ ] Compare password with bcrypt.
- [ ] Reject invalid credentials.
- [ ] Generate JWT.
- [ ] Return doctor information.
- [ ] Return JWT.

---

## 3.2 JWT Middleware

- [ ] Extract Bearer token.
- [ ] Validate JWT.
- [ ] Extract doctor ID.
- [ ] Reject missing token.
- [ ] Reject invalid token.
- [ ] Reject expired token.
- [ ] Attach authenticated doctor to request.

---

## 3.3 Authorization

- [ ] Ensure authenticated doctor can access own profile.
- [ ] Ensure doctor can access own queue only.
- [ ] Ensure doctor can cancel own tokens only.
- [ ] Ensure doctor can advance own queue only.
- [ ] Ensure doctor can modify own availability only.
- [ ] Prevent cross-doctor queue manipulation.

---

## 3.4 Password Security

- [ ] Hash passwords with bcrypt.
- [ ] Never store plaintext passwords.
- [ ] Never return password hashes through API.
- [ ] Never log passwords.

---

# PHASE 4 - Clinic and Doctor APIs

**Goal:** Provide the basic doctor information required by the patient app.

**Dependencies:** Phase 3

---

## 4.1 Clinics API

Implement:

```http
GET /api/clinics
```

- [ ] Return active clinics.
- [ ] Validate query parameters if added.
- [ ] Return consistent response structure.

---

## 4.2 Doctors API

Implement:

```http
GET /api/doctors?clinicId=1
```

- [ ] Return available doctors.
- [ ] Include:
  - [ ] Doctor ID
  - [ ] Name
  - [ ] Specialization
  - [ ] Clinic
  - [ ] Availability status
  - [ ] Queue summary
- [ ] Do not expose password information.

---

## 4.3 Doctor Profile

Implement:

```http
GET /api/doctors/me
```

- [ ] Require JWT.
- [ ] Return authenticated doctor's profile.
- [ ] Return current availability status.

---

# PHASE 5 - Doctor ACTIVE / INACTIVE Availability System

**Goal:** Implement the explicit doctor availability control from the PRD.

**Dependencies:** Phase 4

---

## 5.1 Status Model

Allowed values:

```text
ACTIVE
INACTIVE
```

- [ ] Confirm database default is `INACTIVE`.
- [ ] Confirm login does not change status.
- [ ] Confirm logout does not change status.

---

## 5.2 Get Status API

Implement:

```http
GET /api/doctors/me/status
Authorization: Bearer <JWT>
```

- [ ] Authenticate doctor.
- [ ] Return current status.

Expected:

```json
{
  "success": true,
  "status": "ACTIVE"
}
```

---

## 5.3 Update Status API

Implement:

```http
PATCH /api/doctors/me/status
Authorization: Bearer <JWT>
```

Request:

```json
{
  "status": "ACTIVE"
}
```

- [ ] Validate status.
- [ ] Authenticate doctor.
- [ ] Update only authenticated doctor.
- [ ] Persist status.
- [ ] Return updated status.

---

## 5.4 Booking Enforcement

Before creating a token:

- [ ] Verify doctor exists.
- [ ] Verify doctor is active.
- [ ] Reject booking if doctor is inactive.
- [ ] Return HTTP `409 Conflict`.
- [ ] Return clear error message.

Expected error:

```json
{
  "success": false,
  "message": "Doctor is currently unavailable for new bookings."
}
```

---

## 5.5 Existing Queue Behavior

When doctor becomes INACTIVE:

- [ ] Do not cancel existing waiting tokens.
- [ ] Do not cancel serving token.
- [ ] Keep existing tokens in database.
- [ ] Allow doctor to continue managing existing queue.
- [ ] Prevent only new bookings.

---

## 5.6 Socket.IO Availability Event

Implement:

```text
doctor:availability:updated
```

Payload:

```json
{
  "doctorId": 1,
  "status": "ACTIVE",
  "timestamp": "..."
}
```

- [ ] Emit event after successful status change.
- [ ] Emit only after database update succeeds.
- [ ] Ensure patient clients can receive the event.

---

# PHASE 6 - Token Generation and Booking Backend

**Goal:** Implement the complete patient token booking flow.

**Dependencies:** Phase 5

---

## 6.1 Get Doctor Queue Summary

Implement:

```http
GET /api/doctors/:doctorId/queue/summary
```

Return:

- [ ] Current serving token.
- [ ] Waiting count.
- [ ] Doctor availability.
- [ ] Doctor ID.
- [ ] Bookability status.

---

## 6.2 Token Creation API

Implement:

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

---

## 6.3 Validate Booking Request

Validate:

- [ ] Doctor ID.
- [ ] Patient name.
- [ ] Patient phone.
- [ ] Patient age.
- [ ] Patient gender.
- [ ] Doctor availability.
- [ ] Clinic availability.

---

## 6.4 Generate Token Number

- [ ] Determine today's booking date.
- [ ] Find latest token number for doctor/date.
- [ ] Generate next number server-side.
- [ ] Never trust a client-supplied token number.
- [ ] Protect against concurrent booking requests.
- [ ] Use database transaction/locking as appropriate.
- [ ] Enforce unique database constraint.

---

## 6.5 Duplicate Active Token Protection

For the same:

```text
patient phone
+
doctor
+
booking date
```

- [ ] Search for active token.
- [ ] Treat `WAITING` as active.
- [ ] Treat `SERVING` as active.
- [ ] Reject duplicate booking.
- [ ] Allow booking again after token is completed/cancelled according to the daily rule.

Return:

```text
You already have an active token for this doctor today.
```

---

## 6.6 Token Creation Response

Return:

- [ ] Token ID.
- [ ] Token number.
- [ ] Token status.
- [ ] Current serving token.
- [ ] Patients ahead.
- [ ] Estimated waiting time.

---

# PHASE 7 - Queue Service and Token Lifecycle

**Goal:** Centralize all queue logic in a backend service.

**Dependencies:** Phase 6

---

## 7.1 Implement Queue Service

Create:

```text
queue.service.ts
```

Responsibilities:

- [ ] Get today's queue.
- [ ] Get current serving token.
- [ ] Get waiting tokens.
- [ ] Calculate waiting count.
- [ ] Calculate patients ahead.
- [ ] Calculate estimated wait.
- [ ] Advance queue.
- [ ] Cancel token.

---

## 7.2 Implement Token State Machine

Valid states:

```text
WAITING
SERVING
COMPLETED
CANCELLED
```

Valid transitions:

```text
WAITING → SERVING
SERVING → COMPLETED
WAITING → CANCELLED
```

- [ ] Prevent invalid transitions.
- [ ] Prevent cancelled token from becoming serving.
- [ ] Prevent completed token from becoming serving.
- [ ] Prevent completed token from being cancelled.

---

## 7.3 Queue Ordering

- [ ] Sort active waiting tokens by token number ascending.
- [ ] Select earliest waiting token.
- [ ] Do not allow frontend to choose arbitrary next token.
- [ ] Calculate queue state on backend.

---

## 7.4 Patients Ahead

Implement backend calculation for:

```text
patientsAhead
```

- [ ] Count active queue entries ahead of patient's token.
- [ ] Ensure current serving state is handled correctly.
- [ ] Recalculate after cancellation.
- [ ] Recalculate after queue advancement.

---

## 7.5 Estimated Waiting Time

Default:

```text
5 minutes / patient
```

Implement:

```text
estimatedWaitMinutes =
patientsAhead × 5
```

- [ ] Keep estimate informational.
- [ ] Label UI as "Estimated wait".
- [ ] Do not present estimate as guaranteed.

---

# PHASE 8 - Next Token / Queue Advancement

**Goal:** Implement the doctor's main queue-control operation safely.

**Dependencies:** Phase 7

---

## 8.1 Next Token API

Implement:

```http
POST /api/doctors/me/queue/next
Authorization: Bearer <JWT>
```

---

## 8.2 Queue Advancement Transaction

When current token exists:

```text
SERVING → COMPLETED
WAITING → SERVING
```

- [ ] Start database transaction.
- [ ] Identify current serving token.
- [ ] Identify earliest waiting token.
- [ ] Complete current token.
- [ ] Set next token to serving.
- [ ] Update timestamps.
- [ ] Commit transaction.
- [ ] Roll back on failure.

---

## 8.3 No Current Serving Token

If no token is serving:

- [ ] Select earliest waiting token.
- [ ] Change it to `SERVING`.
- [ ] Return new current token.

---

## 8.4 Empty Queue

If no waiting tokens exist:

- [ ] Do not modify database.
- [ ] Return clear response.
- [ ] Allow frontend to disable Next Token.

Expected:

```text
No patients waiting
```

---

## 8.5 Concurrent Next Token Requests

Test:

```text
Request A → Next Token
Request B → Next Token
```

- [ ] Ensure two requests cannot serve the same token.
- [ ] Ensure queue state remains valid.
- [ ] Ensure transaction/locking prevents race conditions.

---

# PHASE 9 - Token Cancellation

**Goal:** Allow doctors to cancel waiting tokens.

**Dependencies:** Phase 7

---

## 9.1 Cancel API

Implement:

```http
PATCH /api/tokens/:tokenId/cancel
Authorization: Bearer <JWT>
```

- [ ] Authenticate doctor.
- [ ] Verify token belongs to authenticated doctor's queue.
- [ ] Verify token is `WAITING`.
- [ ] Change status to `CANCELLED`.
- [ ] Set cancellation timestamp.
- [ ] Return updated token.

---

## 9.2 Cancellation Rules

- [ ] Allow waiting token cancellation.
- [ ] Reject serving token cancellation.
- [ ] Reject completed token cancellation.
- [ ] Reject already-cancelled token cancellation.
- [ ] Recalculate queue information.

---

# PHASE 10 - Socket.IO Real-Time Backend

**Goal:** Make queue and availability changes visible without refresh.

**Dependencies:** Phases 5, 8, 9

---

## 10.1 Socket.IO Setup

- [ ] Initialize Socket.IO server.
- [ ] Configure CORS.
- [ ] Create `/queue` namespace if used.
- [ ] Create doctor-specific queue rooms.

Room format:

```text
doctor:{doctorId}
```

---

## 10.2 Client Room Joining

- [ ] Validate doctor ID.
- [ ] Join selected doctor's room.
- [ ] Handle disconnect.
- [ ] Handle reconnect.

---

## 10.3 Queue Events

Implement:

```text
queue:updated
```

- [ ] Emit after token creation.
- [ ] Emit after queue advancement.
- [ ] Emit after token cancellation.

---

## 10.4 Token Events

Implement:

```text
token:cancelled
token:serving
```

- [ ] Emit cancellation event.
- [ ] Emit serving event.
- [ ] Include doctor ID.
- [ ] Include token ID/number where appropriate.

---

## 10.5 Availability Events

Implement:

```text
doctor:availability:updated
```

- [ ] Emit after ACTIVE/INACTIVE change.
- [ ] Include doctor ID.
- [ ] Include new status.
- [ ] Include timestamp.

---

## 10.6 Real-Time Reliability

- [ ] Add reconnect behavior.
- [ ] After reconnect, client should fetch current state via REST.
- [ ] Do not treat Socket.IO event history as the database.
- [ ] SQL remains the source of truth.

---

# PHASE 11 - Doctor React Web Application Foundation

**Goal:** Build the web application shell.

**Dependencies:** Backend authentication and core APIs

---

## 11.1 Initialize React App

Recommended:

```text
React
TypeScript
Vite
```

- [ ] Create project.
- [ ] Configure TypeScript.
- [ ] Configure routing.
- [ ] Configure API client.
- [ ] Configure Socket.IO client.
- [ ] Configure styling.

---

## 11.2 Create React Structure

```text
src/
├── components/
├── pages/
├── services/
├── hooks/
├── types/
├── context/
├── App.tsx
└── main.tsx
```

- [ ] Create components directory.
- [ ] Create pages directory.
- [ ] Create services directory.
- [ ] Create hooks directory.
- [ ] Create types directory.
- [ ] Create auth context.

---

## 11.3 API Service

Create:

```text
services/api.ts
```

- [ ] Configure backend base URL.
- [ ] Configure authentication header.
- [ ] Implement common API error handling.
- [ ] Implement login request.
- [ ] Implement doctor profile request.
- [ ] Implement queue request.
- [ ] Implement next-token request.
- [ ] Implement cancel-token request.
- [ ] Implement status request.

---

## 11.4 Socket Service

Create:

```text
services/socket.ts
```

- [ ] Configure Socket.IO backend URL.
- [ ] Connect to queue namespace.
- [ ] Join doctor room.
- [ ] Listen for queue updates.
- [ ] Listen for availability updates.
- [ ] Handle reconnect.
- [ ] Disconnect cleanly.

---

# PHASE 12 - Doctor Login UI

**Goal:** Build secure, minimal doctor login.

**Dependencies:** Phase 11

---

## 12.1 Login Page

Build:

- [ ] Clinic logo/name.
- [ ] Email input.
- [ ] Password input.
- [ ] Login button.
- [ ] Loading state.
- [ ] Validation messages.
- [ ] Authentication error state.

---

## 12.2 Authentication State

- [ ] Store JWT securely according to application architecture.
- [ ] Store authenticated doctor information.
- [ ] Redirect authenticated doctor to dashboard.
- [ ] Redirect unauthenticated users to login.
- [ ] Handle expired JWT.
- [ ] Clear authentication state on logout.

---

# PHASE 13 - Doctor Dashboard UI

**Goal:** Build the primary doctor experience.

**Dependencies:** Phase 12

---

## 13.1 Dashboard Header

Build:

- [ ] Clinic branding.
- [ ] Doctor name.
- [ ] Specialization.
- [ ] Availability status.
- [ ] Logout control.

---

## 13.2 ACTIVE / INACTIVE Toggle

Build a prominent sliding control:

```text
Availability
[ ● ACTIVE ]
```

or:

```text
Availability
[ INACTIVE ○ ]
```

- [ ] Fetch current status on dashboard load.
- [ ] Display correct state.
- [ ] Allow doctor to slide status.
- [ ] Disable control while API request is running.
- [ ] Update UI after successful response.
- [ ] Revert UI if request fails.
- [ ] Display clear status label.
- [ ] Do not rely only on color.
- [ ] Do not automatically change status on login.

---

## 13.3 Queue Summary Cards

Build:

```text
Now Serving
Waiting
Completed
```

- [ ] Show current serving token.
- [ ] Show waiting count.
- [ ] Show completed count.
- [ ] Update in real time.

---

## 13.4 Current Patient Card

Display:

- [ ] Token number.
- [ ] Patient name.
- [ ] Current status.
- [ ] Next Token button.

Token number should be visually prominent.

---

## 13.5 Next Token Button

- [ ] Disable while request is running.
- [ ] Disable when no waiting patients.
- [ ] Call backend endpoint.
- [ ] Refresh/update queue state.
- [ ] Handle errors.
- [ ] Update via Socket.IO.

---

## 13.6 Queue List

Display:

- [ ] Token number.
- [ ] Patient name.
- [ ] Status.
- [ ] Booking time.
- [ ] Cancel action.

---

## 13.7 Cancel Confirmation

- [ ] Add confirmation UI.
- [ ] Clearly identify token being cancelled.
- [ ] Prevent accidental cancellation.
- [ ] Call cancel API.
- [ ] Update queue after success.

---

## 13.8 Empty Queue State

Display:

```text
No patients waiting

You're all caught up.
```

- [ ] Disable Next Token.
- [ ] Keep dashboard visually clean.

---

# PHASE 14 - Doctor Web Real-Time Integration

**Goal:** Ensure the doctor's dashboard updates automatically.

**Dependencies:** Phases 10 and 13

---

## 14.1 Patient Booking Update

When patient books:

- [ ] Receive `queue:updated`.
- [ ] Update waiting count.
- [ ] Add new token to queue.
- [ ] Update queue statistics.

---

## 14.2 Next Token Update

When doctor advances:

- [ ] Current token becomes completed.
- [ ] Next token becomes serving.
- [ ] Queue list updates.
- [ ] Statistics update.

---

## 14.3 Cancellation Update

When token is cancelled:

- [ ] Remove or update cancelled token.
- [ ] Recalculate visible queue.
- [ ] Update waiting count.

---

## 14.4 Socket Reconnection

- [ ] Detect disconnect.
- [ ] Reconnect automatically.
- [ ] Fetch current queue after reconnect.
- [ ] Ensure no stale queue remains displayed.

---

# PHASE 15 - Patient Flutter Application Foundation

**Goal:** Build the patient mobile application.

**Dependencies:** Backend doctor/queue APIs

---

## 15.1 Initialize Flutter

- [ ] Create Flutter project.
- [ ] Configure Android.
- [ ] Configure application name.
- [ ] Configure app icon if available.
- [ ] Add networking dependency.
- [ ] Add Socket.IO client.
- [ ] Add local storage dependency if required for token tracking.

Recommended:

```text
Flutter
Dart
Dio
Socket.IO client
```

---

## 15.2 Create Mobile Structure

```text
lib/
├── models/
├── screens/
├── services/
├── widgets/
└── main.dart
```

- [ ] Create models.
- [ ] Create screens.
- [ ] Create services.
- [ ] Create reusable widgets.

---

## 15.3 API Service

Create:

```text
api_service.dart
```

Implement:

- [ ] Get clinics.
- [ ] Get doctors.
- [ ] Get doctor details.
- [ ] Get queue summary.
- [ ] Create token.
- [ ] Get token status.

---

## 15.4 Socket Service

Create:

```text
socket_service.dart
```

- [ ] Connect to backend.
- [ ] Join doctor queue room.
- [ ] Listen for queue updates.
- [ ] Listen for availability changes.
- [ ] Listen for token cancellation.
- [ ] Reconnect when required.
- [ ] Fetch latest REST state after reconnect.

---

# PHASE 16 - Patient Home Screen

**Goal:** Allow patients to quickly choose a doctor.

**Dependencies:** Phase 15

---

## 16.1 Home UI

Build:

- [ ] App name/logo.
- [ ] Simple greeting.
- [ ] Doctor list.
- [ ] Doctor cards.

Each doctor card should show:

- [ ] Doctor name.
- [ ] Specialization.
- [ ] Availability.
- [ ] Waiting count.
- [ ] View/Book action.

---

## 16.2 Doctor Availability

ACTIVE:

```text
● Active
8 patients waiting

[ View & Book ]
```

INACTIVE:

```text
○ Currently unavailable

[ Booking unavailable ]
```

- [ ] Disable booking for inactive doctor.
- [ ] Still optionally display doctor.
- [ ] Update availability in real time.

---

# PHASE 17 - Patient Doctor Details Screen

**Goal:** Give patients only the information needed to decide whether to book.

**Dependencies:** Phase 16

---

## 17.1 Doctor Details

Display:

- [ ] Doctor name.
- [ ] Specialization.
- [ ] Clinic.
- [ ] Availability.
- [ ] Current token.
- [ ] Waiting count.
- [ ] Book Token button.

---

## 17.2 Booking Availability

If ACTIVE:

- [ ] Enable Book Token.

If INACTIVE:

- [ ] Disable Book Token.
- [ ] Display unavailable message.
- [ ] Prevent API booking as well.

---

# PHASE 18 - Patient Details Form

**Goal:** Collect only the required patient information.

**Dependencies:** Phase 17

---

## 18.1 Required Fields

- [ ] Full name.
- [ ] Mobile number.
- [ ] Age.
- [ ] Gender.

---

## 18.2 Optional Field

- [ ] Email only if required.

Do not add:

- [-] Medical history.
- [-] Allergies.
- [-] Prescriptions.
- [-] Insurance.
- [-] Unnecessary personal information.

---

## 18.3 Validation

- [ ] Validate name.
- [ ] Validate phone.
- [ ] Validate age.
- [ ] Validate gender.
- [ ] Display field-level errors.
- [ ] Disable submission while booking request is in progress.

---

# PHASE 19 - Patient Token Booking

**Goal:** Complete the core patient journey.

**Dependencies:** Phases 17 and 18

---

## 19.1 Book Token

- [ ] Submit patient details.
- [ ] Call `POST /api/tokens`.
- [ ] Display loading state.
- [ ] Handle success.
- [ ] Handle duplicate active token.
- [ ] Handle doctor becoming inactive before submission.
- [ ] Handle network error.

---

## 19.2 Booking Confirmation

Display:

```text
Token Booked

#24

Dr. Sharma

Currently Serving
#18

Patients Ahead
5

Estimated Wait
~30 min
```

- [ ] Show token number prominently.
- [ ] Show doctor.
- [ ] Show current token.
- [ ] Show patients ahead.
- [ ] Show estimated wait.
- [ ] Add Track Queue action.

---

# PHASE 20 - Patient Live Queue Tracking

**Goal:** Allow patients to monitor their position without refreshing.

**Dependencies:** Phases 10 and 19

---

## 20.1 Queue Tracking Screen

Display:

- [ ] Patient token.
- [ ] Current serving token.
- [ ] Patients ahead.
- [ ] Estimated wait.
- [ ] Doctor name.
- [ ] Live indicator.
- [ ] Queue status.

---

## 20.2 Real-Time Queue Changes

When doctor advances:

- [ ] Update current serving token.
- [ ] Decrease patients ahead.
- [ ] Recalculate estimated wait.
- [ ] Update token state.

---

## 20.3 Token Cancellation

If patient's token is cancelled:

- [ ] Receive cancellation event.
- [ ] Display:

```text
Token Cancelled
```

- [ ] Stop treating token as active.
- [ ] Prevent invalid queue tracking state.

---

## 20.4 Doctor Availability Changes

If doctor becomes INACTIVE:

- [ ] Update doctor status.
- [ ] Do not cancel patient's existing token.
- [ ] Continue displaying existing queue information.
- [ ] Prevent new bookings for that doctor.

---

# PHASE 21 - Shared UI Design System

**Goal:** Make both applications visually consistent with the attached reference.

**Dependencies:** Basic UI implementations

---

## 21.1 Design Principles

- [ ] Minimal.
- [ ] Sleek.
- [ ] Spacious.
- [ ] Rounded cards.
- [ ] Soft backgrounds.
- [ ] Limited colors.
- [ ] Clear hierarchy.
- [ ] Large token numbers.
- [ ] Few actions.
- [ ] Subtle shadows.
- [ ] Minimal borders.

---

## 21.2 Color Palette

Use approximately:

```text
Dark:          #303030
Soft Yellow:   #FDF7E5
Accent Yellow: #FFD84D
Light Gray:    #E3E5E6
Medium Gray:   #A4ABB6
White:         #FFFFFF
```

- [ ] Verify accessibility contrast.
- [ ] Avoid overusing yellow.
- [ ] Use dark color for primary actions.
- [ ] Use yellow for important accents.

---

## 21.3 Typography

Choose one:

```text
Inter
Geist
Manrope
```

Recommended hierarchy:

```text
Page title       28–36px
Section title    18–22px
Body             14–16px
Secondary text   12–14px
Token number     40–64px
```

- [ ] Use one font consistently.
- [ ] Make token number visually dominant.

---

## 21.4 Accessibility

- [ ] Maintain readable contrast.
- [ ] Do not use color as the only status indicator.
- [ ] Add text labels.
- [ ] Ensure buttons are large enough.
- [ ] Ensure web keyboard navigation works.
- [ ] Use clear error messages.

---

# PHASE 22 - Loading, Error, and Empty States

**Goal:** Make the product reliable and understandable during normal failures.

**Dependencies:** UI implementation

---

## 22.1 Loading States

Doctor web:

- [ ] Login loading.
- [ ] Queue loading.
- [ ] Next Token loading.
- [ ] Cancel loading.
- [ ] Status toggle loading.

Patient app:

- [ ] Doctor list loading.
- [ ] Doctor detail loading.
- [ ] Booking loading.
- [ ] Queue loading.
- [ ] Queue refresh/reconnect state.

---

## 22.2 Error States

Implement:

- [ ] Network error.
- [ ] Authentication failure.
- [ ] Expired session.
- [ ] Booking failure.
- [ ] Duplicate token.
- [ ] Doctor unavailable.
- [ ] Queue operation failure.
- [ ] Server error.

---

## 22.3 Empty States

Doctor:

```text
No patients waiting
You're all caught up.
```

Patient:

```text
No doctors available right now.
```

---

# PHASE 23 - API Consistency and Validation

**Goal:** Make all APIs predictable for both clients.

**Dependencies:** Backend APIs

---

## 23.1 Response Format

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
  "errors": {}
}
```

- [ ] Standardize all endpoints.
- [ ] Remove inconsistent response formats.

---

## 23.2 HTTP Status Codes

Implement consistently:

- [ ] `200` Success.
- [ ] `201` Created.
- [ ] `400` Bad Request.
- [ ] `401` Unauthorized.
- [ ] `403` Forbidden.
- [ ] `404` Not Found.
- [ ] `409` Conflict.
- [ ] `422` Validation Error.
- [ ] `500` Server Error.

---

## 23.3 Request Validation

- [ ] Validate every external request.
- [ ] Validate doctor ID.
- [ ] Validate patient details.
- [ ] Validate token ID.
- [ ] Validate status.
- [ ] Reject unexpected/invalid data.

---

# PHASE 24 - Security Hardening

**Goal:** Make the MVP safe enough for real deployment testing.

**Dependencies:** All backend functionality

---

## 24.1 Authentication Security

- [ ] Hash passwords.
- [ ] Use strong JWT secret.
- [ ] Configure JWT expiry.
- [ ] Reject invalid JWT.
- [ ] Handle expired sessions.

---

## 24.2 Authorization Security

Test:

- [ ] Doctor A cannot access Doctor B's queue.
- [ ] Doctor A cannot cancel Doctor B's token.
- [ ] Doctor A cannot advance Doctor B's queue.
- [ ] Doctor A cannot change Doctor B's availability.
- [ ] Unauthenticated user cannot access doctor endpoints.

---

## 24.3 API Security

- [ ] Enable Helmet.
- [ ] Configure CORS.
- [ ] Add rate limiting.
- [ ] Use parameterized queries/ORM.
- [ ] Validate input.
- [ ] Centralize errors.
- [ ] Do not expose internal stack traces in production.

---

## 24.4 Sensitive Data

- [ ] Never log passwords.
- [ ] Never log JWT secrets.
- [ ] Avoid unnecessary patient information in logs.
- [ ] Never expose password hash through API.
- [ ] Do not commit credentials.

---

# PHASE 25 - Backend Testing

**Goal:** Verify business logic before relying on the UI.

**Dependencies:** Backend implementation

---

## 25.1 Authentication Tests

- [ ] Valid login succeeds.
- [ ] Invalid email fails.
- [ ] Invalid password fails.
- [ ] Missing credentials fail.
- [ ] Invalid JWT fails.
- [ ] Expired JWT fails.

---

## 25.2 Doctor Status Tests

- [ ] Default doctor status is INACTIVE.
- [ ] Doctor can switch to ACTIVE.
- [ ] Doctor can switch to INACTIVE.
- [ ] Doctor cannot modify another doctor's status.
- [ ] Login does not automatically activate doctor.
- [ ] Logout does not automatically deactivate doctor.
- [ ] Status event is emitted after successful update.

---

## 25.3 Booking Tests

- [ ] Valid booking creates token.
- [ ] Token number increments.
- [ ] Token number resets by booking date.
- [ ] Duplicate active token is rejected.
- [ ] Inactive doctor booking is rejected.
- [ ] Invalid patient data is rejected.
- [ ] Concurrent booking does not duplicate token number.

---

## 25.4 Queue Tests

- [ ] First waiting token becomes serving.
- [ ] Serving token becomes completed.
- [ ] Next waiting token becomes serving.
- [ ] Empty queue is handled.
- [ ] Cancelled token is skipped.
- [ ] Completed token cannot be cancelled.
- [ ] Serving token cannot be cancelled.
- [ ] Invalid state transitions are rejected.

---

## 25.5 Authorization Tests

- [ ] Doctor can access own queue.
- [ ] Doctor cannot access another doctor's queue.
- [ ] Doctor can cancel own token.
- [ ] Doctor cannot cancel another doctor's token.
- [ ] Doctor can advance own queue.
- [ ] Doctor cannot advance another doctor's queue.

---

# PHASE 26 - Real-Time Testing

**Goal:** Verify that REST and Socket.IO stay synchronized.

**Dependencies:** Socket.IO implementation + client applications

---

## 26.1 Patient Booking → Doctor Dashboard

Test:

```text
Patient books #25
        ↓
Backend creates token
        ↓
Socket event emitted
        ↓
Doctor dashboard updates
```

- [ ] No browser refresh required.
- [ ] Waiting count increments.
- [ ] Token appears.

---

## 26.2 Doctor Next Token → Patient App

Test:

```text
Doctor advances #24 → #25
        ↓
Socket event
        ↓
Patient app updates
```

- [ ] Current token changes.
- [ ] Patients ahead change.
- [ ] Estimated wait changes.

---

## 26.3 Doctor Cancellation → Patient

- [ ] Doctor cancels patient token.
- [ ] Patient receives cancellation.
- [ ] Patient sees cancelled state.

---

## 26.4 Availability Update

Test:

```text
Doctor ACTIVE
        ↓
Doctor switches INACTIVE
        ↓
Patient app updates
        ↓
New booking disabled
```

Then:

```text
Doctor INACTIVE
        ↓
Doctor switches ACTIVE
        ↓
Patient app updates
        ↓
Booking becomes available
```

---

## 26.5 Socket Disconnect

- [ ] Disconnect patient.
- [ ] Reconnect patient.
- [ ] Verify queue state is refreshed.
- [ ] Disconnect doctor.
- [ ] Reconnect doctor.
- [ ] Verify queue state is refreshed.

---

# PHASE 27 - End-to-End MVP Testing

**Goal:** Test the complete system as a real user would.

**Dependencies:** All core development phases

---

## 27.1 Complete Booking Journey

- [ ] Start backend.
- [ ] Start database.
- [ ] Start doctor web.
- [ ] Start patient app.
- [ ] Doctor logs in.
- [ ] Doctor is INACTIVE.
- [ ] Patient sees doctor unavailable.
- [ ] Doctor switches ACTIVE.
- [ ] Patient sees doctor active.
- [ ] Patient enters details.
- [ ] Patient books token.
- [ ] Doctor sees new token immediately.
- [ ] Patient sees token confirmation.

---

## 27.2 Complete Queue Journey

- [ ] Create multiple patient tokens.
- [ ] Verify token sequence.
- [ ] Verify queue ordering.
- [ ] Doctor presses Next Token.
- [ ] Verify current token.
- [ ] Verify previous token becomes completed.
- [ ] Verify patient app updates.
- [ ] Repeat until queue is empty.

---

## 27.3 Cancellation Journey

- [ ] Create multiple tokens.
- [ ] Doctor cancels waiting token.
- [ ] Verify status is CANCELLED.
- [ ] Verify queue position changes.
- [ ] Verify patient receives cancellation.
- [ ] Verify cancelled token is skipped by Next Token.

---

## 27.4 Availability Journey

- [ ] Doctor switches INACTIVE.
- [ ] Patient sees unavailable status.
- [ ] Attempt booking through UI.
- [ ] Booking button is disabled.
- [ ] Attempt booking directly through API.
- [ ] Backend rejects booking.
- [ ] Doctor switches ACTIVE.
- [ ] Patient sees active status.
- [ ] New booking succeeds.

---

# PHASE 28 - UI/UX Review

**Goal:** Bring the implementation into line with the PRD's visual direction.

**Dependencies:** Functional web and mobile UI

---

## 28.1 Doctor Dashboard Review

- [ ] Remove unnecessary information.
- [ ] Ensure current token is visually dominant.
- [ ] Ensure Next Token is the primary action.
- [ ] Ensure status toggle is prominent.
- [ ] Keep queue readable.
- [ ] Keep statistics minimal.
- [ ] Use rounded cards.
- [ ] Use soft background.
- [ ] Avoid visual clutter.

---

## 28.2 Patient App Review

- [ ] Reduce unnecessary fields.
- [ ] Make doctor selection obvious.
- [ ] Make token number dominant.
- [ ] Make queue position obvious.
- [ ] Make availability clear.
- [ ] Keep navigation simple.
- [ ] Avoid unnecessary menus.

---

## 28.3 Reference Image Alignment

Use the attached reference only for design language:

- [ ] Soft neutral background.
- [ ] Warm yellow accent.
- [ ] Dark primary elements.
- [ ] Rounded surfaces.
- [ ] Generous spacing.
- [ ] Minimal content density.
- [ ] Clean typography.

Do NOT copy the HR dashboard's actual information architecture.

---

# PHASE 29 - Performance and Reliability

**Goal:** Ensure the MVP behaves correctly under expected load.

**Dependencies:** Functional system

---

## 29.1 API Performance

Target:

```text
Normal API response < 500 ms
```

- [ ] Measure major endpoints.
- [ ] Optimize slow queries.
- [ ] Add database indexes where required.

---

## 29.2 Real-Time Performance

Target:

```text
Queue update propagation ideally < 1 second
```

- [ ] Measure booking → dashboard update.
- [ ] Measure next token → patient update.
- [ ] Measure status → patient update.

---

## 29.3 Expected MVP Scale

Validate against:

```text
1–50 clinics
1–500 doctors
10–500 active patients per doctor/day
```

- [ ] Test representative queue sizes.
- [ ] Test concurrent booking.
- [ ] Test concurrent queue advancement.

---

# PHASE 30 - Logging and Monitoring

**Goal:** Make production failures diagnosable without exposing sensitive data.

**Dependencies:** Backend complete

---

## 30.1 Backend Logs

Log:

- [ ] Server startup.
- [ ] Database connection.
- [ ] Authentication failures.
- [ ] Token creation.
- [ ] Token cancellation.
- [ ] Queue advancement.
- [ ] Doctor status changes.
- [ ] Unexpected errors.

---

## 30.2 Sensitive Logging Rules

Never log:

- [ ] Passwords.
- [ ] JWT secrets.
- [ ] Database credentials.
- [ ] Unnecessary patient information.

---

# PHASE 31 - Production Configuration

**Goal:** Prepare the MVP for deployment.

**Dependencies:** Testing complete

---

## 31.1 Backend Production Environment

- [ ] Create production SQL database.
- [ ] Configure production `DATABASE_URL`.
- [ ] Configure production `JWT_SECRET`.
- [ ] Configure production CORS.
- [ ] Configure production Socket.IO origin.
- [ ] Disable verbose error details.
- [ ] Configure production logging.

---

## 31.2 React Production Environment

- [ ] Configure production API URL.
- [ ] Configure production Socket.IO URL.
- [ ] Build production bundle.
- [ ] Test production build locally.

---

## 31.3 Flutter Production Configuration

- [ ] Configure production API URL.
- [ ] Configure production Socket.IO URL.
- [ ] Configure Android application ID.
- [ ] Configure app name.
- [ ] Build release APK/AAB.
- [ ] Test release build.

---

# PHASE 32 - Deployment

**Goal:** Deploy all MVP components.

**Dependencies:** Phase 31

---

## 32.1 Backend Deployment

Possible target:

```text
Render
Railway
VPS
```

- [ ] Deploy Node.js backend.
- [ ] Configure environment variables.
- [ ] Configure SQL connection.
- [ ] Verify health endpoint.
- [ ] Verify API endpoints.
- [ ] Verify Socket.IO connection.

---

## 32.2 MySQL Database Deployment

- [ ] Deploy managed MySQL.
- [ ] Verify that the production database is MySQL/SQL only.
- [ ] Run production migrations.
- [ ] Verify schema.
- [ ] Verify constraints.
- [ ] Create production doctor accounts securely.

---

## 32.3 Doctor Web Deployment

Possible target:

```text
Vercel
Netlify
```

- [ ] Deploy React application.
- [ ] Configure backend URL.
- [ ] Configure Socket.IO URL.
- [ ] Verify login.
- [ ] Verify dashboard.
- [ ] Verify real-time queue.

---

## 32.4 Patient App Release

- [ ] Build Android release.
- [ ] Install on physical device.
- [ ] Verify production API.
- [ ] Verify Socket.IO.
- [ ] Verify token booking.
- [ ] Verify queue tracking.

---

# PHASE 33 - Production Smoke Test

**Goal:** Verify that the deployed MVP actually works before declaring victory.

**Dependencies:** Phase 32

---

## 33.1 Doctor Smoke Test

- [ ] Open production web app.
- [ ] Login.
- [ ] Verify status.
- [ ] Switch ACTIVE.
- [ ] Verify patient app sees ACTIVE.
- [ ] View queue.
- [ ] Advance token.
- [ ] Cancel waiting token.
- [ ] Switch INACTIVE.
- [ ] Verify new booking is blocked.
- [ ] Logout.

---

## 33.2 Patient Smoke Test

- [ ] Open production app.
- [ ] View doctors.
- [ ] Verify availability.
- [ ] Select active doctor.
- [ ] Enter patient details.
- [ ] Book token.
- [ ] Verify confirmation.
- [ ] Verify live queue.
- [ ] Verify next-token updates.
- [ ] Verify cancellation.
- [ ] Verify inactive doctor cannot accept new booking.

---

# PHASE 34 - MVP Completion Gate

The MVP is complete only when every item below passes.

## Architecture

- [ ] React communicates with Node.js API.
- [ ] Flutter/Kotlin communicates with Node.js API.
- [ ] Neither client connects directly to SQL.
- [ ] SQL is the source of truth.
- [ ] Socket.IO is used for real-time updates.

## Doctor

- [ ] Login works.
- [ ] JWT works.
- [ ] Dashboard works.
- [ ] ACTIVE / INACTIVE toggle works.
- [ ] Status persists.
- [ ] Queue displays correctly.
- [ ] Next Token works.
- [ ] Cancel Token works.
- [ ] Real-time updates work.
- [ ] Logout works.

## Patient

- [ ] Doctor list works.
- [ ] Availability works.
- [ ] Doctor details work.
- [ ] Patient details form works.
- [ ] Token booking works.
- [ ] Unique token generation works.
- [ ] Duplicate active booking protection works.
- [ ] Confirmation works.
- [ ] Live queue tracking works.
- [ ] Cancellation state works.

## Backend

- [ ] Authentication works.
- [ ] Authorization works.
- [ ] Validation works.
- [ ] Error handling works.
- [ ] Token lifecycle is enforced.
- [ ] Queue advancement is transactional.
- [ ] Token creation is transaction-safe.
- [ ] Availability enforcement works.
- [ ] Socket events work.
- [ ] Security middleware is enabled.

## UI

- [ ] Minimal design.
- [ ] Sleek design.
- [ ] Reference color palette followed.
- [ ] Responsive doctor dashboard.
- [ ] Accessible controls.
- [ ] Clear loading states.
- [ ] Clear error states.
- [ ] Clear empty states.
- [ ] No unnecessary UI.

---

# PHASE 35 - Post-MVP / Future Work

**Do NOT implement these during MVP unless the requirements are explicitly changed.**

---

## Phase 35.1 - Patient Authentication

- [ ] Evaluate OTP login.
- [ ] Implement mobile OTP.
- [ ] Create patient account model.
- [ ] Link persistent patient identity to bookings.

---

## Phase 35.2 - Push Notifications

- [ ] Evaluate Firebase Cloud Messaging.
- [ ] Notify patient when token is approaching.
- [ ] Notify patient when token is called.
- [ ] Notify patient if token is cancelled.
- [ ] Notify patient if doctor becomes unavailable.

---

## Phase 35.3 - Doctor Scheduling

- [ ] Create doctor schedules.
- [ ] Define working days.
- [ ] Define working hours.
- [ ] Prevent bookings outside working hours.
- [ ] Add schedule management UI.

---

## Phase 35.4 - Admin Dashboard

- [ ] Admin authentication.
- [ ] Clinic management.
- [ ] Doctor management.
- [ ] Enable/disable doctors.
- [ ] Configure queue settings.
- [ ] Manage clinic information.

---

## Phase 35.5 - Queue Enhancements

- [ ] No-show status.
- [ ] Queue pause.
- [ ] Queue resume.
- [ ] Doctor delay mode.
- [ ] Configurable consultation duration.
- [ ] Better waiting-time estimation.

---

## Phase 35.6 - Hospital Features

Only after the token system is stable:

- [ ] Appointments.
- [ ] Patient history.
- [ ] Prescriptions.
- [ ] Payments.
- [ ] Reports.
- [ ] Analytics.
- [ ] Departments.
- [ ] Hospital-wide queue management.

---

# 36. Dependency Map

The implementation should follow this dependency chain:

```text
PHASE 0
Project Setup
    │
    ▼
PHASE 1
Backend Foundation
    │
    ▼
PHASE 2
Database
    │
    ▼
PHASE 3
Authentication
    │
    ▼
PHASE 4
Clinic / Doctor APIs
    │
    ▼
PHASE 5
Doctor Availability
    │
    ▼
PHASE 6
Token Booking
    │
    ▼
PHASE 7
Queue Service
    │
    ├───────────────┐
    ▼               ▼
PHASE 8          PHASE 9
Next Token       Cancellation
    │               │
    └───────┬───────┘
            ▼
PHASE 10
Socket.IO Backend
            │
      ┌─────┴─────┐
      ▼           ▼
PHASE 11       PHASE 15
React Web      Flutter App
      │           │
      ▼           ▼
PHASE 12       PHASE 16
Login          Patient Home
      │           │
      ▼           ▼
PHASE 13       PHASE 17
Dashboard      Doctor Details
      │           │
      ▼           ▼
PHASE 14       PHASE 18
Realtime Web   Patient Details
                  │
                  ▼
              PHASE 19
              Booking
                  │
                  ▼
              PHASE 20
              Live Queue
                  │
       ┌──────────┴──────────┐
       ▼                     ▼
PHASE 21                PHASE 22
UI Design               States
       │                     │
       └──────────┬──────────┘
                  ▼
              PHASE 23
              API Quality
                  │
                  ▼
              PHASE 24
              Security
                  │
                  ▼
              PHASE 25
              Backend Tests
                  │
                  ▼
              PHASE 26
              Realtime Tests
                  │
                  ▼
              PHASE 27
              E2E Tests
                  │
                  ▼
              PHASE 28
              UI Review
                  │
                  ▼
              PHASE 29
              Performance
                  │
                  ▼
              PHASE 30
              Logging
                  │
                  ▼
              PHASE 31
              Production Config
                  │
                  ▼
              PHASE 32
              Deployment
                  │
                  ▼
              PHASE 33
              Smoke Test
                  │
                  ▼
              PHASE 34
              MVP COMPLETE
                  │
                  ▼
              PHASE 35
              Future Features
```

---

# 37. Critical Business Rules Checklist

These rules must remain true throughout development.

- [ ] Token numbers are generated by the backend.
- [ ] Token numbers are unique per doctor per day.
- [ ] Patient cannot create duplicate active token for the same doctor/day.
- [ ] Inactive doctors cannot receive new tokens.
- [ ] Existing tokens are not automatically cancelled when doctor becomes inactive.
- [ ] Login does not automatically activate a doctor.
- [ ] Logout does not automatically deactivate a doctor.
- [ ] Only authenticated doctors can manage queues.
- [ ] Doctors can modify only their own queues.
- [ ] Doctors can modify only their own availability.
- [ ] `WAITING → SERVING` is the normal next-token transition.
- [ ] `SERVING → COMPLETED` occurs when moving to the next patient.
- [ ] `WAITING → CANCELLED` is the cancellation transition.
- [ ] Completed/cancelled tokens cannot be served.
- [ ] Serving/completed tokens cannot be cancelled through the waiting-token cancellation operation.
- [ ] Queue advancement is transactional.
- [ ] Token generation is protected against concurrent requests.
- [ ] SQL is the authoritative state.
- [ ] Socket.IO is for real-time synchronization, not persistence.
- [ ] Client applications never connect directly to SQL.
- [ ] Estimated waiting time is informational, not guaranteed.
- [ ] Medical records and unnecessary patient information are outside MVP scope.

---

# 38. Final MVP Deliverables

At the end of the implementation, the repository should contain:

```text
hospital-token-system/
│
├── backend/
│   ├── src/
│   ├── prisma/
│   ├── tests/
│   ├── package.json
│   └── .env.example
│
├── doctor-web/
│   ├── src/
│   ├── public/
│   └── package.json
│
├── patient-app/
│   ├── lib/
│   ├── android/
│   └── pubspec.yaml
│
├── docs/
│   └── hospital_clinic_token_booking_prd.md
│
├── README.md
└── .gitignore
```

---

# 39. Definition of Done

A task should not be marked `[x]` simply because the code exists.

A task is complete only when:

- [ ] Implementation exists.
- [ ] Database changes exist where required.
- [ ] API integration exists where required.
- [ ] Validation exists.
- [ ] Authorization exists where required.
- [ ] Loading state exists where relevant.
- [ ] Error handling exists.
- [ ] Real-time behavior exists where required.
- [ ] Manual testing passes.
- [ ] Automated tests pass where applicable.
- [ ] The implementation matches the PRD.
- [ ] No unnecessary feature has been introduced.
- [ ] No sensitive credentials are committed.

---

# 40. MVP Completion Statement

The project should be considered **MVP complete** only when a real end-to-end scenario works:

```text
Doctor logs in
      ↓
Doctor switches INACTIVE → ACTIVE
      ↓
Patient opens mobile app
      ↓
Patient sees doctor as ACTIVE
      ↓
Patient enters details
      ↓
Patient books Token #1
      ↓
Doctor sees Token #1 immediately
      ↓
Patient #2 books Token #2
      ↓
Doctor sees #1 and #2 in queue
      ↓
Doctor presses NEXT TOKEN
      ↓
#1 becomes SERVING
      ↓
Patient #1 sees updated queue
      ↓
Doctor presses NEXT TOKEN
      ↓
#1 becomes COMPLETED
#2 becomes SERVING
      ↓
Patient #2 sees updated queue
      ↓
Doctor cancels a waiting token
      ↓
Affected patient sees CANCELLED
      ↓
Doctor switches ACTIVE → INACTIVE
      ↓
Patient app shows doctor unavailable
      ↓
New booking is rejected
      ↓
Existing queue remains intact
```

If this flow works reliably, the core product works.

Everything else is secondary.
