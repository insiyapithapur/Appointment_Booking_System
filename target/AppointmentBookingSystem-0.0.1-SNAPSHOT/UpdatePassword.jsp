<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    HttpSession sessionObj = request.getSession(false);
    //String role = (sessionObj != null) ? (String) sessionObj.getAttribute("roleName") : null;

    if (sessionObj == null || sessionObj.getAttribute("email") == null) {
        response.sendRedirect(request.getContextPath() + "/Login.jsp?error=Unauthorized");
        return; 
    }
%>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Reset Password - Hospital Management System</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
  <style>
    :root {
      --primary-color: #4f5e95;
      --secondary-color: #96c8fb;
      --light-bg: #f7f9fc;
      --text-color: #333;
    }
    
    body, html {
      font-family: 'Segoe UI', Arial, sans-serif;
      background-color: var(--light-bg);
      height: 100%;
      margin: 0;
      padding: 0;
      overflow-x: hidden;
    }
    
    .main-container {
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
    
    .login-container {
      flex: 1;
      display: flex;
      flex-direction: column;
      justify-content: center;
      padding: 40px;
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
    
    .password-container input {
      width: 100%;
      padding: 15px;
      border: 1px solid #e0e0e0;
      border-radius: 8px;
      font-size: 16px;
      transition: border-color 0.3s;
    }
    
    .password-container input:focus {
      outline: none;
      border-color: var(--primary-color);
      box-shadow: 0 0 0 2px rgba(79, 94, 149, 0.2);
    }
    
    .password-help {
      position: absolute;
      right: 15px;
      top: 50%;
      transform: translateY(-50%);
      width: 20px;
      height: 20px;
      background-color: #e0e0e0;
      color: #666;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      cursor: pointer;
      font-size: 12px;
    }
    
    .login-button {
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
      margin-bottom: 20px;
    }
    
    .login-button:hover {
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
    
    .redirects {
      display: flex;
      justify-content: center;
      margin-top: 20px;
      color: #666;
      font-size: 14px;
    }
    
    .redirects a {
      color: var(--primary-color);
      text-decoration: none;
      transition: color 0.3s;
    }
    
    .redirects a:hover {
      color: #3d4a75;
      text-decoration: underline;
    }
    
    .validation-message {
      color: #dc3545;
      font-size: 12px;
      margin-top: 5px;
      display: none;
    }
    
    .password-requirements {
      display: none;
      background-color: #f8f9fa;
      border: 1px solid #e0e0e0;
      border-radius: 5px;
      padding: 15px;
      margin-bottom: 20px;
      position: relative;
    }
    
    .requirement {
      display: flex;
      align-items: center;
      margin-bottom: 5px;
      font-size: 13px;
      color: #666;
    }
    
    .requirement i {
      margin-right: 5px;
    }
    
    .valid {
      color: #28a745;
    }
    
    .invalid {
      color: #dc3545;
    }
    
    @media (max-width: 992px) {
      .image-container {
        flex: 0 0 30%;
      }
    }
    
    @media (max-width: 768px) {
      .main-container {
        flex-direction: column;
        height: auto;
      }
      
      .image-container {
        flex: 0 0 200px;
        height: 200px;
        width: 100%;
      }
      
      .login-container {
        padding: 20px;
      }
    }
  </style>
</head>
<body>
  <div class="main-container">
    <div class="image-container">
      <img src="./imgLandingPage.png" alt="Login" class="responsive-image">
    </div>
    <div class="login-container">
      <h1>Reset Password</h1>
      <p class="subtitle"></p>
      <form id="resetForm" action="${pageContext.request.contextPath}/UpdatePassword" method="Post">
      
        <div class="password-requirements" id="passwordRequirements">
          <div class="requirement" id="length"><i class="bi bi-x-circle"></i> 8+ characters</div>
          <div class="requirement" id="uppercase"><i class="bi bi-x-circle"></i> At least one uppercase letter</div>
          <div class="requirement" id="lowercase"><i class="bi bi-x-circle"></i> At least one lowercase letter</div>
          <div class="requirement" id="number"><i class="bi bi-x-circle"></i> At least one number</div>
          <div class="requirement" id="special"><i class="bi bi-x-circle"></i> At least one special character</div>
        </div>
       
        <div class="input-container password-container">
          <input type="password" id="password" placeholder="New Password" name="password">
          <div class="password-help" id="passwordHelp">?</div>
          <div id="passwordError" class="validation-message">Please enter a valid password</div>
        </div>
        
        <div class="input-container password-container">
          <input type="password" id="confirmPassword" placeholder="Confirm" name="confirmPassword">
          <div class="password-help" id="confirmHelp">?</div>
          <div id="confirmPasswordError" class="validation-message">Passwords do not match</div>
        </div>
        
        <button class="login-button" type="submit" value="Submit" id="resetBtn">Reset</button>
        <% 
          String msg = (String)getServletContext().getAttribute("invalid");
          if(msg!=null) {
            out.println("<div class='error-message'>" + msg + "</div>");
            getServletContext().removeAttribute("invalid");
          }
        %>
      </form>

      <div class="redirects">
      </div>
    </div>
  </div>
  
  <script>
    document.addEventListener('DOMContentLoaded', function() {
      const passwordInput = document.getElementById('password');
      const confirmInput = document.getElementById('confirmPassword');
      const passwordHelp = document.getElementById('passwordHelp');
      const confirmHelp = document.getElementById('confirmHelp');
      const passwordError = document.getElementById('passwordError');
      const confirmPasswordError = document.getElementById('confirmPasswordError');
      const resetForm = document.getElementById('resetForm');
      const passwordRequirements = document.getElementById('passwordRequirements');
      
      // Show password requirements when password field is focused
      passwordInput.addEventListener('focus', function() {
        passwordRequirements.style.display = 'block';
      });
      
      // Hide password requirements when clicking outside
      document.addEventListener('click', function(event) {
        if (!passwordInput.contains(event.target) && !passwordRequirements.contains(event.target)) {
          passwordRequirements.style.display = 'none';
        }
      });
      
      // Help tooltips
      passwordHelp.addEventListener('click', function() {
        alert('Password must be at least 8 characters and include uppercase, lowercase, numbers, and special characters.');
      });
      
      confirmHelp.addEventListener('click', function() {
        alert('Please enter your password again to confirm.');
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
        if (lengthValid && uppercaseValid && lowercaseValid && numberValid && specialValid) {
          passwordError.style.display = 'none';
        } else {
          passwordError.style.display = 'block';
        }
        
        // Check password match if confirm password has value
        if (confirmInput.value) {
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
          icon.classList.replace('bi-x-circle', 'bi-check-circle');
        } else {
          element.classList.add('invalid');
          element.classList.remove('valid');
          icon.classList.replace('bi-check-circle', 'bi-x-circle');
        }
      }
      
      // Confirm password validation
      confirmInput.addEventListener('input', checkPasswordMatch);
      
      function checkPasswordMatch() {
        const password = passwordInput.value;
        const confirmPassword = confirmInput.value;
        
        if (password === confirmPassword) {
          confirmPasswordError.style.display = 'none';
        } else {
          confirmPasswordError.style.display = 'block';
        }
      }
      
      // Form submission validation
      resetForm.addEventListener('submit', function(event) {
        const password = passwordInput.value;
        const confirmPassword = confirmInput.value;
        
        const passwordLengthValid = password.length >= 8;
        const passwordUppercaseValid = /[A-Z]/.test(password);
        const passwordLowercaseValid = /[a-z]/.test(password);
        const passwordNumberValid = /[0-9]/.test(password);
        const passwordSpecialValid = /[!@#$%^&*(),.?":{}|<>]/.test(password);
        const passwordValid = passwordLengthValid && passwordUppercaseValid && passwordLowercaseValid && 
                            passwordNumberValid && passwordSpecialValid;
        
        const passwordsMatch = password === confirmPassword;
        
        // Show validation errors
        passwordError.style.display = passwordValid ? 'none' : 'block';
        confirmPasswordError.style.display = passwordsMatch ? 'none' : 'block';
        
        // Prevent form submission if there are errors
        if (!passwordValid || !passwordsMatch) {
          event.preventDefault();
        }
      });
    });
  </script>
</body>
</html>