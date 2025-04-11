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
            --sidebar-bg: #4f5e95;
            --primary-color: #4f5e95;
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
        
		.alert {
		    transition: opacity 0.15s linear;
		}
		
		.alert.fade {
		    opacity: 0;
		}
		
		.alert.fade.show {
		    opacity: 1;
		}
		
		/* Position alerts in a fixed position at the top */
		.alert-container {
		    position: fixed;
		    top: 20px;
		    right: 20px;
		    z-index: 2000;
		    max-width: 350px;
		}
		
        .filter-container {
            background-color: #f9f9f9;
            padding: 15px 20px;
            border-bottom: 1px solid #eee;
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
        
        .reason-tooltip:hover .reason-text {
            visibility: visible;
            opacity: 1;
        }
        
        /* Filter styles */
        .filter-item {
            margin-bottom: 8px;
        }
        
        .filter-label {
            font-weight: 500;
            margin-bottom: 5px;
            color: var(--primary-color);
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
            
            .filter-container .row {
                flex-direction: column;
            }
            
            .filter-container .col-md-4 {
                margin-bottom: 10px;
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
        <div class="nav-item" onclick="window.location.href='${pageContext.request.contextPath}/LogoutServlet'">
    Logout
</div>
    </div>
    
    <div class="content">
        <h2>My Appointments</h2>
        <p class="text-muted">View and manage your medical appointments</p>
        
        <!-- Display any error or success messages -->
        <!-- Replace your existing alert code with this -->
		<!-- Alert Container -->
		<div class="alert-container">
		    <c:if test="${not empty errorMessage}">
		        <div class="alert alert-danger" role="alert">
		            <i class="fas fa-exclamation-circle me-2"></i>
		            ${errorMessage}
		            <button type="button" class="btn-close ms-2" data-bs-dismiss="alert" aria-label="Close"></button>
		        </div>
		    </c:if>
		    <c:if test="${not empty successMessage}">
		        <div class="alert alert-success" role="alert">
		            <i class="fas fa-check-circle me-2"></i>
		            ${successMessage}
		            <button type="button" class="btn-close ms-2" data-bs-dismiss="alert" aria-label="Close"></button>
		        </div>
		    </c:if>
		</div>
        
        <!-- Appointments Table -->
        <div class="appointments-container">
            <div class="appointments-header">
                <div>Appointment History</div>
            </div>
            
            <!-- Filter Controls -->
			<div class="filter-container">
			    <div class="row align-items-end">
			        <!-- Text filter for doctor name or reason -->
			        <div class="col-md-3">
			            <div class="filter-item">
			                <div class="filter-label">
			                    <i class="fas fa-search me-1"></i> Search
			                </div>
			                <input type="text" id="textFilter" class="form-control" 
			                       placeholder="Doctor name or reason..." 
			                       onkeyup="applyFilters()">
			            </div>
			        </div>
			        
			        <!-- Date filter -->
			        <div class="col-md-3">
					    <div class="filter-item">
					        <div class="filter-label">
					            <i class="far fa-calendar-alt me-1"></i> Date
					        </div>
					        <input type="date" id="dateFilter" class="form-control" 
					               onchange="applyFilters()">
					    </div>
					</div>
			        
			        <!-- Status filter dropdown -->
			        <div class="col-md-3">
			            <div class="filter-item">
			                <div class="filter-label">
			                    <i class="fas fa-tasks me-1"></i> Status
			                </div>
			                <select id="statusFilter" class="form-select" onchange="applyFilters()">
			                    <option value="all">All</option>
			                    <option value="Pending">Pending</option>
			                    <option value="Completed">Completed</option>
			                    <option value="Cancelled">Cancelled</option>
			                </select>
			            </div>
			        </div>
			        
			        <!-- Reset Filters Button -->
			        <div class="col-md-3">
			            <div class="filter-item">
			                <button class="btn btn-outline-secondary w-100" onclick="resetFilters()">
			                    <i class="fas fa-redo-alt me-1"></i> Reset Filters
			                </button>
			            </div>
			        </div>
			    </div>
			</div>
            
            <table class="appointments-table" id="appointmentsTable">
                <thead>
                    <tr>
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
                        
                        <!-- Set a predefined color based on appointmentId -->
                        <c:set var="avatarColor" value="hsl(${(appointmentId * 40) % 360}, 70%, 60%)" />
                        
                        <tr class="appointment-row" 
                            data-doctor="${doctorName}" 
                            data-date="${appointmentDate}" 
                            data-status="${status}" 
                            data-reason="${reason}">
                            <td>
                                <div class="doctor-info">
                                    <div class="doctor-avatar" style="background-color: ${avatarColor}">
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
                        <tr id="no-appointments-row">
                            <td colspan="6" class="text-center py-4">
                                <div class="alert alert-info mb-0">
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
        
        // Updated applyFilters function with corrected date formatting for DD-MM-YYYY
		function applyFilters() {
		    const textFilter = document.getElementById('textFilter').value.toUpperCase();
		    const dateInput = document.getElementById('dateFilter').value; // This is in YYYY-MM-DD format
		    const statusFilter = document.getElementById('statusFilter').value;
		    
		    // Log the filters for debugging
		    console.log("Filters applied - Text:", textFilter, "Date:", dateInput, "Status:", statusFilter);
		    
		    let visibleRows = 0;
		    const rows = document.getElementsByClassName('appointment-row');
		    
		    // If there's a date filter, create a Date object for comparison
		    let selectedDate = null;
		    if (dateInput) {
		        selectedDate = new Date(dateInput);
		        console.log("Selected date object:", selectedDate);
		    }
		    
		    for (let i = 0; i < rows.length; i++) {
		        const row = rows[i];
		        
		        // Check text filter (doctor name or reason)
		        const doctorName = row.getAttribute('data-doctor').toUpperCase();
		        const reason = row.getAttribute('data-reason').toUpperCase();
		        const textMatch = !textFilter || 
		                         doctorName.includes(textFilter) || 
		                         reason.includes(textFilter);
		        
		        // For debugging: log the data of the first row
		        if (i === 0) {
		            console.log("First row data - Doctor:", doctorName, "Reason:", reason, "Match:", textMatch);
		        }
		        
		        // Check date filter with multiple format support
		        let dateMatch = true;
		        if (selectedDate) {
		            dateMatch = false; // Default to false if date filter is applied
		            const rawAppointmentDate = row.getAttribute('data-date');
		            
		            // Log raw date for debugging
		            if (i === 0) {
		                console.log("Raw appointment date:", rawAppointmentDate);
		            }
		            
		            // Try different date formats
		            
		            // 1. Try "Apr 21, 2025" format
		            if (rawAppointmentDate.includes(",")) {
		                try {
		                    const appDate = new Date(rawAppointmentDate);
		                    if (i === 0) console.log("Parsed as 'Apr 21, 2025':", appDate);
		                    
		                    // Compare year, month, and day
		                    if (appDate.getFullYear() === selectedDate.getFullYear() &&
		                        appDate.getMonth() === selectedDate.getMonth() &&
		                        appDate.getDate() === selectedDate.getDate()) {
		                        dateMatch = true;
		                    }
		                } catch (e) {
		                    console.log("Error parsing date:", e);
		                }
		            }
		            
		            // 2. Try "DD-MM-YYYY" format
		            if (!dateMatch && rawAppointmentDate.includes("-")) {
		                try {
		                    const parts = rawAppointmentDate.split("-");
		                    if (parts.length === 3) {
		                        // Assume DD-MM-YYYY format
		                        const day = parseInt(parts[0], 10);
		                        const month = parseInt(parts[1], 10) - 1; // JS months are 0-indexed
		                        const year = parseInt(parts[2], 10);
		                        
		                        if (i === 0) console.log("Parsed as DD-MM-YYYY:", year, month, day);
		                        
		                        if (year === selectedDate.getFullYear() &&
		                            month === selectedDate.getMonth() &&
		                            day === selectedDate.getDate()) {
		                            dateMatch = true;
		                        }
		                    }
		                } catch (e) {
		                    console.log("Error parsing DD-MM-YYYY:", e);
		                }
		            }
		            
		            // Debug the final date match result
		            if (i === 0) {
		                console.log("Date match result:", dateMatch);
		            }
		        }
		        
		        // Check status filter
		        const status = row.getAttribute('data-status');
		        const statusMatch = statusFilter === "all" || status === statusFilter;
		        
		        // Show/hide row based on all filters
		        if (textMatch && dateMatch && statusMatch) {
		            row.style.display = "";
		            visibleRows++;
		        } else {
		            row.style.display = "none";
		        }
		    }
		    
		    // Show "no results" message if no visible rows
		    const noResultsRow = document.getElementById('no-results-row');
		    if (visibleRows === 0 && rows.length > 0) {
		        noResultsRow.style.display = "";
		    } else {
		        noResultsRow.style.display = "none";
		    }
		    
		    console.log("Filter applied - Visible rows:", visibleRows);
		}
     
        function resetFilters() {
            // Reset text filter
            document.getElementById('textFilter').value = "";
            
            // Reset date filter
            document.getElementById('dateFilter').value = "";
            
            // Reset status filter
            document.getElementById('statusFilter').value = "all";
            
            // Apply the reset filters
            applyFilters();
        }
        
        // Handle responsive behavior
        window.addEventListener('resize', function() {
            if (window.innerWidth > 768) {
                document.getElementById("sidebar").classList.remove("active");
                document.getElementById("sidebar-overlay").classList.remove("active");
            }
        });
        
        // Initialize filters on page load
        document.addEventListener('DOMContentLoaded', function() {
            // Initialize Bootstrap tooltips
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
            var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl)
            });
        });
        
        document.addEventListener('DOMContentLoaded', function() {
            // Auto-hide success and error messages after 5 seconds
            const alerts = document.querySelectorAll('.alert-success, .alert-danger');
            
            alerts.forEach(function(alert) {
                // Add fade class for smooth transition
                alert.classList.add('fade', 'show');
                
                // Auto-hide after 5 seconds
                setTimeout(function() {
                    // Start fade out
                    alert.classList.remove('show');
                    
                    // Remove from DOM after animation completes
                    setTimeout(function() {
                        alert.remove();
                    }, 150); // Matches Bootstrap's transition time
                }, 5000);
            });
            
            // Initialize Bootstrap tooltips
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
            var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl)
            });
        });
    </script>
</body>
</html>