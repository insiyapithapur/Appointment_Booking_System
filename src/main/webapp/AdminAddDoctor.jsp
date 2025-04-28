<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Doctor</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Inter font from Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css">
    <style>
        :root {
            /* Sky blue theme colors */
            --primary-color: #4dabf7;
            --primary-light: #e7f5ff;
            --primary-dark: #339af0;
            --bg-color: #ffffff;
            --bg-secondary: #f8fafc;
            --sidebar-bg: #f8fafc;
            --text-primary: #2b3d4f;
            --text-secondary: #6c757d;
            --border-color: #dbe4ff;
            
            /* Status colors */
            --confirmed-color: #219653;
            --pending-color: #f2994a;
            --cancelled-color: #eb5757;
            --completed-color: #2f80ed;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background-color: var(--bg-color);
            color: var(--text-primary);
            line-height: 1.5;
            font-size: 14px;
        }
        
        /* Sidebar */
        .sidebar {
            position: fixed;
            width: 220px;
            height: 100vh;
            background-color: var(--sidebar-bg);
            border-right: 1px solid var(--border-color);
            padding: 0 0 30px 0;
            z-index: 1000;
            transition: all 0.3s;
        }
        
        /* Updated profile section - LinkedIn style */
        .profile-section {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding-bottom: 20px;
            position: relative;
            border-bottom: 1px solid var(--border-color);
        }
        
        .profile-background {
            width: 100%;
            height: 80px;
            background-color: var(--primary-color);
            background-image: url('data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMzAwIiBoZWlnaHQ9IjEwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KICA8ZyBvcGFjaXR5PSIwLjIiIGZpbGw9IiNmZmZmZmYiPgogICAgPHBhdGggZD0iTTI1LDUwIEE4LDggMCAwLDEgMzMsNTggTDMzLDY1IEE4LDggMCAwLDEgMjUsNzMgTC0xNSw3MyBBOCw4IDAgMCwxIC0yMyw2NSBMLTI1LDYwIEE1LDUgMCAwLDEgLTIwLDU1IEwtNSw1NSBBNSw1IDAgMCwxIDAsNjAgTDAsNjUgQTIsIDIgMCAwLDAgMiw2NyBMMTAsNjcgQTIsIDIgMCAwLDAgMTIsNjUgTDEyLDYwIEE4LDggMCAwLDEgMjAsNTIgTDI1LDUwIFoiPgogICAgICA8YW5pbWF0ZVRyYW5zZm9ybSBhdHRyaWJ1dGVOYW1lPSJ0cmFuc2Zvcm0iIHR5cGU9InJvdGF0ZSIgZnJvbT0iMCA1MCA1MCIgdG89IjM2MCA1MCA1MCIgZHVyPSIxMHMiIHJlcGVhdENvdW50PSJpbmRlZmluaXRlIiAvPgogICAgPC9wYXRoPgogICAgPHBhdGggZD0iTTkwLDUwIEE4LDggMCAwLDEgOTgsNTggTDk4LDY1IEE4LDggMCAwLDEgOTAsNzMgTDUwLDczIEE4LDggMCAwLDEgNDIsNjUgTDQwLDYwIEE1LDUgMCAwLDEgNDUsNTUgTDYwLDU1IEE1LDUgMCAwLDEgNjUsNjAgTDY1LDY1IEEyLCAyIDAgMCwwIDY3LDY3IEw3NSw2NyBBMiwgMiAwIDAsIDAgNzcsNjUgTDc3LDYwIEE4LDggMCAwLDEgODUsNTIgTDkwLDUwIFoiPgogICAgICA8YW5pbWF0ZVRyYW5zZm9ybSBhdHRyaWJ1dGVOYW1lPSJ0cmFuc2Zvcm0iIHR5cGU9InJvdGF0ZSIgZnJvbT0iMCA1MCA1MCIgdG89IjM2MCA1MCA1MCIgZHVyPSIxNXMiIHJlcGVhdENvdW50PSJpbmRlZmluaXRlIiAvPgogICAgPC9wYXRoPgogICAgPHBhdGggZD0iTTE1NSw1MCBBOCw4IDAgMCwxIDE2Myw1OCBMMTY1LDY1IEE4LDggMCAwLDEgMTU3LDczIEwxMTUsNzMgQTgsOCAwIDAsIDEgMTA3LDY1IEwxMDUsNjAgQTUsNSAwIDAsIDEgMTEwLDU1IEwxMjUsNTUgQTUsNSAwIDAsIDEgMTMwLDYwIEwxMzAsNjUgQTIsIDIgMCAwLDAgMTMyLDY3IEwxNDAsNjcgQTIsIDIgMCAwLDAgMTQyLDY1IEwxNDIsNjAgQTgsOCAwIDAsIDEgMTUwLDUyIEwxNTUsNTAgWiI+CiAgICAgIDxhbmltYXRlVHJhbnNmb3JtIGF0dHJpYnV0ZU5hbWU9InRyYW5zZm9ybSIgdHlwZT0icm90YXRlIiBmcm9tPSIwIDUwIDUwIiB0bz0iMzYwIDUwIDUwIiBkdXI9IjIwcyIgcmVwZWF0Q291bnQ9ImluZGVmaW5pdGUiIC8+CiAgICA8L3BhdGg+CiAgICA8cGF0aCBkPSJNMjIwLDUwIEE4LDggMCAwLDEgMjI4LDU4IEwyMzAsNjUgQTgsOCAwIDAsIDEgMjIyLDczIEwxODAsNzMgQTgsOCAwIDAsIDEgMTcyLDY1IEwxNzAsNjAgQTUsNSAwIDAsIDEgMTc1LDU1IEwxOTAsNTUgQTUsNSAwIDAsIDEgMTk1LDYwIEwxOTUsNjUgQTIsIDIgMCAwLDAgMTk3LDY3IEwyMDUsNjcgQTIsIDIgMCAwLDAgMjA3LDY1IEwyMDcsNjAgQTgsOCAwIDAsIDEgMjE1LDUyIEwyMjAsNTAgWiI+CiAgICAgIDxhbmltYXRlVHJhbnNmb3JtIGF0dHJpYnV0ZU5hbWU9InRyYW5zZm9ybSIgdHlwZT0icm90YXRlIiBmcm9tPSIwIDUwIDUwIiB0bz0iMzYwIDUwIDUwIiBkdXI9IjI1cyIgcmVwZWF0Q291bnQ9ImluZGVmaW5pdGUiIC8+CiAgICA8L3BhdGg+CiAgPC9nPgo8L3N2Zz4=');
            background-repeat: repeat;
        }
        
        .profile-avatar {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            background-color: var(--primary-light);
            border: 4px solid white;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-top: -45px;
            position: relative;
            font-weight: 600;
            font-size: 24px;
            color: var(--primary-color);
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .profile-name {
            font-size: 18px;
            font-weight: 600;
            color: var(--text-primary);
            margin-top: 12px;
            text-align: center;
            line-height: 1.2;
        }
        
        .profile-title {
            font-size: 12px;
            color: var(--text-secondary);
            margin-top: 4px;
            text-align: center;
            padding: 0 20px;
        }
        
        .profile-badge {
            display: inline-block;
            padding: 4px 10px;
            background-color: var(--primary-light);
            color: var(--primary-color);
            border-radius: 12px;
            font-size: 12px;
            margin-top: 10px;
            font-weight: 500;
        }
        
        .profile-badge i {
            margin-right: 4px;
            font-size: 10px;
        }
        
        .nav-menu {
            list-style-type: none;
            padding: 0 20px;
            margin-top: 20px;
        }
        
        .nav-item {
            margin-bottom: 10px;
        }
        
        .nav-link {
            display: flex;
            align-items: center;
            padding: 10px 15px;
            border-radius: 6px;
            text-decoration: none;
            color: var(--text-secondary);
            transition: all 0.2s;
            cursor: pointer;
        }
        
        .nav-link i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }
        
        .nav-link.active {
            background-color: var(--primary-light);
            color: var(--primary-color);
            font-weight: 500;
        }
        
        .nav-link:hover:not(.active) {
            background-color: var(--bg-secondary);
            color: var(--primary-dark);
        }
        
        /* Main Content */
        .content {
            margin-left: 220px;
            padding: 30px;
            transition: all 0.3s;
        }
        
        /* Page header */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }
        
        .page-title-section {
            display: flex;
            flex-direction: column;
        }
        
        .page-title {
            font-size: 24px;
            font-weight: 600; 
            color: var(--primary-color);
            margin-bottom: 4px;
        }
        
        .page-subtitle {
            color: var(--text-secondary);
            font-size: 14px;
        }
        
        /* Card styles */
        .card {
            background-color: var(--bg-color);
            border-radius: 8px;
            border: 1px solid var(--border-color);
            overflow: hidden;
            margin-bottom: 20px;
            box-shadow: 0 2px 6px rgba(77, 171, 247, 0.04);
        }
        
        .card-header {
            padding: 15px 20px;
            font-weight: 600;
            color: var(--primary-color);
            border-bottom: 1px solid var(--border-color);
            background-color: var(--primary-light);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .card-body {
            padding: 20px;
        }
        
        /* Form styles */
        .form-label {
            font-weight: 500;
            color: var(--text-primary);
            font-size: 14px;
            margin-bottom: 6px;
        }
        
        .required::after {
            content: " *";
            color: #dc3545;
        }
        
        .form-control, .form-select {
            border: 1px solid var(--border-color);
            border-radius: 6px;
            font-size: 14px;
            padding: 8px 12px;
            transition: all 0.2s;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.25rem rgba(77, 171, 247, 0.25);
        }
        
        /* Button Styles */
        .btn {
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.2s;
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }
        
        .btn-primary:hover {
            background-color: var(--primary-dark);
            border-color: var(--primary-dark);
        }
        
        .btn-outline-primary {
            color: var(--primary-color);
            border-color: var(--primary-color);
        }
        
        .btn-outline-primary:hover {
            background-color: var(--primary-light);
            color: var(--primary-color);
        }
        
        .btn-outline-secondary {
            color: var(--text-secondary);
            border-color: var(--border-color);
        }
        
        .btn-outline-secondary:hover {
            background-color: var(--primary-light);
            color: var(--primary-color);
            border-color: var(--primary-color);
        }
        
        /* Schedule item */
        .schedule-item {
            background-color: var(--bg-secondary);
            border-radius: 8px;
            border: 1px solid var(--border-color);
            margin-bottom: 15px;
        }
        
        /* Toggle Sidebar Button */
        .toggle-sidebar {
            display: none;
            position: fixed;
            top: 20px;
            left: 20px;
            z-index: 1001;
            background-color: var(--bg-color);
            color: var(--primary-color);
            border: 1px solid var(--border-color);
            border-radius: 6px;
            width: 40px;
            height: 40px;
            cursor: pointer;
            transition: all 0.3s;
            align-items: center;
            justify-content: center;
        }
        
        .toggle-sidebar:hover {
            background-color: var(--primary-light);
        }
        
        .sidebar-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(0, 0, 0, 0.2);
            z-index: 999;
            backdrop-filter: blur(2px);
        }
        
        /* Responsive Styles */
        @media (max-width: 991px) {
            .sidebar {
                width: 200px;
            }
            .content {
                margin-left: 200px;
            }
        }
        
        @media (max-width: 768px) {
            .toggle-sidebar {
                display: flex;
            }
            
            .sidebar {
                transform: translateX(-100%);
            }
            
            .sidebar.active {
                transform: translateX(0);
            }
            
            .sidebar-overlay.active {
                display: block;
            }
            
            .content {
                margin-left: 0;
                padding: 20px;
            }
            
            .page-header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .page-header-actions {
                margin-top: 15px;
            }
        }
        
        @media (max-width: 576px) {
            .content {
                padding: 15px;
            }
        }
    </style>
