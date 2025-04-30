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

@WebServlet("/Admin/DoctorSchedules")
public class AdminDoctorSchedulesServlet extends HttpServlet {
    
    private AdminService adminService;
    
    @Override
    public void init() throws ServletException {
    	adminService = new AdminService();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String doctorIdParam = request.getParameter("id");
        System.out.println("doctorIdParam "+doctorIdParam);
        
        try {
        	int doctorId = Integer.parseInt(doctorIdParam);
            System.out.println("doctorId"+doctorId);
            
            // Get doctor details
            List<Object[]> doctorDetails = adminService.getDoctorDetailsById(doctorId);
            doctorDetails.forEach(System.out::println);
            
            request.setAttribute("doctor", doctorDetails);
            
            // Get doctor schedules
            List<Object[]> schedules = adminService.getDoctorSchedules(doctorId);
            schedules.forEach(System.out::println);
            request.setAttribute("schedules", schedules);
            
            // Forward to the schedule view page
            request.getRequestDispatcher("/AdminDoctorSchedule.jsp")
                   .forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/Admin/Doctors");
        }
    }
    
    // Add doPost method to handle schedule availability updates
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String scheduleIdParam = request.getParameter("scheduleId");
        String availabilityParam = request.getParameter("availability");
        String doctorIdParam = request.getParameter("doctorId");
        
        try {
            int scheduleId = Integer.parseInt(scheduleIdParam);
            boolean isAvailable = "true".equals(availabilityParam);
            
            // Update schedule availability
            boolean updated = adminService.updateScheduleAvailability(scheduleId, isAvailable);
            
            // Redirect back to the schedules page with a status message
            String redirectUrl = request.getContextPath() + "/Admin/DoctorSchedules?id=" + doctorIdParam;
            if (updated) {
                redirectUrl += "&status=success";
            } else {
                redirectUrl += "&status=error";
            }
            
            response.sendRedirect(redirectUrl);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/Admin/Doctors");
        }
    }
}