package com.training.project.servlet;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
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
        
        // Get filter parameters
        String specializationFilter = request.getParameter("specialization");
        String doctorNameFilter = request.getParameter("doctorName");
        
        // Get all doctors
        List<String> allDoctors = patientService.getDoctorDetails();
        
        // Filter doctors by specialization and/or name
        List<String> filteredDoctors = new ArrayList<>();
        
        // Extract all available specializations for the dropdown
        Set<String> specializations = new HashSet<>();
        
        for (String doctorInfo : allDoctors) {
            String[] doctorParts = doctorInfo.split("\\|");
            if (doctorParts.length >= 3) {
                String doctorName = doctorParts[1].trim();
                String specialty = doctorParts[2].trim();
                
                // Add to specializations list for dropdown
                specializations.add(specialty);
                
                // Check if doctor matches both filters (if provided)
                boolean matchesSpecialty = specializationFilter == null || specializationFilter.isEmpty() || 
                                          specialty.equalsIgnoreCase(specializationFilter);
                
                boolean matchesName = doctorNameFilter == null || doctorNameFilter.isEmpty() || 
                                     doctorName.toLowerCase().contains(doctorNameFilter.toLowerCase());
                
                if (matchesSpecialty && matchesName) {
                    filteredDoctors.add(doctorInfo);
                    System.out.println("doctorInfo "+doctorInfo);
                }
            }
        }
        
        // Set attributes for JSP
        request.setAttribute("doctors", filteredDoctors);
        request.setAttribute("specializations", specializations);
        request.setAttribute("selectedSpecialization", specializationFilter);
        request.setAttribute("doctorNameFilter", doctorNameFilter);
        
        System.out.println("Filtered doctors count: " + filteredDoctors.size());
        System.out.println("Available specializations: " + specializations);
        System.out.println("Doctor name filter: " + (doctorNameFilter != null ? doctorNameFilter : "None"));
        
        // Forward to the find doctor JSP
        request.getRequestDispatcher("/PatientDoctor.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Simply call doGet to handle both types of requests
        doGet(request, response);
    }
}