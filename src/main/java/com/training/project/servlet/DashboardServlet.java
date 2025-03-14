package com.training.project.servlet;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
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

@WebServlet("/Dashboard")
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
        
//        Integer doctorId = 1;
//        String doctorName = "Insiya_Doc1";
        
        System.out.println("Processing dashboard for doctor ID: " + doctorId);
        if (doctorId == null) {
            // If not logged in, redirect to login page
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Get today's date
        LocalDate today = LocalDate.now();
        
        // Retrieve upcoming appointments for the doctor
        List<String> appointmentStrings = doctorService.getUpcomingAppointmentsForDoctor(doctorId, today);
        
        // Process appointments for display
        List<AppointmentDisplayData> displayAppointments = processAppointmentStringsForDisplay(appointmentStrings);
        
        // Set attributes for the JSP
        request.setAttribute("doctorName", doctorName);
        request.setAttribute("appointments", displayAppointments);
        
        // Forward to the dashboard JSP
        request.getRequestDispatcher("/Dashboard.jsp").forward(request, response);
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
                // Format is "Patient: %s | Date: %s | Token: %d | Reason: %s | Status: %s | Contact: %s"
                String[] parts = appointmentString.split(" \\| ");
                
                if (parts.length >= 6) {
                    AppointmentDisplayData data = new AppointmentDisplayData();
                    
                    // Extract patient name
                    String patientName = parts[0].substring(parts[0].indexOf(":") + 1).trim();
                    data.setPatientName(patientName);
                    
                    // Extract appointment date
                    String dateStr = parts[1].substring(parts[1].indexOf(":") + 1).trim();
                    LocalDate appointmentDate = LocalDate.parse(dateStr);
                    data.setAppointmentTime(appointmentDate);
                    
                    // Extract token number
                    String tokenStr = parts[2].substring(parts[2].indexOf(":") + 1).trim();
                    int token = Integer.parseInt(tokenStr);
                    data.setappointmentToken(token);
                    
                    // Extract reason
                    String reason = parts[3].substring(parts[3].indexOf(":") + 1).trim();
                    data.setReason(reason);
                    
                    // Extract status
                    String status = parts[4].substring(parts[4].indexOf(":") + 1).trim();
                    data.setStatus(status);
                    
                    // Extract contact
                    String contact = parts[5].substring(parts[5].indexOf(":") + 1).trim();
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
    
    private int countPendingAppointments(List<AppointmentDisplayData> appointments) {
        int count = 0;
        for (AppointmentDisplayData appointment : appointments) {
            if ("PENDING".equalsIgnoreCase(appointment.getStatus())) {
                count++;
            }
        }
        return count;
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