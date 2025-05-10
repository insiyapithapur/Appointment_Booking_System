# Appointment Booking System

## Project Overview
A comprehensive web-based application designed to streamline and optimize healthcare appointment scheduling processes. This system addresses the inefficiencies of traditional manual scheduling methods by providing a digital platform where patients can self-schedule appointments, doctors can manage their availability, and administrators can oversee the entire scheduling ecosystem.

## Features

### Patient Interface
- Secure login system with registration functionality
- Browse available doctors with filtering capabilities
- Book new appointments with preferred doctors 
- View upcoming appointments
- Access complete history of past medical visits
- Cancel or reschedule appointments
- Manage personal profile information

### Doctor Interface
- View daily and weekly appointment schedules
- Update appointment status (completed)
- Record medical notes from patient visits
- Access patient appointment history for context
- Manage personal and professional profile details

### Administrative Dashboard
- Add and manage doctor profiles
- View all registered patients
- Define working hours and scheduling parameters
- Override bookings when necessary
- Generate operational reports
- Access system-wide analytics

## Technology Stack

### Backend
- **Java** - Core programming language
- **J2EE Architecture** - Enterprise application architecture
- **Hibernate ORM** - Object-relational mapping
- **JSP** - JavaServer Pages for dynamic content generation
- **Servlets** - Request handling and processing
- **JSTL** - JSP Standard Tag Library
- **EL** - Expression Language

### Database
- **Oracle Database** - Robust, enterprise-grade RDBMS
- **PL/SQL** - Stored procedures and functions for analytics

### Frontend
- **HTML5** - Structure and content
- **CSS3** - Styling and responsive design
- **JavaScript** - Client-side interactivity
- **Bootstrap** - Responsive UI components

### Deployment
- **Render** - Web hosting platform
- **Docker** - Containerization
- **Oracle Cloud** - Database hosting
![image](https://github.com/user-attachments/assets/8f35bfd8-6b29-48e2-9e00-be7fe448bfa4)


## System Architecture
The system follows the MVC (Model-View-Controller) architecture:
- **Model**: Hibernate entity classes and DAO layer
- **View**: JSP pages with JSTL and EL
- **Controller**: Servlet classes for handling requests

## Database Schema
The database design is normalized to 3NF and includes the following key entities:
- Users (with role-based access)
- Doctors (with specializations)
- Patients (with medical history)
- Appointments (with status tracking)
- Schedules (for doctor availability)
![image](https://github.com/user-attachments/assets/930d67f7-dc5f-4964-bdec-69fd6978e734)

## Some Screenshots
Login Form ![image](https://github.com/user-attachments/assets/a2cc7fc9-8e60-4388-8029-e7b48adc6de4)
Patient Registration form ![image](https://github.com/user-attachments/assets/1f98b4e0-c804-4448-ba78-7aefad354d26)
Patient Dashboard ![image](https://github.com/user-attachments/assets/ea27e514-57c8-4eb9-be49-19dd49538dc4)
Available Doctors for appointment booking ![image](https://github.com/user-attachments/assets/9ea88a5b-dc70-4911-91cd-524e8af07095)
Available Slots for booking ![image](https://github.com/user-attachments/assets/738e702e-6fef-4af2-8571-a01b1f363ee9)  ![image](https://github.com/user-attachments/assets/bff639fc-e14a-4fe3-a1a3-375c7d5a9d65)
Doctor Dashboard ![image](https://github.com/user-attachments/assets/910bc3cd-0b47-485f-9ca4-32f3a5c8ff94) ![image](https://github.com/user-attachments/assets/9688f752-b668-4998-8e04-de91c3de7a1b)
Patient List for Doctor ![image](https://github.com/user-attachments/assets/b4d4254a-1aef-4b8e-a000-806e27931be8)
Appointment History ![image](https://github.com/user-attachments/assets/8589c52d-0817-478c-8108-2af7f7cb97c5)

## Installation and Setup
1. Clone the repository
2. Configure Oracle database connection in `hibernate.cfg.xml`
3. Deploy the application using Docker or directly to Tomcat/JBoss
4. Access the application through the web browser

## Usage
- Admin credentials: Username : ADMIN_INSIYA and Password: ROOT
- Access the system at: https://appointment-booking-system-15pl.onrender.com

## Future Enhancements
- Add two-factor authentication 
- User Experience Improvements
- Implement real-time updates using WebSockets for adding push notifications for appointment reminders and updates
- Implement video consultation capabilities
- Provide calendar integration (Google, Outlook)
