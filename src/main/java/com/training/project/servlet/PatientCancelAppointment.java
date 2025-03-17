package com.training.project.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.training.project.service.PatientService;

@WebServlet("/CancelAppointment")
public class PatientCancelAppointment extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private PatientService patientService;

    public PatientCancelAppointment() {
        super();
        patientService = new PatientService();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
    
    private void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get the appointment ID from the request
        String appointmentIdStr = request.getParameter("id");
        
        // If id parameter is not found, check if it's coming from the modal form
        if (appointmentIdStr == null || appointmentIdStr.isEmpty()) {
            appointmentIdStr = request.getParameter("appointmentId");
        }

        HttpSession session = request.getSession();
        String redirectPath = "Patient/Dashboard"; // Default redirect path

        try {
            // Validate the appointment ID
            if (appointmentIdStr == null || appointmentIdStr.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Invalid appointment ID.");
                response.sendRedirect(redirectPath);
                return;
            }

            int appointmentId = Integer.parseInt(appointmentIdStr);
            
            // Check if there's a specific action parameter (for the modal form)
            String action = request.getParameter("action");
            if (action != null && action.equals("cancelAppointment")) {
                // If coming from the appointments page, change the redirect path
                redirectPath = "Patient/Appointments";
            }

            // Call the service method to update the appointment status to cancelled (status ID = 3)
            boolean isUpdated = patientService.updateAppointmentStatus(appointmentId, 3);

            if (isUpdated) {
                session.setAttribute("successMessage", "Appointment cancelled successfully.");
            } else {
                session.setAttribute("errorMessage", "Failed to cancel appointment. Please try again.");
            }

        } catch (IllegalArgumentException e) {
            session.setAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            session.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
        }

        // Redirect back to the appropriate page
        response.sendRedirect(redirectPath);
    }
}