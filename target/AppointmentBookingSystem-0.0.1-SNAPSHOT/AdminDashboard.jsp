<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Medical Dashboard</title>
<!-- Bootstrap CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<!-- Font Awesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
:root {
	--sidebar-bg: #4f5e95;
	--primary-color: #4f5e95;
	--light-bg: #f7f9fc;
	--confirmed-color: #e8f5e9;
	--pending-color: #e3f2fd;
	--text-color: #333;
	--card-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
	--card-hover-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
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

/* Doctors list styles */
.doctors-container {
	background-color: white;
	border-radius: 10px;
	padding: 15px;
	margin-bottom: 20px;
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}

.doctors-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 15px;
}

.doctors-title {
	font-size: 18px;
	font-weight: bold;
	color: var(--primary-color);
}

.total-appointments {
	background-color: var(--primary-color);
	color: white;
	border-radius: 20px;
	padding: 5px 15px;
	font-size: 14px;
	font-weight: bold;
}

.doctors-list {
	display: flex;
	flex-wrap: wrap;
	gap: 15px;
}

.doctor-card {
	background-color: #f5f9ff;
	border-radius: 10px;
	padding: 15px;
	width: calc(25% - 15px);
	min-width: 200px;
	display: flex;
	flex-direction: column;
	align-items: center;
	cursor: pointer;
	transition: all 0.3s;
	position: relative;
}

.doctor-card:hover {
	transform: translateY(-5px);
	box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
}

.doctor-card.active {
	background-color: rgba(76, 175, 80, 0.1);
	border: 2px solid #4CAF50;
}

.doctor-card.active::after {
	content: "Active";
	position: absolute;
	top: 10px;
	right: 10px;
	background-color: #4CAF50;
	color: white;
	font-size: 12px;
	padding: 2px 8px;
	border-radius: 10px;
}

.doctor-avatar {
	width: 60px;
	height: 60px;
	border-radius: 50%;
	background-color: #96c8fb;
	color: white;
	font-size: 18px;
	display: flex;
	align-items: center;
	justify-content: center;
	margin-bottom: 10px;
}

.doctor-name {
	font-weight: bold;
	margin-bottom: 5px;
}

.doctor-specialty {
	font-size: 12px;
	color: #666;
	margin-bottom: 5px;
}

.doctor-appointments {
	font-size: 12px;
	color: var(--primary-color);
	font-weight: bold;
}

/* Dashboard summary styles */
.dashboard-summary {
	background-color: white;
	border-radius: 16px;
	padding: 25px;
	margin-top: 20px;
	box-shadow: var(--card-shadow);
}

.summary-title {
	font-size: 20px;
	font-weight: bold;
	color: var(--primary-color);
	margin-bottom: 20px;
	position: relative;
	padding-bottom: 10px;
}

.summary-title:after {
	content: '';
	position: absolute;
	bottom: 0;
	left: 0;
	width: 40px;
	height: 3px;
	background-color: var(--primary-color);
	border-radius: 3px;
}

.summary-row {
	display: flex;
	flex-wrap: wrap;
	gap: 24px;
	width: 100%;
	margin-bottom: 24px;
}

.summary-row:last-child {
	margin-bottom: 0;
}

.summary-box {
	background-color: #f5f9ff;
	border-radius: 12px;
	padding: 24px;
	flex: 1;
	min-width: 200px;
	text-align: center;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
	transition: all 0.3s ease;
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	position: relative;
	overflow: hidden;
	border: 1px solid rgba(0, 0, 0, 0.05);
}

.summary-box:hover {
	transform: scale(1.03);
	box-shadow: var(--card-hover-shadow);
	z-index: 1;
}

.summary-box:before {
	content: '';
	position: absolute;
	top: 0;
	left: 0;
	width: 4px;
	height: 100%;
	background-color: var(--primary-color);
}

.summary-box-icon {
	font-size: 24px;
	color: var(--primary-color);
	margin-bottom: 15px;
	background-color: rgba(79, 94, 149, 0.1);
	width: 50px;
	height: 50px;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
}

