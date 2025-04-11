<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Add Doctor</title>
<!-- Bootstrap CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<!-- Bootstrap Icons -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
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

.form-card {
	background-color: white;
	border-radius: 10px;
	padding: 25px;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
	margin-bottom: 30px;
}

.form-section-title {
	font-size: 18px;
	color: var(--primary-color);
	margin-bottom: 20px;
	font-weight: 600;
	padding-bottom: 10px;
	border-bottom: 1px solid #e0e0e0;
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

.btn-primary {
	background-color: var(--primary-color);
	border-color: var(--primary-color);
}

.btn-primary:hover {
	background-color: #3d4a75;
	border-color: #3d4a75;
}

.btn-outline-primary {
	color: var(--primary-color);
	border-color: var(--primary-color);
}

.btn-outline-primary:hover {
	background-color: var(--primary-color);
	color: white;
}

.form-label {
	font-weight: 500;
	color: var(--text-color);
}

.required::after {
	content: " *";
	color: #dc3545;
}

/* Responsive styles */
@media ( max-width : 992px) {
	.sidebar {
		width: 220px;
	}
	.content {
		margin-left: 220px;
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
}

@media ( max-width : 576px) {
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
		<div class="nav-item active" onclick="navigateTo('Admin/Doctors')">Doctors</div>
        <div class="nav-item" onclick="navigateTo('Admin/Appointments')">Appointments</div>
        <div class="nav-item" onclick="window.location.href='${pageContext.request.contextPath}/LogoutServlet'">
    Logout
</div>
	</div>

	<div class="content">
		<div class="d-flex justify-content-between align-items-center mb-4">
			<div>
				<h2>Add New Doctor</h2>
				<p class="text-muted" id="current-datetime"></p>
			</div>
			<button class="btn btn-outline-primary"
				onclick="navigateTo('Admin/Doctors')">
				<i class="bi bi-arrow-left me-2"></i> Back to Doctor List
			</button>
		</div>

		<div class="container-fluid px-0">
			<form id="addDoctorForm" action="Admin/SaveDoctor" method="post"
				class="needs-validation" novalidate>
				<!-- Personal Information -->
				<div class="form-card">
					<div class="form-section-title">Personal Information</div>
					<div class="row g-3">
						<div class="col-md-6">
							<label for="firstName" class="form-label required">First
								Name</label> <input type="text" class="form-control" id="firstName"
								name="firstName" required>
							<div class="invalid-feedback">Please enter first name</div>
						</div>
						<div class="col-md-6">
							<label for="lastName" class="form-label required">Last
								Name</label> <input type="text" class="form-control" id="lastName"
								name="lastName" required>
							<div class="invalid-feedback">Please enter last name</div>
						</div>
						<div class="col-md-6">
							<label for="email" class="form-label required">Email</label> <input
								type="email" class="form-control" id="email" name="email"
								required>
							<div class="invalid-feedback">Please enter a valid email</div>
						</div>
						<div class="col-md-6">
							<label for="phone" class="form-label required">Phone
								Number</label> <input type="tel" class="form-control" id="phone"
								name="phone" required>
							<div class="invalid-feedback">Please enter phone number</div>
						</div>
						<div class="col-md-6">
							<label for="dateOfBirth" class="form-label required">Date of Birth</label>
							<input type="date" class="form-control" id="dateOfBirth"
								name="dateOfBirth" required>
								<div class="invalid-feedback">Please select a
								DOB</div>
						</div>
						<div class="col-md-6">
							<label for="gender" class="form-label required">Gender</label> <select
								class="form-select" id="gender" name="gender" required>
								<option value="">Select Gender</option>
								<option value="male">Male</option>
								<option value="female">Female</option>
								<option value="other">Other</option>
							</select>
							<div class="invalid-feedback">Please select a
								Gender</div>
						</div>
					</div>
				</div>

				<!-- Professional Information -->
				<div class="form-card">
					<div class="form-section-title">Professional Information</div>
					<div class="row g-3">
						<div class="col-md-6">
							<label for="licenseNumber" class="form-label required">License
								Number</label> <input type="text" class="form-control"
								id="licenseNumber" name="licenseNumber" required>
							<div class="invalid-feedback">Please enter license number</div>
						</div>
						<div class="col-md-6">
							<label for="experience" class="form-label required">Years
								of Experience</label> <input type="number" class="form-control"
								id="experience" name="experience" min="0" required>
							<div class="invalid-feedback">Please enter years of
								experience</div>
						</div>
						<div class="col-md-6">
							<label for="specialization" class="form-label required">Specialization</label>
							<select class="form-select" id="specialization"
								name="specialization" required>
								<option value="">Select Specialization</option>
								<option value="Cardiology">Cardiology</option>
								<option value="Neurology">Neurology</option>
								<option value="Orthopedics">Orthopedics</option>
								<option value="Pediatrics">Pediatrics</option>
								<option value="Dermatology">Dermatology</option>
								<option value="Oncology">Oncology</option>
								<option value="Gynecology">Gynecology</option>
								<option value="Ophthalmology">Ophthalmology</option>
							</select>
							<div class="invalid-feedback">Please select a
								specialization</div>
						</div>
						<div class="col-md-6">
							<label for="designation" class="form-label required">Degree</label>
							<input type="text" class="form-control" id="designation"
								name="designation" required>
							<div class="invalid-feedback">Please enter designation</div>
						</div>
						<div class="col-md-12">
							<label for="qualifications" class="form-label">Qualifications</label>
							<textarea class="form-control" id="qualifications"
								name="qualifications" rows="3"></textarea>
						</div>
					</div>
				</div>

				<!-- Account Information -->
				<div class="form-card">
					<div class="form-section-title">Account Information</div>
					<div class="row g-3">
						<div class="col-md-6">
							<label for="username" class="form-label required">Username</label>
							<input type="text" class="form-control" id="username"
								name="username" required>
							<div class="invalid-feedback">Please enter username</div>
						</div>
						<div class="col-md-6">
							<label for="password" class="form-label required">Password</label>
							<input type="password" class="form-control" id="password"
								name="password" required>
							<div class="invalid-feedback">Please enter password</div>
						</div>
						<div class="col-md-6">
							<label for="confirmPassword" class="form-label required">Confirm
								Password</label> <input type="password" class="form-control"
								id="confirmPassword" name="confirmPassword" required>
							<div class="invalid-feedback">Passwords do not match</div>
						</div>
					</div>
				</div>
				<!-- Add schedule  -->
				
				<!-- Schedule Information -->
				<div class="form-card">
				    <div class="form-section-title">Schedule Information</div>
				    <div class="row mb-3">
				        <div class="col-12">
				            <div class="d-flex justify-content-between">
				                <h6>Weekly Schedule</h6>
				                <button type="button" class="btn btn-sm btn-outline-primary" id="addScheduleBtn">
				                    <i class="bi bi-plus-circle"></i> Add Schedule
				                </button>
				            </div>
				            <hr>
				        </div>
				    </div>
				    
				    <div id="scheduleContainer">
				        <div class="schedule-item card p-3 mb-3">
				            <div class="row g-3">
				                <div class="col-md-4">
				                    <label for="dayOfWeek0" class="form-label required">Day of Week</label>
				                    <select class="form-select" id="dayOfWeek0" name="dayOfWeek[]" required>
				                        <option value="">Select Day</option>
				                        <option value="1">Monday</option>
				                        <option value="2">Tuesday</option>
				                        <option value="3">Wednesday</option>
				                        <option value="4">Thursday</option>
				                        <option value="5">Friday</option>
				                        <option value="6">Saturday</option>
				                        <option value="0">Sunday</option>
				                    </select>
				                    <div class="invalid-feedback">Please select a day</div>
				                </div>
				                <div class="col-md-4">
				                    <label for="startTime0" class="form-label required">Start Time</label>
				                    <input type="time" class="form-control" id="startTime0" name="startTime[]" required>
				                    <div class="invalid-feedback">Please select start time</div>
				                </div>
				                <div class="col-md-4">
				                    <label for="endTime0" class="form-label required">End Time</label>
				                    <input type="time" class="form-control" id="endTime0" name="endTime[]" required>
				                    <div class="invalid-feedback">Please select end time</div>
				                </div>
				                <div class="col-md-6">
				                    <label for="maxTokens0" class="form-label required">Max Tokens</label>
				                    <input type="number" class="form-control" id="maxTokens0" name="maxTokens[]" min="1" required>
				                    <div class="invalid-feedback">Please enter max tokens</div>
				                </div>
				                <div class="col-md-6">
				                    <label for="isAvailable0" class="form-label">Availability</label>
				                    <select class="form-select" id="isAvailable0" name="isAvailable[]">
				                        <option value="true" selected>Available</option>
				                        <option value="false">Not Available</option>
				                    </select>
				                </div>
				                <div class="col-12">
				                    <button type="button" class="btn btn-sm btn-outline-danger remove-schedule" style="display: none;">
				                        <i class="bi bi-trash"></i> Remove
				                    </button>
				                </div>
				            </div>
				        </div>
				    </div>
				</div>


				<!-- Form Actions -->
				<div class="d-flex justify-content-between mb-4">
					<button type="button" class="btn btn-outline-secondary"
						onclick="navigateTo('Admin/Doctors')">Cancel</button>
					<div>
						<button type="reset" class="btn btn-outline-primary me-2">Reset</button>
						<button type="submit" class="btn btn-primary">Save Doctor</button>
					</div>
				</div>
			</form>
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
				weekday : 'long',
				year : 'numeric',
				month : 'long',
				day : 'numeric',
				hour : '2-digit',
				minute : '2-digit',
				second : '2-digit'
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
			document.getElementById("sidebar-overlay").classList
					.toggle("active");
		}

		function navigateTo(page) {
        	const contextPath = '${pageContext.request.contextPath}';
            window.location.href = contextPath + '/' + page;
        }

		// Handle responsive behavior
		window.addEventListener('resize', function() {
			if (window.innerWidth > 768) {
				document.getElementById("sidebar").classList.remove("active");
				document.getElementById("sidebar-overlay").classList
						.remove("active");
			}
		});

		// Form validation
		(function() {
			'use strict'

			// Fetch all forms that need validation
			const forms = document.querySelectorAll('.needs-validation');

			// Loop over them and prevent submission
			Array
					.from(forms)
					.forEach(
							function(form) {
								form
										.addEventListener(
												'submit',
												function(event) {
													if (!form.checkValidity()) {
														event.preventDefault();
														event.stopPropagation();
													} else {
														// Check if passwords match
														const password = document
																.getElementById('password');
														const confirmPassword = document
																.getElementById('confirmPassword');

														if (password.value !== confirmPassword.value) {
															confirmPassword
																	.setCustomValidity('Passwords do not match');
															event
																	.preventDefault();
															event
																	.stopPropagation();
														} else {
															confirmPassword
																	.setCustomValidity('');
														}
													}

													form.classList
															.add('was-validated');
												}, false);
							});
		})();

		// Clear custom validity when typing in confirm password field
		document.getElementById('confirmPassword').addEventListener(
				'input',
				function() {
					const password = document.getElementById('password');
					const confirmPassword = document
							.getElementById('confirmPassword');

					if (password.value !== confirmPassword.value) {
						confirmPassword
								.setCustomValidity('Passwords do not match');
					} else {
						confirmPassword.setCustomValidity('');
					}
				});

		// License number validation - allow only alphanumeric characters
		document.getElementById('licenseNumber').addEventListener('input',
				function() {
					this.value = this.value.replace(/[^a-zA-Z0-9]/g, '');
				});

		// Phone number validation - allow only numbers and some special characters
		document.getElementById('phone').addEventListener('input', function() {
			this.value = this.value.replace(/[^0-9+\-() ]/g, '');
		});

		// Username validation - allow only alphanumeric characters and underscores
		document.getElementById('username').addEventListener('input',
				function() {
					this.value = this.value.replace(/[^a-zA-Z0-9_]/g, '');
				});
		
		
		
		
		
		// Schedule management
		let scheduleCounter = 1;

		document.getElementById('addScheduleBtn').addEventListener('click', function() {
		    const container = document.getElementById('scheduleContainer');
		    const newSchedule = document.createElement('div');
		    newSchedule.className = 'schedule-item card p-3 mb-3';
		    
		    newSchedule.innerHTML = `
		        <div class="row g-3">
		            <div class="col-md-4">
		                <label for="dayOfWeek${scheduleCounter}" class="form-label required">Day of Week</label>
		                <select class="form-select" id="dayOfWeek${scheduleCounter}" name="dayOfWeek[]" required>
		                    <option value="">Select Day</option>
		                    <option value="1">Monday</option>
		                    <option value="2">Tuesday</option>
		                    <option value="3">Wednesday</option>
		                    <option value="4">Thursday</option>
		                    <option value="5">Friday</option>
		                    <option value="6">Saturday</option>
		                    <option value="7">Sunday</option>
		                </select>
		                <div class="invalid-feedback">Please select a day</div>
		            </div>
		            <div class="col-md-4">
		                <label for="startTime${scheduleCounter}" class="form-label required">Start Time</label>
		                <input type="time" class="form-control" id="startTime${scheduleCounter}" name="startTime[]" required>
		                <div class="invalid-feedback">Please select start time</div>
		            </div>
		            <div class="col-md-4">
		                <label for="endTime${scheduleCounter}" class="form-label required">End Time</label>
		                <input type="time" class="form-control" id="endTime${scheduleCounter}" name="endTime[]" required>
		                <div class="invalid-feedback">Please select end time</div>
		            </div>
		            <div class="col-md-6">
		                <label for="maxTokens${scheduleCounter}" class="form-label required">Max Tokens</label>
		                <input type="number" class="form-control" id="maxTokens${scheduleCounter}" name="maxTokens[]" min="1" required>
		                <div class="invalid-feedback">Please enter max tokens</div>
		            </div>
		            <div class="col-md-6">
		                <label for="isAvailable${scheduleCounter}" class="form-label">Availability</label>
		                <select class="form-select" id="isAvailable${scheduleCounter}" name="isAvailable[]">
		                    <option value="true" selected>Available</option>
		                    <option value="false">Not Available</option>
		                </select>
		            </div>
		            <div class="col-12">
		                <button type="button" class="btn btn-sm btn-outline-danger remove-schedule">
		                    <i class="bi bi-trash"></i> Remove
		                </button>
		            </div>
		        </div>
		    `;
		    
		    container.appendChild(newSchedule);
		    
		    // Show the remove button for the first schedule once there are multiple schedules
		    if (container.querySelectorAll('.schedule-item').length > 1) {
		        document.querySelector('.schedule-item .remove-schedule').style.display = 'inline-block';
		    }
		    
		    // Add event listener to the new remove button
		    newSchedule.querySelector('.remove-schedule').addEventListener('click', function() {
		        container.removeChild(newSchedule);
		        // Hide the remove button for the first schedule if only one remains
		        if (container.querySelectorAll('.schedule-item').length === 1) {
		            document.querySelector('.schedule-item .remove-schedule').style.display = 'none';
		        }
		    });
		    
		    scheduleCounter++;
		});

		// Add event listener to the initial remove button
		document.querySelector('.remove-schedule').addEventListener('click', function() {
		    const container = document.getElementById('scheduleContainer');
		    if (container.querySelectorAll('.schedule-item').length > 1) {
		        this.closest('.schedule-item').remove();
		    }
		});

		// Token calculation based on start and end time
		function calculateMaxTokens(startTime, endTime) {
		    if (startTime && endTime) {
		        const start = new Date(`2023-01-01T${startTime}`);
		        const end = new Date(`2023-01-01T${endTime}`);
		        
		        // Calculate difference in minutes
		        const diffInMinutes = (end - start) / (1000 * 60);
		        
		        // Calculate tokens (1 token per 6 minutes = 10 tokens per hour)
		        return Math.floor(diffInMinutes / 6);
		    }
		    return 0;
		}

		// Set up event listeners for time inputs to calculate tokens automatically
		document.addEventListener('change', function(e) {
		    if (e.target.name === 'startTime[]' || e.target.name === 'endTime[]') {
		        const scheduleItem = e.target.closest('.schedule-item');
		        const startTimeInput = scheduleItem.querySelector('[name="startTime[]"]');
		        const endTimeInput = scheduleItem.querySelector('[name="endTime[]"]');
		        const maxTokensInput = scheduleItem.querySelector('[name="maxTokens[]"]');
		        
		        if (startTimeInput.value && endTimeInput.value) {
		            const tokens = calculateMaxTokens(startTimeInput.value, endTimeInput.value);
		            if (tokens > 0) {
		                maxTokensInput.value = tokens;
		            } else {
		                maxTokensInput.value = '';
		                alert('End time must be after start time');
		            }
		        }
		    }
		});
	</script>
</body>
</html>