</head>
<body>
    <button class="toggle-sidebar" onclick="toggleSidebar()">
        <i class="fas fa-bars"></i>
    </button>
    
    <div class="sidebar-overlay" id="sidebar-overlay" onclick="toggleSidebar()"></div>
    
    <div class="sidebar" id="sidebar">
        <!-- Updated LinkedIn-style profile section -->
        <div class="profile-section">
            <div class="profile-background"></div>
            <div class="profile-avatar">A</div>
            <div class="profile-name">Admin</div>
            <div class="profile-title">System Administrator</div>
            <div class="profile-badge">
                <i class="fas fa-circle"></i> Admin Portal
            </div>
        </div>
        
        <ul class="nav-menu">
            <li class="nav-item">
                <a onclick="navigateTo('Admin/Dashboard')" class="nav-link">
                    <i class="fas fa-home"></i> Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a onclick="navigateTo('Admin/Patients')" class="nav-link">
                    <i class="fas fa-user-injured"></i> Patients
                </a>
            </li>
            <li class="nav-item">
                <a onclick="navigateTo('Admin/Doctors')" class="nav-link active">
                    <i class="fas fa-user-md"></i> Doctors
                </a>
            </li>
            <li class="nav-item">
                <a onclick="navigateTo('Admin/Appointments')" class="nav-link">
                    <i class="fas fa-calendar-check"></i> Appointments
                </a>
            </li>
            <li class="nav-item">
                <a onclick="window.location.href='${pageContext.request.contextPath}/LogoutServlet'" class="nav-link">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </li>
        </ul>
    </div>

    <div class="content">
        <!-- Page Header -->
        <div class="page-header">
            <div class="page-title-section">
                <h1 class="page-title">New Doctor Registration</h1>
            </div>
            <div class="page-header-actions">
                <button class="btn btn-outline-primary" onclick="navigateTo('Admin/Doctors')">
                    <i class="fas fa-arrow-left me-2"></i> Back to Doctor List
                </button>
            </div>
        </div>

        <form id="addDoctorForm" action="Admin/SaveDoctor" method="post" class="needs-validation" novalidate>
            <!-- Personal Information -->
            <div class="card">
                <div class="card-header">
                    <div><i class="fas fa-user me-2"></i> Personal Information</div>
                </div>
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label for="firstName" class="form-label required">First Name</label>
                            <input type="text" class="form-control" id="firstName" name="firstName" required>
                            <div class="invalid-feedback">Please enter first name</div>
                        </div>
                        <div class="col-md-6">
                            <label for="lastName" class="form-label required">Last Name</label>
                            <input type="text" class="form-control" id="lastName" name="lastName" required>
                            <div class="invalid-feedback">Please enter last name</div>
                        </div>
                        <div class="col-md-6">
                            <label for="email" class="form-label required">Email</label>
                            <input type="email" class="form-control" id="email" name="email" required>
                            <div class="invalid-feedback">Please enter a valid email</div>
                        </div>
                        <div class="col-md-6">
                            <label for="phone" class="form-label required">Phone Number</label>
                            <input type="tel" class="form-control" id="phone" name="phone" required>
                            <div class="invalid-feedback">Please enter phone number</div>
                        </div>
                        <div class="col-md-6">
                            <label for="dateOfBirth" class="form-label required">Date of Birth</label>
                            <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth" required>
                            <div class="invalid-feedback">Please select a DOB</div>
                        </div>
                        <div class="col-md-6">
                            <label for="gender" class="form-label required">Gender</label>
                            <select class="form-select" id="gender" name="gender" required>
                                <option value="">Select Gender</option>
                                <option value="male">Male</option>
                                <option value="female">Female</option>
                                <option value="other">Other</option>
                            </select>
                            <div class="invalid-feedback">Please select a Gender</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Professional Information -->
            <div class="card">
                <div class="card-header">
                    <div><i class="fas fa-briefcase-medical me-2"></i> Professional Information</div>
                </div>
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label for="licenseNumber" class="form-label required">License Number</label>
                            <input type="text" class="form-control" id="licenseNumber" name="licenseNumber" required>
                            <div class="invalid-feedback">Please enter license number</div>
                        </div>
                        <div class="col-md-6">
                            <label for="experience" class="form-label required">Years of Experience</label>
                            <input type="number" class="form-control" id="experience" name="experience" min="0" required>
                            <div class="invalid-feedback">Please enter years of experience</div>
                        </div>
                        <div class="col-md-6">
                            <label for="specialization" class="form-label required">Specialization</label>
                            <select class="form-select" id="specialization" name="specialization" required>
                                <option value="">Select Specialization</option>
                                <option value="Cardiology">Cardiology</option>
                                <option value="Neurology">Neurology</option>
                                <option value="Orthopedics">Orthopedics</option>
                                <option value="Pediatrics">Pediatrics</option>
                                <option value="Dermatology">Dermatology</option>
                                <option value="Oncology">Oncology</option>
                                <option value="Gynecology">Gynecology</option>
                                <option value="Ophthalmology">Ophthalmology</option>
                            </select>
                            <div class="invalid-feedback">Please select a specialization</div>
                        </div>
                        <div class="col-md-6">
                            <label for="designation" class="form-label required">Degree</label>
                            <input type="text" class="form-control" id="designation" name="designation" required>
                            <div class="invalid-feedback">Please enter designation</div>
                        </div>
                        <div class="col-md-12">
                            <label for="qualifications" class="form-label">Qualifications</label>
                            <textarea class="form-control" id="qualifications" name="qualifications" rows="3"></textarea>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Account Information -->
            <div class="card">
                <div class="card-header">
                    <div><i class="fas fa-lock me-2"></i> Account Information</div>
                </div>
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label for="username" class="form-label required">Username</label>
                            <input type="text" class="form-control" id="username" name="username" required>
                            <div class="invalid-feedback">Please enter username</div>
                        </div>
                        <div class="col-md-6">
                            <label for="password" class="form-label required">Password</label>
                            <input type="password" class="form-control" id="password" name="password" required>
                            <div class="invalid-feedback">Please enter password</div>
                        </div>
                        <div class="col-md-6">
                            <label for="confirmPassword" class="form-label required">Confirm Password</label>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                            <div class="invalid-feedback">Passwords do not match</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Schedule Information -->
            <div class="card">
                <div class="card-header">
                    <div><i class="fas fa-calendar-alt me-2"></i> Schedule Information</div>
                </div>
                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col-12">
                            <div class="d-flex justify-content-between align-items-center">
                                <h6 class="mb-0 text-primary">Weekly Schedule</h6>
                                <button type="button" class="btn btn-sm btn-outline-primary" onclick="addNewSchedule()">
                                    <i class="fas fa-plus-circle"></i> Add Schedule
                                </button>
                            </div>
                            <hr class="mt-2">
                        </div>
                    </div>
                    
                    <div id="scheduleContainer">
                        <div class="schedule-item p-3 mb-3">
                            <div class="row g-3">
                                <div class="col-md-4">
                                    <label for="dayOfWeek0" class="form-label required">Day of Week</label>
                                    <select class="form-select" id="dayOfWeek0" name="dayOfWeek[]" required>
                                        <option value="">Select Day</option>
                                        <option value="1">Monday</option>
                                        <option value="2">Tuesday</option>
                                        <option value="3">Wednesday</option>
                                        <option value="4">Thursday</option>
                                        <option value="5">Friday</option>
                                        <option value="6">Saturday</option>
                                        <option value="0">Sunday</option>
                                    </select>
                                    <div class="invalid-feedback">Please select a day</div>
                                </div>
                                <div class="col-md-4">
                                    <label for="startTime0" class="form-label required">Start Time</label>
                                    <input type="time" class="form-control" id="startTime0" name="startTime[]" required>
                                    <div class="invalid-feedback">Please select start time</div>
                                </div>
                                <div class="col-md-4">
                                    <label for="endTime0" class="form-label required">End Time</label>
                                    <input type="time" class="form-control" id="endTime0" name="endTime[]" required>
                                    <div class="invalid-feedback">Please select end time</div>
                                </div>
                                <div class="col-md-6">
                                    <label for="maxTokens0" class="form-label required">Max Tokens</label>
                                    <input type="number" class="form-control" id="maxTokens0" name="maxTokens[]" min="1" required>
                                    <div class="invalid-feedback">Please enter max tokens</div>
                                </div>
                                <div class="col-md-6">
                                    <label for="isAvailable0" class="form-label">Availability</label>
                                    <select class="form-select" id="isAvailable0" name="isAvailable[]">
                                        <option value="true" selected>Available</option>
                                        <option value="false">Not Available</option>
                                    </select>
                                </div>
                                <div class="col-12">
                                    <button type="button" class="btn btn-sm btn-outline-danger remove-schedule" style="display: none;">
                                        <i class="fas fa-trash"></i> Remove
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Form Actions -->
            <div class="d-flex justify-content-between mb-4">
                <button type="button" class="btn btn-outline-secondary" onclick="navigateTo('Admin/Doctors')">
                    <i class="fas fa-times me-2"></i> Cancel
                </button>
                <div>
                    <button type="reset" class="btn btn-outline-primary me-2">
                        <i class="fas fa-redo me-2"></i> Reset
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-2"></i> Save Doctor
                    </button>
                </div>
            </div>
        </form>
    </div>

    <!-- Bootstrap & jQuery JS -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Function to update date and time
        function updateDateTime() {
            const now = new Date();
            
            // Format the date: Weekday, Month Day, Year
            const options = { 
                weekday: 'long', 
                year: 'numeric', 
                month: 'long', 
                day: 'numeric',
                hour: '2-digit',
                minute: '2-digit'
            };
            
            const formattedDateTime = now.toLocaleDateString('en-US', options);
            document.getElementById('current-datetime').textContent = formattedDateTime;
        }
        
        // Update date and time when page loads
        updateDateTime();
        
        // Update date and time every minute
        setInterval(updateDateTime, 60000);
        
        function toggleSidebar() {
            document.getElementById("sidebar").classList.toggle("active");
            document.getElementById("sidebar-overlay").classList.toggle("active");
        }
        
        function navigateTo(page) {
        	const contextPath = '${pageContext.request.contextPath}';
            window.location.href = contextPath + '/' + page;
        }
        
        // Handle responsive behavior
        window.addEventListener('resize', function() {
            if (window.innerWidth > 768) {
                document.getElementById("sidebar").classList.remove("active");
                document.getElementById("sidebar-overlay").classList.remove("active");
            }
        });
        
        // Form validation
        (function() {
            'use strict'
            
            // Fetch all forms that need validation
            const forms = document.querySelectorAll('.needs-validation');
            
            // Loop over them and prevent submission
            Array.from(forms).forEach(function(form) {
                form.addEventListener('submit', function(event) {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    } else {
                        // Check if passwords match
                        const password = document.getElementById('password');
                        const confirmPassword = document.getElementById('confirmPassword');
                        
                        if (password.value !== confirmPassword.value) {
                            confirmPassword.setCustomValidity('Passwords do not match');
                            event.preventDefault();
                            event.stopPropagation();
                        } else {
                            confirmPassword.setCustomValidity('');
                        }
                    }
                    
                    form.classList.add('was-validated');
                }, false);
            });
        })();
        
        // Clear custom validity when typing in confirm password field
        document.getElementById('confirmPassword').addEventListener('input', function() {
            const password = document.getElementById('password');
            const confirmPassword = document.getElementById('confirmPassword');
            
            if (password.value !== confirmPassword.value) {
                confirmPassword.setCustomValidity('Passwords do not match');
            } else {
                confirmPassword.setCustomValidity('');
            }
        });
        
        // License number validation - allow only alphanumeric characters
        document.getElementById('licenseNumber').addEventListener('input', function() {
            this.value = this.value.replace(/[^a-zA-Z0-9]/g, '');
        });
        
        // Phone number validation - allow only numbers and some special characters
        document.getElementById('phone').addEventListener('input', function() {
            this.value = this.value.replace(/[^0-9+\-() ]/g, '');
        });
        
        // Username validation - allow only alphanumeric characters and underscores
        document.getElementById('username').addEventListener('input', function() {
            this.value = this.value.replace(/[^a-zA-Z0-9_]/g, '');
        });
        
     // Wait for the DOM to be fully loaded
        document.addEventListener('DOMContentLoaded', function() {
            // Initialize the Add Schedule button
            const addScheduleBtn = document.getElementById('addScheduleBtn');
            if (addScheduleBtn) {
                addScheduleBtn.addEventListener('click', addNewSchedule);
            }
            
            // Initialize the first Remove button
            const initialRemoveBtn = document.querySelector('.remove-schedule');
            if (initialRemoveBtn) {
                initialRemoveBtn.addEventListener('click', function() {
                    const container = document.getElementById('scheduleContainer');
                    if (container && container.querySelectorAll('.schedule-item').length > 1) {
                        this.closest('.schedule-item').remove();
                    }
                });
            }
        });

        let scheduleCounter = 1;

        // Function to add a new schedule
        function addNewSchedule() {
            const container = document.getElementById('scheduleContainer');
            if (!container) return;
            
            const newSchedule = document.createElement('div');
            newSchedule.className = 'schedule-item p-3 mb-3';
            
            newSchedule.innerHTML = `
                <div class="row g-3">
                    <div class="col-md-4">
                        <label for="dayOfWeek${scheduleCounter}" class="form-label required">Day of Week</label>
                        <select class="form-select" id="dayOfWeek${scheduleCounter}" name="dayOfWeek[]" required>
                            <option value="">Select Day</option>
                            <option value="1">Monday</option>
                            <option value="2">Tuesday</option>
                            <option value="3">Wednesday</option>
                            <option value="4">Thursday</option>
                            <option value="5">Friday</option>
                            <option value="6">Saturday</option>
                            <option value="0">Sunday</option>
                        </select>
                        <div class="invalid-feedback">Please select a day</div>
                    </div>
                    <div class="col-md-4">
                        <label for="startTime${scheduleCounter}" class="form-label required">Start Time</label>
                        <input type="time" class="form-control" id="startTime${scheduleCounter}" name="startTime[]" required>
                        <div class="invalid-feedback">Please select start time</div>
                    </div>
                    <div class="col-md-4">
                        <label for="endTime${scheduleCounter}" class="form-label required">End Time</label>
                        <input type="time" class="form-control" id="endTime${scheduleCounter}" name="endTime[]" required>
                        <div class="invalid-feedback">Please select end time</div>
                    </div>
                    <div class="col-md-6">
                        <label for="maxTokens${scheduleCounter}" class="form-label required">Max Tokens</label>
                        <input type="number" class="form-control" id="maxTokens${scheduleCounter}" name="maxTokens[]" min="1" required>
                        <div class="invalid-feedback">Please enter max tokens</div>
                    </div>
                    <div class="col-md-6">
                        <label for="isAvailable${scheduleCounter}" class="form-label">Availability</label>
                        <select class="form-select" id="isAvailable${scheduleCounter}" name="isAvailable[]">
                            <option value="true" selected>Available</option>
                            <option value="false">Not Available</option>
                        </select>
                    </div>
                    <div class="col-12">
                        <button type="button" class="btn btn-sm btn-outline-danger remove-schedule">
                            <i class="fas fa-trash"></i> Remove
                        </button>
                    </div>
                </div>
            `;
            
            container.appendChild(newSchedule);
            
            // Show the remove button for the first schedule once there are multiple schedules
            if (container.querySelectorAll('.schedule-item').length > 1) {
                const firstRemoveBtn = document.querySelector('.schedule-item .remove-schedule');
                if (firstRemoveBtn) {
                    firstRemoveBtn.style.display = 'inline-block';
                }
            }
            
            // Add event listener to the new remove button
            const newRemoveBtn = newSchedule.querySelector('.remove-schedule');
            if (newRemoveBtn) {
                newRemoveBtn.addEventListener('click', function() {
                    container.removeChild(newSchedule);
                    
                    // Hide the remove button for the first schedule if only one remains
                    if (container.querySelectorAll('.schedule-item').length === 1) {
                        const firstRemoveBtn = document.querySelector('.schedule-item .remove-schedule');
                        if (firstRemoveBtn) {
                            firstRemoveBtn.style.display = 'none';
                        }
                    }
                });
            }
            
            scheduleCounter++;
        }
    </script>
</body>
</html>