package com.training.project.servlet;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.training.project.service.DoctorService;
import com.training.project.service.UserService;

@WebServlet("/Doctor/Profile")
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private DoctorService doctorService;
    private UserService userService;
    
    @Override
    public void init() throws ServletException {
        System.out.println("===== Profile servlet initialized =====");
        doctorService = new DoctorService();
        userService = new UserService();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("===== ProfileServlet doGet method called =====");
        
        HttpSession session = request.getSession();
        
        
        Integer userId = (Integer) session.getAttribute("userId");
        String doctorName = "Dr. "+(String) session.getAttribute("username");
        
        try {
            // Get user profile data using the service method
            List<String> profileDetails = userService.GetUserProfileDetails(userId);
            
            // Process the profile details into a more usable format for the JSP
            Map<String, String> profileData = processProfileDetails(profileDetails);
            
            // Set attributes for the JSP
            for (Map.Entry<String, String> entry : profileData.entrySet()) {
                request.setAttribute(entry.getKey(), entry.getValue());
            }
            
            request.setAttribute("doctorName", doctorName);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error retrieving profile data: " + e.getMessage());
        }
        
        request.getRequestDispatcher("/Profile.jsp").forward(request, response);
    }

    /**
     * Process the list of profile details into a map for easier access in JSP
     */
    private Map<String, String> processProfileDetails(List<String> profileDetails) {
        Map<String, String> profileData = new HashMap<>();
        
        // Set default values
        profileData.put("userName", "");
        profileData.put("userFullName", "");
        profileData.put("userEmail", "");
        profileData.put("userDOB", "");
        profileData.put("userPhone", "");
        profileData.put("userGender", "");
        profileData.put("doctorSpecialization", "");
        profileData.put("doctorLicenseNumber", "");
        profileData.put("doctorDegree", "");
        
        // Process each detail line
        for (String detail : profileDetails) {
            if (detail.startsWith("Username:")) {
                profileData.put("userName", detail.substring("Username:".length()).trim());
            } else if (detail.startsWith("Name:")) {
                profileData.put("userFullName", detail.substring("Name:".length()).trim());
            } else if (detail.startsWith("Email:")) {
                profileData.put("userEmail", detail.substring("Email:".length()).trim());
            } else if (detail.startsWith("DOB:")) {
                profileData.put("userDOB", detail.substring("DOB:".length()).trim());
            } else if (detail.startsWith("Phone:")) {
                profileData.put("userPhone", detail.substring("Phone:".length()).trim());
            } else if (detail.startsWith("Gender:")) {
                profileData.put("userGender", detail.substring("Gender:".length()).trim());
            } else if (detail.startsWith("Specialization:")) {
                profileData.put("doctorSpecialization", detail.substring("Specialization:".length()).trim());
            } else if (detail.startsWith("License Number:")) {
                profileData.put("doctorLicenseNumber", detail.substring("License Number:".length()).trim());
            } else if (detail.startsWith("Degree:")) {
                profileData.put("doctorDegree", detail.substring("Degree:".length()).trim());
            }
        }
        
        return profileData;
    }
}