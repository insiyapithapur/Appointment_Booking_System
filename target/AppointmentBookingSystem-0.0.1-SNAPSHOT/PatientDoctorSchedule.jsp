<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Appointment</title>
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
        
        /* Doctor info card */
        .doctor-card {
            background-color: white;
            border-radius: 8px;
            border: 1px solid var(--border-color);
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 6px rgba(77, 171, 247, 0.04);
        }
        
        .doctor-avatar-large {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            font-size: 24px;
            margin-right: 20px;
        }
        
        .doctor-name {
            font-size: 20px;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 5px;
        }
        
        .doctor-specialty {
            font-size: 14px;
            color: var(--text-secondary);
            margin-bottom: 5px;
        }
        
        .badge-specialty {
            background-color: rgba(47, 128, 237, 0.1);
            color: #2f80ed;
            padding: 5px 10px;
            border-radius: 4px;
            font-weight: 500;
            font-size: 12px;
            display: inline-block;
        }
        
        /* Schedule styles */
        .schedule-container {
            background-color: white;
            border-radius: 8px;
            border: 1px solid var(--border-color);
            overflow: hidden;
            margin-bottom: 30px;
            box-shadow: 0 2px 6px rgba(77, 171, 247, 0.04);
        }
        
        .schedule-header {
            padding: 15px 20px;
            font-weight: 600;
            color: var(--primary-color);
            border-bottom: 1px solid var(--border-color);
            background-color: var(--primary-light);
            display: flex;
            align-items: center;
        }
        
        .schedule-header i {
            margin-right: 10px;
        }
        
        .schedule-card {
            background-color: white;
            border-radius: 8px;
            border: 1px solid var(--border-color);
            transition: all 0.2s;
            height: 100%;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.03);
        }
        
        .schedule-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(77, 171, 247, 0.1);
        }
        
        .schedule-card.unavailable {
            opacity: 0.7;
            background-color: #f8f9fa;
        }
        
        .schedule-card-header {
            padding: 12px 15px;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: var(--bg-secondary);
        }
        
        .day-badge {
            background-color: rgba(47, 128, 237, 0.1);
            color: #2f80ed;
            padding: 5px 10px;
            border-radius: 4px;
            font-weight: 500;
            font-size: 12px;
            display: inline-flex;
            align-items: center;
        }
        
        .day-badge i {
            margin-right: 5px;
        }
        
        .time-badge {
            background-color: rgba(46, 125, 50, 0.1);
            color: #2e7d32;
            padding: 5px 10px;
            border-radius: 4px;
            font-weight: 500;
            font-size: 12px;
            display: inline-flex;
            align-items: center;
        }
        
        .time-badge i {
            margin-right: 5px;
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }
        
        .btn-primary:hover {
            background-color: var(--primary-dark);
            border-color: var(--primary-dark);
        }
        
        .btn-secondary {
            background-color: #e9ecef;
            border-color: #dee2e6;
            color: #6c757d;
        }
        
        .back-button {
            background-color: var(--primary-light);
            color: var(--primary-color);
            border: none;
            border-radius: 6px;
            padding: 8px 16px;
            font-size: 14px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s;
            cursor: pointer;
            text-decoration: none;
        }
        
        .back-button:hover {
            background-color: var(--primary-dark);
            color: white;
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
            .card-columns {
                column-count: 2;
            }
        }
        
        @media (max-width: 991px) {
            .sidebar {
                width: 200px;
            }
            .content {
                margin-left: 200px;
            }
            .card-columns {
                column-count: 1;
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
            
            .doctor-info {
                flex-direction: column;
                align-items: center;
                text-align: center;
            }
            
            .doctor-avatar-large {
                margin-right: 0;
                margin-bottom: 15px;
            }
        }
        
        @media (max-width: 576px) {
            .page-header-row {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            
            .content {
                padding: 15px;
            }
            
            .schedule-card-header {
                flex-direction: column;
                gap: 8px;
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
            <div class="d-flex justify-content-between align-items-center mb-2 page-header-row">
                <h1 class="page-title">Book Appointment</h1>
                <button class="back-button" onclick="navigateTo('Patient/Doctors')">
                    <i class="fas fa-arrow-left"></i> Back to Doctors
                </button>
            </div>
        </div>
        
        <!-- Doctor Information -->
        <div class="doctor-card mb-4">
            <div class="d-flex">
                <div class="doctor-avatar-large" style="background-color: hsl(${doctorId * 40 % 360}, 70%, 60%)">
                    ${fn:substring(doctorName, 0, 1)}
                </div>
                <div>
                    <div class="doctor-name">${doctorName}</div>
                    <div class="mb-2"><span class="badge-specialty">${doctorSpecialty}</span></div>
                    <div class="doctor-specialty mb-1">${doctorExperience} • ${doctorDegree}</div>
                    <div class="text-secondary"><i class="fas fa-phone-alt me-2"></i>${doctorContact}</div>
                </div>
            </div>
        </div>
        
        <!-- Schedule Container -->
        <div class="schedule-container">
            <div class="schedule-header">
                <i class="far fa-calendar-alt"></i> Available Time Slots
            </div>
            <div class="p-4">
                <div class="row g-3">
                    <c:forEach items="${schedules}" var="scheduleInfo" varStatus="status">
                        <c:set var="scheduleParts" value="${fn:split(scheduleInfo, '|')}" />
                        <c:set var="scheduleId" value="${fn:trim(fn:substringAfter(scheduleParts[0], 'Schedule ID:'))}" />
                        <c:set var="doctorId" value="${fn:trim(fn:substringAfter(scheduleParts[1], 'Doctor ID:'))}" />
                        <c:set var="day" value="${fn:trim(fn:substringAfter(scheduleParts[2], 'Day:'))}" />
                        <c:set var="time" value="${fn:trim(fn:substringAfter(scheduleParts[3], 'Time:'))}" />
                        <c:set var="isAvailable" value="${fn:trim(fn:substringAfter(scheduleParts[5], 'Available:'))}" />
                        
                        <div class="col-md-6 col-lg-4">
                            <div class="schedule-card ${isAvailable eq 'Yes' ? '' : 'unavailable'}">
                                <div class="schedule-card-header">
                                    <span class="day-badge"><i class="far fa-calendar"></i> ${day}</span>
                                    <span class="time-badge"><i class="far fa-clock"></i> ${time}</span>
                                </div>
                                <div class="card-body p-3">
                                    <c:choose>
                                        <c:when test="${isAvailable eq 'Yes'}">
                                            <a href="${pageContext.request.contextPath}/Patient/ConfirmAppointment?scheduleId=${scheduleId}&day=${day}" 
                                               class="btn btn-primary w-100">
                                                <i class="fas fa-check-circle me-2"></i> Select This Slot
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn btn-secondary w-100" disabled>
                                                <i class="fas fa-times-circle me-2"></i> Not Available
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    
                    <c:if test="${empty schedules}">
                        <div class="col-12 py-4">
                            <div class="alert alert-info text-center">
                                <i class="fas fa-info-circle me-2"></i>
                                No available schedules found for this doctor.
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap & jQuery JS -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
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
    </script>
</body>
</html>