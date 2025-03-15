package com.training.project.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.training.project.model.Appointment;
import com.training.project.service.AdminService;

@WebServlet("/Admin/Appointments")
public class AdminAppointmentServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private AdminService adminservice;

    @Override
    public void init() throws ServletException {
        super.init();
        System.out.println("Admin Appointments servlet initialized");
        adminservice = new AdminService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Appointment> appointments = adminservice.fetchAppointments();
            request.setAttribute("appointments", appointments);
            request.getRequestDispatcher("/AdminAppointment.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error retrieving appointments: " + e.getMessage());
            e.printStackTrace();
            request.getRequestDispatcher("appointments.jsp").forward(request, response);
        }
    }
}
