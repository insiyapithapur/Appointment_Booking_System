<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Healthcare Management System</title>
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
            background-image: url('images/LoginPage.jpg'); /* Update path to use images folder */
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
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.5); /* Add text shadow for better readability over image */
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
            background-color: rgba(0, 0, 0, 0.3); /* Slightly lighter overlay to show image better */
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
        
        .login-form-container {
            width: 100%;
            max-width: 400px;
            padding: 30px 40px;
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
        }
        
        .form-header {
            margin-bottom: 30px;
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
        
        .form-check {
            margin-bottom: 20px;
        }
        
        .form-check-input {
            margin-right: 8px;
        }
        
        .form-check-label {
            font-size: 14px;
            color: var(--text-secondary);
        }
        
        .btn-login {
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
        }
        
        .btn-login:hover {
            background-color: var(--primary-dark);
        }
        
        .form-footer {
            margin-top: 25px;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 15px;
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
        
        .invalid-feedback {
            color: var(--error-color);
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }
        
        .is-invalid {
            border-color: var(--error-color);
        }
        
        .is-invalid + .invalid-feedback {
            display: block;
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
            <div class="login-form-container">
                <div class="form-header">
                    <h1 class="form-title">Welcome Back</h1>
                    <p class="form-subtitle">Sign in to your healthcare account</p>
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
                
                <form id="loginForm" action="${pageContext.request.contextPath}/Login" method="POST">
                    <div class="form-group">
                        <i class="fas fa-user form-icon"></i>
                        <input type="text" id="username" class="form-control" placeholder="Username" name="username" required>
                        <div class="invalid-feedback">Please enter your username</div>
                    </div>
                    
                    <div class="form-group">
                        <i class="fas fa-lock form-icon"></i>
                        <input type="password" id="password" class="form-control" placeholder="Password" name="password" required>
                        <button type="button" class="password-toggle" id="togglePassword">
                            <i class="fas fa-eye"></i>
                        </button>
                        <div class="invalid-feedback">Please enter your password</div>
                    </div>
                    
                    <div class="form-check">
                        <input type="checkbox" class="form-check-input" id="remember" name="remember">
                        <label class="form-check-label" for="remember">Remember me</label>
                    </div>
                    
                    <button type="submit" class="btn-login">
                        <i class="fas fa-sign-in-alt"></i> Sign In
                    </button>
                </form>
                
                <div class="form-footer">
                    <a href="${pageContext.request.contextPath}/ForgetPassword.jsp" class="form-link">
                        <i class="fas fa-question-circle"></i> Forgot your password?
                    </a>
                    <a href="${pageContext.request.contextPath}/Register.jsp" class="form-link">
                        <i class="fas fa-user-plus"></i> Don't have an account? Register here
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Toggle password visibility
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
            
            // Form validation
            const loginForm = document.getElementById('loginForm');
            const usernameInput = document.getElementById('username');
            
            loginForm.addEventListener('submit', function(event) {
                let isValid = true;
                
                // Validate username
                if (usernameInput.value.trim() === '') {
                    usernameInput.classList.add('is-invalid');
                    isValid = false;
                } else {
                    usernameInput.classList.remove('is-invalid');
                }
                
                // Validate password
                if (passwordInput.value.trim() === '') {
                    passwordInput.classList.add('is-invalid');
                    isValid = false;
                } else {
                    passwordInput.classList.remove('is-invalid');
                }
                
                if (!isValid) {
                    event.preventDefault();
                }
            });
            
            // Remove invalid state on input
            usernameInput.addEventListener('input', function() {
                if (this.value.trim() !== '') {
                    this.classList.remove('is-invalid');
                }
            });
            
            passwordInput.addEventListener('input', function() {
                if (this.value.trim() !== '') {
                    this.classList.remove('is-invalid');
                }
            });
        });
    </script>
</body>
</html>