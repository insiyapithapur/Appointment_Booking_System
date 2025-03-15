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
        
        .appointments-container {
            background: white;
            border-radius: 10px;
            padding: 0;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            overflow: hidden;
            margin-bottom: 30px;
        }
        
        .appointments-header {
            background-color: var(--primary-color);
            color: white;
            padding: 15px 20px;
            font-size: 18px;
            font-weight: bold;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .appointments-table {
            width: 100%;
        }
        
        .appointments-table th {
            background-color: #f5f5f5;
            color: #666;
            font-weight: 500;
            padding: 12px 20px;
            text-align: left;
        }
        
        .appointments-table td {
            padding: 12px 20px;
            border-bottom: 1px solid #eee;
        }
        
        .appointments-table tr:last-child td {
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
        
        /* Custom badge styles with CSS variables */
        .badge-completed {
            background-color: var(--completed-color);
            color: #2e7d32;
            font-weight: 500;
            padding: 6px 12px;
            border-radius: 4px;
        }
        
        .badge-pending {
            background-color: #fff8e1;
            color: #f57f17;
            font-weight: 500;
            padding: 6px 12px;
            border-radius: 4px;
        }
        
        .badge-cancelled {
            background-color: var(--cancelled-color);
            color: #c62828;
            font-weight: 500;
            padding: 6px 12px;
            border-radius: 4px;
        }
        
        .badge-confirmed {
            background-color: var(--pending-color);
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
        
        .reason-cell {
            max-width: 200px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        
        .reason-tooltip {
            position: relative;
            display: inline-block;
            cursor: pointer;
        }
        
        .reason-tooltip .reason-text {
            visibility: hidden;
            width: 250px;
            background-color: #555;
            color: #fff;
            text-align: left;
            border-radius: 6px;
            padding: 10px;
            position: absolute;
            z-index: 1;
            bottom: 125%;
            left: 50%;
            margin-left: -125px;
            opacity: 0;
            transition: opacity 0.3s;
            white-space: normal;
        }
        
        .reason-tooltip:hover .reason-text {
            visibility: visible;
            opacity: 1;
        }
        
        /* Responsive styles */
        @media (max-width: 1250px) {
            .appointments-table {
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
        <div class="nav-item active" onclick="navigateTo('Patient/Appointments')">Appointments</div>
        <div class="nav-item" onclick="navigateTo('Patient/Doctors')">Doctors</div>
        <div class="nav-item" onclick="navigateTo('Patient/Profile')">Profile</div>
    </div>
    
    <div class="content">
        <h2>My Appointments</h2>
        <p class="text-muted">View and manage your medical appointments</p>
        
        <!-- Display any error or success messages -->
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger" role="alert">
                ${errorMessage}
            </div>
        </c:if>
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success" role="alert">
                ${successMessage}
            </div>
        </c:if>
        
        <!-- Book New Appointment Button -->
        <div class="mb-4">
            <a href="${pageContext.request.contextPath}/Patient/Doctors" class="btn btn-primary">
                <i class="fas fa-plus-circle"></i> Book New Appointment
            </a>
        </div>
        
        <!-- Appointments Table -->
        <div class="appointments-container">
            <div class="appointments-header">
                <div>Appointment History</div>
                <div class="search-box">
                    <input type="text" id="appointmentSearch" class="form-control" placeholder="Search appointments..." onkeyup="searchAppointments()">
                </div>
            </div>
            <table class="appointments-table" id="appointmentsTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Doctor</th>
                        <th>Date</th>
                        <th>Token</th>
                        <th>Reason</th>
                        <th>Status</th>
                        <th>Action</th>
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
                        
                        <tr>
                            <td>${appointmentId}</td>
                            <td>
                                <div class="doctor-info">
                                    <div class="doctor-avatar" style="background-color: hsl(${(status.index * 40) % 360}, 70%, 60%)">
                                        ${fn:substring(doctorName, 4, 5)}
                                    </div>
                                    ${doctorName}
                                </div>
                            </td>
                            <td>${appointmentDate}</td>
                            <td>${tokenNo}</td>
                            <td class="reason-cell">
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
                                            <i class="fas fa-file-medical"></i> View Record
                                        </a>
                                    </c:when>
                                    <c:when test="${fn:containsIgnoreCase(status, 'Pending') || fn:containsIgnoreCase(status, 'Confirmed')}">
                                        <!-- Cancel button for pending appointments -->
                                        <button class="btn btn-sm btn-danger" onclick="cancelAppointment(${appointmentId})">
                                            <i class="fas fa-times-circle"></i> Cancel
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- Disabled button for other statuses -->
                                        <button class="btn btn-sm btn-secondary" disabled>
                                            ${status}
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    
                    <c:if test="${empty appointments}">
                        <tr>
                            <td colspan="7" class="text-center py-4">
                                <div class="alert alert-info mb-0">
                                    You don't have any appointments yet. 
                                    <a href="${pageContext.request.contextPath}/Patient/Doctors" class="alert-link">Book an appointment</a> to get started.
                                </div>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
    
    <!-- Cancel Appointment Modal -->
    <div class="modal fade" id="cancelModal" tabindex="-1" aria-labelledby="cancelModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="cancelModalLabel">Cancel Appointment</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to cancel this appointment?</p>
                    <p class="text-danger">This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <form id="cancelForm" action="${pageContext.request.contextPath}/Patient/CancelAppointment" method="post">
                        <input type="hidden" id="appointmentIdToCancel" name="appointmentId" value="">
                        <button type="submit" class="btn btn-danger">Confirm Cancellation</button>
                    </form>
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
        
        function cancelAppointment(appointmentId) {
            // Set the appointment ID in the modal form
            document.getElementById('appointmentIdToCancel').value = appointmentId;
            
            // Show the modal
            var modal = new bootstrap.Modal(document.getElementById('cancelModal'));
            modal.show();
        }
        
        function searchAppointments() {
            var input, filter, table, tr, td, i, txtValue;
            input = document.getElementById("appointmentSearch");
            filter = input.value.toUpperCase();
            table = document.getElementById("appointmentsTable");
            tr = table.getElementsByTagName("tr");
            
            for (i = 1; i < tr.length; i++) { // Start from 1 to skip the header row
                let visible = false;
                // Search in Doctor name (column 1), Date (column 2), Reason (column 4), and Status (column 5)
                for (let j of [1, 2, 4, 5]) {
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