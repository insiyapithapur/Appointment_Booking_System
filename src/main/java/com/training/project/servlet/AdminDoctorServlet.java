package com.training.project.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.training.project.service.AdminService;

@WebServlet("/Admin/Doctors")
public class AdminDoctorServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AdminService adminService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        System.out.println("Admin  DOCTOR  servlet initialized");
        adminService = new AdminService();
    }

    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Object[]> doctors = adminService.getDoctorDetails();
        
        request.setAttribute("doctors", doctors);
        
        request.getRequestDispatcher("/AdminDoctor.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Simply call doGet to handle both types of requests
        doGet(request, response);
    }
}
