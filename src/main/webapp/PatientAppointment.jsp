<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Appointments</title>
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
            flex-wrap: wrap;
            gap: 15px;
        }
        
        /* Filter section */
        .filter-bar {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .search-container {
            position: relative;
            flex-grow: 1;
            max-width: 300px;
        }
        
        .search-input {
            width: 100%;
            padding: 8px 12px 8px 35px;
            border-radius: 6px;
            border: 1px solid var(--border-color);
            font-size: 13px;
            color: var(--text-primary);
            background-color: white;
        }
        
        .search-icon {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-secondary);
        }
        
        .date-container {
            position: relative;
            display: flex;
            align-items: center;
        }
        
        .date-input {
            padding: 8px 12px 8px 35px;
            border-radius: 6px;
            border: 1px solid var(--border-color);
            font-size: 13px;
            color: var(--text-primary);
            background-color: white;
            width: 180px;
        }
        
        .date-icon {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-secondary);
            pointer-events: none;
        }
        
        .filter-dropdown {
            padding: 8px 12px;
            border-radius: 6px;
            border: 1px solid var(--border-color);
            font-size: 13px;
            color: var(--text-primary);
            background-color: white;
            cursor: pointer;
        }
        
        .filter-button {
            padding: 8px 12px;
            border-radius: 6px;
            border: 1px solid var(--border-color);
            font-size: 13px;
            color: var(--text-primary);
            background-color: var(--bg-secondary);
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: all 0.2s;
        }
        
        .filter-button:hover {
            background-color: var(--primary-light);
            color: var(--primary-color);
        }
        
        /* Table styles */
        .appointments-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }
        
        .appointments-table th {
            padding: 12px 15px;
            text-align: left;
            font-weight: 500;
            color: var(--text-secondary);
            border-bottom: 1px solid var(--border-color);
            background-color: var(--bg-secondary);
            cursor: pointer;
            transition: all 0.2s;
            user-select: none;
        }
        
        .appointments-table th:hover {
            background-color: var(--primary-light);
            color: var(--primary-color);
        }
        
        .appointments-table th i {
            margin-left: 5px;
        }
        
        .appointments-table td {
            padding: 12px 15px;
            border-bottom: 1px solid var(--border-color);
            vertical-align: middle;
        }
        
        .appointments-table tbody tr:last-child td {
            border-bottom: none;
        }
        
        /* Doctor Info */
        .doctor-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .doctor-avatar {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background-color: var(--primary-light);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 500;
            font-size: 12px;
            color: var(--primary-color);
        }
        
        /* Status Badges */
        .badge-pending {
            background-color: rgba(242, 153, 74, 0.1);
            color: var(--pending-color);
            padding: 5px 10px;
            border-radius: 4px;
            font-weight: 500;
            font-size: 12px;
            display: inline-block;
        }
        
        .badge-confirmed {
            background-color: rgba(33, 150, 83, 0.1);
            color: var(--confirmed-color);
            padding: 5px 10px;
            border-radius: 4px;
            font-weight: 500;
            font-size: 12px;
            display: inline-block;
        }
        
        .badge-cancelled {
            background-color: rgba(235, 87, 87, 0.1);
            color: var(--cancelled-color);
            padding: 5px 10px;
            border-radius: 4px;
            font-weight: 500;
            font-size: 12px;
            display: inline-block;
        }
        
        .badge-completed {
            background-color: rgba(47, 128, 237, 0.1);
            color: var(--completed-color);
            padding: 5px 10px;
            border-radius: 4px;
            font-weight: 500;
            font-size: 12px;
            display: inline-block;
        }
        
        /* Button styles */
        .btn {
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.2s;
        }
        
        .btn-sm {
            padding: 5px 10px;
            font-size: 12px;
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
        
        .btn-danger {
            background-color: #f44336;
            border-color: #f44336;
        }
        
        /* Action buttons row */
        /* Action Button */
        .btn-action {
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            text-decoration: none;
            transition: all 0.2s;
            cursor: pointer;
            border: none;
        }
        
        .btn-view {
            background-color: rgba(47, 128, 237, 0.1);
            color: var(--completed-color);
            border: 1px solid rgba(47, 128, 237, 0.2);
        }
        
        .btn-view:hover {
            background-color: rgba(47, 128, 237, 0.2);
        }
        
        .btn-cancel {
            background-color: rgba(235, 87, 87, 0.1);
            color: var(--cancelled-color);
            border: 1px solid rgba(235, 87, 87, 0.2);
        }
        
        .btn-cancel:hover {
            background-color: rgba(235, 87, 87, 0.2);
        }
        
        /* Reason Tooltip */
        .reason-tooltip {
            position: relative;
            display: inline-block;
            cursor: pointer;
        }
        
        .reason-tooltip .reason-text {
            visibility: hidden;
            width: 200px;
            background-color: var(--text-primary);
            color: #fff;
            text-align: left;
            border-radius: 4px;
            padding: 8px 10px;
            position: absolute;
            z-index: 1;
            bottom: 125%;
            left: 0;
            opacity: 0;
            transition: opacity 0.3s;
            white-space: normal;
            font-size: 12px;
            box-shadow: 0 2px 8px rgba(43, 61, 79, 0.15);
        }
        
        .reason-tooltip:hover .reason-text {
            visibility: visible;
            opacity: 1;
        }
        
        /* Alert styles */
        .alert-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 2000;
            max-width: 350px;
        }
        
        .alert {
            border: none;
            border-radius: 6px;
            padding: 12px 15px;
            margin-bottom: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            display: flex;
            align-items: center;
            gap: 10px;
            transition: opacity 0.15s linear, transform 0.15s ease-out;
        }
        
        .alert.fade {
            opacity: 0;
            transform: translateY(-10px);
        }
        
        .alert.show {
            opacity: 1;
            transform: translateY(0);
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
        
        /* Modal styling */
        .modal-content {
            border: none;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .modal-header {
            background-color: var(--bg-color);
            border-bottom: 1px solid var(--border-color);
            padding: 15px 20px;
        }
        
        .modal-title {
            color: var(--primary-color);
            font-weight: 600;
            font-size: 18px;
        }
        
        .modal-body {
            padding: 20px;
        }
        
        .modal-footer {
            border-top: 1px solid var(--border-color);
            padding: 15px 20px;
        }
        
        /* Responsive Styles */
        @media (max-width: 1200px) {
            .appointments-table {
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
                padding: 20px;
            }
            
            .statistics-row {
                flex-direction: column;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .filter-container .row {
                flex-direction: column;
            }
            
            .filter-container .col-md-3 {
                margin-bottom: 10px;
                width: 100%;
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
                <a onclick="navigateTo('Patient/Appointments')" class="nav-link active">
                    <i class="fas fa-calendar-check"></i> Appointments
                </a>
            </li>
            <li class="nav-item">
                <a onclick="navigateTo('Patient/Doctors')" class="nav-link">
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
            <h1 class="page-title">Appointment History</h1>
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
        
        <!-- Appointments Table and Filter -->
        <div class="card">
           <div class="card-header">
                <div><i class="fas fa-calendar-alt me-2"></i>Appointments</div>
                
                <!-- Appointment Filters -->
                <div class="filter-bar">
                    <div class="search-container">
                        <i class="fas fa-search search-icon"></i>
                        <input type="text" id="textFilter" class="search-input" placeholder="Doctor name or reason..." onkeyup="applyFilters()">
                    </div>
                    
                    <!-- Date input field instead of dropdown -->
                    <div class="date-container">
                        <i class="fas fa-calendar-day date-icon"></i>
                        <input type="date" id="dateFilter" class="date-input" onchange="applyFilters()">
                    </div>
                            
                    <select id="statusFilter" class="filter-dropdown" onchange="applyFilters()">
                        <option value="all">All</option>
                        <option value="Pending">Pending</option>
                        <option value="Completed">Completed</option>
                        <option value="Cancelled">Cancelled</option>
                    </select>
                            
                    <button class="filter-button" onclick="resetFilters()">
                        <i class="fas fa-sync-alt"></i> 
                    </button>
                </div>
            </div>
            
            <!-- Appointments Table -->
            <div class="table-responsive">
            	<table class="appointments-table" id="appointmentsTable">
            		<thead>
                            <tr>
                                <th onclick="sortTable(0)">Doctor</th>
                                <th onclick="sortTable(1)">Date</th>
                                <th onclick="sortTable(2)">Token</th>
                                <th onclick="sortTable(3)">Reason</th>
                                <th onclick="sortTable(4)">Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${appointments}" var="appointmentInfo" varStatus="status">
                            <c:set var="appointmentParts" value="${fn:split(appointmentInfo, '|')}" />
                            <c:set var="appointmentId" value="${fn:trim(fn:substringAfter(appointmentParts[0], 'ID:'))}" />
                            <c:set var="doctorName" value="${fn:trim(fn:substringAfter(appointmentParts[1], 'Doctor:'))}" />
                            <c:set var="appointmentDate" value="${fn:trim(fn:substringAfter(appointmentParts[2], 'Date:'))}" />
                            <c:set var="tokenNo" value="${fn:trim(fn:substringAfter(appointmentParts[3], 'Token:'))}" />
                            <c:set var="reason" value="${fn:trim(fn:substringAfter(appointmentParts[4], 'Reason:'))}" />
                            <c:set var="status" value="${fn:trim(fn:substringAfter(appointmentParts[5], 'Status:'))}" />
                            
                            <!-- Set a predefined color based on appointmentId -->
                            <c:set var="avatarColor" value="hsl(${(appointmentId * 40) % 360}, 70%, 60%)" />
                            
                            <tr class="appointment-row" 
                                data-doctor="${doctorName}" 
                                data-date="${appointmentDate}" 
                                data-status="${status}" 
                                data-reason="${reason}">
                                <td>
                                    <div class="doctor-info">
                                        <div class="doctor-avatar">
                                            ${fn:substring(doctorName, 0, 1)}
                                        </div>
                                        ${doctorName}
                                    </div>
                                </td>
                                <td>${appointmentDate}</td>
                                <td>${tokenNo}</td>
                                <td>
                                    <div class="reason-tooltip">
                                        ${fn:length(reason) > 25 ? fn:substring(reason, 0, 25).concat('...') : reason}
                                        <span class="reason-text">${reason}</span>
                                    </div>
                                </td>
                                <td>
                                    <span class="badge-${fn:toLowerCase(status)}">
                                        ${status}
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${fn:containsIgnoreCase(status, 'Completed')}">
                                            <!-- View medical record button for completed appointments -->
                                            <a href="${pageContext.request.contextPath}/Patient/Appointments?action=viewMedicalRecord&appointmentId=${appointmentId}" 
                                               class="btn btn-sm btn-primary">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                        </c:when>
                                        <c:when test="${fn:containsIgnoreCase(status, 'Pending') || fn:containsIgnoreCase(status, 'Confirmed')}">
                                                <button class="btn-action btn-cancel" onclick="cancelAppointment(${appointmentId})">
                                                    <i class="fas fa-times"></i>
                                                </button>                                    
                                         </c:when>
                                        <c:otherwise>
                                            <!-- Disabled button for other statuses -->
                                            <span class="text-muted">NA</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty appointments}">
                            <tr id="no-appointments-row">
                                <td colspan="6" class="text-center py-4">
                                    <div class="alert alert-info mb-0">
                                        <i class="fas fa-info-circle me-2"></i>
                                        You don't have any appointments yet.
                                    </div>
                                </td>
                            </tr>
                        </c:if>
                        
                        <!-- No results row (hidden by default) -->
                        <tr id="no-results-row" style="display: none;">
                            <td colspan="6" class="text-center py-4">
                                <div class="alert alert-warning mb-0">
                                    <i class="fas fa-filter me-2"></i>
                                    No appointments match your filters.
                                    <button class="btn btn-sm btn-link" onclick="resetFilters()">Reset filters</button>
                                </div>
                            </td>
                        </tr>
                    </tbody>
            	</table>
            </div>
            
        </div>
        
        <!-- Action buttons -->
        <div class="action-buttons">
            <a href="${pageContext.request.contextPath}/Patient/BookAppointment" class="btn btn-primary">
                <i class="fas fa-calendar-plus"></i> Book New Appointment
            </a>
        </div>
    </div>
    
    <!-- Cancel Appointment Modal -->
    <div class="modal fade" id="cancelModal" tabindex="-1" aria-labelledby="cancelModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="cancelModalLabel">
                        <i class="fas fa-calendar-times me-2"></i> Cancel Appointment
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to cancel this appointment?</p>
                    <p class="text-danger">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        This action cannot be undone.
                    </p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        Close
                    </button>
                    <form id="cancelForm" action="${pageContext.request.contextPath}/Patient/Appointments" method="post">
                        <input type="hidden" id="appointmentIdToCancel" name="appointmentId" value="">
                        <input type="hidden" name="action" value="cancelAppointment">
                        <input type="hidden" name="newStatusId" value="3">
                        <button type="submit" class="btn btn-danger">
                            Confirm Cancellation
                        </button>
                    </form>
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
                minute: '2-digit'
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

        function cancelAppointment(appointmentId) {
            // Set the appointment ID in the modal form
            document.getElementById('appointmentIdToCancel').value = appointmentId;
            
            // Show the modal
            const modalElement = document.getElementById('cancelModal');
            if (modalElement) {
                const modal = new bootstrap.Modal(modalElement);
                modal.show();
            } else {
                console.error("Modal element not found");
                // Fallback to direct cancellation
                if (confirm("Are you sure you want to cancel this appointment? This action cannot be undone.")) {
                    window.location.href = "${pageContext.request.contextPath}/CancelAppointment?id=" + appointmentId;
                }
            }
        }
        
        // Sort table function
        let currentSortColumn = -1;
        let sortDirection = 1; // 1 for ascending, -1 for descending
        
        function sortTable(columnIndex) {
            const table = document.getElementById('appointmentsTable');
            if (!table) return;
            
            const tbody = table.querySelector('tbody');
            const rows = Array.from(tbody.querySelectorAll('tr.appointment-row'));
            
            // Toggle sort direction if clicking the same column
            if (currentSortColumn === columnIndex) {
                sortDirection *= -1;
            } else {
                sortDirection = 1;
                currentSortColumn = columnIndex;
            }
            
            // Update sort icons
            const headers = table.querySelectorAll('th');
            headers.forEach(header => {
                header.querySelector('i').className = 'fas fa-sort';
            });
            
            const currentHeader = headers[columnIndex];
            currentHeader.querySelector('i').className = sortDirection === 1 ? 'fas fa-sort-up' : 'fas fa-sort-down';
            
            // Sort the rows
            rows.sort((a, b) => {
                let valueA, valueB;
                
                // Special handling for date column
                if (columnIndex === 1) {
                    valueA = a.cells[columnIndex].textContent.trim();
                    valueB = b.cells[columnIndex].textContent.trim();
                } 
                // Special handling for token column (numeric sort)
                else if (columnIndex === 2) {
                    valueA = parseInt(a.cells[columnIndex].textContent.trim()) || 0;
                    valueB = parseInt(b.cells[columnIndex].textContent.trim()) || 0;
                    return sortDirection * (valueA - valueB);
                }
                // Default text comparison for other columns
                else {
                    valueA = a.cells[columnIndex].textContent.trim().toLowerCase();
                    valueB = b.cells[columnIndex].textContent.trim().toLowerCase();
                }
                
                if (valueA < valueB) return -sortDirection;
                if (valueA > valueB) return sortDirection;
                return 0;
            });
            
            // Reappend rows in new order
            const specialRows = Array.from(tbody.querySelectorAll('tr:not(.appointment-row)'));
            tbody.innerHTML = '';
            
            rows.forEach(row => {
                tbody.appendChild(row);
            });
            
            specialRows.forEach(row => {
                tbody.appendChild(row);
            });
        }
        
        // Filter appointments function
        function applyFilters() {
            const searchText = document.getElementById('textFilter').value.toLowerCase();
            const dateFilter = document.getElementById('dateFilter').value; // Will be in YYYY-MM-DD format
            const statusFilter = document.getElementById('statusFilter').value;
            
            console.log("Filters applied - Text:", searchText, "Date:", dateFilter, "Status:", statusFilter);
            
            const rows = document.querySelectorAll('.appointment-row');
            let visibleCount = 0;
            
            rows.forEach(row => {
                const doctorName = row.getAttribute('data-doctor').toLowerCase();
                const reason = row.getAttribute('data-reason').toLowerCase();
                const status = row.getAttribute('data-status');
                const date = row.getAttribute('data-date');
                
                // Check text filter (doctor name or reason)
                const textMatch = !searchText || 
                                 doctorName.includes(searchText) || 
                                 reason.includes(searchText);
                
                // Check date filter
                let dateMatch = true;
                if (dateFilter) {
                    try {
                        const rowDate = new Date(date);
                        const filterDate = new Date(dateFilter);
                        
                        dateMatch = (
                            rowDate.getFullYear() === filterDate.getFullYear() &&
                            rowDate.getMonth() === filterDate.getMonth() &&
                            rowDate.getDate() === filterDate.getDate()
                        );
                    } catch (e) {
                        console.error("Error comparing dates:", e);
                    }
                }
                
                // Check status filter
                const statusMatch = statusFilter === "all" || status.toLowerCase() === statusFilter.toLowerCase();
                
                // Show/hide based on all filters
                if (textMatch && dateMatch && statusMatch) {
                    row.style.display = "";
                    visibleCount++;
                } else {
                    row.style.display = "none";
                }
            });
            
            // Show/hide no results message
            const noResultsRow = document.getElementById('no-results-row');
            if (noResultsRow) {
                if (visibleCount === 0 && rows.length > 0) {
                    noResultsRow.style.display = "";
                } else {
                    noResultsRow.style.display = "none";
                }
            }
        }
        
        // Reset filters function
        function resetFilters() {
            document.getElementById('textFilter').value = "";
            document.getElementById('dateFilter').value = "";
            document.getElementById('statusFilter').value = "all";
            
            // Apply reset filters
            applyFilters();
            
            // Reset sort indicators
            const headers = document.querySelectorAll('th i');
            headers.forEach(icon => {
                icon.className = 'fas fa-sort';
            });
            
            currentSortColumn = -1;
            sortDirection = 1;
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
            // Auto-hide alerts after 5 seconds
            setTimeout(function() {
                const alerts = document.querySelectorAll('.alert-container .alert');
                alerts.forEach(alert => {
                    alert.classList.remove('show');
                    setTimeout(() => {
                        alert.remove();
                    }, 300);
                });
            }, 5000);
        });
    </script>
</body>
</html>