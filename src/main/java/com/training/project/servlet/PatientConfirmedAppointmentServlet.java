package com.training.project.servlet;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.training.project.service.PatientService;


@WebServlet("/Patient/ConfirmAppointment")
public class PatientConfirmedAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PatientService patientService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        System.out.println("Patient Confirmed appointment servlet");
        patientService = new PatientService();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if this is an AJAX request for available slots
        String fetchSlots = request.getParameter("fetchSlots");
        
        if ("true".equals(fetchSlots)) {
            // This is a request for available slots data
            handleAvailableSlotsRequest(request, response);
            return;
        }
        
        // Original appointment confirmation flow
        String scheduleId = request.getParameter("scheduleId");
        String day = request.getParameter("day");
        
        if (scheduleId == null || scheduleId.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/Patient/Doctors");
            return;
        }
        
        // Get information about the selected schedule to display on confirmation page
        int scheduleIdInt = Integer.parseInt(scheduleId);
        System.out.println("scheduleIdInt hdwh"+scheduleIdInt);
        request.setAttribute("scheduleId", scheduleIdInt);
        request.setAttribute("scheduleDay", day);
        
        // Get doctor ID from schedule ID
        int doctorId = patientService.getDoctorIdByScheduleId(scheduleIdInt); // You need to implement this method
        System.out.println("doctorId "+doctorId);
        request.setAttribute("doctorId", doctorId);
        
        // Get available slots for the next 30 days
        LocalDate startDate = LocalDate.now();
        LocalDate endDate = startDate.plusDays(30);
        List<String> availableSlots = patientService.getAvailableSlots(doctorId, startDate, endDate);
        availableSlots.forEach(System.out::println);
        request.setAttribute("availableSlots", availableSlots);
        
        // Filter slots based on the day of the week
        List<String> filteredSlots = availableSlots.stream()
                .filter(slot -> {
                    // Extract the date from the slot string (assuming format like "Mon, May 05, 2025 | Schedule: 1...")
                    String[] parts = slot.split("\\|");
                    String datePart = parts[0].trim();
                    
                    // Check if the slot's day matches the requested day
                    return datePart.startsWith(day.substring(0, 3));
                })
                .collect(Collectors.toList());
        
        System.out.println("Filtered slots for " + day + ":");
        filteredSlots.forEach(System.out::println);
        
        request.setAttribute("availableSlots", filteredSlots);
        
        // Forward to confirmation page
        System.out.println("123rr");
        try {
            request.getRequestDispatcher("/PatientConfirmedAppointment.jsp").forward(request, response);
            System.out.println("Forward completed");
        } catch (Exception e) {
            System.out.println("Forward failed: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("Error: " + e.getMessage());
            response.flushBuffer();
        }
    }
    
    // New method to handle AJAX requests for available slots
    private void handleAvailableSlotsRequest(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String doctorIdParam = request.getParameter("doctorId");
        
        try {
            int doctorId = Integer.parseInt(doctorIdParam);
            LocalDate startDate = LocalDate.now();
            LocalDate endDate = startDate.plusDays(30);
            
            List<String> availableSlots = patientService.getAvailableSlots(doctorId, startDate, endDate);
            
            // Return as JSON
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            // Build JSON array
            StringBuilder jsonBuilder = new StringBuilder("[");
            for (int i = 0; i < availableSlots.size(); i++) {
                jsonBuilder.append("\"").append(availableSlots.get(i)).append("\"");
                if (i < availableSlots.size() - 1) {
                    jsonBuilder.append(",");
                }
            }
            jsonBuilder.append("]");
            
            response.getWriter().write(jsonBuilder.toString());
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Error: " + e.getMessage());
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      Integer patientId = (Integer) request.getSession().getAttribute("roleSpecificId");
      System.out.println("patientId session"+patientId);
      if (patientId == null) {
          response.sendRedirect(request.getContextPath() + "/Login");
          return;
      }
      
      String scheduleIdParam = request.getParameter("scheduleId");
      String reasonParam = request.getParameter("reason");
      String appointmentDateParam = request.getParameter("appointmentDate");
      
      if (scheduleIdParam == null || scheduleIdParam.isEmpty()) {
          request.setAttribute("errorMessage", "Schedule information is missing");
          request.getRequestDispatcher("/PatientConfirmedAppointment.jsp").forward(request, response);
          return;
      }
      
      try {
          int scheduleId = Integer.parseInt(scheduleIdParam);
          String reason = (reasonParam != null) ? reasonParam : "General checkup";
          
          // Parse appointment date (use today if not provided)
          LocalDate appointmentDate = (appointmentDateParam != null && !appointmentDateParam.isEmpty()) 
              ? LocalDate.parse(appointmentDateParam) 
              : LocalDate.now();
          
          // Book the appointment
          boolean success = patientService.bookAppointment(patientId, scheduleId, appointmentDate, reason);
          
          if (success) {
              // Redirect to appointments page with success message
              response.sendRedirect(request.getContextPath() + "/Patient/Appointments?success=true");
          } else {
              request.setAttribute("errorMessage", "Failed to book appointment. Please try again.");
              request.getRequestDispatcher("/PatientConfirmedAppointment.jsp").forward(request, response);
          }
          
      } catch (Exception e) {
          e.printStackTrace();
          request.setAttribute("errorMessage", "Error processing your request: " + e.getMessage());
          request.getRequestDispatcher("/PatientConfirmedAppointment.jsp").forward(request, response);
      }
  }
}