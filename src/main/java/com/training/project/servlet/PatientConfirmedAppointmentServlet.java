package com.training.project.servlet;

import java.io.IOException;
import java.time.LocalDate;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.training.project.service.PatientService;

@WebServlet("/Patient/ConfirmAppointment")
public class PatientConfirmedAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PatientService patientService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        System.out.println("Patient COnfirmed appointment servlet");
        patientService = new PatientService();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String scheduleId = request.getParameter("scheduleId");
        
        if (scheduleId == null || scheduleId.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/Patient/Doctors");
            return;
        }
        
        // Get information about the selected schedule to display on confirmation page
        int scheduleIdInt = Integer.parseInt(scheduleId);
        System.out.println("scheduleIdInt hdwh"+scheduleIdInt);
        request.setAttribute("scheduleId", scheduleIdInt);
        
        // Forward to confirmation page
        request.getRequestDispatcher("/PatientConfirmedAppointment.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer patientId = (Integer) request.getSession().getAttribute("roleSpecificId");
        System.out.println("patientId session"+patientId);
        if (patientId == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }
        
        String scheduleIdParam = request.getParameter("scheduleId");
        String reasonParam = request.getParameter("reason");
        String appointmentDateParam = request.getParameter("appointmentDate");
        
        if (scheduleIdParam == null || scheduleIdParam.isEmpty()) {
            request.setAttribute("errorMessage", "Schedule information is missing");
            request.getRequestDispatcher("/PatientConfirmedAppointment.jsp").forward(request, response);
            return;
        }
        
        try {
            int scheduleId = Integer.parseInt(scheduleIdParam);
            String reason = (reasonParam != null) ? reasonParam : "General checkup";
            
            // Parse appointment date (use today if not provided)
            LocalDate appointmentDate = (appointmentDateParam != null && !appointmentDateParam.isEmpty()) 
                ? LocalDate.parse(appointmentDateParam) 
                : LocalDate.now();
            
            // Book the appointment
            boolean success = patientService.bookAppointment(patientId, scheduleId, appointmentDate, reason);
            
            if (success) {
                // Redirect to appointments page with success message
                response.sendRedirect(request.getContextPath() + "/Patient/Appointments?success=true");
            } else {
                request.setAttribute("errorMessage", "Failed to book appointment. Please try again.");
                request.getRequestDispatcher("/PatientConfirmedAppointment.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error processing your request: " + e.getMessage());
            request.getRequestDispatcher("/PatientConfirmedAppointment.jsp").forward(request, response);
        }
    }
}