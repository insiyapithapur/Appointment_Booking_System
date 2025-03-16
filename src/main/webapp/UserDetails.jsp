<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Register</title>
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

.content {
	padding: 20px;
	transition: all 0.3s;
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
@media (max-width: 992px) {
	.content {
		padding: 20px;
	}
}

@media (max-width: 768px) {
	.content {
		padding: 15px;
	}
}

@media (max-width: 576px) {
	.content {
		padding: 15px 10px;
	}
}
</style>
</head>
<body>
	<div class="content">
		<div class="d-flex justify-content-between align-items-center mb-4">
			<div>
				<h2>Just a step away to log you in</h2>
			</div>
		</div>

		<div class="container-fluid px-0">
			<form id="UserDetails" action="${pageContext.request.contextPath}/UserDetails" method="post"
				class="needs-validation" novalidate>
				<!-- Personal Information -->
				<div class="form-card">
					<div class="form-section-title">Enter Information</div>
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
						<div class="col-md-6">
							<label for="bloodGroup" class="form-label required">Blood Group</label>
							<select class="form-select" id="bloodGroup"
								name="bloodGroup" required>
								<option value="">Select Blood Group</option>
								<option value="A+">A+</option>
								<option value="A-">A-</option>
								<option value="B+">B+</option>
								<option value="B-">B-</option>
								<option value="AB+">AB+</option>
								<option value="AB-">AB-</option>
								<option value="O+">O+</option>
								<option value="O-">O-</option>
							</select>
							<div class="invalid-feedback">Please select a
								Blood Group</div>
						</div>
					</div>
				</div>

				<!-- Form Actions -->
				<div class="d-flex justify-content-between mb-4">
					
					<div>
						<button type="reset" class="btn btn-outline-primary me-2">Reset</button>
						<button type="submit" class="btn btn-primary">Register</button>
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
		// Form validation
		(function() {
			'use strict'

			// Fetch all forms that need validation
			const forms = document.querySelectorAll('.needs-validation');

			// Loop over them and prevent submission
			Array.from(forms).forEach(function(form) {
				form.addEventListener('submit', function(event) {
					if (!form.checkValidity()) {
						event.preventDefault();
						event.stopPropagation();
					}
					form.classList.add('was-validated');
				}, false);
			});
		})();

		// Phone number validation - allow only numbers and some special characters
		document.getElementById('phone').addEventListener('input', function() {
			this.value = this.value.replace(/[^0-9+\-() ]/g, '');
		});
		
		// Email validation
		document.getElementById('email').addEventListener('input', function() {
			const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
			if (!emailRegex.test(this.value)) {
				this.setCustomValidity('Please enter a valid email address');
			} else {
				this.setCustomValidity('');
			}
		});
	</script>
</body>
</html>