<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointments List</title>
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
        .filter-section {
            padding: 15px;
        }
        
        .search-box {
            position: relative;
        }
        
        .search-box .search-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-secondary);
            z-index: 2;
        }
        
        .search-box input {
            padding-left: 40px;
            border-radius: 6px;
            border: 1px solid var(--border-color);
            font-size: 14px;
            height: 38px;
        }
        
        .form-select {
            border: 1px solid var(--border-color);
            border-radius: 6px;
            font-size: 14px;
            height: 38px;
        }
        
        /* Appointment Table */
        .table-container {
            background-color: var(--bg-color);
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 6px rgba(77, 171, 247, 0.04);
            border: 1px solid var(--border-color);
        }
        
        .appointment-table {
            width: 100%;
            margin-bottom: 0;
        }
        
        .appointment-table th {
            padding: 12px 16px;
            font-weight: 600;
            color: var(--text-primary);
            background-color: var(--primary-light);
            border-bottom: 1px solid var(--border-color);
            white-space: nowrap;
        }
        
        .appointment-table td {
            padding: 12px 16px;
            vertical-align: middle;
            border-bottom: 1px solid var(--border-color);
        }
        
        .appointment-table tr:last-child td {
            border-bottom: none;
        }
        
        .appointment-table tbody tr {
            transition: all 0.2s;
            cursor: pointer;
        }
        
        .appointment-table tbody tr:hover {
            background-color: var(--primary-light);
        }
        
        /* Status Badges */
        .status-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
            display: inline-block;
            text-align: center;
            text-transform: uppercase;
        }
        
        .status-confirmed {
            background-color: rgba(33, 150, 83, 0.1);
            color: var(--confirmed-color);
        }
        
        .status-pending {
            background-color: rgba(242, 153, 74, 0.1);
            color: var(--pending-color);
        }
        
        .status-cancelled {
            background-color: rgba(235, 87, 87, 0.1);
            color: var(--cancelled-color);
        }
        
        .status-completed {
            background-color: rgba(47, 128, 237, 0.1);
            color: var(--completed-color);
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
        
        /* No Results Message */
        .alert-no-results {
            background-color: rgba(77, 171, 247, 0.05);
            color: var(--primary-color);
            padding: 20px;
            border-radius: 6px;
            text-align: center;
            width: 100%;
            font-size: 14px;
            border: 1px solid rgba(77, 171, 247, 0.1);
        }
        
        /* Button Styles */
        .btn {
            padding: 8px 16px;
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
            background-color: var(--primary-light);
            color: var(--primary-color);
            border-color: var(--primary-color);
        }
        
        /* Error message */
        .error {
            background-color: rgba(235, 87, 87, 0.1);
            color: var(--cancelled-color);
            padding: 10px;
            border-radius: 6px;
            margin-bottom: 20px;
            border: 1px solid rgba(235, 87, 87, 0.2);
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
            
            .filters-row .col-md-2, 
            .filters-row .col-md-4 {
                margin-bottom: 10px;
            }
            
            .table-container {
                overflow-x: auto;
            }
        }
        
        @media (max-width: 576px) {
            .content {
                padding: 15px;
            }
            
            .hide-xs {
                display: none;
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
                <a onclick="navigateTo('Admin/Dashboard')" class="nav-link">
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
                <a onclick="navigateTo('Admin/Appointments')" class="nav-link active">
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
        <!-- Page Header -->
        <div class="page-header">
            <h1 class="page-title">Appointments Management</h1>
        </div>

        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>

        <!-- Filter Card -->
        <div class="card mb-4">
            <div class="card-header">
                <div><i class="fas fa-filter me-2"></i> Filter Appointments</div>
                <button class="btn btn-sm btn-outline-primary" type="button" data-bs-toggle="collapse" data-bs-target="#filterCollapse" aria-expanded="true" aria-controls="filterCollapse">
                    <i class="fas fa-chevron-down"></i>
                </button>
            </div>
            <div class="collapse show" id="filterCollapse">
                <div class="filter-section">
                    <div class="row align-items-center">
                        <div class="col-md-4 mb-2 mb-md-0">
                            <div class="search-box">
                                <i class="fas fa-search search-icon"></i>
                                <input type="text" id="searchInput" class="form-control" placeholder="Search appointments..." oninput="filterAppointments()">
                            </div>
                        </div>
                        
                        <div class="col-md-3 mb-2 mb-md-0">
                            <input type="date" class="form-control" id="dateFilter" onchange="filterAppointments()">
                        </div>
                        
                        <div class="col-md-3 mb-2 mb-md-0">
                            <select class="form-select" id="sortBy" onchange="sortAppointments()">
                                <option value="dateAsc">Date (Oldest First)</option>
                                <option value="dateDesc">Date (Newest First)</option>
                                <option value="patientAsc">Patient Name (A-Z)</option>
                                <option value="patientDesc">Patient Name (Z-A)</option>
                            </select>
                        </div>
                        
                        <div class="col-md-2 text-md-end">
                            <button class="btn btn-outline-secondary" onclick="resetFilters()">
							    <i class="fas fa-redo me-1"></i> 
							</button>
                        </div>
                    </div>
                    
                    <!-- Active Filters Display (matching doctor management page) -->
                    <div class="mt-3">
                        <div class="filter-badges" id="active-filters">
                            <!-- Active filters will be displayed here -->
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Appointment Table -->
        <div class="table-container mb-4">
            <table class="table appointment-table" id="appointmentTable">
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Patient</th>
                        <th>Doctor</th>
                        <th class="hide-xs">Reason</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="appointmentTableBody">
                    <c:forEach var="a" items="${appointments}">
                        <tr class="appointment-row" 
                            data-id="${a.appointmentId}" 
                            data-date="${a.appointmentDate}"
                            data-patient="${a.patient.user.username}"
                            data-status="${a.status.statusName.toLowerCase()}">
                            <td>${a.appointmentDate}</td>
                            <td>
							    <div class="d-flex align-items-center">
							        <div>${a.patient.user.username}</div>
							    </div>
							</td>
							
							<td>
							    <div class="d-flex align-items-center">
							        <div>Dr. ${a.schedule.doctor.user.username}</div>
							    </div>
							</td>
							
                            <td class="hide-xs">
                                <div class="d-inline-block text-truncate" style="max-width: 150px;" 
                                    title="${a.reason}">
                                    ${a.reason}
                                </div>
                            </td>
                            
                            <td>
                                <span class="status-badge status-${a.status.statusName.toLowerCase()}">
                                    ${a.status.statusName}
                                </span>
                            </td>
                            
                            <td>
							    <c:choose>
							        <c:when test="${fn:toLowerCase(a.status.statusName) eq 'pending'}">
							            <!-- If status is PENDING: Show Complete button -->
							            <a href="${pageContext.request.contextPath}/Admin/CompleteAppointment?appointmentId=${a.appointmentId}" 
							               class="btn btn-sm btn-success" style="background-color: var(--confirmed-color); border-color: var(--confirmed-color);"
							               onclick="event.stopPropagation();">
							                <i class="fas fa-check-circle"></i>
							            </a>
							        </c:when>
							        <c:when test="${fn:toLowerCase(a.status.statusName) eq 'completed'}">
							            <!-- If status is COMPLETED: Show View button -->
							            <a href="${pageContext.request.contextPath}/Admin/ViewMedicalRecord?appointmentId=${a.appointmentId}" 
							               class="btn btn-sm btn-primary" style="background-color: var(--primary-color); border-color: var(--primary-color);"
							               onclick="event.stopPropagation();">
							                <i class="fas fa-eye"></i>
							            </a>
							        </c:when>
							        <c:when test="${fn:toLowerCase(a.status.statusName) eq 'cancelled'}">
							            <!-- If status is CANCELLED: Show NA text -->
							            <span class="text-muted">NA</span>
							        </c:when>
							        <c:otherwise>
							            <!-- Default case: Show view button -->
							            <button class="btn btn-sm btn-outline-primary" onclick="event.stopPropagation(); viewAppointment('${a.appointmentId}')">
							                <i class="fas fa-eye"></i>
							            </button>
							        </c:otherwise>
							    </c:choose>
							</td>
                        </tr>
                    </c:forEach>
                    
                    <c:if test="${empty appointments}">
                        <tr id="noResultsRow">
                            <td colspan="6" class="text-center py-4">
                                <div class="alert-no-results">
                                    <i class="fas fa-calendar-times me-2"></i> No appointments found
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
        
        function viewAppointment(id) {
            // In a real application, this would navigate to the appointment details page
            console.log("Viewing appointment ID: " + id);
            window.location.href = 'DoctorMedicalRecordView.jsp?id=' + id;
        }
        
        // Debounce function to limit how often a function can run
        function debounce(func, wait) {
            let timeout;
            return function(...args) {
                clearTimeout(timeout);
                timeout = setTimeout(() => func.apply(this, args), wait);
            };
        }

     // Fixed clearFilter function - adding event.stopPropagation
        function clearFilter(filterType) {
            // Stop event propagation to prevent row click
            event.stopPropagation();
            
            if (filterType === 'search') {
                document.getElementById('searchInput').value = '';
                activeFilters.search = '';
            } else if (filterType === 'date') {
                document.getElementById('dateFilter').value = '';
                activeFilters.date = '';
            }
            
            // Update the UI
            filterAppointments();
        }

        // Fixed resetFilters function
        function resetFilters() {
            // Reset input values
            document.getElementById('searchInput').value = '';
            document.getElementById('dateFilter').value = '';
            document.getElementById('sortBy').value = 'dateAsc';
            
            // Reset activeFilters object
            activeFilters = {
                search: '',
                date: ''
            };
            
            // Clear the filter badges display
            const activeFiltersContainer = document.getElementById('active-filters');
            if (activeFiltersContainer) {
                activeFiltersContainer.innerHTML = '';
            }
            
            // Apply the filters and sort
            filterAppointments();
            sortAppointments();
        }

        // Updated updateActiveFiltersDisplay function
        function updateActiveFiltersDisplay() {
            const activeFiltersContainer = document.getElementById('active-filters');
            if (!activeFiltersContainer) return;
            
            // Clear existing badges
            activeFiltersContainer.innerHTML = '';
            
            // Get current filter values
            const searchValue = document.getElementById('searchInput').value;
            const dateValue = document.getElementById('dateFilter').value;
            
            // Update activeFilters object
            activeFilters.search = searchValue;
            activeFilters.date = dateValue;
            
            // Add search filter badge if there's a search value
            if (activeFilters.search) {
                const badge = document.createElement('div');
                badge.className = 'filter-badge';
                badge.innerHTML = `Search: ${activeFilters.search} <span onclick="event.stopPropagation(); clearFilter('search')">×</span>`;
                activeFiltersContainer.appendChild(badge);
            }
            
            // Add date filter badge if there's a date value
            if (activeFilters.date) {
                const badge = document.createElement('div');
                badge.className = 'filter-badge';
                badge.innerHTML = `Date: ${activeFilters.date} <span onclick="event.stopPropagation(); clearFilter('date')">×</span>`;
                activeFiltersContainer.appendChild(badge);
            }
        }
        
        function sortAppointments() {
            const sortBy = document.getElementById('sortBy').value;
            const tbody = document.getElementById('appointmentTableBody');
            const appointments = Array.from(document.querySelectorAll('.appointment-row'));
            
            // Sort appointments based on selected criteria
            appointments.sort((a, b) => {
                switch(sortBy) {
                    case 'dateAsc':
                        return a.getAttribute('data-date').localeCompare(b.getAttribute('data-date'));
                    case 'dateDesc':
                        return b.getAttribute('data-date').localeCompare(a.getAttribute('data-date'));
                    case 'patientAsc':
                        return a.getAttribute('data-patient').localeCompare(b.getAttribute('data-patient'));
                    case 'patientDesc':
                        return b.getAttribute('data-patient').localeCompare(a.getAttribute('data-patient'));
                    default:
                        return 0;
                }
            });
            
            // Get any non-appointment rows (like "no results" message)
            const otherRows = Array.from(tbody.querySelectorAll('tr:not(.appointment-row)'));
            
            // Clear the table body
            tbody.innerHTML = '';
            
            // Add the sorted appointment rows
            appointments.forEach(appointment => {
                tbody.appendChild(appointment);
            });
            
            // Add back the other rows
            otherRows.forEach(row => {
                tbody.appendChild(row);
            });
        }
        
     // Fixed filterAppointments function
        function filterAppointments() {
            const searchText = document.getElementById('searchInput').value.toLowerCase();
            const dateFilter = document.getElementById('dateFilter').value;
            
            console.log("Filtering with search:", searchText, "and date:", dateFilter);
            
            const appointments = document.querySelectorAll('.appointment-row');
            let visibleCount = 0;
            
            appointments.forEach(appointment => {
                const id = appointment.getAttribute('data-id');
                const date = appointment.getAttribute('data-date');
                const patient = appointment.getAttribute('data-patient').toLowerCase();
                const status = appointment.getAttribute('data-status');
                
                // Check if appointment matches all selected filters
                const matchesSearch = searchText === '' || 
                                     id.includes(searchText) || 
                                     patient.includes(searchText) || 
                                     status.includes(searchText);
                                     
                const matchesDate = dateFilter === '' || date === dateFilter;
                
                // Show or hide based on filter results
                if (matchesSearch && matchesDate) {
                    appointment.style.display = '';
                    visibleCount++;
                } else {
                    appointment.style.display = 'none';
                }
            });
            
            // Show "No results" message if no appointments match filters
            const tbody = document.getElementById('appointmentTableBody');
            const existingNoResults = document.getElementById('dynamicNoResults');
            
            // Remove existing "no results" row if it exists
            if (existingNoResults) {
                existingNoResults.remove();
            }
            
            if (visibleCount === 0 && appointments.length > 0) {
                // Create a "no results" row
                const noResultsRow = document.createElement('tr');
                noResultsRow.id = 'dynamicNoResults';
                noResultsRow.innerHTML = `
                    <td colspan="6" class="text-center py-4">
                        <div class="alert-no-results">
                            <i class="fas fa-filter me-2"></i> No appointments match your filters
                        </div>
                    </td>
                `;
                tbody.appendChild(noResultsRow);
            }
            
            // Update active filters display
            updateActiveFiltersDisplay();
        }

        // Enhanced DOM loaded event handler
        document.addEventListener('DOMContentLoaded', function() {
            console.log("Document loaded, initializing event listeners");
            
            // Set up search input for real-time filtering with debounce
            const searchInput = document.getElementById('searchInput');
            if (searchInput) {
                const debouncedFilter = debounce(filterAppointments, 300);
                searchInput.addEventListener('input', debouncedFilter);
                
                // Add Escape key functionality to clear search
                searchInput.addEventListener('keyup', function(e) {
                    if (e.key === 'Escape') {
                        this.value = '';
                        filterAppointments();
                    }
                });
            }
            
            // Setup date filter with correct event
            const dateFilter = document.getElementById('dateFilter');
            if (dateFilter) {
                dateFilter.addEventListener('input', filterAppointments);
                dateFilter.addEventListener('change', filterAppointments);
            }
            
            // Set up sort by dropdown
            const sortBySelect = document.getElementById('sortBy');
            if (sortBySelect) {
                sortBySelect.addEventListener('change', sortAppointments);
            }
            
            // Add click event to appointment rows
            const appointmentRows = document.querySelectorAll('.appointment-row');
            appointmentRows.forEach(row => {
                row.addEventListener('click', function() {
                    const id = this.getAttribute('data-id');
                    viewAppointment(id);
                });
            });
            
            // Add event listener to reset button
            const resetButton = document.querySelector('button[onclick="resetFilters()"]');
            if (resetButton) {
                resetButton.addEventListener('click', resetFilters);
            }
            
            // Handle responsive behavior
            window.addEventListener('resize', function() {
                if (window.innerWidth > 768) {
                    document.getElementById("sidebar").classList.remove("active");
                    document.getElementById("sidebar-overlay").classList.remove("active");
                }
            });
        });
    </script>
</body>
</html>