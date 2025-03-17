<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Medical Record</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css">
    <style>
        :root {
            --sidebar-bg: #4f95e9;
            --primary-color: #4f95e9;
            --light-bg: #f7f9fc;
            --completed-color: #e8f5e9;
            --pending-color: #e3f2fd;
            --cancelled-color: #ffebee;
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
        
        .section-title {
            color: var(--primary-color);
            font-weight: 600;
            margin-bottom: 10px;
            font-size: 16px;
        }
        
        .section-content {
            background-color: #f9f9f9;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            white-space: pre-line;
        }
        
        .appointment-info {
            display: flex;
            flex-wrap: wrap;
            margin-bottom: 20px;
            padding: 15px;
            background-color: #f0f7ff;
            border-radius: 5px;
        }
        
        .appointment-info-item {
            flex: 1 0 30%;
            margin-bottom: 10px;
        }
        
        .appointment-info-label {
            font-weight: 600;
            color: #666;
            font-size: 14px;
        }
        
        .appointment-info-value {
            font-size: 16px;
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
            background-color: #3d75a4;
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
            .appointment-info-item {
                flex: 1 0 100%;
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
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Medical Record</h2>
            <a href="${pageContext.request.contextPath}/Patient/Appointments" class="btn btn-outline-primary">
                <i class="fas fa-arrow-left"></i> Back to Appointments
            </a>
        </div>
        
        <!-- Display any error messages -->
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger" role="alert">
                ${errorMessage}
            </div>
        </c:if>
        
        <div class="medical-record-container">
            <div class="medical-record-header">
                Medical Record Details
            </div>
            
            <div class="medical-record-content">
                <!-- Appointment information -->
				<!-- Appointment information -->
<div class="appointment-info">
    <div class="appointment-info-item">
        <div class="appointment-info-label">Patient Name</div>
        <div class="appointment-info-value">
            <c:choose>
                <c:when test="${not empty medicalRecord and not empty medicalRecord.appointment and not empty medicalRecord.appointment.patient and not empty medicalRecord.appointment.patient.user}">
                    ${medicalRecord.appointment.patient.user.username}
                </c:when>
                <c:otherwise>
                    <span class="text-muted">Information not available</span>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
    <div class="appointment-info-item">
        <div class="appointment-info-label">Doctor Name</div>
        <div class="appointment-info-value">
            <c:choose>
                <c:when test="${not empty medicalRecord and not empty medicalRecord.appointment and not empty medicalRecord.appointment.schedule and not empty medicalRecord.appointment.schedule.doctor and not empty medicalRecord.appointment.schedule.doctor.user}">
                    Dr. ${medicalRecord.appointment.schedule.doctor.user.username}
                </c:when>
                <c:otherwise>
                    <span class="text-muted">Information not available</span>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
    <div class="appointment-info-item">
        <div class="appointment-info-label">Appointment Date</div>
        <div class="appointment-info-value">
            <c:choose>
                <c:when test="${not empty medicalRecord and not empty medicalRecord.appointment and not empty medicalRecord.appointment.appointmentDate}">
                    ${medicalRecord.appointment.appointmentDate}
                </c:when>
                <c:otherwise>
                    <span class="text-muted">Date not available</span>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
    <div class="appointment-info-item">
        <div class="appointment-info-label">Token Number</div>
        <div class="appointment-info-value">
            <c:choose>
                <c:when test="${not empty medicalRecord and not empty medicalRecord.appointment and not empty medicalRecord.appointment.tokenNo}">
                    ${medicalRecord.appointment.tokenNo}
                </c:when>
                <c:otherwise>
                    <span class="text-muted">Not available</span>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
    <div class="appointment-info-item">
        <div class="appointment-info-label">Status</div>
        <div class="appointment-info-value">
            <c:choose>
                <c:when test="${not empty medicalRecord and not empty medicalRecord.appointment and not empty medicalRecord.appointment.status}">
                    <span class="badge-completed">
                        ${medicalRecord.appointment.status.statusName}
                    </span>
                </c:when>
                <c:otherwise>
                    <span class="text-muted">Status not available</span>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
    <div class="appointment-info-item">
        <div class="appointment-info-label">Reason for Visit</div>
        <div class="appointment-info-value">
            <c:choose>
                <c:when test="${not empty medicalRecord and not empty medicalRecord.appointment and not empty medicalRecord.appointment.reason}">
                    ${medicalRecord.appointment.reason}
                </c:when>
                <c:otherwise>
                    <span class="text-muted">Not specified</span>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- Diagnosis -->
<div class="section-title">
    <i class="fas fa-stethoscope me-2"></i> Diagnosis
</div>
<div class="section-content">
    <c:choose>
        <c:when test="${not empty medicalRecord and not empty medicalRecord.diagnosis}">
            ${medicalRecord.diagnosis}
        </c:when>
        <c:otherwise>
            <span class="text-muted">No diagnosis information available</span>
        </c:otherwise>
    </c:choose>
</div>

<!-- Treatment Plan -->
<div class="section-title">
    <i class="fas fa-prescription-bottle-alt me-2"></i> Treatment Plan
</div>
<div class="section-content">
    <c:choose>
        <c:when test="${not empty medicalRecord and not empty medicalRecord.treatment}">
            ${medicalRecord.treatment}
        </c:when>
        <c:otherwise>
            <span class="text-muted">No treatment plan available</span>
        </c:otherwise>
    </c:choose>
</div>

<!-- Additional Notes -->
<c:if test="${not empty medicalRecord and not empty medicalRecord.notes}">
    <div class="section-title">
        <i class="fas fa-clipboard me-2"></i> Additional Notes
    </div>
    <div class="section-content">
        ${medicalRecord.notes}
    </div>
</c:if>

<!-- Created Date -->
<div class="text-muted mt-4">
    <small>
        <i class="far fa-calendar-alt me-1"></i> Record created on:
        <c:choose>
            <c:when test="${not empty medicalRecord and not empty medicalRecord.createdAt}">
                ${medicalRecord.createdAt.format(java.time.format.DateTimeFormatter.ofPattern('MMMM dd, yyyy'))} at 
                ${medicalRecord.createdAt.format(java.time.format.DateTimeFormatter.ofPattern('hh:mm a'))}
            </c:when>
            <c:otherwise>
                <span>Date not available</span>
            </c:otherwise>
        </c:choose>
    </small>
</div>
                
                <!-- Print button -->
                <div class="mt-4 text-end">
                    <button onclick="window.print()" class="btn btn-primary">
                        <i class="fas fa-print me-2"></i> Print Record
                    </button>
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