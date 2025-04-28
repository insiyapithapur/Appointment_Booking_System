<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Medical Dashboard</title>
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
            background-color: #4dabf7;
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
        
        /* Appointment Table */
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
        }
        
        .appointments-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }
        
        .appointments-table th {
            padding: 12px 15px;
            text-align: left;
            font-weight: 500;
            color: var(--text-secondary);
            border-bottom: 1px solid var(--border-color);
            background-color: var(--bg-secondary);
        }
        
        .appointments-table td {
            padding: 12px 15px;
            border-bottom: 1px solid var(--border-color);
            vertical-align: middle;
        }
        
        .appointments-table tbody tr:last-child td {
            border-bottom: none;
        }
        
        /* Patient Info */
        .patient-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .patient-avatar {
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
        
        /* Status Badge */
        .badge {
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
        }
        
        .badge-confirmed {
            color: var(--confirmed-color);
            background-color: rgba(33, 150, 83, 0.1);
        }
        
        .badge-pending {
            color: var(--pending-color);
            background-color: rgba(242, 153, 74, 0.1);
        }
        
        .badge-cancelled {
            color: var(--cancelled-color);
            background-color: rgba(235, 87, 87, 0.1);
        }
        
        .badge-completed {
            color: var(--completed-color);
            background-color: rgba(47, 128, 237, 0.1);
        }
        
        /* Action Button */
        .btn-action {
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            text-decoration: none;
            transition: all 0.2s;
        }
        
        .btn-complete {
            background-color: rgba(33, 150, 83, 0.1);
            color: var(--confirmed-color);
            border: 1px solid rgba(33, 150, 83, 0.2);
        }
        
        .btn-complete:hover {
            background-color: rgba(33, 150, 83, 0.2);
            color: var(--confirmed-color);
        }
        
        .btn-view {
            background-color: rgba(47, 128, 237, 0.1);
            color: var(--completed-color);
            border: 1px solid rgba(47, 128, 237, 0.2);
        }
        
        .btn-view:hover {
            background-color: rgba(47, 128, 237, 0.2);
            color: var(--completed-color);
        }
        
        /* Reason Tooltip */
        .reason-cell {
            max-width: 200px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        
        .reason-tooltip {
            position: relative;
            display: inline-block;
            cursor: pointer;
        }
        
        .reason-tooltip .reason-text {
            visibility: hidden;
            width: 200px;
            background-color: var(--text-primary);
            color: #fff;
            text-align: left;
            border-radius: 4px;
            padding: 8px 10px;
            position: absolute;
            z-index: 1;
            bottom: 125%;
            left: 0;
            opacity: 0;
            transition: opacity 0.3s;
            white-space: normal;
            font-size: 12px;
            box-shadow: 0 2px 8px rgba(43, 61, 79, 0.15);
        }
        
        .reason-tooltip:hover .reason-text {
            visibility: visible;
            opacity: 1;
        }
        
        /* Alert Styles */
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
            .appointments-table {
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
                <a href="${pageContext.request.contextPath}/Doctor/Dashboard" class="nav-link active">
                    <i class="fas fa-chart-line"></i> Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/Doctor/Patient" class="nav-link">
                    <i class="fas fa-user-injured"></i> Patients
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/Doctor/Appointment" class="nav-link">
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
        
        <!-- Analytics Section -->
		<div class="analytics-section" style="display: flex; flex-wrap: wrap; gap: 20px; margin-bottom: 30px;">
		    <!-- Total Patients Card -->
		    <div class="analytics-card" style="flex: 1; min-width: 240px; background-color: #ffffff; border-radius: 10px; padding: 20px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.03); border: 1px solid #dbe4ff; display: flex; justify-content: space-between; transition: all 0.3s ease;">
		        <div class="analytics-info">
		            <div style="font-size: 16px; font-weight: 500; color: #2b3d4f; margin-bottom: 10px;">Total Patient</div>
		            <div style="font-size: 32px; font-weight: 700; color: #2b3d4f; margin-bottom: 10px;">
		                <c:out value="${totalPatients != null ? totalPatients : '1'}" />
		            </div>
		        </div>
		        <div style="width: 60px; height: 60px; display: flex; align-items: center; justify-content: center; background-color: #f0f4fd; border-radius: 10px; color: #4a5687;">
		            <i class="fas fa-user-injured"></i>
		        </div>
		    </div>
		    
		    <!-- Patients Today Card -->
		    <div class="analytics-card" style="flex: 1; min-width: 240px; background-color: #ffffff; border-radius: 10px; padding: 20px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.03); border: 1px solid #dbe4ff; display: flex; justify-content: space-between; transition: all 0.3s ease;">
		        <div class="analytics-info">
		            <div style="font-size: 16px; font-weight: 500; color: #2b3d4f; margin-bottom: 10px;">Patients Today</div>
		            <div style="font-size: 32px; font-weight: 700; color: #2b3d4f; margin-bottom: 10px;">
		                <c:out value="${patientsToday != null ? patientsToday : '0'}" />
		            </div>
		        </div>
		        <div style="width: 60px; height: 60px; display: flex; align-items: center; justify-content: center; background-color: #f0f4fd; border-radius: 10px; color: #4a5687;">
		            <i class="fas fa-user-clock"></i>
		        </div>
		    </div>
		    
		    <!-- Appointments Today Card -->
		    <div class="analytics-card" style="flex: 1; min-width: 240px; background-color: #ffffff; border-radius: 10px; padding: 20px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.03); border: 1px solid #dbe4ff; display: flex; justify-content: space-between; transition: all 0.3s ease;">
		        <div class="analytics-info">
		            <div style="font-size: 16px; font-weight: 500; color: #2b3d4f; margin-bottom: 10px;">Appointments Today</div>
		            <div style="font-size: 32px; font-weight: 700; color: #2b3d4f; margin-bottom: 10px;">
		                <c:out value="${appointmentsToday != null ? appointmentsToday : '0'}" />
		            </div>
		        </div>
		        <div style="width: 60px; height: 60px; display: flex; align-items: center; justify-content: center; background-color: #f0f4fd; border-radius: 10px; color: #4a5687;">
		            <i class="fas fa-calendar-check"></i>
		        </div>
		    </div>
		</div>

        <!-- Appointments Table -->
        <div class="card">
            <div class="card-header" style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 15px;">
		        <div style="font-weight: 600;">Upcoming Appointments</div>
		        
		        <!-- Compact Filters -->
		        <div style="display: flex; gap: 10px; align-items: center;">
		            <!-- Search Filter -->
		            <div style="position: relative;">
		                <input type="text" id="patientSearch" placeholder="Search patient or contact..." 
		                       style="width: 220px; padding: 6px 12px; padding-left: 30px; border-radius: 6px; border: 1px solid var(--border-color); 
		                              font-size: 13px; background-color: white;">
		                <i class="fas fa-search" style="position: absolute; left: 10px; top: 50%; transform: translateY(-50%); color: var(--text-secondary);"></i>
		            </div>
		            
		            <!-- Date Filter -->
		            <div style="position: relative;">
		                <input type="date" id="appointmentDate" 
		                       style="width: 150px; padding: 6px 12px; border-radius: 6px; border: 1px solid var(--border-color); 
		                              font-size: 13px; background-color: white;">
		            </div>
		            
		            <!-- Refresh Button with Icon -->
					<button onclick="clearFilters()" style="padding: 6px 12px; background-color: var(--bg-secondary); color: var(--text-secondary); 
					                border: 1px solid var(--border-color); border-radius: 6px; cursor: pointer; font-weight: 500; font-size: 13px;">
					    <i class="fas fa-sync-alt"></i>
					</button>
		        </div>
		    </div>
    
            <table class="appointments-table">
                <thead>
                    <tr>
                        <th>Patient Name</th>
                        <th>Date</th>
                        <th>Token No</th>
                        <th>Reason</th>
                        <th>Contact</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${appointments}" var="appointment">
                        <tr>
                            <td>
                                <div class="patient-info">
                                    <div class="patient-avatar" style="background-color: ${appointment.avatarColor}">${appointment.initials}</div>
                                    ${appointment.patientName}
                                </div>
                            </td>
                            <td>${appointment.formattedDate}</td>
                            <td>${appointment.appointmentToken}</td>
                            <td class="reason-cell">
                                <div class="reason-tooltip">
                                    ${fn:length(appointment.reason) > 25 ? fn:substring(appointment.reason, 0, 25).concat('...') : appointment.reason}
                                    <span class="reason-text">${appointment.reason}</span>
                                </div>
                            </td>
                            <td>${appointment.contactNumber}</td>
                            <td>
                                <span class="badge badge-${fn:toLowerCase(appointment.status)}">
                                    ${appointment.status}
                                </span>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${appointment.status == 'Completed'}">
                                        <a href="${pageContext.request.contextPath}/Doctor/ViewMedicalRecord?appointmentId=${appointment.appointmentId}"
                                           class="btn-action btn-view">
                                            <i class="fas fa-eye"></i> 
                                        </a>
                                    </c:when>
                                    <c:when test="${appointment.status == 'Cancelled'}">
                                        <span class="text-muted">NA</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/Doctor/CompleteAppointment?appointmentId=${appointment.appointmentId}"
                                           class="btn-action btn-complete">
                                            <i class="fas fa-check-circle"></i>
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    
                    <c:if test="${empty appointments}">
                        <tr>
                            <td colspan="7" class="text-center py-4">
                                <div class="alert alert-info mb-0">
                                    <i class="fas fa-info-circle me-2"></i> No appointments scheduled for today.
                                </div>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
    
    <!-- Bootstrap & jQuery JS -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
	    // Filter functionality
	    function applyFilters() {
	        const searchValue = document.getElementById('patientSearch').value.toLowerCase();
	        const dateValue = document.getElementById('appointmentDate').value;
	        
	        // Format the selected date to match your format (Apr 15, 2025)
	        let formattedDate = '';
	        if (dateValue) {
	            const date = new Date(dateValue);
	            const month = date.toLocaleString('en', { month: 'short' });
	            const day = date.getDate();
	            const year = date.getFullYear();
	            formattedDate = `${month} ${day}, ${year}`;
	        }
	        
	        // Get all table rows
	        const rows = document.querySelectorAll('.appointments-table tbody tr');
	        
	        rows.forEach(row => {
	            // For handling empty table message
	            if (row.querySelector('td[colspan="7"]')) {
	                return;
	            }
	            
	            const patientNameCell = row.querySelector('td:first-child').textContent.toLowerCase();
	            const contactCell = row.querySelector('td:nth-child(5)').textContent.toLowerCase();
	            const dateCell = row.querySelector('td:nth-child(2)').textContent;
	            
	            // Check if row matches the search filter
	            const matchesSearch = searchValue === '' || 
	                                 patientNameCell.includes(searchValue) || 
	                                 contactCell.includes(searchValue);
	            
	            // Check if row matches the date filter
	            const matchesDate = dateValue === '' || dateCell.includes(formattedDate);
	            
	            // Show or hide the row based on filters
	            if (matchesSearch && matchesDate) {
	                row.style.display = '';
	            } else {
	                row.style.display = 'none';
	            }
	        });
	        
	        // Check if there are any visible rows
	        let visibleRows = 0;
	        rows.forEach(row => {
	            if (row.style.display !== 'none') {
	                visibleRows++;
	            }
	        });
	        
	        // Show "no results" message if all rows are filtered out
	        const tbody = document.querySelector('.appointments-table tbody');
	        const existingNoResults = document.getElementById('no-results-row');
	        
	        if (visibleRows === 0 && !existingNoResults) {
	            const noResultsRow = document.createElement('tr');
	            noResultsRow.id = 'no-results-row';
	            noResultsRow.innerHTML = `
	                <td colspan="7" class="text-center py-4">
	                    <div class="alert alert-info mb-0">
	                        <i class="fas fa-info-circle me-2"></i> No appointments match your filters.
	                    </div>
	                </td>
	            `;
	            tbody.appendChild(noResultsRow);
	        } else if (visibleRows > 0 && existingNoResults) {
	            existingNoResults.remove();
	        }
	    }
	
	    function clearFilters() {
	        // Reset input fields
	        document.getElementById('patientSearch').value = '';
	        document.getElementById('appointmentDate').value = '';
	        
	        // Show all rows
	        const rows = document.querySelectorAll('.appointments-table tbody tr');
	        rows.forEach(row => {
	            row.style.display = '';
	        });
	        
	        // Remove any "no results" message
	        const existingNoResults = document.getElementById('no-results-row');
	        if (existingNoResults) {
	            existingNoResults.remove();
	        }
	    }
	
	    // Add input event listeners for real-time filtering
	    document.addEventListener('DOMContentLoaded', function() {
	        const searchInput = document.getElementById('patientSearch');
	        const dateInput = document.getElementById('appointmentDate');
	        
	        searchInput.addEventListener('input', function() {
	            applyFilters();
	        });
	        
	        dateInput.addEventListener('change', function() {
	            applyFilters();
	        });
	    });
	    
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