<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient List</title>
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
        
        /* Patient Table Styles */
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
        
        /* Patient Avatar */
        .patient-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .doctor-avatar {
            width: 36px;
            height: 36px;
            margin-right: 5px;
            border-radius: 50%;
            background-color: var(--primary-light);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 500;
            font-size: 12px;
            color: var(--primary-color);
        }
        
        /* Filter Bar */
        .filter-bar {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .search-box {
            position: relative;
            flex-grow: 1;
            max-width: 500px;
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
            padding: 12px 12px;
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
            
        </div>
        
        <ul class="nav-menu">
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/Doctor/Dashboard" class="nav-link">
                    <i class="fas fa-chart-line"></i> Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/Doctor/Patient" class="nav-link active">
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
    	
    	<!-- Page Header -->
        <div class="page-header">
            <h1 class="page-title">Patients</h1>
        </div>
        
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
        


        
        <!-- Patients Table Card -->
        <div class="card ">
            <div class="card-header">

                <div><i class="fas fa-user-alt me-2"></i> Patient Records</div>
                <!-- Filter Bar -->
                <div class="filter-bar">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" id="searchInput" placeholder="Search by name, ID, phone ..." onkeyup="filterPatients()">
                    </div>

                    <select class="filter-dropdown" id="bloodTypeFilter" onchange="filterPatients()">
                        <option value="">All Blood Types</option>
                        <option value="A+">A+</option>
                        <option value="A-">A-</option>
                        <option value="B+">B+</option>
                        <option value="B-">B-</option>
                        <option value="AB+">AB+</option>
                        <option value="AB-">AB-</option>
                        <option value="O+">O+</option>
                        <option value="O-">O-</option>
                    </select>

                    <select class="filter-dropdown" id="sortBy" onchange="sortPatients()">
                        <option value="nameAsc">Name (A-Z)</option>
                        <option value="nameDesc">Name (Z-A)</option>
                        <option value="idAsc">ID (Low-High)</option>
                        <option value="idDesc">ID (High-Low)</option>
                    </select>

                    <button class="btn-filter btn-reset" onclick="resetFilters()">
                        <i class="fas fa-sync-alt"></i>
                    </button>
                </div>
            </div>

            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table mb-0" id="patientTable">
                        <thead>
                            <tr>
                                <th>Patient Name</th>
                                <th>Blood Type</th>
                                <th>Age</th>
                                <th>Gender</th>
                                <th>Phone</th>
                                <th>Email</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<Object[]> patients = (List<Object[]>) request.getAttribute("patients");
                                if (patients != null && !patients.isEmpty()) {
                                    for (Object[] row : patients) {
                                        String bloodType = row[0].toString();
                                        String firstName = row[1].toString();
                                        String lastName = row[2].toString();
                                        String initials = firstName.charAt(0) + "" + lastName.charAt(0);
                                        
                                        // Use color based on blood type
                                        String bgColor = "#64B5F6"; // Default color
                                        
                                        // Map blood types to different colors
                                        if (bloodType.startsWith("A")) {
                                            bgColor = "#4CAF50"; // Green
                                        } else if (bloodType.startsWith("B")) {
                                            bgColor = "#FF9800"; // Orange
                                        } else if (bloodType.startsWith("AB")) {
                                            bgColor = "#9C27B0"; // Purple
                                        } else if (bloodType.startsWith("O")) {
                                            bgColor = "#F44336"; // Red
                                        }
                                        
                                        String fullName = firstName + " " + lastName;
                                        String patientId = row[3].toString();
                                        String age = row[4].toString();
                                        String gender = row[5].toString();
                                        String phone = row[6].toString();
                                        String email = row[7].toString();
                            %>
                            <tr data-id="<%= patientId %>" 
                                data-name="<%= fullName %>"
                                data-blood="<%= bloodType %>"
                                data-phone="<%= phone %>"
                                data-email="<%= email %>"
                                onclick="viewPatient(<%= patientId %>)">
                                <td>
                                    <div class="patient-info">
                                        <div class="doctor-avatar">
                                            <%= initials.toUpperCase() %>
                                        </div>
                                        <%= fullName %>
                                    </div>
                                </td>
                                <td><%= bloodType %></td>
                                <td><%= age %></td>
                                <td><%= gender %></td>
                                <td><%= phone %></td>
                                <td><%= email %></td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="7" class="text-center text-danger" id="noResults">No patients found</td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
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
        
        function viewPatient(id) {
            console.log("Viewing patient ID: " + id);
            window.location.href = 'patient-details.jsp?id=' + id;
        }
        
        // Filter functions
        function filterPatients() {
            const searchText = document.getElementById('searchInput').value.toLowerCase();
            const bloodType = document.getElementById('bloodTypeFilter').value;
            
            const rows = document.querySelectorAll('#patientTable tbody tr');
            let visibleCount = 0;
            
            rows.forEach(row => {
                // Skip the "No patients found" row if present
                if (row.cells.length === 1 && row.cells[0].id === 'noResults') {
                    return;
                }
                
                const name = row.getAttribute('data-name').toLowerCase();
                const id = row.getAttribute('data-id');
                const phone = row.getAttribute('data-phone');
                const email = row.getAttribute('data-email').toLowerCase();
                const patientBloodType = row.getAttribute('data-blood');
                
                // Check if patient matches all selected filters
                const matchesSearch = name.includes(searchText) || 
                                     id.includes(searchText) || 
                                     phone.includes(searchText) ||
                                     email.includes(searchText);
                const matchesBloodType = bloodType === '' || patientBloodType === bloodType;
                
                // Show or hide based on filter results
                if (matchesSearch && matchesBloodType) {
                    row.style.display = '';
                    visibleCount++;
                } else {
                    row.style.display = 'none';
                }
            });
            
            // Show "No results" message if no patients match filters
            const noResultsRow = document.getElementById('noResults');
            if (noResultsRow) {
                if (visibleCount === 0) {
                    noResultsRow.parentElement.style.display = '';
                } else {
                    noResultsRow.parentElement.style.display = 'none';
                }
            }
        }
        
        function sortPatients() {
            const sortBy = document.getElementById('sortBy').value;
            const table = document.getElementById('patientTable');
            const tbody = table.querySelector('tbody');
            const rows = Array.from(tbody.querySelectorAll('tr'));
            
            // Filter out the "No patients found" row if present
            const dataRows = rows.filter(row => row.cells.length > 1 || row.cells[0].id !== 'noResults');
            
            // Sort patients based on selected criteria
            dataRows.sort((a, b) => {
                switch(sortBy) {
                    case 'nameAsc':
                        return a.getAttribute('data-name').localeCompare(b.getAttribute('data-name'));
                    case 'nameDesc':
                        return b.getAttribute('data-name').localeCompare(a.getAttribute('data-name'));
                    case 'idAsc':
                        return parseInt(a.getAttribute('data-id')) - parseInt(b.getAttribute('data-id'));
                    case 'idDesc':
                        return parseInt(b.getAttribute('data-id')) - parseInt(a.getAttribute('data-id'));
                    default:
                        return 0;
                }
            });
            
            // Clear the table body
            tbody.innerHTML = '';
            
            // Reappend sorted rows to the tbody
            dataRows.forEach(row => {
                tbody.appendChild(row);
            });
            
            // Add back the "No results" row if needed
            const noResultsRow = rows.find(row => row.cells.length === 1 && row.cells[0].id === 'noResults');
            if (noResultsRow) {
                tbody.appendChild(noResultsRow);
            }
        }
        
        function resetFilters() {
            document.getElementById('searchInput').value = '';
            document.getElementById('bloodTypeFilter').value = '';
            document.getElementById('sortBy').value = 'nameAsc';
            
            filterPatients();
            sortPatients();
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