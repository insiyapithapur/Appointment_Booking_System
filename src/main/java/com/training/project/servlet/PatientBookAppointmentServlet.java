package com.training.project.servlet;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.hibernate.Session;
import org.hibernate.SessionFactory;

import com.training.project.service.PatientService;

@WebServlet("/Patient/BookAppointment")
public class PatientBookAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SessionFactory sessionFactory;
    private PatientService patientService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        System.out.println("Patient Book Appointment servlet initialized");
        patientService = new PatientService(); 
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the doctor ID from the request parameter
        String doctorIdParam = request.getParameter("doctorId");
        
        if (doctorIdParam == null || doctorIdParam.isEmpty()) {
            // Redirect back to doctors page if no doctor ID is provided
            response.sendRedirect(request.getContextPath() + "/Patient/Doctors");
            return;
        }
        
        try {
            int doctorId = Integer.parseInt(doctorIdParam);
            
            // Get schedule details which include doctor info
            List<String> scheduleDetails = patientService.getScheduleDetailsByDoctorId(doctorId);
            
            if (scheduleDetails.isEmpty()) {
                // No details found for this doctor
                response.sendRedirect(request.getContextPath() + "/Patient/Doctors");
                return;
            }
            
            // Extract doctor info from the first item
            String doctorInfo = scheduleDetails.get(0);
            
            // Parse the doctor info string
            String doctorName = doctorInfo.substring(
                doctorInfo.indexOf("Doctor: ") + 8, 
                doctorInfo.indexOf(" | Specialization")
            );
            
            String specialization = doctorInfo.substring(
                doctorInfo.indexOf("Specialization: ") + 15, 
                doctorInfo.indexOf(" | Experience")
            );
            
            String experience = doctorInfo.substring(
                doctorInfo.indexOf("Experience: ") + 12, 
                doctorInfo.indexOf(" years | Degree")
            ) + " years";
            
            String degree = doctorInfo.substring(
                doctorInfo.indexOf("Degree: ") + 8, 
                doctorInfo.indexOf(" | Contact")
            );
            
            String contact = doctorInfo.substring(
                doctorInfo.indexOf("Contact: ") + 9, 
                doctorInfo.indexOf(" | Email")
            );
            
            // Set doctor details in request attributes
            request.setAttribute("doctorId", doctorId);
            request.setAttribute("doctorName", doctorName);
            request.setAttribute("doctorSpecialty", specialization);
            request.setAttribute("doctorExperience", experience);
            request.setAttribute("doctorDegree", degree);
            request.setAttribute("doctorContact", contact);
            
            // Remove the first item (doctor info) and pass only schedule details
            scheduleDetails.remove(0);
            request.setAttribute("schedules", scheduleDetails);
            
            // Forward to the JSP page
            request.getRequestDispatcher("/PatientDoctorSchedule.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            // Invalid doctor ID format
            response.sendRedirect(request.getContextPath() + "/Patient/Doctors");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Simply call doGet to handle both types of requests
        doGet(request, response);
    }
}