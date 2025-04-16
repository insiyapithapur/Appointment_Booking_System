<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Medical Record Details</title>
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
            color: var(--text-primary);
        }
        
        .date {
            color: var(--text-secondary);
            font-size: 14px;
        }
        
        /* Card Styles */
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
        
        .card-header i {
            margin-right: 10px;
        }
        
        .card-body {
            padding: 20px;
        }
        
        /* Medical Record Sections */
        .section-title {
            font-size: 16px;
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            padding-bottom: 10px;
            border-bottom: 1px solid var(--border-color);
        }
        
        .section-title i {
            margin-right: 10px;
        }
        
        .section-content {
            margin-bottom: 25px;
        }
        
        .section-content:last-child {
            margin-bottom: 0;
        }
        
        .info-row {
            display: flex;
            margin-bottom: 10px;
        }
        
        .info-label {
            width: 150px;
            font-weight: 500;
            color: var(--text-secondary);
        }
        
        .info-value {
            flex: 1;
            color: var(--text-primary);
        }
        
        .medical-info {
            background-color: var(--bg-secondary);
            border-left: 3px solid var(--primary-color);
            padding: 15px;
            margin-bottom: 0;
            border-radius: 0 4px 4px 0;
        }
        
        /* Button Styles */
        .btn-custom-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
        }
        
        .btn-custom-primary:hover {
            background-color: var(--primary-dark);
            border-color: var(--primary-dark);
            color: white;
        }
        
        .btn-custom-success {
            background-color: var(--confirmed-color);
            border-color: var(--confirmed-color);
            color: white;
        }
        
        .btn-custom-success:hover {
            background-color: #178541;
            border-color: #178541;
            color: white;
        }
        
        .action-buttons {
            display: flex;
            gap: 10px;
            margin-top: 10px;
        }
        
        /* Alert Styles */
        .alert {
            border-radius: 8px;
            border: none;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
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
            .info-row {
                flex-direction: column;
            }
            
            .info-label {
                width: 100%;
                margin-bottom: 5px;
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
            
            .action-buttons {
                flex-direction: column;
                width: 100%;
            }
            
            .action-buttons .btn {
                width: 100%;
            }
        }
        
        /* Print styles */
        @media print {
            .sidebar, .toggle-sidebar, .sidebar-overlay, .action-buttons, .btn {
                display: none !important;
            }
            .content {
                margin-left: 0;
                padding: 0;
            }
            .card {
                box-shadow: none;
                border: none;
            }
            .card-header {
                color: black;
                background-color: white;
                border-bottom: 1px solid #ddd;
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
                        ${fn:substring(sessionScope.username, 0, 1)}
                    </c:when>
                    <c:otherwise>
                        <!-- Show doctor image if available -->
                        <img src="${doctorImage}" alt="${sessionScope.username}">
                    </c:otherwise>
                </c:choose>
                <div class="profile-verification">
                    <i class="fas fa-check"></i>
                </div>
            </div>
            <div class="profile-name">${sessionScope.username}</div>
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
                        Doctor
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
        <!-- Header -->
        <div class="header">
            <div class="title">Medical Record</div>
            <a href="${pageContext.request.contextPath}/Doctor/Appointment" class="btn btn-sm btn-outline-secondary">
             	<i class="fas fa-arrow-left"></i> Back
            </a>
        </div>
        
        <!-- Display any error messages -->
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger" role="alert">
                ${sessionScope.errorMessage}
                <c:remove var="errorMessage" scope="session" />
            </div>
        </c:if>
        
        <!-- Appointment Information Card -->
        <div class="card">
            <div class="card-header">
                <div><i class="fas fa-info-circle"></i> Appointment Information</div>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <div class="info-row">
                            <div class="info-label">Appointment ID:</div>
                            <div class="info-value">${appointmentId}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Date:</div>
                            <div class="info-value">
                                <c:if test="${not empty medicalRecord.appointment.appointmentDate}">
                                    <fmt:parseDate value="${medicalRecord.appointment.appointmentDate}" pattern="yyyy-MM-dd" var="parsedDate" type="date" />
                                    <fmt:formatDate value="${parsedDate}" pattern="MMMM dd, yyyy" />
                                </c:if>
                            </div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Token Number:</div>
                            <div class="info-value">${medicalRecord.appointment.tokenNo}</div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="info-row">
                            <div class="info-label">Patient:</div>
                            <div class="info-value">${medicalRecord.appointment.patient.user.username}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Reason:</div>
                            <div class="info-value">${medicalRecord.appointment.reason}</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Medical Details Card (Combined) -->
        <div class="card">
            <div class="card-header">
                <div><i class="fas fa-file-medical"></i> Medical Details</div>
                <button class="btn btn-sm btn-outline-primary" onclick="">
                    <i class="fas fa-edit"></i> 
                </button>
            </div>
            <div class="card-body">
                <!-- Diagnosis Section -->
                <div class="section-content">
                    <div class="section-title">
                        <i class="fas fa-stethoscope"></i> Diagnosis
                    </div>
                    <div class="medical-info">
                        ${not empty medicalRecord.diagnosis ? medicalRecord.diagnosis : 'No diagnosis provided.'}
                    </div>
                </div>
                
                <!-- Treatment Section -->
                <div class="section-content">
                    <div class="section-title">
                        <i class="fas fa-pills"></i> Treatment
                    </div>
                    <div class="medical-info">
                        ${not empty medicalRecord.treatment ? medicalRecord.treatment : 'No treatment information provided.'}
                    </div>
                </div>
                
                <!-- Notes Section -->
                <div class="section-content">
                    <div class="section-title">
                        <i class="fas fa-sticky-note"></i> Additional Notes
                    </div>
                    <div class="medical-info">
                        ${not empty medicalRecord.notes ? medicalRecord.notes : 'No additional notes provided.'}
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Action Buttons -->
        <div class="action-buttons">
            <button class="btn btn-custom-primary" onclick="window.print()">
                <i class="fas fa-print"></i> Print Medical Record
            </button>
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
        
        function editRecord(appointmentId) {
            const contextPath = '${pageContext.request.contextPath}';
            window.location.href = contextPath + '/Doctor/CompleteAppointment?appointmentId=' + appointmentId;
        }
    </script>
</body>
</html>