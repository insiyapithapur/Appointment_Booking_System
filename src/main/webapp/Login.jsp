<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login</title>
<link rel="stylesheet" href="style.css">
<style>
  html, body {
    margin: 0 !important;
    padding: 0 !important;
    overflow: hidden !important;
    height: 100% !important;
    width: 100% !important;
  }
</style>
<!-- Force any potential browser caching to refresh -->
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="0">
</head>
<body>
<div class="main-container">
  <div class="image-container">
    <img src="login.jpg" alt="Login" class="responsive-image">
  </div>
  <div class="login-container">
    <h1>Welcome Back</h1>
    <p class="subtitle">Sign in to your account</p>
    <form action="${pageContext.request.contextPath}/Login" method="Post">
      <div class="input-container">
        <input type="text" placeholder="Username" name="username">
      </div>
      <div class="input-container password-container">
        <input type="password" placeholder="Password" name="password">
        <div class="password-help">?</div>
      </div>
      <button class="login-button" type="submit" value="Submit">Login</button>
      <%
      String msg = (String)getServletContext().getAttribute("invalid");
      if(msg!=null) {
        out.println("<div class='error-message'>" + msg + "</div>");
        getServletContext().removeAttribute("invalid");
      }
      %>
    </form>
    <div class="redirects">
      <a href="${pageContext.request.contextPath}/forgetPassword.jsp">Forgot your password?</a>
      <a href="${pageContext.request.contextPath}/register.jsp">Don't have account? Register here</a>
    </div>
  </div>
</div>
</body>
</html>
