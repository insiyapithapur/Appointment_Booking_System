<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login - Healthcare Management System</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
  <style>
    :root {
      --primary-color: #4f5e95;
      --secondary-color: #3d4a75;
      --light-bg: #f7f9fc;
      --error-color: #dc3545;
      --success-color: #198754;
    }
    
    body, html {
      font-family: 'Segoe UI', Arial, sans-serif;
      background-color: var(--light-bg);
      height: 100%;
      margin: 0;
      padding: 0;
      overflow-x: hidden;
    }
    
    .page-container {
      display: flex;
      height: 100vh;
      width: 100vw;
    }
    
    .image-container {
      flex: 0 0 40%;
      background-color: var(--primary-color);
      overflow: hidden;
      position: relative;
      height: 100vh;
    }
    
    .image-container img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      object-position: center;
    }
    
    .form-container {
      flex: 1;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 20px;
    }
    
    .login-container {
      background-color: white;
      border-radius: 15px;
      box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
      padding: 40px;
      width: 100%;
      max-width: 500px;
    }
    
    h1 {
      color: var(--primary-color);
      margin-bottom: 10px;
      font-weight: 600;
    }
    
    .subtitle {
      color: #666;
      margin-bottom: 30px;
    }
    
    .input-container {
      position: relative;
      margin-bottom: 20px;
    }
    
    .input-container input {
      width: 100%;
      padding: 15px 15px 15px 45px;
      border: 1px solid #ddd;
      border-radius: 8px;
      font-size: 16px;
      transition: all 0.3s;
    }
    
    .input-container input:focus {
      border-color: var(--primary-color);
      box-shadow: 0 0 0 3px rgba(79, 94, 149, 0.2);
      outline: none;
    }
    
    .input-container .icon {
      position: absolute;
      left: 15px;
      top: 50%;
      transform: translateY(-50%);
      color: #999;
    }
    
    .password-container {
      position: relative;
    }
    
    .toggle-password {
      position: absolute;
      right: 15px;
      top: 50%;
      transform: translateY(-50%);
      color: #999;
      cursor: pointer;
      background: none;
      border: none;
    }
    
    .remember-me {
      display: flex;
      align-items: center;
      margin-bottom: 20px;
    }
    
    .remember-me input {
      margin-right: 8px;
    }
    
    .login-button {
      background-color: var(--primary-color);
      color: white;
      padding: 15px;
      border: none;
      border-radius: 8px;
      font-size: 16px;
      font-weight: 600;
      cursor: pointer;
      transition: background-color 0.3s;
      width: 100%;
      margin-bottom: 20px;
    }
    
    .login-button:hover {
      background-color: var(--secondary-color);
    }
    
    .error-message {
      color: var(--error-color);
      background-color: rgba(220, 53, 69, 0.1);
      padding: 12px;
      border-radius: 6px;
      margin-bottom: 20px;
      font-size: 14px;
      text-align: center;
    }
    
    .redirects {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 15px;
      margin-top: 20px;
    }
    
    .redirects a {
      color: var(--primary-color);
      text-decoration: none;
      font-size: 14px;
      transition: color 0.3s;
    }
    
    .redirects a:hover {
      color: var(--secondary-color);
      text-decoration: underline;
    }
    
    .invalid-feedback {
      color: var(--error-color);
      font-size: 12px;
      margin-top: 5px;
      display: none;
    }
    
    input.is-invalid {
      border-color: var(--error-color);
    }
    
    input.is-invalid + .invalid-feedback {
      display: block;
    }
    
    @media (max-width: 992px) {
      .image-container {
        flex: 0 0 30%;
      }
    }
    
    @media (max-width: 768px) {
      .page-container {
        flex-direction: column;
        height: auto;
      }
      
      .image-container {
        flex: 0 0 200px;
        height: 200px;
        width: 100%;
      }
      
      .form-container {
        padding: 20px;
      }
      
      .login-container {
        padding: 30px;
      }
    }
  </style>
</head>
<body>
  <div class="page-container">
    <div class="image-container">
      <img src="imgLandingPage.png" alt="Healthcare Login">
    </div>
    
    <div class="form-container">
      <div class="login-container">
        <h1>Welcome Back</h1>
        <p class="subtitle">Sign in to your healthcare account</p>
        
        <% 
          String msg = (String)getServletContext().getAttribute("invalid");
          if(msg!=null) {
            out.println("<div class='error-message'><i class='bi bi-exclamation-circle'></i> " + msg + "</div>");
            getServletContext().removeAttribute("invalid");
          }
        %>
        
        <form id="loginForm" action="${pageContext.request.contextPath}/Login" method="POST">
          <div class="input-container">
            <i class="bi bi-person icon"></i>
            <input type="text" id="username" placeholder="Username" name="username" required>
            <div class="invalid-feedback">Please enter your username</div>
          </div>
          
          <div class="input-container password-container">
            <i class="bi bi-lock icon"></i>
            <input type="password" id="password" placeholder="Password" name="password" required>
            <button type="button" class="toggle-password" id="togglePassword">
              <i class="bi bi-eye"></i>
            </button>
            <div class="invalid-feedback">Please enter your password</div>
          </div>
          
          <div class="remember-me">
            <input type="checkbox" id="remember" name="remember">
            <label for="remember">Remember me</label>
          </div>
          
          <button class="login-button" type="submit">
            <i class="bi bi-box-arrow-in-right me-2"></i> Log In
          </button>
        </form>
        
        <div class="redirects">
          <a href="${pageContext.request.contextPath}/forgetPassword.jsp">
            <i class="bi bi-question-circle"></i> Forgot your password?
          </a> 
          <a href="${pageContext.request.contextPath}/Register.jsp">
            <i class="bi bi-person-plus"></i> Don't have an account? Register here
          </a>
        </div>
      </div>
    </div>
  </div>
  
  <script>
    document.addEventListener('DOMContentLoaded', function() {
      // Form validation
      const loginForm = document.getElementById('loginForm');
      const usernameInput = document.getElementById('username');
      const passwordInput = document.getElementById('password');
      const togglePassword = document.getElementById('togglePassword');
      
      // Toggle password visibility
      togglePassword.addEventListener('click', function() {
        const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
        passwordInput.setAttribute('type', type);
        
        // Toggle eye icon
        const eyeIcon = this.querySelector('i');
        eyeIcon.classList.toggle('bi-eye');
        eyeIcon.classList.toggle('bi-eye-slash');
      });
      
      // Form submission validation
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