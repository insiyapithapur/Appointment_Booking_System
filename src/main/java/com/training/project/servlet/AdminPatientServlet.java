package com.training.project.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.training.project.service.AdminService;

@WebServlet("/Admin/Patients")
public class AdminPatientServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AdminService adminService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        System.out.println("Admin Patient servlet initialized");
        adminService = new AdminService();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Object[]> patients = adminService.getPatientDetails();
        request.setAttribute("patients", patients);

        // Forward the request to patientlist.jsp
        request.getRequestDispatcher("/AdminPatient.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Simply call doGet to handle both types of requests
        doGet(request, response);
    }
}
