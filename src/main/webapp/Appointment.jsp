<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointments</title>
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
            overflow: hidden;
        }
        
        .profile-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .profile-verification {
            position: absolute;
            bottom: 0;
            right: 0;
            width: 22px;
            height: 22px;
            background-color: var(--primary-color);
            border-radius: 50%;
            border: 2px solid white;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 10px;
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
        
        .profile-specialty {
            display: inline-block;
            padding: 4px 10px;
            background-color: var(--primary-light);
            color: var(--primary-color);
            border-radius: 12px;
            font-size: 12px;
            margin-top: 10px;
            font-weight: 500;
        }
        
        .profile-specialty i {
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
        
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        
        .title {
            font-size: 24px;
            font-weight: 600;
            color: var(--primary-color);
        }
        
        .date {
            color: var(--text-secondary);
            font-size: 14px;
        }
        
        /* Card and Table Styles */
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
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .card-body {
            padding: 0;
        }
        
        /* Table Styles */
        .table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-bottom: 0;
        }
        
        .table th {
            padding: 12px 15px;
            text-align: left;
            font-weight: 500;
            color: var(--text-secondary);
            border-bottom: 1px solid var(--border-color);
            background-color: var(--bg-secondary);
        }
        
        .table td {
            padding: 12px 15px;
            border-bottom: 1px solid var(--border-color);
            vertical-align: middle;
        }
        
        .table tbody tr:last-child td {
            border-bottom: none;
        }
        
        .table tbody tr {
            cursor: pointer;
            transition: background-color 0.2s;
        }
        
        .table tbody tr:hover {
            background-color: rgba(77, 171, 247, 0.03);
        }
        
        /* Patient/Appointment Avatar */
        .appointment-avatar {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 500;
            font-size: 12px;
            color: #fff;
        }
        
        /* Filter Bar */
        .filter-bar {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
            flex-wrap: wrap;
            align-items: center;
        }
        
        .search-box {
            position: relative;
            flex-grow: 1;
            max-width: 300px;
        }
        
        .search-box input {
            width: 100%;
            padding: 8px 12px;
            padding-left: 35px;
            border-radius: 6px;
            border: 1px solid var(--border-color);
            font-size: 14px;
        }
        
        .search-box i {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-secondary);
        }
        
        .filter-dropdown {
            min-width: 150px;
            padding: 8px 12px;
            border-radius: 6px;
            border: 1px solid var(--border-color);
            font-size: 14px;
            background-color: white;
        }
        
        .btn-filter {
            padding: 8px 16px;
            border-radius: 6px;
            font-weight: 500;
            font-size: 14px;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.2s;
        }
        
        .btn-reset {
            background-color: var(--bg-secondary);
            color: var(--text-secondary);
            border: 1px solid var(--border-color);
        }
        
        .btn-reset:hover {
            background-color: var(--border-color);
        }
        
        /* Status Badges */
        .badge-pending {
            background-color: rgba(242, 153, 74, 0.15);
            color: var(--pending-color);
            padding: 5px 10px;
            border-radius: 4px;
            font-weight: 500;
            font-size: 12px;
        }
        
        .badge-confirmed {
            background-color: rgba(33, 150, 83, 0.15);
            color: var(--confirmed-color);
            padding: 5px 10px;
            border-radius: 4px;
            font-weight: 500;
            font-size: 12px;
        }
        
        .badge-cancelled {
            background-color: rgba(235, 87, 87, 0.15);
            color: var(--cancelled-color);
            padding: 5px 10px;
            border-radius: 4px;
            font-weight: 500;
            font-size: 12px;
        }
        
        .badge-completed {
            background-color: rgba(47, 128, 237, 0.15);
            color: var(--completed-color);
            padding: 5px 10px;
            border-radius: 4px;
            font-weight: 500;
            font-size: 12px;
        }
        
        /* Responsive Styles */
        @media (max-width: 1200px) {
            .table {
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
            }
            
            .header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            
            .filter-bar {
                flex-direction: column;
                align-items: stretch;
            }
            
            .search-box {
                max-width: 100%;
            }
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
        
        /* Alert Container */
        .alert-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 2000;
            max-width: 350px;
        }
        
        .alert {
            border: none;
            border-radius: 6px;
            padding: 12px 15px;
            margin-bottom: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            display: flex;
            align-items: center;
            gap: 10px;
            transition: opacity 0.15s linear, transform 0.15s ease-out;
        }
        
        .alert.fade {
            opacity: 0;
            transform: translateY(-10px);
        }
        
        .alert.show {
            opacity: 1;
            transform: translateY(0);
        }
        
        .alert-success {
            background-color: rgba(33, 150, 83, 0.1);
            color: var(--confirmed-color);
        }
        
        .alert-danger {
            background-color: rgba(235, 87, 87, 0.1);
            color: var(--cancelled-color);
        }
        
        .alert-info {
            background-color: rgba(77, 171, 247, 0.1);
            color: var(--primary-color);
        }
    </style>
