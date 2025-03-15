<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Available Doctors</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css">
    <style>
        :root {
            --sidebar-bg: #4f95e9;
            --primary-color: #4f95e9;
            --light-bg: #f7f9fc;
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
        
        .doctors-container {
            background: white;
            border-radius: 10px;
            padding: 0;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            overflow: hidden;
            margin-bottom: 30px;
        }
        
        .doctors-header {
            background-color: var(--primary-color);
            color: white;
            padding: 15px 20px;
            font-size: 18px;
            font-weight: bold;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .doctors-table {
            width: 100%;
        }
        
        .doctors-table th {
            background-color: #f5f5f5;
            color: #666;
            font-weight: 500;
            padding: 12px 20px;
            text-align: left;
        }
        
        .doctors-table td {
            padding: 12px 20px;
            border-bottom: 1px solid #eee;
        }
        
        .doctors-table tr:last-child td {
            border-bottom: none;
        }
        
        .doctor-avatar {
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
        
        .doctor-info {
            display: flex;
            align-items: center;
        }
        
        .badge-specialty {
            background-color: #e3f2fd;
            color: #1565c0;
            font-weight: 500;
            padding: 6px 12px;
            border-radius: 4px;
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
        
        .search-container {
            margin-bottom: 20px;
        }
        
        /* Responsive styles */
        @media (max-width: 1250px) {
            .doctors-table {
                display: block;
                overflow-x: auto;
            }
        }
        
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
        <div class="nav-item" onclick="navigateTo('Patient/Appointments')">Appointments</div>
        <div class="nav-item active" onclick="navigateTo('Patient/Doctors')">Doctors</div>
        <div class="nav-item" onclick="navigateTo('Patient/Profile')">Profile</div>
    </div>
    
    <div class="content">
        <h2>Doctors</h2>
        <p class="text-muted">Find the right specialist for your healthcare needs</p>
        
        <!-- Search & Filter -->
        <div class="search-container">
            <form action="${pageContext.request.contextPath}/Patient/Doctors" method="get" class="row g-3">
                <div class="col-md-4">
                    <label for="specialization" class="form-label">Filter by Specialty</label>
                    <select name="specialization" id="specialization" class="form-select">
                        <option value="">All Specialties</option>
                        <c:forEach items="${specializations}" var="specialty">
                            <option value="${specialty}" ${param.specialization eq specialty ? 'selected' : ''}>${specialty}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-4 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-filter"></i> Filter
                    </button>
                </div>
            </form>
        </div>
        
        <!-- Doctors Table -->
        <div class="doctors-container">
            <div class="doctors-header">
                <div>Available Doctors</div>
                <div class="search-box">
                    <input type="text" id="doctorSearch" class="form-control" placeholder="Search doctors..." onkeyup="searchDoctors()">
                </div>
            </div>
            <table class="doctors-table" id="doctorsTable">
                <thead>
                    <tr>
                        <th>Doctor</th>
                        <th>Specialty</th>
                        <th>Experience</th>
                        <th>Qualifications</th>
                        <th>Contact</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${doctors}" var="doctorInfo" varStatus="status">
                        <c:set var="doctorParts" value="${fn:split(doctorInfo, '|')}" />
                        <c:set var="doctorId" value="${fn:trim(fn:substringAfter(doctorParts[0], 'ID:'))}" />
                        <c:set var="doctorName" value="${fn:trim(doctorParts[1])}" />
                        <c:set var="specialty" value="${fn:trim(doctorParts[2])}" />
                        <c:set var="experience" value="${fn:trim(doctorParts[3])}" />
                        <c:set var="degree" value="${fn:trim(doctorParts[4])}" />
                        <c:set var="contact" value="${fn:trim(doctorParts[5])}" />
                        <c:set var="email" value="${fn:trim(doctorParts[6])}" />
                        
                        <tr>
                            <td>
                                <div class="doctor-info">
                                    <div class="doctor-avatar" style="background-color: hsl(${(status.index * 40) % 360}, 70%, 60%)">
                                        ${fn:substring(doctorName, 4, 5)}
                                    </div>
                                    ${doctorName}
                                </div>
                            </td>
                            <td>
                                <span class="badge-specialty">${specialty}</span>
                            </td>
                            <td>${experience}</td>
                            <td>
							    <c:choose>
							        <c:when test="${fn:length(degree) > 20}">
							            <div style="max-width: 150px; word-wrap: break-word;">
							                ${degree}
							            </div>
							        </c:when>
							        <c:otherwise>
							            ${degree}
							        </c:otherwise>
							    </c:choose>
							</td>
                            <td>${contact}</td>
                            <td>
                                <button class="btn btn-success" onclick="bookAppointment(${doctorId})">
                                     Book Appointment
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                    
                    <c:if test="${empty doctors}">
                        <tr>
                            <td colspan="6" class="text-center py-4">
                                <div class="alert alert-info mb-0">
                                    No doctors found. Please try a different search.
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
        function toggleSidebar() {
            document.getElementById("sidebar").classList.toggle("active");
            document.getElementById("sidebar-overlay").classList.toggle("active");
        }
        
        function navigateTo(page) {
        	const contextPath = '${pageContext.request.contextPath}';
            window.location.href = contextPath + '/' + page;
        }
        
        function bookAppointment(doctorId) {
            console.log("Booking appointment with doctor ID: " + doctorId);
            window.location.href = "${pageContext.request.contextPath}/Patient/Appointments?doctorId=" + doctorId;
        }
        
        function searchDoctors() {
            var input, filter, table, tr, td, i, txtValue;
            input = document.getElementById("doctorSearch");
            filter = input.value.toUpperCase();
            table = document.getElementById("doctorsTable");
            tr = table.getElementsByTagName("tr");
            
            for (i = 1; i < tr.length; i++) { // Start from 1 to skip the header row
                let visible = false;
                // Search in Doctor name (column 0), Specialty (column 1), and Qualifications (column 3)
                for (let j of [0, 1, 3]) {
                    td = tr[i].getElementsByTagName("td")[j];
                    if (td) {
                        txtValue = td.textContent || td.innerText;
                        if (txtValue.toUpperCase().indexOf(filter) > -1) {
                            visible = true;
                            break;
                        }
                    }
                }
                tr[i].style.display = visible ? "" : "none";
            }
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