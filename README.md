# Appointment Booking System


## Project Overview

The Appointment Booking System is a comprehensive digital platform designed to streamline and optimize the appointment scheduling process in healthcare facilities. This system replaces manual appointment booking methods with an efficient, user-friendly digital solution that connects patients, doctors, and administrative staff through a centralized platform.

Developed as part of a project at Mastek, this application leverages a technology stack including JSP, Expression Language (EL), JSTL, Servlets, Hibernate, and J2EE architecture to create a robust Appointment Booking System for healthcare facilities.

## Key Features

### Patient Portal
- Secure login system allowing patients to book new appointments with preferred doctors
- View upcoming appointments and complete history of past medical visits
- Receive appointment confirmations and reminders
- Manage personal profile information
- Filter doctor availability by specialty, date range, or specific practitioner

### Doctor Interface
- View daily and weekly appointment schedules
- Update appointment status (completed, cancelled, rescheduled)
- Record notes from patient visits
- Manage availability calendars
- Access patient appointment history for context

### Administrative Dashboard
- Add and manage doctor profiles
- Define working hours and scheduling parameters
- Override bookings when necessary
- Generate operational reports
- Monitor system usage with analytics

### Analytics Module
- Data visualization tools for key metrics including:
  - Total appointments processed
  - Most active doctors by patient volume
  - Appointment distribution across specialties
  - Peak booking times

## System Architecture

The system is built on a multi-tiered architecture:

```
┌─────────────────┐
│   Presentation  │ JSP, EL, JSTL, HTML, CSS, JS
└────────┬────────┘
         │
┌────────▼────────┐
│    Controller   │ Servlets
└────────┬────────┘
         │
┌────────▼────────┐
│      Model      │ JavaBeans, Hibernate ORM
└────────┬────────┘
         │
┌────────▼────────┐
│     Database    │ Oracle
└─────────────────┘
```

### Technologies Used

| Component            | Technology                    |
|----------------------|-------------------------------|
| Framework            | J2EE Components, Hibernate    |
| Language             | Java, HTML, CSS, JS, JSP, JSTL, EL |
| IDE                  | Eclipse Enterprise Edition    |
| Database             | Oracle                        |
| API                  | REST API                      |
| Design Tools         | Figma, dbdiagram.io          |

## System Workflow

### User Authentication Flow

![Onboarding Process](https://raw.githubusercontent.com/yourusername/appointment-booking-system/main/docs/images/onboarding-flow.png)

The system implements a multi-tiered authentication approach with specialized interfaces for different stakeholders:

1. Users navigate to the login screen
2. New users can register with appropriate role credentials
3. Password recovery through email verification
4. Role-based redirection to appropriate dashboards

### Patient Flow

After authentication, patients can:
- View dashboard with upcoming appointments
- Browse doctor directory and profiles
- Schedule new appointments
- View appointment history
- Update personal profile

### Doctor Flow

After authentication, doctors can:
- View dashboard with today's appointments
- Access patient profiles and medical history
- Update appointment status
- Manage availability
- Configure profile settings

### Admin Flow

After authentication, administrators can:
- View system analytics and reports
- Manage doctor and patient accounts
- Configure system settings
- Monitor appointment activities
- Generate operational reports

## Database Design

The database schema is designed to support the complex relationships between patients, doctors, appointments, and other entities:

![Database Design](https://raw.githubusercontent.com/yourusername/appointment-booking-system/main/docs/images/database-design.png)


## Future Scope

- Improved business logic on database side using PL/SQL concepts
- Improvement in UI
- Enhanced scheduling process 
- File upload capabilities for doctor reports

## Installation and Setup

1. Clone the repository
   ```bash
   git clone https://github.com/yourusername/appointment-booking-system.git
   ```

2. Configure Oracle database
   - Create database schema
   - Update connection properties in `hibernate.cfg.xml`

3. Deploy to application server
   - Deploy the WAR file to a J2EE-compatible application server (e.g., Tomcat, JBoss)

4. Access the application
   ```
   http://localhost:8080/appointment-booking-system
   ```