.summary-box-title {
	font-size: 15px;
	color: #555;
	margin-bottom: 10px;
	font-weight: 500;
}

.summary-box-value {
	font-size: 28px;
	font-weight: bold;
	color: var(--primary-color);
}

/* Responsive styles */
@media ( max-width : 991px) {
	.sidebar {
		width: 220px;
	}
	.content {
		margin-left: 220px;
	}
	.doctor-card {
		width: calc(33.33% - 15px);
	}
}

@media ( max-width : 768px) {
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
	.doctor-card {
		width: calc(50% - 15px);
	}
	.summary-row {
		flex-direction: column;
		gap: 16px;
	}
	.summary-box {
		width: 100%;
	}
}

@media ( max-width : 576px) {
	.doctor-card {
		width: 100%;
	}
}
</style>
</head>
<body>
	<button class="toggle-sidebar" onclick="toggleSidebar()">☰</button>
	<div class="sidebar-overlay" id="sidebar-overlay"
		onclick="toggleSidebar()"></div>

	<div class="sidebar" id="sidebar">
<div class="avatar" >Admin</div>
        <div class="doctor-name mb-4"></div>
		<div class="nav-item" onclick="navigateTo('Admin/Dashboard')">Dashboard</div>
		<div class="nav-item" onclick="navigateTo('Admin/Patients')">Patients</div>
		<div class="nav-item " onclick="navigateTo('Admin/Doctors')">Doctors</div>
        <div class="nav-item" onclick="navigateTo('Admin/Appointments')">Appointments</div>
	</div>

	<div class="content">
		<h2>Dashboard</h2>
		<p class="text-muted" id="current-datetime"></p>

		<!-- Dashboard Summary Section -->
		<div class="dashboard-summary">
			<div class="summary-title">Clinic Overview</div>
			<div class="summary-row">
				<div class="summary-box">
					<div class="summary-box-icon">
						<i class="fas fa-users"></i>
					</div>
					<div class="summary-box-title">Total Users</div>
					<div class="summary-box-value">
						<c:out value="${totalUsers}" default="0" />
					</div>
				</div>
				<div class="summary-box">
					<div class="summary-box-icon">
						<i class="fas fa-user-injured"></i>
					</div>
					<div class="summary-box-title">Total Patients</div>
					<div class="summary-box-value">
						<c:out value="${totalPatients}" default="0" />
					</div>
				</div>
			</div>
			<div class="summary-row">
				<div class="summary-box">
					<div class="summary-box-icon">
						<i class="fas fa-user-md"></i>
					</div>
					<div class="summary-box-title">Total Doctors</div>
					<div class="summary-box-value">
						<c:out value="${doctorCount}" default="0" />
					</div>
				</div>
				<div class="summary-box">
					<div class="summary-box-icon">
						<i class="fas fa-calendar-check"></i>
					</div>
					<div class="summary-box-title">Total Appointments</div>
					<div class="summary-box-value">
						<c:out value="${totalAppointments}" default="0" />
					</div>
				</div>
			</div>
			<div class="summary-row">
				<div class="summary-box">
					<div class="summary-box-icon">
						<i class="fas fa-user-check"></i>
					</div>
					<div class="summary-box-title">Total Active Doctor</div>
					<div class="summary-box-value">
						<c:out value="${activeDoctorCount}" default="0" />
					</div>
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
        
        function setActiveDoctor(doctorName) {
            // Get all doctor cards
            const doctorCards = document.querySelectorAll('.doctor-card');
            
            // Remove active class from all cards
            doctorCards.forEach(card => {
                card.classList.remove('active');
            });
            
            // Add active class to the clicked card
            event.currentTarget.classList.add('active');
            
            // Update the sidebar doctor name
            document.querySelector('.sidebar .doctor-name').textContent = 'Dr. ' + doctorName;
            
            // In a real application, you would also update the appointments list
            console.log("Selected doctor: " + doctorName);
            alert("Selected doctor: " + doctorName);
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