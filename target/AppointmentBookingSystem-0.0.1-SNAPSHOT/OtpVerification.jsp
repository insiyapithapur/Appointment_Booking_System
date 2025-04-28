<%@page import="org.hibernate.internal.build.AllowSysOut"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Verify OTP - Hospital Management System</title>
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
      <img src="imgLandingPage.png" alt="Login" class="responsive-image">
    </div>
    <div class="login-container">
      <h1>Verify OTP</h1>
      <p class="subtitle"></p>
      <form action="${pageContext.request.contextPath}/VerifyOtp" method="Post">
       
         <div class="input-container password-container">
          <input type="password" placeholder="OTP" name="password">
          <div class="password-help">?</div>
        </div>
        
        <button class="login-button" type="submit" value="Submit">Verify</button>
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
      // Help tooltip functionality
      const passwordHelp = document.querySelector('.password-help');
      
      passwordHelp.addEventListener('click', function() {
        alert('Enter the OTP (One-Time Password) that was sent to your email address.');
      });
    });
  </script>
</body>
</html>