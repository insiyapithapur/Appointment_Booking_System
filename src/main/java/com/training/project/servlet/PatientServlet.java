package com.training.project.servlet;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.training.project.service.DoctorService;
import com.training.project.service.UserService;

/**
 * Servlet to handle patient list and appointment display
 */
@WebServlet("/Doctor/Patient")
public class PatientServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private DoctorService doctorService;
    private UserService userService;
    
    @Override
    public void init() throws ServletException {
        System.out.println("patient servlet initialized");
        doctorService = new DoctorService();
        userService = new UserService();
    }
       
    /**
     * Handles GET requests for displaying patient list and appointments
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        System.out.println("patient servlet doGet");
        // Check if user is logged in
        // if (session == null || session.getAttribute("userId") == null) {
        //     response.sendRedirect("login.jsp");
        //     return;
        // }
        
        Integer doctorId = (Integer) session.getAttribute("roleSpecificId");
        String doctorName = "Dr. "+(String) session.getAttribute("username");
        
        request.setAttribute("doctorName", doctorName);
        
        try {
            // Get patient data
            List<String> patientInfoList = doctorService.getAllPatients(doctorId);
            List<Object[]> patients = convertToDisplayFormat(patientInfoList);
            
            /*// Get appointment data
            List<String> appointmentInfoList = doctorService.getAppointmentsForDoctor(doctorId);
            List<Object[]> appointments = convertAppointmentsToDisplayFormat(appointmentInfoList);
            
            // Create a map of patient appointments for easy lookup
            Map<String, List<Object[]>> patientAppointments = mapPatientAppointments(appointments);*/
            
            // Set attributes for the JSP
            request.setAttribute("patients", patients);
            /*request.setAttribute("appointments", appointments);
            request.setAttribute("patientAppointments", patientAppointments);*/
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error retrieving data: " + e.getMessage());
        }
        
        // Forward to the JSP
        request.getRequestDispatcher("/Patient.jsp").forward(request, response);
    }

    /**
     * Create a map of patient contact number to their appointments for easy lookup
     */
    private Map<String, List<Object[]>> mapPatientAppointments(List<Object[]> appointments) {
        Map<String, List<Object[]>> patientAppointments = new HashMap<>();
        
        for (Object[] appointment : appointments) {
            String contactNumber = (String) appointment[2];
            
            if (!patientAppointments.containsKey(contactNumber)) {
                patientAppointments.put(contactNumber, new ArrayList<>());
            }
            
            patientAppointments.get(contactNumber).add(appointment);
        }
        
        return patientAppointments;
    }

    /**
     * Convert the String list from getAllPatients to the format expected by the JSP
     * 
     * Each Object[] in the returned list contains:
     * [0] - Blood Type
     * [1] - First Name
     * [2] - Last Name
     * [3] - Patient ID (placeholder - generated sequence)
     * [4] - Age (calculated from DOB if available)
     * [5] - Gender (placeholder)
     * [6] - Phone Number
     * [7] - Email
     */
    private List<Object[]> convertToDisplayFormat(List<String> patientsList) {
        List<Object[]> formattedPatients = new ArrayList<>();
        int id = 1000; // Starting ID for demonstration
        
        for (String patientInfo : patientsList) {
            try {
                // Parse the patient info string
                // Format: "Patient: %s | Contact: %s | Email: %s | Blood Group: %s | DOB: %s"
                String[] parts = patientInfo.split(" \\| ");
                
                if (parts.length >= 5) {
                    // Extract patient name
                    String patientName = parts[0].substring(parts[0].indexOf(":") + 1).trim();
                    String[] nameParts = patientName.split(" ", 2);
                    String firstName = nameParts[0];
                    String lastName = nameParts.length > 1 ? nameParts[1] : "";
                    
                    // Extract contact number
                    String contactNumber = parts[1].substring(parts[1].indexOf(":") + 1).trim();
                    
                    // Extract email
                    String email = parts[2].substring(parts[2].indexOf(":") + 1).trim();
                    
                    // Extract blood group
                    String bloodGroup = parts[3].substring(parts[3].indexOf(":") + 1).trim();
                    
                    // Extract date of birth
                    String dobString = parts[4].substring(parts[4].indexOf(":") + 1).trim();
                    
                    // Calculate age from DOB if possible
                    int age = 30; // Default age
                    if (!dobString.equals("N/A")) {
                        try {
                            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd, yyyy");
                            LocalDate dob = LocalDate.parse(dobString, formatter);
                            LocalDate now = LocalDate.now();
                            age = now.getYear() - dob.getYear();
                            // Adjust age if birthday hasn't occurred yet this year
                            if (now.getMonthValue() < dob.getMonthValue() || 
                                (now.getMonthValue() == dob.getMonthValue() && now.getDayOfMonth() < dob.getDayOfMonth())) {
                                age--;
                            }
                        } catch (Exception e) {
                            System.out.println("Could not parse date: " + dobString);
                        }
                    }
                    
                    // Create an object array with the required fields for the JSP
                    Object[] patientData = new Object[8];
                    patientData[0] = bloodGroup;
                    patientData[1] = firstName;
                    patientData[2] = lastName;
                    patientData[3] = id++; // Placeholder for patient ID
                    patientData[4] = age;
                    patientData[5] = Math.random() > 0.5 ? "Male" : "Female"; // Placeholder for gender
                    patientData[6] = contactNumber;
                    patientData[7] = email;
                    
                    formattedPatients.add(patientData);
                }
            } catch (Exception e) {
                System.err.println("Error parsing patient info: " + e.getMessage());
                e.printStackTrace();
            }
        }
        
        return formattedPatients;
    }
    
    /**
     * Convert the String list from getAppointmentsForDoctor to a display format
     * 
     * Each Object[] in the returned list contains:
     * [0] - Appointment ID
     * [1] - Patient Name
     * [2] - Contact Number
     * [3] - Appointment Date
     * [4] - Token Number
     * [5] - Reason
     * [6] - Status
     */
    private List<Object[]> convertAppointmentsToDisplayFormat(List<String> appointmentsList) {
        List<Object[]> formattedAppointments = new ArrayList<>();
        
        for (String appointmentInfo : appointmentsList) {
            try {
                // Parse the appointment info string
                // Format: "ID: %d | Patient: %s | Contact: %s | Date: %s | Token: %d | Reason: %s | Status: %s"
                String[] parts = appointmentInfo.split(" \\| ");
                
                if (parts.length >= 7) {
                    // Extract appointment ID
                    String idStr = parts[0].substring(parts[0].indexOf(":") + 1).trim();
                    Integer appointmentId = Integer.parseInt(idStr);
                    
                    // Extract patient name
                    String patientName = parts[1].substring(parts[1].indexOf(":") + 1).trim();
                    
                    // Extract contact number
                    String contactNumber = parts[2].substring(parts[2].indexOf(":") + 1).trim();
                    
                    // Extract appointment date
                    String appointmentDate = parts[3].substring(parts[3].indexOf(":") + 1).trim();
                    
                    // Extract token number
                    String tokenStr = parts[4].substring(parts[4].indexOf(":") + 1).trim();
                    Integer tokenNo = Integer.parseInt(tokenStr);
                    
                    // Extract reason
                    String reason = parts[5].substring(parts[5].indexOf(":") + 1).trim();
                    
                    // Extract status
                    String status = parts[6].substring(parts[6].indexOf(":") + 1).trim();
                    
                    // Create an object array with the appointment fields
                    Object[] appointmentData = new Object[7];
                    appointmentData[0] = appointmentId;
                    appointmentData[1] = patientName;
                    appointmentData[2] = contactNumber;
                    appointmentData[3] = appointmentDate;
                    appointmentData[4] = tokenNo;
                    appointmentData[5] = reason;
                    appointmentData[6] = status;
                    
                    formattedAppointments.add(appointmentData);
                }
            } catch (Exception e) {
                System.err.println("Error parsing appointment info: " + e.getMessage());
                e.printStackTrace();
            }
        }
        
        return formattedAppointments;
    }
}