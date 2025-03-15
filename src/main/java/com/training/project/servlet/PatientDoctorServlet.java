package com.training.project.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.training.project.service.AdminService;
import com.training.project.service.PatientService;

@WebServlet("/Patient/Doctors")
public class PatientDoctorServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private PatientService patientService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        System.out.println("Patient Doctors servlet initialized");
        patientService = new PatientService();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        Integer patientId = (Integer) session.getAttribute("roleSpecificId");
        String patientName = (String) session.getAttribute("username");
        
        // Check if user is logged in
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
//        // Get search parameter if any
//        String searchSpecialization = request.getParameter("specialization");
        List<String> doctorList;
//        
//        if (searchSpecialization != null && !searchSpecialization.trim().isEmpty()) {
//            // If search parameter exists, filter doctors by specialization
//            doctorList = patientService.getDoctorsBySpecialization(searchSpecialization);
//            request.setAttribute("searchTerm", searchSpecialization);
//        } else {
//            // Otherwise get all active doctors
            doctorList = patientService.getDoctorDetails();
            System.out.println("doctorList "+doctorList);
//        }
        
        // Set doctors as request attribute
        request.setAttribute("doctors", doctorList);
        
        // Get all specializations for the filter dropdown
//        List<String> specializations = patientService.getAllSpecializations();
//        request.setAttribute("specializations", specializations);
        
        // Forward to the find doctor JSP
        request.getRequestDispatcher("/PatientDoctor.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Simply call doGet to handle both types of requests
        doGet(request, response);
    }
}
