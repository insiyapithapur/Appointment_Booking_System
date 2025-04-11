package com.training.project.servlet;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;

import com.training.project.dao.Imp.*;
import com.training.project.model.*;
import com.training.project.service.AdminService;
import com.training.project.util.HibernateUtil;

@WebServlet("/Admin/SaveDoctor")
public class AdminAddDoctorServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    public void init() throws ServletException {
        super.init();
        System.out.println("Admin add doctor servlet initialized");
    }
       
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        
        // Extract form parameters from the AddDoctor.jsp form
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String fullName = firstName + " " + lastName;
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String dateOfBirthStr = request.getParameter("dateOfBirth");
        String gender = request.getParameter("gender");
        
        String licenseNumber = request.getParameter("licenseNumber");
        String experienceStr = request.getParameter("experience");
        String specialization = request.getParameter("specialization");
        String designation = request.getParameter("designation");
        String qualifications = request.getParameter("qualifications");
        
        //Get schedule parameters
        String[] daysOfWeek = request.getParameterValues("dayOfWeek[]");
        String[] startTimes = request.getParameterValues("startTime[]");
        String[] endTimes = request.getParameterValues("endTime[]");
        String[] maxTokens = request.getParameterValues("maxTokens[]");
        String[] isAvailable = request.getParameterValues("isAvailable[]");

        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // Default address (not in the form)
        String address = "Not provided";
        
        // Parse date of birth
        LocalDate dateOfBirth = null;
        if (dateOfBirthStr != null && !dateOfBirthStr.isEmpty()) {
            try {
                dateOfBirth = LocalDate.parse(dateOfBirthStr);
            } catch (DateTimeParseException e) {
                response.getWriter().println("Invalid date format for date of birth");
                return;
            }
        }
        
        // Parse years of experience
        float experience = 0;
        if (experienceStr != null && !experienceStr.isEmpty()) {
            try {
                experience = Float.parseFloat(experienceStr);
            } catch (NumberFormatException e) {
                response.getWriter().println("Invalid format for years of experience");
                return;
            }
        }
        
        SessionFactory sessionFactory = HibernateUtil.getSessionFactory();
        Session session = sessionFactory.openSession();
        Transaction transaction = null;
        
        try {
            // Initialize all DAOs with the same session
            UserDaoImp userDao = new UserDaoImp(session);
            RoleDaoImp roleDao = new RoleDaoImp(session);
            UserDetailDaoImp userDetailDao = new UserDetailDaoImp(session);
            DoctorDaoImp doctorDao = new DoctorDaoImp(session);
            
            // Check if username already exists - no transaction needed for read operation
            User existingUser = userDao.checkUsername(username);
            if (existingUser != null) {
                response.getWriter().println("<div class='alert alert-danger'>Username already exists. Please choose a different username.</div>");
                request.getRequestDispatcher("AdminAddDoctor.jsp").forward(request, response);
                return;
            }
            
            // Get the doctor role (assuming role ID 3 is for doctors)
            Role doctorRole = roleDao.findById(3);
            if (doctorRole == null) {
                response.getWriter().println("Doctor role not found in the database");
                return;
            }
            
            // Now begin the transaction for write operations
            transaction = session.beginTransaction();
            
            // Create and save the user entity directly using session
            User doctorUser = new User(username, password, true, doctorRole);
            session.save(doctorUser);
            
            // Create and save user detail
            UserDetail userDetail =new UserDetail(firstName, lastName, dateOfBirth, gender, phone, email, doctorUser);
            //UserDetail userDetail = new UserDetail(fullName, address, dateOfBirth, gender, phone, email, doctorUser);
            session.save(userDetail);
            
            // Create and save doctor
            Doctor doctor = new Doctor(specialization, licenseNumber, experience, qualifications, true, doctorUser);
            session.save(doctor);
            
         // Create and save schedules
            if (daysOfWeek != null && daysOfWeek.length > 0) {
                for (int i = 0; i < daysOfWeek.length; i++) {
                    if (daysOfWeek[i] != null && !daysOfWeek[i].isEmpty()) {
                        Integer dayOfWeek = Integer.parseInt(daysOfWeek[i]);
                        
                        // Parse start time and end time
                        LocalTime startTime = LocalTime.parse(startTimes[i]);
                        LocalTime endTime = LocalTime.parse(endTimes[i]);
                        
                        // Create LocalDateTime objects (using a reference date for storing the time)
                        LocalDateTime startDateTime = LocalDateTime.of(LocalDate.now(), startTime);
                        LocalDateTime endDateTime = LocalDateTime.of(LocalDate.now(), endTime);
                        
                        // Parse max tokens
                        Integer tokens = Integer.parseInt(maxTokens[i]);
                        System.out.println("tokens "+i+" "+tokens);
                        // Parse availability
                        Boolean available = Boolean.parseBoolean(isAvailable[i]);
                        
                        System.out.println("GUDYGDUYAGVD");
                        // Create and save schedule
                        Schedule schedule = new Schedule((dayOfWeek), startDateTime, endDateTime, tokens, available, doctor);
                        session.save(schedule);
                    }
                }
            }

            // Commit the transaction
            transaction.commit();
            
            request.getRequestDispatcher("/Admin/Doctors").forward(request, response);
            
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
            response.getWriter().println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
            request.getRequestDispatcher("AdminAddDoctor.jsp").forward(request, response);
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Redirect GET requests to the add doctor form page
        response.sendRedirect("/AdminAddDoctor.jsp");
    }
}