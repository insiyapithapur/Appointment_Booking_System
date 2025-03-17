package com.training.project.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.training.project.model.MedicalRecord;
import com.training.project.service.PatientService;

@WebServlet("/Patient/Appointments")
public class PatientAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PatientService patientService;
    
    @Override
    public void init() throws ServletException {
    	System.out.println("patient appointment servlet");
        super.init();
        patientService = new PatientService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        String action = request.getParameter("action");
        
        if ("viewMedicalRecord".equals(action)) {
            viewMedicalRecord(request, response);
        } else {
            // Default action - list appointments
            listAppointments(request, response);
        }
    }
    
    private void listAppointments(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer patientId = (Integer) session.getAttribute("roleSpecificId");
        System.out.println("patientId patientId"+patientId);
        
        if (patientId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        List<String> appointments = patientService.getPatientAppointmentHistory(patientId);
        System.out.println("appointments servlet"+appointments);
        request.setAttribute("appointments", appointments);
        
        request.getRequestDispatcher("/PatientAppointment.jsp").forward(request, response);
    }
    
    private void viewMedicalRecord(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String appointmentIdStr = request.getParameter("appointmentId");
        
        if (appointmentIdStr == null || appointmentIdStr.isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Appointment ID is required to view a medical record.");
            response.sendRedirect(request.getContextPath() + "/Patient/Appointments");
            return;
        }
        
        try {
            Integer appointmentId = Integer.parseInt(appointmentIdStr);
            MedicalRecord medicalRecord = patientService.getMedicalRecordByAppointmentId(appointmentId);
            System.out.println("medicalRecord "+medicalRecord);
            if (medicalRecord == null) {
                request.getSession().setAttribute("errorMessage", "No medical record found for this appointment.");
                response.sendRedirect(request.getContextPath() + "/Patient/Appointments");
                return;
            }
            
            // Get appointment details for display
            request.setAttribute("medicalRecord", medicalRecord);
            request.setAttribute("appointmentId", appointmentId);
            
            // Forward to the view medical record page
            request.getRequestDispatcher("/PatientMedicalRecordView.jsp")
                   .forward(request, response);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid appointment ID format.");
            response.sendRedirect(request.getContextPath() + "/Patient/Appointments");
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Error retrieving medical record: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/Patient/Appointments");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("cancelAppointment".equals(action)) {
            handleCancelAppointment(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/Patient/Appointments");
        }
    }
    
    private void handleCancelAppointment(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String appointmentIdStr = request.getParameter("appointmentId");
        String newStatusIdStr = request.getParameter("newStatusId");
        
        try {
            int appointmentId = Integer.parseInt(appointmentIdStr);
            int newStatusId = Integer.parseInt(newStatusIdStr); // Should be 3 for cancelled
            
            boolean isUpdated = patientService.updateAppointmentStatus(appointmentId, newStatusId);
            
            if (isUpdated) {
                request.getSession().setAttribute("successMessage", "Appointment successfully cancelled.");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to cancel appointment. Please try again.");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid appointment information.");
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "An error occurred: " + e.getMessage());
        }
        
        // Redirect back to the appointments page
        response.sendRedirect(request.getContextPath() + "/Patient/Appointments");
    }
}