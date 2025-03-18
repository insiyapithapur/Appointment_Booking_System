<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Dashboard</title>
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
        }
        
        .appointment-table {
            width: 100%;
        }
        
        .appointment-table th {
            background-color: #f5f5f5;
            color: #666;
            font-weight: 500;
            padding: 12px 20px;
            text-align: left;
        }
        
        .appointment-table td {
            padding: 12px 20px;
            border-bottom: 1px solid #eee;
        }
        
        .appointment-table tr:last-child td {
            border-bottom: none;
        }
        
        /* Badge styles */
        .badge-confirmed {
            background-color: var(--confirmed-color);
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
            background-color: #ffebee;
            color: #c62828;
            font-weight: 500;
            padding: 6px 12px;
            border-radius: 4px;
        }
        
        .badge-completed {
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
        
        .actions {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }
        
        .btn-primary:hover {
            background-color: #3d4a75;
            border-color: #3d4a75;
        }
        
        .btn-danger {
            background-color: #f44336;
            border-color: #f44336;
        }
        
        .reason-cell {
            max-width: 200px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        
        /* Responsive styles */
        @media (max-width: 1250px) {
            .appointment-table {
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
            .actions {
                flex-direction: column;
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
        
        <div class="nav-item active" onclick="navigateTo('Patient/Dashboard')">Dashboard</div>
        <div class="nav-item" onclick="navigateTo('Patient/Appointments')">Appointments</div>
        <div class="nav-item" onclick="navigateTo('Patient/Doctors')">Doctors</div>
        <div class="nav-item" onclick="navigateTo('Patient/Profile')">Profile</div>
        <div class="nav-item" onclick="window.location.href='${pageContext.request.contextPath}/LogoutServlet'">
    Logout
</div>
    </div>
    
    <div class="content">
        <h2>Dashboard</h2>
        <p class="text-muted" id="current-datetime"></p>
        
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
        
        <!-- Upcoming Appointments -->
        <div class="appointments-container">
            <div class="appointments-header">Upcoming Appointments</div>
            
            <c:if test="${empty upcomingAppointments}">
                <div class="p-4 text-center">
                    <div class="alert alert-info mb-0">
                        You have no upcoming appointments.
                    </div>
                </div>
            </c:if>
            
            <c:if test="${not empty upcomingAppointments}">
                <table class="appointment-table">
                    <thead>
                        <tr>
                            <th>Doctor</th>
                            <th>Date</th>
                            <th>Token Number</th>
                            <th>Reason</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="appointmentInfo" items="${upcomingAppointments}">
                            <tr>
                                <c:set var="parts" value="${fn:split(appointmentInfo, '|')}" />
                                <c:set var="appointmentId" value="${fn:trim(fn:substring(parts[1], 15, fn:length(parts[1])))}" />
                                <c:set var="status" value="${fn:trim(fn:substring(parts[5], 8, fn:length(parts[5])))}" />
                                
                                <td>
                                    <div class="patient-info">
                                        <div class="patient-avatar" style="background-color: #61CE70; width: 40px; height: 40px; display: flex; align-items: center; justify-content: center; border-radius: 50%; color: white; font-weight: bold; margin-right: 10px;">
                                            Dr
                                        </div>
                                        ${fn:trim(fn:substring(parts[0], 8, fn:length(parts[0])))}
                                    </div>
                                </td>
                                <td>${fn:trim(fn:substring(parts[2], 6, fn:length(parts[2])))}</td>
                                <td>${fn:trim(fn:substring(parts[3], 7, fn:length(parts[3])))}</td>
                                <td class="reason-cell">${fn:trim(fn:substring(parts[4], 8, fn:length(parts[4])))}</td>
                                <td>
                                    <span class="badge-${fn:toLowerCase(status)}">
                                        ${status}
                                    </span>
                                </td>
                                <!-- Updated Action Buttons Code -->
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
                    </tbody>
                </table>
            </c:if>
        </div>
        
        <div class="actions">
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
	                <h5 class="modal-title" id="cancelModalLabel">Cancel Appointment</h5>
	                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	            </div>
	            <div class="modal-body">
	                <p>Are you sure you want to cancel this appointment?</p>
	                <p class="text-danger">This action cannot be undone.</p>
	            </div>
	            <div class="modal-footer">
	                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
	                <form id="cancelForm" action="${pageContext.request.contextPath}/Patient/Appointments" method="post">
	                    <input type="hidden" id="appointmentIdToCancel" name="appointmentId" value="">
	                    <input type="hidden" name="action" value="cancelAppointment">
	                    <input type="hidden" name="newStatusId" value="3">
	                    <button type="submit" class="btn btn-danger">Confirm Cancellation</button>
	                </form>
	            </div>
	        </div>
	    </div>
	</div>

	
	<!-- Alternative direct implementation of the cancel button functionality -->
	<script>
	    // Alternative manual implementation in case Bootstrap modal isn't working
	    function cancelAppointmentDirect(appointmentId) {
	        if (confirm("Are you sure you want to cancel this appointment? This action cannot be undone.")) {
	            window.location.href = "${pageContext.request.contextPath}/CancelAppointment?id=" + appointmentId;
	        }
	    }
	</script>
    
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

    function cancelAppointment(appointmentId) {
        // Set the appointment ID in the modal form
        document.getElementById('appointmentIdToCancel').value = appointmentId;
        
        // Show the modal
        var modal = new bootstrap.Modal(document.getElementById('cancelModal'));
        modal.show();
    }

    // Handle responsive behavior
    window.addEventListener('resize', function() {
        if (window.innerWidth > 768) {
            document.getElementById("sidebar").classList.remove("active");
            document.getElementById("sidebar-overlay").classList.remove("active");
        }
    });

    // Add this to make sure functions are accessible in the global scope
    window.viewMedicalRecord = viewMedicalRecord;
    window.cancelAppointment = cancelAppointment;
    </script>
</body>
</html>