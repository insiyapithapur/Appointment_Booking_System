<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Profile</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css">
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
        
        /* Profile specific styles */
        .profile-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.05);
            overflow: hidden;
            margin-bottom: 30px;
        }
        
        .profile-header {
            background-color: var(--primary-color);
            color: white;
            padding: 30px;
            position: relative;
        }
        
        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background-color: #81c784;
            color: white;
            font-size: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            border: 5px solid rgba(255, 255, 255, 0.2);
        }
        
        .profile-name {
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 5px;
            text-align: center;
        }
        
        .profile-role {
            font-size: 16px;
            opacity: 0.8;
            text-align: center;
        }
        
        .profile-section {
            padding: 30px;
            border-bottom: 1px solid #eee;
        }
        
        .profile-section:last-child {
            border-bottom: none;
        }
        
        .section-title {
            font-size: 18px;
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
        }
        
        .section-title i {
            margin-right: 10px;
        }
        
        .profile-info-row {
            display: flex;
            margin-bottom: 15px;
        }
        
        .profile-info-label {
            width: 150px;
            font-weight: 500;
            color: #666;
        }
        
        .profile-info-value {
            flex: 1;
            color: var(--text-color);
        }
        
        .edit-button {
            position: absolute;
            top: 20px;
            right: 20px;
            background-color: rgba(255, 255, 255, 0.2);
            color: white;
            border: none;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .edit-button:hover {
            background-color: rgba(255, 255, 255, 0.3);
            transform: scale(1.05);
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
            .profile-info-row {
                flex-direction: column;
            }
            .profile-info-label {
                width: 100%;
                margin-bottom: 5px;
            }
            .profile-info-value {
                width: 100%;
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
        
        <div class="nav-item" onclick="navigateTo('Doctor/Dashboard')">Dashboard</div>
        <div class="nav-item" onclick="navigateTo('Doctor/Patient')">Patients</div>
        <div class="nav-item" onclick="navigateTo('Doctor/Appointment')">Appointments</div>
        <div class="nav-item active" onclick="navigateTo('Doctor/Profile')">Profile</div>
        <div class="nav-item" onclick="window.location.href='${pageContext.request.contextPath}/LogoutServlet'">
    Logout
</div>
    </div>
    
    <div class="content">
        <h2>Profile</h2>
        <p class="text-muted" id="current-datetime"></p>
        
        <div class="profile-container">
           
            
            <div class="profile-section">
                <div class="section-title">
                    <i class="fas fa-user"></i> Basic Information
                </div>
                
                <div class="profile-info-row">
                    <div class="profile-info-label">Full Name</div>
                    <div class="profile-info-value">${userFullName}</div>
                </div>
                
                <div class="profile-info-row">
                    <div class="profile-info-label">User Name</div>
                    <div class="profile-info-value">${userName}</div>
                </div>
                
                <div class="profile-info-row">
                    <div class="profile-info-label">Email</div>
                    <div class="profile-info-value">${userEmail}</div>
                </div>
                
                <div class="profile-info-row">
                    <div class="profile-info-label">Date of Birth</div>
                    <div class="profile-info-value">${userDOB}</div>
                </div>
                
                <div class="profile-info-row">
                    <div class="profile-info-label">Phone</div>
                    <div class="profile-info-value">${userPhone}</div>
                </div>
                
                <div class="profile-info-row">
                    <div class="profile-info-label">Gender</div>
                    <div class="profile-info-value">${userGender}</div>
                </div>
            </div>
            
            <div class="profile-section">
                <div class="section-title">
                    <i class="fas fa-stethoscope"></i> Doctor Information
                </div>
                
                <div class="profile-info-row">
                    <div class="profile-info-label">Specialization</div>
                    <div class="profile-info-value">${doctorSpecialization}</div>
                </div>
                
                <div class="profile-info-row">
                    <div class="profile-info-label">License Number</div>
                    <div class="profile-info-value">${doctorLicenseNumber}</div>
                </div>
                
                <div class="profile-info-row">
                    <div class="profile-info-label">Degree</div>
                    <div class="profile-info-value">${doctorDegree}</div>
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
        
        function editProfile() {
            // Here you would typically navigate to an edit profile page or show a modal
            alert("Edit profile functionality would be implemented here.");
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