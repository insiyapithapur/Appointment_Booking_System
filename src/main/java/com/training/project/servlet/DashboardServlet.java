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
        System.out.println("bcfusdgciu");
        doctorService = new DoctorService();
        patientService = new PatientService();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // Get the logged-in doctor's ID from the session
        /*Integer doctorId = (Integer) session.getAttribute("doctorId");
        String doctorName = (String) session.getAttribute("doctorName");*/
        Integer doctorId = 2;
        String doctorName = "Insiya_Doc1";
        
        System.out.println("5425421242");
        if (doctorId == null) {
            // If not logged in, redirect to login page
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Get today's date
        LocalDate today = LocalDate.now();
        
        // Retrieve today's appointments for the doctor
        List<Appointment> appointments = doctorService.getUpcomingAppointmentsForDoctor(doctorId, today);
        
        // Process appointments for display
        List<AppointmentDisplayData> displayAppointments = processAppointmentsForDisplay(appointments);
        
        // Count stats
//        int todayAppointments = appointments.size();
//        int pendingConfirmations = countPendingAppointments(appointments);
        int todayAppointments = 4;
        int pendingConfirmations = 5;
        int newPatients = 3; //dummy
        
        // Set attributes for the JSP
        request.setAttribute("doctorName", doctorName);
        request.setAttribute("appointments", displayAppointments);
        request.setAttribute("todayAppointments", todayAppointments);
        request.setAttribute("pendingConfirmations", pendingConfirmations);
        request.setAttribute("newPatients", newPatients);
        
        // Forward to the dashboard JSP
        request.getRequestDispatcher("/Dashboard.jsp").forward(request, response);
    }
    
    private List<AppointmentDisplayData> processAppointmentsForDisplay(List<Appointment> appointments) {
        List<AppointmentDisplayData> displayData = new ArrayList<>();
        
        // Define colors for avatars (you could make this more sophisticated)
        String[] colors = {
            "#64B5F6", "#81C784", "#E57373", "#FFD54F", "#9575CD", 
            "#4DB6AC", "#F06292", "#A1887F", "#90A4AE", "#7986CB"
        };
        
        Random random = new Random();
        
        for (Appointment appointment : appointments) {
            AppointmentDisplayData data = new AppointmentDisplayData();
     
            data.setPatientName("Dummy User"); //dummy
            data.setAppointmentTime(appointment.getAppointmentDate());
            data.setAppointmentId(appointment.getAppointmentId());
            data.setappointmentToken(appointment.getTokenNo());
            data.setStatus(appointment.getStatus().getStatusName());
            
            // Generate initials from patient name
            String[] nameParts = data.getPatientName().split(" ");
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
        
        return displayData;
    }
    
    private int countPendingAppointments(List<Appointment> appointments) {
        int count = 0;
        for (Appointment appointment : appointments) {
            if ("PENDING".equalsIgnoreCase(appointment.getStatus().getStatusName())) {
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