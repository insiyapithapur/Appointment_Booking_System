package com.training.project.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.hibernate.SessionFactory;

import com.training.project.service.DoctorService;

@WebServlet("/Admin/CompleteAppointment")
public class AdminCompleteAppointment extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DoctorService doctorService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        System.out.println("Admin Complete Appointment servlet initialized");
        doctorService = new DoctorService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get appointmentId parameter
        String appointmentIdStr = request.getParameter("appointmentId");
        
        if (appointmentIdStr != null && !appointmentIdStr.isEmpty()) {
            try {
                Integer appointmentId = Integer.parseInt(appointmentIdStr);
                
                // Set the appointmentId in request for the form
                request.setAttribute("appointmentId", appointmentId);
                
                // Forward to the form JSP
                request.getRequestDispatcher("/AdminCompleteAppointment.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "Invalid appointment ID format.");
                response.sendRedirect(request.getContextPath() + "/Admin/Appointments");
            }
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Appointment ID is required.");
            response.sendRedirect(request.getContextPath() + "/Admin/Appointments");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get form parameters
        String appointmentIdStr = request.getParameter("appointmentId");
        String diagnosis = request.getParameter("diagnosis");
        String treatment = request.getParameter("treatment");
        String notes = request.getParameter("notes");
        
        // Validate required fields
        if (appointmentIdStr == null || appointmentIdStr.isEmpty() ||
            diagnosis == null || diagnosis.isEmpty() ||
            treatment == null || treatment.isEmpty()) {
            
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "All required fields must be filled.");
            response.sendRedirect(request.getContextPath() + "/Admin/CompleteAppointment?appointmentId=" + appointmentIdStr);
            return;
        }
        
        try {
            // Parse appointmentId
            Integer appointmentId = Integer.parseInt(appointmentIdStr);
            System.out.println("appointmentId "+appointmentId);
            
            // Add medical record
            boolean success = doctorService.addMedicalRecord(appointmentId, diagnosis, treatment, notes);
            System.out.println("success "+success);
            
            HttpSession session = request.getSession();
            if (success) {
                session.setAttribute("successMessage", "Appointment completed successfully and medical record added.");
            } else {
                session.setAttribute("errorMessage", "Failed to complete appointment. Please try again.");
            }
            
            // Redirect back to appointments
            response.sendRedirect(request.getContextPath() + "/Admin/Appointments");
            
        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Invalid appointment ID format.");
            response.sendRedirect(request.getContextPath() + "/Admin/Appointments");
        } catch (Exception e) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/Admin/Appointments");
        }
    }
}