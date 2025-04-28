<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Arrays" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor List</title>
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
        
        /* Doctor Stats */
        .doctor-stats {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .stat-card {
            flex: 1;
            min-width: 240px;
            background-color: var(--bg-color);
            border-radius: 8px;
            padding: 20px;
            border: 1px solid var(--border-color);
            box-shadow: 0 2px 6px rgba(77, 171, 247, 0.04);
            display: flex;
            align-items: center;
        }
        
        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            margin-right: 15px;
            flex-shrink: 0;
        }
        
        .stat-info h3 {
            font-size: 14px;
            font-weight: 500;
            color: var(--text-secondary);
            margin-bottom: 5px;
        }
        
        .stat-info p {
            font-size: 22px;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0;
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
        
        /* Doctor Table */
        .table-container {
            background-color: var(--bg-color);
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 6px rgba(77, 171, 247, 0.04);
            border: 1px solid var(--border-color);
        }
        
        .doctor-table {
            width: 100%;
            margin-bottom: 0;
        }
        
        .doctor-table th {
            padding: 12px 16px;
            font-weight: 600;
            color: var(--text-primary);
            background-color: var(--primary-light);
            border-bottom: 1px solid var(--border-color);
            white-space: nowrap;
        }
        
        .doctor-table td {
            padding: 12px 16px;
            vertical-align: middle;
            border-bottom: 1px solid var(--border-color);
        }
        
        .doctor-table tr:last-child td {
            border-bottom: none;
        }
        
        .doctor-table tbody tr {
            transition: all 0.2s;
            cursor: pointer;
        }
        
        .doctor-table tbody tr:hover {
            background-color: var(--primary-light);
        }
        
        /* Doctor Avatar */
        .doctor-avatar {
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
        
        /* Specialization Badge */
        .specialization-badge {
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
            display: inline-block;
            text-align: center;
            background-color: rgba(33, 150, 83, 0.1);
            color: var(--confirmed-color);
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
        
        /* Filter badges */
        .filter-badges {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 15px;
        }
        
        .filter-badge {
            background-color: var(--primary-color);
            color: white;
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 12px;
            display: inline-flex;
            align-items: center;
            cursor: pointer;
        }
        
        .filter-badge span {
            margin-left: 5px;
            font-weight: bold;
            cursor: pointer;
        }
        
        .clear-filters {
            color: var(--primary-color);
            background: none;
            border: none;
            font-size: 14px;
            cursor: pointer;
            padding: 0;
            font-weight: 500;
        }
        
        .clear-filters:hover {
            text-decoration: underline;
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
            
            .doctor-stats {
                flex-direction: column;
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
                <a onclick="navigateTo('Admin/Doctors')" class="nav-link active">
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
            <h1 class="page-title">Doctor Management</h1>
            <!-- Add Doctor Button -->
	        <div class="d-flex justify-content-end">
	            <button class="btn btn-primary" onclick="navigateTo('AdminAddDoctor.jsp')">
	                <i class="fas fa-plus-circle me-2"></i> Add New Doctor
	            </button>
	        </div>
        </div>

        <!-- Filter Card -->
        <div class="card mb-4">
            <div class="card-header">
                <div><i class="fas fa-filter me-2"></i> Filter Doctors</div>
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
                                <input type="text" id="search-filter" class="form-control" placeholder="Search by name or license..." oninput="applyFilters()">
                            </div>
                        </div>
                        
                        <div class="col-md-4 mb-2 mb-md-0">
                            <select id="specialization-filter" class="form-select" onchange="applyFilters()">
                                <option value="">All Specializations</option>
                                <option value="Cardiology">Cardiology</option>
                                <option value="Neurology">Neurology</option>
                                <option value="Orthopedics">Orthopedics</option>
                                <option value="Pediatrics">Pediatrics</option>
                                <option value="Dermatology">Dermatology</option>
                                <option value="Oncology">Oncology</option>
                                <option value="Gynecology">Gynecology</option>
                                <option value="Ophthalmology">Ophthalmology</option>
                            </select>
                        </div>
                        
                        <div class="col-md-3 mb-2 mb-md-0">
                            <select id="sort-by" class="form-select">
                                <option value="nameAsc">Name (A-Z)</option>
                                <option value="nameDesc">Name (Z-A)</option>
                                <option value="expDesc">Experience (High-Low)</option>
                                <option value="expAsc">Experience (Low-High)</option>
                            </select>
                        </div>
                        
                        <div class="col-md-1 text-md-end">
                            <button class="btn btn-outline-secondary" onclick="clearAllFilters()">
                                <i class="fas fa-redo"></i>
                            </button>
                        </div>
                    </div>
                    
                    <!-- Active Filters Display -->
                    <div class="mt-3">
                        <div class="filter-badges" id="active-filters">
                            <!-- Active filters will be displayed here -->
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Doctor Table -->
        <div class="table-container mb-4">
            <table class="table doctor-table" id="doctor-table">
                <thead>
                    <tr>
                        <th>Doctor</th>
                        <th>License</th>
                        <th>Specialization</th>
                        <th class="hide-xs">Experience</th>
                        <th class="hide-xs">Contact</th>
                        <th class="hide-xs">Email</th>
                    </tr>
                </thead>
                <tbody id="doctor-table-body">
                    <%
                        List<Object[]> doctors = (List<Object[]>) request.getAttribute("doctors");
                        if (doctors != null && !doctors.isEmpty()) {
                            for (Object[] row : doctors) {
                                // Get initials from first and last name
                                String initials = row[4].toString().charAt(0) + "" + row[5].toString().charAt(0);
                    %>
                    <tr class="doctor-row"
                        data-name="<%= row[4] %> <%= row[5] %>" 
                        data-license="<%= row[1] %>"
                        data-specialization="<%= row[1] %>">
                        <td>
                            <div class="d-flex align-items-center">
                                <div class="doctor-avatar"><%= initials %></div>
                                <div>Dr. <%= row[5] %> <%= row[6] %></div>
                            </div>
                        </td>
                        <td><%= row[2] %></td>
                        <td><span class="specialization-badge"><%= row[1] %></span></td>
                        <td class="hide-xs"><%= row[3] %> years</td>
                        <td class="hide-xs"><%= row[10] %></td>
                        <td class="hide-xs"><%= row[8] %></td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr id="no-results-row">
                        <td colspan="7" class="text-center py-4">
                            <div class="alert-no-results">
                                <i class="fas fa-user-md-slash me-2"></i> No doctors found
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
		 // Replace the entire JavaScript section at the bottom of your file
		
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
		     if (document.getElementById('current-datetime')) {
		         document.getElementById('current-datetime').textContent = formattedDateTime;
		     }
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
		
		 function viewDoctor(username) {
		     // In a real application, this would navigate to the doctor details page
		     console.log("Viewing doctor: " + username);
		     window.location.href = '${pageContext.request.contextPath}/Admin/DoctorDetails?id=' + username;
		 }
		
		 function editDoctor(username) {
		     // In a real application, this would navigate to the doctor edit page
		     console.log("Editing doctor: " + username);
		     window.location.href = '${pageContext.request.contextPath}/Admin/EditDoctor?id=' + username;
		 }
		
		 // Filter functionality
		 let activeFilters = {
		     search: '',
		     specialization: ''
		 };
		
		 // Debounce function to limit how often a function can run
		 function debounce(func, wait) {
		     let timeout;
		     return function(...args) {
		         clearTimeout(timeout);
		         timeout = setTimeout(() => func.apply(this, args), wait);
		     };
		 }
		
		 // Real-time filtering implementation
		 function applyFilters() {
		     console.log("Applying filters...");
		     
		     // Get filter values
		     const searchValue = document.getElementById('search-filter').value.toLowerCase();
		     const specializationValue = document.getElementById('specialization-filter').value;
		     
		     // Display active filters
		     updateActiveFiltersDisplay();
		     
		     // Get all doctor rows
		     const doctorRows = document.querySelectorAll('.doctor-row');
		     let visibleCount = 0;
		     
		     // Filter the rows
		     Array.from(doctorRows).forEach(row => {
		         const name = row.getAttribute('data-name').toLowerCase();
		         const license = row.getAttribute('data-license').toLowerCase();
		         const specialization = row.getAttribute('data-specialization');
		         
		         // Apply search filter
		         const matchesSearch = searchValue === '' || 
		                              name.includes(searchValue) || 
		                              license.includes(searchValue);
		         
		         // Apply specialization filter
		         const matchesSpecialization = specializationValue === '' || 
		                                      specialization === specializationValue;
		         
		         // Show or hide based on all filters
		         const isVisible = matchesSearch && matchesSpecialization;
		         
		         if (isVisible) {
		             row.style.display = '';
		             visibleCount++;
		         } else {
		             row.style.display = 'none';
		         }
		     });
		     
		     // Show or hide no results message
		     const tbody = document.getElementById('doctor-table-body');
		     
		     // Remove dynamic no results row if it exists
		     const dynamicNoResults = document.getElementById('dynamic-no-results');
		     if (dynamicNoResults) {
		         dynamicNoResults.remove();
		     }
		     
		     // Add no results row if needed
		     if (visibleCount === 0 && doctorRows.length > 0) {
		         const newNoResultsRow = document.createElement('tr');
		         newNoResultsRow.id = 'dynamic-no-results';
		         newNoResultsRow.innerHTML = `
		             <td colspan="6" class="text-center py-4">
		                 <div class="alert-no-results">
		                     <i class="fas fa-filter me-2"></i> No doctors match your filters
		                 </div>
		             </td>
		         `;
		         tbody.appendChild(newNoResultsRow);
		     }
		     
		     // Update counter if it exists
		     //const counterElement = document.getElementById('doctors-counter');
		     //if (counterElement) {
		         //counterElement.textContent = visibleCount;
		     //}
		     
		     //console.log(`Filter applied: ${visibleCount} doctors visible`);
		 }
		
		 function updateActiveFiltersDisplay() {
		     const activeFiltersContainer = document.getElementById('active-filters');
		     activeFiltersContainer.innerHTML = '';
		     
		     // Add search filter badge
		     if (activeFilters.search) {
		         const badge = document.createElement('div');
		         badge.className = 'filter-badge';
		         badge.innerHTML = `Search: ${activeFilters.search} <span onclick="clearFilter('search')">×</span>`;
		         activeFiltersContainer.appendChild(badge);
		     }
		     
		     // Add specialization filter badge
		     if (activeFilters.specialization) {
		         const badge = document.createElement('div');
		         badge.className = 'filter-badge';
		         badge.innerHTML = `Specialization: ${activeFilters.specialization} <span onclick="clearFilter('specialization')">×</span>`;
		         activeFiltersContainer.appendChild(badge);
		     }
		 }
		
		 function clearFilter(filterType) {
		     if (filterType === 'search') {
		         document.getElementById('search-filter').value = '';
		         activeFilters.search = '';
		     } else if (filterType === 'specialization') {
		         document.getElementById('specialization-filter').value = '';
		         activeFilters.specialization = '';
		     }
		     
		     applyFilters();
		 }
		
		 function clearAllFilters() {
		     document.getElementById('search-filter').value = '';
		     document.getElementById('specialization-filter').value = '';
		     document.getElementById('sort-by').value = 'nameAsc';
		     
		     activeFilters = {
		         search: '',
		         specialization: ''
		     };
		     
		     applyFilters();
		     sortDoctors();
		 }
		
		 function sortDoctors() {
		     const sortBy = document.getElementById('sort-by').value;
		     const tbody = document.getElementById('doctor-table-body');
		     const rows = Array.from(document.querySelectorAll('.doctor-row'));
		     
		     // Remove any existing "no results" row before sorting
		     const noResultsRow = document.getElementById('dynamic-no-results');
		     if (noResultsRow) {
		         noResultsRow.remove();
		     }
		     
		     // Sort doctors based on selected criteria
		     rows.sort((a, b) => {
		         const nameA = a.getAttribute('data-name');
		         const nameB = b.getAttribute('data-name');
		         const expA = parseInt(a.querySelector('td:nth-child(4)').textContent);
		         const expB = parseInt(b.querySelector('td:nth-child(4)').textContent);
		         
		         switch(sortBy) {
		             case 'nameAsc':
		                 return nameA.localeCompare(nameB);
		             case 'nameDesc':
		                 return nameB.localeCompare(nameA);
		             case 'expDesc':
		                 return expB - expA;
		             case 'expAsc':
		                 return expA - expB;
		             default:
		                 return 0;
		         }
		     });
		     
		     // Reappend sorted rows
		     rows.forEach(row => {
		         if (row.style.display !== 'none') {
		             tbody.appendChild(row);
		         }
		     });
		 }
		
		 // Initialize event listeners when the DOM is fully loaded
		 document.addEventListener('DOMContentLoaded', function() {
		     console.log("Document loaded, initializing event listeners");
		     
		     
		     // Set up search input for real-time filtering with debounce
		     const searchInput = document.getElementById('search-filter');
		     if (searchInput) {
		         const debouncedFilter = debounce(applyFilters, 300);
		         searchInput.addEventListener('input', debouncedFilter);
		         
		         // Add Escape key functionality to clear search
		         searchInput.addEventListener('keyup', function(e) {
		             if (e.key === 'Escape') {
		                 this.value = '';
		                 applyFilters();
		             }
		         });
		     }
		     
		     // Set up specialization filter
		     const specializationFilter = document.getElementById('specialization-filter');
		     if (specializationFilter) {
		         specializationFilter.addEventListener('change', applyFilters);
		     }
		     
		     // Set up sort by dropdown
		     const sortBySelect = document.getElementById('sort-by');
		     if (sortBySelect) {
		         sortBySelect.addEventListener('change', sortDoctors);
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