package com.training.project.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hibernate.SessionFactory;

import com.training.project.service.AdminService;

@WebServlet("/Admin/Dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SessionFactory sessionFactory;
    private AdminService adminService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        System.out.println("Admin dashboard servlet initialized");
        adminService = new AdminService();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get patient count
        long totalPatients = adminService.getTotalPatientCount();
        
        // Set attributes for the JSP
        request.setAttribute("totalPatients", totalPatients);
        
        // Add doctor counts
        long doctorCount = adminService.getDoctorCount();
        request.setAttribute("doctorCount", doctorCount);
        
        // Add active doctor count
        long activeDoctorCount = adminService.getActiveDoctorCount();
        request.setAttribute("activeDoctorCount", activeDoctorCount);
        
        // Add active doctor details
        List<Object[]> activeDoctors = adminService.getActiveDoctorDetails();
        request.setAttribute("activeDoctors", activeDoctors);
        
        long totalAppointments = adminService.getTotalAppointmentCount();
        request.setAttribute("totalAppointments", totalAppointments);
        
        long totalUsers = adminService.getTotalUserCount();
        request.setAttribute("totalUsers", totalUsers);
        
        // Forward to the dashboard JSP
        request.getRequestDispatcher("/AdminDashboard.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Simply call doGet to handle both types of requests
        doGet(request, response);
    }
}