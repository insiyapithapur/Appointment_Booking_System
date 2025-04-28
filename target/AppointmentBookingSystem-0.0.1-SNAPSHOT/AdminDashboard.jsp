<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
        }
        
        /* Statistics Cards */
        .statistics-row {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            flex: 1;
            min-width: 240px;
            background-color: var(--bg-color);
            border-radius: 10px;
            padding: 20px;
            border: 1px solid var(--border-color);
            box-shadow: 0 2px 6px rgba(77, 171, 247, 0.04);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .stat-info h3 {
            font-size: 14px;
            font-weight: 500;
            color: var(--text-secondary);
            margin-bottom: 10px;
        }
        
        .stat-info p {
            font-size: 24px;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 5px;
        }
        
        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 8px;
            background-color: var(--primary-light);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary-color);
            font-size: 18px;
        }
        
        /* Card */
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
        
        /* Doctors list styles */
        .doctors-container {
            background-color: var(--bg-color);
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
            box-shadow: 0 2px 6px rgba(77, 171, 247, 0.04);
            border: 1px solid var(--border-color);
        }
        
        .doctors-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .doctors-title {
            font-size: 18px;
            font-weight: 600;
            color: var(--primary-color);
        }
        
        .total-appointments {
            background-color: var(--primary-color);
            color: white;
            border-radius: 20px;
            padding: 5px 15px;
            font-size: 14px;
            font-weight: 500;
        }
        
        .doctors-list {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .doctor-card {
            background-color: var(--primary-light);
            border-radius: 10px;
            padding: 15px;
            width: calc(25% - 15px);
            min-width: 200px;
            display: flex;
            flex-direction: column;
            align-items: center;
            cursor: pointer;
            transition: all 0.3s;
            position: relative;
            border: 1px solid var(--border-color);
        }
        
        .doctor-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .doctor-card.active {
            background-color: rgba(33, 150, 83, 0.1);
            border: 2px solid var(--confirmed-color);
        }
        
        .doctor-card.active::after {
            content: "Active";
            position: absolute;
            top: 10px;
            right: 10px;
            background-color: var(--confirmed-color);
            color: white;
            font-size: 12px;
            padding: 2px 8px;
            border-radius: 10px;
        }
        
        .doctor-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background-color: var(--primary-color);
            color: white;
            font-size: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 10px;
        }
        
        .doctor-name {
            font-weight: 600;
            margin-bottom: 5px;
            color: var(--text-primary);
        }
        
        .doctor-specialty {
            font-size: 12px;
            color: var(--text-secondary);
            margin-bottom: 5px;
        }
        
        .doctor-appointments {
            font-size: 12px;
            color: var(--primary-color);
            font-weight: 500;
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
            .doctor-card {
                width: calc(33.33% - 15px);
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
            
            .doctor-card {
                width: calc(50% - 15px);
            }
            
            .statistics-row {
                flex-direction: column;
            }
            
            .stat-card {
                width: 100%;
            }
            
            .header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
        }
        
        @media (max-width: 576px) {
            .doctor-card {
                width: 100%;
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
                A
            </div>
            <div class="profile-name">Admin</div>
            <div class="profile-title">System Administrator</div>
            <div class="profile-badge">
                <i class="fas fa-circle"></i> Admin Portal
            </div>
        </div>
        
        <ul class="nav-menu">
            <li class="nav-item">
                <a onclick="navigateTo('Admin/Dashboard')" class="nav-link active">
                    <i class="fas fa-home"></i> Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a onclick="navigateTo('Admin/Patients')" class="nav-link">
                    <i class="fas fa-user-injured"></i> Patients
                </a>
            </li>
            <li class="nav-item">
                <a onclick="navigateTo('Admin/Doctors')" class="nav-link">
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
        
        <!-- Statistics Cards -->
        <div class="card">
            <div class="card-header">
                <div><i class="fas fa-chart-line me-2"></i>System Overview</div>
            </div>
            <div class="p-3">
            	<div class="statistics-row">

		            <div class="stat-card">
		                <div class="stat-info">
		                    <h3>Total Patients</h3>
		                    <p>
		                        <c:out value="${totalPatients}" default="0" />
		                    </p>
		                </div>
		                <div class="stat-icon">
		                    <i class="fas fa-user-injured"></i>
		                </div>
		            </div>
		            
		            <div class="stat-card">
		                <div class="stat-info">
		                    <h3>Total Doctors</h3>
		                    <p>
		                        <c:out value="${doctorCount}" default="0" />
		                    </p>
		                </div>
		                <div class="stat-icon">
		                    <i class="fas fa-user-md"></i>
		                </div>
		            </div>
		            
		            <div class="stat-card">
		                <div class="stat-info">
		                    <h3>Total Appointments</h3>
		                    <p>
		                        <c:out value="${totalAppointments}" default="0" />
		                    </p>
		                </div>
		                <div class="stat-icon">
		                    <i class="fas fa-calendar-check"></i>
		                </div>
		            </div>
		        </div>
            </div>
         </div>

        <!-- Active Doctors Card -->
        <div class="card">
            <div class="card-header">
                <div><i class="fas fa-user-md me-2"></i> Active Doctors</div>
                <div class="total-appointments">
                    <c:out value="${activeDoctorCount}" default="0" /> Active
                </div>
            </div>
            
            <div class="p-3">
                <div class="doctors-list">
                    <!-- Dynamically generate doctor cards based on activeDoctors list -->
                    <c:choose>
                        <c:when test="${empty activeDoctors}">
                            <p class="text-center w-100">No active doctors available today.</p>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${activeDoctors}" var="doctor">
                                <div class="doctor-card">
                                    <div class="doctor-avatar">${fn:substring(doctor.name, 0, 1)}</div>
                                    <div class="doctor-name">${doctor.name}</div>
                                    <div class="doctor-specialty">${doctor.specialization}</div>
                                    <div class="doctor-appointments">${doctor.pendingAppointments} appointments today</div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
        
        <!-- Today Appointment Overview Card -->
        <div class="card">
            <div class="card-header">
                <div><i class="fas fa-chart-line me-2"></i> Today's Appointment Overview</div>
                <div class="total-appointments">
                    <c:out value="${todayTotalAppointments}" default="0" /> TOTAL
                </div>
            </div>
            
            <div class="p-3">
                <div class="statistics-row">
                    
                    <div class="stat-card">
		                <div class="stat-info">
		                    <h3>Pending Appointments</h3>
		                    <p>
		                        <c:out value="${todayPendingAppointments}" default="0" />
		                    </p>
		                </div>
		                <div class="stat-icon" style="background-color: rgba(242, 153, 74, 0.1); color: var(--pending-color);">
		                    <i class="fas fa-hourglass-half"></i>
		                </div>
		            </div>
		            
		            <div class="stat-card">
		                <div class="stat-info">
		                    <h3>Completed Appointments</h3>
		                    <p>
		                        <c:out value="${todayCompletedAppointments}" default="0" />
		                    </p>
		                </div>
		                <div class="stat-icon" style="background-color: rgba(33, 150, 83, 0.1); color: var(--confirmed-color);">
		                    <i class="fas fa-check-circle"></i>
		                </div>
		            </div>
		            
		            <div class="stat-card">
		                <div class="stat-info">
		                    <h3>Cancelled Appointments</h3>
		                    <p>
		                        <c:out value="${todayCancelledAppointments}" default="0" />
		                    </p>
		                </div>
		                <div class="stat-icon" style="background-color: rgba(235, 87, 87, 0.1); color: var(--cancelled-color);">
		                    <i class="fas fa-calendar-times"></i>
		                </div>
		            </div>
		            
                </div>
            </div>
        </div>
        
        <!-- Overall Appointment Statistics -->
		<div class="card">
		    <div class="card-header">
		        <div><i class="fas fa-clipboard-list me-2"></i> Overall Appointment Statistics</div>
		        <div class="total-appointments">
                    <c:out value="${totalAppointments}" default="0" /> TOTAL
                </div>
		    </div>
		    
		    <div class="p-3">
		        <div class="statistics-row">
		            <div class="stat-card">
		                <div class="stat-info">
		                    <h3>Pending Appointments</h3>
		                    <p>
		                        <c:out value="${pendingAppointments}" default="0" />
		                    </p>
		                </div>
		                <div class="stat-icon" style="background-color: rgba(242, 153, 74, 0.1); color: var(--pending-color);">
		                    <i class="fas fa-hourglass-half"></i>
		                </div>
		            </div>
		            
		            <div class="stat-card">
		                <div class="stat-info">
		                    <h3>Completed Appointments</h3>
		                    <p>
		                        <c:out value="${completedAppointments}" default="0" />
		                    </p>
		                </div>
		                <div class="stat-icon" style="background-color: rgba(33, 150, 83, 0.1); color: var(--confirmed-color);">
    <i class="fas fa-check-circle"></i>
</div>
</div>

<div class="stat-card">
    <div class="stat-info">
        <h3>Cancelled Appointments</h3>
        <p>
            <c:out value="${cancelledAppointments}" default="0" />
        </p>
    </div>
    <div class="stat-icon" style="background-color: rgba(235, 87, 87, 0.1); color: var(--cancelled-color);">
        <i class="fas fa-calendar-times"></i>
    </div>
</div>

</div>
</div>
</div>

<!-- Patient Stats Card -->
<div class="card">
    <div class="card-header">
        <div><i class="fas fa-user-injured me-2"></i> Patient Statistics</div>
        <div class="total-appointments">
                    <c:out value="${totalPatients}" default="0" /> TOTAL
                </div>
    </div>
    
    <div class="p-3">
        <div class="statistics-row">
            <div class="stat-card">
                <div class="stat-info">
                    <h3>Inactive Patients</h3>
                    <p><c:out value="${inactivePatients}" default="0" /></p>
                </div>
                <div class="stat-icon" style="background-color: var(--primary-light); color: var(--primary-color);">
                    <i class="fas fa-users"></i>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-info">
                    <h3>Active Patients</h3>
                    <p><c:out value="${activePatients}" default="0" /></p>
                </div>
                <div class="stat-icon" style="background-color: rgba(33, 150, 83, 0.1); color: var(--confirmed-color);">
                    <i class="fas fa-user-check"></i>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-info">
                    <h3>New Patients (Week)</h3>
                    <p><c:out value="${newPatientsThisWeek}" default="0" /></p>
                </div>
                <div class="stat-icon" style="background-color: rgba(242, 153, 74, 0.1); color: var(--pending-color);">
                    <i class="fas fa-user-plus"></i>
                </div>
            </div>
            
        </div>
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
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit'
        };
        
        const formattedDateTime = now.toLocaleDateString('en-US', options);
        document.getElementById('current-datetime').textContent = formattedDateTime;
    }
    
    // Update date and time when page loads
    updateDateTime();
    
    // Update date and time every second
    setInterval(updateDateTime, 1000);
    
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
    
    // Document ready function
    document.addEventListener('DOMContentLoaded', function() {
        // Any initialization code can go here
        console.log("Dashboard fully loaded");
    });
</script>
</body>
</html>