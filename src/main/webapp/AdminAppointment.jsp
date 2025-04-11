<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Appointments List</title>
<!-- Bootstrap CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<!-- Font Awesome for icons -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css">
<style>
:root {
	--sidebar-bg: #4f5e95;
	--primary-color: #4f5e95;
	--light-bg: #f7f9fc;
	--confirmed-color: #e8f5e9;
	--pending-color: #fff8e1;
	--cancelled-color: #ffebee;
	--completed-color: #e3f2fd;
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
	height: 100vh;
	position: fixed;
	width: 250px;
	padding: 20px 0;
	text-align: center;
	transition: all 0.3s;
	z-index: 1000;
	overflow-y: auto;
}

.content {
	margin-left: 250px;
	padding: 20px;
	transition: all 0.3s;
}

.avatar {
	width: 70px;
	height: 70px;
	border-radius: 50%;
	background-color: #96c8fb;
	color: white;
	font-size: 20px;
	display: flex;
	align-items: center;
	justify-content: center;
	margin: 0 auto 10px;
	cursor: pointer;
	transition: transform 0.2s;
}

.avatar:hover {
	transform: scale(1.05);
}

.nav-item {
	padding: 12px 24px;
	margin: 5px 0;
	cursor: pointer;
	transition: all 0.3s;
	text-align: left;
}

.nav-item.active {
	background-color: #4CAF50;
	border-radius: 5px;
}

.nav-item:hover {
	background-color: rgba(255, 255, 255, 0.2);
	transform: translateX(5px);
}

.appointment-table-container {
    background-color: white;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    overflow: hidden;
    margin-bottom: 30px;
}

.table {
    margin-bottom: 0;
}

.table thead th {
    background-color: #f5f5f5;
    color: #555;
    font-weight: 600;
    padding: 12px 15px;
    border-bottom: 2px solid #e0e0e0;
}

.table tbody tr {
    transition: all 0.2s;
    cursor: pointer;
}

.table tbody tr:hover {
    background-color: rgba(79, 94, 149, 0.05);
}

.table td {
    padding: 12px 15px;
    vertical-align: middle;
    border-bottom: 1px solid #eee;
}

.status-badge {
    padding: 5px 10px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: bold;
    text-transform: uppercase;
    display: inline-block;
}

.status-confirmed {
	background-color: #81C784;
	color: white;
}

.status-pending {
	background-color: #FFD54F;
	color: white;
}

.status-cancelled {
	background-color: #E57373;
	color: white;
}

.status-completed {
	background-color: #64B5F6;
	color: white;
}

.error {
	background-color: #ffebee;
	color: #c62828;
	padding: 10px;
	border-radius: 4px;
	margin-bottom: 20px;
}

