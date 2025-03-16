package com.training.project.servlet;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.training.project.service.UserService;

@WebServlet("/UserDetails")
public class UserDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserService userService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        userService = new UserService();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Integer userId = (Integer) request.getSession().getAttribute("userId");
        
        if (userId == null) {
            // User not logged in, redirect to login page
            request.setAttribute("errorMessage", "Please login to continue.");
            request.getRequestDispatcher("/Login.jsp").forward(request, response);
            return;
        }
        
        // Get form parameters
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String dobString = request.getParameter("dateOfBirth");
        String gender = request.getParameter("gender");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String bloodGroup = request.getParameter("bloodGroup");
        
        // Validate required fields
        if (firstName == null || firstName.trim().isEmpty() ||
            lastName == null || lastName.trim().isEmpty() ||
            dobString == null || dobString.trim().isEmpty() ||
            gender == null || gender.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            bloodGroup == null || bloodGroup.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "All fields are required.");
            request.getRequestDispatcher("/UserDetails.jsp").forward(request, response);
            return;
        }
        
        try {
            // Parse date of birth
            LocalDate dob = LocalDate.parse(dobString, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            
            // Call service method to save patient details
            List<Object> result = userService.fillUserDetailsForPatient(
                userId, firstName, lastName, dob, gender, email, phone, bloodGroup);
            
            if (result != null && !result.isEmpty()) {
                Integer patientId = (Integer) result.get(1);
                String username = (String) result.get(2);
                String roleName = (String) result.get(3);
                
                
                request.getSession().setAttribute("roleSpecificId", patientId);
			    request.getSession().setAttribute("roleName", roleName);
			    request.getSession().setAttribute("username", username);
			    
                
                // Set success message
                request.setAttribute("successMessage", "Patient details saved successfully.");
                
                // Redirect to dashboard or another appropriate page
                response.sendRedirect(request.getContextPath() + "/Patient/Dashboard");
            } else {
                // Failed to save
                request.setAttribute("errorMessage", "Failed to save patient details. Please try again.");
                request.getRequestDispatcher("/UserDetails.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error processing your request: " + e.getMessage());
            request.getRequestDispatcher("/UserDetails.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // For GET requests, simply show the form
//        request.getRequestDispatcher("/UserDetails.jsp").forward(request, response);
    }
}














































//package com.training.project.servlet;
//
//import java.io.IOException;
//import java.time.LocalDate;
//
//import javax.servlet.RequestDispatcher;
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.HttpServlet;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import javax.servlet.http.HttpSession;
//
//import com.training.project.model.*;
//import com.training.project.service.UserService;
//
///**
// * Servlet implementation class LoginServlet
// */
//@WebServlet("/Patient/EnterPatientDetails")
//public class UserDetailServlet extends HttpServlet {
//    private static final long serialVersionUID = 1L;
//    
//    private UserService userService;
//    
//    public UserDetailServlet() {
//        super();
//        userService = new UserService();
//    }
//    
//    /**
//     * Handle GET requests - redirect to the registration page
//     */
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
//            throws ServletException, IOException {
//        // Simply forward to the register page
//        RequestDispatcher dispatcher = request.getRequestDispatcher("/Register.jsp");
//        dispatcher.forward(request, response);
//    }
//    
//    /**
//     * Handle POST requests - process form submissions
//     */
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
//            throws ServletException, IOException {
//        try {
//        	
//        	
//        	// in register add userId in session
//        	//after that this will call in this add userID to save UserDetails and PatientDetails
//        	//again save rolebasedID and userID(see logic from LoginServlet)
//        	
//        	
//            // Extract user data from form
//            String firstName = request.getParameter("firstName");
//            String lastName = request.getParameter("lastName");
//            String email = request.getParameter("email");
//            String phone = request.getParameter("phone");
//            String dateOfBirth = request.getParameter("dateOfBirth");
//            String gender = request.getParameter("gender");
//            String bloodGroup = request.getParameter("bloodGroup");
//            
//            // Validate required fields
//            if (firstName == null || firstName.trim().isEmpty() ||
//                lastName == null || lastName.trim().isEmpty() ||
//                email == null || email.trim().isEmpty() ||
//                phone == null || phone.trim().isEmpty() ||
//                dateOfBirth == null || dateOfBirth.trim().isEmpty() ||
//                gender == null || gender.trim().isEmpty() ||
//                bloodGroup == null || bloodGroup.trim().isEmpty()) {
//                
//                request.setAttribute("errorMessage", "All fields are required");
//                RequestDispatcher dispatcher = request.getRequestDispatcher("/Register.jsp");
//                dispatcher.forward(request, response);
//                return;
//            }
//            
//            // Create user object
//            UserDetail user = new UserDetail();
//            user.setFirstName(firstName);
//            user.setLastName(lastName);
//            user.setEmail(email);
//            user.setPhoneNumber(phone);
//            user.setDateOfBirth(dateOfBirth);
//            user.setGender(gender);
//           
//            
//            // Save user
//            boolean userSaved = userService.registerUser(user);
//            
//            if (userSaved) {
//                // Set user in session
//                HttpSession session = request.getSession();
//                session.setAttribute("user", user);
//                
//                // Redirect to dashboard or success page
//                response.sendRedirect(request.getContextPath() + "/dashboard");
//            } else {
//                // If user couldn't be saved, go back to form with error
//                request.setAttribute("errorMessage", "Registration failed. Please try again.");
//                RequestDispatcher dispatcher = request.getRequestDispatcher("/register.jsp");
//                dispatcher.forward(request, response);
//            }
//            
//        } catch (Exception e) {
//            // Log the error (in a real application)
//            e.printStackTrace();
//            
//            // Set error message and forward back to registration page
//            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
//            RequestDispatcher dispatcher = request.getRequestDispatcher("/register.jsp");
//            dispatcher.forward(request, response);
//        }
//    }
//}