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
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css">
    <style>
        :root {
            --sidebar-bg: #4f95e9;
            --primary-color: #4f95e9;
            --light-bg: #f7f9fc;
            --text-color: #333;
        }
        
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: var(--light-bg);
        }
        
        .sidebar {
            background-color: var(--sidebar-bg);
            color: white;
            min-height: 100vh;
            position: fixed;
            width: 250px;
            padding: 20px 0;
            text-align: center;
            transition: all 0.3s;
            z-index: 1000;
        }
        
        .content {
            margin-left: 250px;
            padding: 20px;
            transition: all 0.3s;
        }
        
        .avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background-color: #96c8fb;
            color: white;
            font-size: 25px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            cursor: pointer;
            transition: transform 0.2s;
        }
        
        .avatar:hover {
            transform: scale(1.05);
        }
        
        .nav-item {
            padding: 15px 24px;
            margin: 5px 15px;
            cursor: pointer;
            transition: all 0.3s;
            text-align: left;
            border-radius: 5px;
        }
        
        .nav-item.active {
            background-color: #81c784;
            font-weight: bold;
        }
        
        .nav-item:hover {
            background-color: rgba(255, 255, 255, 0.2);
            transform: translateX(5px);
        }
        
        .schedule-container {
            background: white;
            border-radius: 10px;
            padding: 0;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            overflow: hidden;
            margin-bottom: 30px;
        }
        
        .schedule-header {
            background-color: var(--primary-color);
            color: white;
            padding: 15px 20px;
            font-size: 18px;
            font-weight: bold;
        }
        
        .schedule-card {
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            margin-bottom: 15px;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        
        .schedule-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .schedule-card.unavailable {
            opacity: 0.6;
        }
        
        .schedule-card-header {
            background-color: #f5f5f5;
            padding: 12px 15px;
            border-bottom: 1px solid #e0e0e0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .day-badge {
            background-color: #e3f2fd;
            color: #1565c0;
            font-weight: 500;
            padding: 6px 12px;
            border-radius: 4px;
            display: inline-block;
        }
        
        .time-badge {
            background-color: #e8f5e9;
            color: #2e7d32;
            font-weight: 500;
            padding: 6px 12px;
            border-radius: 4px;
            display: inline-block;
        }
        
        .toggle-sidebar {
            display: none;
            position: fixed;
            top: 20px;
            left: 20px;
            z-index: 1001;
            background-color: var(--primary-color);
            color: white;
            border: none;
            border-radius: 5px;
            padding: 8px 12px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        
        .toggle-sidebar:hover {
            background-color: #3d75a4;
        }
        
        /* Overlay for mobile when sidebar is active */
        .sidebar-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 999;
        }
        
        .doctor-info-card {
            background-color: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }
        
        .doctor-avatar-large {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 24px;
            margin-right: 20px;
        }
        
        .badge-specialty {
            background-color: #e3f2fd;
            color: #1565c0;
            font-weight: 500;
            padding: 6px 12px;
            border-radius: 4px;
        }
        
        /* Responsive styles */
        @media (max-width: 991px) {
            .sidebar {
                width: 220px;
            }
            .content {
                margin-left: 220px;
            }
        }
        
        @media (max-width: 768px) {
            .toggle-sidebar {
                display: block;
            }
            .sidebar {
                transform: translateX(-100%);
                width: 250px;
                z-index: 1000;
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
        }
    </style>
</head>
<body>
    <button class="toggle-sidebar" onclick="toggleSidebar()">☰</button>
    <div class="sidebar-overlay" id="sidebar-overlay" onclick="toggleSidebar()"></div>
    
    <div class="sidebar" id="sidebar">
        <div class="avatar">P+</div>
        <div class="patient-name mb-3">${sessionScope.username}</div>
        
        <div class="nav-item" onclick="navigateTo('Patient/Dashboard')">Dashboard</div>
        <div class="nav-item" onclick="navigateTo('Patient/Appointments')">Appointments</div>
        <div class="nav-item active" onclick="navigateTo('Patient/Doctors')">Doctors</div>
        <div class="nav-item" onclick="navigateTo('Patient/Profile')">Profile</div>
        <div class="nav-item" onclick="window.location.href='${pageContext.request.contextPath}/LogoutServlet'">
    Logout
</div>
    </div>
    
    <div class="content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Book Appointment</h2>
            <button class="btn btn-outline-primary" onclick="navigateTo('Patient/Doctors')">
                <i class="fas fa-arrow-left me-2"></i> Back to Doctors
            </button>
        </div>
        
        <!-- Doctor Information -->
        <div class="doctor-info-card">
            <div class="d-flex">
                <div class="doctor-avatar-large" style="background-color: hsl(${doctorId * 40 % 360}, 70%, 60%)">
                    ${fn:substring(doctorName, 4, 5)}
                </div>
                <div>
                    <h3>${doctorName}</h3>
                    <p class="mb-1"><span class="badge-specialty">${doctorSpecialty}</span></p>
                    <p class="mb-1">${doctorExperience} | ${doctorDegree}</p>
                    <p class="text-muted">${doctorContact}</p>
                </div>
            </div>
        </div>
        
        <p class="text-muted">Select a schedule from the doctor's available time slots</p>
        
        <!-- Schedule Container -->
        <div class="schedule-container">
            <div class="schedule-header">
                <i class="far fa-calendar-alt me-2"></i> Available Schedules
            </div>
            <div class="p-3">
                <div class="row">
                    <c:forEach items="${schedules}" var="scheduleInfo" varStatus="status">
                        <c:set var="scheduleParts" value="${fn:split(scheduleInfo, '|')}" />
                        <c:set var="scheduleId" value="${fn:trim(fn:substringAfter(scheduleParts[0], 'Schedule ID:'))}" />
                        <c:set var="doctorId" value="${fn:trim(fn:substringAfter(scheduleParts[1], 'Doctor ID:'))}" />
                        <c:set var="day" value="${fn:trim(fn:substringAfter(scheduleParts[2], 'Day:'))}" />
                        <c:set var="time" value="${fn:trim(fn:substringAfter(scheduleParts[3], 'Time:'))}" />
                        <c:set var="maxTokens" value="${fn:trim(fn:substringAfter(scheduleParts[4], 'Max Tokens:'))}" />
                        <c:set var="isAvailable" value="${fn:trim(fn:substringAfter(scheduleParts[5], 'Available:'))}" />
                        
                        <div class="col-md-6 col-lg-4">
                            <div class="schedule-card ${isAvailable eq 'Yes' ? '' : 'unavailable'} mb-3">
                                <div class="schedule-card-header">
                                    <span class="day-badge"><i class="far fa-calendar me-1"></i> ${day}</span>
                                    <span class="time-badge"><i class="far fa-clock me-1"></i> ${time}</span>
                                </div>
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <div>
                                            <small class="text-muted">Max patients: ${maxTokens}</small>
                                        </div>
                                        <div>
                                            <span class="badge ${isAvailable eq 'Yes' ? 'bg-success' : 'bg-secondary'}">
                                                ${isAvailable eq 'Yes' ? 'Available' : 'Unavailable'}
                                            </span>
                                        </div>
                                    </div>
                                    <c:choose>
                                        <c:when test="${isAvailable eq 'Yes'}">
                                            <a href="${pageContext.request.contextPath}/Patient/ConfirmAppointment?scheduleId=${scheduleId}" 
                                               class="btn btn-primary w-100">
                                                Select Slot
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn btn-secondary w-100" disabled>
                                                Not Available
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