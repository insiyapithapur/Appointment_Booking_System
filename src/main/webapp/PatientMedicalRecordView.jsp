<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Medical Record Details</title>
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
        
        .medical-record-container {
            background: white;
            border-radius: 10px;
            padding: 0;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            overflow: hidden;
            margin-bottom: 30px;
        }
        
        .medical-record-header {
            background-color: var(--primary-color);
            color: white;
            padding: 15px 20px;
            font-size: 18px;
            font-weight: bold;
        }
        
        .medical-record-content {
            padding: 20px;
        }
        
        .medical-record-section {
            margin-bottom: 20px;
            border-bottom: 1px solid #eee;
            padding-bottom: 15px;
        }
        
        .medical-record-section:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }
        
        .section-title {
            font-size: 16px;
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 10px;
        }
        
        .section-content {
            margin-left: 15px;
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
        
        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }
        
        .btn-primary:hover {
            background-color: #3d4a75;
            border-color: #3d4a75;
        }
        
        .actions {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }
        
        .metadata {
            font-size: 14px;
            color: #666;
            margin-bottom: 5px;
        }
        
        .medical-info {
            background-color: #f9f9f9;
            border-left: 4px solid var(--primary-color);
            padding: 15px;
            margin-bottom: 10px;
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
            .actions {
                flex-direction: column;
            }
        }
        
        /* Print styles */
        @media print {
            .sidebar, .toggle-sidebar, .sidebar-overlay, .actions {
                display: none !important;
            }
            .content {
                margin-left: 0;
                padding: 0;
            }
            .medical-record-container {
                box-shadow: none;
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
        <div class="nav-item active" onclick="navigateTo('Patient/Appointments')">Appointments</div>
        <div class="nav-item" onclick="navigateTo('Patient/Doctors')">Doctors</div>
        <div class="nav-item" onclick="navigateTo('Patient/Profile')">Profile</div>
    </div>
    
    <div class="content">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h2>Medical Record</h2>
            <a href="${pageContext.request.contextPath}/Patient/Appointments" class="btn btn-outline-primary">
                <i class="fas fa-arrow-left"></i> Back to Appointments
            </a>
        </div>
        <p class="text-muted" id="current-datetime"></p>
        
        <!-- Display any error messages -->
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger" role="alert">
                ${sessionScope.errorMessage}
                <c:remove var="errorMessage" scope="session" />
            </div>
        </c:if>
        
        <!-- Medical Record Display -->
        <div class="medical-record-container">
            <div class="medical-record-header">
                Medical Record Details
            </div>
            <div class="medical-record-content">
                <!-- Appointment Details -->
                <div class="medical-record-section">
                    <div class="section-title">Appointment Information</div>
                    <div class="section-content">
                        <div class="row">
                            <div class="col-md-6">
                                <p class="metadata">Appointment ID: ${appointmentId}</p>
                                <p class="metadata">Date: 
                                    <c:if test="${not empty medicalRecord.appointment.appointmentDate}">
                                        <fmt:parseDate value="${medicalRecord.appointment.appointmentDate}" pattern="yyyy-MM-dd" var="parsedDate" type="date" />
                                        <fmt:formatDate value="${parsedDate}" pattern="MMMM dd, yyyy" />
                                    </c:if>
                                </p>
                                <p class="metadata">Token Number: ${medicalRecord.appointment.tokenNo}</p>
                                <p class="metadata">Reason: ${medicalRecord.appointment.reason}</p>
                            </div>
                            <div class="col-md-6">
                                <p class="metadata">Doctor: Dr. ${medicalRecord.appointment.schedule.doctor.user.username}</p>
                                <p class="metadata">Specialization: ${medicalRecord.appointment.schedule.doctor.specialization}</p>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Diagnosis -->
                <div class="medical-record-section">
                    <div class="section-title">Diagnosis</div>
                    <div class="section-content">
                        <div class="medical-info">
                            ${not empty medicalRecord.diagnosis ? medicalRecord.diagnosis : 'No diagnosis provided.'}
                        </div>
                    </div>
                </div>
                
                <!-- Treatment -->
                <div class="medical-record-section">
                    <div class="section-title">Treatment</div>
                    <div class="section-content">
                        <div class="medical-info">
                            ${not empty medicalRecord.treatment ? medicalRecord.treatment : 'No treatment information provided.'}
                        </div>
                    </div>
                </div>
                
                <!-- Notes -->
                <div class="medical-record-section">
                    <div class="section-title">Additional Notes</div>
                    <div class="section-content">
                        <div class="medical-info">
                            ${not empty medicalRecord.notes ? medicalRecord.notes : 'No additional notes provided.'}
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="actions">
            <button class="btn btn-primary" onclick="window.print()">
                <i class="fas fa-print"></i> Print Medical Record
            </button>
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