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

.appointment-list {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
	gap: 20px;
	margin-bottom: 30px;
}

.appointment-card {
	background-color: white;
	border-radius: 10px;
	padding: 20px;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
	cursor: pointer;
	transition: all 0.3s;
}

.appointment-card:hover {
	transform: translateY(-5px);
	box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
}

.appointment-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 15px;
}

.appointment-id {
	font-weight: bold;
	color: var(--text-color);
}

.appointment-status {
	padding: 5px 15px;
	border-radius: 20px;
	font-size: 12px;
	font-weight: bold;
	text-transform: uppercase;
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

.appointment-info {
	display: grid;
	grid-template-columns: 1fr 1fr;
	grid-gap: 10px;
}

.info-group {
	margin-bottom: 10px;
}

.info-label {
	color: #777;
	font-size: 14px;
	margin-bottom: 3px;
}

.info-value {
	font-weight: bold;
	color: var(--text-color);
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

/* Pagination styles */
.pagination-container {
	display: flex;
	justify-content: center;
	margin: 20px 0;
}

/* Responsive styles */
@media ( max-width : 1200px) {
	.appointment-list {
		grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
	}
}

@media ( max-width : 992px) {
	.sidebar {
		width: 220px;
	}
	.content {
		margin-left: 220px;
	}
	.appointment-list {
		grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
	}
}

@media ( max-width : 768px) {
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
	.appointment-list {
		grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
	}
	.filters-row .col-md-3 {
		margin-bottom: 10px;
	}
}

@media ( max-width : 576px) {
	.appointment-list {
		grid-template-columns: 1fr;
	}
	.appointment-card {
		max-width: 100%;
	}
	.content {
		padding: 15px 10px;
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
		<div class="nav-item " onclick="navigateTo('Admin/Doctors')">Doctors</div>
        <div class="nav-item" onclick="navigateTo('Admin/Appointments')">Appointments</div>
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

			<div class="appointment-list" id="appointmentList">
				<c:forEach var="a" items="${appointments}">
					<div class="appointment-card"
						onclick="viewAppointment(${a.appointmentId})"
						data-id="${a.appointmentId}" data-date="${a.appointmentDate}"
						data-patient="${a.patient.user.username}"
						data-status="${a.status.statusName.toLowerCase()}">
						<div class="appointment-header">
							<span class="appointment-id">Appointment
								#${a.appointmentId}</span> <span
								class="appointment-status status-${a.status.statusName.toLowerCase()}">${a.status.statusName}</span>
						</div>
						<div class="appointment-info">
							<div class="info-group">
								<div class="info-label">Date</div>
								<div class="info-value">${a.appointmentDate}</div>
							</div>
							<div class="info-group">
								<div class="info-label">Day</div>
								<div class="info-value">${a.schedule.dayOfWeek}</div>
							</div>
							<div class="info-group">
								<div class="info-label">Patient</div>
								<div class="info-value">${a.patient.user.username}</div>
							</div>
							<div class="info-group">
								<div class="info-label">Patient ID</div>
								<div class="info-value">${a.patient.patientId}</div>
							</div>
							<div class="info-group">
								<div class="info-label">Doctor</div>
								<div class="info-value">${a.schedule.doctor.user.username}</div>
							</div>
							<div class="info-group">
								<div class="info-label">Reason</div>
								<div class="info-value">${a.reason}</div>
							</div>
						</div>
					</div>
				</c:forEach>
			</div>

			<div class="pagination-container">
				<ul class="pagination">
					<li class="page-item disabled"><a class="page-link" href="#"
						tabindex="-1" aria-disabled="true">Previous</a></li>
					<li class="page-item active"><a class="page-link" href="#">1</a></li>
					<li class="page-item"><a class="page-link" href="#">2</a></li>
					<li class="page-item"><a class="page-link" href="#">3</a></li>
					<li class="page-item"><a class="page-link" href="#">Next</a></li>
				</ul>
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
            
            const appointments = document.querySelectorAll('.appointment-card');
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
            if (visibleCount === 0) {
                // If no "No results" element exists, create one
                if (!document.getElementById('noResults')) {
                    const noResults = document.createElement('div');
                    noResults.id = 'noResults';
                    noResults.className = 'text-center text-danger w-100';
                    noResults.textContent = 'No appointments found';
                    document.getElementById('appointmentList').appendChild(noResults);
                } else {
                    document.getElementById('noResults').style.display = 'block';
                }
            } else if (document.getElementById('noResults')) {
                document.getElementById('noResults').style.display = 'none';
            }
        }
        
        function sortAppointments() {
            const sortBy = document.getElementById('sortBy').value;
            const appointmentList = document.getElementById('appointmentList');
            const appointments = Array.from(document.querySelectorAll('.appointment-card'));
            
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
            
            // Reappend sorted appointments to the container
            appointments.forEach(appointment => {
                appointmentList.appendChild(appointment);
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