<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Available Doctors</title>
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
            overflow: hidden;
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
            flex-direction: column;
            margin-bottom: 24px;
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
            margin-bottom: 30px;
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
        
        /* Filter section */
        .filter-container {
            padding: 15px 20px;
            border-bottom: 1px solid var(--border-color);
            background-color: var(--bg-secondary);
        }
        
        .filter-item {
            margin-bottom: 0;
        }
        
        .filter-label {
            font-weight: 500;
            margin-bottom: 5px;
            color: var(--text-secondary);
            font-size: 13px;
        }
        
        .search-box {
            position: relative;
        }
        
        .search-box .search-icon {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-secondary);
            z-index: 2;
        }
        
        .search-box input {
            padding-left: 35px;
            border-radius: 6px;
            border: 1px solid var(--border-color);
            font-size: 13px;
            height: 38px;
        }
        
        .form-control, .form-select {
            border: 1px solid var(--border-color);
            border-radius: 6px;
            font-size: 13px;
            height: 38px;
        }
        
        /* Table styles */
        .doctors-table {
            width: 100%;
            margin-bottom: 0;
        }
        
        .doctors-table th {
            padding: 12px 16px;
            font-weight: 600;
            color: var(--text-primary);
            background-color: var(--bg-secondary);
            border-bottom: 1px solid var(--border-color);
            white-space: nowrap;
            cursor: pointer;
        }
        
        .doctors-table th i {
            margin-left: 5px;
            font-size: 12px;
        }
        
        .doctors-table td {
            padding: 12px 16px;
            vertical-align: middle;
            border-bottom: 1px solid var(--border-color);
        }
        
        .doctors-table tr:last-child td {
            border-bottom: none;
        }
        
        .doctors-table tbody tr {
            transition: all 0.2s;
        }
        
        .doctors-table tbody tr:hover {
            background-color: var(--primary-light);
        }
        
        /* Doctor Info */
        .doctor-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .doctor-avatar {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 500;
            font-size: 12px;
            color: white;
        }
        
        /* Badge for specialty */
        .badge-specialty {
            background-color: rgba(47, 128, 237, 0.1);
            color: #2f80ed;
            padding: 5px 10px;
            border-radius: 4px;
            font-weight: 500;
            font-size: 12px;
            display: inline-block;
        }
        
        /* Button styles */
        .btn {
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.2s;
        }
        
        .btn-sm {
            padding: 5px 10px;
            font-size: 12px;
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }
        
        .btn-primary:hover {
            background-color: var(--primary-dark);
            border-color: var(--primary-dark);
        }
        
        .btn-success {
            background-color: #28a745;
            border-color: #28a745;
        }
        
        .btn-success:hover {
            background-color: #218838;
            border-color: #1e7e34;
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
        @media (max-width: 1200px) {
            .doctors-table {
                display: block;
                overflow-x: auto;
            }
        }
        
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
            
            .filter-container .row {
                flex-direction: column;
            }
            
            .filter-container .col-md-3 {
                margin-bottom: 10px;
                width: 100%;
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
            <div class="profile-avatar">
                ${fn:substring(sessionScope.username, 0, 1)}
            </div>
            <div class="profile-name">${sessionScope.username}</div>
            <div class="profile-title">Patient</div>
            <div class="profile-badge">
                <i class="fas fa-circle"></i> Active Member
            </div>
        </div>
        
        <ul class="nav-menu">
            <li class="nav-item">
                <a onclick="navigateTo('Patient/Dashboard')" class="nav-link">
                    <i class="fas fa-home"></i> Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a onclick="navigateTo('Patient/Appointments')" class="nav-link">
                    <i class="fas fa-calendar-check"></i> Appointments
                </a>
            </li>
            <li class="nav-item">
                <a onclick="navigateTo('Patient/Doctors')" class="nav-link active">
                    <i class="fas fa-user-md"></i> Doctors
                </a>
            </li>
            <li class="nav-item">
                <a onclick="navigateTo('Patient/Profile')" class="nav-link">
                    <i class="fas fa-user"></i> Profile
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
            <h1 class="page-title">Available Doctors</h1>
        </div>
        
        <!-- Doctors Table Card -->
        <div class="card mb-4">
            
            <!-- Filter Controls -->
            <div class="filter-container">
                <div class="row align-items-end">
                    <!-- Text filter for doctor name or specialty -->
                    <div class="col-md-6">
                        <div class="filter-item">
                            <div class="filter-label">
                                <i class="fas fa-search me-1"></i> Search Doctors
                            </div>
                            <div class="search-box">
                                <i class="fas fa-search search-icon"></i>
                                <input type="text" id="doctorSearch" class="form-control" 
                                       placeholder="Search by name, specialty or qualifications..." 
                                       onkeyup="searchDoctors()">
                            </div>
                        </div>
                    </div>
                    
                    <!-- Specialty filter dropdown - optional enhancement -->
                    <div class="col-md-4">
                        <div class="filter-item">
                            <div class="filter-label">
                                <i class="fas fa-filter me-1"></i> Filter by Specialty
                            </div>
                            <select id="specialtyFilter" class="form-select" onchange="searchDoctors()">
                                <option value="">All Specialties</option>
                                <!-- Could be populated dynamically with available specialties -->
                                <option value="Cardiology">Cardiology</option>
                                <option value="Dermatology">Dermatology</option>
                                <option value="Neurology">Neurology</option>
                                <option value="Orthopedics">Orthopedics</option>
                                <option value="Pediatrics">Pediatrics</option>
                                <option value="Psychiatry">Psychiatry</option>
                                <option value="Gynecology">Gynecology</option>
                                <option value="Dentistry">Dentistry</option>
                            </select>
                        </div>
                    </div>
                    
                    <!-- Reset Filters Button -->
                    <div class="col-md-2">
                        <div class="filter-item">
                            <button class="btn btn-outline-secondary w-20" onclick="resetFilters()">
                                <i class="fas fa-redo-alt me-1"></i> 
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Doctors Table -->
            <div class="table-responsive">
                <table class="doctors-table" id="doctorsTable">
                    <thead>
                        <tr>
                            <th onclick="sortTable(0)">Doctor</th>
                            <th onclick="sortTable(1)">Specialty</th>
                            <th onclick="sortTable(2)">Experience</th>
                            <th onclick="sortTable(3)">Qualifications</th>
                            <th onclick="sortTable(4)">Contact</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${doctors}" var="doctorInfo" varStatus="status">
                            <c:set var="doctorParts" value="${fn:split(doctorInfo, '|')}" />
                            <c:set var="doctorId" value="${fn:trim(fn:substringAfter(doctorParts[0], 'ID:'))}" />
                            <c:set var="doctorName" value="${fn:trim(doctorParts[1])}" />
                            <c:set var="specialty" value="${fn:trim(doctorParts[2])}" />
                            <c:set var="experience" value="${fn:trim(doctorParts[3])}" />
                            <c:set var="degree" value="${fn:trim(doctorParts[4])}" />
                            <c:set var="contact" value="${fn:trim(doctorParts[5])}" />
                            <c:set var="email" value="${fn:trim(doctorParts[6])}" />
                            
                            <tr class="doctor-row" 
                                data-doctor="${doctorName}" 
                                data-specialty="${specialty}" 
                                data-qualifications="${degree}">
                                <td>
                                    <div class="doctor-info">
                                        <div class="doctor-avatar" style="background-color: hsl(${(status.index * 40) % 360}, 70%, 60%)">
                                            ${fn:substring(doctorName, 0, 1)}
                                        </div>
                                        ${doctorName}
                                    </div>
                                </td>
                                <td>
                                    <span class="badge-specialty">${specialty}</span>
                                </td>
                                <td>${experience}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${fn:length(degree) > 20}">
                                            <div class="d-inline-block text-truncate" style="max-width: 150px;" title="${degree}">
                                                ${degree}
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            ${degree}
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${contact}</td>
                                <td>
                                    <button class="btn btn-success btn-sm" onclick="bookAppointment(${doctorId})">
                                        <i class="fas fa-calendar-plus me-1"></i> Book Appointment
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty doctors}">
                            <tr id="no-doctors-row">
                                <td colspan="6" class="text-center py-4">
                                    <div class="alert alert-info mb-0">
                                        <i class="fas fa-info-circle me-2"></i>
                                        No doctors are available at the moment.
                                    </div>
                                </td>
                            </tr>
                        </c:if>
                        
                        <!-- No results row (hidden by default) -->
                        <tr id="no-results-row" style="display: none;">
                            <td colspan="6" class="text-center py-4">
                                <div class="alert alert-warning mb-0">
                                    <i class="fas fa-filter me-2"></i>
                                    No doctors match your search.
                                    <button class="btn btn-sm btn-link" onclick="resetFilters()">Reset filters</button>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap & jQuery JS -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Function to toggle sidebar on mobile
    function toggleSidebar() {
        document.getElementById("sidebar").classList.toggle("active");
        document.getElementById("sidebar-overlay").classList.toggle("active");
    }
    
    // Function to navigate to different pages
    function navigateTo(page) {
        const contextPath = '${pageContext.request.contextPath}';
        window.location.href = contextPath + '/' + page;
    }
    
    // Function to book an appointment with a doctor
    function bookAppointment(doctorId) {
        window.location.href = "${pageContext.request.contextPath}/Patient/BookAppointment?doctorId=" + doctorId;
    }
    
    // Search doctors function - filters the table
    function searchDoctors() {
        const searchText = document.getElementById('doctorSearch').value.toLowerCase();
        const specialtyFilter = document.getElementById('specialtyFilter').value;
        
        const rows = document.querySelectorAll('.doctor-row');
        let visibleCount = 0;
        
        rows.forEach(row => {
            const doctorName = row.getAttribute('data-doctor').toLowerCase();
            const specialty = row.getAttribute('data-specialty');
            const qualifications = row.getAttribute('data-qualifications').toLowerCase();
            
            // Check if row matches search text (doctor name, specialty, or qualifications)
            const textMatch = !searchText || 
                            doctorName.includes(searchText) || 
                            qualifications.includes(searchText) ||
                            specialty.toLowerCase().includes(searchText);
            
            // Check if row matches specialty filter
            const specialtyMatch = !specialtyFilter || specialty === specialtyFilter;
            
            // Show/hide row based on filters
            if (textMatch && specialtyMatch) {
                row.style.display = "";
                visibleCount++;
            } else {
                row.style.display = "none";
            }
        });
        
        // Show/hide no results message
        const noResultsRow = document.getElementById('no-results-row');
        if (noResultsRow) {
            if (visibleCount === 0 && rows.length > 0) {
                noResultsRow.style.display = "";
            } else {
                noResultsRow.style.display = "none";
            }
        }
    }
    
    // Reset filters function
    function resetFilters() {
        document.getElementById('doctorSearch').value = "";
        document.getElementById('specialtyFilter').value = "";
        
        // Reset the table
        const rows = document.querySelectorAll('.doctor-row');
        rows.forEach(row => {
            row.style.display = "";
        });
        
        // Hide no results message
        const noResultsRow = document.getElementById('no-results-row');
        if (noResultsRow) {
            noResultsRow.style.display = "none";
        }
        
        // Reset sort indicators
        const headers = document.querySelectorAll('th i');
        headers.forEach(icon => {
            icon.className = 'fas fa-sort';
        });
        
        currentSortColumn = -1;
        sortDirection = 1;
    }
    
    // Sort table function
    let currentSortColumn = -1;
    let sortDirection = 1; // 1 for ascending, -1 for descending
    
    function sortTable(columnIndex) {
        const table = document.getElementById('doctorsTable');
        if (!table) return;
        
        const tbody = table.querySelector('tbody');
        const rows = Array.from(tbody.querySelectorAll('tr.doctor-row'));
        
        // Toggle sort direction if clicking the same column
        if (currentSortColumn === columnIndex) {
            sortDirection *= -1;
        } else {
            sortDirection = 1;
            currentSortColumn = columnIndex;
        }
        
        // Update sort icons
        const headers = table.querySelectorAll('th');
        headers.forEach(header => {
            const icon = header.querySelector('i');
            if (icon) {
                icon.className = 'fas fa-sort';
            }
        });
        
        const currentHeader = headers[columnIndex];
        const icon = currentHeader.querySelector('i');
        if (icon) {
            icon.className = sortDirection === 1 ? 'fas fa-sort-up' : 'fas fa-sort-down';
        }
        
        // Sort the rows
        rows.sort((a, b) => {
            let valueA, valueB;
            
            // Special handling for doctor name column (first column)
            if (columnIndex === 0) {
                valueA = a.getAttribute('data-doctor').toLowerCase();
                valueB = b.getAttribute('data-doctor').toLowerCase();
            }
            // Special handling for specialty column
            else if (columnIndex === 1) {
                valueA = a.getAttribute('data-specialty').toLowerCase();
                valueB = b.getAttribute('data-specialty').toLowerCase();
            }
            // Special handling for experience column (numeric sort)
            else if (columnIndex === 2) {
                valueA = a.cells[columnIndex].textContent.trim();
                valueB = b.cells[columnIndex].textContent.trim();
                
                // Extract numbers from experience (e.g., "5 years" -> 5)
                const numA = parseInt(valueA) || 0;
                const numB = parseInt(valueB) || 0;
                return sortDirection * (numA - numB);
            }
            // Special handling for qualifications column
            else if (columnIndex === 3) {
                valueA = a.getAttribute('data-qualifications').toLowerCase();
                valueB = b.getAttribute('data-qualifications').toLowerCase();
            }
            // Default text comparison for other columns
            else {
                valueA = a.cells[columnIndex].textContent.trim().toLowerCase();
                valueB = b.cells[columnIndex].textContent.trim().toLowerCase();
            }
            
            if (valueA < valueB) return -sortDirection;
            if (valueA > valueB) return sortDirection;
            return 0;
        });
        
        // Reappend rows in new order
        const specialRows = Array.from(tbody.querySelectorAll('tr:not(.doctor-row)'));
        tbody.innerHTML = '';
        
        rows.forEach(row => {
            tbody.appendChild(row);
        });
        
        specialRows.forEach(row => {
            tbody.appendChild(row);
        });
    }
    
    // Handle responsive behavior
    window.addEventListener('resize', function() {
        if (window.innerWidth > 768) {
            document.getElementById("sidebar").classList.remove("active");
            document.getElementById("sidebar-overlay").classList.remove("active");
        }
    });
</script>
</body>
</html>