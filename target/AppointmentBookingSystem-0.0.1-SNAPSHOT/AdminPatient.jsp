<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
            --active-color: #81C784;
            --inactive-color: #E57373;
            --new-color: #FFD54F;
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
        }
        
        /* Filter Card */
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
        
        /* Filters Row */
        .filters-row {
            padding: 15px;
        }
        
        .search-box {
            position: relative;
        }
        
        .search-box .search-icon {
            position: absolute;
            top: 50%;
            left: 15px;
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
        
        /* Patient Table */
        .table-container {
            background-color: var(--bg-color);
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 6px rgba(77, 171, 247, 0.04);
            border: 1px solid var(--border-color);
        }
        
        .patient-table {
            width: 100%;
            margin-bottom: 0;
        }
        
        .patient-table th {
            padding: 12px 16px;
            font-weight: 600;
            color: var(--text-primary);
            background-color: var(--primary-light);
            border-bottom: 1px solid var(--border-color);
            white-space: nowrap;
        }
        
        .patient-table td {
            padding: 12px 16px;
            vertical-align: middle;
            border-bottom: 1px solid var(--border-color);
        }
        
        .patient-table tr:last-child td {
            border-bottom: none;
        }
        
        .patient-table tbody tr {
            transition: all 0.2s;
            cursor: pointer;
        }
        
        .patient-table tbody tr:hover {
            background-color: var(--primary-light);
        }
        
        /* Patient Avatar */
        .patient-avatar {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background-color: var(--primary-light);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary-color);
            font-weight: 600;
            font-size: 14px;
            margin-right: 10px;
        }
        
        /* Status Badge */
        .patient-status-badge {
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
            display: inline-block;
            text-align: center;
        }
        
        .status-active {
            background-color: rgba(33, 150, 83, 0.1);
            color: var(--confirmed-color);
        }
        
        .status-inactive {
            background-color: rgba(235, 87, 87, 0.1);
            color: var(--cancelled-color);
        }
        
        .status-new {
            background-color: rgba(242, 153, 74, 0.1);
            color: var(--pending-color);
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
        
        .btn-outline-secondary {
            color: var(--text-secondary);
            border-color: var(--border-color);
        }
        
        .btn-outline-secondary:hover {
            background-color: var(--primary-light);
            color: var(--primary-color);
            border-color: var(--primary-color);
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
                <a onclick="navigateTo('Admin/Patients')" class="nav-link active">
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
        <!-- Page Header -->
        <div class="page-header">
            <h1 class="page-title">Patient Management</h1>
        </div>
        
        <!-- Filter Card -->
        <div class="card mb-4">
            <div class="card-header">
                <div><i class="fas fa-filter me-2"></i> Filter Patients</div>
                <button class="btn btn-sm btn-outline-primary" type="button" data-bs-toggle="collapse" data-bs-target="#filterCollapse" aria-expanded="true" aria-controls="filterCollapse">
                    <i class="fas fa-chevron-down"></i>
                </button>
            </div>
            <div class="collapse show" id="filterCollapse">
                <div class="filters-row">
                    <div class="row align-items-center">
                        <div class="col-md-4 mb-2 mb-md-0">
                            <div class="search-box">
                                <i class="fas fa-search search-icon"></i>
                                <input type="text" class="form-control" id="searchInput" placeholder="Search patients..." oninput="filterPatients()">
                            </div>
                        </div>
                        <div class="col-md-2 mb-2 mb-md-0">
                            <select class="form-select" id="bloodTypeFilter" onchange="filterPatients()">
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
                        </div>
                        <div class="col-md-2 mb-2 mb-md-0">
                            <select class="form-select" id="statusFilter" onchange="filterPatients()">
                                <option value="">All Statuses</option>
                                <option value="active">Active</option>
                                <option value="inactive">Inactive</option>
                            </select>
                        </div>
                        <div class="col-md-2 mb-2 mb-md-0">
                            <select class="form-select" id="sortBy" onchange="sortPatients()">
                                <option value="nameAsc">Name (A-Z)</option>
                                <option value="nameDesc">Name (Z-A)</option>
                            </select>
                        </div>
                        <div class="col-md-2 text-md-end">
                            <button class="btn btn-outline-secondary" onclick="resetFilters()">
                                <i class="fas fa-redo me-1"></i> 
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Patient Table -->
        <div class="table-container mb-4">
            <table class="table patient-table" id="patientTable">
                <thead>
                    <tr>
                        <th>Patient</th>
                        <th>Patient Username</th>
                        <th>Blood Type</th>
                        <th class="hide-xs">Phone</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody id="patientTableBody">
                    <%
                        List<Object[]> patients = (List<Object[]>) request.getAttribute("patients");
                        if (patients != null && !patients.isEmpty()) {
                            for (Object[] row : patients) {
                                String initials = row[1].toString().charAt(0) + "" + row[2].toString().charAt(0);
                                
                                // Randomly assign a status for demonstration purposes
                                String[] statuses = {"active", "inactive", "new"};
                                String status = statuses[(int)(Math.random() * 3)];
                                String statusClass = "status-" + status;
                                String statusText = status.substring(0, 1).toUpperCase() + status.substring(1);
                    %>
                    <tr class="patient-row" onclick="viewPatient('<%= row[3] %>')"
                        data-name="<%= row[1] %> <%= row[2] %>"
                        data-id="<%= row[3] %>"
                        data-blood="<%= row[0] %>"
                        data-status="<%= status %>"
                        data-phone="<%= row[6] %>"
                        data-recent="March 10, 2025">
                        <td>
                            <div class="d-flex align-items-center">
                                <div class="patient-avatar"><%= initials %></div>
                                <div><%= row[1] %> <%= row[2] %></div>
                            </div>
                        </td>
                        <td><%= row[3] %></td>
                        <td><%= row[0] %></td>
                        <td class="hide-xs"><%= row[6] %></td>
                        <td><span class="patient-status-badge <%= statusClass %>"><%= statusText %></span></td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr id="noResultsRow">
                        <td colspan="7" class="text-center py-4">
                            <div class="alert-no-results">
                                <i class="fas fa-user-slash me-2"></i> No patients found
                            </div>
                        </td>
                    </tr>
                    <%
                        }
                    %>
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
        
        function viewPatient(id) {
            // In a real application, this would navigate to the patient details page
            console.log("Viewing patient ID: " + id);
            window.location.href = '${pageContext.request.contextPath}/Admin/PatientDetails?id=' + id;
        }
        
        function editPatient(id) {
            // In a real application, this would navigate to the patient edit page
            console.log("Editing patient ID: " + id);
            window.location.href = '${pageContext.request.contextPath}/Admin/EditPatient?id=' + id;
        }
        
        function addNewPatient() {
            // Navigate to add new patient page
            window.location.href = '${pageContext.request.contextPath}/Admin/AddPatient';
        }
        
        // Filter functions
        function filterPatients() {
            const searchText = document.getElementById('searchInput').value.toLowerCase();
            const bloodType = document.getElementById('bloodTypeFilter').value;
            const status = document.getElementById('statusFilter').value;
            
            const patients = document.querySelectorAll('.patient-row');
            let visibleCount = 0;
            
            patients.forEach(patient => {
                const name = patient.getAttribute('data-name').toLowerCase();
                const id = patient.getAttribute('data-id');
                const phone = patient.getAttribute('data-phone');
                const patientBloodType = patient.getAttribute('data-blood');
                const patientStatus = patient.getAttribute('data-status');
                
                // Check if patient matches all selected filters
                const matchesSearch = name.includes(searchText) || 
                                     id.includes(searchText) || 
                                     phone.includes(searchText);
                const matchesBloodType = bloodType === '' || patientBloodType === bloodType;
                const matchesStatus = status === '' || patientStatus === status;
                
                // Show or hide based on filter results
                if (matchesSearch && matchesBloodType && matchesStatus) {
                    patient.style.display = '';
                    visibleCount++;
                } else {
                    patient.style.display = 'none';
                }
            });
            
            // Show "No results" message if no patients match filters
            const noResultsRow = document.getElementById('noResultsRow');
            if (noResultsRow) {
                if (visibleCount === 0 && patients.length > 0) {
                    // Create "no results" row if it doesn't exist
                    if (!document.getElementById('dynamicNoResults')) {
                        const tbody = document.getElementById('patientTableBody');
                        const noResultsTr = document.createElement('tr');
                        noResultsTr.id = 'dynamicNoResults';
                        noResultsTr.innerHTML = `
                            <td colspan="7" class="text-center py-4">
                                <div class="alert-no-results">
                                    <i class="fas fa-filter me-2"></i> No patients match your filters
                                </div>
                            </td>
                        `;
                        tbody.appendChild(noResultsTr);
                    }
                } else {
                    // Remove dynamic "no results" row if it exists
                    const dynamicNoResults = document.getElementById('dynamicNoResults');
                    if (dynamicNoResults) {
                        dynamicNoResults.remove();
                    }
                }
            }
        }
        
        function sortPatients() {
            const sortBy = document.getElementById('sortBy').value;
            const tbody = document.getElementById('patientTableBody');
            const patients = Array.from(document.querySelectorAll('.patient-row'));
            
            // Sort patients based on selected criteria
            patients.sort((a, b) => {
                switch(sortBy) {
                    case 'nameAsc':
                        return a.getAttribute('data-name').localeCompare(b.getAttribute('data-name'));
                    case 'nameDesc':
                        return b.getAttribute('data-name').localeCompare(a.getAttribute('data-name'));
                    case 'idAsc':
                        return parseInt(a.getAttribute('data-id')) - parseInt(b.getAttribute('data-id'));
                    case 'idDesc':
                        return parseInt(b.getAttribute('data-id')) - parseInt(a.getAttribute('data-id'));
                    case 'recent':
                        return b.getAttribute('data-recent').localeCompare(a.getAttribute('data-recent'));
                    default:
                        return 0;
                }
            });
            
            // Reappend sorted patients to the container
            const noResultsRow = document.getElementById('noResultsRow');
            
            // Clear tbody except for the no results row if it exists
            if (noResultsRow) {
                // If we have a static no results row, preserve it
                tbody.innerHTML = '';
                tbody.appendChild(noResultsRow);
            } else {
                tbody.innerHTML = '';
            }
            
            // Add the sorted rows back
            patients.forEach(patient => {
                tbody.appendChild(patient);
            });
            
            // Check if we need to add a dynamic "no results" row
            const dynamicNoResults = document.getElementById('dynamicNoResults');
            if (dynamicNoResults) {
                tbody.appendChild(dynamicNoResults);
            }
        }
        
        function resetFilters() {
            document.getElementById('searchInput').value = '';
            document.getElementById('bloodTypeFilter').value = '';
            document.getElementById('statusFilter').value = '';
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