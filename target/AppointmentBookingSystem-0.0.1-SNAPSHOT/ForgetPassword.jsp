<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Forgot Password - Hospital Management System</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
  <style>
    :root {
      --primary-color: #4f5e95;
      --secondary-color: #96c8fb;
      --light-bg: #f7f9fc;
      --text-color: #333;
      --error-color: #dc3545;
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
      background-color: var(--secondary-color);
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
    
    .forgot-container {
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
      border: 1px solid #e0e0e0;
      border-radius: 8px;
      font-size: 16px;
      transition: border-color 0.3s;
    }
    
    .input-container input:focus {
      outline: none;
      border-color: var(--primary-color);
      box-shadow: 0 0 0 2px rgba(79, 94, 149, 0.2);
    }
    
    .input-container .icon {
      position: absolute;
      left: 15px;
      top: 50%;
      transform: translateY(-50%);
      color: #999;
    }
    
    .submit-button {
      background-color: var(--primary-color);
      color: white;
      padding: 15px;
      border: none;
      border-radius: 8px;
      width: 100%;
      font-size: 16px;
      font-weight: 500;
      cursor: pointer;
      transition: background-color 0.3s;
      margin-top: 10px;
      margin-bottom: 20px;
    }
    
    .submit-button:hover {
      background-color: #3d4a75;
    }
    
    .error-message {
      color: #dc3545;
      background-color: #f8d7da;
      border: 1px solid #f5c6cb;
      padding: 10px;
      border-radius: 5px;
      margin-bottom: 20px;
      font-size: 14px;
      text-align: center;
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
    
    .redirects {
      display: flex;
      justify-content: center;
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
      color: #3d4a75;
      text-decoration: underline;
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
      
      .forgot-container {
        padding: 30px;
      }
    }
  </style>
</head>
<body>
  <div class="page-container">
    <div class="image-container">
      <img src="./asset/imgLandingPage.png" alt="Healthcare">
    </div>
    <div class="form-container">
      <div class="forgot-container">
        <h1>Forgot Password</h1>
        <p class="subtitle">Enter your username or email to reset your password</p>
        
        <% 
          String msg = (String)getServletContext().getAttribute("invalid");
          if(msg != null) {
            out.println("<div class='error-message'><i class='bi bi-exclamation-circle'></i> " + msg + "</div>");
            getServletContext().removeAttribute("invalid");
          }
        %>
        
        <form id="forgotPasswordForm" action="${pageContext.request.contextPath}/Forget" method="Post" novalidate>
          
          
          <div class="input-container">
            <i class="bi bi-envelope icon"></i>
            <input type="email" id="email" placeholder="Email address" name="email">
            <div class="invalid-feedback">Please enter a valid email address</div>
          </div>
          
          <p class="text-center text-muted small mb-4">Enter  email that is associated with your account</p>
          
          <button class="submit-button" type="submit">
            <i class="bi bi-send me-2"></i> Reset Password
          </button>
        </form>

        <div class="redirects">
        
          <a href="${pageContext.request.contextPath}">
            <i class="bi bi-box-arrow-in-left"></i> Back to Login
          </a>
        </div>
      </div>
    </div>
  </div>

  <script>
    document.addEventListener('DOMContentLoaded', function() {
      const forgotForm = document.getElementById('forgotPasswordForm');
      const usernameInput = document.getElementById('username');
      const emailInput = document.getElementById('email');
      
      // Form submission validation
      forgotForm.addEventListener('submit', function(event) {
        let isValid = false;
        
        // Validate username
        if (usernameInput.value.trim() !== '') {
          usernameInput.classList.remove('is-invalid');
          isValid = true;
        } else {
          usernameInput.classList.remove('is-invalid');
        }
        
        // Validate email if username is empty
        const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (emailInput.value.trim() !== '') {
          if (emailPattern.test(emailInput.value)) {
            emailInput.classList.remove('is-invalid');
            isValid = true;
          } else {
            emailInput.classList.add('is-invalid');
            isValid = false;
          }
        } else {
          emailInput.classList.remove('is-invalid');
        }
        
        // If both fields are empty
        if (usernameInput.value.trim() === '' && emailInput.value.trim() === '') {
          usernameInput.classList.add('is-invalid');
          emailInput.classList.add('is-invalid');
          isValid = false;
        }
        
        if (!isValid) {
          event.preventDefault();
        }
      });
      
      // Remove invalid state on input
      usernameInput.addEventListener('input', function() {
        if (this.value.trim() !== '') {
          this.classList.remove('is-invalid');
          emailInput.classList.remove('is-invalid');
        }
      });
      
      emailInput.addEventListener('input', function() {
        if (this.value.trim() !== '') {
          this.classList.remove('is-invalid');
          usernameInput.classList.remove('is-invalid');
        }
      });
    });
  </script>
</body>
</html>