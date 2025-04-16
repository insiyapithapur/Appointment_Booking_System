<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Healthcare Management System</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css">
    <!-- Inter font from Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            /* Sky blue theme colors (matching dashboard) */
            --primary-color: #4dabf7;
            --primary-light: #e7f5ff;
            --primary-dark: #339af0;
            --bg-color: #ffffff;
            --bg-secondary: #f8fafc;
            --sidebar-bg: #f8fafc;
            --text-primary: #2b3d4f;
            --text-secondary: #6c757d;
            --border-color: #dbe4ff;
            --error-color: #eb5757;
            --success-color: #219653;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body, html {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background-color: var(--bg-secondary);
            height: 100%;
            color: var(--text-primary);
            line-height: 1.5;
        }
        
        .login-container {
            display: flex;
            height: 100vh;
        }
        
        .brand-side {
            display: none;
            flex: 0 0 40%;
            background-image: url('images/LoginPage.jpg'); /* Same image as login page */
            background-size: cover;
            background-position: center;
            position: relative;
            overflow: hidden;
            color: white;
            /* Gradient fallback if image fails to load */
            background-color: #4dabf7;
            background: linear-gradient(135deg, #43a7d5 0%, #4dabf7 100%);
        }
        
        .brand-side-content {
            padding: 40px;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            position: relative;
            z-index: 2;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.5);
        }
        
        .brand-logo {
            font-size: 24px;
            font-weight: 600;
        }
        
        .brand-graphic {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.3); /* Slightly lighter overlay */
            z-index: 1;
        }
        
        .brand-quote {
            font-size: 18px;
            font-weight: 300;
            max-width: 80%;
        }
        
        .form-side {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .register-form-container {
            width: 100%;
            max-width: 450px; /* Slightly wider than login form */
            padding: 30px 40px;
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
        }
        
        .form-header {
            margin-bottom: 25px;
            text-align: center;
        }
        
        .form-title {
            font-size: 24px;
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 8px;
        }
        
        .form-subtitle {
            color: var(--text-secondary);
            font-size: 14px;
        }
        
        .error-alert {
            background-color: rgba(235, 87, 87, 0.1);
            color: var(--error-color);
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .form-group {
            margin-bottom: 20px;
            position: relative;
        }
        
        .form-control {
            width: 100%;
            padding: 12px 15px 12px 40px;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s;
            color: var(--text-primary);
            background-color: var(--bg-secondary);
        }
        
        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(77, 171, 247, 0.1);
            outline: none;
            background-color: white;
        }
        
        .form-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-secondary);
        }
        
        .password-toggle {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: var(--text-secondary);
            cursor: pointer;
        }
        
        .password-requirements {
            margin-top: -12px;
            margin-bottom: 20px;
            background-color: var(--bg-secondary);
            border-radius: 0 0 8px 8px;
            padding: 12px 15px;
            font-size: 12px;
            border: 1px solid #e2e8f0;
            border-top: none;
            display: none;
        }
        
        .requirement {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 6px;
            color: var(--text-secondary);
        }
        
        .requirement:last-child {
            margin-bottom: 0;
        }
        
        .requirement i {
            font-size: 10px;
        }
        
        .valid {
            color: var(--success-color);
        }
        
        .invalid {
            color: var(--error-color);
        }
        
        .btn-register {
            width: 100%;
            padding: 12px;
            background-color: var(--primary-color);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            margin-top: 5px;
        }
        
        .btn-register:hover {
            background-color: var(--primary-dark);
        }
        
        .form-footer {
            margin-top: 25px;
            display: flex;
            justify-content: center;
        }
        
        .form-link {
            color: var(--primary-color);
            text-decoration: none;
            font-size: 13px;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .form-link:hover {
            color: var(--primary-dark);
            text-decoration: underline;
        }
        
        .validation-message {
            color: var(--error-color);
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }
        
        /* Responsive styles */
        @media (min-width: 992px) {
            .brand-side {
                display: block;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <!-- Brand Side (hidden on mobile) -->
        <div class="brand-side">
            <div class="brand-graphic"></div>
            <div class="brand-side-content">
                <div class="brand-logo">
                    <i class="fas fa-heartbeat"></i> Healthcare System
                </div>
                <div class="brand-quote">
                    Streamlined medical management for better patient care.
                </div>
            </div>
        </div>
        
        <!-- Form Side -->
        <div class="form-side">
            <div class="register-form-container">
                <div class="form-header">
                    <h1 class="form-title">Create Account</h1>
                    <p class="form-subtitle">Join our healthcare platform</p>
                </div>
                
                <% 
                    String msg = (String)getServletContext().getAttribute("invalid");
                    if(msg!=null) {
                %>
                <div class="error-alert">
                    <i class="fas fa-exclamation-circle"></i>
                    <span><%= msg %></span>
                </div>
                <% 
                    getServletContext().removeAttribute("invalid");
                    }
                %>
                
                <form id="registrationForm" action="${pageContext.request.contextPath}/Register" method="Post" novalidate>
                    <div class="form-group">
                        <i class="fas fa-user form-icon"></i>
                        <input type="text" id="username" class="form-control" placeholder="Username" name="user" required>
                        <div id="usernameError" class="validation-message">Please enter a valid username (3-20 characters)</div>
                    </div>
                    
                    <div class="form-group">
                        <i class="fas fa-lock form-icon"></i>
                        <input type="password" id="password" class="form-control" placeholder="Password" name="password" required>
                        <button type="button" class="password-toggle" id="togglePassword">
                            <i class="fas fa-eye"></i>
                        </button>
                        <div id="passwordError" class="validation-message">Please enter a valid password</div>
                    </div>
                    
                    <div class="password-requirements" id="passwordRequirements">
                        <div class="requirement" id="length"><i class="fas fa-circle"></i> 8+ characters</div>
                        <div class="requirement" id="uppercase"><i class="fas fa-circle"></i> At least one uppercase letter</div>
                        <div class="requirement" id="lowercase"><i class="fas fa-circle"></i> At least one lowercase letter</div>
                        <div class="requirement" id="number"><i class="fas fa-circle"></i> At least one number</div>
                        <div class="requirement" id="special"><i class="fas fa-circle"></i> At least one special character</div>
                    </div>
                    
                    <div class="form-group">
                        <i class="fas fa-lock form-icon"></i>
                        <input type="password" id="confirmPassword" class="form-control" placeholder="Confirm Password" name="confirmPassword" required>
                        <button type="button" class="password-toggle" id="toggleConfirmPassword">
                            <i class="fas fa-eye"></i>
                        </button>
                        <div id="confirmPasswordError" class="validation-message">Passwords do not match</div>
                    </div>
                    
                    <button type="submit" class="btn-register">
                        <i class="fas fa-user-plus"></i> Create Account
                    </button>
                </form>
                
                <div class="form-footer">
                    <a href="${pageContext.request.contextPath}/Login.jsp" class="form-link">
                        <i class="fas fa-sign-in-alt"></i> Already have an account? Login here
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Toggle password visibility for password field
            const togglePassword = document.getElementById('togglePassword');
            const passwordInput = document.getElementById('password');
            
            togglePassword.addEventListener('click', function() {
                const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                passwordInput.setAttribute('type', type);
                
                // Toggle eye icon
                const eyeIcon = this.querySelector('i');
                eyeIcon.classList.toggle('fa-eye');
                eyeIcon.classList.toggle('fa-eye-slash');
            });
            
            // Toggle password visibility for confirm password field
            const toggleConfirmPassword = document.getElementById('toggleConfirmPassword');
            const confirmPasswordInput = document.getElementById('confirmPassword');
            
            toggleConfirmPassword.addEventListener('click', function() {
                const type = confirmPasswordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                confirmPasswordInput.setAttribute('type', type);
                
                // Toggle eye icon
                const eyeIcon = this.querySelector('i');
                eyeIcon.classList.toggle('fa-eye');
                eyeIcon.classList.toggle('fa-eye-slash');
            });
            
            // Show password requirements when password field is focused
            passwordInput.addEventListener('focus', function() {
                document.getElementById('passwordRequirements').style.display = 'block';
            });
            
            // Hide password requirements when clicking outside
            document.addEventListener('click', function(e) {
                if (e.target !== passwordInput && !document.getElementById('passwordRequirements').contains(e.target)) {
                    document.getElementById('passwordRequirements').style.display = 'none';
                }
            });
            
            // Password validation
            passwordInput.addEventListener('input', function() {
                const password = this.value;
                
                // Check each requirement
                const lengthValid = password.length >= 8;
                const uppercaseValid = /[A-Z]/.test(password);
                const lowercaseValid = /[a-z]/.test(password);
                const numberValid = /[0-9]/.test(password);
                const specialValid = /[!@#$%^&*(),.?":{}|<>]/.test(password);
                
                // Update UI for each requirement
                updateRequirement('length', lengthValid);
                updateRequirement('uppercase', uppercaseValid);
                updateRequirement('lowercase', lowercaseValid);
                updateRequirement('number', numberValid);
                updateRequirement('special', specialValid);
                
                // Show/hide error message
                const errorElement = document.getElementById('passwordError');
                if (lengthValid && uppercaseValid && lowercaseValid && numberValid && specialValid) {
                    errorElement.style.display = 'none';
                } else {
                    errorElement.style.display = 'block';
                }
                
                // Check password match if confirm password has value
                const confirmPassword = confirmPasswordInput.value;
                if (confirmPassword) {
                    checkPasswordMatch();
                }
            });
            
            // Update password requirement UI
            function updateRequirement(id, isValid) {
                const element = document.getElementById(id);
                const icon = element.querySelector('i');
                
                if (isValid) {
                    element.classList.add('valid');
                    element.classList.remove('invalid');
                    icon.classList.replace('fa-circle', 'fa-check-circle');
                } else {
                    element.classList.add('invalid');
                    element.classList.remove('valid');
                    icon.classList.replace('fa-check-circle', 'fa-circle');
                }
            }
            
            // Username validation
            const usernameInput = document.getElementById('username');
            usernameInput.addEventListener('input', function() {
                const username = this.value;
                const isValid = username.length >= 3 && username.length <= 20 && /^[a-zA-Z0-9_]+$/.test(username);
                
                const errorElement = document.getElementById('usernameError');
                if (isValid) {
                    errorElement.style.display = 'none';
                } else {
                    errorElement.style.display = 'block';
                }
            });
            
            // Confirm password validation
            confirmPasswordInput.addEventListener('input', checkPasswordMatch);
            
            function checkPasswordMatch() {
                const password = passwordInput.value;
                const confirmPassword = confirmPasswordInput.value;
                const errorElement = document.getElementById('confirmPasswordError');
                
                if (password === confirmPassword) {
                    errorElement.style.display = 'none';
                } else {
                    errorElement.style.display = 'block';
                }
            }
            
            // Form submission validation
            const registrationForm = document.getElementById('registrationForm');
            registrationForm.addEventListener('submit', function(event) {
                const username = usernameInput.value;
                const password = passwordInput.value;
                const confirmPassword = confirmPasswordInput.value;
                
                const usernameValid = username.length >= 3 && username.length <= 20 && /^[a-zA-Z0-9_]+$/.test(username);
                
                const passwordLengthValid = password.length >= 8;
                const passwordUppercaseValid = /[A-Z]/.test(password);
                const passwordLowercaseValid = /[a-z]/.test(password);
                const passwordNumberValid = /[0-9]/.test(password);
                const passwordSpecialValid = /[!@#$%^&*(),.?":{}|<>]/.test(password);
                const passwordValid = passwordLengthValid && passwordUppercaseValid && passwordLowercaseValid && 
                                    passwordNumberValid && passwordSpecialValid;
                
                const passwordsMatch = password === confirmPassword;
                
                // Show validation errors
                document.getElementById('usernameError').style.display = usernameValid ? 'none' : 'block';
                document.getElementById('passwordError').style.display = passwordValid ? 'none' : 'block';
                document.getElementById('confirmPasswordError').style.display = passwordsMatch ? 'none' : 'block';
                
                // Prevent form submission if there are errors
                if (!usernameValid || !passwordValid || !passwordsMatch) {
                    event.preventDefault();
                }
            });
        });
    </script>
</body>
</html>