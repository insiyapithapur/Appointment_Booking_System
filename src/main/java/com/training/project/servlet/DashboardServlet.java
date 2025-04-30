package com.training.project.servlet;

import java.io.IOException;
import java.time.LocalDate;
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
import com.training.project.service.DoctorService;
import com.training.project.service.PatientService;

@WebServlet("/Doctor/Dashboard")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private DoctorService doctorService;
    private PatientService patientService;
    
    public DashboardServlet() {
        super();
    }
    
    @Override
    public void init() throws ServletException {
        super.init();
        System.out.println("Dashboard servlet initialized");
        doctorService = new DoctorService();
        patientService = new PatientService();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // Get the logged-in doctor's ID from the session
        Integer doctorId = (Integer) session.getAttribute("roleSpecificId");
        String doctorName = "Dr. "+(String) session.getAttribute("username");
        
        System.out.println("Processing dashboard for doctor ID: " + doctorId);
        if (doctorId == null) {
            // If not logged in, redirect to login page
            response.sendRedirect("Login.jsp");
            return;
        }
        
        // Get today's date
        LocalDate today = LocalDate.now();
        
        // Retrieve upcoming appointments for the doctor
        List<String> appointmentStrings = doctorService.getUpcomingAppointmentsForDoctor(doctorId, today);
        
        // Process appointments for display
        List<AppointmentDisplayData> displayAppointments = processAppointmentStringsForDisplay(appointmentStrings);
        
        // Get dashboard analytics for the doctor
        Map<String, List<Map<String, Object>>> dashboardAnalytics = doctorService.getDashboardSummary(doctorId);
        
        // Process analytics data for easy access in JSP
        Map<String, Object> processedAnalytics = processAnalyticsForDisplay(dashboardAnalytics);
        
        // Set attributes for the JSP
        request.setAttribute("doctorName", doctorName);
        request.setAttribute("appointments", displayAppointments);
        request.setAttribute("analytics", processedAnalytics);
        
        // Forward to the dashboard JSP
        request.getRequestDispatcher("/Dashboard.jsp").forward(request, response);
    }
    
    /**
     * Process the analytics data for easier use in JSP
     * @param dashboardAnalytics The raw analytics data from the service
     * @return Processed analytics map
     */
    private Map<String, Object> processAnalyticsForDisplay(Map<String, List<Map<String, Object>>> dashboardAnalytics) {
        Map<String, Object> processed = new HashMap<>();
        
        try {
            // Process patient analytics
            if (dashboardAnalytics.containsKey("patientAnalytics") && !dashboardAnalytics.get("patientAnalytics").isEmpty()) {
                Map<String, Object> patientData = dashboardAnalytics.get("patientAnalytics").get(0);
                
                // Match the JSP variable names exactly
                processed.put("totalPatients", patientData.get("totalPatients"));
                processed.put("newPatientsThisMonth", patientData.get("newPatientsThisMonth"));
                processed.put("todayPatients", patientData.get("todayPatients"));
            } else {
                // Set defaults if no data available
                processed.put("totalPatients", 0);
                processed.put("newPatientsThisMonth", 0);
                processed.put("todayPatients", 0);
            }
            
            // Process today's appointment analytics
            if (dashboardAnalytics.containsKey("todayAppointmentAnalytics") && !dashboardAnalytics.get("todayAppointmentAnalytics").isEmpty()) {
                Map<String, Object> todayData = dashboardAnalytics.get("todayAppointmentAnalytics").get(0);
                
                // These variable names match what's used in your JSP
                processed.put("todayPendingAppointments", todayData.get("pendingCount"));
                processed.put("todayCompletedAppointments", todayData.get("completedCount"));
                processed.put("todayCancelledAppointments", todayData.get("cancelledCount"));
                processed.put("todayTotalAppointments", todayData.get("totalCount"));
            } else {
                // Set defaults if no data available
                processed.put("todayPendingAppointments", 0);
                processed.put("todayCompletedAppointments", 0);
                processed.put("todayCancelledAppointments", 0);
                processed.put("todayTotalAppointments", 0);
            }
            
            // Process overall appointment analytics
            if (dashboardAnalytics.containsKey("overallAppointmentAnalytics") && !dashboardAnalytics.get("overallAppointmentAnalytics").isEmpty()) {
                Map<String, Object> overallData = dashboardAnalytics.get("overallAppointmentAnalytics").get(0);
                
                // These variable names match what's used in your JSP
                processed.put("overallPendingAppointments", overallData.get("pendingCount"));
                processed.put("overallCompletedAppointments", overallData.get("completedCount"));
                processed.put("overallCancelledAppointments", overallData.get("cancelledCount"));
                processed.put("overallTotalAppointments", overallData.get("totalCount"));
            } else {
                // Set defaults if no data available
                processed.put("overallPendingAppointments", 0);
                processed.put("overallCompletedAppointments", 0);
                processed.put("overallCancelledAppointments", 0);
                processed.put("overallTotalAppointments", 0);
            }
            
            // For debugging purposes
            System.out.println("Processed analytics for JSP:");
            processed.forEach((key, value) -> System.out.println(key + " = " + value));
            
        } catch (Exception e) {
            System.out.println("Error processing analytics data: " + e.getMessage());
            e.printStackTrace();
            
            // Set all values to 0 to prevent null pointer exceptions in JSP
            processed.put("totalPatients", 0);
            processed.put("newPatientsThisMonth", 0);
            processed.put("todayPatients", 0);
            processed.put("todayPendingAppointments", 0);
            processed.put("todayCompletedAppointments", 0);
            processed.put("todayCancelledAppointments", 0);
            processed.put("todayTotalAppointments", 0);
            processed.put("overallPendingAppointments", 0);
            processed.put("overallCompletedAppointments", 0);
            processed.put("overallCancelledAppointments", 0);
            processed.put("overallTotalAppointments", 0);
        }
        
        return processed;
    }
    
    private List<AppointmentDisplayData> processAppointmentStringsForDisplay(List<String> appointmentStrings) {
        List<AppointmentDisplayData> displayData = new ArrayList<>();
        
        // Define colors for avatars
        String[] colors = {
            "#64B5F6", "#81C784", "#E57373", "#FFD54F", "#9575CD", 
            "#4DB6AC", "#F06292", "#A1887F", "#90A4AE", "#7986CB"
        };
        
        Random random = new Random();
        
        for (String appointmentString : appointmentStrings) {
            try {
                // Parse the formatted appointment string
                // Updated format is "ID: %d | Patient: %s | Date: %s | Token: %d | Reason: %s | Status: %s | Contact: %s"
                String[] parts = appointmentString.split(" \\| ");
                
                if (parts.length >= 7) { // Make sure we have all parts including ID
                    AppointmentDisplayData data = new AppointmentDisplayData();
                    
                    // Extract appointment ID
                    String idStr = parts[0].substring(parts[0].indexOf(":") + 1).trim();
                    int appointmentId = Integer.parseInt(idStr);
                    data.setAppointmentId(appointmentId);
                    
                    // Extract patient name
                    String patientName = parts[1].substring(parts[1].indexOf(":") + 1).trim();
                    data.setPatientName(patientName);
                    
                    // Extract appointment date
                    String dateStr = parts[2].substring(parts[2].indexOf(":") + 1).trim();
                    LocalDate appointmentDate = LocalDate.parse(dateStr);
                    data.setAppointmentTime(appointmentDate);
                    
                    // Extract token number
                    String tokenStr = parts[3].substring(parts[3].indexOf(":") + 1).trim();
                    int token = Integer.parseInt(tokenStr);
                    data.setappointmentToken(token);
                    
                    // Extract reason
                    String reason = parts[4].substring(parts[4].indexOf(":") + 1).trim();
                    data.setReason(reason);
                    
                    // Extract status
                    String status = parts[5].substring(parts[5].indexOf(":") + 1).trim();
                    data.setStatus(status);
                    
                    // Extract contact
                    String contact = parts[6].substring(parts[6].indexOf(":") + 1).trim();
                    data.setContactNumber(contact);
                    
                    // Generate initials from patient name
                    String[] nameParts = patientName.split(" ");
                    StringBuilder initials = new StringBuilder();
                    for (String part : nameParts) {
                        if (!part.isEmpty()) {
                            initials.append(part.charAt(0));
                            if (initials.length() >= 2) break; // Only use first two initials
                        }
                    }
                    data.setInitials(initials.toString().toUpperCase());
                    
                    // Assign a random color from the array
                    data.setAvatarColor(colors[random.nextInt(colors.length)]);
                    
                    displayData.add(data);
                }
            } catch (Exception e) {
                System.out.println("Error parsing appointment string: " + appointmentString);
                e.printStackTrace();
            }
        }
        
        return displayData;
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Handle any POST requests if needed
        doGet(request, response);
    }
    
    // Inner class to hold display data for appointments
    public static class AppointmentDisplayData {
        private String patientName;
        private LocalDate appointmentTime;
        private int appointmentId;
        private int appointmentToken;
        private String status;
        private String reason;
        private String contactNumber;
        private String initials;
        private String avatarColor;
        
        public String getPatientName() {
            return patientName;
        }
        
        public void setPatientName(String patientName) {
            this.patientName = patientName;
        }
        
        public String getFormattedDate() {
            if (appointmentTime == null) return "";
            // Format the LocalDate as a string
            return appointmentTime.format(java.time.format.DateTimeFormatter.ofPattern("MMM dd, yyyy"));
        }
        
        public void setAppointmentTime(LocalDate appointmentTime) {
            this.appointmentTime = appointmentTime;
        }
        
        public int getAppointmentId() {
            return appointmentId;
        }
        
        public void setAppointmentId(int appointmentId) {
            this.appointmentId = appointmentId;
        }
        
        public int getappointmentToken() {
            return appointmentToken;
        }
        
        public void setappointmentToken(int appointmentToken) {
            this.appointmentToken = appointmentToken;
        }
        
        public String getStatus() {
            return status;
        }
        
        public void setStatus(String status) {
            this.status = status;
        }
        
        public String getReason() {
            return reason;
        }
        
        public void setReason(String reason) {
            this.reason = reason;
        }
        
        public String getContactNumber() {
            return contactNumber;
        }
        
        public void setContactNumber(String contactNumber) {
            this.contactNumber = contactNumber;
        }
        
        public String getInitials() {
            return initials;
        }
        
        public void setInitials(String initials) {
            this.initials = initials;
        }
        
        public String getAvatarColor() {
            return avatarColor;
        }
        
        public void setAvatarColor(String avatarColor) {
            this.avatarColor = avatarColor;
        }
    }
}