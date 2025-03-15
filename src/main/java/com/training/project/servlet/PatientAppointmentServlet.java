package com.training.project.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.training.project.service.PatientService;

@WebServlet("/Patient/Appointments")
public class PatientAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PatientService patientService;

    @Override
    public void init() throws ServletException {
        super.init();
        System.out.println("Patient appointment servlet initialized");
        patientService = new PatientService();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Check if user is logged in
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Integer patientId = (Integer) session.getAttribute("roleSpecificId");
        String action = request.getParameter("action");

        if ("viewMedicalRecord".equals(action)) {
            // Handle view medical record request
            String appointmentIdStr = request.getParameter("appointmentId");

            if (appointmentIdStr != null && !appointmentIdStr.isEmpty()) {
                try {
                    int appointmentId = Integer.parseInt(appointmentIdStr);
                    
                    // Get all appointments
                    List<String> allAppointments = patientService.getPatientAppointmentHistory(patientId);
                    
                    // Find the specific appointment by ID
                    String selectedAppointment = null;
                    for (String appt : allAppointments) {
                        if (appt.startsWith("ID: " + appointmentId + " |")) {
                            selectedAppointment = appt;
                            break;
                        }
                    }

                    if (selectedAppointment != null) {
                        request.setAttribute("appointmentDetail", selectedAppointment);
                        request.getRequestDispatcher("/PatientMedicalRecordView.jsp").forward(request, response);
                        return;
                    } else {
                        request.setAttribute("errorMessage", "Medical record not found or you don't have permission to view it.");
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "Invalid appointment ID.");
                }
            } else {
                request.setAttribute("errorMessage", "Appointment ID is required.");
            }
        }

        // Default: Show all appointments
        List<String> appointmentHistory = patientService.getPatientAppointmentHistory(patientId);
        request.setAttribute("appointments", appointmentHistory);

        // Forward to the appointments JSP
        request.getRequestDispatcher("/PatientAppointment.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Handle any POST requests if needed
        doGet(request, response);
    }
}