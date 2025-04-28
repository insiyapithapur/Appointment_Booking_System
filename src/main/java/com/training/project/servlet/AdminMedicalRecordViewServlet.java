package com.training.project.servlet;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.training.project.model.MedicalRecord;
import com.training.project.service.DoctorService;
import com.training.project.service.PatientService;

@WebServlet("/Admin/ViewMedicalRecord")
public class AdminMedicalRecordViewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private DoctorService doctorService;
    private PatientService patientService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        doctorService = new DoctorService();
        patientService = new PatientService();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // Check if user is logged in
        if (session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }
        
        // Get the appointment ID from the request
        String appointmentIdStr = request.getParameter("appointmentId");
        
        try {
            // Validate the appointment ID
            if (appointmentIdStr == null || appointmentIdStr.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Invalid appointment ID.");
                response.sendRedirect(request.getContextPath() + "/Admin/Dashboard");
                return;
            }
            
            int appointmentId = Integer.parseInt(appointmentIdStr);
            
            // Fetch the medical record for this appointment
            MedicalRecord medicalRecord = patientService.getMedicalRecordByAppointmentId(appointmentId);
            
            if (medicalRecord == null) {
                session.setAttribute("errorMessage", "Medical record not found for this appointment.");
                response.sendRedirect(request.getContextPath() + "/Admin/Dashboard");
                return;
            }
            
            // Set the medical record as a request attribute
            request.setAttribute("medicalRecord", medicalRecord);
            request.setAttribute("appointmentId", appointmentId);
            
            // Forward to the medical record JSP
            RequestDispatcher dispatcher = request.getRequestDispatcher("/AdminMedicalRecordView.jsp");
            dispatcher.forward(request, response);
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid appointment ID format.");
            response.sendRedirect(request.getContextPath() + "/Admin/Dashboard");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Error retrieving medical record: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/Admin/Dashboard");
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}