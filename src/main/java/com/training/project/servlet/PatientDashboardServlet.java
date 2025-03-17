package com.training.project.servlet;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.training.project.service.PatientService;

@WebServlet("/Patient/Dashboard")
public class PatientDashboardServlet  extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private PatientService patientService;
	
	@Override
    public void init() throws ServletException {
        super.init();
        System.out.println("Patient dashboard servlet initialized");
        patientService = new PatientService();
    }
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
	        throws ServletException, IOException {
	    
	    HttpSession session = request.getSession();
	    
	    // Check if user is logged in
	    if (session == null || session.getAttribute("userId") == null) {
	        response.sendRedirect("/Login.jsp");
	        return;
	    }
	    
	    try {
	        Integer patientId = (Integer) session.getAttribute("roleSpecificId");
	        String patientName = (String) session.getAttribute("username");
	        LocalDate today = LocalDate.now();
	        
	        // Get upcoming appointments
	        List<String> upcomingAppointments = patientService.getUpcomingAppointmentsForPatient(patientId, today);
	        
	        // Set appointments as request attribute
	        request.setAttribute("upcomingAppointments", upcomingAppointments);
	        
	        // Forward to the dashboard JSP
	        request.getRequestDispatcher("/PatientDashboard.jsp").forward(request, response);
	    } catch (Exception e) {
	        e.printStackTrace();
	        request.setAttribute("errorMessage", "Error loading dashboard data: " + e.getMessage());
	        request.getRequestDispatcher("/error.jsp").forward(request, response);
	    }
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Handle any POST requests if needed
        doGet(request, response);
    }
}
