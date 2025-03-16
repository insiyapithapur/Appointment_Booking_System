<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Register - Appointment Management System</title>
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
    
    input {
      width: 100%;
      padding: 15px;
      border: 1px solid #e0e0e0;
      border-radius: 8px;
      font-size: 16px;
      transition: border-color 0.3s;
    }
    
    input:focus {
      outline: none;
      border-color: var(--primary-color);
      box-shadow: 0 0 0 2px rgba(79, 94, 149, 0.2);
    }
    
    .password-container {
      position: relative;
    }
    
    .password-toggle {
      position: absolute;
      right: 15px;
      top: 50%;
      transform: translateY(-50%);
      color: #666;
      cursor: pointer;
      background: none;
      border: none;
      padding: 0;
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
      margin-top: 10px;
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
    
    .validation-message {
      color: #dc3545;
      font-size: 12px;
      margin-top: 5px;
      display: none;
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
      <img src="./asset/imgLandingPage.png" alt="Healthcare">
    </div>
    <div class="form-container">
      <div class="login-container">
        <h1>Create Account</h1>
        <p class="subtitle">Join our healthcare platform</p>
        
        <form id="registrationForm" action="${pageContext.request.contextPath}/Register" method="Post" novalidate>
          <div class="input-container">
            <input type="text" id="username" placeholder="Username" name="user" required>
            <div id="usernameError" class="validation-message">Please enter a valid username (3-20 characters)</div>
          </div>
          
          <div class="password-container input-container">
            <input type="password" id="password" placeholder="Password" name="password" required>
            <button type="button" class="password-toggle" onclick="togglePasswordVisibility('password')">
              <i class="bi bi-eye-slash"></i>
            </button>
            <div id="passwordError" class="validation-message">Please enter a valid password</div>
          </div>
          
          <div class="password-requirements" id="passwordRequirements">
            <div class="requirement" id="length"><i class="bi bi-x-circle"></i> 8+ characters</div>
            <div class="requirement" id="uppercase"><i class="bi bi-x-circle"></i> At least one uppercase letter</div>
            <div class="requirement" id="lowercase"><i class="bi bi-x-circle"></i> At least one lowercase letter</div>
            <div class="requirement" id="number"><i class="bi bi-x-circle"></i> At least one number</div>
            <div class="requirement" id="special"><i class="bi bi-x-circle"></i> At least one special character</div>
          </div>
          
          <div class="password-container input-container">
            <input type="password" id="confirmPassword" placeholder="Confirm Password" name="confirmPassword" required>
            <button type="button" class="password-toggle" onclick="togglePasswordVisibility('confirmPassword')">
              <i class="bi bi-eye-slash"></i>
            </button>
            <div id="confirmPasswordError" class="validation-message">Passwords do not match</div>
          </div>

          <button class="login-button" type="submit" id="submitBtn">Register</button>
          
          <% 
            String msg = (String)getServletContext().getAttribute("invalid");
            if(msg != null) {
              out.println("<div class='error-message'>" + msg + "</div>");
              getServletContext().removeAttribute("invalid");
            }
          %>
        </form>

        <div class="redirects">
          <a href="${pageContext.request.contextPath}/login.jsp">Already have an account? Login here</a>
        </div>
      </div>
    </div>
  </div>

  <script>
    // Toggle password visibility
    function togglePasswordVisibility(inputId) {
      const passwordInput = document.getElementById(inputId);
      const toggleButton = passwordInput.nextElementSibling;
      const icon = toggleButton.querySelector('i');
      
      if (passwordInput.type === 'password') {
        passwordInput.type = 'text';
        icon.classList.replace('bi-eye-slash', 'bi-eye');
      } else {
        passwordInput.type = 'password';
        icon.classList.replace('bi-eye', 'bi-eye-slash');
      }
    }
    
    // Show password requirements when password field is focused
    document.getElementById('password').addEventListener('focus', function() {
      document.getElementById('passwordRequirements').style.display = 'block';
    });
    
    // Password validation
    document.getElementById('password').addEventListener('input', function() {
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
      const confirmPassword = document.getElementById('confirmPassword').value;
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
        icon.classList.replace('bi-x-circle', 'bi-check-circle');
      } else {
        element.classList.add('invalid');
        element.classList.remove('valid');
        icon.classList.replace('bi-check-circle', 'bi-x-circle');
      }
    }
    
    // Username validation
    document.getElementById('username').addEventListener('input', function() {
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
    document.getElementById('confirmPassword').addEventListener('input', checkPasswordMatch);
    
    function checkPasswordMatch() {
      const password = document.getElementById('password').value;
      const confirmPassword = document.getElementById('confirmPassword').value;
      const errorElement = document.getElementById('confirmPasswordError');
      
      if (password === confirmPassword) {
        errorElement.style.display = 'none';
      } else {
        errorElement.style.display = 'block';
      }
    }
    
    // Form submission validation
    document.getElementById('registrationForm').addEventListener('submit', function(event) {
      const username = document.getElementById('username').value;
      const password = document.getElementById('password').value;
      const confirmPassword = document.getElementById('confirmPassword').value;
      
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
  </script>
</body>
</html>