.filters-row {
	background-color: white;
	border-radius: 10px;
	padding: 15px;
	margin-bottom: 20px;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.search-box {
	position: relative;
}

.search-box .search-icon {
	position: absolute;
	top: 50%;
	left: 15px;
	transform: translateY(-50%);
	color: #aaa;
}

.search-box input {
	padding-left: 40px;
	border-radius: 50px;
	border: 1px solid #ddd;
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

/* Alert styles for "No records found" */
.alert-no-results {
    background-color: #f8f9fa;
    border: 1px solid #e9ecef;
    color: #6c757d;
    padding: 20px;
    border-radius: 5px;
    text-align: center;
    width: 100%;
}

/* Responsive styles */
@media (max-width: 992px) {
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
	.filters-row .col-md-3 {
		margin-bottom: 10px;
	}
	
	.appointment-table-container {
        overflow-x: auto;
    }
    
    .table th, 
    .table td {
        white-space: nowrap;
    }
}

@media (max-width: 576px) {
	.content {
		padding: 15px 10px;
	}
	
	/* Hide less important columns on very small screens */
    .hide-xs {
        display: none;
    }
}
</style>
</head>
<body>
	<button class="toggle-sidebar" onclick="toggleSidebar()">☰</button>
	<div class="sidebar-overlay" id="sidebar-overlay"
		onclick="toggleSidebar()"></div>

	<div class="sidebar" id="sidebar">
		<div class="avatar">Admin</div>
		<div class="doctor-name mb-4"></div>
		<div class="nav-item" onclick="navigateTo('Admin/Dashboard')">Dashboard</div>
		<div class="nav-item" onclick="navigateTo('Admin/Patients')">Patients</div>
		<div class="nav-item" onclick="navigateTo('Admin/Doctors')">Doctors</div>
        <div class="nav-item active" onclick="navigateTo('Admin/Appointments')">Appointments</div>
        <div class="nav-item" onclick="window.location.href='${pageContext.request.contextPath}/LogoutServlet'">
    Logout
</div>
	</div>
	<div class="content">
		<h2>Appointments</h2>
		<p class="text-muted" id="current-datetime"></p>

		<div class="container-fluid px-0">

			<c:if test="${not empty error}">
				<div class="error">${error}</div>
			</c:if>

			<!-- Filters Row -->
			<div class="filters-row mb-4">
				<div class="row align-items-center">
					<div class="col-md-4 mb-2 mb-md-0">
						<div class="search-box">
							<i class="fas fa-search search-icon"></i> <input type="text"
								class="form-control" id="searchInput"
								placeholder="Search appointments..."
								oninput="filterAppointments()">
						</div>
					</div>
					<div class="col-md-3 mb-2 mb-md-0">
						<input type="date" class="form-control" id="dateFilter"
							onchange="filterAppointments()">
					</div>
					<div class="col-md-3 mb-2 mb-md-0">
						<select class="form-select" id="sortBy"
							onchange="sortAppointments()">
							<option value="dateAsc">Date (Oldest First)</option>
							<option value="dateDesc">Date (Newest First)</option>
							<option value="patientAsc">Patient Name (A-Z)</option>
							<option value="patientDesc">Patient Name (Z-A)</option>
						</select>
					</div>
					<div class="col-md-2 text-md-end">
						<button class="btn btn-outline-secondary" onclick="resetFilters()">
							<i class="fas fa-redo me-1"></i> Reset
						</button>
					</div>
				</div>
			</div>

			<!-- Appointment Table -->
            <div class="appointment-table-container">
                <table class="table" id="appointmentTable">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Patient</th>
                            <th>Doctor</th>
                            <th class="hide-xs">Reason</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="appointmentTableBody">
                        <c:forEach var="a" items="${appointments}">
                            <tr class="appointment-row" onclick="viewAppointment('${a.appointmentId}')"
                                data-id="${a.appointmentId}" 
                                data-date="${a.appointmentDate}"
                                data-patient="${a.patient.user.username}"
                                data-status="${a.status.statusName.toLowerCase()}">
                                <td>${a.appointmentDate}</td>
                                <td>${a.patient.user.username}</td>
                                <td>${a.schedule.doctor.user.username}</td>
                                <td class="hide-xs">
                                    <div class="d-inline-block text-truncate" style="max-width: 150px;" 
                                         title="${a.reason}">
                                        ${a.reason}
                                    </div>
                                </td>
                                <td>
                                    <span class="status-badge status-${a.status.statusName.toLowerCase()}">
                                        ${a.status.statusName}
                                    </span>
                                </td>
                                <td>
                                    <button class="btn btn-sm btn-outline-primary" onclick="event.stopPropagation(); viewAppointment('${a.appointmentId}')">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty appointments}">
                            <tr id="noResultsRow">
                                <td colspan="8" class="text-center py-4">
                                    <div class="alert-no-results">
                                        <i class="fas fa-calendar-times me-2"></i> No appointments found
                                    </div>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
		</div>
	</div>

	<!-- Bootstrap & jQuery JS -->
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
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
                minute: '2-digit',
                second: '2-digit'
            };
            
            const formattedDateTime = now.toLocaleDateString('en-US', options);
            document.getElementById('current-datetime').textContent = formattedDateTime;
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
        
        function viewAppointment(id) {
            // In a real application, this would navigate to the appointment details page
            console.log("Viewing appointment ID: " + id);
            window.location.href = 'appointment-details.jsp?id=' + id;
        }
        
        // Filter functions
        function filterAppointments() {
            const searchText = document.getElementById('searchInput').value.toLowerCase();
            const dateFilter = document.getElementById('dateFilter').value;
            
            const appointments = document.querySelectorAll('.appointment-row');
            let visibleCount = 0;
            
            appointments.forEach(appointment => {
                const id = appointment.getAttribute('data-id');
                const date = appointment.getAttribute('data-date');
                const patient = appointment.getAttribute('data-patient').toLowerCase();
                const status = appointment.getAttribute('data-status');
                
                // Check if appointment matches all selected filters
                const matchesSearch = id.includes(searchText) || 
                                     patient.includes(searchText) || 
                                     status.includes(searchText);
                const matchesDate = dateFilter === '' || date.includes(dateFilter);
                
                // Show or hide based on filter results
                if (matchesSearch && matchesDate) {
                    appointment.style.display = '';
                    visibleCount++;
                } else {
                    appointment.style.display = 'none';
                }
            });
            
            // Show "No results" message if no appointments match filters
            const tbody = document.getElementById('appointmentTableBody');
            const existingNoResults = document.getElementById('dynamicNoResults');
            
            // Remove existing "no results" row if it exists
            if (existingNoResults) {
                existingNoResults.remove();
            }
            
            if (visibleCount === 0 && appointments.length > 0) {
                // Create a "no results" row
                const noResultsRow = document.createElement('tr');
                noResultsRow.id = 'dynamicNoResults';
                noResultsRow.innerHTML = `
                    <td colspan="8" class="text-center py-4">
                        <div class="alert-no-results">
                            <i class="fas fa-filter me-2"></i> No appointments match your filters
                        </div>
                    </td>
                `;
                tbody.appendChild(noResultsRow);
            }
        }
        
        function sortAppointments() {
            const sortBy = document.getElementById('sortBy').value;
            const tbody = document.getElementById('appointmentTableBody');
            const appointments = Array.from(document.querySelectorAll('.appointment-row'));
            
            // Sort appointments based on selected criteria
            appointments.sort((a, b) => {
                switch(sortBy) {
                    case 'dateAsc':
                        return a.getAttribute('data-date').localeCompare(b.getAttribute('data-date'));
                    case 'dateDesc':
                        return b.getAttribute('data-date').localeCompare(a.getAttribute('data-date'));
                    case 'patientAsc':
                        return a.getAttribute('data-patient').localeCompare(b.getAttribute('data-patient'));
                    case 'patientDesc':
                        return b.getAttribute('data-patient').localeCompare(a.getAttribute('data-patient'));
                    default:
                        return 0;
                }
            });
            
            // Get any non-appointment rows (like "no results" message)
            const otherRows = Array.from(tbody.querySelectorAll('tr:not(.appointment-row)'));
            
            // Clear the table body
            tbody.innerHTML = '';
            
            // Add the sorted appointment rows
            appointments.forEach(appointment => {
                tbody.appendChild(appointment);
            });
            
            // Add back the other rows
            otherRows.forEach(row => {
                tbody.appendChild(row);
            });
        }
        
        function resetFilters() {
            document.getElementById('searchInput').value = '';
            document.getElementById('dateFilter').value = '';
            document.getElementById('sortBy').value = 'dateAsc';
            
            filterAppointments();
            sortAppointments();
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