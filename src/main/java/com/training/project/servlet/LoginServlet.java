package com.training.project.servlet;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.training.project.service.UserService;

@WebServlet("/Login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private UserService userService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        System.out.println("Login servlet initialized");
        userService = new UserService();
    }

    public LoginServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/Login.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            response.setContentType("text/html");
            
            // getting parameters from form
            String username = request.getParameter("username").trim();
            String password = request.getParameter("password").trim();
            
            // setting attributes for potentially re-populating the form
            request.setAttribute("username", username);
            request.setAttribute("password", password);
            
            String contextPath = request.getContextPath();
            
            // Use the combined login method
            Map<String, Object> loginResult = userService.loginUser(username, password);
            
            if (loginResult.containsKey("success") && (boolean)loginResult.get("success")) {
                // Login successful
                @SuppressWarnings("unchecked")
                List<Object> userDetails = (List<Object>) loginResult.get("userDetails");
                
                Integer userId = (Integer) userDetails.get(0);
                Integer roleSpecificId = (Integer) userDetails.get(1);
                String roleName = (String) userDetails.get(2);
                String storedUsername = (String) userDetails.get(3);
                
                // Store in session
                request.getSession().setAttribute("userId", userId);
                request.getSession().setAttribute("roleSpecificId", roleSpecificId);
                request.getSession().setAttribute("roleName", roleName);
                request.getSession().setAttribute("username", storedUsername);
                
                String destination = "";
                if ("ADMIN".equalsIgnoreCase(roleName)) {
                    destination = "/Admin/Dashboard";
                } else if ("DOCTOR".equalsIgnoreCase(roleName)) {
                    destination = "/Doctor/Dashboard";
                } else if ("PATIENT".equalsIgnoreCase(roleName)) {
                    destination = "/Patient/Dashboard";
                }
                
                // Use RequestDispatcher to forward the request
                request.getRequestDispatcher(destination).forward(request, response);
                return; // Important to prevent further execution
                
            } else {
                // The login failed - set an appropriate error message based on the error type
                String errorType = (String) loginResult.get("errorType");
                String errorMessage = (String) loginResult.get("errorMessage");
                
                // Set error message in application scope to be displayed in JSP
                getServletContext().setAttribute("invalid", errorMessage);
                getServletContext().setAttribute("errorType", errorType);
                
                // If login status update failed but credentials were valid, we can still proceed with login
                if ("LOGIN_STATUS_UPDATE_FAILED".equals(errorType) && loginResult.containsKey("userDetails")) {
                    // Log warning
                    System.out.println("Warning: Proceeding with login despite failed status update");
                    
                    @SuppressWarnings("unchecked")
                    List<Object> userDetails = (List<Object>) loginResult.get("userDetails");
                    
                    Integer userId = (Integer) userDetails.get(0);
                    Integer roleSpecificId = (Integer) userDetails.get(1);
                    String roleName = (String) userDetails.get(2);
                    String storedUsername = (String) userDetails.get(3);
                    
                    // Store in session
                    request.getSession().setAttribute("userId", userId);
                    request.getSession().setAttribute("roleSpecificId", roleSpecificId);
                    request.getSession().setAttribute("roleName", roleName);
                    request.getSession().setAttribute("username", storedUsername);
                    
                    String destination = "";
                    if ("ADMIN".equalsIgnoreCase(roleName)) {
                        destination = "/Admin/Dashboard";
                    } else if ("DOCTOR".equalsIgnoreCase(roleName)) {
                        destination = "/Doctor/Dashboard";
                    } else if ("PATIENT".equalsIgnoreCase(roleName)) {
                        destination = "/Patient/Dashboard";
                    }
                    
                    // Use RequestDispatcher to forward the request
                    request.getRequestDispatcher(destination).forward(request, response);
                    return; // Important to prevent further execution
                } else {
                    // For other error types, redirect back to login page
                    response.sendRedirect(contextPath + "/Login");
                    return; // Important to prevent further execution
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            getServletContext().setAttribute("invalid", "System error occurred. Please try again later.");
            getServletContext().setAttribute("errorType", "SYSTEM_ERROR");
            response.sendRedirect(request.getContextPath() + "/Login");
            return; // Important to prevent further execution
        }
    }
}