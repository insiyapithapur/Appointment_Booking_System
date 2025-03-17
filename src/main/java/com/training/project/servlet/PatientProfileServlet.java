package com.training.project.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.training.project.service.UserService;

@WebServlet("/Patient/Profile")
public class PatientProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserService userService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        userService = new UserService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            session.setAttribute("errorMessage", "You must be logged in to view your profile.");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        try {
            // Fetch user profile details
            List<String> profileDetails = userService.GetUserProfileDetails(userId);
            
            if (profileDetails.isEmpty()) {
                session.setAttribute("errorMessage", "Failed to retrieve profile information.");
                response.sendRedirect(request.getContextPath() + "/Patient/Dashboard");
                return;
            }
            
            // Set profile details as request attribute
            request.setAttribute("profileDetails", profileDetails);
            
            // Forward to the profile JSP
            request.getRequestDispatcher("/PatientProfile.jsp").forward(request, response);
            
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Error retrieving profile: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/Patient/Dashboard");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            response.sendRedirect(request.getContextPath() + "/Patient/Profile");
    }
    
}