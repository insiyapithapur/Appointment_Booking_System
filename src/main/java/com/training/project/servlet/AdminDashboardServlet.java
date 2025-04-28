package com.training.project.servlet;

import java.io.IOException;
import java.util.List;
import java.util.Map;
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
        // Get all dashboard data at once
        Map<String, List<Map<String, Object>>> dashboardData = adminService.getDashboardSummary();
        
        if (dashboardData != null && !dashboardData.isEmpty()) {
            // Patient analytics
            if (dashboardData.containsKey("patientAnalytics") && !dashboardData.get("patientAnalytics").isEmpty()) {
                Map<String, Object> patientAnalytics = dashboardData.get("patientAnalytics").get(0);
                request.setAttribute("totalPatients", patientAnalytics.get("totalCount"));
                request.setAttribute("activePatients", patientAnalytics.get("activeCount"));
                request.setAttribute("inactivePatients", patientAnalytics.get("inactiveCount"));
                request.setAttribute("newPatientsThisWeek", patientAnalytics.get("newThisWeek"));
            }
            
            // Doctor analytics
            if (dashboardData.containsKey("doctorAnalytics") && !dashboardData.get("doctorAnalytics").isEmpty()) {
                Map<String, Object> doctorAnalytics = dashboardData.get("doctorAnalytics").get(0);
                request.setAttribute("doctorCount", doctorAnalytics.get("totalCount"));
                request.setAttribute("activeDoctorCount", doctorAnalytics.get("activeCount"));
            }
            
            // Today's active doctors
            if (dashboardData.containsKey("todayActiveDoctors")) {
                request.setAttribute("activeDoctors", dashboardData.get("todayActiveDoctors"));
            }
            
            // Today's appointment analytics
            if (dashboardData.containsKey("todayAppointmentAnalytics") && !dashboardData.get("todayAppointmentAnalytics").isEmpty()) {
                Map<String, Object> todayAppointments = dashboardData.get("todayAppointmentAnalytics").get(0);
                request.setAttribute("todayPendingAppointments", todayAppointments.get("pendingCount"));
                request.setAttribute("todayCompletedAppointments", todayAppointments.get("completedCount"));
                request.setAttribute("todayCancelledAppointments", todayAppointments.get("cancelledCount"));
                request.setAttribute("todayTotalAppointments", todayAppointments.get("totalCount"));
            }
            
            // Overall appointment analytics
            if (dashboardData.containsKey("overallAppointmentAnalytics") && !dashboardData.get("overallAppointmentAnalytics").isEmpty()) {
                Map<String, Object> overallAppointments = dashboardData.get("overallAppointmentAnalytics").get(0);
                request.setAttribute("totalAppointments", overallAppointments.get("totalCount"));
                request.setAttribute("pendingAppointments", overallAppointments.get("pendingCount"));
                request.setAttribute("completedAppointments", overallAppointments.get("completedCount"));
                request.setAttribute("cancelledAppointments", overallAppointments.get("cancelledCount"));
            }
        } 
        
        // Forward to the dashboard JSP
        request.getRequestDispatcher("/AdminDashboard.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Simply call doGet to handle both types of requests
        doGet(request, response);
    }
}