<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Medical Dashboard</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --sidebar-bg: #4f5e95;
            --primary-color: #4f5e95;
            --light-bg: #f7f9fc;
            --confirmed-color: #e8f5e9;
            --pending-color: #e3f2fd;
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
        
        .stats-container {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            flex: 1;
            min-width: 200px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            position: relative;
            overflow: hidden;
        }
        
        .stat-title {
            font-size: 16px;
            color: #666;
            margin-bottom: 10px;
        }
        
        .stat-value {
            font-size: 36px;
            font-weight: bold;
            color: var(--primary-color);
        }
        
        .trend-indicator {
            position: absolute;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            right: 15px;
            top: 15px;
            opacity: 0.2;
        }
        
        .trend-up {
            background-color: #a5d6a7;
            color: #2e7d32;
        }
        
        .trend-down {
            background-color: #90caf9;
            color: #1565c0;
        }
        
        .appointments-container {
            background: white;
            border-radius: 10px;
            padding: 0;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            overflow: hidden;
        }
        
        .appointments-header {
            background-color: var(--primary-color);
            color: white;
            padding: 15px 20px;
            font-size: 18px;
            font-weight: bold;
        }
        
        .appointments-table {
            width: 100%;
        }
        
        .appointments-table th {
            background-color: #f5f5f5;
            color: #666;
            font-weight: 500;
            padding: 12px 20px;
            text-align: left;
        }
        
        .appointments-table td {
            padding: 12px 20px;
            border-bottom: 1px solid #eee;
        }
        
        .appointments-table tr:last-child td {
            border-bottom: none;
        }
        
        .patient-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            margin-right: 10px;
        }
        
        .patient-info {
            display: flex;
            align-items: center;
        }
        
        .status-badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 500;
        }
        
        .status-confirmed {
            background-color: var(--confirmed-color);
            color: #2e7d32;
        }
        
        .status-pending {
            background-color: var(--pending-color);
            color: #1565c0;
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
            background-color: #3d4a75;
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
        
        /* Responsive styles */
        @media (max-width: 991px) {
            .sidebar {
                width: 220px;
            }
            .content {
                margin-left: 220px;
            }
            .stats-container {
                flex-wrap: wrap;
            }
            .stat-card {
                flex: 0 0 calc(50% - 15px);
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
            .stat-card {
                flex: 0 0 100%;
            }
        }
    </style>
</head>
<body>
    <button class="toggle-sidebar" onclick="toggleSidebar()">☰</button>
    <div class="sidebar-overlay" id="sidebar-overlay" onclick="toggleSidebar()"></div>
    
    <div class="sidebar" id="sidebar">
        <div class="avatar">MD+</div>
        <div class="doctor-name mb-3">Dr. ${doctorName}</div>
        
        <div class="nav-item active" onclick="navigateTo('Dashboard')">Dashboard</div>
        <div class="nav-item" onclick="navigateTo('patients')">Patients</div>
        <div class="nav-item" onclick="navigateTo('appointments')">Appointments</div>
        <div class="nav-item" onclick="navigateTo('profile')">Profile</div>
        <div class="nav-item" onclick="navigateTo('settings')">Settings</div>
    </div>
    
    <div class="content">
        <h2>Dashboard</h2>
        <p class="text-muted" id="current-datetime"></p>
        
        <!-- Stats Cards -->
        <div class="stats-container">
            <div class="stat-card">
                <div class="stat-title">Today's Appointments</div>
                <div class="stat-value">${todayAppointments}</div>
                <div class="trend-indicator trend-up">↑</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-title">Pending Confirmations</div>
                <div class="stat-value">${pendingConfirmations}</div>
                <div class="trend-indicator trend-down">↓</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-title">New Patients</div>
                <div class="stat-value">${newPatients}</div>
                <div class="trend-indicator trend-up">↑</div>
            </div>
        </div>
        
        <!-- Appointments Table -->
        <div class="appointments-container">
            <div class="appointments-header">Today's Appointments</div>
            <table class="appointments-table">
                <!-- Add "Action" to your table header -->
				<thead>
				    <tr>
				        <th>Patient Name</th>
				        <th>Time</th>
				        <th>Token No</th>
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
				            <td>
				                <span class="status-badge ${appointment.status == 'CONFIRMED' ? 'status-confirmed' : 'status-pending'}">
				                    ${appointment.status}
				                </span>
				            </td>
				            <td>
				                <c:choose>
				                    <c:when test="${appointment.status == 'COMPLETED'}">
				                        <!-- If completed: View enabled, Complete disabled -->
				                        <button class="btn btn-sm btn-primary" onclick="viewAppointment(${appointment.appointmentId})">View</button>
				                        <button class="btn btn-sm btn-secondary" disabled>Complete</button>
				                    </c:when>
				                    <c:otherwise>
				                        <!-- If pending: View disabled, Complete enabled -->
				                        <button class="btn btn-sm btn-secondary" disabled>View</button>
				                        <button class="btn btn-sm btn-success" style="background-color: #61CE70; border-color: #61CE70;" 
				                                onclick="markCompleted(${appointment.appointmentId})">Complete</button>
				                    </c:otherwise>
				                </c:choose>
				            </td>
				        </tr>
				    </c:forEach>
				</tbody>
            </table>
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
            window.location.href = ''page;
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