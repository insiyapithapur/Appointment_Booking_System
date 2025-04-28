<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Profile</title>
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
        
        /* Profile specific styles */
        .profile-container {
            background: white;
            border-radius: 8px;
            border: 1px solid var(--border-color);
            overflow: hidden;
            margin-bottom: 30px;
            box-shadow: 0 2px 6px rgba(77, 171, 247, 0.04);
        }
        
        .profile-content-section {
            padding: 25px 30px;
            border-bottom: 1px solid var(--border-color);
        }
        
        .profile-content-section:last-child {
            border-bottom: none;
        }
        
        .section-title {
            font-size: 16px;
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
        }
        
        .section-title i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
            color: var(--primary-color);
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 15px 30px;
        }
        
        .info-item {
            margin-bottom: 5px;
        }
        
        .info-label {
            font-size: 13px;
            color: var(--text-secondary);
            margin-bottom: 5px;
        }
        
        .info-value {
            font-size: 15px;
            font-weight: 500;
            color: var(--text-primary);
        }
        
        .blood-group-badge {
            display: inline-block;
            background-color: var(--primary-light);
            color: var(--primary-color);
            padding: 5px 10px;
            border-radius: 4px;
            font-weight: 500;
            font-size: 14px;
        }
        
        .edit-button {
            background-color: var(--primary-light);
            color: var(--primary-color);
            border: none;
            border-radius: 6px;
            padding: 8px 16px;
            font-size: 14px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s;
            cursor: pointer;
            margin-left: auto;
        }
        
        .edit-button:hover {
            background-color: var(--primary-dark);
            color: white;
        }
        
        .profile-header-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
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
        
        .alert-success {
            background-color: #e6f7ee;
            color: #0c6b39;
            border: 1px solid #b7e4ca;
        }
        
        .alert-danger {
            background-color: #fbeaea;
            color: #b71c1c;
            border: 1px solid #f5c2c2;
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
            .info-grid {
                grid-template-columns: 1fr;
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
            
            .profile-header-row {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            
            .edit-button {
                margin-left: 0;
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
                <a onclick="navigateTo('Patient/Doctors')" class="nav-link">
                    <i class="fas fa-user-md"></i> Doctors
                </a>
            </li>
            <li class="nav-item">
                <a onclick="navigateTo('Patient/Profile')" class="nav-link active">
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
            <h1 class="page-title">My Profile</h1>
        </div>
        
        <!-- Display any error or success messages -->
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger" role="alert">
                <i class="fas fa-exclamation-circle"></i>
                <div>${sessionScope.errorMessage}</div>
                <c:remove var="errorMessage" scope="session" />
            </div>
        </c:if>
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success" role="alert">
                <i class="fas fa-check-circle"></i>
                <div>${sessionScope.successMessage}</div>
                <c:remove var="successMessage" scope="session" />
            </div>
        </c:if>
        
        <div class="profile-container">
            <div class="profile-content-section">
                <div class="profile-header-row">
                    <div class="section-title">
                        <i class="fas fa-user"></i> Personal Information
                    </div>
                    <button class="edit-button" onclick="navigateTo('Patient/EditProfile')">
                        <i class="fas fa-pencil-alt"></i> Edit Profile
                    </button>
                </div>
                
                <div class="info-grid">
                    <c:forEach items="${profileDetails}" var="detail">
                        <c:if test="${detail.startsWith('Username:')}">
                            <div class="info-item">
                                <div class="info-label">Username</div>
                                <div class="info-value">${detail.substring(10)}</div>
                            </div>
                        </c:if>
                        
                        <c:if test="${detail.startsWith('Email:')}">
                            <div class="info-item">
                                <div class="info-label">Email Address</div>
                                <div class="info-value">${detail.substring(7)}</div>
                            </div>
                        </c:if>
                        
                        <c:if test="${detail.startsWith('DOB:')}">
                            <div class="info-item">
                                <div class="info-label">Date of Birth</div>
                                <div class="info-value">${detail.substring(5)}</div>
                            </div>
                        </c:if>
                        
                        <c:if test="${detail.startsWith('Phone:')}">
                            <div class="info-item">
                                <div class="info-label">Phone Number</div>
                                <div class="info-value">${detail.substring(7)}</div>
                            </div>
                        </c:if>
                        
                        <c:if test="${detail.startsWith('Gender:')}">
                            <div class="info-item">
                                <div class="info-label">Gender</div>
                                <div class="info-value">${detail.substring(8)}</div>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
            </div>
            
            <div class="profile-content-section">
                <div class="section-title">
                    <i class="fas fa-heartbeat"></i> Medical Information
                </div>
                
                <div class="info-grid">
                    <c:forEach items="${profileDetails}" var="detail">
                        <c:if test="${detail.startsWith('Blood Group:')}">
                            <div class="info-item">
                                <div class="info-label">Blood Group</div>
                                <div class="info-value">
                                    <span class="blood-group-badge">${detail.substring(13)}</span>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
            </div>
            
            <div class="profile-content-section">
                <div class="section-title">
                    <i class="fas fa-shield-alt"></i> Account Security
                </div>
                
                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-label">Password</div>
                        <div class="info-value">••••••••</div>
                    </div>
                    <div class="info-item mt-3">
                        <button class="btn btn-outline-primary" onclick="navigateTo('Patient/ChangePassword')">
                            <i class="fas fa-key me-2"></i> Change Password
                        </button>
                    </div>
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