</head>
<body>
    <button class="toggle-sidebar" onclick="toggleSidebar()">
        <i class="fas fa-bars"></i>
    </button>
    
    <div class="sidebar-overlay" id="sidebar-overlay" onclick="toggleSidebar()"></div>
    
    <div class="sidebar" id="sidebar">
        <!-- Updated LinkedIn-style doctor profile section -->
        <div class="profile-section">
            <div class="profile-background"></div>
            <div class="profile-avatar">
                <c:choose>
                    <c:when test="${empty doctorImage}">
                        <!-- Show initials if no image is available -->
                        ${fn:substring(doctorName, 0, 1)}
                    </c:when>
                    <c:otherwise>
                        <!-- Show doctor image if available -->
                        <img src="${doctorImage}" alt="${doctorName}">
                    </c:otherwise>
                </c:choose>
                <div class="profile-verification">
                    <i class="fas fa-check"></i>
                </div>
            </div>
            <div class="profile-name">${doctorName}</div>
            <div class="profile-title">
                <c:if test="${not empty doctorQualification}">
                    ${doctorQualification} -
                </c:if>
                <c:if test="${not empty doctorSpecialty}">
                    ${doctorSpecialty}
                </c:if>
                <c:if test="${empty doctorQualification and empty doctorSpecialty}">
                    Medical Professional
                </c:if>
            </div>
            <div class="profile-specialty">
                <i class="fas fa-circle"></i> 
                <c:choose>
                    <c:when test="${not empty doctorRole}">
                        ${doctorRole}
                    </c:when>
                    <c:otherwise>
                        Dentist
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        
        <ul class="nav-menu">
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/Doctor/Dashboard" class="nav-link">
                    <i class="fas fa-chart-line"></i> Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/Doctor/Patient" class="nav-link">
                    <i class="fas fa-user-injured"></i> Patients
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/Doctor/Appointment" class="nav-link active">
                    <i class="fas fa-calendar-check"></i> Appointments
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/Doctor/Profile" class="nav-link">
                    <i class="fas fa-user-md"></i> Profile
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/LogoutServlet" class="nav-link">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </li>
        </ul>
    </div>

    <div class="content">
        <!-- Alert Container -->
        <div class="alert-container">
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger fade show" role="alert">
                    <i class="fas fa-exclamation-circle"></i>
                    <div>${errorMessage}</div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success fade show" role="alert">
                    <i class="fas fa-check-circle"></i>
                    <div>${successMessage}</div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
        </div>
        
        <!-- Filter Bar -->
        <div class="filter-bar">
            <div class="search-box">
                <i class="fas fa-search"></i>
                <input type="text" id="searchInput" placeholder="Search by patient name, contact or reason..." onkeyup="filterAppointments()">
            </div>
            
            <select class="filter-dropdown" id="statusFilter" onchange="filterAppointments()">
                <option value="">All Statuses</option>
                <option value="Pending">Pending</option>
                <option value="Completed">Completed</option>
                <option value="Cancelled">Cancelled</option>
            </select>
            
            <select class="filter-dropdown" id="sortBy" onchange="sortAppointments()">
                <option value="dateAsc">Date (Oldest First)</option>
                <option value="dateDesc">Date (Newest First)</option>
                <option value="nameAsc">Patient Name (A-Z)</option>
                <option value="nameDesc">Patient Name (Z-A)</option>
            </select>
            
            <button class="btn-filter btn-reset" onclick="resetFilters()">
                <i class="fas fa-sync-alt"></i> 
            </button>
        </div>
        
        <!-- Appointments Table Card -->
        <div class="card appointment-table">
            <div class="card-header">
                <div>Appointment Records</div>
            </div>
            <div class="card-body p-0">
                <c:choose>
                    <c:when test="${not empty appointmentDetails}">
                        <div class="table-responsive">
                            <table class="table mb-0" id="appointmentTable">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Patient</th>
                                        <th>Contact</th>
                                        <th>Date</th>
                                        <th>Token</th>
                                        <th>Reason</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${appointmentDetails}" var="appointment" varStatus="status">
                                        <%-- Parse the appointment string --%>
                                        <% 
                                        String appointmentStr = (String)pageContext.getAttribute("appointment");
                                        String[] parts = appointmentStr.split("\\|");
                                        
                                        String appointmentId = "0";
                                        String patientName = "N/A";
                                        String contactNumber = "N/A";
                                        String formattedDate = "N/A";
                                        String tokenNo = "N/A";
                                        String reasonText = "N/A";
                                        String statusValue = "N/A";
                                        
                                        for (String part : parts) {
                                            part = part.trim();
                                            if (part.startsWith("ID:")) {
                                                appointmentId = part.substring("ID:".length()).trim();
                                            } else if (part.startsWith("Patient:")) {
                                                patientName = part.substring("Patient:".length()).trim();
                                            } else if (part.startsWith("Contact:")) {
                                                contactNumber = part.substring("Contact:".length()).trim();
                                            } else if (part.startsWith("Date:")) {
                                                formattedDate = part.substring("Date:".length()).trim();
                                            } else if (part.startsWith("Token:")) {
                                                tokenNo = part.substring("Token:".length()).trim();
                                            } else if (part.startsWith("Reason:")) {
                                                reasonText = part.substring("Reason:".length()).trim();
                                            } else if (part.startsWith("Status:")) {
                                                statusValue = part.substring("Status:".length()).trim();
                                            }
                                        }
                                        
                                        pageContext.setAttribute("appointmentId", appointmentId);
                                        pageContext.setAttribute("patientName", patientName);
                                        pageContext.setAttribute("contactNumber", contactNumber);
                                        pageContext.setAttribute("formattedDate", formattedDate);
                                        pageContext.setAttribute("tokenNo", tokenNo);
                                        pageContext.setAttribute("reasonText", reasonText);
                                        pageContext.setAttribute("statusValue", statusValue);
                                        
                                        // Get initials for avatar
                                        String initials = "NA";
                                        if (!patientName.equals("N/A") && patientName.length() > 1) {
                                            String[] nameParts = patientName.split(" ");
                                            if (nameParts.length > 1) {
                                                initials = nameParts[0].substring(0, 1) + nameParts[1].substring(0, 1);
                                            } else {
                                                initials = nameParts[0].substring(0, 1);
                                            }
                                        }
                                        pageContext.setAttribute("initials", initials.toUpperCase());
                                        
                                        // Set avatar color based on status
                                        String avatarColor = "#64B5F6"; // Default blue
                                        if (statusValue.equals("Confirmed")) {
                                            avatarColor = "#4CAF50"; // Green
                                        } else if (statusValue.equals("Pending")) {
                                            avatarColor = "#FF9800"; // Yellow/Orange
                                        } else if (statusValue.equals("Cancelled")) {
                                            avatarColor = "#F44336"; // Red
                                        } else if (statusValue.equals("Completed")) {
                                            avatarColor = "#9C27B0"; // Purple
                                        }
                                        pageContext.setAttribute("avatarColor", avatarColor);
                                        %>
                                        
                                        <tr data-id="${appointmentId}" 
                                            data-patient="${patientName}" 
                                            data-contact="${contactNumber}" 
                                            data-date="${formattedDate}" 
                                            data-status="${statusValue}"
                                            data-token="${tokenNo}"
                                            data-reason="${reasonText}">
                                            <td>${appointmentId}</td>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <div class="appointment-avatar me-2" style="background-color: ${avatarColor};">
                                                        ${initials}
                                                    </div>
                                                    ${patientName}
                                                </div>
                                            </td>
                                            <td>${contactNumber}</td>
                                            <td>${formattedDate}</td>
                                            <td>${tokenNo}</td>
                                            <td>${reasonText}</td>
                                            <td>
                                                <span class="badge-${fn:toLowerCase(statusValue)}">
                                                    ${statusValue}
                                                </span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${statusValue eq 'Completed'}">
                                                        <!-- If completed: View enabled, Complete disabled -->
                                                        <a href="${pageContext.request.contextPath}/Doctor/ViewMedicalRecord?appointmentId=${appointmentId}"
                                                           class="btn btn-sm btn-primary" style="background-color: var(--primary-color); border-color: var(--primary-color);">
                                                            <i class="fas fa-eye"></i> 
                                                        </a>
                                                    </c:when>
                                                    <c:when test="${statusValue eq 'Cancelled'}">
                                                        <!-- If cancelled: No button shown -->
                                                        <span class="text-muted">NA</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <!-- If pending/confirmed: Complete enabled -->
                                                        <a href="${pageContext.request.contextPath}/Doctor/CompleteAppointment?appointmentId=${appointmentId}"
                                                           class="btn btn-sm btn-success" style="background-color: var(--confirmed-color); border-color: var(--confirmed-color);">
                                                            <i class="fas fa-check-circle"></i> 
                                                        </a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-info text-center m-3">
                            No appointments found for this doctor.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
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
                day: 'numeric'
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
        
        // Filter functions
        function filterAppointments() {
            const searchText = document.getElementById('searchInput').value.toLowerCase();
            const statusFilter = document.getElementById('statusFilter').value;
            
            const rows = document.querySelectorAll('#appointmentTable tbody tr');
            let visibleCount = 0;
            
            rows.forEach(row => {
                const patient = row.getAttribute('data-patient').toLowerCase();
                const contact = row.getAttribute('data-contact').toLowerCase();
                const date = row.getAttribute('data-date').toLowerCase();
                const reason = row.getAttribute('data-reason').toLowerCase();
                const status = row.getAttribute('data-status');
                
                // Check if appointment matches all selected filters
                const matchesSearch = patient.includes(searchText) || 
                                     contact.includes(searchText) || 
                                     date.includes(searchText) ||
                                     reason.includes(searchText);
                const matchesStatus = statusFilter === '' || status === statusFilter;
                
                // Show or hide based on filter results
                if (matchesSearch && matchesStatus) {
                    row.style.display = '';
                    visibleCount++;
                } else {
                    row.style.display = 'none';
                }
            });
            
            // Handle no results message if needed
            if (visibleCount === 0) {
                // Check if "No results" message already exists
                let noResultsRow = document.querySelector('#noFilterResults');
                
                if (!noResultsRow) {
                    // Create a "No results" message if it doesn't exist
                    const tbody = document.querySelector('#appointmentTable tbody');
                    noResultsRow = document.createElement('tr');
                    noResultsRow.id = 'noFilterResults';
                    noResultsRow.innerHTML = `
                        <td colspan="8" class="text-center py-3">
                            <div class="alert alert-info mb-0">
                                <i class="fas fa-info-circle me-2"></i> No appointments match your filters.
                            </div>
                        </td>
                    `;
                    tbody.appendChild(noResultsRow);
                } else {
                    noResultsRow.style.display = '';
                }
            } else {
                // Hide "No results" message if it exists
                const noResultsRow = document.querySelector('#noFilterResults');
                if (noResultsRow) {
                    noResultsRow.style.display = 'none';
                }
            }
        }
        
        function sortAppointments() {
            const sortBy = document.getElementById('sortBy').value;
            const table = document.getElementById('appointmentTable');
            const tbody = table.querySelector('tbody');
            const rows = Array.from(tbody.querySelectorAll('tr'));
            
            // Filter out any "No results" message row
            const dataRows = rows.filter(row => !row.id || row.id !== 'noFilterResults');
            
            // Sort rows based on selected criteria
            dataRows.sort((a, b) => {
                switch(sortBy) {
                    case 'dateAsc':
                        return new Date(a.getAttribute('data-date')) - new Date(b.getAttribute('data-date'));
                    case 'dateDesc':
                        return new Date(b.getAttribute('data-date')) - new Date(a.getAttribute('data-date'));
                    case 'nameAsc':
                        return a.getAttribute('data-patient').localeCompare(b.getAttribute('data-patient'));
                    case 'nameDesc':
                        return b.getAttribute('data-patient').localeCompare(a.getAttribute('data-patient'));
                    default:
                        return 0;
                }
            });
            
            // Clear the table body (keeping the "No results" row if it exists)
            const noResultsRow = rows.find(row => row.id && row.id === 'noFilterResults');
            tbody.innerHTML = '';
            
            // Reappend sorted rows to the tbody
            dataRows.forEach(row => {
                tbody.appendChild(row);
            });
            
            // Add back the "No results" row if it exists
            if (noResultsRow) {
                tbody.appendChild(noResultsRow);
            }
        }
        
        function resetFilters() {
            document.getElementById('searchInput').value = '';
            document.getElementById('statusFilter').value = '';
            document.getElementById('sortBy').value = 'dateAsc';
            
            filterAppointments();
            sortAppointments();
        }
        
        // Handle responsive behavior
        window.addEventListener('resize', function() {
            if (window.innerWidth > 768) {
                document.getElementById("sidebar").classList.remove("active");
                document.getElementById("sidebar-overlay").classList.remove("active");
            }
        });
        
        // Document ready function
        document.addEventListener('DOMContentLoaded', function() {
            // Auto-hide success and error messages after 5 seconds
            const alerts = document.querySelectorAll('.alert-success, .alert-danger');
            
            alerts.forEach(function(alert) {
                // Auto-hide after 5 seconds
                setTimeout(function() {
                    // Start fade out
                    alert.classList.remove('show');
                    
                    // Remove from DOM after animation completes
                    setTimeout(function() {
                        alert.remove();
                    }, 300);
                }, 5000);
            });
        });
    </script>
</body>
</html>