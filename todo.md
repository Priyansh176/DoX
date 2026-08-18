# Hospital / Clinic Token Booking System - MVP Todo

This is a simple, basic MVP plan based on the PRD. The focus is on the core queue flow: doctor login, queue management, patient booking, and real-time updates without overbuilding.

---

## Phase 1 - Backend (Node.js + Express)

### 1. Project Setup
- [x] Initialize Node.js project
- [x] Install dependencies: express, dotenv, cors, helmet, mysql2 or Prisma, bcrypt, jsonwebtoken, socket.io
- [x] Configure TypeScript (basic setup)
- [x] Create environment variables file
- [x] Create basic project folder structure

### 2. API Foundation
- [x] Set up Express app
- [x] Add basic health check route
- [x] Add global error handling
- [x] Add request validation
- [x] Add consistent API response format
- [x] Add basic CORS and security middleware

### 3. Authentication
- [x] Create doctor login API
- [x] Hash password using bcrypt
- [x] Generate JWT on successful login
- [x] Add auth middleware for protected doctor routes
- [x] Add route protection for doctor-only APIs

### 4. Doctor APIs
- [x] Get doctor profile
- [x] Get doctor queue
- [x] Get current serving token
- [x] Advance to next token
- [x] Cancel waiting token
- [x] Get and update doctor availability status
- [x] Enforce doctor can only access their own queue

### 5. Patient APIs
- [x] Get clinics
- [x] Get doctors by clinic
- [x] Get doctor queue summary
- [x] Create new token booking
- [x] Get token status
- [x] Prevent duplicate active booking for same patient/doctor/day
- [x] Reject booking when doctor is inactive

### 6. Queue Logic
- [x] Generate token numbers per doctor per day
- [x] Sort waiting tokens by token number
- [x] Mark next token as SERVING
- [x] Mark current serving token as COMPLETED when advanced
- [x] Keep existing queue unchanged when doctor becomes inactive
- [x] Calculate patients ahead and estimated wait time
- [x] Ensure queue advancement is transactional

### 7. Real-Time Layer
- [x] Set up Socket.IO server
- [x] Join doctor queue room
- [x] Emit queue update events
- [x] Emit token cancellation event
- [x] Emit serving token event
- [x] Emit doctor availability changed event

### 8. Basic Validation & Security
- [x] Validate required patient fields
- [x] Validate doctor login input
- [x] Validate doctor status values: ACTIVE / INACTIVE
- [x] Prevent unauthorized access to other doctor data
- [x] Avoid logging sensitive data

### 9. Basic Testing
- [x] Test doctor login route structure
- [x] Test backend startup and DB connection
- [x] Test token route matching and request schema
- [x] Test duplicate booking prevention
- [x] Test next token logic
- [x] Test cancellation logic
- [x] Test unauthorized access

---

## Phase 2 - Frontend (React)

### 1. Project Setup
- [x] Initialize React app
- [x] Install React Router, Axios, Socket.IO client
- [x] Set up basic app structure
- [x] Configure API base URL and environment values

### 2. Doctor Web Dashboard
- [x] Build login page
- [x] Build dashboard layout shell
- [x] Show doctor name and clinic info
- [x] Add logout button
- [x] Add availability toggle for ACTIVE / INACTIVE
- [x] Show current queue summary cards
- [x] Show current serving token section
- [x] Show waiting queue list
- [x] Add Next Token button
- [x] Add Cancel button for waiting tokens
- [x] Show empty state when no patients are waiting
- [x] Add loading and error states

### 3. Doctor Dashboard API Integration
- [x] Connect login API
- [x] Fetch current doctor status
- [x] Update doctor status via API
- [x] Fetch queue data
- [x] Call next token endpoint
- [x] Cancel token endpoint
- [x] Refresh queue after updates

### 4. Real-Time UI Updates
- [x] Connect Socket.IO client to doctor room
- [x] Listen for queue updates
- [x] Listen for doctor availability changes
- [x] Update dashboard without page refresh

### 5. Patient App UI (Simple React-based flow if needed)
- [ ] Build doctor list screen
- [ ] Build doctor details screen
- [ ] Build patient details form
- [ ] Add booking button
- [ ] Show booking confirmation screen
- [ ] Show live queue tracking screen
- [ ] Show doctor unavailable state
- [ ] Show error states for booking failures and duplicates

### 6. Frontend Styling
- [ ] Use simple clean design with soft cards and warm accents
- [ ] Keep layout minimal and readable
- [ ] Highlight token numbers prominently
- [ ] Keep buttons easy to understand
- [ ] Ensure responsive desktop layout for MVP

---

## Phase 3 - Database (MySQL)

### 1. Setup Database
- [x] Create MySQL database for clinic queue project
- [x] Create database user and credentials
- [x] Configure .env connection details
- [x] Test connection from backend

### 2. Tables
- [x] Create clinics table
- [x] Create doctors table
- [x] Create patients table
- [x] Create tokens table
- [x] Add primary keys and foreign keys
- [x] Add created_at and updated_at timestamps

### 3. Required Fields / Constraints
- [x] Store doctor status as ACTIVE / INACTIVE
- [x] Store password hash for doctors
- [x] Store patient details: name, phone, age, gender
- [x] Store token details: token_number, status, booking_date
- [x] Add unique token constraint per doctor per day
- [x] Add indexes for queue lookup and doctor queries

### 4. Queue Rules in SQL
- [x] Support daily reset of token numbers
- [x] Keep historical records after reset
- [x] Store token status values: WAITING, SERVING, COMPLETED, CANCELLED
- [x] Support queue ordering by token_number ascending

### 5. Seed Data
- [x] Add sample clinic
- [x] Add sample doctor
- [ ] Add sample patient records if needed
- [ ] Seed initial queue records for testing

### 6. Basic Integrity Checks
- [x] Prevent duplicate token numbers for same doctor/day
- [x] Ensure queue advancement stays valid
- [x] Ensure inactive doctors cannot accept new bookings
- [x] Maintain queue history for audit and debugging

---

## MVP Cross-Phase Checklist

### Must Have
- [x] Doctor login with JWT
- [x] Doctor ACTIVE / INACTIVE status toggle
- [x] New patient booking only when doctor is active
- [x] Token generation per doctor/day
- [x] Real-time queue updates via Socket.IO
- [x] Doctor can advance queue
- [x] Doctor can cancel waiting token
- [x] Duplicate booking prevention
- [x] Queue persists in MySQL
- [x] Basic loading and error states

### Not Required in Initial MVP
- [ ] EMR system
- [ ] Payment integration
- [ ] Prescriptions
- [ ] Insurance processing
- [ ] Advanced admin dashboard
- [ ] Complex analytics
- [ ] Push notifications
- [ ] Multi-department features

---

## Recommended Simple Delivery Order

1. Database schema and seed data
2. Backend auth and queue APIs
3. Socket.IO real-time updates
4. React doctor dashboard
5. Patient booking flow
6. Basic testing and bug fixing

---

## Definition of Done for MVP

- [x] Backend works for login, queue, booking, and cancellation
- [x] MySQL schema is created and functional
- [x] React dashboard can manage queue
- [ ] Patient booking flow works for basic usage
- [x] Doctor availability status is enforced
- [x] Real-time updates work without refresh
- [x] Basic validation and error messages are in place
- [x] Project remains simple and easy to extend later
