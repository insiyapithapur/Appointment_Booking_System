<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Confirm Appointment</title>
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
            --success-color: #40c057;
            --info-color: #15aabf;
            --warning-color: #fab005;
            --danger-color: #fa5252;
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
        
        /* Confirm card styles */
        .confirm-card {
            background-color: var(--bg-color);
            border-radius: 8px;
            border: 1px solid var(--border-color);
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 2px 6px rgba(77, 171, 247, 0.04);
        }
        
        .section-title {
            font-size: 18px;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 20px;
        }
        
        /* Form controls */
        .form-label {
            font-weight: 500;
            color: var(--text-primary);
            margin-bottom: 6px;
            font-size: 14px;
        }
        
        .form-control, .form-select {
            border: 1px solid var(--border-color);
            border-radius: 6px;
            font-size: 14px;
            padding: 10px 12px;
            transition: all 0.2s;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.25rem rgba(77, 171, 247, 0.25);
        }
        
        .input-group-text {
            background-color: var(--bg-secondary);
            border: 1px solid var(--border-color);
            color: var(--text-secondary);
        }
        
        .input-help-text {
            font-size: 12px;
            color: var(--text-secondary);
            margin-top: 6px;
        }
        
        /* Available slots styles */
        .available-slots-container {
            background-color: var(--bg-secondary);
            border-radius: 8px;
            border: 1px solid var(--border-color);
            padding: 20px;
            margin-top: 25px;
        }
        
        .slots-header {
            font-size: 16px;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }
        
        .slots-header i {
            margin-right: 8px;
            color: var(--primary-color);
        }
        
        .slot-item {
            background-color: white;
            border-radius: 6px;
            border: 1px solid var(--border-color);
            padding: 12px 15px;
            margin-bottom: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: all 0.2s;
            cursor: pointer;
        }
        
        .slot-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
            border-color: var(--primary-color);
        }
        
        .slot-item.selected {
            background-color: var(--primary-light);
            border-color: var(--primary-color);
        }
        
        .slot-date {
            font-weight: 500;
            color: var(--text-primary);
            display: flex;
            align-items: center;
        }
        
        .slot-date i {
            margin-right: 8px;
            color: var(--primary-color);
        }
        
        .slot-available {
            font-size: 12px;
            padding: 4px 10px;
            border-radius: 12px;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
        }
        
        .slot-available i {
            margin-right: 5px;
        }
        
        .slot-available.high {
            background-color: rgba(64, 192, 87, 0.1);
            color: var(--success-color);
        }
        
        .slot-available.medium {
            background-color: rgba(250, 176, 5, 0.1);
            color: var(--warning-color);
        }
        
        .slot-available.low {
            background-color: rgba(250, 82, 82, 0.1);
            color: var(--danger-color);
        }
        
        .slot-available.none {
            background-color: rgba(108, 117, 125, 0.1);
            color: var(--text-secondary);
        }
        
        /* Button styles */
        .btn {
            padding: 9px 16px;
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
        
        .btn-outline-secondary {
            color: var(--text-secondary);
            border-color: var(--border-color);
        }
        
        .btn-outline-secondary:hover {
            background-color: var(--bg-secondary);
            color: var(--text-primary);
        }
        
        .btn-outline-primary {
            color: var(--primary-color);
            border-color: var(--primary-color);
        }
        
        .btn-outline-primary:hover {
            background-color: var(--primary-color);
            color: white;
        }
        
        /* Alert styles */
        .alert {
            border-radius: 6px;
            padding: 12px 15px;
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px;
        }
        
        .alert-danger {
            background-color: rgba(250, 82, 82, 0.1);
            color: var(--danger-color);
            border: 1px solid rgba(250, 82, 82, 0.2);
        }
        
        .alert-info {
            background-color: rgba(21, 170, 191, 0.1);
            color: var(--info-color);
            border: 1px solid rgba(21, 170, 191, 0.2);
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
            
            .page-header-row {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
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
            <div class="d-flex justify-content-between align-items-center mb-2 page-header-row">
                <h1 class="page-title">Confirm Appointment</h1>
                <button class="btn btn-outline-primary" onclick="history.back()">
                    <i class="fas fa-arrow-left me-2"></i> Back
                </button>
            </div>
        </div>
        
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <div>${errorMessage}</div>
            </div>
        </c:if>
        
        <div class="confirm-card">
            
            <form action="${pageContext.request.contextPath}/Patient/ConfirmAppointment" method="post">
                <input type="hidden" name="scheduleId" value="${scheduleId}">
                <input type="hidden" id="scheduleDay" value="${scheduleDay}">
                <input type="hidden" id="doctorId" value="${doctorId}">
                
                <div class="mb-4">
                    <label for="appointmentDate" class="form-label">Appointment Date</label>
                    <div class="input-group">
                        <input type="date" class="form-control" id="appointmentDate" name="appointmentDate" required>
                        <span class="input-group-text">
                            <i class="fas fa-info-circle" data-bs-toggle="tooltip" 
                               title="Only dates that fall on ${scheduleDay} are available for selection"></i>
                        </span>
                    </div>
                    <div class="input-help-text">
                        <i class="fas fa-calendar-day me-1"></i>
                        You can only select dates that fall on ${scheduleDay}
                    </div>
                </div>
                
                <!-- Available Slots Section -->
                <div class="available-slots-container">
                    <div class="slots-header">
                        <i class="fas fa-calendar-alt"></i> Available Appointment Slots
                    </div>
                    <div id="availableSlotsDisplay">
                        <c:if test="${not empty availableSlots}">
                            <c:forEach var="slot" items="${availableSlots}">
                                <div class="slot-item" data-slot-info="${slot}">
                                    <c:set var="slotParts" value="${fn:split(slot, '|')}" />
                                    <c:set var="dateInfo" value="${fn:trim(slotParts[0])}" />
                                    
                                    <c:set var="availableParts" value="${fn:split(slotParts[4], ':')}" />
                                    <c:set var="availableCount" value="${fn:trim(availableParts[1])}" />
                                    
                                    <span class="slot-date">
                                        <i class="far fa-calendar"></i> ${dateInfo}
                                    </span>
                                    <span class="slot-available 
                                        <c:choose>
                                            <c:when test="${availableCount > 5}">high</c:when>
                                            <c:when test="${availableCount > 2}">medium</c:when>
                                            <c:when test="${availableCount > 0}">low</c:when>
                                            <c:otherwise>none</c:otherwise>
                                        </c:choose>">
                                        <i class="fas fa-user-clock"></i> ${availableCount} slots available
                                    </span>
                                </div>
                            </c:forEach>
                        </c:if>
                        <c:if test="${empty availableSlots}">
                            <div class="alert alert-info">
                                <i class="fas fa-info-circle me-2"></i>
                                No available slots found for the selected date range.
                            </div>
                        </c:if>
                    </div>
                </div>
                
                <div class="mb-4 mt-4">
                    <label for="reason" class="form-label">Reason for Appointment</label>
                    <textarea class="form-control" id="reason" name="reason" rows="4" 
                              placeholder="Please describe your symptoms or reason for the appointment..." required></textarea>
                    <div class="input-help-text">
                        <i class="fas fa-info-circle me-1"></i>
                        Providing detailed information helps the doctor prepare for your visit
                    </div>
                </div>
                
                <div class="d-flex justify-content-end mt-4">
                    <a href="${pageContext.request.contextPath}/Patient/Doctors" class="btn btn-outline-secondary me-2">
                        Cancel
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-check me-2"></i> Confirm Booking
                    </button>
                </div>
            </form>
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
        
        // Function to get the day of the week for a date
        function getDayOfWeek(date) {
            const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
            return days[date.getDay()];
        }
        
        // Function to check if a date is valid for selection
        function isValidDate(date) {
            const scheduleDay = document.getElementById('scheduleDay').value;
            return getDayOfWeek(date) === scheduleDay;
        }
        
     // Function to refresh available slots
        function refreshAvailableSlots(selectedDate) {
            const doctorId = document.getElementById('doctorId').value;
            const contextPath = '${pageContext.request.contextPath}';
            
            // Format date for display
            const formattedDate = selectedDate.toISOString().split('T')[0];
            
            // Make AJAX call to get updated slot information
            fetch(`${contextPath}/Patient/ConfirmAppointment?fetchSlots=true&doctorId=${doctorId}`)
                .then(response => response.json())
                .then(slots => {
                    updateAvailableSlotsDisplay(slots, formattedDate);
                })
                .catch(error => console.error('Error fetching slots:', error));
        }
        
        // Function to update the display with latest slot information
        function updateAvailableSlotsDisplay(slots, selectedDateStr) {
            const slotsContainer = document.getElementById('availableSlotsDisplay');
            
            if (!slots || slots.length === 0) {
                slotsContainer.innerHTML = `
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle me-2"></i>
                        No available slots found for the selected date range.
                    </div>`;
                return;
            }
            
            let html = '';
            
            slots.forEach(slot => {
                const slotParts = slot.split('|');
                const dateInfo = slotParts[0].trim();
                
                // Extract date for matching
                const slotDatePart = dateInfo.split(',')[1]?.trim() || '';
                
                // Extract available count
                const availableParts = slotParts[4].split(':');
                const availableCount = availableParts[1].trim();
                
                // Determine appropriate class based on available count
                let availableClass = 'none';
                if (availableCount > 5) {
                    availableClass = 'high';
                } else if (availableCount > 2) {
                    availableClass = 'medium';
                } else if (availableCount > 0) {
                    availableClass = 'low';
                }
                
                // Highlight the row if it matches the selected date
                const isSelectedDate = dateInfo.includes(selectedDateStr);
                const highlightClass = isSelectedDate ? 'selected' : '';
                
                html += `
                    <div class="slot-item ${highlightClass}" data-slot-info="${slot}">
                        <span class="slot-date">
                            <i class="far fa-calendar"></i> ${dateInfo}
                        </span>
                        <span class="slot-available ${availableClass}">
                            <i class="fas fa-user-clock"></i> ${availableCount} slots available
                        </span>
                    </div>
                `;
            });
            
            slotsContainer.innerHTML = html;
            
            // Add click event to slot items to select the date
            document.querySelectorAll('.slot-item').forEach(item => {
                item.addEventListener('click', function() {
                    const slotInfo = this.getAttribute('data-slot-info');
                    const slotParts = slotInfo.split('|');
                    const dateInfo = slotParts[0].trim();
                    
                    // Extract date for setting the input
                    try {
                        const dateString = dateInfo.replace(/^\w+,\s/, ''); // Remove day name
                        const date = new Date(dateString);
                        
                        if (!isNaN(date.getTime())) {
                            const formattedDate = date.toISOString().split('T')[0];
                            document.getElementById('appointmentDate').value = formattedDate;
                            
                            // Highlight the selected slot
                            document.querySelectorAll('.slot-item').forEach(el => {
                                el.classList.remove('selected');
                            });
                            this.classList.add('selected');
                        }
                    } catch (e) {
                        console.error('Error parsing date:', e);
                    }
                });
            });
        }
        
        // Set up date field with restrictions
        document.addEventListener('DOMContentLoaded', function() {
            const dateInput = document.getElementById('appointmentDate');
            const scheduleDay = document.getElementById('scheduleDay').value;
            
            // Enable tooltips
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
            var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl)
            });
            
            // Find the next valid date (today or future date that falls on the schedule day)
            let currentDate = new Date();
            while (!isValidDate(currentDate) || currentDate < new Date(new Date().setHours(0,0,0,0))) {
                currentDate.setDate(currentDate.getDate() + 1);
            }
            
            // Set the initial date to the next valid date
            const formattedDate = currentDate.toISOString().split('T')[0];
            dateInput.value = formattedDate;
            
            // Make slot items clickable
            document.querySelectorAll('.slot-item').forEach(item => {
                item.addEventListener('click', function() {
                    const slotInfo = this.getAttribute('data-slot-info');
                    const slotParts = slotInfo.split('|');
                    const dateInfo = slotParts[0].trim();
                    
                    // Extract date for setting the input
                    try {
                        const dateString = dateInfo.replace(/^\w+,\s/, ''); // Remove day name
                        const date = new Date(dateString);
                        
                        if (!isNaN(date.getTime())) {
                            const formattedDate = date.toISOString().split('T')[0];
                            dateInput.value = formattedDate;
                            
                            // Highlight the selected slot
                            document.querySelectorAll('.slot-item').forEach(el => {
                                el.classList.remove('selected');
                            });
                            this.classList.add('selected');
                        }
                    } catch (e) {
                        console.error('Error parsing date:', e);
                    }
                });
            });
            
            // Custom date validation
            dateInput.addEventListener('input', function(e) {
                const selectedDate = new Date(this.value);
                
                if (!isValidDate(selectedDate)) {
                    // If not valid day of week, show warning and reset
                    alert(`Please select a date that falls on ${scheduleDay}. Other days are not available for this schedule.`);
                    this.value = formattedDate; // Reset to valid date
                }
            });
            
            // Handle date navigation with browser date picker
            dateInput.addEventListener('change', function(e) {
                const selectedDate = new Date(this.value);
                
                // Ensure it's a valid day of week
                if (!isValidDate(selectedDate)) {
                    alert(`Please select a date that falls on ${scheduleDay}. Other days are not available for this schedule.`);
                    this.value = formattedDate; // Reset to valid date
                    return;
                }
                
                // Ensure it's not in the past
                const today = new Date(new Date().setHours(0,0,0,0));
                if (selectedDate < today) {
                    alert("Please select a future date.");
                    this.value = formattedDate; // Reset to valid date
                    return;
                }
                
                // Highlight the matching slot if it exists
                const selectedDateStr = this.value;
                document.querySelectorAll('.slot-item').forEach(item => {
                    const slotInfo = item.getAttribute('data-slot-info');
                    if (slotInfo.includes(selectedDateStr)) {
                        document.querySelectorAll('.slot-item').forEach(el => {
                            el.classList.remove('selected');
                        });
                        item.classList.add('selected');
                        
                        // Scroll to the highlighted item
                        item.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
                    }
                });
                
                // Optionally refresh slots data when date changes
                // refreshAvailableSlots(selectedDate);
            });
        });
    </script>
</body>
</html>