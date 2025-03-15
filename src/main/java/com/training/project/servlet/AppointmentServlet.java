package com.training.project.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.training.project.model.Appointment;
import com.training.project.model.Patient;
import com.training.project.model.User;
import com.training.project.service.DoctorService;
import com.training.project.service.UserService;

/**
 * Servlet to handle appointments display
 */
@WebServlet("/Doctor/Appointment")
public class AppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private DoctorService doctorService;
    private UserService userService;
    
    @Override
    public void init() throws ServletException {
        System.out.println("===== Appointments servlet initialized =====");
        doctorService = new DoctorService();
        userService = new UserService();
    }
       
    /**
     * Handles GET requests for displaying appointments
     */
	 // This is a partial code snippet showing what you should modify in your AppointmentServlet
	 // Assuming doctorService.getAppointmentsForDoctor() returns List<String> as shown in your code
	
	 /**
	  * Handles GET requests for displaying appointments
	  */
	 protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	     System.out.println("===== AppointmentServlet doGet method called =====");
	     
	     HttpSession session = request.getSession();
	     
	     Integer doctorId = (Integer) session.getAttribute("roleSpecificId");
	     String doctorName = "Dr. "+(String) session.getAttribute("username");
	     
	     request.setAttribute("doctorName", doctorName);
	     
	     try {
	         // Get appointment details as strings
	         List<String> appointmentDetails = doctorService.getAppointmentsForDoctor(doctorId);
	         
	         // Log the raw appointment details for debugging
	         System.out.println("Raw appointment details:");
	         appointmentDetails.forEach(System.out::println);
	         
	         // Make sure each appointment string has all required fields
	         List<String> formattedAppointments = new ArrayList<>();
	         for (String appointment : appointmentDetails) {
	             // Format each appointment string to ensure it has all required fields
	             // This assumes your service returns data in a certain format
	             // Modify this based on your actual data format
	             formattedAppointments.add(formatAppointmentString(appointment));
	         }
	         
	         // Set the formatted appointments as an attribute for the JSP
	         request.setAttribute("appointmentDetails", formattedAppointments);
	         
	     } catch (Exception e) {
	         e.printStackTrace();
	         request.setAttribute("errorMessage", "Error retrieving appointment data: " + e.getMessage());
	     }
	     
	     // Forward to the JSP
	     request.getRequestDispatcher("/Appointment.jsp").forward(request, response);
	 }

	 /**
	  * Helper method to ensure appointment strings have all required fields
	  */
	 private String formatAppointmentString(String appointmentString) {
	     // This assumes the string already has a certain format, like "Field1: Value1 | Field2: Value2"
	     // Check if the string contains all required fields
	     String[] requiredFields = {"Patient", "Contact", "Date", "Token", "Reason", "Status"};
	     
	     // Create a map to store existing fields
	     Map<String, String> fieldMap = new HashMap<>();
	     
	     // Parse the existing string
	     String[] parts = appointmentString.split("\\|");
	     for (String part : parts) {
	         String[] keyValue = part.trim().split(":", 2);
	         if (keyValue.length >= 2) {
	             fieldMap.put(keyValue[0].trim(), keyValue[1].trim());
	         }
	     }
	     
	     // Build a new string with all required fields
	     StringBuilder formattedAppointment = new StringBuilder();
	     for (String field : requiredFields) {
	         if (formattedAppointment.length() > 0) {
	             formattedAppointment.append(" | ");
	         }
	         formattedAppointment.append(field).append(": ");
	         
	         // Add the value if it exists, otherwise add a placeholder
	         if (fieldMap.containsKey(field)) {
	             formattedAppointment.append(fieldMap.get(field));
	         } else {
	             formattedAppointment.append("N/A");
	         }
	     }
	     
	     return formattedAppointment.toString();
	 }
    
    /**
     * Generate a random color for avatar backgrounds
     */
    private String getRandomColor() {
        String[] colors = {
            "#4CAF50", "#2196F3", "#9C27B0", "#FF9800", "#E91E63",
            "#3F51B5", "#009688", "#FF5722", "#607D8B", "#673AB7"
        };
        
        return colors[new Random().nextInt(colors.length)];
    }
    
    /**
     * Data Transfer Object for appointment display
     */
    public static class AppointmentDisplayDTO {
        private int appointmentId;
        private java.util.Date appointmentDate;
        private java.util.Date startTime;
        private java.util.Date endTime;
        private String status;
        private int tokenNumber;
        private int patientId;
        private String patientName;
        private String patientPhone;
        private String patientGender;
        private String initials;
        private String avatarColor;
        private String appointmentType;
        
        // Getters and setters (remain the same as in previous version)
        public int getAppointmentId() { return appointmentId; }
        public void setAppointmentId(int appointmentId) { this.appointmentId = appointmentId; }
        
        public java.util.Date getAppointmentDate() { return appointmentDate; }
        public void setAppointmentDate(java.util.Date appointmentDate) { this.appointmentDate = appointmentDate; }
        
        public java.util.Date getStartTime() { return startTime; }
        public void setStartTime(java.util.Date startTime) { this.startTime = startTime; }
        
        public java.util.Date getEndTime() { return endTime; }
        public void setEndTime(java.util.Date endTime) { this.endTime = endTime; }
        
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
        
        public int getTokenNumber() { return tokenNumber; }
        public void setTokenNumber(int tokenNumber) { this.tokenNumber = tokenNumber; }
        
        public int getPatientId() { return patientId; }
        public void setPatientId(int patientId) { this.patientId = patientId; }
        
        public String getPatientName() { return patientName; }
        public void setPatientName(String patientName) { this.patientName = patientName; }
        
        public String getPatientPhone() { return patientPhone; }
        public void setPatientPhone(String patientPhone) { this.patientPhone = patientPhone; }
        
        public String getPatientGender() { return patientGender; }
        public void setPatientGender(String patientGender) { this.patientGender = patientGender; }
        
        public String getInitials() { return initials; }
        public void setInitials(String initials) { this.initials = initials; }
        
        public String getAvatarColor() { return avatarColor; }
        public void setAvatarColor(String avatarColor) { this.avatarColor = avatarColor; }
        
        public String getAppointmentType() { return appointmentType; }
        public void setAppointmentType(String appointmentType) { this.appointmentType = appointmentType; }
    }
}